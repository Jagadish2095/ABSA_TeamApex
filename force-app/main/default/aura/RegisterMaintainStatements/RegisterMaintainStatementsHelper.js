({
    promiseGetAccount : function(component){
        console.log('The recordId value is ===>' +JSON.string)
        return this.createPromise(component, "c.getAccountDetails", {
            clientAccountId: component.get("v.recordId")
        });
        
    },
    
	createPromise : function(component, name, params) {
        
        return new Promise(function(resolve, reject){
            let action = component.get(name);
            if (params) {
                action.setParams(params);
            }
            action.setCallback(this, function(response){
                               let state = response.getState();
            if (component.isValid() && state == "SUCCESS") {
                let result = response.getReturnValue();
                resolve(result);
            }
            else {
                reject(response.getError());
            }
            });
        $A.enqueueAction(action);
     });
    },
    submitRequest : function(component , event){
        
    }
 })