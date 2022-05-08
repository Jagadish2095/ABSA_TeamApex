({
    canCaptureAbsaLifeProductDetails: function(component) {
        var opportunityId = component.get('v.opportunityId');
        var isIntegratedFlow = component.get('v.isIntergratedFlow');
        component.set("v.showSpinner", true);
        
        if(isIntegratedFlow){
            
            var action = component.get('c.isAbsaLifeSelectedInRoa');
            action.setParams({
                'oppotunityId': opportunityId
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if(state == "SUCCESS"){
                    var absaLifeRequired = response.getReturnValue() ;
                    
                    if(absaLifeRequired == false){
                        var navigate = component.get('v.navigateFlow');
                        navigate('NEXT');
                    }
                    
                } else{
                    var errors = response.getError();
                    if(errors) {
                        if(errors[0] && errors[0].message){
                            component.find('branchFlowFooter').set('v.heading', 'Failed to open account');
                            component.find('branchFlowFooter').set('v.message', errors[0].message);
                            component.find('branchFlowFooter').set('v.showDialog', true);
                        }
                        else{
                            console.log("unknown error");
                        }
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    updateSelectedAndCompletedProducts: function(component) {
        var opportunityId = component.get('v.opportunityId');
        
        var selectedPRoduct = component.get('v.productToCapture');
        var isApplicationCompleted = component.get('v.isApplicationCompleted');
        
        component.set("v.showSpinner", true);
        
        var action = component.get('c.getSelectedAndComletedProducts');
        action.setParams({
            'opportunityId': opportunityId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS"){
                var selectedProducts = response.getReturnValue() ;
                component.set('v.absaListProducts', selectedProducts); 
            } else{
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message){
                        component.find('branchFlowFooter').set('v.heading', 'Failed to open account');
                        component.find('branchFlowFooter').set('v.message', errors[0].message);
                        component.find('branchFlowFooter').set('v.showDialog', true);
                    }
                    else{
                        console.log("unknown error");
                    }
                }
            }
            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    ValidateSelections: function(component) {

        var products = component.get('v.absaListProducts');
        var hasSelection = false;
        var messageObj = { errors : [], message : ''};

       products.forEach(function(product){
            if(product.isSelected ){
                hasSelection = true;
                if(!product.isFuifilled){
                    messageObj.errors.push(product.productName  + ' is Selected but not completed');
                }
            }

       });
 
       if(messageObj.errors.length > 0){
            messageObj.message = 'Continue with Products fulfillment ?';
            component.set('v.validationErrors', messageObj);
            return false;
        }else if(!hasSelection){
           messageObj.message = 'Continue with Products fulfillment without an ABSA Life Products?';
           component.set('v.validationErrors', messageObj);
           return false;
       }

       return true;

    }
})