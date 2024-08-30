import QtQuick 2.7
import QtQuick.Controls.Styles 1.4 as QuickStyles
import WGTools.Views.Details 1.0 as Details

QuickStyles.TableViewStyle {
	id: style

	// ScrollViewStyle ====================================
	ScrollViewStyle { id: scrollViewStyle }

	minimumHandleLength: scrollViewStyle.minimumHandleLength
	scrollToClickedPosition: scrollViewStyle.scrollToClickedPosition
	transientScrollBars: scrollViewStyle.transientScrollBars
	
	corner: scrollViewStyle.corner
	incrementControl: scrollViewStyle.incrementControl
	decrementControl: scrollViewStyle.decrementControl
	handle: scrollViewStyle.handle
	scrollBarBackground: scrollViewStyle.scrollBarBackground
	frame: scrollViewStyle.frame

	// TableViewStyle =====================================
	alternateBackgroundColor: _palette.color8
	backgroundColor: _palette.color8
	highlightedTextColor: _palette.color1
	textColor: _palette.color1

	rowDelegate: Details.RowDelegate {
		active: style.control.activeFocus
	}
	headerDelegate: Details.TableViewHeader {
		view: style.control
	}
}
