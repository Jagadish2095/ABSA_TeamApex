({
	 navHome : function (component, event, helper) {       
        var homeEvent = $A.get("e.force:navigateToURL");
        homeEvent.setParams({
            "url": "/home/home.jsp"
        });
        homeEvent.fire();
     }
})