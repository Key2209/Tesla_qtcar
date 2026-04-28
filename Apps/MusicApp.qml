import QtQuick 2.9
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3


    // ----------------------
    // 2. 音乐模块
    // ----------------------
    Rectangle {

    property int activeWidget: 0
    property int paddingVal: 20
    property int cardSpacing: 20
    property int bottomWidgetHeight: 180
    property int topSafeMargin: 50
    property int bottomSafeMargin: 120
    property color cardBackgroundColor: "#1C1C1E"
    property color cardBorderColor: "#38383A"
    property color themeColor: "#FA114F"
    
    signal requestToggleActive()



    // ==========================================
    // 接口：播放器核心状态 (对接 C++ QMediaPlayer 或外部 IPC 服务)
    // ==========================================
    property bool musicIsPlaying: MusicCtrl.isPlaying
    property string musicTitle: MusicCtrl.title
    property string musicArtist: MusicCtrl.artist
    property int musicDurationSec: MusicCtrl.durationSec
    property int musicElapsedSec: MusicCtrl.elapsedSec
    property string musicCoverPath: MusicCtrl.coverPath
    property string musicLyric: MusicCtrl.currentLyric

    // 根据秒数自动计算进度 (0.0 - 1.0)
    property real musicProgress: musicDurationSec > 0 ? (musicElapsedSec / musicDurationSec) : 0

    // 天气接口预留
    property string weatherCity: "Cupertino"
    property string weatherDate: "Tuesday, March 24"
    property string weatherTemp: "22°"
    property string weatherCondition: "Partly Cloudy"
    property string weatherHighLow: "H:26° L:14°"
    property string weatherIconPath: "qrc:/icons/weather_cloud.png"

    // ==========================================
    // 内部逻辑与工具函数
    // ==========================================

    // 时间格式化函数 (例如把 130 变成 "2:10")
    function formatTime(seconds) {
        var m = Math.floor(seconds / 60);
        var s = Math.floor(seconds % 60);
        return m + ":" + (s < 10 ? "0" : "") + s;
    }

    // 初始化内容（删除了内部模拟）
    Component.onCompleted: {
    }
        id: musicWidgetContainer
        color: cardBackgroundColor
        radius: 16
        border.color: cardBorderColor
        border.width: 1
        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomSafeMargin + paddingVal
        anchors.leftMargin: paddingVal
        anchors.rightMargin: activeWidget === 2 ? paddingVal : (parent.width / 2 + cardSpacing / 2)
        height: activeWidget === 2 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight

        opacity: activeWidget === 0 || activeWidget === 2 ? 1 : 0
        visible: opacity > 0
        z: activeWidget === 2 ? 99 : 1

        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuart
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuart
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }

        MouseArea {
            anchors.fill: parent
            z: 0
            onClicked: requestToggleActive()
        }

        // ==========================================
        // 迷你模式 UI
        // ==========================================
        Item {
            anchors.fill: parent
            anchors.margins: 16
            opacity: activeWidget === 2 ? 0 : 1
            visible: opacity > 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 16
                Rectangle {
                    width: bottomWidgetHeight - 32
                    height: width
                    radius: 10
                    color: "#2C2C2E"
                    clip: true
                    Image {
                        anchors.fill: parent
                        source: musicCoverPath
                        fillMode: Image.PreserveAspectCrop
                        visible: status === Image.Ready
                    }
                    Image {
                        source: "qrc:/icons/music_icons/listen.png"
                        anchors.centerIn: parent
                        width: 32
                        height: 32
                        fillMode: Image.PreserveAspectFit
                        visible: !parent.children[0].visible
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 4
                    Text {
                        text: musicTitle
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Text {
                        text: musicArtist
                        font.pixelSize: 16
                        color: "#8E8E93"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                RowLayout {
                    spacing: 16
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        // color: musicIsPlaying ? "#3A3A3C" : "#FFFFFF"
                        color:"#FFFFFF"
                        Image {
                            source: musicIsPlaying ? "qrc:/icons/music_icons/btn_pausing.png" : "qrc:/icons/music_icons/btn_playing.png"
                            anchors.centerIn: parent
                            width: 48
                            height: 48
                            fillMode: Image.PreserveAspectFit
                            visible: status === Image.Ready
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                MusicCtrl.togglePlayPause();
                                mouse.accepted = true;
                            }
                            onPressed: parent.scale = 0.9
                            onReleased: parent.scale = 1.0
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 100
                                }
                            }
                        }
                    }
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 24
                        color: "transparent"
                        Image {
                            id: nextBtnMiniImg
                            source: "qrc:/icons/music_icons/btn_playNext_100.png"
                            anchors.centerIn: parent
                            width: 24
                            height: 24
                            fillMode: Image.PreserveAspectFit
                            visible: false
                        }
                        ColorOverlay {
                            anchors.fill: nextBtnMiniImg
                            source: nextBtnMiniImg
                            color: "#FFFFFF"
                            antialiasing: true
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                MusicCtrl.playNext();
                                mouse.accepted = true;
                            }
                            onPressed: parent.opacity = 0.5
                            onReleased: parent.opacity = 1.0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 100
                                }
                            }
                        }
                    }
                }
            }
            // 底部迷你进度条
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -10
                anchors.left: parent.left
                anchors.right: parent.right
                height: 3
                radius: 1.5
                color: "#3A3A3C"
                Rectangle {
                    width: parent.width * musicProgress
                    height: parent.height
                    radius: 1.5
                    color: "#FFFFFF"
                }
            }
        }

        // ==========================================
        // 全屏模式 UI
        // ==========================================
        Item {
            anchors.fill: parent
            opacity: activeWidget === 2 ? 1 : 0
            visible: opacity > 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            // ---------------- 左侧主控区 ----------------
            Item {
                width: parent.width * 0.55
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 40
                    spacing: 20

                    // 1. 封面及光影效果
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Rectangle {
                            id: coverRect
                            width: Math.min(parent.width, parent.height)
                            height: width
                            anchors.centerIn: parent
                            radius: 20
                            color: "#2C2C2E"

                            // 底部的投影，使用封面图模糊实现发光边缘
                            Image {
                                id: coverGlow
                                source: musicCoverPath
                                anchors.fill: parent
                                anchors.margins: -10
                                fillMode: Image.PreserveAspectCrop
                                visible: false
                            }
                            FastBlur {
                                anchors.fill: coverGlow
                                source: coverGlow
                                radius: 32
                                transparentBorder: true
                                opacity: 0.6 // 让光晕柔和一点
                                visible: status === Image.Ready
                            }

                            // 实际的图片层
                            Image {
                                id: fullCoverImg
                                anchors.fill: parent
                                source: musicCoverPath
                                fillMode: Image.PreserveAspectCrop
                                visible: status === Image.Ready
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: coverRect.width
                                        height: coverRect.height
                                        radius: 20
                                    }
                                }
                            }
                            Image {
                                source: "qrc:/icons/music_icons/listen.png"
                                anchors.centerIn: parent
                                width: coverRect.width * 0.4
                                height: coverRect.width * 0.4
                                fillMode: Image.PreserveAspectFit
                                visible: !fullCoverImg.visible
                            }
                        }
                    }

                    // 2. 信息及互动
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 70
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Text {
                                text: musicTitle
                                font.pixelSize: 32
                                font.weight: Font.Bold
                                color: "#FFFFFF"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            Text {
                                text: musicArtist
                                font.pixelSize: 22
                                color: themeColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                font.weight: Font.Medium
                            }
                        }
                        
                        // 喜欢
                        Item {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            property bool isLiked: false
                            Image {
                                source: parent.isLiked ? "qrc:/icons/music_icons/likelike.png" : "qrc:/icons/music_icons/like1.png"
                                anchors.centerIn: parent
                                width: 28
                                height: 28
                                fillMode: Image.PreserveAspectFit
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: parent.isLiked = !parent.isLiked
                                onPressed: parent.scale = 0.8
                                onReleased: parent.scale = 1.0
                                Behavior on scale { NumberAnimation { duration: 150 } }
                            }
                        }

                        Item { Layout.preferredWidth: 10 }

                        // 更多设置
                        // Rectangle {
                        //     Layout.preferredWidth: 36
                        //     Layout.preferredHeight: 36
                        //     radius: 18
                        //     color: "#3A3A3C"
                        //     Image {
                        //         source: "qrc:/icons/music_icons/setting.png"
                        //         anchors.centerIn: parent
                        //         width: 20
                        //         height: 20
                        //         fillMode: Image.PreserveAspectFit
                        //     }
                        //     MouseArea {
                        //         anchors.fill: parent
                        //         onClicked: mouse.accepted = true
                        //         onPressed: parent.opacity = 0.6
                        //         onReleased: parent.opacity = 1.0
                        //     }
                        // }
                    }

                    // 3. 进度条 (已实现数据绑定和拖动修改时间)
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        spacing: 8

                        Slider {
                            id: fullSlider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 24
                            from: 0
                            to: 100
                            value: musicProgress * 100

                            onMoved: {
                                var seekSec = (value / 100) * musicDurationSec;
                                MusicCtrl.seekTo(Math.floor(seekSec));
                            }

                            background: Rectangle {
                                x: fullSlider.leftPadding
                                // 👇 核心魔法：底槽的 Y 轴绝对垂直居中公式
                                y: fullSlider.topPadding + fullSlider.availableHeight / 2 - height / 2
                                width: fullSlider.availableWidth
                                height: 6
                                radius: 3
                                color: "#3A3A3C"

                                Rectangle {
                                    width: fullSlider.visualPosition * parent.width
                                    height: parent.height
                                    color: themeColor // 粉色高亮进度
                                    radius: 3
                                }
                            }

                            handle: Rectangle {
                                x: fullSlider.leftPadding + fullSlider.visualPosition * (fullSlider.availableWidth - width)
                                // 👇 核心魔法：圆圈的 Y 轴公式，必须跟上面底槽的公式【一模一样】！
                                y: fullSlider.topPadding + fullSlider.availableHeight / 2 - height / 2

                                // 稍微把默认状态设为 12，按下去变成 20，这样平时看起来会更舒服贴合
                                width: fullSlider.pressed ? 20 : 12
                                height: width
                                radius: width / 2
                                color: "#FFFFFF"

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }
                            }
                        }
                        RowLayout {
                            Layout.fillWidth: true
                            // 当前时间
                            Text {
                                text: formatTime(musicElapsedSec)
                                color: "#8E8E93"
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                            }
                            Item {
                                Layout.fillWidth: true
                            }
                            // 剩余时间 (以负号显示)
                            Text {
                                text: "-" + formatTime(musicDurationSec - musicElapsedSec)
                                color: "#8E8E93"
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                            }
                        }
                    }

                    // 4. 控制盘
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 20
                        
                        // 播放模式
                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.preferredWidth: 44
                            Layout.preferredHeight: 44
                            opacity: 0.7
                            Image {
                                id: playModeImg
                                source: "qrc:/icons/music_icons/playmodel30.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                                visible: false
                            }
                            ColorOverlay {
                                anchors.fill: playModeImg
                                source: playModeImg
                                color: "#FFFFFF"
                                antialiasing: true
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse.accepted = true
                                onPressed: parent.opacity = 0.3
                                onReleased: parent.opacity = 0.7
                            }
                        }
                        
                        // 上一首
                        Item {
                            Layout.preferredWidth: 64
                            Layout.preferredHeight: 64
                            Image {
                                id: prevBtnFullImg
                                source: "qrc:/icons/music_icons/btn_playPrev_100.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: 44
                                height: 44
                                visible: false
                            }
                            ColorOverlay {
                                anchors.fill: prevBtnFullImg
                                source: prevBtnFullImg
                                color: "#FFFFFF"
                                antialiasing: true
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    MusicCtrl.playPrevious();
                                    mouse.accepted = true;
                                }
                                onPressed: parent.scale = 0.85
                                onReleased: parent.scale = 1.0
                                Behavior on scale { NumberAnimation { duration: 150 } }
                            }
                        }
                        
                        // 播放/暂停
                        Rectangle {
                            Layout.preferredWidth: 88
                            Layout.preferredHeight: 88
                            radius: 44
                            color: "#FFFFFF"
                            
                            // 外发光
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                color: "#10FFFFFF"
                                radius: 10
                                samples: 21
                            }
                            Image {
                                source: musicIsPlaying ? "qrc:/icons/music_icons/btn_playing.png" : "qrc:/icons/music_icons/btn_pausing.png"
                                anchors.centerIn: parent
                                width: 88
                                height: 88
                                fillMode: Image.PreserveAspectFit
                                visible: status === Image.Ready
                                // 根据深浅模式调整图标颜色，白色圆底用黑色图标，黑底用白图标
                                // 但目前图标是现成的 PNG，我们默认它们能融洽显示，如果不能可以通过 ColorOverlay 调整（为了避免不支持先保留）
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    MusicCtrl.togglePlayPause();
                                    mouse.accepted = true;
                                }
                                onPressed: parent.scale = 0.90
                                onReleased: parent.scale = 1.0
                                Behavior on scale { NumberAnimation { duration: 100 } }
                            }
                        }
                        
                        // 下一首
                        Item {
                            Layout.preferredWidth: 64
                            Layout.preferredHeight: 64
                            Image {
                                id: nextBtnFullImg
                                source: "qrc:/icons/music_icons/btn_playNext_100.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: 44
                                height: 44
                                visible: false
                            }
                            ColorOverlay {
                                anchors.fill: nextBtnFullImg
                                source: nextBtnFullImg
                                color: "#FFFFFF"
                                antialiasing: true
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    MusicCtrl.playNext();
                                    mouse.accepted = true;
                                }
                                onPressed: parent.scale = 0.85
                                onReleased: parent.scale = 1.0
                                Behavior on scale { NumberAnimation { duration: 150 } }
                            }
                        }
                        

                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // ---------------- 右侧列表区 ----------------
            Item {
                anchors.left: parent.children[0].right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.margins: 40

                RowLayout {
                    id: listHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 12

                    Image {
                        id: listHeaderImg
                        source: "qrc:/icons/music_icons/listen.png"
                        width: 32
                        height: 32
                        fillMode: Image.PreserveAspectFit
                        visible: false
                    }
                    ColorOverlay {
                        anchors.fill: listHeaderImg
                        source: listHeaderImg
                        color: "#FFFFFF"
                        opacity: 0.8
                    }

                    Text {
                        text: "当前歌词"
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        color: "white"
                        Layout.fillWidth: true
                    }
                }

                // 歌词大字显示区
                Item {
                    anchors.top: listHeader.bottom
                    anchors.topMargin: 24
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    
                    Text {
                        id: displayLyric
                        anchors.centerIn: parent
                        width: parent.width * 0.9
                        text: musicLyric !== "" ? musicLyric : "正在连接音频服务..."
                        font.pixelSize: 32
                        font.weight: Font.Bold
                        color: themeColor // 使用上面的粉红色
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        opacity: text !== "" ? 1 : 0.6
                        
                        Behavior on text {
                            // 为了避免快速跳变闪烁，暂不加复杂动画，或者只用淡入淡出（QML property绑定时需要手动写状态机）
                        }
                    }
                    
                    // 副标题装饰
                    Text {
                        anchors.top: displayLyric.bottom
                        anchors.topMargin: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: musicLyric !== "" ? "车机蓝牙同步歌词模式" : "暂无歌词数据"
                        font.pixelSize: 18
                        color: "#8E8E93"
                    }
                }
            }
        }
    }