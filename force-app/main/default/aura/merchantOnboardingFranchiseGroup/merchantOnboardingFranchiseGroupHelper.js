({
    validateForm : function(component, event, helper) {
        var isPartOfFranchise = component.find('isPartOfFranchise').get('v.value');
        var franchisePriceScheme = component.find("franchisePriceScheme").get("v.value");

        if (isPartOfFranchise && $A.util.isEmpty(franchisePriceScheme)) {
            helper.fireToast("Error!", "Franchise Price Scheme cannot be blank.", "error");
        } else {
            var fields = event.getParam('fields');
            component.find("FranchiseGroupForm").submit(fields); // no errors so submit form
        }
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})