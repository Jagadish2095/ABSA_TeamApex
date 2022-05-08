({
    init: function (component, event, helper) {

        var recordId = component.get("v.recordId");
        var action = component.get("c.getLinkedAccount");
        action.setParams({ "caseId": recordId });

        console.log('SendSMSController.init starting...');

        component.set('v.loading', true);

        action.setCallback(this, function (response) {

            var state = response.getState();

            console.log('state=' + state);

            component.set('v.loading', false);

            if (state === "SUCCESS") {
                var output = response.getReturnValue();

                if (output[0]) {
                    component.set("v.linkedAccount", true);
                }
                else {
                    component.set("v.linkedAccount", false);
                }
                if (output[1]) {
                    component.set("v.mobileNumber", output[1]);
                }
            }
            else {
                $A.get("e.force:closeQuickAction").fire();

                helper.showErrors(response.getError());
            }
        });
        $A.enqueueAction(action);

        var action = component.get("c.getQuickTextTemplates");
        action.setParams({ "folderName": 'Contact Centre' });
        component.set('v.loading', true);

        action.setCallback(this, function (response) {

            var state = response.getState();

            console.log('state=' + state);

            component.set('v.loading', false);

            if (state === "SUCCESS") {
                var output = response.getReturnValue();

                console.log(output);

                console.log('output.length' + output.length);

                component.set('v.quickTextOptions', output);
            }

            else {
                $A.get("e.force:closeQuickAction").fire();

                helper.showErrors(response.getError());
            }
        });
        $A.enqueueAction(action);
    },

    dosendSMS: function (component, event, helper) {

        console.log('sendSMS onClickHandler starting...');

        helper.showSpinner(component);

        var selectSmsTemplate = component.find('selectSmsTemplate');

        var action = component.get("c.sendSMSQuickAction");

        var recordId = component.get("v.recordId");
        var phoneNo = component.get("v.mobileNumber");
        var smsTemplateName = component.get("v.selectedSmsTemplateName");

        console.log('caseID' + recordId);
        console.log('phoneNo' + phoneNo);
        console.log('SMS template Name' + smsTemplateName);

        action.setParams({ "caseId": recordId, "phoneNumber": phoneNo, "quickTextName": smsTemplateName });

        component.set('v.loading', true);

        action.setCallback(this, function (response) {

            var state = response.getState();

            console.log('state=' + state);

            component.set('v.loading', false);

            if (component.isValid() && state === "SUCCESS") {

                var output = response.getReturnValue();
                console.log('successfully called the Apex Controller');

                //Show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Sending SMS",
                    "type": "success"
                });

                toastEvent.fire();

                helper.hideSpinner(component);
                helper.navHome(component, event, helper);
                // refresh record detail
                $A.get("e.force:refreshView").fire();
               
            }

            else if (state === "ERROR") {
                var errors = response.getError();

                helper.handleErrors(response.getError());
                helper.hideSpinner(component);
            }
        });


        if (smsTemplateName === '--Select sms template--') {

            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "Warning",
                "message": "Please select a valid sms template",
                "type": "warning"
            });

            toastEvent.fire();

            helper.hideSpinner(component);

        }

        if (phoneNo === undefined || phoneNo === null || phoneNo === '') {

            var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title": "Warning",
                "message": "Please enter a Phone Number",
                "type": "warning"
            });

            toastEvent.fire();

            helper.hideSpinner(component);

        }

        else {

            $A.enqueueAction(action);
        }

    }

})