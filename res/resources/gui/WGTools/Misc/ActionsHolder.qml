import QtQuick 2.11
import WGTools.Controls 2.0

QtObject {
	default property list<Action> actions

	function action(text) {
		for (var i=0; i<actions.length; ++i) {
			var action = actions[i]
			if (action && action.objectName == text) {
				return action
			}
		}

		return null
	}
}
