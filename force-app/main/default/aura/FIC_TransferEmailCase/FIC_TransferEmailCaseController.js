({
    doInit: function (component, event, helper) {
        component.set("v.options", [
            'Email is relevant',
            'Email relevant to other department',
            'Email not relevant, send case to junk queue',
            'Manually send an email to the relevant recipient group'
        ]);
        component.set("v.departmentsList", [
            'Non-Res',
            'Business Bank',
            'Private Bank',
            'Admin Team'
        ]);
    },

    sendToQueue: function (component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
        let action = component.get("c.transferCase");
        action.setParams({
            caseId: component.get("v.recordId"),
            selectedOption: component.get("v.optionSelected"),
            departmentSelected: component.get("v.departmentSelected"),
            emailSubject : component.get("v.emailSubject"),
            emailsBody : component.get("v.emailBody")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log("success");
                $A.util.addClass(spinner, "slds-hide");
                $A.get('e.force:refreshView').fire();
            } else if (state === "ERROR") {
                let errors = response.getError();
                component.set("v.errorMessage", "Apex error details: " + JSON.stringify(errors));
                console.log(component.get("v.errorMessage"));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
                console.log(component.get("v.errorMessage"));
            }
        });
        $A.enqueueAction(action);
        component.set("v.showSpinner", false);
    },

    activeButton : function(component){
        let emailDepartment = component.get("v.departmentSelected");
        let emailSubject = component.get("v.emailSubject");
        let emailBody = component.get("v.emailBody");
        if(emailDepartment !== '' && emailSubject !== '' && emailBody !== '' ){
            component.set('v.isButtonActive',false);
        }
    },

    closeModal: function (component) {
        component.set("v.isModalOpen",false);
    },
    openModal: function (component) {
        component.set("v.isModalOpen",true);
    }
});