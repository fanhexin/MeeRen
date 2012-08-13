#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QSettings *setting, QObject *parent = 0);
    
signals:
    
public slots:
    QVariant value(const QString &key);
    void setValue(const QString &key, const QVariant &value);
    void clear();
private:
    QSettings *m_setting;
};

#endif // SETTINGS_H
