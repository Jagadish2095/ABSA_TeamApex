({
    callCasaPromise : function(component) {
        return new Promise(function(resolve, reject) {
            console.log(`I PROMISE...`);

            component.set("v.showSpinner", true);
            var action = component.get("c.callCasaForAccountId");
            action.setParams({
                accountId: component.get("v.accountId"),
                opportunityId: component.get("v.opportunityId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var data = JSON.parse(response.getReturnValue());
                component.set("v.showSpinner", false);
                if(state == "SUCCESS"){
                    resolve(data);
                }else{
                    reject(data);
                }
            });
            $A.enqueueAction(action);
            component.set("v.showSpinner", true);
            console.log(`Calling CASA... I PROMISE :)`);

        })
    }, 

    handleError: function (component, casaResult) {
        component.set("v.casaStatus", casaResult.msg);
        component.set("v.showError", true);
        component.set("v.isSuccessful", false);
        console.log(`handleError: ${JSON.stringify(casaResult)}`);
    },

    handleSuccess: function (component, casaResult) {
        var dataMap = component.get("v.ccApplicationDataMap");
        var casaMap = new Map();

        if(dataMap == ""){
            dataMap = new Map();
        }else{
            dataMap = JSON.parse(dataMap);
        }

        casaMap["referenceNumber"] = casaResult.refNo;
        casaMap["status"] = casaResult.status;

        dataMap["casa"] = casaMap;

        component.set("v.ccApplicationDataMap", JSON.stringify(dataMap));

        if(casaResult.msg == "Success"){
            component.set("v.casaStatus", casaResult.status);
            component.set("v.showSuccess", true);
            component.set("v.isSuccessful", true);
        }else{
            component.set("v.casaStatus", casaResult.msg);
            component.set("v.casaStatus", casaResult.msg);
            component.set("v.showError", true);
            component.set("v.isSuccessful", false);
        }
        console.log(`handleSuccess: ${JSON.stringify(casaResult)}`);
    }
})