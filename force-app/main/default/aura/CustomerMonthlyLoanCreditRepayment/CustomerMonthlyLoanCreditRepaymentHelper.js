({
    loadData : function(component,event) {		
        component.set("v.showSpinner", true);

        var action = component.get("c.getDebtExpenses");
        action.setParams({
            "applicationId": component.get("v.applicationId")
        });
        
        action.setCallback(this, function (response) {
           var state = response.getState();
           
           if (state === "SUCCESS") {
               var results = JSON.parse(response.getReturnValue());
                              
               component.set("v.expenseRecord", results);

               component.set("v.total", results.assetPayment.Applicant_Value__c + 
                results.creditPayment.Applicant_Value__c + results.loanPayment.Applicant_Value__c + 
                results.homeloanPayment.Applicant_Value__c + results.retailPayment.Applicant_Value__c);

           }else{
               console.log('failed---'+state);
           }

           component.set("v.showSpinner", false);
       });
       
       $A.enqueueAction(action);
   },
   
   saveData : function(component,event) {
        component.set("v.showSpinner", true);

        var action = component.get("c.saveDebtExpenses");

        var d = component.get("v.expenseRecord");

        action.setParams({ "data" : JSON.stringify(d) });

        action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {           
                console.log(state);                
        }else{
                console.log('failed---'+state);
        }

        component.set("v.showSpinner", false);
    });
    
    $A.enqueueAction(action);
   },
   
   updateExpense : function(component,event) {	
        
        if (component.get("v.expense") != "")
        {
            var expenses = JSON.parse(component.get("v.expense"));
            
            if (expenses != null)
            {
                component.set("v.expenseRecord.assetPayment.Applicant_Value__c", expenses.vehicleInstalment);
                component.set("v.expenseRecord.loanPayment.Applicant_Value__c", expenses.personalLoanInstalment);
                component.set("v.expenseRecord.retailPayment.Applicant_Value__c", expenses.otherFixedDebtExpense.amount);
                component.set("v.expenseRecord.creditPayment.Applicant_Value__c", expenses.creditCardInstalment);
                component.set("v.expenseRecord.homeloanPayment.Applicant_Value__c", expenses.bondInstalmentOrRent);
            }            
        }
   }
})