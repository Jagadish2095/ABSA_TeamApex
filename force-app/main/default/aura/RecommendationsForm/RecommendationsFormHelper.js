({
    checkUserAccess: function (component){
        var action = component.get("c.getUserAccess");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('retrunValue' + JSON.stringify(returnValue));
                if (returnValue != null){
                    component.set("v.hasRecordAccess",true);
                    component.set("v.isNotAdvisor",returnValue['recommendationAccess']);
                    if(returnValue['recordAccess']){
                        component.set("v.mode","EDIT");
                    }
                    else{
                        component.set("v.mode","VIEW");
                    }
                    component.find("recordLoader").reloadRecord();
                }
            }
        });
        $A.enqueueAction(action);
    },
    getSelectedProduct: function (component) {
        var action = component.get("c.getOpportunityLineItem");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log('retrunValue' + JSON.stringify(returnValue));                
                if (returnValue != null){
                    component.set("v.showSpinner",false);                    
                    component.set("v.oppLineItem", returnValue);                    
                    if(returnValue.lineItem.Product2Id != null)component.set("v.isProductAdded", true);
                }
            }
            else if(state == "ERROR")
            {
                console.log('error is'+response); 
                component.set("v.isProductAdded", false);                
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    updateOpportunityLineItem: function (component) {
        var objectData = component.get("v.oppLineItem");
       console.log('updated dat, ',objectData);
        var action = component.get("c.updateOpportunityLineItem");
        action.setParams({
            updateOppLineItems: JSON.stringify(objectData)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.invoketostMessage(component,"success","Recommendation details has been updated successfully.","dismissible",false);
                component.set("v.showSpinner",false);                
            }
            if(state == "ERROR"){ 
                var errors = response.getError();
                this.invoketostMessage(component,"error", "Something went wrong. Error: " + errors[0].pageErrors[0].message,"sticky",false);
                component.set("v.showSpinner",false);
            }
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },     
    saveSelectedProduct: function (component, event, helper) {      
        var action = component.get("c.saveOpportunityLineItem");
        action.setParams({
            oppId: component.get("v.recordId"),
            productId: component.get("v.selectedProductRecord").Id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue['opportunityProductId'] != null)component.set("v.isProductAdded", true); 
                this.invoketostMessage(component,"success", "Product added successfully. Please fill the Recommendation details.","sticky",false);
                component.set("v.showSpinner",false);
            } else if (state === "ERROR") {
                component.set("v.isProductAdded", false); 
                var errors = response.getError();
                var errors2 = JSON.stringify(errors);
                console.log('errors: ' + JSON.stringify(errors));
                if (errors2.includes("Please select a valid product for your Merchant Onboarding")) {
                    this.invoketostMessage(component,"error", "Please select a valid product for investment opportunity.","sticky",false);
                }
                else {
                    this.invoketostMessage(component,"error", "Something went wrong. Error: " + errors[0].pageErrors[0].message,"sticky",false);
                } 
                component.set("v.showSpinner",false);
            }
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    checkFieldValidations: function(component,event) {
        let oppRecord = component.get("v.oppRecord");
        if(oppRecord.STI_Id_Number__c === false){
            component.set("v.showSpinner",false);
            this.invoketostMessage(component,"warning","Please complete ID & V before adding Recommendation!","sticky",false);
        }
        else if((oppRecord.Sub_Status__c != 'Discovery Stage' && oppRecord.StageName === 'New') || oppRecord.Sub_Status__c === 'ID & V Completed') {
            component.set("v.showSpinner",false);
            this.invoketostMessage(component,"warning","Opportunity status should be 'Discovery Stage'!","sticky",false);
        }
            else {
                let subStatus = ['Discovery Stage','Recommendation Stage','Call back','Investment finalized'];
                if(subStatus.indexOf(oppRecord.Sub_Status__c) > -1|| (component.get("v.isNotAdvisor") === true && subStatus.indexOf(oppRecord.Sub_Status__c) > -0)){ 
                    component.set("v.hasEditAccess",true);
                }
                else{ 
                    component.set("v.hasEditAccess",false);
                }
                this.getSelectedProduct(component);            
            }
    },
    invoketostMessage : function(component,typeText,userMessage,modelMode,closeQuickAction){
        if(closeQuickAction === true){
            $A.get("e.force:closeQuickAction").fire();
        }
        component.find('notifLib').showToast({
            variant: typeText,
            message: userMessage,
            mode: modelMode
        });
    }
})