({
    init: function (component, event, helper) {
        helper.setUserOptionsForSelect(component);
    },

    handleUserSelect : function (component, event, helper) {
        helper.setUserId(component);
    },

    handleSelectedUserChange :function (component, event, helper) {
        helper.setUserOptionsForSelect(component);
    }
});