import QtQuick 2.7
import WGTools.Utils 1.0

ItemFactory {
    choiceCriteria:
    {
        'propertyTypes': "bool",
        'meta': "Meta::View::Button"
    }

    component: Qt.createComponent("../Delegates/ButtonCheckBoxDelegate.qml")
    properties: function(model) { return { model: model } }
}
