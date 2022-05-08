({
    /*@ Author: Tinashe Shoko
 	**@ Date: 01/04/2020
 	**@ Description: Method that controlls submit actions of the component*/
    handleOnSubmit : function(component, event, helper) {
        event.preventDefault(); // prevent default submission of form so we do error handling
        helper.validateForm(component, event, helper); // field validation before form submission
    },

    handleSuccess : function(component, event, helper) {
        // Show toast
        helper.fireToast("Success!", "Franchise Group has been updated successfully.", "success");
    }
})