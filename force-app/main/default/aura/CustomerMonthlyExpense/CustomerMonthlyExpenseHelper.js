({
    clientUpdateAsPromise : function(component, helper) {
        return new Promise(function(resolve, reject) {
            var de = component.find("monthlyExpenses");
            var le = component.find("monthlyLivingExpenses");

            try {
                console.log("Saving expenses");
                de.updateExpenses();
                le.updateLivingExpenses();

                resolve( { isValid: true, errorMessage: '', actionResult: ''} );
            }
            catch(err) {
                reject( { isValid: false, errorMessage: 'Error while saving expenses: ' + err } );
            }
        });     
    }
})