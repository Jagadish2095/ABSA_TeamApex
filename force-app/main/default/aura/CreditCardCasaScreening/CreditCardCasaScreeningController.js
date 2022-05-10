({
    init : function(component, event, helper) {
        console.log(`INIT...`);

        helper.callCasaPromise(component)
       .then(
            $A.getCallback(function(casaResult) {
                helper.handleSuccess(component, casaResult);
              }),
           $A.getCallback(function(error) {
               helper.handleError(component, casaResult);
           })
       )
       console.log(`INIT... END`);

   }
})