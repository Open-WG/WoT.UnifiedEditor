.pragma library

var sideLabels =
[
	"+X Right",
	"-X Left",
	"+Y Top",
	"-Y Bottom",
	"+Z Front",
	"-Z Back"
]

function getImageTitleText(imageSide) {
	return sideLabels[imageSide]
}
