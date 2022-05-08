({
    init: function (component, event, helper) {
        helper.setUserOptionsForSelect(component);
        helper.setUserNumber(component);
    },
    handleUserSelect : function (component, event, helper) {
        helper.setUserId(component);
    },

    handleSelectedUserChange :function (component, event, helper) {
        helper.setUserOptionsForSelect(component);
    },

    // openPinpad :function (component, event, helper) {
    //     helper.fireSetPinEvent(component);
    // },

    handleNameChange  : function (component, event, helper) {
        helper.populateUserName(component);
    },

    handleIdChange  : function (component, event, helper) {
        helper.populateUserId(component);
    },

    handleCellphoneChange : function (component, event, helper) {
        helper.populateCellphone(component)
    }
});