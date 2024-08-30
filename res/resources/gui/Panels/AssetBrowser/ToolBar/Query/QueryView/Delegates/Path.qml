import QtQuick 2.11
import "../../../../Common" as Common

Common.PathBreadcrumbsView {
	height: parent.height
	spacing: 5
	endingSlash: parent.ListView.view.count > 1
	path: model.display

	Accessible.name: "Breadcrumbs"
}
