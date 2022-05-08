({  
    
    executeHandler : function(component, event, helper) {
        
        var action = component.get("c.execute");
        var today = new Date();
        var date = today.getDate()+'-'+(today.getMonth()+1)+'-'+today.getFullYear();
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
        var TriggerDateTime = date+' '+time;
        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Post to database state is: " + state);
            }
            else {
                console.log("Post to database state is: " + state); 
            }
        });
        
        $A.enqueueAction(action);
     
        
        helper.showSpinner(component);
        setTimeout(function(){
            var action = component.get("c.retrieveFromDB");
            action.setParams({ postDateTime : TriggerDateTime });
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    console.log("Retrieve from database state is: " + state);
                    component.set('v.resultsList', response.getReturnValue());
                }
                else {
                    console.log("Retrieve from database state is: " + state); 
                }   
            }); 
        	helper.hideSpinner(component);
            $A.enqueueAction(action);
          }, 50000);
        },
    
 
     doInit : function(component, event, helper) {
        var action = component.get("c.getMonitoringData");
		helper.getAllRecords(component);
    },
        
    
})