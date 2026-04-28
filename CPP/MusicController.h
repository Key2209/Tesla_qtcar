#ifndef MUSICCONTROLLER_H
#define MUSICCONTROLLER_H

#include <QObject>
#include <QString>
#include <QProcess>
#include <QRegularExpression>

class MusicController : public QObject
{
    Q_OBJECT
    // 供QML绑定的属性
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged)
    Q_PROPERTY(int durationSec READ durationSec NOTIFY durationSecChanged)
    Q_PROPERTY(int elapsedSec READ elapsedSec NOTIFY elapsedSecChanged)
    Q_PROPERTY(QString coverPath READ coverPath NOTIFY coverPathChanged)
    Q_PROPERTY(QString currentLyric READ currentLyric NOTIFY currentLyricChanged)

public:
    explicit MusicController(QObject *parent = nullptr);
    ~MusicController();

    // 属性 Getters
    bool isPlaying() const { return m_isPlaying; }
    QString title() const { return m_title; }
    QString artist() const { return m_artist; }
    int durationSec() const { return m_durationSec; }
    int elapsedSec() const { return m_elapsedSec; }
    QString coverPath() const { return m_coverPath; }
    QString currentLyric() const { return m_currentLyric; }

    // 供QML调用的控制接口
    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void playNext();
    Q_INVOKABLE void playPrevious();
    Q_INVOKABLE void seekTo(int seconds);

signals:
    // 属性变更信号（驱动QML刷新）
    void isPlayingChanged();
    void titleChanged();
    void artistChanged();
    void durationSecChanged();
    void elapsedSecChanged();
    void coverPathChanged();
    void currentLyricChanged();

private slots:
    // 处理底层进程发来的终端输出
    void onProcessReadyRead();
    void onProcessError();

private:
    void parseOutput(const QString &output);
    void extractTrackInfo(const QString &line);
    void extractPositionInfo(const QString &line);
    void extractStateInfo(const QString &line);

    // 内部状态
    bool m_isPlaying;
    QString m_title;
    QString m_artist;
    int m_durationSec;
    int m_elapsedSec;
    QString m_coverPath;
    QString m_currentLyric;

    // 进程与正则
    QProcess *m_process;
    QRegularExpression m_trackRegex;
    QRegularExpression m_positionRegex;
};

#endif // MUSICCONTROLLER_H