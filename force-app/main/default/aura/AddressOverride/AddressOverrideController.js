({
    init: function (component, event, helper) {
        
        //Get address record details id recordId exist
        if(component.get("v.recordId") != null) {
            console.log('recordId : ' + component.get("v.recordId"));
            helper.getAddressRecordDetails(component,event, helper);
        } 
        //Get ParentId based on where you add a new Address
        else {
            helper.getParentRecordDetails(component,event, helper);
        }
        
    },   
    
    actionAddressCreation: function (component, event, helper) {
        helper.upsertAddressRecord(component,event, helper);
    },
    
    closeNewAddressModal: function (component, event, helper) {
        helper.closeComponent(component,event, helper);
    }
})