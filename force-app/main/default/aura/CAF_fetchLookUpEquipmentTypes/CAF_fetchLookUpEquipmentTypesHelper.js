({
	searchHelper : function(component,event,getInputkeyWord) {
	 
     var action = component.get("c.fetchLookUpEquipTypes");
             action.setParams({
            'searchKeyWord': getInputkeyWord,
            
          });
         
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var storeResponse = response.getReturnValue();
                
                
                // if storeResponse size is equal 0 ,display No Result Found... message on screen. 
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...Please try again !!!');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
        //alert('inside Show Spinner');
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
        //alert('inside hide Spinner');
    }
})