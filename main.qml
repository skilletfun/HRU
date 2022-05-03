import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1


Window {
    id: root
    width: 900
    height: 600
    visible: true
    title: qsTr("HRU")

    property string current_state: 'auth'
    property string current_user: ''

    Rectangle {
        id: auth_rect
        anchors.fill: parent
        visible: root.current_state == 'auth' ? true : false

        Text {
            id: auth_lbl
            text: 'Авторизация'
            font.bold: true
            font.pointSize: 24
            anchors.horizontalCenter: user_field.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 130
        }

        TextField {
            id: user_field
            height: 60
            width: parent.width/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: auth_lbl.bottom
            anchors.topMargin: 30
            font.pixelSize: height/3
            placeholderText: 'Логин'
            selectByMouse: true
            background: Rectangle { border.width: 2; border.color: user_field.focus ? 'green' : 'grey' }
            onAccepted: { focus = false; }
        }

        TextField {
            id: password_field
            echoMode: TextInput.Password
            height: 60
            width: parent.width/2
            anchors.top: user_field.bottom
            anchors.horizontalCenter: user_field.horizontalCenter
            anchors.topMargin: 30
            selectByMouse: true
            placeholderText: 'Пароль'
            font.pixelSize: height/3
            background: Rectangle { border.width: 2; border.color: password_field.focus ? 'green' : 'grey' }
            onAccepted: { focus = false; }
        }

        Button {
            id: login
            enabled: user_field.text != '' && password_field.text != ''
            height: 60
            width: parent.width/2
            anchors.top: password_field.bottom
            anchors.horizontalCenter: user_field.horizontalCenter
            anchors.topMargin: 30
            font.pixelSize: height/3
            text: 'Войти'
            onReleased: {
                if (user_field.text === 'admin' && password_field.text === 'admin')
                    root.current_state = 'admin';
                else
                {
                    for (var i = 0; i < users.count; i++)
                    {
                        if (user_field.text === users.get(i).login && password_field.text === users.get(i).password)
                        {
                            root.current_state = 'user';
                            root.current_user = users.get(i).login;
                            user_field.clear();
                            password_field.clear();
                            break;
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: admin
        anchors.fill: parent
        visible: root.current_state == 'admin' ? true : false

        Column {
            id: column_btns

            anchors.top: parent.top
            anchors.topMargin: 125
            anchors.left: parent.left
            anchors.leftMargin: 50
            anchors.bottom: parent.bottom
            spacing: 20

            IconButton {
                id: add_btn
                source: 'add.png'
                height: 50
                onReleased: { popup_add_user.open(); }
            }
            IconButton {
                id: del_btn
                source: 'remove.png'
                height: 50
                onReleased: { remove_user(users_combobox.currentText); }
            }
            IconButton {
                id: apply_btn
                source: 'checked.png'
                height: 50
                onReleased: { apply_user_files(users_combobox.currentText); }
            }
            IconButton {
                id: matrix_btn
                source: 'matrix.png'
                height: 50
                onReleased: { matrix_access.visible = true; }
            }
            IconButton {
                id: exit_btn
                source: 'logout.png'
                height: 50
                onReleased: { root.current_state = 'auth'; }
            }
        }

        Popup {
            id: popup_add_user
            anchors.centerIn: parent
            background: Rectangle { color: '#f7f7f8' }

            height: parent.height * 0.5
            width: parent.width * 0.5
            modal: true

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
            }

            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
            }

            Column {
                anchors.fill: parent
                anchors.topMargin: 30
                spacing: 25

                TextField {
                    id: login_field_new
                    height: 60
                    width: parent.width/2
                    placeholderText: 'Логин'
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: height/3
                    background: Rectangle { border.width: 2; border.color: login_field_new.focus ? 'green' : 'grey' }
                    onAccepted: { focus = false; }
                }
                TextField {
                    id: password_field_new
                    height: 60
                    width: parent.width/2
                    placeholderText: 'Пароль'
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: height/3
                    background: Rectangle { border.width: 2; border.color: password_field_new.focus ? 'green' : 'grey' }
                    onAccepted: { focus = false; }
                }

                Button {
                    id: add_user_btn
                    enabled: login_field_new.text != '' && password_field_new.text != ''
                    height: 60
                    width: parent.width/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 30
                    font.pixelSize: height/3
                    text: 'Добавить'
                    onReleased: {
                        add_user(login_field_new.text, password_field_new.text);
                        login_field_new.clear();
                        password_field_new.clear();
                    }
                }
            }
        }

        ComboBox {
            id: users_combobox
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.horizontalCenter: settings.horizontalCenter
            height: 50
            width: parent.width/3
            textRole: 'login'
            font.pointSize: height/3
            model: users
            onCurrentTextChanged: { get_user_files(currentText); }
        }

        ListView {
            id: settings
            visible: users_combobox.currentText == '' ? false : true

            clip: true
            width: parent.width / 1.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: users_combobox.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 50
            model: current_user_model

            spacing: 5

            delegate: Rectangle {
                height: 60
                width: settings.width

                Text {
                    id: _lbl
                    text: index >= 0 ? files.get(index).name : ''
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    CheckBox {
                        id: _r
                        checked: pr === '0' ? false : true
                        text: 'R'
                        font.pointSize: 16
                        onCheckedChanged: { current_user_model.setProperty(index, 'pr', checked ? '1' : '0'); }
                    }
                    CheckBox {
                        id: _w
                        text: 'W'
                        checked: pw === '0' ? false : true
                        font.pointSize: 16
                        onCheckedChanged: { current_user_model.setProperty(index, 'pw', checked ? '1' : '0'); }
                    }
                    CheckBox {
                        id: _x
                        text: 'X'
                        checked: px === '0' ? false : true
                        font.pointSize: 16
                        onCheckedChanged: { current_user_model.setProperty(index, 'px', checked ? '1' : '0'); }
                    }
                }
            }
        }
    }

    Rectangle {
        id: user
        visible: root.current_state == 'user' ? true : false
        anchors.fill: parent

        Text {
            id: lbl_
            text: 'Вы вошли как: ' + root.current_user
            font.bold: true
            font.pointSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 50
        }

        IconButton {
            id: exit_btn_view
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 45
            source: 'logout.png'
            height: 50
            onReleased: { root.current_state = 'auth'; }
        }

        ListView {
            id: view_access_files
            clip: true
            width: parent.width / 1.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: lbl_.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 50
            model: current_user_model

            spacing: 5

            delegate: Rectangle {
                visible: pw != '1' && pr != '1' && px != '1' ? false : true
                height: visible ? 60 : 0
                width: view_access_files.width

                Text {
                    id: __lbl
                    text: index >= 0 ? files.get(index).name : ''
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 16
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 35

                    CheckBox {
                        id: __r
                        enabled: false
                        checked: pr === '0' ? false : true
                        text: 'R'
                        font.pointSize: 16
                    }
                    CheckBox {
                        id: __w
                        enabled: false
                        text: 'W'
                        checked: pw === '0' ? false : true
                        font.pointSize: 16
                    }
                    CheckBox {
                        id: __x
                        enabled: false
                        text: 'X'
                        checked: px === '0' ? false : true
                        font.pointSize: 16
                    }
                }
            }
        }
    }

    ListModel {
        id: files

        ListElement {
            name: 'БОС_4_лаба.docx'
        }
        ListElement {
            name: 'Текстовый файл.txt'
        }
        ListElement {
            name: 'ЧМ Медведева.mp4'
        }
        ListElement {
            name: 'WIN32_TROJAN.exe'
        }
        ListElement {
            name: 'Протоколы ОИ.pdf'
        }
        ListElement {
            name: 'Exogenesis: Symphony.mp3'
        }
    }

    ListModel {
        id: users
    }

    ListModel {
        id: current_user_model
    }

    MessageDialog {
        id: messageDialog
        title: "Ошибка"
        text: "Пользователь уже существует."
        onAccepted: { close(); }
    }

    Window {
        id: matrix_access
        visible: false
        title: 'Матрица доступа'
        height: 600
        width: 940

        Rectangle {
            anchors.fill: parent
            anchors.margins: 25

            Row {
                id: title_row
                height: 30
                anchors.right: parent.right
                anchors.top: parent.top

                Repeater {
                    model: ['#', 'Логин : Пароль', '.docx', '.txt', '.mp4', '.exe', '.pdf', '.mp3']

                    delegate: Rectangle {
                        height: title_row.height
                        width: index == 1 ? 250 : 95

                        Rectangle {
                            visible: index > 0 ? true : false
                            height: parent.height
                            width: 2
                            anchors.left: parent.left
                            anchors.top: parent.top
                            color: 'black'
                        }

                        Text {
                            id: _typecolumn
                            anchors.centerIn: parent
                            font.pointSize: 14
                            text: modelData
                        }
                    }
                }
            }

            Rectangle {
                id: line
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: title_row.bottom
                height: 2
                color: 'black'
            }

            ListView {
                id: all_users_view
                anchors.top: line.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                clip: true

                model: users

                delegate: Rectangle {
                    id: all_users_rect
                    width: all_users_view.width
                    height: 30

                    property string _index: String(index+1)
                    property string loginpass: String(login + ' : ' + password)

                    Row {
                        id: _row
                        height: parent.height
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: [all_users_rect._index, all_users_rect.loginpass, file1, file2, file3, file4, file5, file6]

                            delegate: Rectangle {
                                height: all_users_rect.height
                                width: index == 1 ? 250 : 95

                                Rectangle {
                                    visible: index > 0 ? true : false
                                    height: parent.height
                                    width: 2
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    color: 'black'
                                }

                                Text {
                                    id: _typecolumn_all
                                    anchors.centerIn: parent
                                    font.pointSize: 14
                                    text: index == 0 || index == 1 ? modelData : to_normal_view(modelData)
                                }
                            }
                        }
                    }
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 1
                        color: 'grey'
                        anchors.bottom: parent.bottom
                    }
                }
            }
        }


    }

    function add_user(login, password)
    {
        var flag = true;
        for (var i = 0; i < users.count; i++)
        {
            if (users.get(i).login === login)
            {
                flag = false;
                break;
            }
        }
        if (login === 'admin') flag = false;
        if (flag) users.append({ login: login, password: password,
                                file1: '000', file2: '000', file3: '000', file4: '000', file5: '000', file6: '000' });
        else messageDialog.open();
    }

    function remove_user(login)
    {
        for (var i = 0; i < users.count; i++)
        {
            if (users.get(i).login === login){ users.remove(i); break; }
        }
    }

    function get_user_files(login)
    {
        for (var i = 0; i < users.count; i++)
        {
            if (users.get(i).login === login)
            {
                current_user_model.clear();
                var arr_files = ['file1', 'file2', 'file3', 'file4', 'file5', 'file6'];

                for (var el in arr_files)
                {
                    var f = users.get(i)[arr_files[el]];
                    current_user_model.append({pr: f[0], pw: f[1], px: f[2]});
                }
                break;
            }
        }
    }

    function apply_user_files(login)
    {
        var arr_files = ['file1', 'file2', 'file3', 'file4', 'file5', 'file6'];
        for (var i = 0; i < users.count; i++)
        {
            if (users.get(i).login === login)
            {
                for (var j = 0; j < current_user_model.count; j++)
                {
                    var value = current_user_model.get(j).pr + current_user_model.get(j).pw + current_user_model.get(j).px;
                    users.setProperty(i, arr_files[j], value);
                }

                break;
            }
        }
    }

    function to_normal_view(data)
    {
        var res = '';
        if (data[0] === '1') res = 'R';
        if (data[1] === '1') res = res + 'W';
        if (data[2] === '1') res = res + 'X';
        res = res.split('').join('/');

        if (res === '') res = '---';
        return res;
    }
}
