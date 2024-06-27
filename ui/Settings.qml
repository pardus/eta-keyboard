/*****************************************************************************
 *   Copyright (C) 2016 by Hikmet Bas                                        *
 *   <hikmet.bas@pardus.org.tr>                                              *
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
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import eta.helper 1.0

ApplicationWindow {
    flags: Qt.WindowStaysOnBottomHint |
           Qt.FramelessWindowHint |
           Qt.X11BypassWindowManagerHint
    id: settings
    property bool settingsVisible: main.settingsVisible
    property string keyColor
    property int languageIndex: 0
    property int colorIndex: 0
    property bool layout: main.layoutChange
    property bool loaded: main.loaded
    property bool waitFlag : true
    property variant colorsCurrentArr: ["Grey","Green","Blue","Brown","White"]
    property variant colorsTr: ["Gri","Yeşil","Mavi","Kahve","Beyaz"]
    property variant colorsUs: ["Grey","Green","Blue","Brown","White"]
    property variant colorsAra: ["رمادي","أخضر","أزرق","بنى","أبيض"]
    property variant colorsDe: ["Grau", "Grün", "Blau", "Braun", "Weiß"]
    property variant colorsFr: ["Gris", "Vert", "Bleu", "Marron", "Blanc"]
    property var languageData: [
        { text: "tr", flagSrc: "qrc:/ui/Images/flags/tr.svg" },
        { text: "us", flagSrc: "qrc:/ui/Images/flags/us.svg" },
        { text: "de", flagSrc: "qrc:/ui/Images/flags/de.svg" },
        { text: "fr", flagSrc: "qrc:/ui/Images/flags/fr.svg" },
        { text: "ara", flagSrc: "qrc:/ui/Images/flags/ara.svg" }
    ]


    visible: true
    color: main.color
    x: main.x - settings.width + main.spacing
    y: main.y + main.height - settings.height

    function setAndSaveConf(){
        if (main.loaded) {
            main.setAndSave()
        }

    }

    function setLayout(){

        main.releaseAll = !main.releaseAll
        layoutKey.keyText = main.layout
        settings.setAndSaveConf()
    }

    function changeTheme(){


        layoutKey.keyText = main.layout
        if (settings.colorIndex<colorModel.count){
            main.keyPressedColor = colorModel.get(settings.colorIndex).pColor;
            main.keyColor = colorModel.get(settings.colorIndex).kColor;
            main.textColor = colorModel.get(settings.colorIndex).tColor;
            main.activeTextColor = colorModel.get(settings.colorIndex).atColor;
            main.activeTextColor0 =
                    colorModel.get(settings.colorIndex).atColor0;
            main.activeTextColor1 =
                    colorModel.get(settings.colorIndex).atColor1;
            main.activeTextColor2 =
                    colorModel.get(settings.colorIndex).atColor2;
            main.activeTextColor3 =
                    colorModel.get(settings.colorIndex).atColor3;
            main.keyHoverColor = colorModel.get(settings.colorIndex).hColor;
            main.color = colorModel.get(settings.colorIndex).bColor;

            main.updateTheme = !main.updateTheme
           main.themeName = settings.colorIndex

            colorKey.keyText = settings.colorsCurrentArr[settings.colorIndex]


        }
        else {
            settings.colorIndex = 0
            main.keyPressedColor = colorModel.get(settings.colorIndex).pColor;
            main.keyColor = colorModel.get(settings.colorIndex).kColor;
            main.textColor = colorModel.get(settings.colorIndex).tColor;
            main.activeTextColor = colorModel.get(settings.colorIndex).atColor;
            main.activeTextColor0 =
                    colorModel.get(settings.colorIndex).atColor0;
            main.activeTextColor1 =
                    colorModel.get(settings.colorIndex).atColor1;
            main.activeTextColor2 =
                    colorModel.get(settings.colorIndex).atColor2;
            main.activeTextColor3 =
                    colorModel.get(settings.colorIndex).atColor3;
            main.keyHoverColor = colorModel.get(settings.colorIndex).hColor;
            main.color = colorModel.get(settings.colorIndex).bColor;
            main.updateTheme = !main.updateTheme
            main.themeName = settings.colorIndex
            colorKey.keyText = settings.colorsCurrentArr[settings.colorIndex]
        }

        settings.setAndSaveConf()

    }

    function changeLanguageLayout(buttonPressed) {
        if (buttonPressed) {
            settings.languageIndex = (settings.languageIndex + 1) % languageModel.count;
        } else {
            settings.languageIndex = helper.getCurrentLayoutIndex();
        }

        main.languageLayoutIndex = settings.languageIndex;
        console.log("language layout index = ", main.languageLayoutIndex)

        var selectedLang = languageModel.get(settings.languageIndex).text;
        console.log("selected lang = ", selectedLang)

        helper.setKeyboardLayout(selectedLang);

        languageKey.keyText = selectedLang;
        flagImage.source = languageModel.get(settings.languageIndex).flagSrc;

        updateColorsArray();
        settings.setAndSaveConf();
    }

    function updateColorsArray() {
        var keyText = languageModel.get(settings.languageIndex).text;
        if (keyText === "tr") {
            settings.colorsCurrentArr = settings.colorsTr;
        } else if (keyText === "ara") {
            settings.colorsCurrentArr = settings.colorsAra;
        } else if (keyText === "de") {
            settings.colorsCurrentArr = settings.colorsDe;
        } else if (keyText === "fr") {
            settings.colorsCurrentArr = settings.colorsFr;
        } else {
            settings.colorsCurrentArr = settings.colorsUs;
        }
    }

    ListModel {
        id: languageModel
    }

    ListModel {
        id: colorModel
        ListElement {
            text:"Grey"
            kColor:"#585858"
            tColor:"#dddddd"
            atColor:"white"
            atColor0:"white"
            atColor1:"white"
            atColor2:"light green"
            atColor3:"white"
            hColor:"#848484"
            bColor:"#010101"
            pColor: "white"
        }
        ListElement {
            text:"Green"
            kColor:"#2a6f2c"
            tColor:"white"
            atColor:"white"
            atColor0:"white"
            atColor1:"white"
            atColor2:"#f4ff0f"
            atColor3:"white"
            hColor:"#66bb5d"
            bColor:"#010101"
            pColor: "white"
        }
        ListElement {
            text:"Blue"
            kColor:"#0e5b83"
            tColor:"#fbfcfe"
            atColor:"#fbfcfe"
            atColor0:"white"
            atColor1:"white"
            atColor2:"#f4ff0f"
            atColor3:"white"
            hColor:"#3980f4"
            bColor:"#010101"
            pColor: "white"
        }

        ListElement {
            text:"Brown"
            kColor:"#693f27"
            tColor:"#fbfcfe"
            atColor:"#fbfcfe"
            atColor0:"white"
            atColor1:"white"
            atColor2:"#f4ff0f"
            atColor3:"white"
            hColor:"#a07b5e"
            bColor:"#010101"
            pColor: "white"
        }
        ListElement {
            text:"White"
            kColor:"#f9f9f9"
            tColor:"grey"
            atColor:"grey"
            atColor0:"grey"
            atColor1:"grey"
            atColor2:"red"
            atColor3:"grey"
            hColor:"white"
            bColor:"#bbb7b6"
            pColor: "grey"
        }
    }



    Rectangle{
        id: container
        color: main.color

        Column{
            id: col1
            spacing: main.spacing
            anchors{
                top: container.top
                left: container.left
                margins: main.spacing
            }

            Row{
                id: row1
                spacing: main.spacing


                Key{
                    id: transUp
                    leVis4: true
                    keyText: "O"

                    MouseArea {
                        id: ma8
                        anchors.fill: parent

                        onEntered: {
                            transUp.btnHovered()
                        }

                        onExited: {
                            transUp.btnHovered()
                        }

                        onPressed: {
                            transUp.btnPressed()
                        }

                        onPressAndHold: {
                            transUp.btnHold()
                        }

                        onReleased: {
                            transUp.btnReleased()
                        }

                        onClicked: {
                            transUp.btnClicked()
                            if (main.transparency<1) {
                                main.transparency+=0.1
                                settings.opacity = main.transparency

                            }

                            settings.setAndSaveConf()
                        }
                    }
                }

                Key{
                    id: languageKey
                    leVis4: true
                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Image {
                            id: flagImage
                            anchors.centerIn: parent
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            source: languageModel.get(settings.languageIndex).flagSrc
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent

                        onEntered: {
                            languageKey.btnHovered()
                        }

                        onExited: {
                            languageKey.btnHovered()
                        }

                        onPressed: {
                            languageKey.btnPressed()
                            settings.waitFlag = false
                            changeLanguageLayout(true)
                        }

                        onPressAndHold: {
                            languageKey.btnHold()
                        }

                        onReleased: {
                            languageKey.btnReleased()
                            settings.waitFlag = true
                        }

                        onClicked: {
                            languageKey.btnClicked()
                        }
                    }
                }

                Key{
                    id: colorKey
                    leVis4: true

                    MouseArea {
                        id: ma1
                        anchors.fill: parent

                        onEntered: {
                            colorKey.btnHovered()
                        }

                        onExited: {
                            colorKey.btnHovered()
                        }

                        onPressed: {
                            colorKey.btnPressed()
                            settings.colorIndex++
                            changeTheme()
                        }

                        onPressAndHold: {
                            colorKey.btnHold()
                        }

                        onReleased: {
                            colorKey.btnReleased()
                        }

                        onClicked: {

                        }
                    }
                }

                Key{
                    id: layoutKey
                    leVis4: true

                    MouseArea {
                        id: ma2
                        anchors.fill: parent

                        onEntered: {
                            layoutKey.btnHovered()
                        }

                        onExited: {
                            layoutKey.btnHovered()
                        }

                        onPressed: {
                            layoutKey.btnPressed()
                        }

                        onPressAndHold: {
                            layoutKey.btnHold()
                        }

                        onReleased: {
                            layoutKey.btnReleased()
                        }

                        onClicked: {
                            layoutKey.btnClicked()
                            if (main.layout == "Full") {
                                main.layout = "Tablet"
                            }
                            else {
                                main.layout = "Full"
                            }
                            main.symbolMode = false
                            settings.setLayout()
                        }
                    }
                }
            }

            Row{
                id: r2
                spacing: main.spacing

                Key{
                    id: transDown
                    leVis4: true
                    keyText: "o"

                    MouseArea {
                        id: ma7
                        anchors.fill: parent

                        onEntered: {
                            transDown.btnHovered()
                        }

                        onExited: {
                            transDown.btnHovered()
                        }

                        onPressed: {
                            transDown.btnPressed()
                        }

                        onPressAndHold: {
                            transDown.btnHold()
                        }

                        onReleased: {
                            transDown.btnReleased()
                        }

                        onClicked: {
                            transDown.btnClicked()
                            if (main.transparency>0.4) {
                                main.transparency-=0.1
                                settings.opacity = main.transparency
                            }

                            settings.setAndSaveConf()
                        }
                    }
                }

                Key{
                    id: scaleDown
                    leVis4: true
                    keyText: "-"

                    MouseArea {
                        id: ma3
                        anchors.fill: parent

                        onEntered: {
                            scaleDown.btnHovered()
                        }

                        onExited: {
                            scaleDown.btnHovered()
                        }

                        onPressed: {
                            scaleDown.btnPressed()
                        }
                        onPressAndHold: {
                            scaleDown.btnHold()
                        }

                        onReleased: {
                            scaleDown.btnReleased()
                        }

                        onClicked: {
                            scaleDown.btnClicked()
                            if (main.scale>0.5) {
                                main.scale-=0.1
                            }

                            settings.setAndSaveConf()
                        }
                    }
                }

                Key{
                    id: scaleUp
                    leVis4: true
                    keyText: "+"

                    MouseArea {
                        id: ma4
                        anchors.fill: parent

                        onEntered: {
                            scaleUp.btnHovered()
                        }

                        onExited: {
                            scaleUp.btnHovered()
                        }

                        onPressed: {
                            scaleUp.btnPressed()
                        }

                        onPressAndHold: {
                            scaleUp.btnHold()
                        }

                        onReleased: {
                            scaleUp.btnReleased()
                        }

                        onClicked: {
                            scaleDown.btnClicked()
                            if (main.scale<1.5) {
                                main.scale+=0.1
                            }

                            settings.setAndSaveConf()
                        }
                    }
                }

                Key{
                    id: autoShowKey
                    leVis4: true

                    Image {
                        id: autoShowImage
                        anchors.centerIn: parent
                        width: parent.width * 0.8
                        height: parent.height * 0.8
                        source: helper.getEnableAtspi() ? "qrc:/ui/Images/auto-on.png" : "qrc:/ui/Images/auto-off.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: ma6
                        anchors.fill: parent

                        onPressed: {
                            autoShowKey.btnPressed()
                        }

                        onPressAndHold: {
                            autoShowKey.btnHold()
                        }

                        onReleased: {
                            autoShowKey.btnReleased()
                        }

                        onClicked: {
                            autoShowKey.btnClicked()
                            helper.setEnableAtspi(!helper.getEnableAtspi());
                            autoShowImage.source = helper.getEnableAtspi() ? "qrc:/ui/Images/auto-on.png" : "qrc:/ui/Images/auto-off.png";
                            if(helper.getEnableAtspi()){
                                console.log("Atspi enabled");
                            }else {
                                console.log("Atspi disabled");
                            }

                            settings.setAndSaveConf()
                        }
                    }
                }
            }
        }
    }

    NumberAnimation {
        id: showSettings;
        target: settings;
        property: "width";
        to:main.m_settings_width
        duration: 300
        easing.type: Easing.OutQuad
    }

    NumberAnimation {
        id: hideSettings;
        target: settings;
        property: "width";
        to: 0 ;
        duration: 300;
        easing.type: Easing.OutQuad
    }

    function fillListModel() {
        languageModel.clear();
        for (var i = 0; i < languageData.length; i++) {
            languageModel.append(languageData[i]);
        }
    }

    onLayoutChanged: {
        fillListModel();
        if (settings.waitFlag) {
            // Infinite loop
            // changeLanguageLayout(false);
        }
    }

    onColorsCurrentArrChanged : {
        colorKey.keyText = settings.colorsCurrentArr[settings.colorIndex]
    }

    onSettingsVisibleChanged: {
        if(main.settingsVisible) {
            showSettings.start()
        }
        else {
            hideSettings.start()
        }
    }

    onLoadedChanged: {
        settings.colorIndex = main.themeName
        updateColorsArray();
        changeTheme();
        changeLanguageLayout(false);
        setLayout();
        settings.setAndSaveConf();
    }

    Component.onCompleted: {
        fillListModel();
        changeLanguageLayout(false);
        hideSettings.start();
    }
}
