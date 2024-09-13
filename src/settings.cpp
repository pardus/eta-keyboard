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
#include "src/settings.h"
#include <QDir>
#include <QFileInfo>
#include <QSettings>
#include <QVariant>
#include <QString>

Settings::Settings(QObject *parent) :
    QObject(parent),
    m_color(0),
    m_scale(1.0),
    m_opacity(1.0)
{
    configpath = QDir::homePath() + "/.config/eta/virtualkeyboard/config.ini";

    preferences = new QSettings(configpath, QSettings::IniFormat);

    QFileInfo checkConfig(configpath);

    if (checkConfig.exists() && checkConfig.isFile()) {
        preferences->beginGroup("virtualkeyboard");
        m_color = preferences->value("Color").toInt();
        m_layoutType = preferences->value("LayoutType").toString();
        m_scale = preferences->value("Scale").toDouble();
        m_languageLayoutIndex = preferences->value("LanguageLayoutIndex").toUInt();
        m_opacity = preferences->value("Opacity").toDouble();

        preferences->endGroup();
    }
}

void Settings::setSettings(const int color, const QString& layoutType,
                           double scale,
                           unsigned int languageLayoutIndex,
                           double opacity)
{
    this->m_color = color;
    this->m_layoutType = layoutType;
    this->m_scale = scale;
    this->m_languageLayoutIndex = languageLayoutIndex;
    this->m_opacity = opacity;
}

int Settings::getColor() const
{
    return this->m_color;
}

QString Settings::getLayoutType() const
{
    return this->m_layoutType;
}

double Settings::getScale()
{
    return this->m_scale;
}

unsigned int Settings::getLanguageLayoutIndex()
{
    return this->m_languageLayoutIndex;
}

double Settings::getOpacity()
{
    return this->m_opacity;
}

void Settings::saveSettings()
{
    preferences->beginGroup("virtualkeyboard");

    preferences->setValue("Color", this->m_color);
    preferences->setValue("LayoutType", this->m_layoutType);
    preferences->setValue("Scale", this->m_scale);
    preferences->setValue("LanguageLayoutIndex", this->m_languageLayoutIndex);
    preferences->setValue("Opacity", this->m_opacity);

    preferences->endGroup();
    preferences->sync();
}
