/**
 * This is the JavaScript Controller for the AdviserLookup Component for the selection of Adviser records
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-02-23
 */

({
	onfocus : function(component, event, helper) {

		$A.util.addClass(component.find("mySpinner"), "slds-show");

		var forOpen = component.find("searchRes");

		$A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');

		var inputKeyWord = '';

        helper.searchHelper(component, event, inputKeyWord);

    },

    onblur : function(component, event, helper) {

		component.set("v.listOfSearchRecords", null );

		var forclose = component.find("searchRes");

		$A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

    },

    keyPressController : function(component, event, helper) {

		var inputKeyWord = component.get("v.SearchKeyWord");

        if (inputKeyWord.length > 0 ) {

			var forOpen = component.find("searchRes");

			$A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');

			helper.searchHelper(component, event, inputKeyWord);

        } else {

			component.set("v.listOfSearchRecords", null );

			var forclose = component.find("searchRes");

			$A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');

        }

	},

	clear : function(component, event, helper) {

		var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");

		$A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
		$A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');

		component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null);
        component.set("v.selectedRecord", {});

    },

	handleComponentEvent : function(component, event, helper) {

		var selectedsObjectGetFromEvent = event.getParam("recordByEvent");

		component.set("v.selectedRecord" , selectedsObjectGetFromEvent);

		var forclose = component.find("lookup-pill");

		$A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');

        var forclose = component.find("searchRes");

		$A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

        var lookUpTarget = component.find("lookupField");

		$A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');

	},

})