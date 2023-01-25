pragma Singleton
import QtQuick 2.7
//see ePropertyFlags.h
QtObject
{
    readonly property int noFlags                  : 0x00
    readonly property int noUI                     : 0x01
    readonly property int noNetwork                : 0x02
    readonly property int noSerializeDisk          : 0x04
    readonly property int registerInGlobalStore    : 0x08
    readonly property int readOnly                 : 0x10
    readonly property int enumAsBitmask            : 0x20
}
