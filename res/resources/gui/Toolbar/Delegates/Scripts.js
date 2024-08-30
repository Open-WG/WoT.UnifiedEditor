.pragma library

function getDelegate(type, path) {
	return "%1%2Delegate.qml".arg(path.length ? path + "/" : "").arg(type)
}
