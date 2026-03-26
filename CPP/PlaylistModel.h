#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QString>

// 定义单首歌的数据结构
struct SongData {
    QString title;
    QString artist;
    QString coverPath;
    int durationSec;
};

class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT

public:
    // 定义 QML 中可以使用的角色名称 (例如 QML 里的 model.songName)
    enum SongRoles {
        TitleRole = Qt::UserRole + 1,
        ArtistRole,
        CoverRole,
        DurationRole
    };

    explicit PlaylistModel(QObject *parent = nullptr);

    // QAbstractListModel 必须重写的三个函数
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // 添加歌曲的接口
    void addSong(const SongData &song);

private:
    QList<SongData> m_playlist;
};

#endif // PLAYLISTMODEL_H