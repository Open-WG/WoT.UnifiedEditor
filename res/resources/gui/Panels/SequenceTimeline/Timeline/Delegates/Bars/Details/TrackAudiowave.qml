import QtQuick 2.11
import WGTools.AnimSequences 1.0 as Sequences

Audiowave {
	id: audiowave

	state: itemData.specialStyle == Sequences.SpecialStyleTypes.OneShotStyle ? "oneshot" : ""
	states: State {
		name: "oneshot"

		PropertyChanges {
			target: audiowave
			opacity: 0.5
			color: {
				var c = context.colors.color(itemData.colorIndex)
				var maxMinSum = Math.max(c.r, c.g, c.b) + Math.min(c.r, c.g, c.b)

				return Qt.rgba(maxMinSum - c.r, maxMinSum - c.g, maxMinSum - c.b)
			}
		}
	}
}
