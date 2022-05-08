({
	searchHelper : function(component,event,getInputkeyWord) {
        
        var action = component.get("c.fetchLookUpValues");
        
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'objectName' : component.get("v.objectAPIName")
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
                
                //Set searchResult list with return value from server
                component.set("v.listOfSearchRecords", storeResponse);
                
            }
            
        });
        
        $A.enqueueAction(action);
           
	}
    
})