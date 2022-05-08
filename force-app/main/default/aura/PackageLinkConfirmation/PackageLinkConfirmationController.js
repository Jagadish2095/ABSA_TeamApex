({
    init : function(cmp, event, helper) {
       helper.GetIndicator(cmp, event, helper);
    },
    
    handleNavigate: function(component, event, helper) {
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");
        //var finshFlow="/flow/flowName?retURL=home/home.jsp"
        var finshFlow="home/home.jsp"
        switch(actionClicked)
        {
            case "NEXT": 
            case "FINISH":
                {   
                    // resolve handler
                    //navigate(finshFlow);
                   helper.navHome(component, event, helper);
                    //navigate(actionClicked);   
                    break;   
                }
            case "BACK":
                {
                    navigate(event.getParam("action"));
                    break;
                }
            case "PAUSE":
                {
                    navigate(event.getParam("action"));
                    break;
                }
        }
    }
	
})