({
    doInit: function(component, event, helper) {
        console.log('doint....');
        component.set("v.showSpinner",true);
        helper.checkUserAccess(component);
    },
    onLoad:function(component,event,helper){
        var checkedArray = [];
        var changeType = event.getParams().changeType;
        if (changeType === "LOADED") {
            //checkedArray.push(component.get("v.opportunityRecord").STI_DOB__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Postal_Address__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Physical_Address__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Email_Address__c);
            //checkedArray.push(component.get("v.opportunityRecord").STI_Middle_name__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Full_Name__c);
            checkedArray.push(component.get("v.opportunityRecord").STI_Id_Number__c);
            checkedArray.push(component.get("v.opportunityRecord").Inv_Phone_Number__c);
            var checkedFieldsCount = checkedArray.filter(function(obj){ return obj===true; }).length;
            console.log('checkedFieldsCount'+checkedFieldsCount);
            console.log('checkedFields'+checkedFieldsCount);
            if((component.get("v.opportunityRecord").STI_Id_Number__c)===true && checkedFieldsCount>=3){
                component.set("v.isCheckboxEnabled",true);
                component.set("v.isVerificationSuccess",true);
            }
            else{
                component.set("v.isCheckboxEnabled",false);
                component.set("v.isVerificationSuccess",false);
            }
            if(component.get("v.mode") === 'EDIT'){
                helper.renderIdType(component,event);
            }
        }
        if (changeType === "ERROR") {
        }
        
        component.set("v.showSpinner",false);
    },
    
    handleCheckbox:function(component, event, helper) {
        console.log('Inside handlecheckbox');
        helper.enableSubmit(component,event);
    },
    handleSaveRecord:function(component,event,helper){
        component.set("v.showSpinner",true);
        component.set("v.isSubmitEnabled",true);
        component.find("recordLoader").saveRecord($A.getCallback(function(response) {
            if (component.isValid() && response.state == "SUCCESS") {
                component.set("v.isCheckboxEnabled",true);
                $A.get('e.force:refreshView').fire();                 
                component.set("v.showSpinner",false);
            } else if (response.state == "ERROR") {
                console.log(response.error[0].message);
                var record = component.get("v.opportunityRecord");
                record.STI_Postal_Address__c = false;
                record.STI_Physical_Address__c = false;
                record.STI_Email_Address__c = false;
                record.STI_Full_Name__c = false;
                record.STI_Id_Number__c = false;
                record.Inv_Phone_Number__c = false;
                component.set("v.opportunityRecord",record);
                component.find('notifLib').showToast({
                    variant: 'error',
                    message: response.error[0].message,
                    mode: 'sticky'
                });
                component.set("v.showSpinner",false);
            }
        }));
    },
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    }
})