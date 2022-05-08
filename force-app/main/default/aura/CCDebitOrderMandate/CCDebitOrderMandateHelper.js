({

    executeInitiateDebiCheck: function (component, event) {
        var action = component.get('c.callInitiateDebiCheck');
        var applicationId = component.get('v.applicationRecordId');
        var lockVersionId = component.get('v.lockVersionId');
        var ccApplicationNumber = component.get('v.ccApplicationNumber');
        action.setParams({
            'applicationId': applicationId,
            'applicationNumber': ccApplicationNumber,
            'lockVersionId': lockVersionId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var responseDate = response.getReturnValue();
                console.log('RESP ---', JSON.stringify(responseDate));
            }
        });
        $A.enqueueAction(action);
    },

    executeCompleteTwoHelper: function (component, event) {
        return new Promise(function (resolve, reject) {
            let action = component.get('c.callCompleteTwo');
            var applicationRecordId = component.get('v.applicationRecordId');
            var applicationNumber = component.get('v.ccApplicationNumber');
            var lockVersionId = component.get('v.lockVersionId');
            var cardProdSubProdGroupId = component.get('v.cardProdSubProdGroupId');
            action.setParams({
                'applicationId': applicationRecordId,
                'applicationNumber': applicationNumber,
                'lockVersionId': lockVersionId,
                'cardProdSubProdGroupId': cardProdSubProdGroupId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.completeTwoResult', response.getReturnValue());
                    var completeTwoResult = JSON.parse(response.getReturnValue());
                    if (completeTwoResult.statusCode == 200) {
                        if ((completeTwoResult.applyResponse.z_return.responseCommons != null) &&
                            (completeTwoResult.applyResponse.z_return.responseCommons.responseMessages != null) &&
                            (completeTwoResult.applyResponse.z_return.responseCommons.responseMessages.length > 0)) {
                            var resultError = '';
                            for (var i = 0; i < completeTwoResult.applyResponse.z_return.responseCommons.responseMessages.length; i++) {
                                console.log(completeTwoResult.applyResponse.z_return.responseCommons.responseMessages[i].message);
                                resultError = resultError + completeTwoResult.applyResponse.z_return.responseCommons.responseMessages[i].message + '\r\n';
                                resultError = resultError.replace('&lt;', '<');
                                resultError = resultError.replace('&gt;', '>');
                                if (resultError.includes("SubmitSalaryAccountDetails:")) {

                                }
                                if (resultError.includes("SubmitDebitOrderDetails:")) {

                                }
                            }
                            reject(resultError);
                        } else {
                            lockVersionId = completeTwoResult.applyResponse.z_return.application.lockVersionId;
                            component.set('v.lockVersionId', lockVersionId);
                            resolve(completeTwoResult);
                        }
                    } else {
                        reject(completeTwoResult);
                    }
                } else {
                    reject(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        })
    }
})