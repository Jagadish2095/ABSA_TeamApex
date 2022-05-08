({

    doInit: function (component, event, helper) {
        console.log('within the init of Origination of Vertical tabs');
    },

    
    toggleClass: function (component, event, helper) {
        helper.hideChildCmp(component, event); // Hide all components and show only selected child component
        var selectedvalue = component.get("v.selectedItem");
        console.log('value is' + selectedvalue);
        if (selectedvalue == "TabOne") {
            var divChild = component.find("div1");
            $A.util.removeClass(divChild, "slds-hide");
        }
        else if (selectedvalue == "TabTwo") {
            var divChild = component.find("div2");
            $A.util.removeClass(divChild, "slds-hide")
        }
        else if (selectedvalue == "TabThree") {
            var divChild = component.find("div3");
            $A.util.removeClass(divChild, "slds-hide")
        }
        else if (selectedvalue == "TabFour") {
            var divChild = component.find("div4");
            $A.util.removeClass(divChild, "slds-hide");
        }
        else if (selectedvalue == "TabFive") {
            var divChild = component.find("div5");
            $A.util.removeClass(divChild, "slds-hide");
        }
        else if (selectedvalue == "TabSix") {
            var divChild = component.find("div6");
            $A.util.removeClass(divChild, "slds-hide");
        } 
        else {
            
            //  block of code to be executed if the condition1 is false and condition2 is false
        }
    },
})