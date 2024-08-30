.pragma library

function roundValue(value, decimals) {
	const multiplier = Math.pow(10, decimals)
	return Math.round(value * multiplier) / multiplier
}

function textFromValue(value, locale, decimals) {
//  return Number(value).toLocaleString(locale, 'f', decimals)

	value = roundValue(value, decimals)
	return Number(value).toLocaleString(locale.name, {maximumFractionDigits: decimals})
}

function compare(x, y) {
	return Math.abs(x - y) < Number.EPSILON
}

function clamp(value, min, max) {
	return Math.min(Math.max(value, min), max)
}

function iterateChildrenAt(item, x, y, visit) {
    item = item.childAt(x, y)
    while (item) {
        if (visit(item)) {
            break
        }

        x -= item.x
        y -= item.y
        item = item.childAt(x, y)
    }
}
