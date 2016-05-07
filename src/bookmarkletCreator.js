var component,
    bookmarklet;


function createBookmarklet(transfer) {
    component = Qt.createComponent("Bookmarklet.qml");
    bookmarklet = component.createObject(appView, {
        shareUrl: String(transfer.items[0].url),
        shareTitle: String(transfer.items[0].name)
    });
    if (bookmarklet == null) {
        console.log("Error creating object");
    }
}
