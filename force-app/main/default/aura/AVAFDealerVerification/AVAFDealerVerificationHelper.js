({
	getDealerInfo : function(component,event,helper) {
        var code = component.get("v.dealerCode");
        var abNumber = component.get("v.currentUser.AB_Number__c");
         this.showSpinner(component);
        var action = component.get("c.getDealerInfo");
        while (code.length < 10) code = "0" + code;
        action.setParams({
            dCode : code,
            abNumber : abNumber
        });
        action.setCallback(this,function(response){
            var state = response.getState();
           
            if(state === "SUCCESS"){
                var resp = response.getReturnValue();
                var respValue = JSON.parse(resp);
               
                if (respValue.BAPI_SF_DLR_DETAILS.E_RESPONSE_DESC.includes('not found')) {
                    // error
                    component.set("v.errorMessage", "Error: No Dealer Information received from service.");
                }
                
                for(let item in respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS){
                   
                    if(`${respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS[item]}` === 'null'){                       
                        `${respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS[item] = ''}`
                    }
                }
                component.set("v.DealershipName",respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.NAME_ORG1);
                component.set("v.DealerTelephoneNumber",respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.DEALER_TELEPHONE);
                component.set("v.CommentsFromtheMarketer",respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.NOTES);
                component.set("v.ApprovedDealer",respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.ZAPPROVED_IND);
                component.set("v.DealerAddress",respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.STREET1 +','+respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.STREET2 +','+
                              respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.CITY1 +','+respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.CITY2 +','+respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.POST_CODE
                              +','+respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.REGION+','+respValue.BAPI_SF_DLR_DETAILS.E_DLR_DETAILS.COUNTRY);
            }else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                   
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error No details found");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    saveReasonandCloseCase: function (component, event, helper) {
    
     
        var description = component.find("descriptionField").get("v.value");
        if (description) {
            description += "Reason : " + component.get("v.Reason");
        } else {
            description = "Reason : " + component.get("v.Reason");
        }
        component.find("descriptionField").set("v.value", description);
        component.find("statusField").set("v.value", "Closed");
        component.find("caseCloseEditForm").submit();
        $A.get("e.force:refreshView").fire();
    },
    
    showSpinner: function (component) {
        component.set("v.showSpinner", true);
    },
    
    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
    }
})