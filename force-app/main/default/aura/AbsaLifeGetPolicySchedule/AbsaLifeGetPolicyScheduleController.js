({
	doInit : function(component, event, helper) {
        helper.showSpinner(component);
		helper.getPolicyData(component, event, helper);
		component.set('v.benefitsColumns', [
            {label: 'First Name', fieldName: 'firstName', type: 'text'},
            {label: 'Surname', fieldName: 'surname', type: 'text'},
            {label: 'Component Type', fieldName: 'benefitType', type: 'text'},
            {label: 'Commencement Date', fieldName: 'commencementDate', type: 'text'},
            {label: 'Cover', fieldName: 'cover', type: 'text'},
            {label: 'Premium', fieldName: 'premium', type: 'text'}
        ]);
	},
    
    handleCommunicationType: function (component, event, helper) {
        component.set("v.showPreview", true);
        var isInForceStatus = component.get("v.status");
        if(isInForceStatus == "In force"){
            component.set("v.isInForceStatus", true);
        }else{
            component.set("v.errorMessage", "Policy is not in force!");
        }
        
        var selectedCommunicationType = event.getParam("value");
        component.set("v.selectedCommunicationType", selectedCommunicationType);
        if(selectedCommunicationType == "email"){
            component.set("v.commButtonLabel", "Send Email");
        }else{
            component.set("v.commButtonLabel", "Post");
        }        
    },
    
    handleOnLoad: function (component) {
        
        var nameFieldValue = component.find("nameField").get("v.value");
        var clientName = nameFieldValue.FirstName + " " +nameFieldValue.LastName;
        component.set("v.clientName", clientName);
        
        var emailFieldValue = component.find("clientEmailAddress").get("v.value");
        component.set("v.clientEmail", emailFieldValue);
	},
    handlePreview: function (component, event, helper) {
        helper.showSpinner(component);
        helper.handlePreviewHelper(component, event, helper);
	},
    
    handleCloseModal: function (component, event, helper) {
        
        component.set("v.isShowModal", false);
		component.set("v.isShowPreviewModal", false);
        component.set("v.isPostCommunication", false);
        component.set("v.isEmailCommunication", false);
        component.set("v.commButtonLabel", " ");
        helper.hideSpinner(component);
	},
    
    communicationTypeAction: function (component, event, helper) {
        helper.showSpinner(component);
       var selectedCommunicationTypeAction = event.getSource().get("v.label");
        if(selectedCommunicationTypeAction == "Send Email"){
            component.set("v.commButtonLabel", "Confirm");
            component.set("v.isShowPreviewModal", false);
            component.set("v.isEmailCommunication", true);
            helper.hideSpinner(component);
        }else if(selectedCommunicationTypeAction == "Post"){
            component.set("v.commButtonLabel", "Download");
            component.set("v.isShowPreviewModal", false);
            component.set("v.isPostCommunication", true);
            helper.hideSpinner(component);
        }else if(selectedCommunicationTypeAction == "Confirm"){
            component.set("v.isShowPreviewModal", false);
            component.set("v.isPostCommunication", false);
            helper.sendEmailHelper(component, event, helper);
        }else if(selectedCommunicationTypeAction == "Download"){
            component.set("v.isShowModal", false);
            component.set("v.isShowPreviewModal", false);
        	component.set("v.isPostCommunication", false);
        	component.set("v.isEmailCommunication", false);
            helper.downloadPolicyScheduleHelper(component, event, helper);
        }
	}
})