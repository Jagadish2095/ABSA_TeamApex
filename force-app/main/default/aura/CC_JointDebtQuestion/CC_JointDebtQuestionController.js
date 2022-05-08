({
    doInit : function(component, event, helper) {

	},
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        //navigate(actionClicked);
        console.log(`${actionClicked} clicked !`);

		//navigate(actionClicked);

		switch(actionClicked)
        {
			//console.log(`${actionClicked} clicked`);

            case 'NEXT':
            case 'FINISH':
                {
                    helper.callFinalScoring(component, actionClicked);
					//navigate('NEXT');
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
    },
    handlecheck2: function(component,event){
        component.set("v.nextDisabled", false);
        component.set("v.checked",false);
        alert(document.getElementById('checkbox2').value);
    },
    handlecheck1: function(component,event){
        alert(document.getElementById('checkbox1').value);
    }


})