({

    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that get called on initialization loads to setup component data*/
    doInit : function(component, event, helper){
        helper.getBankingDetails(component, event, helper);
        var applicationId = component.get("v.applicationId");
        console.log("applicationId : " + applicationId);
        if($A.util.isEmpty(applicationId)){
            helper.getApplication(component);
        }
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method calls the helper method to open the modal*/
    openModal : function(component, event, helper){
        helper.openModal(component, event, helper);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method calls the helper method to close the modal*/
    closeModal : function(component, event, helper){
        helper.closeModal(component, event, helper);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method that controlls component load time actions*/
    handleOnLoad : function(component, event, helper){
        helper.hideSpinner(component, event, helper);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 09/04/2020
 	**@ Description: Method that controlls submit actions of the component*/
    handleSubmit : function(component, event, helper) {

        event.preventDefault();
        var isError = helper.validateMotivation(component, event, helper);
        console.log('*INSIDE handleSubmit==>: '+isError);

        if (!isError) {
            var eventFields = event.getParam("fields");
            console.log('-------SAVING FORM---------');
            console.log('*INSIDE handleSubmit==>: '+JSON.stringify(eventFields));
            component.find('motivationBankingDetailsForm').submit(eventFields);
        }
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method that controlls component success time actions*/
    handleSuccess : function(component, event, helper){

        helper.closeModal(component, event, helper);

        // Show toast
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": "Record has been updated successfully."
        });
        toastEvent.fire();
    },

    handleError : function(component, event, helper){
        var componentName = 'MultiBankingDetailsSection';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "Banking Details: There has been an error saving the data.", "error");
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationId = event.getParam("applicationId");
        component.set("v.applicationId", applicationId);
    },

    executeSaveFormMethod : function(component, event, helper) {

        var componentLabels = component.get("v.componentLabels");

        for (var i = 0; i < componentLabels.length; i++) {
            // Set cmpFormStatus to 'unknown' so that the child component can update
            // it to 'valid' or 'invalid'
            component.set('v.cmpFormStatus_' + componentLabels[i], 'unknown');

            // Fire the saveFormMethod for each child component
            var childComponent = component.find(componentLabels[i]);
            childComponent.saveFormMethod();
        }

        // Cancel the already running wait cycle
        if (component.get('v.waitCycleId')) {
            clearTimeout(component.get('v.waitCycleId'));
        }

        // Timeout duration for waiting for saving all child components
        var timeoutDuration = 15000; // 15 seconds

        var timeoutId = setTimeout($A.getCallback(function() {

            // If still in wait cycle after timeout duration, then stop the wait cycle and
            // show error to the user. This is a safety net to prevent waiting endlessly.
            if (component.get('v.waitCycleId')) {
                helper.hideSpinner(component);
                // Stop the wait cycle
                component.set('v.waitCycleId', null);
                component.set('v.cmpFormStatus', 'invalid');
                helper.fireToast('Error', 'Banking Details Section: Timeout occurred while saving Application. Either try again or please contact the administrator.', 'error');
                return;
            }
        }), timeoutDuration);

        // Start the wait cycle
        component.set('v.waitCycleId', timeoutId);
    },

    // PJAIN: 20200509
    // Below method ensures that application generation waits for the saveFormMethod operation
    // to be  processed by all components. This method is needed because the save operation
    // runs asynchronously. This method is called when cmpFormStatus is updated for any component.
    // Processing happens only when in wait cycle AND all components have set the cmpFormStatus
    // attribute to either valid or invalid. Once the conditions are met, either the application
    // is generated or message with invalid component names is shown.
    handleCmpFormStatusChange: function(component, event, helper) {

        // If not in wait cycle, then exit the function and stop processing
        if (!component.get('v.waitCycleId')) {
            return;
        }

        var componentLabels = component.get('v.componentLabels');
        var isValid = false;

        for (var i = 0; i < componentLabels.length; i++) {
            var cmpFormStatus_Child = component.get('v.cmpFormStatus_' + componentLabels[i]);

            if (cmpFormStatus_Child === 'unknown') {
                // If the child form has not been saved yet, then exit the function and stop processing
                return;
            } else if (componentLabels[i] === 'MerchantBusinessBankingDetailsCmp' && cmpFormStatus_Child === 'valid') { // PJAIN: 20200527: To have Business Banking details mandatory
                isValid = true;
            }
        }

        // Stop the wait cycle
        clearTimeout(component.get('v.waitCycleId'));
        component.set('v.waitCycleId', null);

        if(isValid){
            component.set('v.cmpFormStatus', 'valid');
        } else {
            component.set('v.cmpFormStatus', 'invalid');
        }
    },

})