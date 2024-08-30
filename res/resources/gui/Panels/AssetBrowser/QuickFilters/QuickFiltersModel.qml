import QtQuick 2.11
import QtQml.Models 2.11

ListModel {
	ListElement {display: "Favorites"; filter: "#Favorites"}
	ListElement {display: "Spaces"; filter: "$asset_type=space"}
	ListElement {display: "Models"; filter: "$asset_type=model lod0"}
	ListElement {display: "Atlas"; filter: "$asset_type=atlas"}
	ListElement {display: "SpeedTree"; filter: "$asset_type=speedtree"}
	ListElement {display: "Prefabs"; filter: "$asset_type=prefab"}
	ListElement {display: "GameObjects"; filter: "#GameObjects"}
	ListElement {display: "Textures"; filter: "$asset_type=texture"}
	ListElement {display: "Tiles"; filter: "#Terrain_tiles"}
	ListElement {display: "Lighting"; filter: "#SH-Grid #Lights #EnvironmentLights"}
	ListElement {display: "Effects"; filter: "#Effects"}
	ListElement {display: "Water"; filter: "#Water"}
	ListElement {display: "Outland"; filter: "#Outland"}
	ListElement {display: "Decor"; filter: "#Decor"}
	ListElement {display: "Sequences"; filter: ".seq"}
	ListElement {display: "SSM"; filter: "$asset_type=ssm"}
	ListElement {display: "FBX"; filter: "$asset_type=fbx"}
	ListElement {display: "Sound"; filter: "#Sound"}
	ListElement {display: "Tanks"; filter: "$asset_type=tank"; menu: "TankFilterMenu.qml"}
}
