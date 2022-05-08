({
	GetIndicator : function(component, event, helper) {
        var oppId = component.get("v.opportunityId");
        var action = component.get("c.GetPackageIndicator");		      
        action.setParams({
            "oppId": oppId        	
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.CbpResultFound',true);
                var cbpIndicator = response.getReturnValue();
                console.log('cbpindicator:  '+ cbpIndicator);
                component.set('v.cbpIndicator',cbpIndicator);
            }
            else
            {
                console.log('error');
                component.set('v.CbpResultFound',false);
                component.set('v.cbpIndicator','');
                
            }
        });
        $A.enqueueAction(action);
                
	},
    navHome : function (component, event, helper) {       
        var homeEvent = $A.get("e.force:navigateToURL");
        homeEvent.setParams({
            "url": "/home/home.jsp"
        });        
        homeEvent.fire();
     }
})