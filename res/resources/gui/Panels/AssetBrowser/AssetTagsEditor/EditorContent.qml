import QtQuick 2.10
import QtQuick.Layouts 1.3
import WGTools.Controls.Details 2.0
import "TagEdit" as Impl
import "TagView" as Impl

ColumnLayout {
	id: root
	spacing: ControlsSettings.spacing

	Impl.TagEdit {
		id: tagEdit
		model: control.backend.tagsModel

		Keys.priority: Keys.AfterItem
		Keys.forwardTo: [tagView]
		Layout.fillWidth: true;

		onTextChanged: {
			control.backend.hintModel.setPattern(text)
		}

		onTagClicked: {
			control.backend.deassignTag(tagName)
		}

		Connections {
			target: control.backend
			onTagAssigned: tagEdit.text = ""
		}

		Connections {
			target: control
			onAboutToShow: tagEdit.text = ""
		}
	}

	Impl.TagView {
		id: tagView
		model: control.backend.hintModel
		tagFilter: tagEdit.text
		canCreateTag: tagFilter.length && !control.backend.hasTag(tagFilter)

		onTagClicked: {
			control.backend.assignTag(tag)
		}

		onNewTagClicked: {
			var success = control.backend.createTag(tag, "0xFFFF00")
			if (success) {
				control.backend.assignTag(tag)
			}
		}

		Layout.fillWidth: true
		Layout.fillHeight: true
	}
}
