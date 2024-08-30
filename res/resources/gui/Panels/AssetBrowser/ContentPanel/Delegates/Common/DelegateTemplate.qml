import QtQuick 2.7

Item {
	id: root

	property Item icon
	property Item desc
	property Item background

	property int orientation: Qt.Vertical
	property real backgroundPadding: 0
	property real padding: 0
	property real spacing: 0

	readonly property real availableWidth: width - padding*2
	readonly property real availableHeight: height - padding*2

	readonly property real _iconSize: (typeof iconSize != "undefined") ? iconSize : 0
	readonly property real _minIconSize: (typeof minIconSize != "undefined") ? minIconSize : 0

	implicitWidth: (icon || desc)
		? (orientation == Qt.Vertical)
			? _iconSize ? _iconSize + padding*2 : 0
			: (icon ? icon.implicitWidth : 0) +
			  (desc ? desc.implicitWidth : 0) +
			  (icon && desc ? spacing : 0) + padding*2
		: 0
	implicitHeight: (icon || desc)
		? (orientation == Qt.Vertical)
			? (icon ? icon.implicitHeight : 0) +
			  (desc ? desc.implicitHeight : 0) +
			  (icon && desc ? spacing : 0) + padding*2
			: Math.max(
				(icon ? icon.implicitHeight : 0),
				(desc ? desc.implicitHeight : 0)) + padding*2
		: 0

	Connections {
		function adjustIcon() {
			if (root.icon)
			{
				root.icon.parent = root
				root.icon.implicitWidth = Qt.binding(function() { return root._iconSize })
				root.icon.implicitHeight = Qt.binding(function() { return root._iconSize })
				root.icon.width = Qt.binding(function()
				{
					if (root.orientation == Qt.Vertical)
						return root.availableWidth
					else
						return root.availableHeight
				})

				root.icon.height = Qt.binding(function()
				{
					if (root.orientation == Qt.Vertical)
						return root.availableWidth
					else
						return root.availableHeight
				})

				root.icon.x = Qt.binding(function() { return root.padding })
				root.icon.y = Qt.binding(function() { return root.padding })
				root.icon.z = 1
			}
		}

		function adjustDesc() {
			if (root.desc)
			{
				root.desc.parent = root
				root.desc.implicitWidth = Qt.binding(function() { return root._iconSize })
				root.desc.width = Qt.binding(function()
				{
					if (root.orientation == Qt.Vertical || root.icon == null)
						return root.availableWidth
					else
						return root.availableWidth - root.icon.width - root.spacing
				})

				root.desc.height = Qt.binding(function()
				{
					if (root.orientation == Qt.Vertical || root.icon == null)
						return root.availableHeight - root.icon.height - root.spacing
					else
						return root.availableHeight
				})

				root.desc.x = Qt.binding(function()
				{
					if (root.orientation == Qt.Vertical || root.icon == null)
						return root.padding
					else
						return root.padding + root.icon.width + root.spacing
				})

				root.desc.y = Qt.binding(function()
				{
					if (root.orientation == Qt.Vertical || root.icon == null)
						return root.height - root.padding - this.height
					else
						return root.padding
				})

				root.desc.z = 1
			}
		}

		function adjustBackground() {
			if (root.background)
			{
				root.background.parent = root
				root.background.width = Qt.binding(function() { return root.width - root.backgroundPadding*2 })
				root.background.height = Qt.binding(function() { return root.height - root.backgroundPadding*2 })
				root.background.x = Qt.binding(function() { return root.backgroundPadding })
				root.background.y = Qt.binding(function() { return root.backgroundPadding })
				root.background.z = 0
			}
		}

		onIconChanged: adjustIcon()
		onDescChanged: adjustDesc()
		onBackgroundChanged: adjustBackground()

		Component.onCompleted: {
			adjustIcon()
			adjustDesc()
			adjustBackground()
		}
	}

	// Rectangle { anchors.fill: parent; border.width: 1; border.color: "green"; color: "transparent"; z: 100 }
}
