import QtQuick 2.11
import QtQuick.Controls 1.4 as C1
import QtQuick.Layouts 1.3
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Views 1.0 as Views
import WGTools.Views.Details 1.0 as ViewDetails
import WGTools.Controls 2.0

import "./Buttons" as Buttons
import "../SequenceTimeline/Tree" as STTree
import "../SequenceTimeline/Constants.js" as Constants

import WGTools.Debug 1.0

ControlsEx.Panel {
	property bool hasGraph: context ? context.hasFile : false

	id: panel
	title: "State Machine"
	anchors.fill: parent

	layoutHint: "bottom"

	C1.SplitView {
		id: content
		anchors.fill: parent
		visible: panel.hasGraph
		clip: true

		ColumnLayout {
			spacing: 0
			RowLayout {
				Layout.margins: 3
				Layout.bottomMargin: 2
				Layout.fillWidth: true
				spacing: 1
				Buttons.CreateButton {}
				Buttons.OpenButton {}
				Buttons.SaveButton {}
			}
			
			Rectangle {
				implicitHeight: Constants.rowHeight
				Layout.fillWidth: true
				color: _palette.color9

				STTree.TreeHeader {
					anchors.fill: parent
					labelText: "State Machine:"
					fileNameText: context.assetName
				}
			}

			Parameters {
				id: parameters
				implicitWidth: Constants.minTreeViewWidth
				Layout.fillWidth: true
			}
		}

		StateMachineView {
			id: graphView
			implicitWidth: parent.implicitWidth - parameters.implicitWidth
			anchors.fill: graphView
		}
	}

	Item {
		anchors.fill: parent
		clip: true

		visible: !panel.hasGraph

		EmptyPanel {
			visible: true
			anchors.centerIn: parent
		}
	}
}