({
	
    doInit: function (component, event, helper) {
        helper.populateContracts(component);
    },

    showCloseModal: function (component, event, helper) {
        helper.toggleModal(component);
    },

    stopPropagation: function (component, event, helper) {
        event.stopPropagation();
    }

})