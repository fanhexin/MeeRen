#include "settings.h"

Settings::Settings(QSettings *setting, QObject *parent) :
    QObject(parent),
    m_setting(setting)
{

}

QVariant Settings::value(const QString &key)
{
    return m_setting->value(key);
}

void Settings::setValue(const QString &key, const QVariant &value)
{
    m_setting->setValue(key, value);
}

void Settings::clear()
{
    m_setting->clear();
}
