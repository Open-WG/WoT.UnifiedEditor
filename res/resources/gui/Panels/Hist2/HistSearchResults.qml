import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.11
import WGTools.Misc 1.0 as Misc
import WGTools.HIST 1.0 as Hist
import "Details/SearchResults" as Details

Item {
	Details.SearchResultsView {
		id: view
		model: context.filteredResults
		selectionMode: SelectionMode.ExtendedSelection
		selection: context.resultSelectionModel
		visible: context.controller.results.status == Hist.SearchStatus.HAS_RESULTS
		anchors.fill: parent

		onDoubleClicked: context.showAlgorithmInEditor(context.filteredResults.mapToSource(index))
	}

	ColumnLayout {
		visible: !view.visible
		anchors.centerIn: parent

		Image {
			source: "image://gui/model-validate-success"
			visible: context.controller.results.status == Hist.SearchStatus.ALL_FIXED
			Layout.alignment: Qt.AlignHCenter
			Layout.preferredWidth: 84
			Layout.preferredHeight: 84
		}

		Misc.Text {
			text: "All Objects Fixed"
			visible: context.controller.results.status == Hist.SearchStatus.ALL_FIXED
			Layout.alignment: Qt.AlignHCenter
		}

		Image {
			source: "image://gui/magnifier"
			visible: context.controller.results.status == Hist.SearchStatus.NOT_FOUND
			Layout.alignment: Qt.AlignHCenter
			Layout.preferredWidth: 120
			Layout.preferredHeight: 77
		}

		Misc.Text {
			text: "Nothing Found"
			visible: context.controller.results.status == Hist.SearchStatus.NOT_FOUND
			Layout.alignment: Qt.AlignHCenter
		}
	}
}
