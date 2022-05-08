({
    getOpportunityLineItemIdJS: function(component) {

        var action = component.get("c.getOpportunityLineItemId");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();

                if(!$A.util.isEmpty(responseValue)){
                    component.set("v.opportunityLineItemId", responseValue);
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                component.set("v.errorMessage", "getOpportunityLineItemId: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "getOpportunityLineItemId: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 05/05/2020
 	**@ Description: Method that resets the value of an inputField to the original (database value)
     **               This would work if the field is an Array (multiple fields with the same id) of fields or just a single field element*/
    resetFieldValue : function(component){

        let fields = component.get("v.resetFieldsList");
        for(var i = 0; i<fields.length; i++){
            var thisField = component.find(fields[i]);
            var isFieldArray = Array.isArray(thisField);

            if(isFieldArray){
                thisField.forEach(function(field) {
                    if(field){
                        field.reset();
                    }
                });
            }else{
                if(thisField){
                    thisField.reset();
                }
            }
        }
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})