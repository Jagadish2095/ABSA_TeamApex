({
    fetchData: function(component, helper) {
        return new Promise(function(resolve, reject) {
            var oppId = component.get('v.oppurtunityId');
            //var getAppProdIdAction = component.get('c.getAppProdAndAccountWithFamily');
            var getAppProdIdAction = component.get('c.getAppProdAndAccount');
            getAppProdIdAction.setParams({
                oppId : oppId//,
               // productFamily : 'Savings'
            });
            getAppProdIdAction.setCallback(component, function(response) {
                var state = response.getState();
                if(state === 'SUCCESS' && component.isValid()){
                    var result = response.getReturnValue();
                    //var results = result.split(',');
                    component.set('v.applicationProdId',result.ApplicationId);
                    helper.executeIssueGhost(component, helper);
                    
                } else if (state == 'ERROR') {
                    var errorMessage = 'Unknown Error';
                    var errors = response.getError();
                    if(errors[0] && errors[0].message){
                        errorMessage = errors[0].message;
                    }
                    reject(errorMessage);
                }
            });
            $A.enqueueAction(getAppProdIdAction);
        });
    },
    
    executeIssueGhost: function(component, helper) {
        var oppurtunityId = component.get('v.oppurtunityId');
        var applicationId = component.get('v.applicationProdId');
        return new Promise(function(resolve, reject) {
            let action = component.get('c.issueGhostCard');
            action.setParams({
                'oppId': oppurtunityId,
                'applicationId': applicationId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set("v.debitCardNumber",response.getReturnValue());
                    component.set("v.showSpinner", false);
                    component.find('branchFlowFooter').set('v.nextDisabled', 'false');
                    resolve('SUCCESS')
                } else {
                    var errorMessage = 'Unknown Error';
                    var errors = response.getError();
                    if(errors[0] && errors[0].message){
                        errorMessage = errors[0].message;
                    }
                    component.set("v.showSpinner", false);
                    reject(errorMessage);
                }
                               
            });
            $A.enqueueAction(action);
        })
    },
    
})