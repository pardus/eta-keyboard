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
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import eta.helper 1.0


ApplicationWindow {
    flags:Qt.WindowStaysOnTopHint |
          Qt.FramelessWindowHint |
          Qt.WindowSystemMenuHint |
          Qt.WindowDoesNotAcceptFocus |
          Qt.X11BypassWindowManagerHint
    id: main
    visible: false
    title: qsTr("ETA Virtual Keyboard")
    color: "#010101"

    property string keyColor: "#585858" //settings.keyColor
    property string keyPressedColor: "#ffffff"
    property string keyHoverColor: "#848484"
    property string textColor: "#dddddd"
    property string activeTextColor: "white"
    property string activeTextColor0: "white"
    property string activeTextColor1: "white"
    property string activeTextColor2: "white"
    property string activeTextColor3: "white"
    property string textPressedColor: "#5e5a5a"
    property int keyHeight
    property int keyWidth: keyHeight
    property int spacing: keyHeight / 12
    property int dockSize
    property double scale: 1 // 0.2 ... 1.8
    property double transparency: 1
    property string layout
    property int languageLayoutIndex: 0 // Current System Language Layout
    property int keyLevel: 0
    property bool symbolMode: false
    property bool releaseAll: false
    property bool settingsVisible : false
    property bool updateTheme: false
    property bool keyHover: true
    property bool keyHoverTimer: false
    property bool keyHoverTimerTriggered: false
    property bool password: true
    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property int m_height
    property int m_width
    property int m_settings_height
    property int m_settings_width
    property bool keyboardVisible: false
    property bool layoutChange: false
    property int themeName
    property bool loaded: false
    property string storedMirror
    property string mirrorCharacter
    property bool btnCtrl: false
    property bool btnAlt: false
    property bool btnMeta: false
    property bool btnShift: false
    property bool btnAltGr: false
    property bool sticky: false
    property int stickyNum: 0
    property bool shuffle: true
    property bool pinMode: false
    property string previousLayout
    property double previousOpacity
    property int panelPos : 0 // 0 is default left, 1 is right
    property int lastX: -1
    property int lastY: -1
    property rect screenGeometry
    property bool initialized: false
    property int baseFontSize: 15
    property int fontSize: baseFontSize * scale
    property bool capsLockActive: helper.getCapslockStatus()

    function setAndSave(){

        if (main.layout == "Pin") {

        }
        else {
            helper.setSettings(main.themeName,
                               main.layout,
                               main.scale,
                               settings.languageIndex,
                               main.opacity)
            helper.saveSettings()
        }
    }

    function releaseAllSticky(){
        btnAlt = false
        btnAltGr = false
        btnCtrl = false
        btnMeta = false
        btnShift = false
        sticky = false
        stickyNum = 0
        keyLevel = 0
        releaseAll = !releaseAll
    }


    function updateCapsLockState(capsLockOn) {
        if (btnAltGr) {
            main.keyLevel = 2;
            return
        }

        if (settings.currentLanguageCode == "ara") {
            return
        }

        if (capsLockOn) {
            mirrorText.text = mirrorText.text.toUpperCase()
        }

        main.capsLockActive = capsLockOn
        layoutChange = !layoutChange
    }

    function constrainPosition(x, y){
        // TODO: figure why it cannot get screen's info
        var availableGeometry = screen.availableGeometry;
        var screenGeometry = screen.geometry;
        // TEMP: Fallback if screen properties are undefined
        if (!availableGeometry || !screenGeometry) {
            return Qt.point(x, y);
        }

        var topPanelHeight = availableGeometry.y - screenGeometry.y;
        var bottomPanelHeight = (screenGeometry.y + screenGeometry.height) - (availableGeometry.y + availableGeometry.height);
        var safetyMargin = 5;

        // Horizontal constraints
        if (x < screenGeometry.x) {
            x = screenGeometry.x;
        } else if (x + width > screenGeometry.x + screenGeometry.width) {
            x = screenGeometry.x + screenGeometry.width - width;
        }

        // Vertical constraints
        if (y < screenGeometry.y + topPanelHeight + safetyMargin) {
            y = screenGeometry.y + topPanelHeight + safetyMargin;
        } else if (y + height > screenGeometry.y + screenGeometry.height - bottomPanelHeight - safetyMargin) {
            y = screenGeometry.y + screenGeometry.height - bottomPanelHeight - height - safetyMargin;
        }

        return Qt.point(x, y);
    }


    function keyClicked(keyCode,mirror,keyText,level,code){

        main.settingsVisible = false
        let capsLockOn = helper.getCapslockStatus()

        if (symbolMode && mirror) {
            switch(level) {
            case 0:
                helper.fakeKeyPress(code);
                helper.fakeKeyRelease(code);
                break;
            case 1:
                helper.fakeKeyPress(50);
                helper.fakeKeyPress(code);
                helper.fakeKeyRelease(code);
                helper.fakeKeyRelease(50);
                break
            case 2:
                helper.fakeKeyPress(108);
                helper.fakeKeyPress(code);
                helper.fakeKeyRelease(code);
                helper.fakeKeyRelease(108);
                break
            case 3:
                helper.fakeKeyPress(108);
                helper.fakeKeyPress(50);
                helper.fakeKeyPress(code);
                helper.fakeKeyRelease(code);
                helper.fakeKeyRelease(50);
                helper.fakeKeyRelease(108);
                break
            }

            main.storedMirror += keyText
            if (main.password) {
                mirrorText.text +="*"
            }
            else {
                mirrorText.text += keyText
            }
            if (keyCode == 65) {
                mirrorText.text = ""
                main.storedMirror = ""
            }

        }
        else {
            switch (keyCode){
            case 500: // symbol
                symbolMode = !symbolMode
                sticky = true
                break
            case 560: // shuffle
                shuffle = !shuffle
                sticky = true
                break
            case 37: // ctrlL
                stickyNum+= btnCtrl ? -1 : 1
                btnCtrl = !btnCtrl
                sticky = true
                break
            case 64: // alt
                stickyNum+= btnAlt ? -1 : 1
                btnAlt = !btnAlt
                sticky = true
                break
            case 133: // meta
                stickyNum+= btnMeta ? -1 : 1
                btnMeta = !btnMeta
                sticky = true
                break
            case 108: // altgr
                stickyNum+= btnAltGr ? -1 : 1
                main.keyLevel+= btnAltGr ? -2 : 2
                btnAltGr = !btnAltGr
                sticky = true
                break
            case 50: // shift
                stickyNum+= btnShift ? -1 : 1
                main.keyLevel+= btnShift ? -1 : 1
                btnShift = !btnShift
                updateCapsLockState(capsLockOn)
                sticky = true
                break
            }

            if (stickyNum>3){
                releaseAllSticky()
                return 0
            }

            if (!sticky) {

                if (btnAlt){
                    helper.fakeKeyPress(64)
                }

                if (btnAltGr){
                    helper.fakeKeyPress(108)
                }

                if (btnCtrl){
                    helper.fakeKeyPress(37)
                }

                if (btnMeta){
                    helper.fakeKeyPress(133)
                }

                if (btnShift){
                    helper.fakeKeyPress(50)
                }

                helper.fakeKeyPress(keyCode);
                helper.fakeKeyRelease(keyCode);

                if (mirror && !btnAlt && !btnCtrl && !btnMeta){

                    if (helper.getCapslockStatus() && main.keyLevel == 0) {
                        mirrorCharacter = helper.getSymbol(
                            keyCode,
                            main.languageLayoutIndex,
                            main.keyLevel
                        )
                        main.storedMirror += mirrorCharacter.toUpperCase()
                        if (main.password) {
                            mirrorText.text +="*"
                        }
                        else {
                            mirrorText.text += mirrorCharacter.toUpperCase()
                        }
                    } else if (helper.getCapslockStatus() && main.keyLevel == 1) {
                        mirrorCharacter = helper.getSymbol(
                            keyCode,
                            main.languageLayoutIndex,
                            main.keyLevel
                        )
                        main.storedMirror += mirrorCharacter.toLowerCase()
                        if (main.password) {
                            mirrorText.text +="*"
                        } else {
                            mirrorText.text += mirrorCharacter.toLowerCase()
                        }
                    } else {
                        mirrorCharacter = helper.getSymbol(
                            keyCode,
                            main.languageLayoutIndex,
                            main.keyLevel
                        )
                        main.storedMirror += mirrorCharacter
                        if (main.password) {
                            mirrorText.text +="*"
                        }
                        else {
                            mirrorText.text += mirrorCharacter
                        }
                    }

                }
                switch (keyCode){
                case 65:
                    mirrorText.text = ""
                    main.storedMirror = ""
                    break;
                case 36:
                    mirrorText.text = ""
                    main.storedMirror = ""
                    break;
                case 111:
                    mirrorText.text = ""
                    main.storedMirror = ""
                    break;
                case 113:
                    mirrorText.text = ""
                    main.storedMirror = ""
                    break;
                case 114:
                    mirrorText.text = ""
                    main.storedMirror = ""
                    break;
                case 116:
                    mirrorText.text = ""
                    main.storedMirror = ""
                    break;
                case 23:
                    mirrorText.text = ""
                    main.storedMirror = ""
                    break;

                }

                if (btnAlt){
                    helper.fakeKeyRelease(64)
                }

                if (btnAltGr){
                    helper.fakeKeyRelease(108)
                }

                if (btnCtrl){
                    helper.fakeKeyRelease(37)
                }

                if (btnMeta){
                    helper.fakeKeyRelease(133)
                }

                if (btnShift){
                    helper.fakeKeyRelease(50)
                }

                releaseAllSticky()
            }

            sticky = false
        }

        updateCapsLockState(capsLockOn)
    }


    function updateScreenGeometry(geometry) {
        // if (!main.initialized) return;
        if (geometry) {
            screenGeometry = geometry
            screenWidth = geometry.width
            screenHeight = geometry.height

            setSize()
            setPosition()

            // Recalculate position with new h/w vals
            main.x = main.screenWidth / 2 - main.width / 2;
            main.y = main.screenHeight - main.height - main.spacing * 20;
            if (main.pinMode) {
                main.y = main.screenHeight / 2 - main.height / 2;
        }
        }
    }


    function fakeKeyTablet(code,level,keyText) {
        main.settingsVisible = false
        switch(level) {
        case 0:
            helper.fakeKeyPress(code);
            helper.fakeKeyRelease(code);
            break;
        case 1:
            helper.fakeKeyPress(50);
            helper.fakeKeyPress(code);
            helper.fakeKeyRelease(code);
            helper.fakeKeyRelease(50);
            break
        case 2:
            helper.fakeKeyPress(108);
            helper.fakeKeyPress(code);
            helper.fakeKeyRelease(code);
            helper.fakeKeyRelease(108);
            break
        case 3:
            helper.fakeKeyPress(108);
            helper.fakeKeyPress(50);
            helper.fakeKeyPress(code);
            helper.fakeKeyRelease(code);
            helper.fakeKeyRelease(50);
            helper.fakeKeyRelease(108);
            break
        }

        if (main.pinMode) {
            main.shuffle = !main.shuffle
            main.shuffle = !main.shuffle
        } else {

            main.storedMirror += keyText
            if (main.password) {
                mirrorText.text += "*"
            }
            else {
                mirrorText.text += keyText
            }
        }
    }


    function setSize(){
        var oldWidth = main.width
        var oldHeight = main.height
        var scaleVariable

        if (main.layout == "Tam") {
            scaleVariable = main.scale
        } else if (main.layout == "Sade") {
            scaleVariable = main.scale + 0.2
        } else {
            scaleVariable = 0.8
        }


        main.keyHeight =  main.screenHeight * scaleVariable / 23
        main.dockSize = main.screenHeight * scaleVariable / 35
        if (main.layout == "Tam") {
            main.width = main.keyHeight * 15 + main.spacing * 16
            main.height = main.keyHeight * 11 / 2 + main.dockSize + main.spacing * 8
        } else if (main.layout == "Sade") {
            main.width = main.keyHeight * 12 + main.spacing * 13
            main.height = main.keyHeight * 4 + main.dockSize + main.spacing * 6
        } else {
            main.width = main.keyHeight * 4 + main.spacing * 5
            main.height = main.keyHeight * 4 + main.dockSize + main.spacing * 6
        }

        settings.width =  main.keyWidth * 4 + main.spacing * 6
        settings.height = main.keyHeight * 2 + main.spacing * 3
        main.m_height = main.height
        main.m_width = main.width
        main.m_settings_height = settings.height
        main.m_settings_width = settings.width
    }

    function pressedBackspace(){
        helper.fakeKeyPress(22)
        mirrorText.text = mirrorText.text.substring(0, mirrorText.text.length - 1)
        main.storedMirror = main.storedMirror.substring(0, main.storedMirror.length - 1)
    }

    function releasedBackspace(){
        helper.fakeKeyRelease(22)
    }

    function holdBackspace(keyCode) {
        if (keyCode == 22) {
            mirrorText.text = ""
            main.storedMirror = ""
        }
    }

    function showPinMode(){
        if (!main.pinMode){
            main.opacity = 1
            main.pinMode = true
            main.password = true
            main.shuffle = true
            main.previousLayout = main.layout == "Pin" ? main.previousLayout : main.layout
            main.layout = "Pin"
            main.settingsVisible = false
            settings.visible = false
            closeBtnImage.visible = false
            main.show();
            setPosition();
        }
    }

    function hidePinMode() {
        if (main.pinMode) {
            main.opacity = main.previousOpacity
            main.hide();

        }
    }

    function hideKeyboard() {
        if (!helper.isDbusAvailable()){
            Qt.quit();
        }
        mirrorText.text = ""
        main.storedMirror = ""
        main.hide();
        settings.hide();

        // Close language selection window if it is open
        if (settings.languageWindow && settings.languageWindow.visible) {
            settings.languageWindow.hide();
            settings.languageWindow.isOpen = false;
        }
    }

    function setPosition() {
        var initialX, initialY;
        // If there is a saved pos use it, else use default pos
        if (main.lastX !== -1 && main.lastY !== -1) {
            initialX = main.lastX;
            initialY = main.lastY;
        } else {
            initialX = main.screenWidth / 2 - main.width / 2;
            initialY = main.pinMode ?
                    (main.screenHeight / 2 - main.height / 2) :
                    (main.screenHeight - main.height - main.spacing * 20);
        }
        var pos = constrainPosition(initialX, initialY);
        main.x = pos.x;
        main.y = pos.y;
    }

    Connections {
        target: screen
        onGeometryChanged: function(geometry) {
            updateScreenGeometry(geometry)
        }
    }

    Helper {
        id: helper

        onShowCalled: {
            main.show();
            setPosition();
        }


        onHideCalled: {
            hideKeyboard()
        }

        onLayoutChanged: {
            main.layoutChange = !main.layoutChange
        }

        onPasswordDetected: {
            main.password = true
            if (!keyboardVisible) {
                main.show();
                setPosition();
            }
        }

        onShowPinInputCalled: {
            showPinMode()
        }

        onHidePinInputCalled: {
            hidePinMode()
        }
    }

    ListModel {
        id:stickyModel
    }

    Item {
        id: container

        Rectangle {
            id: dock
            height: main.dockSize
            width: main.width
            color: main.color
            anchors{
                top: container.top
                left: container.left
                margins: main.spacing
            }

            Rectangle {
                id: passwordToggle
                height: dock.height
                width: passwordToggle.height
                color:  main.keyColor
                radius: passwordToggle.height / 2
                visible: main.pinMode ? false : true
                anchors{
                    left: dock.left
                    top: dock.top
                }
                z: +5

                Image {
                    id: pToggleText
                    source: main.password ?
                    "Images/view-conceal-symbolic.svg"
                    : "Images/view-reveal-symbolic.svg"

                    smooth: true
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: parent.height * 0.8
                }

                MouseArea{
                    id: pToggleMa
                    anchors.fill: parent

                    onClicked: {
                        main.password = !main.password
                        pToggleText.source = main.password ?
                        "Images/view-conceal-symbolic.svg"
                        : "Images/view-reveal-symbolic.svg"

                        main.keyHover = !main.password
                    }
                }
            }

            Image {
                id: closeBtnImage
                source: "Images/close.svg"
                smooth: true
                mipmap: true
                height:main.dockSize
                width: closeBtnImage.height
                anchors {
                    right: dock.right
                    top: dock.top
                    bottom: dock.bottom
                    rightMargin: 10
                }
                z: +5

                MouseArea{
                    anchors.fill: closeBtnImage

                    onClicked: {
                        hideKeyboard();
                    }
                }
            }

            Item {
                id: mirrorTextContainer
                anchors {
                    left: passwordToggle.right
                    right: closeBtnImage.left
                    top: dock.top
                    bottom: dock.bottom
                }

                Text {
                    id: mirrorText
                    text: ""
                    font.pixelSize: main.fontSize
                    color: main.activeTextColor
                    anchors.centerIn: mirrorTextContainer
                    wrapMode: Text.WordWrap
                    z: -5
                }
            }



            MouseArea {
                property variant cpos: "1,1"
                anchors {
                    top: dock.top
                    left: passwordToggle.right
                    bottom: dock.bottom
                    right: closeBtnImage.left
                }

                onPressed: {
                    cpos = Qt.point(mouse.x, mouse.y);
                }

                onPositionChanged: {
                    main.settingsVisible = false
                    var delta = Qt.point(mouse.x - cpos.x, mouse.y - cpos.y);
                    var pos = constrainPosition(main.x + delta.x, main.y + delta.y);
                    main.x = pos.x;
                    main.y = pos.y;
                }

                onReleased: {
                    main.lastX = main.x;
                    main.lastY = main.y;
                }
            }
        }

        FullLayout{
            id: fullLay
            visible: main.layout=="Tam" ? true : false
            anchors.top: dock.bottom
        }

        TabletLayout{
            id: tabletLayout
            visible: main.layout=="Sade" ? true : false
            anchors.top: dock.bottom
        }

        PinLayout{
            id: pinLayout
            visible: main.layout=="Pin" ? true : false
            anchors.top: dock.bottom
        }
    }

    Settings{
        id: settings
        visible: false
    }

    onLayoutChanged: {
        setSize()
    }

    onScaleChanged: {
        fontSize = baseFontSize * scale;
        setSize()
    }

    onTransparencyChanged: {
        main.opacity = main.transparency
    }

    onPasswordChanged: {
        if (main.password){
            var len = mirrorText.text.length
            mirrorText.text = ""
            for (var i=0; i<len; i++){
                mirrorText.text += "*"
            }
        }
        else {
            mirrorText.text = main.storedMirror
        }

        passwordToggle.color = main.password ? main.keyPressedColor : main.keyColor
        pToggleText.source = main.password ? "Images/view-conceal-symbolic.svg" : "Images/view-reveal-symbolic.svg"
    }

    onKeyHoverTimerChanged: {
        timer.start()
    }

    Component.onCompleted: {
        updateScreenGeometry(screen.geometry)
        main.initialized = true;

        main.themeName = helper.getColor() ? helper.getColor() : 0
        main.layout = helper.getLayoutType() == "Sade" || helper.getLayoutType() == "Tam" ? helper.getLayoutType() : "Tam"
        main.previousLayout = main.layout
        main.scale = helper.getScale() ? helper.getScale() : 1
        main.transparency = helper.getOpacity() ? helper.getOpacity() : 1
        main.opacity = main.transparency
        main.previousOpacity = main.opacity
        settings.opacity = main.transparency

        main.screenHeight = Screen.height
        main.screenWidth = Screen.width

        setSize()

        main.settingsVisible = false
        closeBtnImage.visible = true
        main.loaded = true

        fontSize = baseFontSize * scale;

        if (helper.isLogin()) {
            closeBtnImage.visible = false
            main.password = true
            setPosition()
        } else if (helper.isShowOnStartEnabled()) {
            main.show();
            setPosition();
        } else {
            hideKeyboard();
        }

        // Clean mirror text when input field is changed
        helper.focusChanged.connect(function() {
            mirrorText.text = ""
            main.storedMirror = ""
        })
    }

    Timer {
        id: timer
        running: false
        interval: 1250
        onTriggered: {
            if (main.keyHoverTimer) {
                main.keyHoverTimer = false
                main.keyHoverTimerTriggered = !main.keyHoverTimerTriggered

            }
        }
    }
}
