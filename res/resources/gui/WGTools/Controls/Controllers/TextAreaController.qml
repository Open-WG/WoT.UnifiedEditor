import QtQuick 2.7

TextFieldController {
	id: controller

	Connections {
		target: controller.control
		ignoreUnknownSignals: true
		onTextChanged: {
			if (controller.control.activeFocus) {
				notifier.notify(true)
			}
		}
	}
}
