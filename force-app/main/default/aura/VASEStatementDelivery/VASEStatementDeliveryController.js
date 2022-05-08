({
    init: function(component, event, helper) {
        helper.estatmentDelivey(component, event, true);
    },

    EStatDeliverySection: function (component, event) {

    },
    eStatDeliveryButtonIcon: function (component, event, helper) {
        if (component.get('v.eStatDeliverySelected'))
        {
            component.set('v.eStatDeliverySelected', false);
            component.set('v.eStatDeliveryIconName', 'utility:add');
        }
        else {
            component.set('v.eStatDeliverySelected', true);
            helper.estatmentDelivey(component, event, false);
        }
    }
})