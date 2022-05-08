({
    doInit : function(component, event, helper) {
        helper.showSpinner(component);
        var accountEmail = component.get('v.clientEmail');
        var mandateEmail = component.get('v.mundateEmail');
        
        if(mandateEmail){
            component.set('v.clientEmail',mandateEmail);
        }
        
        var action = component.get('c.getNatisDocs');
        var accountId = component.get('v.recordId');
        
        action.setParams({
            "accId" : accountId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                var arrayMapKeys = [];
                
                for(var key in result){
                    arrayMapKeys.push({key: key, value: result[key]});
                }
                
                component.set("v.mapValues", arrayMapKeys);
                
                helper.hideSpinner(component);
                
            } else if (state === "ERROR") {
                
                var toast = helper.getToast("Error", "There was an error retrieving the Natis document list", "error");
                
                helper.hideSpinner(component);
                
                toast.fire();
            }
        }));
        
        $A.enqueueAction(action);
        
    },
    
    //Added against W-005675 dated 16/09/2020 by Humbe
    caseRecordUpdate:function(component,event,helper){
        if(event.getParams().changeType == "LOADED"){
            component.set("v.serviceGroupTypeId", component.get("v.caseRecord.sd_Service_Group_Type_Id__c"));
            component.find("serviceGroupTypeLoader").reloadRecord();
        }
    },
    
    //Added against W-005675 dated 16/09/2020 by Humbe
    serviceGroupTypeUpdate:function(component, event, helper){
        if(event.getParams().changeType == "LOADED"){
            var additionalAttributesString = component.get("v.serviceGroupTypeRecord.Additional_Attributes__c");
            if(!$A.util.isEmpty(additionalAttributesString)){
                var additionalAttributes = JSON.parse(additionalAttributesString);
                if(!$A.util.isEmpty(additionalAttributes.NatisRequestVehicleSelection)){
                    component.set("v.setEmailFieldDisabledValue", additionalAttributes.NatisRequestVehicleSelection.setEmailFieldDisabledValue);
                }
            }
        }
    },
    
    closeCase: function (component, event, helper) {
        
        helper.showSpinner(component);
        var checkboxes;
        var checkboxesChecked = [];
        
        if(component.find("natisdocs")){
            
            checkboxes = component.find("natisdocs");
            
            if(Array.isArray(checkboxes)){
                
                for (var i=0; i < checkboxes.length; i++) {
                    
                    if(checkboxes[i].get("v.checked")){
                        if (checkboxes[i].get("v.value")) {
                            checkboxesChecked.push( checkboxes[i].get("v.value") );
                        }
                    }
                    
                }
                
            }else{
                checkboxesChecked.push( checkboxes.get("v.value") );
            }
        }
        
        var action = component.get('c.sendNatisDocs');
        
        var caseId = component.get('v.caseId');
        var email = component.get('v.clientEmail');
        
        action.setParams({
            "docList" : checkboxesChecked,
            "emailAddress" : email,
            "caseRecordId" : caseId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if(result === 'success'){
                    var toast = helper.getToast("Success", "Selected Natis documentation emailed successfully", "success");
                }else{
                    var toast = helper.getToast("Error", result, "error");
                }
                
                helper.hideSpinner(component);
                
                toast.fire();
                
                $A.get('e.force:refreshView').fire();
                
                
            } else if (state === "ERROR") {
                
                var toast = helper.getToast("Error", "There was an error emailing the selected Natis documentation", "error");
                
                helper.hideSpinner(component);
                
                toast.fire();
                
                $A.get('e.force:refreshView').fire();
            }
        }));
        
        if( component.get('v.clientEmail') && checkboxesChecked.length > 0){
            $A.enqueueAction(action);
        }else{
            
            var toast;
            
            if(component.find("natisdocs")){
                
                if(!component.get('v.clientEmail')){
                    toast = helper.getToast("Warning", "Please provide a valid email address", "warning");
                }else{
                    toast = helper.getToast("Warning", "Please select at least 1 document", "warning");
                }
                
            }else{
                toast = helper.getToast("Warning", "No Natis documents could be found for this Client", "warning");
            }
            
            helper.hideSpinner(component);
            toast.fire();
        }
    }
})