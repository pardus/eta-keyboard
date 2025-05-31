/*****************************************************************************
 *   Copyright (C) 2016 by Yunusemre Senturk                                 *
 *   <yunusemre.senturk@pardus.org.tr>                                       *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 *****************************************************************************/
#include "src/xkblibwrapper.h"
#include "logger.h"
#include <QtCore/QTextStream>
#include <QGuiApplication>

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/XKBlib.h>
#include <X11/extensions/XKBrules.h>

XKBLibWrapper::XKBLibWrapper(QObject *parent) :
    QObject(parent)
{
    auto *x11App = qGuiApp->nativeInterface<QNativeInterface::QX11Application>();
    display = x11App->display();
    logger = new Logger(this);
    xkbState = new XkbStateRec();
}

void XKBLibWrapper::setLayout(unsigned int layoutIndex)
{
    if (XkbLockGroup(display, XkbUseCoreKbd, layoutIndex)) {
        XkbGetState( display, XkbUseCoreKbd, xkbState );

    } else {
        logger->log(logger->red_color
                    + "Failed to change layout group to " + QString::number(layoutIndex)
                    + logger->no_color);
    }
}

int XKBLibWrapper::getCurrentLayoutIndex()
{
    XkbGetState( display, XkbUseCoreKbd, xkbState );
    return xkbState->group;
}

QString XKBLibWrapper::getCurrentLayout()
{
    XkbGetState( display, XkbUseCoreKbd, xkbState );
    unsigned int group = xkbState->group;
    return getLayoutName(group);
}

QString XKBLibWrapper::getLayoutName(unsigned int layoutIndex)
{
    QList<LayoutUnit> layoutUnits = getLayoutsList();
    return layoutUnits.at(layoutIndex).toString();
}

QList<LayoutUnit> XKBLibWrapper::getLayoutsList()
{

    XkbConfig xkbConfig;
    QList<LayoutUnit> lus;
    LayoutUnit lu;
    if( getGroupNames( &xkbConfig) ) {
        for(int i=0; i<xkbConfig.layouts.size(); i++) {
            QString layout(xkbConfig.layouts[i]);
            QString variant;
            if( i<xkbConfig.variants.size() &&
                    ! xkbConfig.variants[i].isEmpty() ) {
                variant = xkbConfig.variants[i];
            }
            lu.layout = layout;
            lu.variant = variant;
            lus.append(lu);
        }
    }
    else {
        logger->log(logger->red_color
                    + "Failed to get layout groups from X server"
                    + logger->no_color);
    }
    return lus;
}

QString LayoutUnit::toString() const
{
    if( variant.isEmpty() )
        return layout;

    return layout + "("+variant+")";
}

bool XKBLibWrapper::getGroupNames(XkbConfig* xkbConfig)
{
    Display *display = XOpenDisplay(nullptr);
    static const char* OPTIONS_SEPARATOR = ",";

    Atom real_prop_type;
    int fmt;
    unsigned long nitems, extra_bytes;
    char *prop_data = NULL;
    Status ret;

    Atom rules_atom = XInternAtom(display, _XKB_RF_NAMES_PROP_ATOM, False);

    /* no such atom! */
    if (rules_atom == None) {       /* property cannot exist */
        logger->log(logger->red_color
                    + "Failed to fetch layouts from server: "
                    + "could not find the atom "
                    + _XKB_RF_NAMES_PROP_ATOM
                    + logger->no_color);
        return false;
    }

    ret = XGetWindowProperty(display,
                             DefaultRootWindow(display),
                             rules_atom, 0L, _XKB_RF_NAMES_PROP_MAXLEN,
                             False, XA_STRING, &real_prop_type, &fmt,
                             &nitems, &extra_bytes,
                             (unsigned char **) (void *) &prop_data);

    if (ret != Success) {
        logger->log(logger->red_color
                    + "Failed to fetch layouts from server: "
                    + "Could not get the property"
                    + logger->no_color);
        return false;
    }

    if ((extra_bytes > 0) || (real_prop_type != XA_STRING) || (fmt != 8)) {
        if (prop_data)
            XFree(prop_data);
        logger->log(logger->red_color
                    + "Failed to fetch layouts from server: "
                    + "Wrong property format"
                    + logger->no_color);
        return false;
    }

    QStringList names;
    for(char* p=prop_data; p-prop_data < (long)nitems && p != nullptr;
        p += strlen(p)+1) {
        names.append( p );

    }

    if( names.count() < 4 ) { //{ rules, model, layouts, variants, options }
        XFree(prop_data);
        return false;
    }


    QStringList layouts = names[2].split(OPTIONS_SEPARATOR);
    QStringList variants = names[3].split(OPTIONS_SEPARATOR);

    for(int ii=0; ii<layouts.count(); ii++) {
        xkbConfig->layouts << (layouts[ii] != nullptr ? layouts[ii] : "");
        xkbConfig->variants << (ii < variants.count()
                                && variants[ii] != nullptr ? variants[ii] : "");
    }

    XFree(prop_data);
    return true;
}
