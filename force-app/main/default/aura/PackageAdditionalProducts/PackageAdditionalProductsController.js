({
    init: function(component, event, helper) {
        helper.getProductValues(component);
        helper.getQuotationValues(component);
        component.set('v.updating', false);
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        component.set('v.updating', true);

        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
                var confirmed = helper.checkAdditionalProducts(component);
                if (confirmed) {
                    var promise = helper.executeCompleteOne(component, helper)
                    .then(
                        $A.getCallback(function(result) {
                            component.set('v.updating', false);
                            navigate(actionClicked);
                        }),
                        $A.getCallback(function(error) {
                            component.find('branchFlowFooter').set('v.heading', 'Error executeCompleteOne');
                            component.find('branchFlowFooter').set('v.message', JSON.stringify(error));
                            component.find('branchFlowFooter').set('v.showDialog', true);
                            component.set('v.updating', false);
                        })
                    )
                    } else {
                        component.set('v.updating', false);
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