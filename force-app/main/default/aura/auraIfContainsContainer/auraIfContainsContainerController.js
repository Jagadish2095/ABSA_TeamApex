({
	doInit: function (component, event, helper) {

		var getList = component.get('v.items');
		var getElement = component.get('v.element');
		var getElementIndex = getList.indexOf(getElement);

		var getElements = getElement.split(',');

		if (getElements !== null) {
			for (var x = 0; x < getElements.length; x++) {
				getElementIndex = getList.indexOf(getElements[x]);
				console.log('getElementIndex::: ' + getElementIndex);
				if (getElementIndex != -1) {
					break;
				}
			}
		}
		//console.log('getElement::: ' + getElement);
		//console.log('getList::: ' + JSON.stringify(getList));

		// if getElementIndex is not equal to -1 it's means list contains this element.
		if (getElementIndex != -1) {
			component.set('v.condition', true);
		} else {
			component.set('v.condition', false);
		}
	}
})