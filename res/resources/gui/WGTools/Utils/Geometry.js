.pragma library

function overlap(x1, y1, w1, h1, x2, y2, w2, h2) {
	var cx1 = x1 + w1 / 2
	var cx2 = x2 + w2 / 2
	var cy1 = y1 + h1 / 2
	var cy2 = y2 + h2 / 2
	return (Math.abs(cx1 - cx2) * 2 < (w1 + w2))
		&& (Math.abs(cy1 - cy2) * 2 < (h1 + h2))
}
