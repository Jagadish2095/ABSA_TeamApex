({
    // Start listening once opp has loaded
    oppLoadedHandler: function (component, event, helper) {
        component.set("v.cifNumber", component.find("hiddenOppCif").get("v.value"));
        component.set("v.allowClientIDnVPolling", true);
	},

	//function called when call is dropped, updates Opportunity SalesSubStatus__c field
	handleIDnvStatusChange: function (component, event, helper) {
		var wasOnceAuthenticated = component.get("v.wasOnceAuthenticated");
		var cacheObject = event.getParam("value");

		if (cacheObject == null) {
            if(wasOnceAuthenticated){
                helper.updateOpportunitySalesSubStatus(component);
            }
            component.set("v.clientIDnVObjectString","");
        }
        else{
            console.log(`IDnv : ${JSON.stringify(cacheObject)}`);
            component.set("v.clientIDnVObjectString",JSON.stringify(cacheObject));

            if(!wasOnceAuthenticated){
                // Keeps track of weather or not a call was authenticated, to know if the call was indeed dropped.
                component.set("v.wasOnceAuthenticated", true);               }
        }
	}

})