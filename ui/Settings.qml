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
    property int keyCode
    property string keyColor
    property int languageIndex: 0
    property int colorIndex: 0
    property bool layout: main.layoutChange
    property bool loaded: main.loaded
    property bool waitFlag : true
    property real keyboardWidth: main.width
    property real keyboardHeight: main.height
    property real keyboardX: main.x
    property real keyboardY: main.y
    property var languageWindow: null
    property string fullLayoutText: ""
    property string simpleLayoutText: ""
    property string currentLanguageCode: ""
    property variant colorsCurrentArr: ["Grey","Green","Blue","Brown","White"]
    property variant colorsTr: ["Gri","Yeşil","Mavi","Kahve","Beyaz"]
    property variant colorsUs: ["Grey","Green","Blue","Brown","White"]
    property variant colorsAra: ["رمادي","أخضر","أزرق","بنى","أبيض"]
    property variant colorsDe: ["Grau", "Grün", "Blau", "Braun", "Weiß"]
    property variant colorsFr: ["Gris", "Vert", "Bleu", "Marron", "Blanc"]
    property variant colorsIt: ["Grigio","Verde","Blu","Marrone","Bianco"]
    property variant colorsEs: ["Gris","Verde","Azul","Marrón","Blanco"]
    property variant colorsPt: ["Cinza","Verde","Azul","Marrom","Branco"]
    property variant colorsJp: ["灰色","緑","青","茶色","白"]
    property variant colorsCn: ["灰色","绿色","蓝色","棕色","白色"]
    property variant colorsKr: ["회색","초록색","파란색","갈색","흰색"]
    property variant colorsRu: ["Серый","Зелёный","Синий","Коричневый","Белый"]
    property variant colorsAz: ["Boz","Yaşıl","Mavi","Qəhvəyi","Ağ"]
    property variant colorsAl: ["Gri","Jeshile","Blu","Kafe","E bardhë"]
    property variant colorsBa: ["Siva","Zelena","Plava","Smeđa","Bijela"]
    property variant colorsIr: ["خاکستری","سبز","آبی","قهوه‌ای","سفید"]
    property var languageData: [
        { text: "tr", flagSrc: "qrc:/ui/Images/flags/tr.svg" },
        { text: "us", flagSrc: "qrc:/ui/Images/flags/us.svg" },
        { text: "de", flagSrc: "qrc:/ui/Images/flags/de.svg" },
        { text: "fr", flagSrc: "qrc:/ui/Images/flags/fr.svg" },
        { text: "it", flagSrc: "qrc:/ui/Images/flags/it.svg" },
        { text: "ara", flagSrc: "qrc:/ui/Images/flags/ara.svg" },
        { text: "es", flagSrc: "qrc:/ui/Images/flags/es.svg" },
        { text: "pt", flagSrc: "qrc:/ui/Images/flags/pt.svg" },
        { text: "jp", flagSrc: "qrc:/ui/Images/flags/jp.svg" },
        { text: "cn", flagSrc: "qrc:/ui/Images/flags/cn.svg" },
        { text: "kr", flagSrc: "qrc:/ui/Images/flags/kr.svg" },
        { text: "ru", flagSrc: "qrc:/ui/Images/flags/ru.svg" },
        { text: "az", flagSrc: "qrc:/ui/Images/flags/az.svg" },
        { text: "al", flagSrc: "qrc:/ui/Images/flags/al.svg" },
        { text: "ba", flagSrc: "qrc:/ui/Images/flags/ba.svg" },
        { text: "ir", flagSrc: "qrc:/ui/Images/flags/ir.svg" }
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
        layoutKey.keyText = main.layout === "Tam" ? settings.fullLayoutText : settings.simpleLayoutText;
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
            layoutKey.keyText = main.layout === "Tam" ? settings.fullLayoutText : settings.simpleLayoutText;
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
            layoutKey.keyText = main.layout === "Tam" ? settings.fullLayoutText : settings.simpleLayoutText;
        }

        settings.setAndSaveConf()
    }

    function changeLanguageLayout() {
        var selectedLang = languageModel.get(settings.languageIndex) ? languageModel.get(settings.languageIndex).text : "tr";
        currentLanguageCode = selectedLang;

        main.languageLayoutIndex = settings.languageIndex;
        flagImage.source = languageModel.get(settings.languageIndex) ? languageModel.get(settings.languageIndex).flagSrc : "qrc:/ui/Images/flags/tr.svg";
        helper.setKeyboardLayout(selectedLang);

        main.updateTheme = !main.updateTheme;
        updateColorsArray();
        layoutKey.keyText = main.layout === "Tam" ? settings.fullLayoutText : settings.simpleLayoutText;

        settings.setAndSaveConf();
    }

    function updateColorsArray() {
        var keyText = languageModel.get(settings.languageIndex) ? languageModel.get(settings.languageIndex).text : "tr";
        if (keyText === "tr") {
            settings.colorsCurrentArr = settings.colorsTr;
            settings.fullLayoutText = "Tam";
            settings.simpleLayoutText = "Sade";
        } else if (keyText === "ara") {
            settings.colorsCurrentArr = settings.colorsAra;
            settings.fullLayoutText = "كامل";
            settings.simpleLayoutText = "بسيط";
        } else if (keyText === "de") {
            settings.colorsCurrentArr = settings.colorsDe;
            settings.fullLayoutText = "Voll";
            settings.simpleLayoutText = "Einfach";
        } else if (keyText === "fr") {
            settings.colorsCurrentArr = settings.colorsFr;
            settings.fullLayoutText = "Complet";
            settings.simpleLayoutText = "Simple";
        } else if (keyText === "it") {
            settings.colorsCurrentArr = settings.colorsIt;
            settings.fullLayoutText = "Completo";
            settings.simpleLayoutText = "Semplice";
        } else if (keyText === "es") {
            settings.colorsCurrentArr = settings.colorsEs;
            settings.fullLayoutText = "Completo";
            settings.simpleLayoutText = "Simple";
        } else if (keyText === "pt") {
            settings.colorsCurrentArr = settings.colorsPt;
            settings.fullLayoutText = "Completo";
            settings.simpleLayoutText = "Simples";
        } else if (keyText === "jp") {
            settings.colorsCurrentArr = settings.colorsJp;
            settings.fullLayoutText = "フル";
            settings.simpleLayoutText = "シンプル";
        } else if (keyText === "cn") {
            settings.colorsCurrentArr = settings.colorsCn;
            settings.fullLayoutText = "完整";
            settings.simpleLayoutText = "简单";
        } else if (keyText === "kr") {
            settings.colorsCurrentArr = settings.colorsKr;
            settings.fullLayoutText = "전체";
            settings.simpleLayoutText = "간단한";
        } else if (keyText === "ru") {
            settings.colorsCurrentArr = settings.colorsRu;
            settings.fullLayoutText = "Полный";
            settings.simpleLayoutText = "Простой";
        } else if (keyText === "az") {
            settings.colorsCurrentArr = settings.colorsAz;
            settings.fullLayoutText = "Tam";
            settings.simpleLayoutText = "Sadə";
        } else if (keyText === "al") {
            settings.colorsCurrentArr = settings.colorsAl;
            settings.fullLayoutText = "Plotë";
            settings.simpleLayoutText = "Thjeshtë";
        } else if (keyText === "ba") {
            settings.colorsCurrentArr = settings.colorsBa;
            settings.fullLayoutText = "Pun";
            settings.simpleLayoutText = "Prost";
        } else if (keyText === "ir") {
            settings.colorsCurrentArr = settings.colorsIr;
            settings.fullLayoutText = "کامل";
            settings.simpleLayoutText = "ساده";
        } else {
            settings.colorsCurrentArr = settings.colorsUs;
            settings.fullLayoutText = "Full";
            settings.simpleLayoutText = "Simple";
        }
    }

    ListModel {
        id: languageModel
    }

    function updateWindowSize() {
        if (languageWindow) {
            var buttonSize = Math.min(transUp.width, transUp.height)

            // Calculate total number of rows and columns
            var totalButtons = languageModel.count
            var columns = Math.ceil(Math.sqrt(totalButtons))
            var rows = Math.ceil(totalButtons / columns)

            // Calculate window size based on the number of buttons
            var windowWidth = columns * (buttonSize + main.spacing) - main.spacing
            var windowHeight = rows * (buttonSize + main.spacing) - main.spacing

            windowWidth += 2 * main.spacing
            windowHeight += 2 * main.spacing

            languageWindow.width = windowWidth
            languageWindow.height = windowHeight

            var windowLeftX = keyboardX - windowWidth
            var windowTopY = keyboardY - (keyboardHeight * 0.13)

            // Adjust Y position based on layout
            if (main.layout === "Sade") {
                windowTopY -= keyboardHeight * 0.2
            } else {
                windowTopY += keyboardHeight * 0.1
            }

            // Keep window on screen
            windowLeftX = Math.max(0, windowLeftX)
            windowTopY = Math.max(0, windowTopY)
            windowTopY = Math.min(Screen.height - windowHeight, windowTopY)

            languageWindow.x = windowLeftX
            languageWindow.y = windowTopY

            // Update grid layout
            if (languageWindow.contentItem && languageWindow.contentItem.children[0] && languageWindow.contentItem.children[0].children[0]) {
                var grid = languageWindow.contentItem.children[0].children[0]
                grid.columns = columns
                grid.rows = rows
            }
        }
    }

    Component {
        id: languageWindowComponent
        Window {
            id: languageWindow
            flags: Qt.Dialog | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
            visible: false
            modality: Qt.NonModal
            color: "transparent"


            property bool isOpen: false

            function toggleVisibility() {
                if (!visible) {
                    show()
                    raise()
                    requestActivate()
                    isOpen = true
                } else {
                    hide()
                    isOpen = false
                }
            }

            Item {
                anchors.fill: parent
                Grid {
                    id: languageGrid
                    columns: 4
                    rows: 4
                    spacing: main.spacing
                    anchors.centerIn: parent

                    Repeater {
                        model: 16 // 4x4 grid
                        Rectangle {
                            width: transUp.width
                            height: transUp.height
                            color: main.keyColor
                            border.color: main.color
                            border.width: 1
                            radius: transUp.radius

                            Image {
                                anchors.centerIn: parent
                                width: parent.width * 0.6
                                height: parent.height * 0.6
                                source: index < languageModel.count ? languageModel.get(index).flagSrc : ""
                                fillMode: Image.PreserveAspectFit
                                visible: index < languageModel.count
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (index < languageModel.count) {
                                        settings.languageIndex = index
                                        changeLanguageLayout()
                                        languageWindow.hide()
                                        languageWindow.isOpen = false
                                    }
                                }
                                onPressed: parent.color = main.keyPressedColor
                                onReleased: parent.color = main.keyColor
                            }
                        }
                    }
                }
            }

            /*
            // Add a close button if needed
            Rectangle {
                width: 30
                height: 30
                color: "red"
                radius: 15
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 10

                Text {
                    anchors.centerIn: parent
                    text: "X"
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        languageWindow.hide()
                        languageWindow.isOpen = false
                    }
                }
            }
            */

            onVisibleChanged: {
                isOpen = visible
            }


            Item {
                focus: true
                Keys.onEscapePressed: close()
            }

            Component.onCompleted: {
                updateWindowSize()
            }
        }
    }

    function toggleLanguageWindow() {
        if (!languageWindow) {
            languageWindow = languageWindowComponent.createObject(settings)
        }
        updateWindowSize()
        languageWindow.toggleVisibility()
    }

    function closeLanguageWindowIfOpen() {
        if (languageWindow && languageWindow.isOpen) {
            languageWindow.hide()
            languageWindow.isOpen = false
        }
    }

    Connections {
        target: main
        function onWidthChanged() {
            keyboardWidth = main.width
            updateWindowSize()
            closeLanguageWindowIfOpen()
        }
        function onHeightChanged() {
            keyboardHeight = main.height
            updateWindowSize()
            closeLanguageWindowIfOpen()
        }
        function onXChanged() {
            keyboardX = main.x
            updateWindowSize()
            closeLanguageWindowIfOpen()
        }
        function onYChanged() {
            keyboardY = main.y
            updateWindowSize()
            closeLanguageWindowIfOpen()
        }
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


    Rectangle {
        id: container
        color: main.color

        Column {
            id: col1
            spacing: main.spacing
            anchors {
                top: container.top
                left: container.left
                margins: main.spacing
            }

            Row {
                id: row1
                spacing: main.spacing

                Key {
                    id: transUp
                    leVis4: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Image {
                            id: transUpImage
                            anchors.centerIn: parent
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            source: "Images/transparent-inc.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

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
                            if (main.transparency < 1) {
                                main.transparency += 0.1
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
                        }

                        onPressAndHold: {
                            languageKey.btnHold()
                        }

                        onReleased: {
                            languageKey.btnReleased()
                        }

                        onClicked: {
                            languageKey.btnClicked()
                            toggleLanguageWindow()
                        }
                    }
                }

                Key{
                    id: colorKey
                    leVis4: true
                    keyCode: 900

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
                    keyCode: 901

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
                            if (main.layout == "Tam") {
                                main.layout = "Sade"
                            }
                            else {
                                main.layout = "Tam"
                            }
                            main.layoutChange = !main.layoutChange
                            main.symbolMode = false
                            settings.setLayout()
                        }
                    }
                }
            }

            Row {
                id: r2
                spacing: main.spacing

                Key {
                    id: transDown
                    leVis4: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Image {
                            id: transDownImage
                            anchors.centerIn: parent
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            source: "Images/transparent-dec.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

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
                            if (main.transparency > 0.4) {
                                main.transparency -= 0.1
                                settings.opacity = main.transparency
                            }

                            settings.setAndSaveConf()
                        }
                    }
                }

                Key {
                    id: scaleDown
                    leVis4: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Image {
                            id: scaleDownImage
                            anchors.centerIn: parent
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            source: "Images/k-.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

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
                            if (main.scale > 0.5) {
                                main.scale -= 0.1
                            }

                            settings.setAndSaveConf()
                        }
                    }
                }

                Key {
                    id: scaleUp
                    leVis4: true

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Image {
                            id: scaleUpImage
                            anchors.centerIn: parent
                            width: parent.width * 0.6
                            height: parent.height * 0.6
                            source: "Images/k+.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

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
                            scaleUp.btnClicked()
                            if (main.scale < 1.5) {
                                main.scale += 0.1
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
                        source: helper.getEnableAtspi() ? "qrc:/ui/Images/auto-on.svg" : "qrc:/ui/Images/auto-off.svg"
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
                            autoShowImage.source = helper.getEnableAtspi() ? "qrc:/ui/Images/auto-on.svg" : "qrc:/ui/Images/auto-off.svg";
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
        settings.languageIndex = helper.getCurrentLayoutIndex();
        updateColorsArray();
        changeTheme();
        changeLanguageLayout();
        setLayout();
        settings.setAndSaveConf();
    }

    Component.onCompleted: {
        fillListModel();
        settings.languageIndex = helper.getCurrentLayoutIndex();
        if (settings.languageIndex >= languageModel.count) {
            settings.languageIndex = 0;
        }
        changeLanguageLayout();
        hideSettings.start();
    }
}
