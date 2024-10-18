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
#include "src/adaptor.h"
#include "src/helper.h"
#include "src/xwrapper.h"
#include "src/vkdbusinterface.h"
#include "src/xkblibwrapper.h"
#include "src/settings.h"
#include <QAbstractEventDispatcher>
#include <QString>
#include <QProcess>
#include <QDir>

bool Helper::login = false;
bool Helper::showOnStart = false;
static bool showAtspi = true;

Helper::Helper(QObject *parent):
    QObject (parent)
{
    xw = new XWrapper;
    xw->setHelper(this);
    xkblw = new XKBLibWrapper(this);
    s = new Settings(this);

    if (!isDbusAvailable())
        return;

    // Load Atspi state from QSettings
    QSettings settings(QDir::homePath() + "/.config/eta/eta-keyboard/config.ini", QSettings::IniFormat);
    showAtspi = settings.value("AtspiEnabled", true).toBool();

    QAbstractEventDispatcher::instance()->installNativeEventFilter(xw);
    vkdi = new VkDbusInterface(this);

    connect(vkdi,SIGNAL(hide()),this,SIGNAL(hideCalled()));
    connect(vkdi,SIGNAL(show(bool)),this,SLOT(showSlot(bool)));
    connect(vkdi,SIGNAL(showForce(bool)),this,SLOT(showForceSlot(bool)));
    connect(vkdi,SIGNAL(toggle()),this,SIGNAL(toggleCalled()));
    connect(vkdi,SIGNAL(showPinInput()),this,SIGNAL(showPinInputCalled()));
    connect(vkdi,SIGNAL(hidePinInput()),this,SIGNAL(hidePinInputCalled()));

}

Helper::~Helper()
{
    delete xw;
}

void Helper::showForceSlot(bool password)
{
    if (password) {
        emit passwordDetected();
    } else {
        emit showCalled();
    }
}
void Helper::showSlot(bool password)
{
    if(getEnableAtspi()){
         showForceSlot(password);
    }
}

void Helper::setKeyboardLayout(const QString &langCode, const QString &variant) {
    QStringList args;
    args << "-layout" << langCode;
    if (!variant.isEmpty()) {
        args << "-variant" << variant;
    }
    QProcess::execute("setxkbmap", args);
}

void Helper::setSettings(int color,
                         const QString& layoutType,
                         double scale,
                         unsigned int languageLayoutIndex,
                         double opacity)
{
    s->setSettings(color, layoutType, scale, languageLayoutIndex, opacity);
}

int Helper::getColor() const
{
    return s->getColor();
}

QString Helper::getLayoutType() const
{
    return s->getLayoutType();
}

double Helper::getScale()
{
    return s->getScale();
}

double Helper::getOpacity()
{
    return s->getOpacity();
}

void Helper::saveSettings()
{
    s->saveSettings();
}

int Helper::getCurrentLayoutIndex()
{
    return s->getLanguageLayoutIndex();
}

void Helper::layoutChangedCallback()
{
    emit layoutChanged();
}

QString Helper::getLayoutName(int layoutIndex) const
{
    return xkblw->getLayoutName(layoutIndex);
}

QString Helper::getCurrentLayout() const
{
    return xkblw->getCurrentLayout();
}

bool Helper::isLogin() const
{
   return Helper::login;
}

bool Helper::isDbusAvailable() const
{
   if (getenv("DISABLE_TIF") != NULL)
       return false;
   return (getenv("DBUS_SESSION_BUS_ADDRESS") != NULL);
}

bool Helper::isShowOnStartEnabled() const
{
    if (!isDbusAvailable())
        return true;

    return Helper::showOnStart;
}

QString Helper::layout() const
{
    return Helper::getCurrentLayout();
}

int Helper::getCapslockStatus()
{
    return xw->getCapslockStatus();
}

int Helper::getNumberOfLayouts()
{
    return xw->getNumberOfLayouts();
}

QString Helper::getSymbol(int keycode, int layoutIndex, int keyLevel) const
{
    return xw->getSymbol(keycode,layoutIndex,keyLevel);
}

void Helper::fakeKeyPress( unsigned int code)
{
    xw->fakeKeyPress(code);
}

void Helper::fakeKeyRelease(unsigned int code)
{
    xw->fakeKeyRelease(code);
}

void Helper::setEnableAtspi(bool status)
{
    showAtspi = status;
    // Save Atspi state to QSettings
    QSettings settings(QDir::homePath() + "/.config/eta/eta-keyboard/config.ini", QSettings::IniFormat);
    settings.setValue("AtspiEnabled", showAtspi);
    settings.sync();
}

bool Helper::getEnableAtspi()
{
    return showAtspi;
}

