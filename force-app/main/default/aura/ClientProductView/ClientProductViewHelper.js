({
    getProductList : function(component, event, helper) {
         var AccountID = component.get("v.recordId");
        
        var action = component.get("c.getProductsList");
        action.setParams({
            
            AccountId : component.get("v.recordId") 
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();	
            if (component.isValid() && state === "SUCCESS") {
                console.log('State success'+state);
                	var productList = response.getReturnValue();
        			component.set("v.ProductsList",productList);
                    component.set('v.columns', [
                    {label: 'Product', fieldName: 'product', type: 'text'},
                    {label: 'Product  Type', fieldName: 'productType', type: 'text'},
                    {label: 'Count', fieldName: 'count', type: 'number'}
                    
                ]);
                                      
            }else if(state == "ERROR"){
                
                        	var errors = response.getError(); 
                			console.log('error message');
                            component.set("v.showErrors",true);
                            component.set("v.errorMessage",errors[0].message);
                        
                  }

        });

        $A.enqueueAction(action);
    },
                           
    
  
})