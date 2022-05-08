({
    doInit: function (component, event, helper) {
        helper.populateChequeDetails(component);
    },

    showCloseModal: function (component, event, helper) {
        helper.toggleModal(component);
    },

    stopPropagation: function (component, event, helper) {
        event.stopPropagation();
    }
})