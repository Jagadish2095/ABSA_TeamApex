({
    loadData : function(component,event) {
        
        component.set("v.showSpinner", true);
        
        var action = component.get("c.getIncomeLeft");
        
        action.setParams({
            "applicationId": component.get("v.applicationId")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                
                //set attribute values from results 
                
                component.set("v.incomeLeft", results);
                
            }else{
                var errors = response.getError();
                
                console.log('failed---'+state);
                
                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                component.find('branchFlowFooter').set('v.message', errors[0].message);
                component.find('branchFlowFooter').set('v.showDialog', true);
            }
            
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    finalScoringAsPromise : function(component, helper) {
        component.set("v.showSpinner", true);
        
        return new Promise(function(resolve, reject) {
            var action = component.get("c.applyFinalScoring");
            
            action.setParams({
                "applicationId": component.get("v.applicationId"),
                "applicationNumber": component.get("v.applicationNumber"),
                "preAssessedCreditLimit": component.get("v.preAssessedCreditLimit"),
                "lockVersionId" : component.get("v.lockVersionId"),
                "mayCheckCreditWorthiness" : component.get("v.consentSelected")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log('FinalScoring State: ' +state);
                if (state === 'SUCCESS') {
                    var returnValue = response.getReturnValue();
                    
                    var r = JSON.parse(returnValue);
                    
                    console.log('Status Code: ' +r.statusCode);
                    console.log('Status: ' +r.status);
                    
                    if (r.statusCode == 200)
                    {
                        if ((r.applyResponse.z_return.responseCommons != null) && 
                            (r.applyResponse.z_return.responseCommons.responseMessages != null) && 
                            (r.applyResponse.z_return.responseCommons.responseMessages.length > 0))
                        {
                            var s = "";
                            
                            for (var i = 0; i < r.applyResponse.z_return.responseCommons.responseMessages.length; i++)
                            {
                                console.log(r.applyResponse.z_return.responseCommons.responseMessages[i].message);
                                
                                s = s + r.applyResponse.z_return.responseCommons.responseMessages[i].message + "\r\n";
                            }
                            
                            reject( { isValid: false, errorMessage: s } );
                        } else {
                            component.set("v.scoringOutcome", r.applyResponse.z_return.application.creditStatus.id);
                            component.set("v.lockVersionId", r.applyResponse.z_return.application.lockVersionId);
                            resolve( { isValid: true, errorMessage: '', actionResult: returnValue} );
                        }
                    }
                    else
                    {
                        reject( { isValid: false, errorMessage: 'An error occured while scoring the client application: ' +r.status } );
                    }
                    
                } else {
                    var errors = response.getError();
                    
                    console.log('failed---'+state);
                    console.log(errors);
                    
                    var s = "";
                    
                    for (var i = 0; i < errors.length; i++)
                    {
                        s = s + errors[i].message;
                    }
                    
                    reject( { isValid: false, errorMessage: s } );
                }
            });
            $A.enqueueAction(action);
        });
    }
})