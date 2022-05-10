({
    init: function(component, event, helper) {
        component.set(' v.annualIncreasesOptions', helper.getAnnualIncreasesOptions());
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        component.set('v.updating', false);
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
                var confirmed = helper.confirmInfo(component);
                component.set('v.updating', false);
                if (confirmed) {
                    navigate(actionClicked);
                }
                break;
            case 'BACK':
            case 'PAUSE':
                component.set('v.updating', false);
                navigate(actionClicked);
                break;
        }
    }
})