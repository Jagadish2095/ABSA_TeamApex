({
    //Last modified 2021/05/28
    init: function(component, event, helper) {
        helper.fetchTranslationValues(component, 'v.relationshipOptions', 'CIFCodesList', 'Nextofkinrelationship', 'Outbound', 'Account', 'Next_of_Kin_Relationship__pc');
    },

    nextOfKinLoaded: function(component, event, helper) {
        var payload = event.getParam("recordUi");
        var firstName = payload.record.fields['Next_of_Kin_First_Name_s__pc'].value;
        var lastName = payload.record.fields['Next_of_Kin_Last_Name__pc'].value;
        var relationship = payload.record.fields['Next_of_Kin_Relationship__pc'].value;
        var cellphoneNumber = payload.record.fields['Next_of_Kin_Cellphone_Number__pc'].value;
        var telephoneNumber = payload.record.fields['Next_of_Kin_Telephone_Number__pc'].value;
        var emailAddress = payload.record.fields['Next_of_Kin_Email_Address__pc'].value;
        var mainCustomMobilePhone = payload.record.fields['PersonMobilePhone'].value;
        component.set("v.firstName", firstName);
        component.set("v.lastName", lastName);
        component.set("v.relationship", relationship);
        component.set("v.cellphoneNumber", cellphoneNumber);
        component.set("v.telephoneNumber", telephoneNumber);
        component.set("v.emailAddress", emailAddress);
        component.set('v.updating', false);
        component.set('v.mainCustomerCellNumber', mainCustomMobilePhone);
    },

    nextOfKinSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var firstName = component.get("v.firstName");
        var lastName = component.get("v.lastName");
        var relationship = component.get("v.relationship");
        var cellphoneNumber = component.get("v.cellphoneNumber");
        var telephoneNumber = component.get("v.telephoneNumber");
        var emailAddress = component.get("v.emailAddress");
        eventFields["Next_of_Kin_First_Name_s__pc"] = firstName;
        eventFields["Next_of_Kin_Last_Name__pc"] = lastName;
        eventFields["Next_of_Kin_Relationship__pc"] = relationship;
        eventFields["Next_of_Kin_Cellphone_Number__pc"] = cellphoneNumber;
        eventFields["Next_of_Kin_Telephone_Number__pc"] = telephoneNumber;
        eventFields["Next_of_Kin_Email_Address__pc"] = emailAddress;
        component.find('NextOfKinDetail').submit(eventFields);
    },
    
    nextOfKinError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
		component.set('v.updating', false);
    },
    
    nextOfKinSuccess : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = component.get('v.actionClicked');
        component.set('v.updating', false);
        navigate(actionClicked); 
    },
    
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        var globalId = component.getGlobalId();
        component.set('v.updating', true);
        component.set('v.actionClicked', actionClicked);
        
        switch(actionClicked)
        {
            case 'NEXT': 
            case 'FINISH':
                if (helper.checkValidity(component, helper) == 'pass') {
                    helper.handleRemoveValidation(component);
                    var promise = helper.executeValidate(component, helper)
                    .then(
                        $A.getCallback(function(result) {
                            document.getElementById(globalId + '_nextOfKin_submit').click();
                        }),
                        $A.getCallback(function(error) {
                            helper.handleAddValidation(component);
                            component.set('v.updating', false);
                        })
                    )
                    } else {
                        component.set('v.updating', false);
                    }
                break;
            case 'BACK':
            case 'PAUSE':
                if (helper.checkValidity(component, helper) == 'pass') {
                    document.getElementById(globalId + '_nextOfKin_submit').click();
                } else {
                    component.set('v.updating', false);
                    var ignoreValidity = confirm('Validation failed! Continue without saving?');
                    if (ignoreValidity) {
                        navigate(actionClicked); 
                    }
                }
                break;
        }
    }
})