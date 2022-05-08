({
    init : function(component, event, helper) {
        helper.SetupStandAloneCheque(component, event, helper);
    },
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        component.set('v.actionClicked', actionClicked);
        
        switch(actionClicked) {
            case 'NEXT': 
            case 'FINISH': 
                helper.SetupStandAloneCheque(component, event, helper);
                break;
            case 'BACK':
                navigate(actionClicked);
                break;
            case 'PAUSE':
                navigate(actionClicked); 
                break;
        }
    }
})