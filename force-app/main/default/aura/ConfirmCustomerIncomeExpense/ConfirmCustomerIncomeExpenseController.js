({
    doInit : function(component, event, helper) {
        helper.loadData(component, event);
        
        $A.util.addClass(component.find("confirmMessage"), "slds-hide");
    },

    handleNavigate: function(component, event, helper) {  
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");
        switch(actionClicked)
        {
            case "NEXT": 
            case "FINISH":
                {
                    var income = component.find("monthlyIncome");

                    if (income.get("v.readOnly") == false)
                    {
                        $A.util.removeClass(component.find("incomeMessage"), "slds-hide");

                        break;
                    }

                    var expenses = component.find("monthlyExpenses");

                    if (expenses.get("v.readOnly") == false)
                    {
                        $A.util.removeClass(component.find("expenseMessage"), "slds-hide");

                        break;
                    }

                    var livingExpenses = component.find("monthlyLivingExpenses");

                    if (livingExpenses.get("v.readOnly") == false)
                    {
                        $A.util.removeClass(component.find("livingExpenseMessage"), "slds-hide");

                        break;
                    }

                    var warrant = component.get("v.warrantChecked");
                    var consent = component.get("v.consentSelected");

                    $A.util.addClass(component.find("confirmMessage"), "slds-hide");

                    if ((!warrant) || (consent != "Y"))
                    {
                        $A.util.removeClass(component.find("confirmMessage"), "slds-hide");

                        break;
                    }    

                    component.set("v.showSpinner", true);

                    if (component.get("v.doFinalScoring")) {

                        component.set("v.doFinalScoring", false);
                        
                        var promise = helper.finalScoringAsPromise(component, helper)
                        .then(
                            // resolve handler
                            $A.getCallback(function(result) {
                                component.set("v.showSpinner", false);

                                if (result.isValid)
                                {
                                    var r = result.actionResult;

                                    component.set("v.scoringResult", r);
                                }
                                
                                navigate(event.getParam("action"));
                            }),
                            
                            // reject handler
                            $A.getCallback(function(error) {
                                component.set("v.doFinalScoring", true);
                                component.set("v.showSpinner", false);
                                
                                component.find('branchFlowFooter').set('v.heading', 'Something went wrong');
                                component.find('branchFlowFooter').set('v.message', error.errorMessage);
                                component.find('branchFlowFooter').set('v.showDialog', true);                
                            })
                        )
                    }
                    
                    break;
                }
            case "BACK":
                {
                    navigate(event.getParam("action"));
                    break;
                }
            case "PAUSE":
                {
                    navigate(event.getParam("action"));
                    break;
                }
        }
       
    },

    updateIncome: function(component, event, helper) {        
        var c = component.find("monthlyIncome");

        c.updateIncome();
        
        helper.loadData(component, event);

        $A.util.addClass(component.find("incomeMessage"), "slds-hide");
    },

    updateExpenses: function(component, event, helper) {
        var c = component.find("monthlyExpenses");

        c.updateExpenses();

        helper.loadData(component, event);

        $A.util.addClass(component.find("expenseMessage"), "slds-hide");
    },

    updateLivingExpenses: function(component, event, helper) {
        var c = component.find("monthlyLivingExpenses");

        c.updateLivingExpenses();

        helper.loadData(component, event);
        
        $A.util.addClass(component.find("livingExpenseMessage"), "slds-hide");
    }
})