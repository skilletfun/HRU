import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: root

    property string source: ''

    width: height
    background: Rectangle { radius: root.width/2; color: root.down ? '#e2e2e1' : root.hovered ? '#f4f4f4' : 'white' }
    display: Button.IconOnly
    padding: 0

    Image {
        anchors.fill: parent
        anchors.margins: 5
        source: root.source
        mipmap: true
    }
}
