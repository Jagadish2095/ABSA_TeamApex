({
    doInit : function(component, event, helper) {
        var recid=component.get("v.caseIdFromFlow");
        /* VK
        var evt = $A.get("e.c:BNGenerationNCrossSellEvent");
        
        evt.setParam("CurrentCaseId", recid);
        evt.fire();*/
        component.set("v.recordId", component.get("v.caseIdFromFlow"));
        var action = component.get("c.queryAllProducts");
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var opts=[];
                var totalSplit = a.getReturnValue();
                
                for(var i=0;i< a.getReturnValue().length;i++){
                    opts.push({label: a.getReturnValue()[i].MasterLabel, value: a.getReturnValue()[i].MasterLabel});
                }
                component.set("v.options", opts);
                
            }
        });
        $A.enqueueAction(action);
    },
    handleFinish: function (component, event) {
        
    },
    handleChange: function (component, event) {
        component.set("v.selectedoptions", event.getParam('value'));
        if(event.getParam('value') != '' && event.getParam('value') != null && event.getParam('value').includes("Short term")){
            component.set("v.disablebutton",false);
        }
        else{
            component.set("v.disablebutton",true);
        }
       
    },
    handleNext : function(component, event, helper) {
        var action = component.get("c.sendEmailToTeam");
        var caseid = component.get("v.recordId");
        var selProducts = component.get("v.selectedoptions").toString();
        
        action.setParams({
            "caseid": caseid,
            "selProducts": selProducts
        });        
        action.setCallback(this, function(a) {
            component.set("v.isLoading", false);
            var state = a.getState();
            if (state === "SUCCESS") {
                var totalSp = a.getReturnValue();
                 component.set("v.prdctList",totalSp); 
               
                if(totalSp[0].DeveloperName== "Short_term"){
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Email sent successfully",
                    "type":"success"
                });
                toastEvent.fire();
                
                }else{
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Email will be sent only to short term Product.",
                    "type":"success"
                });
                toastEvent.fire(); 
                }
             }
                       
            else{
                var errors = a.getError();
                if (errors) {
                    for(let error of errors){
                        let errorMessage = error.message;
                        let errorKey = errorMessage.match(/(\b[A-Z][A-Z]+([_]*[A-Z]+)*)/g).pop();
                        errorMessage = errorMessage.split(errorKey+", ").pop().split(": [").shift();
                        
                        var toastEvent = $A.get('e.force:showToast');
                        toastEvent.setParams({
                            title: 'Error!',
                            message: errorMessage,
                            type: 'error'
                        });
                        toastEvent.fire();  
                    }
                }
            }
            
        });
        $A.enqueueAction(action);
        component.set("v.isLoading", true);
    }
})