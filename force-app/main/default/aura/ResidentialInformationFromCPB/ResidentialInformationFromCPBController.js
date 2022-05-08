({
    doInit : function(component, event, helper) {
    helper.getResidentialDetails(component,event)
    }, 

    assignResidentialInformation: function (component, event, helper) {
        helper.helperAssignCIFValues(component, event);
    },
    onclick: function(component, event, helper){
        component.set('v.isEdit', false);
    },
    getModifiedInformation: function (component, event, helper) {
        helper.helperGetInformation(component, event);
    },
    getCPBaddress: function (component, event, helper){
        helper.helperCPBaddress(component, event);
    }
})