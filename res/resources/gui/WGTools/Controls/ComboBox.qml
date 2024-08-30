import QtQuick 2.11
import QtQuick.Templates 2.4 as T
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0 as Impl

T.ComboBox {
	id: control

	property string placeholderText
	property int autoReziseItemCount: 50 // due to performance purposes
	property bool highlightEnabled: true

	readonly property bool _indicatorVisible: indicator && indicator.visible

	implicitWidth: Math.max(
		background ? background.implicitWidth : 0,
		contentItem.implicitWidth + leftPadding + rightPadding)

	implicitHeight: Math.max(
		background ? background.implicitHeight : 0,
		Math.max(contentItem.implicitHeight,
				 indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

	baselineOffset: contentItem.y + contentItem.baselineOffset
	spacing: ControlsSettings.spacing
	padding: ControlsSettings.padding
	topPadding: ControlsSettings.smallPadding
	bottomPadding: ControlsSettings.smallPadding
	leftPadding: padding
	rightPadding: padding
		+ (_indicatorVisible ? indicator.width + spacing : 0)
		+ (separator.visible ? separator.width + spacing : 0)

	hoverEnabled: true

	font.family: ControlsSettings.fontFamily
	font.pixelSize: ControlsSettings.textNormalSize
	font.hintingPreference: Font.PreferFullHinting

	indicator: Details.ComboBoxIndicator {}
	contentItem: Details.ComboBoxContent {}
	background: Details.ComboBoxBackground {}
	delegate: Details.ComboBoxDelegate {}
	popup: Details.ComboBoxPopup {
		Binding on preferredWidth {
			when: control.popup.visible && control.count < autoReziseItemCount
			value: Impl.SizeCalculator.calcMaxImplicitWidth(control.delegateModel)
				+ control.popup.leftPadding
				+ control.popup.rightPadding
		}
	}

	Details.TextFieldSeparator {
		id: separator
		x: control.indicator.x - (width + control.spacing)
		visible: control.editable && control._indicatorVisible
	}

	Details.BackgroundBB {}
	Details.ContentItemBB {}
}
