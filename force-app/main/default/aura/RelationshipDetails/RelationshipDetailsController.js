({
	doInit : function(component, event, helper) {
        
		var accountId = component.get("v.clientAccountIdFromFlow");
        console.log('accountId--'+accountId);
        var action = component.get("c.getControlOfficers");
        action.setParams({
            accountId : accountId
        });
        helper.showSpinner(component);
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            console.log('response state---'+state);
            
            if (component.isValid() && state === "SUCCESS") {
               
                console.log('response ---'+response);
                
                var responseBean = JSON.parse(response.getReturnValue());
                console.log('Service response ' +  responseBean);
                console.log('message---'+JSON.stringify(responseBean));
                console.log('length ' + responseBean);
                if(responseBean != null){ 
                    if(responseBean.length > 0){
                        for(var i = 0; i < responseBean.length; i++){
                            if(responseBean[i].role == 'Business Banker' && responseBean[i].name != ''){
                            	component.set("v.name" , responseBean[i].name);
                    			component.set("v.branchSite" , responseBean[i].branchSite);
                                component.set("v.cellphoneNumber" , responseBean[i].mobileNumber);
                    			component.set("v.tellNumber" , responseBean[i].tellNumber);
                    			component.set("v.emailAddress" , responseBean[i].email);
                                helper.hideSpinner(component);
                            }
                        }
                        
                    }else{
                        var toast = helper.getToast('error', 'Something went wrong! CIF not linked to a banker','Error');
                        toast.fire();
                        helper.hideSpinner(component);
                    }
                    
                    
                }else{
                    var toast = helper.getToast('error', 'Something went wrong! Service issue','Error');
                    toast.fire();
                    helper.hideSpinner(component);
                }
              }
            
        });
        
        
        $A.enqueueAction(action);
    }
    ,
    showToast : function(type, message, title){
       var toastEvent = $A.get("e.force:showToast");
    	toastEvent.setParams({
        "type" : type,
        "title": title,
        "message": message
    });
    toastEvent.fire();  
    }
})