import QtQuick 2.7
import QtQuick.Controls.Styles 1.4 as QuickStyles
import WGTools.Views.Details 1.0 as Details

QuickStyles.TreeViewStyle {
	id: style

	// ScrollViewStyle ====================================
	ScrollViewStyle {
		id: scrollViewStyle
		scrollBarBackgroundColor: style.backgroundColor
	}

	minimumHandleLength: scrollViewStyle.minimumHandleLength
	scrollToClickedPosition: scrollViewStyle.scrollToClickedPosition
	transientScrollBars: scrollViewStyle.transientScrollBars
	
	corner: scrollViewStyle.corner
	incrementControl: scrollViewStyle.incrementControl
	decrementControl: scrollViewStyle.decrementControl
	handle: scrollViewStyle.handle
	scrollBarBackground: scrollViewStyle.scrollBarBackground
	frame: scrollViewStyle.frame

	// TreeViewStyle ======================================
	indentation: ViewsSettings.treeViewIndentation
	
	alternateBackgroundColor: _palette.color8
	backgroundColor: _palette.color8
	textColor: _palette.color1
	highlightedTextColor: _palette.color1

	branchDelegate: Details.BranchDelegate {}
	rowDelegate: Details.RowDelegate {
		active: style.control.activeFocus
	}
	headerDelegate: Details.TableViewHeader {
		view: style.control
	}
}
