({
    CallCTFSPreScreen : function(component, helper) {    
        return new Promise(function(resolve, reject){
            component.set('v.updating', true);
            let action = component.get('c.cCApplicationPreScreen');
            var RecordId = component.get("v.recordId");
            action.setParams({
            "accountID" : RecordId
            });
            action.setCallback(this, function (response){
            var state = response.getState();
                if (state === 'SUCCESS') {
                    var results = JSON.parse(response.getReturnValue());
                    if (results.statusCode == 200)
                    {  
                    if (results.applyResponse.z_return.responseCommons.z_success == 'TRUE'){
                        component.set("v.CCApplicationNumber",results.applyResponse.z_return.application.applicationNumber);
                        component.set("v.lockVersionId",results.applyResponse.z_return.application.lockVersionId);
                        resolve('Continue');
                    }else{
                        console.log('failed---'+state);
                        reject( { isValid: false, errorMessage: results.applyResponse.z_return.responseCommons.responseMessages[0].message } );
                    }
                }else{
                    var errors = response.getError();
                    reject( { isValid: false, errorMessage: JSON.stringify(errors[0]) });
                }
              }else{
                reject( { isValid: false, errorMessage: results.statusCode });
              }
            });
            $A.enqueueAction(action);
        });
    }
})