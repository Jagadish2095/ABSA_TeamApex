({
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAccountInfoData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data',data);
                component.set("v.accountData", data);
                if(data == null){
                    component.set("v.showExistingAccounts", false);
                }
                else{
                    component.set("v.showExistingAccounts", true);
                }
            }
            else {
                console.log("Failed with state: " + state);
                component.set("v.showExistingAccounts", false);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        console.log('oppId'+oppId);
        var action1 = component.get("c.getBankData");
        action1.setParams({
            "oppId": oppId
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.bankData", data);
                console.log('data1'+JSON.stringify(data));
                if(data == null){
                    //component.set("v.showExistingAccounts", false);
                }
                else{
                    component.set("v.showBankTableDetails", true);
                    //component.set("v.showExistingAccounts", true);
                }
            }
            else {
                console.log("Failed with state: " + state);
                component.set("v.showExistingAccounts", false);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action1);
    },
    
    
    fetchQuoteId: function (component,event) {
     	var oppId = component.get("v.recordId");
        console.log('oppId',oppId);
        var action = component.get("c.getQuotesId");
        action.setParams({
            "oppId": oppId,
            "productName":component.get("v.ProductNameFromFlow")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.quoteId", data.Id);
                component.set("v.opportunity.Debit_Order_Account_Number__c", data.Debit_Order_Account_Number__c);
                component.set("v.selectedAccType", data.Debit_Order_Account_Type__c);
                component.set("v.selectedSalaryDay", data.Debit_Order_Salary_Day__c);
                component.set("v.selectedPayMethod", data.Payment_Method__c);
                component.set("v.opportunity.Debit_Order_Date__c", data.Debit_Order_Date__c);
                component.set("v.selectedBranchCode", data.Debit_Order_Branch_Code__c);
                component.set("v.selectedBankName", data.Debit_Order_Bank_Name__c);
                component.set("v.selectedBranchName", data.Debit_Order_Branch_Name__c);
                component.set("v.opportunity.Debit_Order_Branch_Code__c",data.Debit_Order_Branch_Code__c);
                component.set("v.opportunity.Debit_Order_Account_Type__c",data.Debit_Order_Account_Type__c);
                console.log('quote id '+JSON.stringify(data));
                
                if(data.Debit_Order_Account_Number__c != '' && data.Debit_Order_Account_Number__c != undefined){
                    component.set("v.showQuoteDetails",true);
                    component.set("v.showNewBankDetails",true);
                    component.set("v.showValidateButton",true);
                    component.set('v.showDebitOrderDetail',true);
                    console.log('not null'+data.Debit_Order_Account_Number__c);
                    
                }
                if("Debit_Order_Account_Number__c" in data){
                    console.log('key exists');
                } 
                else{
                   	component.set("v.showQuoteDetails",false);
                    component.set("v.showNewBankDetails",true);
                    component.set("v.showValidateButton",true);
                    component.set('v.showDebitOrderDetail',false);
                    console.log('not field');
                }
                
            }
            else {
                console.log("Failed with state: " + state);
                
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
           
    },
    fetchDebitOrderDetails : function(component, event, helper) {
        component.set("v.showSpinner", true);
        
        var OppId = component.get("v.recordId");
       
        var action = component.get("c.getDebitOrderDetails");
        action.setParams({
            "OppId": OppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log(response);
            if (state === "SUCCESS" ) {
                console.log('oppRecordType',response.getReturnValue().RecordType.Name);
                component.set("v.oppRecordType", response.getReturnValue().RecordType.Name);
                component.set("v.opportunity", response.getReturnValue());
                if(component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity'){
                     component.set("v.showBankTableDetails",false);
               		 component.set("v.showNewBankDetails",true);
                    if(component.get("v.opportunity.Debit_Order_Account_Number__c")==null){
                    
                    component.set('v.showDebitOrderDetail',false);
                	}else{
                    
                    component.set('v.showDebitOrderDetail',true);
                    
                }
                    console.log('in opp');
                }
                         
                
                if(component.get("v.oppRecordType") == 'Direct Delivery Sales Opportunity' || component.get("v.oppRecordType") == 'DD STI Opportunity'){
                     this.fetchQuoteId(component);
                }  
                
            }
            component.set("v.showSpinner", false);
           
        });
        
         
        $A.enqueueAction(action);
       
    },
    
    
    fetchPickListVal : function(component, fieldName, elementId) {

        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.opportunity"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(elementId == 'AccountType'){
                    component.set("v.accTypeOptions", opts); 
                } else if(elementId == 'DebitDay'){ 
                    component.set("v.debitDayOptions", opts); 
                } else if(elementId == 'SalaryDay'){ 
                    component.set("v.salaryDayOptions", opts); 
                }else if(elementId == 'GrossMonthlyIncome'){ 
                    component.set("v.GrossMonthlyIncomeOptions", opts); 
                }else if(elementId == 'PaymentMethod'){ 
                    component.set("v.PaymentMethodOptions", opts); 
                }
                
                //this.getAccountDetails(component);
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        console.log('inside Show Spinner');
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
          console.log('inside hide Spinner');
    },
    
})