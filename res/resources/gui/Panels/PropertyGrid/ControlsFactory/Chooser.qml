import QtQuick 2.7

QtObject {
	function check(factory, model) {
		if (factory.choiceCriteria != undefined)
		{
			if (!model.node.property.checkTypes(factory.choiceCriteria.propertyTypes))
				return false

			if (!checkMeta(factory.choiceCriteria, model.node.property))
				return false

			return true	
		}

		return true
	}

	function checkMeta(criterias, propertyData) {
		if (typeof criterias["meta"] != "undefined")
			return checkMetaFilter(criterias["meta"], propertyData, true)

		if (typeof criterias["anyMeta"] != "undefined")
			return checkMetaFilter(criterias["anyMeta"], propertyData, true)
		
		if (typeof criterias["allMeta"] != "undefined")
			return checkMetaFilter(criterias["allMeta"], propertyData, false)

		return true
	}

	function checkMetaFilter(filterMeta, propertyData, any) {
		switch (typeof filterMeta)
		{
		case "string":
			return checkSingleMeta(filterMeta, propertyData)

		default:
			if (any)
			{
				for (var i = 0; i < filterMeta.length; ++i)
				{
					if (checkSingleMeta(filterMeta[i], propertyData))
						return true
				}
			}
			else
			{
				for (var i = 0; i < filterMeta.length; ++i)
				{
					if (!checkSingleMeta(filterMeta[i], propertyData))
						return false
				}

				return true
			}
			break
		}

		return false
	}

	function checkSingleMeta(meta, propertyData) {
		if (typeof meta != "string") {
			return checkMeta(meta, propertyData)
		}
		var inverse = false

		if (meta[0] == '!')
		{
			meta = meta.substring(1)
			inverse = true
		}

		var metaExists = propertyData.hasAnnotation(meta)

		return inverse ? !metaExists : metaExists
	}
}
