.pragma library

function focusSequence(timelineContext) {
	if (timelineContext.sequenceOpened) {
		if (timelineContext.sequenceDuration != 0) {
			var endSeconds = timelineContext.sequenceDuration
			if (endSeconds == 0)
				endSeconds = 20

			var marginRatio = timelineContext.timelineController.scaleMargin
			marginRatio = timelineContext.timelineController.controlSize / marginRatio
			var end = timelineContext.timelineController.fromSecondsToFrames(endSeconds)

			var margin = end / marginRatio

			timelineContext.timelineController.focusAroundRange(-margin, end + margin)
		}
	}
}

function overlap(x1, y1, w1, h1, x2, y2, w2, h2) {
	var cx1 = x1 + w1 / 2
	var cx2 = x2 + w2 / 2
	var cy1 = y1 + h1 / 2
	var cy2 = y2 + h2 / 2
	return (Math.abs(cx1 - cx2) * 2 < (w1 + w2))
		&& (Math.abs(cy1 - cy2) * 2 < (h1 + h2))
}

function selectKeys(selModel, box, repeater, view, selectionHelper) {
	var selectionChanged = false

	for (var i = 0; i < repeater.count; ++i) {
		var item = repeater.itemAt(i)

		if (!item.visible)
			continue

		var center = Qt.point(item.x, item.y)
		center = repeater.mapToItem(view, center.x, center.y)

		if (overlap(box.x, box.y, box.width, box.height,
				center.x, center.y, 
				item.realWidth, item.realHeight)) {
			selectionHelper.push(item.modelIndex)
			selectionChanged = true;
		}
	}

	return selectionChanged;
}