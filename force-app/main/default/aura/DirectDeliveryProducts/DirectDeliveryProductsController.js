({
    doInit: function (component) {
        component.set('v.hasBeenEdited', false);
        component.set('v.selectedItem', 'Flexi_1');
        component.get("v.recordId");
        console.log( 'recordID = ' + component.get("v.recordId"));
        var action = component.get("c.getProducts");
        var recId = component.get("v.recordId");
        action.setParams({
        'OppId' : recId
    });
    action.setCallback(this, function(response) {
        if (response.getState() == "SUCCESS") {
            var StoreResponse = response.getReturnValue();
            console.log( 'resp[ = ' + response.getReturnValue());
            component.set("v.products",StoreResponse);
        }else{
            alert('Something went wrong..');
        }
    });
    $A.enqueueAction(action);

    },

    handleClick: function(component) {
        component.set('v.hasBeenEdited', true);
    },

    handleBeforeSelect: function(component, event) {
        if (component.get('v.hasBeenEdited')) {
            // Prevent the onselect handler from running
            event.preventDefault();

            component.set('v.asyncValidation', true);

            setTimeout($A.getCallback(function () {
                component.set('v.hasBeenEdited', false);
                component.set('v.selectedItem', event.getParam('name'));
                component.set('v.asyncValidation', false);
            }), 2000);
        }
    }
});