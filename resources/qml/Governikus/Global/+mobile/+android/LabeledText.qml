import QtQuick 2.10

Item {
	property alias label: labelText.text
	property alias text: bodyText.text
	property alias textFormat: bodyText.textFormat
	property int margin
	property int fontUppercase

	signal linkActivated(string link)

	height: childrenRect.height + margin

	Text {
		id: bodyText
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.leftMargin: margin
		anchors.right: parent.right
		anchors.rightMargin: margin
		font.pixelSize: Constants.normal_font_size
		font.capitalization: fontUppercase
		color: Constants.secondary_text
		wrapMode: Text.WordWrap
		onLinkActivated: parent.linkActivated(link)
	}

	Text {
		id: labelText
		anchors.top: bodyText.bottom
		anchors.left: parent.left
		anchors.leftMargin: margin
		anchors.right: parent.right
		anchors.rightMargin: margin
		font.pixelSize: Constants.label_font_size
		color: Constants.blue
		wrapMode: Text.WordWrap
	}
}
