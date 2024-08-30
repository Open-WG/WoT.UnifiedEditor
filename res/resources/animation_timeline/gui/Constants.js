.pragma library

//Scale model
var majorStrokeHeight = 20
var strokeHeight = 20
var strokeWidth = 1

//colors
var defaultBackgroundColor = "#4a4a4a"

var toolbarBackgroundColor = "#4a4a4a"
var toolbarTextColor = "#d9d9d9"

var toolbarButtonBackgroundColor = "#666666"
var toolbarPressedButtonBackgroundColor = "#515151"
var toolbarHoveredButtonBackgroundColor = "#848484"

var scaleBackgoundColor = "#666666"
var scaleBackgroundRecordingColor = Qt.rgba(1, 0, 0, 0.2)
var scaleTimelineBackgroundColor = "#4a4a4a"

var labelBorderColor = "#1a1a1a"

var seqTreeOddItemColor = "#4a4a4a"
var seqTreeEvenItemColor = "#515151"
var seqKeyColor = "#d4d4d4"
var seqKeySelectedColor = "white"
var seqKeySelectedBorderColor = "#0a70dd"
var fontColor = "white"
var seqKeyConnectionColor = "#333333"
var seqContainerKeyColor = "#a09ea0"
var seqContainerKeySelectedBorderColor = "#0a70dd"
var seqContainerKeyResColor = "#ffffff"
var seqContainerKeyStrokeColor = "#000000"
var seqObjSeparatorColor = "#333333"
var selectionColor = "#0a70dd"

var defaultButtonColor = "#8c8c8c"
var defaultButtonDisabledColor = "#666666"
var defaultButtonHoveredColor = Qt.rgba(1, 1, 1, 0.25) //additive
var defaultButtonPressedColor = Qt.rgba(0, 0, 0, 0.6) //additive
var defaultFlatButtonHoveredColor = "#a8a8a8"
var defaultFlatButtonPressedColor = "#383838"
var defaultFlatButtonDisabledColor = "#8c8c8c"

var defaultButtonTextColor = "#ffffff"
var defaultButtonDisabledTextColor = "#d4d4d4"

var addPopupTrackBackgoundColor = "#666666"

var playbackButtonBackgroundColor = "#666666"
var playbackPressedButtonBackgroundColor = "#515151"
var playbackHoveredButtonBackgroundColor = "#848484"
var playbackCursorColor = "#0a70dd"

var curveEditorBackgroundColor = "#333333"

var sequenceDurationColor = "#439dff"
var sequenceDurationRecordingColor = "#ff9999"

var transitionBackgroundColor = "#595959"
var transitionTextColor = "white"

var popupBackgroundColor = "#4a4a4a"

//font
var fontSize = 12
var proximaRg = "Proxima Nova Rg"
var proximaBold = "Proxima Nova Th"

var seqContainerKeyResFontSize = 12;

//sizes
var timelineScaleHeight = 26
var timelineEventHeight = 26

var seqTreeItemHeight = 26
var seqTreeDepthPadding = 25
var seqTreeIconWidth = 16
var seqTreeIconHeight = 16
var seqTreeIconFrameWidth = 26
var seqTreeIconFrameHeight = 26
var seqKeySize = Math.sqrt(81 / 2)
var seqKeySelectedSize = Math.sqrt(289 / 2)
var seqKeyConnectionHeight = 1
var seqContainerKeyHeight = 24
var seqContainerKeySelectedBorderWidth = 2
var seqContainerKeySizerWidth = 5
var seqObjSeparatorHeight = 3

var addSeqObjectButtonHeight = 24
var addSeqObjectButtonWidth = 252
var addSeqObjectButtonRadius = 3

var addPopupTrackRadius = 3
var addPopupTrackShadowRadius = 15

var playbackButtonMinWidth = 38

var playbackIconWidth = 16
var playbackIconHeight = 16

var cursorWidth = 7
var cursorHeight = 21

var dropArrowButtonWidth = 15
var dropArrowButtonHeight = 14

var keyContextMenuWidth = 110
var seqObjContextMenuWidth = 110

var keyPopupWidth = 150

var curveEditorHeight = 96
var curveValueDisplayHeight = 24
var curveValueDisplayWidth = 60
var curveValueDisplayTopBotPadding = 4

//offsets
var addPopupTrackVOffest = 3
var seqSaveLoadItemsMargin = 10

var popupDefaultTopPadding = 5
var popupDefaultBottomPadding = 5
var popupDefaultLeftPadding = 1
var popupDefaultRightPadding = 1
var popupHoveredBorderColor = "#0a70dd"
var popupHoveredBorderWidth = 2
var popupTextColor= "white"

//icons
var iconCollapseExpand = "image://resources/icons/collapse-expand"
var iconRecordButton = "image://resources/icons/playback/record.svg"
var iconFirstFrameButton = "image://resources/icons/playback/first-keyframe"
var iconPrevFrameButton = "image://resources/icons/playback/prev-frame"
var iconPlayButton = "image://resources/icons/playback/play"
var iconPauseButton = "image://resources/icons/playback/pause"
var iconNextFrameButton = "image://resources/icons/playback/next-frame"
var iconLastFrameButton = "image://resources/icons/playback/last-keyframe"
var iconStopButton = "image://resources/icons/playback/stop"
var iconAddButton = "image://resources/icons/add"
var iconDropDownArrows = "image://resources/icons/dropdown-arrows"
var iconSave = "image://resources/icons/save"
var iconOpen = "image://resources/icons/open"

var iconLightObj = "image://resources/icons/objects/light"
var iconParticleObj = "image://resources/icons/objects/particle"
var iconSoundObj = "image://resources/icons/objects/sound"
var iconModelObj = "image://resources/icons/objects/root-model"
var iconDynamicModelObj = "image://resources/icons/objects/dynamic-model"

var iconVisibility = "image://resources/icons/tracks/visibility"
var iconFocus = "image://resources/icons/focus"
var iconFeedback = "image://resources/icons/feedback.svg"
var iconCheckmark = "image://resources/icons/checkmark.svg"
//images
var imageCursor = "image://resources/icons/playback/cursor"
var noSequenceTransition = "image://resources/transitions/no_sequence"

//other
var addPopupTrackSamples = 25
var seqContainerKeyStrokeSpread = 15