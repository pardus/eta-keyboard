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
#include "src/vkdbusinterface.h"
#include "src/adaptor.h"
#include "src/logger.h"
#include <QDBusConnection>

VkDbusInterface::VkDbusInterface(QObject *parent) :
    QObject(parent)
{
    logger = new Logger(this);
    m_adaptor = new VirtualKeyboardInterfaceAdaptor(this);
    QDBusConnection connection = QDBusConnection::sessionBus();
    auto ok = connection.registerObject("/VirtualKeyboard", this);
    if (!ok) {
        logger->log("D-Bus: failed to register object");
        qCritical() << "eta-kbd: D-Bus: failed to register object";
    }
    ok = connection.registerService("org.eta.virtualkeyboard");
    if (!ok) {
        logger->log("D-Bus: failed to register service");
        qCritical() << "eta-kbd: D-Bus: failed to register service";
    }
}

void VkDbusInterface::emitAtspiStateChanged(bool enabled)
{
    m_adaptor->emitAtspiStateChanged(enabled);
}

void VkDbusInterface::showSlot(bool password)
{
    puts("Show");
    emit show(password);
}

void VkDbusInterface::toggleSlot()
{
    emit toggle();
}
void VkDbusInterface::hideSlot()
{
    emit hide();
}

void VkDbusInterface::showForceSlot(bool password)
{
    puts("Force show");
    emit showForce(password);
}
void VkDbusInterface::toggleAutoShowSlot()
{
    emit toggleAutoShow();
}
void VkDbusInterface::showPinInputSlot()
{
    emit showPinInput();
}
void VkDbusInterface::hidePinInputSlot()
{
    emit hidePinInput();
}
