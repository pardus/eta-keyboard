import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import eta.helper 1.0

ApplicationWindow {
    id: settings

    flags: Qt.WindowStaysOnBottomHint | Qt.FramelessWindowHint | Qt.X11BypassWindowManagerHint

    property bool settingsVisible: main.settingsVisible
    property int settingsWidth: main.keyWidth * 3 + main.spacing * 4
    property int settingsHeight: main.keyHeight * 2 + main.spacing * 3
    property string keyColor

    property int languageIndex: 0
    property int colorIndex: 0


    width: settings.settingsWidth
    height:settings.settingsHeight
    visible: true
    color: main.color


    x: main.x - settings.width + main.spacing
    y: main.y + main.height - settings.height


    Helper{
        id: helperId
    }

    ListModel {
        id:languageModel
    }

    ListModel {
        id: colorModel
        ListElement {text:"Grey"; kColor:"#585858"; tColor:"#dddddd"; atColor:"white";hColor:"#848484"; bColor: "#010101"}
        ListElement {text:"Green"; kColor:"dark green"; tColor:"white"; atColor:"white";hColor:"green"; bColor: "#010101"}
        ListElement {text:"Blue"; kColor:"#1b50b8"; tColor:"#fbfcfe"; atColor:"#fbfcfe";hColor:"#3980f4";bColor: "#010101"}
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
                    id: languageKey
                    leVis4: true

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

                            settings.languageIndex++
                            if (settings.languageIndex<languageModel.count){
                                main.languageLayoutIndex = settings.languageIndex
                                helperId.setLayout(languageModel.get(settings.languageIndex).text)
                                languageKey.keyText = languageModel.get(settings.languageIndex).text


                            }
                            else {
                                settings.languageIndex = 0
                                main.languageLayoutIndex = settings.languageIndex
                                helperId.setLayout(languageModel.get(settings.languageIndex).text)
                                languageKey.keyText = languageModel.get(settings.languageIndex).text

                            }

                        }
                        onPressAndHold: {
                            languageKey.btnHold()
                        }
                        onReleased: {
                            languageKey.btnReleased()

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
                            languageKey.btnHovered()
                        }

                        onExited: {
                            languageKey.btnHovered()
                        }

                        onPressed: {
                            languageKey.btnPressed()

                            settings.colorIndex++
                            if (settings.colorIndex<colorModel.count){
                                main.keyColor = colorModel.get(settings.colorIndex).kColor;
                                main.textColor = colorModel.get(settings.colorIndex).tColor;
                                main.activeTextColor = colorModel.get(settings.colorIndex).atColor;
                                main.keyHoverColor = colorModel.get(settings.colorIndex).hColor;
                                main.color = colorModel.get(settings.colorIndex).bColor;
                                main.updateTheme = !main.updateTheme
                                colorKey.keyText = colorModel.get(settings.colorIndex).text

                            }
                            else {
                                settings.colorIndex = 0
                                main.keyColor = colorModel.get(settings.colorIndex).kColor;
                                main.textColor = colorModel.get(settings.colorIndex).tColor;
                                main.activeTextColor = colorModel.get(settings.colorIndex).atColor;
                                main.keyHoverColor = colorModel.get(settings.colorIndex).hColor;
                                main.color = colorModel.get(settings.colorIndex).bColor;
                                main.updateTheme = !main.updateTheme
                                colorKey.keyText = colorModel.get(settings.colorIndex).text


                            }

                        }
                        onPressAndHold: {
                            languageKey.btnHold()
                        }
                        onReleased: {
                            languageKey.btnReleased()

                        }
                        onClicked: {
                            languageKey.btnClicked()
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
                            if (main.layout == "full")
                                main.layout = "tablet"
                            else main.layout = "full"

                            layoutKey.keyText = main.layout


                        }
                        onClicked: {
                            layoutKey.btnClicked()
                        }
                    }

                }
            }

            Row{
                id: r2
                spacing: main.spacing

                Key{
                    id: scaleDown
                    leVis4: true
                    keyText: "-"
                    fontPointSize: main.keyHeight / 2

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
                            if (main.scale>0.5)
                                main.scale-=0.1
                            scale.keyText = main.scale
                        }
                        onClicked: {
                            scaleDown.btnClicked()
                        }
                    }
                }




                Key{
                    id: scale
                    leVis4: true
                    keyText: main.scale
                    fontPointSize: main.keyHeight / 2

                    MouseArea {
                        id: ma5
                        anchors.fill: parent

                    }
                }



                Key{
                    id: scaleUp
                    leVis4: true
                    keyText: "+"
                    fontPointSize: main.keyHeight / 2

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
                            if (main.scale<1.5)
                                main.scale+=0.1
                            scale.keyText = main.scale
                        }
                        onClicked: {
                            scaleDown.btnClicked()
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
        to:settings.settingsWidth
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




    onSettingsVisibleChanged: {
        if(main.settingsVisible)
            showSettings.start()
        else hideSettings.start()

    }


    Component.onCompleted: {

        for(var i = 0; i< helper.getNumberOfLayouts();i++)
        {
            languageModel.append({text:helper.getLayoutName(i)});
        }

        languageKey.keyText = languageModel.get(0).text
        colorKey.keyText = colorModel.get(0).text
        layoutKey.keyText = main.layout



    }
}