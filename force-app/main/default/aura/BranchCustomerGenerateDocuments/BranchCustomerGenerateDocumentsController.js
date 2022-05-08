({
    generateDocuments : function(component, event, helper) {
         var promise = helper.generateDocuments(component, helper)
        .then(
            $A.getCallback(function(result) {
                if (result.startsWith("Error")) {
                    helper.handleError(component, result);
                } else {
                    helper.handleSuccess(component);
                }
            }),
            $A.getCallback(function(error) {
                helper.handleError(component, error);
            })
        )
    }
})