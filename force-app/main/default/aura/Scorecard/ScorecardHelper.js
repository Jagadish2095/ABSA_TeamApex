({
    /*@ Author: Danie Booysen
 	**@ Date: 29/01/2021
 	**@ Description: Function that queries from Apex Application Scoring data to be displayed on the Scorecard*/
    fetchScorecardData : function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        var action = component.get("c.getScorecardData");
        
        action.setParams({
            oppId: component.get("v.recordId")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
				var resp = response.getReturnValue();
                
                if(!$A.util.isEmpty(resp)){
                    component.set("v.applicationScoringObj", resp);
                    component.set("v.applicationScoringId", resp.Id);
                    
                    if(!$A.util.isEmpty(resp.Application_Scoring_Entity__r)){
                        component.set("v.entity1ExcessIndicator", resp.Application_Scoring_Entity__r[0].Excess_Indicator__c);
                    }
                } else{
                    component.set("v.errorMessage", "Apex error ScorecardController.getScorecardData: No Application Scoring records found");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error ScorecardController.getScorecardData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, ScorecardController.getScorecardData state returned: " + state);
            }
            
            helper.hideSpinner(component, event, helper);
        });
        
        $A.enqueueAction(action);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 09/04/2020
 	**@ Description: Method that shows the spinner*/
     showSpinner : function(component, event, helper){
        component.set("v.isMainSpinner", true);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method that hides the spinner*/
    hideSpinner : function(component, event, helper){
        component.set("v.isMainSpinner", false);
    }
});