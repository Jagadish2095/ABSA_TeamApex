({
    doInit : function(component, event, helper) {
        helper.getAppRec(component, event, helper);
        
    },
    handleSubmit: function(component, event, helper) {
        
        helper.showSpinner(component, event, helper);
        
        var parent =component.get("v.Parent");
        console.log('parent in handelsubmit'+parent);
        if(parent=='No'){
            if(component.find("numberOfBorrowerSignatureRequired").get("v.value") == '' || component.find("numberOfBorrowerSignatureRequired").get("v.value") == undefined || 
               component.find("numberOfDaysForBorrowerToAcceptOf").get("v.value") == '' || component.find("numberOfDaysForBorrowerToAcceptOf").get("v.value") == undefined)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }
            else{
                helper.updateBorrowerInfo(component, event, helper);
            }
            
        }else if(parent=='Yes'){
            if( component.find("parentName").get("v.value") == '' || component.find("parentName").get("v.value") == undefined || 
               component.find("regincorporationnumb").get("v.value") == '' || component.find("regincorporationnumb").get("v.value") == undefined || 
               component.find("numberOfBorrowerSignatureRequired").get("v.value") == '' || component.find("numberOfBorrowerSignatureRequired").get("v.value") == undefined || 
               component.find("numberOfDaysForBorrowerToAcceptOf").get("v.value") == '' || component.find("numberOfDaysForBorrowerToAcceptOf").get("v.value") == undefined)
                
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
            }else{
                helper.updateBorrowerInfo(component, event, helper);
            }}
            else{
                helper.updateBorrowerInfo(component, event, helper);
            }
        
        
        /*   else{
            helper.updateBorrowerInfo(component, event, helper);
            
        }*/
        
    },
    
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Borrower  Information Saved Successfully',
            message: 'Borrower  Information Saved Successfully!',
            duration:' 4000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    handleError : function(component, event, helper) {
        
        var componentName = 'CPFFacilityPrimarySecondaryAccountDetails';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        //helper.fireToast("Error!", "There has been an error saving the data.", "error");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: 'Error! There has been an error saving the data.',
            duration:' 4000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
        
    },
    
    // Adding Handler for applicationEvent
    handleApplicationEvent : function(component, event, helper) {
        var applicationId = event.getParam("applicationId");
        console.log('within the application event handler');
        // Condition to not handle self raised event
        if (applicationId != null && applicationId != '') {
            //calling Init on App Event
            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },
    
    
    
})