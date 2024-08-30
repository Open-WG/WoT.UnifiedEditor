import QtQuick 2.7

import ShortcutProvider 1.0
import "Constants.js" as Constants

Item {
	id: root

	anchors.fill: parent

	signal playbackShortcutActivated()
	signal saveShortcutActivated()
	signal recordShortcutActivated()
	signal stopShortcutActivated()
	signal firstFrameShortcutActivated()
	signal lastFrameShortcutActivated()
	signal addKeyShortcutActivated()
	signal openShortcutActivated()
	signal zoomInActivated()
	signal zoomOutActivated()
	signal nextKeyShortcutActivated()
	signal prevKeyShortcutActivated()
	signal removeKeyShortcutActivated()
	
	Shortcut {
		sequence: ShortcutProvider.playbackSequence
		context: Qt.WindowShortcut

		onActivated: playbackShortcutActivated()
		onActivatedAmbiguously: playbackShortcutActivated()
	}

	// Shortcut {
	// 	sequence: ShortcutProvider.saveSequence
	// 	context: Qt.WindowShortcut

	// 	onActivated: saveShortcutActivated()
	// }

	Shortcut {
		sequence: ShortcutProvider.recordSequence
		context: Qt.WindowShortcut

		onActivated: recordShortcutActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.stopSequence
		context: Qt.WindowShortcut

		onActivated: stopShortcutActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.firstFrameSequence
		context: Qt.WindowShortcut

		onActivated: firstFrameShortcutActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.lastFrameSequence
		context: Qt.WindowShortcut

		onActivated: lastFrameShortcutActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.addKeySequence
		context: Qt.WindowShortcut

		onActivated: addKeyShortcutActivated()
	}

	// Shortcut {
	// 	sequence: ShortcutProvider.openSequence
	// 	context: Qt.WindowShortcut

	// 	onActivated: openShortcutActivated()
	// }

	Shortcut {
		sequence: ShortcutProvider.zoomOutSequence
		context: Qt.WindowShortcut

		onActivated: zoomOutActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.zoomInSequence
		context: Qt.WindowShortcut

		onActivated: zoomInActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.nextKeySequence
		context: Qt.WindowShortcut

		onActivated: nextKeyShortcutActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.prevKeySequence
		context: Qt.WindowShortcut

		onActivated: prevKeyShortcutActivated()
	}

	Shortcut {
		sequence: ShortcutProvider.removeKeySequence
		context: Qt.WindowShortcut

		onActivated: {
			removeKeyShortcutActivated()
		}
	}
}