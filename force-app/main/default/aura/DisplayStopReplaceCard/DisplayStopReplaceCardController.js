({
	myAction : function(component, event, helper) {
		var action = component.get("c.getAccountDetails");
        var clientAccountId = component.get('v.clientAccountIdFromFlow');
        action.setParams({clientAccountId:clientAccountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var respObj = JSON.parse(response.getReturnValue());
                console.log('--------respObj-------'+respObj);
                component.set('v.responseList',respObj);
                
                var prodList = [];
                var prodSet = new Set();
                for(var key in respObj){
                    console.log('==='+respObj[0].productType);
                    if (!prodList.includes(respObj[key].productType)) {
                        prodList.push(respObj[key].productType);
                    } 
                }
                component.set('v.prodTypesList',prodList);
                
            } else if(state === "ERROR"){
                
            } else{
                
            }
         });
         $A.enqueueAction(action);
        
	
	}
})