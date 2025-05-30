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
#include <QMetaObject>
#include "src/helper.h"

VirtualKeyboardInterfaceAdaptor::VirtualKeyboardInterfaceAdaptor
(QObject *parent): QDBusAbstractAdaptor(parent)
{
    setAutoRelaySignals(true);
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::show(bool password)
{
    QMetaObject::invokeMethod(parent(), "showSlot", Q_ARG(bool, password));
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::showForce(bool password)
{
    QMetaObject::invokeMethod(parent(), "showForceSlot", Q_ARG(bool, password));
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::toggle()
{
    QMetaObject::invokeMethod(parent(), "toggleSlot");
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::hide()
{
    QMetaObject::invokeMethod(parent(), "hideSlot");
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::toggleAutoShow()
{
    QMetaObject::invokeMethod(parent(), "toggleAutoShowSlot");
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::showPinInput()
{
    QMetaObject::invokeMethod(parent(), "showPinInputSlot");
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::hidePinInput()
{
    QMetaObject::invokeMethod(parent(), "hidePinInputSlot");
}

Q_NOREPLY void VirtualKeyboardInterfaceAdaptor::setEnableAtspi(bool enabled)
{
    Helper* helper = qobject_cast<Helper*>(parent()->parent());
    if (helper) {
        helper->setEnableAtspi(enabled);
    }
}

bool VirtualKeyboardInterfaceAdaptor::getEnableAtspi()
{
    Helper* helper = qobject_cast<Helper*>(parent()->parent());
    if (helper) {
        return helper->getEnableAtspi();
    }
    return true;
}
