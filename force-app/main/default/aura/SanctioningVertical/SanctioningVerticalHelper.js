({
	 hideChildCmp: function (component, event) {
        //hide all the components here
        var div1 = component.find("div1");
        $A.util.addClass(div1, "slds-hide");
        var div2 = component.find("div2");
        $A.util.addClass(div2, "slds-hide");
        var div3 = component.find("div3");
        $A.util.addClass(div3, "slds-hide");
        var div4 = component.find("div4");
        $A.util.addClass(div4, "slds-hide");
        var div5 = component.find("div5");
        $A.util.addClass(div5, "slds-hide");
        var div6 = component.find("div6");
        $A.util.addClass(div6, "slds-hide");
      
        
    }
})