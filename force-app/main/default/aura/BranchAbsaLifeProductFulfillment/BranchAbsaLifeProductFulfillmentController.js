({
    init : function(component, event, helper) {

        helper.canCaptureAbsaLifeProductDetails(component);
        helper.updateSelectedAndCompletedProducts(component);
        
    },
    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
                component.set('v.productToCapture','');
                component.set('v.flowAction','CONTINUE');

                if(helper.ValidateSelections(component)){
                    navigate(actionClicked);
                }
                else{
                    component.set('v.showConfirmDialog','True'); 
                }
                break;
            case 'BACK':
                navigate(actionClicked);
                break;
            case 'PAUSE':
                navigate(actionClicked);
                break;
        }
    },
    handleConfirmDialogYes : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        var navigate = component.get('v.navigateFlow');
        navigate('NEXT');
    },
     
    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
    },
    handleProductSelectionEvent : function(component, event, helper){
        
        var opportunityId = component.get('v.opportunityId');
        var productName = event.getParam('productToCapture')
        component.set('v.productToCapture', productName);
        component.set('v.flowAction', event.getParam('flowAction'));
        
        var evt = event.setParam('opportunityIdResult', opportunityId)
       
        
        var navigate = component.get('v.navigateFlow');
        
        var action = component.get('c.updateAbsaLifeOpportunityWithProducts');
        
        action.setParams({
            'opportunityId':opportunityId,
            'prodName':productName
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS"){
                var oppLineItemId = response.getReturnValue();
                component.set('v.opportunityLineItemId', oppLineItemId);
                var navigate = component.get('v.navigateFlow');
                navigate('NEXT');
                
            } else{
                
            }
        });
        
        $A.enqueueAction(action);
    }
})