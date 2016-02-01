import QtQuick 2.0

Rectangle {

    id: specKey

    property string keyColor: main.keyColor
    property string keyPressedColor: main.keyPressedColor
    property string keyHoverColor: main.keyHoverColor
    property string textColor: main.textColor
    property string textPressedColor: main.textPressedColor
    property string keySymbolLevel1
    property int keyWidth
    property int keyHeight: main.keyHeight


    width: keyWidth
    height: keyHeight
    color: keyColor
    radius: keyHeight/10

    property bool hold: false
    property bool entered: false
    Text {
        id: symbol
        color: textColor
        font.pointSize: keyHeight * 3 / 15
        anchors {
            centerIn: specKey
        }
        text: keySymbolLevel1
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (!specKey.hold){
                specKey.color = specKey.keyHoverColor
                symbol.color = specKey.textColor


            }
            specKey.entered = true
        }

        onExited: {
            if (!specKey.hold){
                specKey.color = specKey.keyColor
                symbol.color = specKey.textColor


            }
            specKey.entered = false
        }

        onPressed: {
            specKey.color = specKey.keyPressedColor
            symbol.color = specKey.textPressedColor

            main.nonStickyPressed(specKey.keySymbolLevel1)



        }
        onPressAndHold: {
            specKey.color = specKey.keyPressedColor
            symbol.color = specKey.textPressedColor


            specKey.hold = true


        }
        onReleased: {
            specKey.hold = false
            if (!specKey.entered){
                specKey.color = specKey.keyColor
                symbol.color = specKey.textColor


            }
            else {
                specKey.color = specKey.keyHoverColor
                symbol.color = specKey.textColor


            }

        }
    }
}
