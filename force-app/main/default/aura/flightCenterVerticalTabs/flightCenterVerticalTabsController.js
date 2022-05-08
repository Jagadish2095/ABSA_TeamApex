({

    doInit: function (component, event, helper) {
        console.log('within the init of flight center of Vertical tabs');
       
    },

    

    toggleClass: function (component, event, helper) {
        helper.hideChildCmp(component, event); // Hide all components and show only selected child component
       
        var selectedvalue = component.get("v.selectedItem");
        console.log('value is' + selectedvalue);
        
        if (selectedvalue == "TabOne") {
            var divChild = component.find("Context");
            $A.util.removeClass(divChild, "slds-hide");
        }
        else if (selectedvalue == "Contract") {
            var divChild = component.find("Contract");
            $A.util.removeClass(divChild, "slds-hide")
        }    
        else {
            //  block of code to be executed if the condition1 is false and condition2 is false
        }
    },
})