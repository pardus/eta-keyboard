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
import QtQuick 2.15
import QtQuick.Window 2.15
import eta.helper 1.0

Rectangle {
    id: key

    property string keyColor: main.keyColor
    property string keyPressedColor: main.keyPressedColor
    property string keyHoverColor: main.keyHoverColor
    property string textColor: main.textColor
    property string textPressedColor: main.textPressedColor
    property string activeTextColor: main.activeTextColor
    property string activeTextColor0: main.activeTextColor0
    property string activeTextColor1: main.activeTextColor1
    property string activeTextColor2: main.activeTextColor2
    property string activeTextColor3: main.activeTextColor3
    property string keyText
    property double keyWidth: main.keyWidth
    property double keyHeight: main.keyHeight
    property int keyLevel: main.keyLevel
    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property double screenScaleFactor: dpiValue / 96
    property int divisor: (screenWidth === 3840 && screenHeight === 2160 &&
    screenScaleFactor === 2) ? 4 * screenScaleFactor : 4
    property int fontPointSize: main.keyHeight / divisor
    property int keyRadius: main.layout == "Tam" ? main.keyHeight / 10 : main.keyHeight / 8
    property int keyCode
    property bool kbdLayout: main.layoutChange
    property bool leVis0: false
    property bool leVis1: false
    property bool leVis2: false
    property bool leVis3: false
    property bool leVis4: false
    property bool highlighted: false
    property double activeOpacity: 1
    property double passiveOpacity: 0.2
    property bool hold: false
    property bool pressed: false
    property bool lock: false
    property bool updateTheme: main.updateTheme
    property bool mirror
    property bool capsMirror
    property bool keyHoverTimerTriggered: main.keyHoverTimerTriggered
    property bool releaseAll: main.releaseAll
    property int keyCodeSymbol
    property int symbolLevel
    property double transparency: main.transparency
    property bool isSpecialKeys: keyCode === 900 || keyCode === 901


    color: ma.containsMouse && main.keyHoverTimer ? key.keyHoverColor : key.keyColor
    radius: key.keyRadius
    width: key.keyWidth
    height: key.keyHeight

    function btnClicked(){

    }

    function btnPressed(){
        key.color = key.keyPressedColor
        key.pressed = true
        var lvl = key.keyLevel;
        if (key.capsMirror && main.capsLockActive && (lvl == 0 || lvl == 1)) lvl = lvl ^ 1;
        switch (lvl) {
        case 0: lev0.color = key.textPressedColor; break;
        case 1: lev1.color = key.textPressedColor; break;
        case 2: lev2.color = key.textPressedColor; break;
        case 3: lev3.color = key.textPressedColor; break;
        }
        lev4.color = key.textPressedColor
    }

    function btnHovered(){

        if (!key.lock && !key.pressed){
            key.color = ma.containsMouse && main.keyHoverTimer ?
                        key.keyHoverColor : key.keyColor
            var lvl = key.keyLevel;
            if (key.capsMirror && main.capsLockActive && (lvl == 0 || lvl == 1)) {
                lvl = lvl ^ 1;
            }
            lev0.color = lvl == 0 ? key.activeTextColor0 : key.textColor
            lev1.color = lvl == 1 ? key.activeTextColor1 : key.textColor
            lev2.color = lvl == 2 ? key.activeTextColor2 : key.textColor
            lev3.color = lvl == 3 ? key.activeTextColor3 : key.textColor
            lev4.color = key.textColor;
        }

        else {
            key.color = key.keyPressedColor
            var lvl = key.keyLevel;
            if (key.capsMirror && main.capsLockActive && (lvl == 0 || lvl == 1)) lvl = lvl ^ 1;
            switch (lvl) {
            case 0: lev0.color = key.textPressedColor; break;
            case 1: lev1.color = key.textPressedColor; break;
            case 2: lev2.color = key.textPressedColor; break;
            case 3: lev3.color = key.textPressedColor; break;
            }
            lev4.color = key.textPressedColor
        }

    }

    function btnHold(){
        key.hold = true
        main.holdBackspace(keyCode)
    }

    function btnReleased(){
        key.hold = false
        key.pressed = false
        btnHovered()
    }


    onKbdLayoutChanged: {
        updateKeySymbols()
    }

    function isSpecialKey(keyCode) {
        const specialKeyCodes = new Set([
            9, 22, 23, 36, 37, 50, 64, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76,
            95, 96, 108, 110, 111, 112, 113, 114, 115, 116, 117, 119, 500, 900, 901
        ]);

        return specialKeyCodes.has(keyCode);
    }

    function updateKeySymbols() {
        if (main.layout === "Sade" && !isSpecialKey(key.keyCode)) {
            if (main.symbolMode) {
                keyText = helper.getSymbol(key.keyCodeSymbol, main.languageLayoutIndex, key.symbolLevel);
            } else {
                var lvl = main.keyLevel;
                if (key.capsMirror && main.capsLockActive) {
                    lvl = lvl ^ 1;
                }
                keyText = helper.getSymbol(key.keyCode, main.languageLayoutIndex, lvl);
            }
        } else {
            if (!key.leVis4) {
                let levels = [lev0, lev1, lev2, lev3, lev4];
                for (let i = 0; i <= 4; i++) {
                    if (levels[i]) {
                        var symbol = helper.getSymbol(key.keyCode, main.languageLayoutIndex, i);

                        // When capsLock is active and capsMirror is true, reverse the case of the symbol
                        if (key.capsMirror && main.capsLockActive && (i === 0 || i === 1)) {
                            // level 0 -> uppercase
                            // level 1 -> lowercase
                            if (i === 0) {
                                symbol = symbol.toUpperCase();
                            } else if (i === 1) {
                                symbol = symbol.toLowerCase();
                            }
                        }

                        levels[i].text = symbol;
                    }
                }
            }
        }
    }

    Text {
        id: lev0
        color: key.keyLevel == 0 ? key.activeTextColor : key.textColor
        font.pointSize: key.fontPointSize ? key.fontPointSize : 5
        text: helper.getSymbol(key.keyCode,main.languageLayoutIndex,0)
        visible: leVis0
        opacity: key.keyLevel == 0 ? key.activeOpacity : key.passiveOpacity
        anchors {
            left: key.left
            bottom: key.bottom
            margins: keyHeight/10
        }
    }

    Text {
        id: lev1
        color: key.keyLevel == 1 ? key.activeTextColor : key.textColor
        font.pointSize: key.fontPointSize ? key.fontPointSize : 5
        text: helper.getSymbol(key.keyCode,main.languageLayoutIndex,1)
        visible: leVis1
        opacity: key.keyLevel == 1 ? key.activeOpacity : key.passiveOpacity
        anchors {
            left: key.left
            top: key.top
            margins: keyHeight/10
        }
    }

    Text {
        id: lev2
        color: key.keyLevel == 2 ? key.activeTextColor : key.textColor
        font.pointSize: key.fontPointSize ? key.fontPointSize : 5
        text: helper.getSymbol(key.keyCode,main.languageLayoutIndex,2)
        visible: leVis2
        opacity: key.keyLevel == 2 ? key.activeOpacity : key.passiveOpacity
        anchors {
            right: key.right
            bottom: key.bottom
            margins: keyHeight/10
        }
    }

    Text {
        id: lev3
        color: key.keyLevel == 3 ? key.activeTextColor : key.textColor
        font.pointSize: key.fontPointSize ? key.fontPointSize : 5
        text: helper.getSymbol(key.keyCode,main.languageLayoutIndex,3)
        visible: leVis3
        opacity: key.keyLevel == 3 ? key.activeOpacity : key.passiveOpacity
        anchors {
            right: key.right
            top: key.top
            margins: keyHeight/10
        }
    }

    Text {
        id: lev4
        color: key.textColor
        font.pointSize: key.fontPointSize ? key.fontPointSize * 3 / 4 : 2
        text: key.keyText
        font.bold: key.highlighted
        font.underline: key.highlighted
        visible: leVis4
        opacity: activeOpacity
        anchors.fill: parent
        anchors.margins: key.isSpecialKeys ? parent.height / 32 : 0
        fontSizeMode: key.isSpecialKeys ? Text.Fit : Text.FixedSize
        minimumPointSize: 1
        elide: key.isSpecialKeys ? Text.ElideRight : Text.ElideNone
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea{
        id: ma
        anchors.fill: parent
        hoverEnabled: main.keyHover

        onEntered: {
            main.keyHoverTimer = true
            btnHovered()
        }

        onExited: {
            main.keyHoverTimer = true
            btnHovered()
        }

        onPressed: {

            btnPressed()

            if (key.keyCode == 22){
                main.pressedBackspace()
            }

            else {
                main.keyClicked(key.keyCode,mirror,keyText,key.symbolLevel,
                                key.keyCodeSymbol)
                if (main.pinMode) {
                    main.shuffle = !main.shuffle
                    main.shuffle = !main.shuffle
                }
            }

            btnHovered()

        }

        onPressAndHold: {
            btnHold()
        }

        onReleased: {
            btnReleased()
            if (key.keyCode == 22){
                main.releasedBackspace()
            }
        }

        onClicked: {
            key.btnClicked()
        }

    }

    onReleaseAllChanged: {
        btnHovered()
    }

    onUpdateThemeChanged:{
        btnHovered()
    }

    onKeyLevelChanged: {
        btnHovered()
    }

    Component.onCompleted: {
        btnHovered()
    }

    onKeyHoverTimerTriggeredChanged: {
        if (!key.pressed) {
            btnHovered()
        }
    }
}
