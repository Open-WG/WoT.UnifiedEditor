import QtQuick 2.7
import WGTools.Utils 1.0
import "Factories" as Factories

// order matters!
FactoryManager {
	chooser: Chooser {}

	Factories.PathDropDownFactory {}
	Factories.DropDownFactory {}
	Factories.TabbedRadioButtonsFactory {}
	Factories.RadioButtonsFactory {}
	Factories.ImageRadioButtonsFactory {}
	Factories.ColorFactory {}
	Factories.ColorGradientFactory {}
	Factories.ImageFactory {}
	Factories.ImagePathFactory {}		// TODO: improve performance
	Factories.TagFactory {}
	Factories.PathFactory {}
	Factories.TextAreaFactory {}
	Factories.TextFieldFactory {}
	Factories.ButtonCheckBoxFactory {}
	Factories.RadioButtonFactory {}
	Factories.CheckBoxFactory {}
	Factories.VectorXFactory {}
	Factories.SliderFactory {}
	Factories.TimelineFactory {}
	Factories.UnitsSpinBoxFactory {}
	Factories.SpinBoxFactory {}
	Factories.CompactNumericFactory {}
	Factories.NumericFactory {}
	Factories.RangeFactory {}
	Factories.ButtonFactory {}
	Factories.LodCameraFactory {}
	Factories.LodBarFactory {}
	Factories.NormalizedPlaybackFactory {}
	Factories.FogMinimapFactory {}
	Factories.ResizeMinimapFactory {}
	Factories.DragItemFactory {}
	Factories.FallbackFactory {}
}
