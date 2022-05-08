({
	createOpportunity : function(component, event, contextRef) {
        
        var action = component.get("c.createOpportunityWithLineItems");
        
        action.setParams({
            'accountId': component.get("v.accountId"),		//Retrieve from clientFinder accountSelected attribute
            'productCode': component.get("v.productCode"),	
            'productType': component.get("v.productType"),
            'contextRef': contextRef
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                
                if (storeResponse !== null) {
                    
                    //Redirect to created opportunity page
                    
                } else {
                    
                    //Error processing
                    
                }
                
            }
            
        });
        
        $A.enqueueAction(action);
           
	}
    
})