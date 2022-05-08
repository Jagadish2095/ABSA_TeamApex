({

    doInit: function (component, event, helper) {
        console.log('within the init of Origination of Vertical tabs');
       
    },

    /*trying to init the cmp on Attest popup for Lazy loading 
     Handler for applicationEvent */
    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        var opportunityId = event.getParam("opportunityId");
        console.log('within the application event handler raised from ' + sourceComponent);
        // Condition to not handle self raised event
        if ((sourceComponent == 'CobAttestationPopup' || sourceComponent == 'NonScoredApprovedFacilities') && (opportunityId != null && opportunityId != '')) {
            //calling Init on App Event
            var a = component.get('c.doInit');
            $A.enqueueAction(a);

        }
    },

    toggleClass: function (component, event, helper) {
        helper.hideChildCmp(component, event); // Hide all components and show only selected child component
       
        var selectedvalue = component.get("v.selectedItem");
        console.log('value is' + selectedvalue);
        
        if (selectedvalue == "TabOne") {
            var divChild = component.find("Guarantee");
            $A.util.removeClass(divChild, "slds-hide");
        }
        else if (selectedvalue == "Agreement") {
            var divChild = component.find("Agreement");
            $A.util.removeClass(divChild, "slds-hide")
        }
        else if (selectedvalue == "Fulfilment") {
            var divChild = component.find("Fulfilment");
            $A.util.removeClass(divChild, "slds-hide")
        }
       
        else {
            //  block of code to be executed if the condition1 is false and condition2 is false
        }
    },
})