({
    searchHelper : function(component,event,getInputkeyWord,searchbyProduct) {
    	searchbyProduct= searchbyProduct;
        var getSearchKey=getInputkeyWord;
        var getProduct=searchbyProduct;
        var action = component.get("c.fetchDependentLookUpValues")
        action.setParams({
            'transactionType': getSearchKey,
            'product': getProduct,
           
            
        });
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();

                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0 ) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                   
                }
                
                // set searchResult list with return value from server.
                component.set("v.listOfTransactionsRecords", storeResponse);
 
            }
            
        });
       
        $A.enqueueAction(action);
        
    },
})