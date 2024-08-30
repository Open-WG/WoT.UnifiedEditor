import QtQuick 2.11
import QtQml.Models 2.11

ListModel {
	ListElement {display: "Favorites"; filter: "#Favorites"}
	ListElement {display: "Spaces"; filter: ".settings"}
	ListElement {display: "Models"; filter: ".model lod0"}
	ListElement {display: "Atlas"; filter: ".atlas"}
	ListElement {display: "SpeedTree"; filter: ".srt"}
	ListElement {display: "Prefabs"; filter: ".prefab"}
	ListElement {display: "GameObjects"; filter: "#GameObjects"}	
	ListElement {display: "Textures"; filter: ".dds"}
	ListElement {display: "Tiles"; filter: "#Terrain_tiles"}
	ListElement {display: "Lighting"; filter: "#SH-Grid #Lights #EnvironmentLights"}
	ListElement {display: "Effects"; filter: "#Effects"}
	ListElement {display: "Water"; filter: "#Water"}
	ListElement {display: "Outland"; filter: "#Outland"}
	ListElement {display: "Decor"; filter: "#Decor"}
	ListElement {display: "Sequences"; filter: ".seq"}
	ListElement {display: "SSM"; filter: ".ssm"}
	ListElement {display: "FBX"; filter: ".fbx"}
	ListElement {display: "Sound"; filter: "#Sound"}
	ListElement {display: "Tanks"; filter: "$asset_type=tank"}
}
