({
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
        var btn=event.getSource('').get('v.label');
        if(btn != 'No')$A.get("e.force:closeQuickAction").fire();
    },
    cancelEdit: function(component, event, helper) {
        component.set("v.editInput", false);
        component.set("v.altAddress", '');
    },
    openEdit: function(component, event, helper) {
        component.set("v.editInput", true);
        component.set("v.altAddress", '');
    },
    submitDetails: function(component, event, helper) {
        component.set("v.loadSpinner", true);
        var cmpEvent = component.getEvent("EmailSenderEvent");
        cmpEvent.setParams({"isvalid" : true,"toAddress":component.get("v.altAddress")});
        cmpEvent.fire();
    },
    handleRemove: function(component, event, helper) {
        component.set("v.altAddress", '');
    },
    confirmAddress: function(component, event, helper) {
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var emailFieldValue = component.get("v.altAddress");
        var primaryAdd = component.get("v.toAddress");
        if(emailFieldValue.match(regExpEmailformat)){
            if(emailFieldValue.toLowerCase() != primaryAdd.toLowerCase()){
                component.set("v.isSaveAddress", true);
                component.set("v.isModalOpen", false);
            }
            else{
                alert('Alternative email should not be the same as Primary email!');
            }
        }
    },
    saveAddress: function(component, event, helper) {
        var btn=event.getSource('').get('v.label');
        if(btn === 'Yes'){
            component.set("v.loadSpinner", true);
            helper.updateAccountDetails(component);
        }
        else{
            component.set("v.editInput", false);
            component.set("v.isSaveAddress", false);
            component.set("v.isModalOpen", true);
        }
    }
})