import QtQuick 2.11
import WGTools.Misc 1.0 as WGT

WGT.FilterResultPlaceholder {
	property var textFilter
	property var quickFilters

	readonly property bool _textFiltered: textFilter && textFilter.text.length
	readonly property bool _quickFiltered: quickFilters && quickFilters.selection.hasSelection

	filtered: _textFiltered || _quickFiltered
	searchText: _quickFiltered
		? ""
		: _textFiltered
			? textFilter.text
			: ""
}
