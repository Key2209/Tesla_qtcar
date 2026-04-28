import QtQuick 2.9
import QtLocation 5.6
import QtQml 2.3
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtPositioning 5.6
import QtQuick.Layouts 1.3
import Style 1.0

import QtQuick 2.9
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

// import Style 1.0

Rectangle {
    id: rightPanelContainer
    property bool runMenuAnimation: false
    color: "transparent"
    visible: true
    clip: true

    property int activeWidget: 0

    property int paddingVal: 20
    property int cardSpacing: 20
    property int bottomWidgetHeight: 180
    property int topSafeMargin: 50
    property int bottomSafeMargin: 120

    property color cardBackgroundColor: "#1C1C1E"
    property color cardBorderColor: "#38383A"
    property color themeColor: "#FA114F" // Apple Music 标志性粉红

    // ==========================================
    // 接口：播放器核心状态 (对接 C++ QMediaPlayer)
    // ==========================================
    property bool musicIsPlaying: false
    property int currentSongIndex: 0

    // 时间状态 (单位：秒)
    property int musicDurationSec: 200
    property int musicElapsedSec: 0

    // 根据秒数自动计算进度 (0.0 - 1.0)
    property real musicProgress: musicDurationSec > 0 ? (musicElapsedSec / musicDurationSec) : 0

    // 当前曲目信息
    property string musicTitle: ""
    property string musicArtist: ""
    property string musicCoverPath: ""

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

    // 切歌函数
    function playSong(index) {
        if (index < 0 || index >= playlistModel.count)
            return;
        var songData = playlistModel.get(index);

        currentSongIndex = index;
        musicTitle = songData.songName;
        musicArtist = songData.artistName;
        musicCoverPath = songData.coverImg;
        musicDurationSec = songData.durationSec;
        musicElapsedSec = 0;
        musicIsPlaying = true;
    }

    // 模拟后台播放的定时器 (C++ 接入后可删除)
    Timer {
        id: mockPlaybackTimer
        interval: 1000
        running: musicIsPlaying && activeWidget !== -1 // 只要在播放就跑
        repeat: true
        onTriggered: {
            if (musicElapsedSec < musicDurationSec) {
                musicElapsedSec++;
            } else {
                // 播完了自动下一首
                var nextIndex = (currentSongIndex + 1) % playlistModel.count;
                playSong(nextIndex);
            }
        }
    }

    // 初始化时加载第一首歌
    Component.onCompleted: {
        playSong(0);
        musicIsPlaying = false; // 初始不自动播放
    }

    // ----------------------
    // 1. 地图模块 (保持不变)
    // ----------------------
    Rectangle {
        id: mapWidgetContainer
        color: cardBackgroundColor
        radius: 16
        border.color: cardBorderColor
        border.width: 1
        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: topSafeMargin + paddingVal
        anchors.leftMargin: paddingVal
        anchors.rightMargin: paddingVal
        height: activeWidget === 1 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2 - cardSpacing - bottomWidgetHeight)
        opacity: activeWidget === 0 || activeWidget === 1 ? 1 : 0
        visible: opacity > 0
        z: activeWidget === 1 ? 99 : 1
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
            onDoubleClicked: activeWidget = activeWidget === 0 ? 1 : 0
        }

        Rectangle {
            z: 100
            width: 44
            height: 44
            radius: 22
            color: "#80000000"
            border.color: "#40FFFFFF"
            border.width: 1
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            Text {
                text: activeWidget === 1 ? "↙" : "↗"
                font.pixelSize: 18
                color: "white"
                anchors.centerIn: parent
            }
            MouseArea {
                anchors.fill: parent
                onClicked: activeWidget = activeWidget === 0 ? 1 : 0
                onPressed: parent.opacity = 0.6
                onReleased: parent.opacity = 1.0
            }
        }
    }

    // ----------------------
    // 2. 音乐模块
    // ----------------------
    Rectangle {
        id: musicWidgetContainer
        color: activeWidget === 2 ? "transparent" : cardBackgroundColor
        radius: 16
        border.color: activeWidget === 2 ? "transparent" : cardBorderColor
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

        // ==========================================
        // 背景特效：全屏时显示毛玻璃封面
        // ==========================================
        Item {
            anchors.fill: parent
            opacity: activeWidget === 2 ? 1 : 0
            visible: opacity > 0
            Behavior on opacity {
                NumberAnimation { duration: 400 }
            }
            
            // 底图
            Image {
                id: bgCoverImg
                source: musicCoverPath
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                visible: false
            }
            // 毛玻璃
            FastBlur {
                anchors.fill: parent
                source: bgCoverImg
                radius: 64
                transparentBorder: false
            }
            // 半透明黑遮罩加深质感
            Rectangle {
                anchors.fill: parent
                color: "#99000000"
            }
        }

        MouseArea {
            anchors.fill: parent
            z: 0
            onClicked: activeWidget = activeWidget === 0 ? 2 : 0
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
                        color: musicIsPlaying ? "#3A3A3C" : "#FFFFFF"
                        Image {
                            source: musicIsPlaying ? "qrc:/icons/music_icons/pause.png" : "qrc:/icons/music_icons/playing.png"
                            anchors.centerIn: parent
                            width: 20
                            height: 20
                            fillMode: Image.PreserveAspectFit
                            visible: status === Image.Ready
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                musicIsPlaying = !musicIsPlaying;
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
                            source: "qrc:/icons/music_icons/next.png"
                            anchors.centerIn: parent
                            width: 24
                            height: 24
                            fillMode: Image.PreserveAspectFit
                            visible: status === Image.Ready
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                playSong((currentSongIndex + 1) % playlistModel.count);
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
                        Rectangle {
                            Layout.preferredWidth: 36
                            Layout.preferredHeight: 36
                            radius: 18
                            color: "#3A3A3C"
                            Image {
                                source: "qrc:/icons/music_icons/setting.png"
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                fillMode: Image.PreserveAspectFit
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse.accepted = true
                                onPressed: parent.opacity = 0.6
                                onReleased: parent.opacity = 1.0
                            }
                        }
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
                                musicElapsedSec = (value / 100) * musicDurationSec;
                            }

                            background: Rectangle {
                                x: fullSlider.leftPadding
                                // ?? 核心魔法：底槽的 Y 轴绝对垂直居中公式
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
                                // ?? 核心魔法：圆圈的 Y 轴公式，必须跟上面底槽的公式【一模一样】！
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
                                source: "qrc:/icons/music_icons/playmodel30.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: 24
                                height: 24
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
                                source: "qrc:/icons/music_icons/previous2.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: 44
                                height: 44
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var prevIndex = currentSongIndex - 1 < 0 ? playlistModel.count - 1 : currentSongIndex - 1;
                                    playSong(prevIndex);
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
                            color: musicIsPlaying ? "#2C2C2E" : "#FFFFFF"
                            // 外发光
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                color: musicIsPlaying ? "#00000000" : "#40FFFFFF"
                                radius: 10
                                samples: 21
                            }
                            Image {
                                source: musicIsPlaying ? "qrc:/icons/music_icons/pause.png" : "qrc:/icons/music_icons/playing.png"
                                anchors.centerIn: parent
                                width: 40
                                height: 40
                                fillMode: Image.PreserveAspectFit
                                visible: status === Image.Ready
                                // 根据深浅模式调整图标颜色，白色圆底用黑色图标，黑底用白图标
                                // 但目前图标是现成的 PNG，我们默认它们能融洽显示，如果不能可以通过 ColorOverlay 调整（为了避免不支持先保留）
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    musicIsPlaying = !musicIsPlaying;
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
                                source: "qrc:/icons/music_icons/next.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: 44
                                height: 44
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    playSong((currentSongIndex + 1) % playlistModel.count);
                                    mouse.accepted = true;
                                }
                                onPressed: parent.scale = 0.85
                                onReleased: parent.scale = 1.0
                                Behavior on scale { NumberAnimation { duration: 150 } }
                            }
                        }
                        
                        // 列表循环
                        Item {
                            Layout.preferredWidth: 44
                            Layout.preferredHeight: 44
                            opacity: 0.7
                            Image {
                                source: "qrc:/icons/music_icons/playmodel10.png"
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                width: 24
                                height: 24
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mouse.accepted = true
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
                        source: "qrc:/icons/music_icons/playList.png"
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        opacity: 0.8
                    }

                    Text {
                        text: "待播清单"
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        color: "white"
                        Layout.fillWidth: true
                    }
                }

                // 包含歌曲信息的 ListModel，增加了时长字段
                ListModel {
                    id: playlistModel
                    ListElement {
                        songName: "Starboy"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list1.jpg"
                        durationSec: 230
                    }
                    ListElement {
                        songName: "Save Your Tears"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list2.jpg"
                        durationSec: 215
                    }
                    ListElement {
                        songName: "Die For You"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list3.jpg"
                        durationSec: 260
                    }
                    ListElement {
                        songName: "Out of Time"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list4.jpg"
                        durationSec: 214
                    }
                    ListElement {
                        songName: "Less Than Zero"
                        artistName: "The Weeknd"
                        coverImg: "qrc:/icons/list5.jpg"
                        durationSec: 211
                    }
                }

                ListView {
                    anchors.top: listHeader.bottom
                    anchors.topMargin: 24
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    clip: true
                    spacing: 8
                    model: playlistModel
                    delegate: Rectangle {
                        width: parent.width
                        height: 60
                        radius: 10

                        // 当前播放的歌曲底色微亮
                        property bool isCurrent: index === currentSongIndex
                        color: isCurrent ? "#2C2C2E" : (itemMouseArea.pressed ? "#3A3A3C" : "transparent")
                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 16

                            // 左侧封面 or 动画占位
                            Rectangle {
                                Layout.preferredWidth: 44
                                Layout.preferredHeight: 44
                                radius: 6
                                color: "#2C2C2E"
                                clip: true

                                // 封面图
                                Image {
                                    source: coverImg
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectCrop
                                    visible: status === Image.Ready
                                    opacity: isCurrent ? 0.4 : 1.0 // 播放时封面变暗，凸显上面的图标
                                }

                                // 正在播放的特效 (简单文字模拟声波，可用 Lottie 替代)
                                Image {
                                    source: "qrc:/icons/music_icons/listen.png"
                                    width: 16
                                    height: 16
                                    fillMode: Image.PreserveAspectFit
                                    visible: isCurrent && musicIsPlaying
                                    anchors.centerIn: parent
                                }
                                Image {
                                    source: "qrc:/icons/music_icons/pause.png"
                                    width: 16
                                    height: 16
                                    fillMode: Image.PreserveAspectFit
                                    anchors.centerIn: parent
                                    visible: isCurrent && !musicIsPlaying
                                }
                            }

                            // 居中严格对齐的文字信息
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text {
                                    text: songName
                                    color: isCurrent ? themeColor : "#FFFFFF" // 播放中显示主题色(粉色)
                                    font.pixelSize: 16
                                    font.weight: isCurrent ? Font.Bold : Font.Medium
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: artistName
                                    color: "#8E8E93"
                                    font.pixelSize: 14
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }

                            // 右侧时间/拖动占位
                            Text {
                                text: formatTime(durationSec)
                                color: "#8E8E93"
                                font.pixelSize: 14
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        MouseArea {
                            id: itemMouseArea
                            anchors.fill: parent
                            onClicked: {
                                if (currentSongIndex === index) {
                                    musicIsPlaying = !musicIsPlaying; // 点击正在播放的歌曲则暂停/继续
                                } else {
                                    playSong(index); // 点击其他歌曲直接切换
                                }
                                mouse.accepted = true;
                            }
                        }
                    }
                }
            }
        }
    }

    // ----------------------
    // 3. 天气模块 (保持不变)
    // ----------------------
    Rectangle {
        id: weatherWidgetContainer
        radius: 16
        clip: true
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomSafeMargin + paddingVal
        anchors.rightMargin: paddingVal
        anchors.leftMargin: activeWidget === 3 ? paddingVal : (parent.width / 2 + cardSpacing / 2)
        height: activeWidget === 3 ? (parent.height - topSafeMargin - bottomSafeMargin - paddingVal * 2) : bottomWidgetHeight
        opacity: activeWidget === 0 || activeWidget === 3 ? 1 : 0
        visible: opacity > 0
        z: activeWidget === 3 ? 99 : 1
        Behavior on anchors.leftMargin {
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

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(parent.width, parent.height)
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#2E335A"
                }
                GradientStop {
                    position: 1.0
                    color: "#1C1B33"
                }
            }
        }
        Rectangle {
            anchors.fill: parent
            radius: 16
            color: "transparent"
            border.color: "#40FFFFFF"
            border.width: 1
        }

        MouseArea {
            anchors.fill: parent
            onClicked: activeWidget = activeWidget === 0 ? 3 : 0
        }

        Item {
            anchors.fill: parent
            anchors.margins: 24
            ColumnLayout {
                anchors.top: parent.top
                anchors.left: parent.left
                spacing: 4
                Text {
                    text: weatherCity
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    color: "white"
                }
                Text {
                    text: weatherDate
                    font.pixelSize: 14
                    color: "#EBEBF5"
                    opacity: 0.6
                }
            }
            Item {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: activeWidget === 3 ? 40 : 10
                width: activeWidget === 3 ? 160 : 80
                height: width
                Behavior on width {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutBack
                    }
                }
                Image {
                    source: weatherIconPath
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: width
                    fillMode: Image.PreserveAspectFit
                    visible: status === Image.Ready
                }
                Text {
                    text: "?"
                    font.pixelSize: parent.width * 0.8
                    anchors.centerIn: parent
                    visible: !parent.children[0].visible
                }
            }
            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                spacing: -4
                Text {
                    text: weatherTemp
                    font.pixelSize: activeWidget === 3 ? 96 : 64
                    font.weight: Font.Light
                    color: "white"
                    Behavior on font.pixelSize {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.InOutQuart
                        }
                    }
                }
                Text {
                    text: weatherCondition + " ? " + weatherHighLow
                    font.pixelSize: 16
                    color: "#EBEBF5"
                    opacity: 0.6
                }
            }
        }
    }


// ==========================================
    // ?? 全屏应用动态加载器 (核心魔法)
    // ==========================================
    Loader {
        id: dynamicAppLoader
        z: 99 // 保证加载出来的App盖在最上面
        
        // 占据整个右侧操作区，预留安全边距
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: topSafeMargin + paddingVal
        anchors.bottomMargin: bottomSafeMargin + paddingVal
        anchors.leftMargin: paddingVal
        anchors.rightMargin: paddingVal

        // 【内存控制】：只有点击了这四个应用时，才激活加载！
        // 2=音乐, 4=电话, 6=蓝牙, 7=记录仪
        active: activeWidget === 2 || activeWidget === 4 || activeWidget === 6 || activeWidget === 7

        // 【路径配置】：根据 activeWidget 动态返回对应的文件路径
        // 注意：如果你使用了 Qt 资源文件(qrc)，路径前面通常需要加 "qrc:/"
        source: {
            switch(activeWidget) {
                case 2: return "qrc:/Apps/MusicApp.qml"
                case 4: return "qrc:/Apps/PhoneApp.qml"
                case 6: return "qrc:/Apps/BluetoothApp.qml"
                case 7: return "qrc:/Apps/DashcamApp.qml"
                default: return ""
            }
        }

        // 【丝滑动画】：App 加载完成后，做一个 300ms 的淡入效果
        opacity: status === Loader.Ready ? 1 : 0
        Behavior on opacity { 
            NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } 
        }

        // 【信号连接】：监听被加载的独立 App 内部发出的退出信号
        Connections {
            // target 指向 Loader 内部实际加载出来的那个 QML 根节点
            target: dynamicAppLoader.item 
            
            // 忽略由于 Loader 尚未加载完成或切换瞬间导致的未知信号报错
            ignoreUnknownSignals: true 

            // 当内部 App 调用 rootApp.requestClose() 时，这里就会收到信号
            onRequestClose: {
                // 收到关闭信号，把状态改回 0 (分屏主页)
                // 这时 active 会变成 false，刚才的 App 就会被彻底从内存中销毁！
                activeWidget = 0; 
            }
        }
    }
}

