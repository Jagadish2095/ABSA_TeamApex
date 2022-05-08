({
	doInit : function(component, event, helper) {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "Credit Application",
            value: "CreditApplication"
        });
        opts.push({
            class: "optionClass",
            label: "Loan Application",
            value: "LoanApplication"
        });
        opts.push({
            class: "optionClass",
            label: "Service Application",
            value: "ServiceApplication"
        });
        opts.push({
            class: "optionClass",
            label: "Insurance Application",
            value: "InsuranceApplication"
        }); 
        opts.push({
            class: "optionClass",
            label: "Others",
            value: "Others"
        });
        component.set("v.enquiryreasonlist" , opts);
        
         //Set the default 3 month transaction window
        var d = new Date();
        d.setMonth(d.getMonth() - 2);
        component.set("v.fromDate", d.getFullYear() + "-" + ((d.getMonth() < 10 ? '0' : '') + d.getMonth()) + "-" + (d.getDate() < 10 ? '0' : '') + d.getDate());
        
        var d = new Date();
        d.setMonth(d.getMonth() + 1);
        component.set("v.toDate", d.getFullYear() + "-" + ((d.getMonth() < 10 ? '0' : '') + d.getMonth()) + "-" + (d.getDate() < 10 ? '0' : '') + d.getDate());
        

		
	},
    
    getEnquiryReason  : function(component, event, helper) {
        
		
	},
    
    submitEstamp : function(component, event, helper) {
        helper.getAccountNumber(component, event, helper);
		
	},
    
    loadTransactionData : function( component, event, helper ){
        
        helper.showSpinner(component);
        var accountNumber = component.get('v.AccountNumber');
        var fdate =  component.get('v.fromDate');
        var tdate =  component.get('v.toDate');
        
        var action = component.get('c.loadTransactions');
        
        action.setParams({
            "pAccountNumber" : accountNumber,
            "fromDate" : fdate,
            "toDate" : tdate
        });
        
        action.setCallback(this, function(response) { 
            
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('transactionData' + JSON.stringify(result));
                
                component.set("v.transactionData", result);
                
                helper.hideSpinner(component);
                
            } else if (state === "ERROR") {
                
                var toast = helper.getToast("Error", "There was an error retrieving a list of transaction history for this account", "error");
                
                helper.hideSpinner(component);
                
                toast.fire();
            }
            
        });
        
        $A.enqueueAction(action);
        
        
    },
    closeCase : function(component,event,helper){
        helper.showSpinner(component);
        var caseId = component.get('v.caseRecordId');

        var action = component.get('c.closeCaseAction');

        action.setParams({
            "caseRecordId" : caseId
            
        });
        action.setCallback(this, $A.getCallback(function (response) {

			var state = response.getState();
			
            if (state === "SUCCESS") {
                var toast = helper.getToast("Success", "Case closed successfully", "Success");
                helper.hideSpinner(component);
                toast.fire();
                 $A.get('e.force:refreshView').fire();
                
            } else if (state === "ERROR") {
                helper.hideSpinner(component);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        var toast = helper.getToast("Error", errors[0].message, "error");
               			toast.fire();
                    }
                }
            }
        }));

       
            $A.enqueueAction(action); 
    }
})