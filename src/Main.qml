import QtQuick 2.4
import QtQuick.Window 2.2
import U1db 1.0 as U1db
import Ubuntu.Components 1.3
import Ubuntu.Content 1.1
import "bookmarkletCreator.js" as BookmarkletCreator


Window {
    id: root
    visibility: Window.AutomaticVisibility

    width: units.gu(150)
    height: units.gu(100)
    property real margins: units.gu(2)

    MainView {
        id: mainView
        objectName: "mainView"
        applicationName: "share-to-diaspora.jaywink"

        automaticOrientation: true

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Page {
            id: appView
            title: i18n.tr("Share to diaspora*")

            property bool waitingPodDomain: false
            property variant transfer

            U1db.Database {
                id: configDb
                path: "config"
            }
            U1db.Document {
                id: config
                database: configDb
                docId: 'config'
                create: true
                defaults: { "podDomain": "" }
            }

            Column {
                id: pageLayout
                anchors {
                    fill: parent
                    margins: root.margins
                }
                spacing: units.gu(1)

                Row {
                    Text {
                        id: podDomainHelp
                        text: i18n.tr("Set pod domain, without 'https://'.")
                    }
                }

                Row {
                    TextField {
                        id: podDomain
                        width: pageLayout.width
                        text: config.contents.podDomain
                        inputMethodHints: Qt.ImhUrlCharactersOnly
                        hasClearButton: true
                    }
                }

                Row {
                    Button {
                        id: podDomainButton
                        text: i18n.tr("Save pod domain")
                        onClicked: {
                            var contents = config.contents;
                            contents.podDomain = podDomain.text.replace("https://", "").replace("http://", "")
                            config.contents = contents;
                            if (config.contents.podDomain !== "" && appView.waitingPodDomain) {
                                BookmarkletCreator.createBookmarklet(appView.transfer);
                            }
                        }
                    }
                }
            }

            Connections {
                target: ContentHub
                onShareRequested: {
                    if (config.contents.podDomain === "") {
                        // We need user to set podDomain first
                        podDomainHelp.text = i18n.tr("Please set pod domain first, without 'https://'.")
                        podDomainButton.text = i18n.tr("Save pod domain & share")
                        appView.waitingPodDomain = true;
                        appView.transfer = transfer;
                    } else {
                        podDomainHelp.destroy();
                        podDomain.destroy();
                        podDomainButton.destroy();
                        BookmarkletCreator.createBookmarklet(transfer);
                    }
                }
            }
        }
    }
}
