#include "../CPP/MusicController.h"
#include <QDebug>
#include <QTimer>
#include <QCoreApplication>
#include <QFile>

MusicController::MusicController(QObject *parent)
    : QObject(parent)
    , m_isPlaying(false), m_title(""), m_artist(""), m_durationSec(0), m_elapsedSec(0), m_coverPath("qrc:/icons/default_cover.jpg"), m_currentLyric("")
{
    m_trackRegex = QRegularExpression(R"(track\[([^\]]+)\]-\[([^\]]+)\])");
    m_positionRegex = QRegularExpression(R"(\[(\d+)-(\d+)\])");

    m_process = new QProcess(this);
    m_process->setProcessChannelMode(QProcess::MergedChannels);

    connect(m_process, &QProcess::readyReadStandardOutput, this, &MusicController::onProcessReadyRead);
    connect(m_process, &QProcess::errorOccurred, this, &MusicController::onProcessError);

    QStringList args;
    args << "BT";
    
    // 我们尝试调用底层的应用，如果失败，我们会注入假数据模拟环境以保证你在VM里能看见效果
    m_process->start("/userdata/rkwifibt_app_test", args);

    if (!m_process->waitForStarted(1500)) {
        qWarning() << "rkwifibt_app_test 启动失败！这说明你目前正在虚拟机/x86环境中。正在切入[模拟测试模式]...";
        m_title = "虚拟机演示歌曲";
        m_artist = "开源测试者";
        m_currentLyric = "测试歌词：你正在虚拟机中调试";
        m_durationSec = 220;
        m_elapsedSec = 60;
        
        QTimer *mockTimer = new QTimer(this);
        connect(mockTimer, &QTimer::timeout, this, [this]() {
            if (m_isPlaying) {
                m_elapsedSec++;
                if (m_elapsedSec % 5 == 0) {
                    m_currentLyric = "测试歌词行：" + QString::number(m_elapsedSec) + "秒";
                    emit currentLyricChanged();
                }
                emit elapsedSecChanged();
            }
        });
        mockTimer->start(1000);
    } else {
        qDebug() << "rkwifibt_app_test 已成功启动，PID:" << m_process->processId();
        
        // 参照开源项目：延迟 1s 后发送命令 "1" 去开启原厂的隐藏蓝牙后台服务模式
        QTimer::singleShot(1000, this, [this]() {
            if (m_process->state() == QProcess::Running) {
                m_process->write("1\n");
                // m_process->waitForBytesWritten();
            }
        });
    }
}

MusicController::~MusicController() {
    if (m_process && m_process->state() == QProcess::Running) {
        m_process->terminate();
        m_process->waitForFinished(2000);
        m_process->kill();
    }
}

// ======================== QML 控制接口 ========================
// 提示：rkwifibt_app_test 通过标准输入写入具体命令即可控制蓝牙操作
// 这里作为参考占位，你可以阅读 SDK/external/rkwifibt 查找它的实际切歌命令进行替换即可
void MusicController::togglePlayPause() {
    m_isPlaying = !m_isPlaying;
    emit isPlayingChanged();
    
    if (m_process->state() == QProcess::Running) {
        // 假设 "2" 是播放/暂停命令 (具体根据SDK填入)
        // m_process->write("2\n");
    }
}

void MusicController::playNext() {
    if (m_process->state() == QProcess::Running) {
        // 假设 "3" 是下一首命令
        // m_process->write("3\n");
    }
}

void MusicController::playPrevious() {
    if (m_process->state() == QProcess::Running) {
        // 假设 "4" 是上一首命令
        // m_process->write("4\n");
    }
}

void MusicController::seekTo(int seconds) {
    // 假设 AVRCP 控制端如果不支持拖动，则可以忽略此命令
}

// ======================== 日志与正则解析 ========================
void MusicController::onProcessReadyRead() {
    QByteArray data = m_process->readAllStandardOutput();
    if (!data.isEmpty()) {
        parseOutput(QString::fromLocal8Bit(data));
    }
}

void MusicController::onProcessError() {
    qWarning() << "后台进程出现异常错误: " << m_process->errorString();
}

void MusicController::parseOutput(const QString &output) {
    QStringList lines = output.split('\n', Qt::SkipEmptyParts);
    for (const QString &line : lines) {
        QString trimmed = line.trimmed();
        // 1. 匹配音乐名/歌词及歌手信息
        if (trimmed.contains("track[")) {
            extractTrackInfo(trimmed);
        }
        // 2. 匹配进度
        else if (trimmed.contains(m_positionRegex)) {
            extractPositionInfo(trimmed);
        }
        // 3. 匹配播放与暂停状态
        else if (trimmed.contains("PLAYER PLAYING") || trimmed.contains("PLAYER PAUSE")) {
            extractStateInfo(trimmed);
        }
    }
}

void MusicController::extractTrackInfo(const QString &line) {
    QRegularExpressionMatch match = m_trackRegex.match(line);
    if (match.hasMatch()) {
        QString parsedTrackOrLyric = match.captured(1);
        QString parsedArtist = match.captured(2);
        
        // 核心理念：如果歌曲作者没变，但是 "Track" 变了，说明我们在接收滚动歌词
        if (m_artist == parsedArtist && m_title != "" && m_title != parsedTrackOrLyric) {
            if (m_currentLyric != parsedTrackOrLyric) {
                m_currentLyric = parsedTrackOrLyric;
                emit currentLyricChanged();
            }
        } 
        else {
            // 这是新的一首歌
            m_title = parsedTrackOrLyric;
            m_artist = parsedArtist;
            m_currentLyric = "正在解析歌词/准备下一句..."; // 重置歌词
            
            emit titleChanged();
            emit artistChanged();
            emit currentLyricChanged();
        }
    }
}

void MusicController::extractPositionInfo(const QString &line) {
    QRegularExpressionMatch match = m_positionRegex.match(line);
    if (match.hasMatch()) {
        // 原项目给的单位是 毫秒(ms)，由于我们的 QML 绑定的都是 秒(Sec)，这里需要除以 1000
        int newElapsedSec = match.captured(1).toInt() / 1000;
        int newDurationSec = match.captured(2).toInt() / 1000;
        
        if (m_elapsedSec != newElapsedSec) {
            m_elapsedSec = newElapsedSec;
            emit elapsedSecChanged();
        }
        if (m_durationSec != newDurationSec) {
            m_durationSec = newDurationSec;
            emit durationSecChanged();
        }
    }
}

void MusicController::extractStateInfo(const QString &line) {
    bool isPlay = line.contains("PLAYER PLAYING");
    if (m_isPlaying != isPlay) {
        m_isPlaying = isPlay;
        emit isPlayingChanged();
    }
}
