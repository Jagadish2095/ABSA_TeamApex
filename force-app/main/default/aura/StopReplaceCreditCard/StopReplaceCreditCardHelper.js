({
	initGetCardDetails : function(component, event, helper, clientAccountId) {
       
        var action = component.get("c.getCardDetails"); 
        action.setParams({clientcd:clientAccountId});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                var custs = [];
                for(var key in respObj){
                    if(respObj[key]==null){
                        component.set("v.errorMessageFromService",key);
                    } else{
                        custs.push({value:respObj[key], key:key});              
                    }
                }
                component.set("v.cardWrapperMap",custs);
                component.set("v.fullCardsWrapper",custs);
            } else if(state === "ERROR"){
                
            } else{
                
            }
         });
         $A.enqueueAction(action);
	},
    getStopCardReasons : function(component, event, helper){
        var action = component.get("c.getCardReasons"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.cardReasonsList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getStopCardCircumstances : function(component, event, helper){
        var action = component.get("c.getCardCircumstances"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.cardCircumstancesList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    getStopReplaceCardWrapper : function(component, event, helper){
        var action = component.get("c.getStopServiceWrapper"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.stopServiceWrapperList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})