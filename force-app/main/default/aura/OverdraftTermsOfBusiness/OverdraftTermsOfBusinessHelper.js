({
	 setTobFields: function(component, event) {
        
        
        var action = component.get("c.getfWrapperListOrigination");
        /*action.setParams({
            "oppId": component.get("v.recordId")
        });*/
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results fieldWrapList---'+JSON.stringify(results));
                component.set("v.fieldWrapList",results);
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getTOB : function(component,event){
        var action = component.get("c.getProductTOBOrigination");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results product---'+JSON.stringify(results));
               if(results){ 
                    var viewA = component.get("v.acceptView");
                    if(viewA){
                        var acceptedResults =[];
                        for(var i=0;i<results.length;i++){
                            console.log('result status---'+results[i].appProduct.Product_Status__c);
                            if(results[i].appProduct.Product_Status__c == 'Accepted' ){//&& results[i].isacceptedApplicationLevel
                                console.log('putting accepted product only');
                                acceptedResults.push(results[i]);
                            } 
                        }
                      component.set("v.appProdTobList",acceptedResults);   
                    }else{
                       component.set("v.appProdTobList",results); 
                    }
               }
            }
        });
        $A.enqueueAction(action);
    },
})