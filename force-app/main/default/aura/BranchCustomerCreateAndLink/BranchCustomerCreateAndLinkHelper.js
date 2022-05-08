({
    fetchTranslationValues: function(component, listName, systemName, valueType, direction) {
        var action = component.get('c.getTranslationValues');   
        action.setParams({
            'systemName': systemName,
            'valueType': valueType,
            'direction': direction,
        });
        action.setCallback(this, function(response) {
            var mapValues = response.getReturnValue();
            var listValues = [];
            for(var itemValue in mapValues) {
                listValues.push(mapValues[itemValue]); 
            }
            listValues.sort();
            component.set(listName, listValues);
        });
        $A.enqueueAction(action);
    },

    fetchValidatedTranslationValues: function(component, listName, systemName, valueType, direction, objName, objField) {
        var action = component.get('c.getValidatedTranslationValues');
        var objObject = { 'sobjectType': objName };
        action.setParams({
            'systemName': systemName,
            'valueType': valueType,
            'direction': direction,
            'objObject': objObject,
            'objField': objField
        });
        action.setCallback(this, function(response) {
            var mapValues = response.getReturnValue();
            var listValues = [];
            for(var itemValue in mapValues) {
                if (mapValues[itemValue] == 'valid') {
                    listValues.push(itemValue);
                    console.log(itemValue);
                } else {
                    // Add function to log/mail system admin with missing values
                }
            }
            listValues.sort();
            component.set(listName, listValues);
        });
        $A.enqueueAction(action);
    },

    fetchAccountOpeningReasonsValues: function(component, listName, valueType, direction) {
        var action = component.get('c.getTranslationValuesByFamily');
        var oppId = component.get("v.opportunityId");
        
        action.setParams({
            'opportunityId': oppId,
            'valueType': valueType,
            'direction': direction,
        });
        action.setCallback(this, function(response) {
            var mapValues = response.getReturnValue();
            var listValues = [];
            for(var itemValue in mapValues) {
                listValues.push(mapValues[itemValue]); 
            }
            listValues.sort();
            component.set(listName, listValues);
        });
        $A.enqueueAction(action);
    },

    loadProductData : function(component,event) {
        component.set("v.showSpinner", true);
        var opportunityId = component.get("v.opportunityId");
        var appId = component.get("v.applicationId");

        var action = component.get("c.getProductDetails");
        action.setParams({
            oppId: opportunityId,
            "applicationId": appId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.productFamily", results.ProductFamily);
                component.set("v.sourceOfFunds", results.SourceOfFunds);  
                component.set("v.IsChequeProduct", results.ProductFamily == 'Cheque');
                component.set("v.IsGroupScheme", results.IsGroupScheme);
                component.set("v.IsSpousal", results.IsSpousal);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
})