#ifndef MUSICCONTROLLER_H
#define MUSICCONTROLLER_H

#include <QObject>
#include <QString>

class MusicController : public QObject
{
    Q_OBJECT
    // 定义 QML 可以直接访问的属性
    Q_PROPERTY(bool isPlaying READ isPlaying WRITE setIsPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(int elapsedSec READ elapsedSec WRITE setElapsedSec NOTIFY elapsedSecChanged)
    Q_PROPERTY(int durationSec READ durationSec WRITE setDurationSec NOTIFY durationSecChanged)
    
    Q_PROPERTY(QString currentTitle READ currentTitle NOTIFY currentSongChanged)
    Q_PROPERTY(QString currentArtist READ currentArtist NOTIFY currentSongChanged)
    Q_PROPERTY(QString currentCover READ currentCover NOTIFY currentSongChanged)

public:
    explicit MusicController(QObject *parent = nullptr);

    // Getters
    bool isPlaying() const { return m_isPlaying; }
    int elapsedSec() const { return m_elapsedSec; }
    int durationSec() const { return m_durationSec; }
    QString currentTitle() const { return m_currentTitle; }
    QString currentArtist() const { return m_currentArtist; }
    QString currentCover() const { return m_currentCover; }

    // Setters
    void setIsPlaying(bool playing);
    void setElapsedSec(int sec);
    void setDurationSec(int sec);

    // QML 可以直接调用的函数 (用 Q_INVOKABLE 修饰)
    Q_INVOKABLE void playSong(int index);
    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void seek(int seconds);
    Q_INVOKABLE void next();
    Q_INVOKABLE void prev();

signals:
    // 状态改变时发射的信号，QML 监听到后会自动刷新 UI
    void isPlayingChanged();
    void elapsedSecChanged();
    void durationSecChanged();
    void currentSongChanged();

private:
    bool m_isPlaying = false;
    int m_elapsedSec = 0;
    int m_durationSec = 0;
    QString m_currentTitle;
    QString m_currentArtist;
    QString m_currentCover;
    
    // 这里未来可以引入真实的播放器实例，例如：
    // QMediaPlayer *m_player; 
};

#endif // MUSICCONTROLLER_H