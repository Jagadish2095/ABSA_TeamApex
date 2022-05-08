({
	hideChildCmp: function (component, event) {
        //hide all the components here
        var div1 = component.find("Guarantee");
        $A.util.addClass(div1, "slds-hide");
        
        var div2 = component.find("Agreement");
        $A.util.addClass(div2, "slds-hide");
        
        var div3 = component.find("Fulfilment");
        $A.util.addClass(div3, "slds-hide");
        }
})