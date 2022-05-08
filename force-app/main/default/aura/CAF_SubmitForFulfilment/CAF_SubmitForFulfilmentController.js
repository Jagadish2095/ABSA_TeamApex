({
	doInit : function(component,event,helper){ 
        var currentUser = $A.get("$SObjectType.CurrentUser.Id");
        var caseOwner = component.get("v.caseRecord.OwnerId");
        if(currentUser != caseOwner){
            component.set("v.isEditable", true);
        }
        else{
            component.set("v.isEditable", false);
        }
       
    },
    submitToFulfilment : function(component,event,helper){ 
   // helper.refreshData(component, event, helper);
        helper.changeOwner(component,event,helper);
        },
    
  
})