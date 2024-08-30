.pragma library

var gDebugMode = false

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

var scaleBackgroundColor = "#666666"
var scaleBackgroundRecordingColor = Qt.rgba(1, 0, 0, 0.2)

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

var addPopupTrackBackgroundColor = "#666666"

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

var splitterColor = "black"

//font
var fontSize = 12
var cursorFontSize = 9
var proximaRg = "Proxima Nova Rg"
var proximaBold = "Proxima Nova Th"
var segoiUI = "Segoe UI"

var seqContainerKeyResFontSize = 12;

//opacity
var trackBarOpacity = 0.3

//sizes
var rowHeight = 26
var barHeight = 18
var barRadius = 3

var keySize = Math.sqrt(72)
var keySelectedSize = Math.sqrt(289 / 2)

var timelineScaleHeight = 26
var timelineEventHeight = 26

var seqTreeItemHeight = 26
var seqTreeDepthPadding = 25
var seqTreeIconWidth = 16
var seqTreeIconHeight = 16
var seqTreeIconFrameWidth = 26
var seqTreeIconFrameHeight = 26
var seqKeyConnectionHeight = 1
var seqContainerKeySelectedBorderWidth = 2
var seqContainerKeySizerWidth = 5
var seqObjSeparatorHeight = 3

var minTreeViewWidth = 252

var addPopupTrackRadius = 3
var addPopupTrackShadowRadius = 15

var playbackButtonMinWidth = 38

var playbackIconWidth = 16
var playbackIconHeight = 16

var cursorRectangleBottomMargin = 6
var cursorRectangleRadius = 4
var cursorTextPadding = 20
var cursorTriangleWidth = 7
var cursorTriangleHeight = 7

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
var addPopupTrackVOffset = 3
var seqSaveLoadItemsMargin = 10

var containerKeyTextMargin = 10

var popupDefaultTopPadding = 5
var popupDefaultBottomPadding = 5
var popupDefaultLeftPadding = 1
var popupDefaultRightPadding = 1
var popupHoveredBorderColor = "#0a70dd"
var popupHoveredBorderWidth = 2
var popupTextColor= "white"

//icons
var iconCollapseExpand = "image://gui/animation_sequence/collapse-expand"
var iconRecordButton = "image://gui/animation_sequence/playback/record"
var iconFirstFrameButton = "image://gui/animation_sequence/playback/first-keyframe"
var iconPrevFrameButton = "image://gui/animation_sequence/playback/prev-frame"
var iconPlayButton = "image://gui/animation_sequence/playback/play"
var iconPauseButton = "image://gui/animation_sequence/playback/pause"
var iconNextFrameButton = "image://gui/animation_sequence/playback/next-frame"
var iconLastFrameButton = "image://gui/animation_sequence/playback/last-keyframe"
var iconStopButton = "image://gui/animation_sequence/playback/stop"
var iconAddButton = "image://gui/animation_sequence/add"
var iconDropDownArrows = "image://gui/animation_sequence/dropdown-arrows"
var iconSave = "image://gui/animation_sequence/save"
var iconOpen = "image://gui/animation_sequence/open"
var iconNewSequence = "image://gui/animation_sequence/new-sequence"

var iconVisibility = "image://gui/animation_sequence/tracks/visibility"
var iconFocus = "image://gui/animation_sequence/fit-to"
var iconFeedback = "image://gui/animation_sequence/feedback"
var iconCheckmark = "image://gui/animation_sequence/checkmark"
var iconCurves = "image://gui/animation_sequence/curves"
var iconGizmo = "image://gui/camo_gizmo"
var openedEye = "image://gui/model_asset/eye"
var closedEye = "image://gui/model_asset/close_eye"
var soundEnabled = "image://gui/animation_sequence/btn_sound"
var soundDisabled = "image://gui/animation_sequence/btn_sound_off"
var soloEnabled = "image://gui/animation_sequence/solo-on"
var soloDisabled = "image://gui/animation_sequence/solo-off"

var tangentBroken = "image://gui/animation_sequence/tangent/tangent-broken"
var tangentFree = "image://gui/animation_sequence/tangent/tangent-free"
var tangentLinear = "image://gui/animation_sequence/tangent/tangent-linear"
var tangentSmooth = "image://gui/animation_sequence/tangent/tangent-smooth"
var tangentStepped = "image://gui/animation_sequence/tangent/tangent-stepped"

//images
var imageCursor = "image://gui/shapes/triangle"
var noSequenceTransition = "image://gui/animation_sequence/transitions/no_sequence"

//other
var addPopupTrackSamples = 25
var seqContainerKeyStrokeSpread = 15
