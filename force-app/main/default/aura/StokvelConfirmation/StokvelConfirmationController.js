({
	 doInit: function(component, event, helper) {         
        // var navigate = component.get("v.navigateFlow");         
         var homeEvent = $A.get("e.force:navigateToURL");
        homeEvent.setParams({
            "url": "/home/home.jsp"
        });
        homeEvent.fire();
        $A.get('e.force:refreshView').fire();
     }
})