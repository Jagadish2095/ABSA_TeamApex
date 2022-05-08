({
    init : function(component, event, helper) {
        helper.setActionsAvailable(component);
    },

    checkAvailableActions : function(component, event, helper) {
        helper.setActionsAvailable(component);
    },

    onButtonPressed: function(component, event, helper) {
        helper.fireEvent(event);
    }
})