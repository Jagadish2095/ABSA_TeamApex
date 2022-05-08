/**
 * This is the JavaScript Helper for the AdviserLookup Component for the selection of Adviser records
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-02-23
 */

({
	searchHelper : function(component, event, inputKeyWord) {

        var action = component.get("c.fetchLookUpValues");

        action.setParams({
			'searchKeyWord': inputKeyWord,
            'objectName' : component.get("v.objectAPIName"),
            'userServiceGroupList' : null
		});

        action.setCallback(this, function(response) {

			$A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();

            if (state === "SUCCESS") {

				var storeResponse = response.getReturnValue();

                if (storeResponse.length == 0) {

					component.set("v.Message", 'No Result Found...');

                } else {

					component.set("v.Message", '');

                }

                component.set("v.listOfSearchRecords", storeResponse);
            }

        });

        $A.enqueueAction(action);

	},
})