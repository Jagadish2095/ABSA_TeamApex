({
	doInit : function(component, event, helper) {

	},

	handleNavigate: function(component, event, helper) {
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");

		console.log(`${actionClicked} clicked !`);

		switch(actionClicked)
        {
            case 'NEXT':
            case 'FINISH':
                {
                   helper.callCasa(component, actionClicked);
		           break;
                }
            case 'BACK':
                {
                    navigate(actionClicked);
                    break;
                }
            case 'PAUSE':
                {
                    navigate(actionClicked);
                    break;
                }
        }
    }
})