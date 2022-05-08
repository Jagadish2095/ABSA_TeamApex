({
    loadData : function(component,event) {
        component.set("v.showSpinner", true);

        var action = component.get("c.getLivingExpenses");
        action.setParams({
            "applicationId": component.get("v.applicationId")
        });
        action.setCallback(this, function (response) {
           var state = response.getState();
           if (state === "SUCCESS") {
               var results = JSON.parse(response.getReturnValue());
               console.log("results");
               console.log(results);
               component.set("v.livingExpenseRecord", results);
               console.log("livingExpenseRecord");
               console.log(JSON.stringify(component.get("v.livingExpenseRecord")));
               component.set("v.total", results.householdExpense.Applicant_Value__c +
                results.fuelExpense.Applicant_Value__c + results.educationFee.Applicant_Value__c +
                results.insurancePolicies.Applicant_Value__c + results.maintenanceExpense.Applicant_Value__c +
                results.rent.Applicant_Value__c + results.otherAmount.Applicant_Value__c);

           }else{
               console.log('failed---'+state);
           }

           component.set("v.showSpinner", false);
       });
       $A.enqueueAction(action);
   },

   saveData : function(component,event) {
    component.set("v.showSpinner", true);

    var action = component.get("c.saveLivingExpenses");
    var d = component.get("v.livingExpenseRecord");
    console.log("Data to sent");
    console.log(JSON.stringify(d));
    action.setParams({ "data" : JSON.stringify(d) });

    action.setCallback(this, function (response) {
       var state = response.getState();
       if (state === "SUCCESS") {
       }else{
            console.log('failed---'+state);
       }

       component.set("v.showSpinner", false);
   });
   $A.enqueueAction(action);
   }
})