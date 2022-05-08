({
    fetchData: function (component) {
        let action = component.get("c.getRelatedParties");
        
        action.setParams({
            "accountId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();            
            if (state === "SUCCESS") {
                let data = response.getReturnValue();
                if(data != '' || data.length > 0){  
                    component.set("v.data", data);
                    console.log(data);
                    console.log(component.get("v.data"));
                    component.set('v.jointsParentCode', data[0].jointsCIF); 
                 }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    redirectToAccount : function (component, event, helper) {
        let accId =  component.get("v.accountSelected");
		var strURL = '/lightning/r/Account/'+accId+'/view?0.cName='+component.get("v.jointsParentCode");
       
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": strURL
        });
        urlEvent.fire();
    },
})