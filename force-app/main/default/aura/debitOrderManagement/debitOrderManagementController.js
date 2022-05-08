({
    
    doInit : function(component, event, helper) {
        console.log('+pro Name '+component.get("v.ProductNameFromFlow"));
        if(component.get("v.recordId") == undefined)
            component.set("v.recordId", component.get("v.OpportunityIdFromFlow"));
        helper.fetchPickListVal(component, 'Payment_Method__c', 'PaymentMethod');
        helper.fetchPickListVal(component, 'Debit_Order_Account_Type__c', 'AccountType');
        helper.fetchPickListVal(component, 'Debit_Order_Debit_Day__c', 'DebitDay');
        helper.fetchPickListVal(component, 'Debit_Order_Salary_Day__c', 'SalaryDay');
        //helper.fetchPickListVal(component, 'Debit_Order_Gross_Monthly_Income__c', 'GrossMonthlyIncome');
        helper.fetchDebitOrderDetails(component, event, helper);
        
        component.set('v.bankColumns', [
            {label: 'Bank Account Number', fieldName: 'bankNum', type: 'text'},
            {label: 'Bank Name', fieldName: 'bName', type: 'text'},
            {label: 'Branch Name', fieldName: 'brName', type: 'text'},
            {label: 'Branch Code', fieldName: 'bCode', type: 'text'},
            {label: 'Account Type', fieldName: 'aType', type: 'text'}
        ]);
		component.set('v.accountColumns', [
            {label: 'Account Number', fieldName: 'accNum', type: 'text'},
            {label: 'Product', fieldName: 'product', type: 'text'},
            {label: 'Product Type', fieldName: 'productType', type: 'text'},
            {label: 'Corporation', fieldName: 'corp', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'}
        ]);
        helper.fetchData(component);
        //helper.fetchQuoteId(component);
    },
    
    handleNext : function(component, event, helper) {

         	var response = event.getSource().getLocalId();
      	 	component.set("v.value", response);
         	var navigate = component.get("v.navigateFlow");
         	navigate(response); 
  		},
    
    //Cancel button 
    cancelAndCloseTab : function(component, event, helper) {
        //Close focus tab and navigate home
        component.set("v.showDebitOrderDetail", true);
        component.set("v.showQuoteDetails", true);
        component.set("v.showValidateButton",false);
        component.set("v.showNewDebitOrderButton", true);
    },
    
    updateSelectedAccount: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.opportunity.Debit_Order_Account_Number__c", selectedRows[0].accNum);
        if(selectedRows[0].productType == 'SA'){
            component.set("v.selectedAccType", 'Savings');
            component.set("v.opportunity.Debit_Order_Account_Type__c", "Savings");
        }
		else if(selectedRows[0].productType == 'CQ'){
            component.set("v.selectedAccType", 'Cheque');
            component.set("v.opportunity.Debit_Order_Account_Type__c", "Cheque");
        }        
        
        component.set("v.selectedBankName", 'ABSA BANK LIMITED');
        component.set("v.selectedBranchName", 'ABSA ELECTRONIC SETTL (632005)');
        component.set("v.selectedBranchCode", '632005');
        
        //Get the event using event name. 
        var appEvent = $A.get("e.c:updateBankDebitOrder"); 
        //Set event attribute value
        appEvent.setParams({"bank" : "ABSA BANK LIMITED", "branch" : "ABSA ELECTRONIC SETTL (632005)"}); 
        appEvent.fire(); 
        console.log("updateBankDebitOrder event fired!");
    },
    
    onPicklistAccTypeChange: function(component, event, helper) {
        component.set("v.opportunity.Debit_Order_Account_Type__c", event.getSource().get("v.value"));
        
    },
    onPicklistPayMethodChange: function(component, event, helper) {
        component.set("v.opportunity.Payment_Method__c", event.getSource().get("v.value"));
        
    },
    onPicklistGrossMonthlyIncomeChange: function(component, event, helper) {
        component.set("v.opportunity.Debit_Order_Gross_Monthly_Income__c", event.getSource().get("v.value"));
        
    },
    
    onPicklistDebitDayChange: function(component, event, helper) {
        component.set("v.opportunity.Debit_Order_Debit_Day__c", event.getSource().get("v.value"));
        
    },
    
    onPicklistSalaryDayChange: function(component, event, helper) {
        component.set("v.opportunity.Debit_Order_Salary_Day__c", event.getSource().get("v.value"));
        
    }, 
    
    checkDebitDate : function(component, event, helper) {
        
        component.set("v.opportunity.Debit_Order_Date__c", event.getSource().get("v.value"));
        component.set("v.futureDateValidationError" , '');
        
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0 in javascipt
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        // Restrict past date to debit date 
        if(component.get("v.opportunity.Debit_Order_Date__c") != '' && component.get("v.opportunity.Debit_Order_Date__c") < todayFormattedDate){
            component.set("v.dateValidationError" , true);
        }else{
            component.set("v.dateValidationError" , false);
        }
        
        //Restrict Future date to debit date 
        var futureDate = new Date(todayFormattedDate);
        futureDate.setDate(futureDate.getDate() + 45);
        futureDate=futureDate.toISOString().slice(0,10);
        var dd=component.get("v.opportunity.Debit_Order_Date__c");
        
        if(component.get("v.oppRecordType") == 'Direct Delivery Sales Opportunity' || component.get("v.oppRecordType") == 'DD STI Opportunity'){
            var minDate = new Date(todayFormattedDate);
            minDate.setDate(minDate.getDate() + 3);
            minDate=minDate.toISOString().slice(0,10);
            if( dd < minDate ){
                component.set("v.futureDateValidationError" , 'Selected date cannot be less than 3 days');
            	component.set("v.showFutureDateValidation" , true);
            }
        }
        if(dd != null || dd != undefined)
        	var dayOfMonth = dd.substring(8, dd.length);
        
        if( dd > futureDate ){
            component.set("v.futureDateValidationError" , 'Selected date cannot be more than 45 days');
            component.set("v.showFutureDateValidation" , true);
        }
        else if((dayOfMonth == '17' || dayOfMonth == '18' || dayOfMonth == '19') && component.get("v.oppRecordType") != 'Direct Delivery Sales Opportunity' && component.get("v.oppRecordType") != 'DD STI Opportunity'){
            component.set("v.futureDateValidationError" , 'Selected date cannot be the 17th, 18th or 19th of any month');
            component.set("v.showFutureDateValidation" , true);
            component.set("v.showInvalidDateSelected" , true);
        }
        else{
            component.set("v.showFutureDateValidation",false);
            component.set("v.showInvalidDateSelected" , false);
        }
    },
    
    checkAccountNumber : function(component, event, helper) {
        
        helper.showSpinner(component); 
       
        var allValid = component.find('debitOrderForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        //Check bank name is blank 
        var bankName=component.get("v.selectedBankName");
        if(bankName =='' || bankName == null )
        {
            
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Bank Name Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
        }
        else
        {
            var bankName=component.get("v.selectedBankName");
            component.set("v.opportunity.Debit_Order_Bank_Name__c",bankName);
            // alert('Inside Debit order JS selectedBankName:  '+ bankName);
            console.log(' Inside Debit order JS selectedBankName:'+bankName);
        }
        
        //Check Branch name is blank 
        var branchName=component.get("v.selectedBranchName");
        var branchCode=component.get("v.selectedBranchCode");
        
        if(branchName=='' ||branchName==null || branchName== undefined )
        {
            
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Branch Name Cannot Be Blank.",
                "type":"error"
            });
            toastEvent.fire();
        }
        else
        {
            component.set("v.opportunity.Debit_Order_Branch_Name__c",component.get("v.selectedBranchName"));
            component.set("v.opportunity.Debit_Order_Branch_Code__c",component.get("v.selectedBranchCode"));
            
            
            //Testing below 
            var branchName =component.get("v.opportunity.Debit_Order_Branch_Name__c");
            var branchCode =component.get("v.opportunity.Debit_Order_Branch_Code__c");
            
        }
        
        //Check if date is in past
        var now = new Date();
        var selectedDate = new Date(component.get("v.opportunity.Debit_Order_Date__c"));
        
        if(selectedDate < now){
            allValid = false; 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Debit Date cannot be current date or in the past.",
                "type":"error"
            });
            toastEvent.fire();
        }
        
        //Check if date is in future
        
        if(component.get("v.showFutureDateValidation")==true && component.get("v.showInvalidDateSelected")==false){
            allValid = false; 
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Selected date cannot be more than 45 days.",
                "type":"error"
            });
            toastEvent.fire();
        }
        
        if(component.get("v.showInvalidDateSelected")==true){
            allValid = false; 
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Date selection is invalid.",
                "type":"error"
            });
            toastEvent.fire();
        }
        
        // 
        if (allValid && bankName!=null  && branchName!=null && branchCode!=null ) 
        {
            
            var accountNumber = component.get("v.opportunity.Debit_Order_Account_Number__c");
            var branchCode =component.get("v.opportunity.Debit_Order_Branch_Code__c");
            var accountTypeStr = component.get("v.opportunity.Debit_Order_Account_Type__c");
            var accountType;
            if(accountTypeStr=='Cheque'){
                accountType='01';  
            }else if(accountTypeStr=='Savings'){
                accountType='02';
            }else if(accountTypeStr=='Transmission'){
                accountType='03';  
            }
            
            var transactionType='DR';                 //hardcoded for now, no source known
            var cdvRequired ='';
            var expiryDate='';
            var channel = 'Sales';  				//hardcoded for now, no source known
            var application = 'Salesforce' ;        //hardcoded for now ,no source known
            var msgLanguage = 'E';   			    //hardcoded for now ,no source known
            var msgTarget = 'STD';					//hardcoded for now ,no source known
            var trace = 'N';						//hardcoded for now ,no source knowns
            
            
            var action = component.get("c.checkBankAccount");
            action.setParams({
                "accountNumber": accountNumber,
                "branchCode": branchCode,
                "accountType": accountType,
                "transactionType":transactionType ,
                "cdvRequired":cdvRequired,
                "expiryDate":expiryDate,
                "channel": channel,
                "application": application,
                "msgLanguage": msgLanguage,
                "msgTarget": msgTarget,
                "trace": trace
            });
            
            //check what Opp validated
            var opp=component.get("v.opportunity");
            var oppstr=JSON.stringify(opp);
            console.log('Opportunity record to validate :'+oppstr);
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                var message = response.getReturnValue();
                if (state === "SUCCESS") { 
                    if(message==true){
                        
                        component.set("v.showNewDebitOrderButton",true);
                        component.set("v.showValidateButton",false);
                        component.set("v.opportunity.Debit_Order_Status__c",'Valid'); 
                        var status = component.get("v.opportunity.Debit_Order_Status__c");
                        
                        console.log("Bank Account Details Validated Successfully" + status); 
                        
                                        
                        //Setting commencement Date 
                        var today = new Date();        
                        var dd = today.getDate();
                        var mm = today.getMonth() + 1; //January is 0 in javascipt
                        var yyyy = today.getFullYear();
                        // if date is less then 10, then append 0 before date   
                        if(dd < 10){
                            dd = '0' + dd;
                        } 
                        // if month is less then 10, then append 0 before date    
                        if(mm < 10){
                            mm = '0' + mm;
                        }
                        console.log('++++dd'+dd+'mm'+mm+'yyyyy'+yyyy);
                        
                        // Setting Commencement date if 1st of any month as same else next month 1st day
                        if(dd == '01'){
                            
                            var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
                            var commencementdate = todayFormattedDate ;
                            console.log('commencementdate this month for 01 :'+commencementdate);
                            component.set("v.opportunity.Commencement_Date__c" , commencementdate);
                            
                        } else{
                            
                            if(mm =='12'){ // for december month only
                                yyyy=yyyy+1;   
                                mm='01';
                            }else{            //all months except December
                                var tmp='1';
                                mm= +mm +  +tmp; 
                                
                                if(mm < 10){
                                    mm = '0' + mm;
                                }
                                
                            }
                            var commencementdate = yyyy+'-'+mm+'-'+'01';
                            console.log('commencementdate next month for rest days :'+commencementdate);
                            component.set("v.opportunity.Commencement_Date__c" , yyyy+'-'+mm+'-'+'01');
                            
                        } 
                        
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success",
                            "message": "Bank Account Details Validated Successfully",
                            "type":"Success"
                        }); 
                        toastEvent.fire();                        
                    }
                    else{
                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "message": "Invalid Bank Account Details.. Please try again " ,
                            "type":"Error"
                        }); 
                        toastEvent.fire();
                        
                        console.log("Failed on account validation with state: " + state); 
                    }
                    
                }     
                else{
                    console.log('Error with the CheckDigitVerification Web Service  :');
                }
                
                helper.hideSpinner(component);
            });
            
            $A.enqueueAction(action);
        }
        else {
            allValid = false;
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please Correct All Error To Proceed With Validate Bank Account",
                "type":"error"
            });
            toastEvent.fire();
            
            helper.hideSpinner(component);
        }
        
        
    },
    
    submitDebitOrder: function(component, event, helper){
        helper.showSpinner(component);  
        
        var OppId = component.get("v.recordId");
        var action = component.get("c.createDebitOrder");
        
        var branchcode=component.get("v.opportunity.Debit_Order_Branch_Code__c");
        var branchcodeInt=parseInt(branchcode);
        component.set("v.opportunity.Debit_Order_Branch_Code__c",branchcodeInt);
        
        var op=JSON.stringify(component.get("v.opportunity"));
        console.log('+++++opp after parse'+op);
        
        action.setParams({
            "Opp": component.get("v.opportunity"),
            "OppId": OppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('+++++++state:'+state);
            
            
            if (state === "SUCCESS") {    
                
                // show Success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "message": "Debit Order Capture Successfully",
                    "type":"Success"
                });
                toastEvent.fire();
                
                // helper.fetchDebitOrderDetails
                $A.get('e.force:refreshView').fire();
                component.set("v.showDebitOrderDetail", true);
                
            } else if(state === "ERROR"){
                
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.message", errors[0].message);                          
                    }  
                }
                // show Failure notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in submitting the Debit Order Details. Please try again"+ component.get("v.message"),
                    "type":"error"
                });
                toastEvent.fire();
                console.log(component.get("v.message"));
            }
            
            helper.hideSpinner(component); 
            // $A.get('e.force:refreshView').fire(); 
        });
        
        $A.enqueueAction(action);
        
    },
    submitBankDebitOrder: function(component, event, helper){
        helper.showSpinner(component);  
        
        var OppId = component.get("v.recordId");
        var action = component.get("c.createBankDebitOrder");
        
        var branchcode=component.get("v.opportunity.Debit_Order_Branch_Code__c");
        var branchcodeInt=parseInt(branchcode);
        component.set("v.opportunity.Debit_Order_Branch_Code__c",branchcodeInt);
        
        var op=JSON.stringify(component.get("v.opportunity"));
        console.log('+++++opp after parse'+op);
        console.log('+pro Name'+component.get("v.ProductNameFromFlow"));
        action.setParams({
            "Opp": component.get("v.opportunity"),
            "OppId": OppId,
            "productName":component.get("v.ProductNameFromFlow")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('+++++++state:'+state);
            
            if (state === "SUCCESS") {    
                component.set("v.showBankTableDetails",false);
                component.set("v.showQuoteDetails",true);
                // show Success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success",
                    "message": "Debit Order Capture Successfully",
                    "type":"Success"
                });
                toastEvent.fire();
                console.log('in showdetails');
                helper.fetchQuoteId(component);
                $A.get('e.force:refreshView').fire();
                component.set("v.showDebitOrderDetail", true);
                
            } else if(state === "ERROR"){
                
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.message", errors[0].message);                          
                    }  
                }
                // show Failure notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in submitting the Debit Order Details. Please try again"+ component.get("v.message"),
                    "type":"error"
                });
                toastEvent.fire();
                console.log(component.get("v.message"));
            }
            
            helper.hideSpinner(component); 
            // $A.get('e.force:refreshView').fire(); 
        });
        
        $A.enqueueAction(action);
        
    },
    updateDebitOrder :function(component, event, helper){
        component.set("v.showDebitOrderDetail", false);
        component.set("v.showValidateButton", true);
        component.set("v.showNewDebitOrderButton", false);
        
        //clear all attribute
        component.set("v.selectedBankName", null);
        component.set("v.selectedBranchName", null);
        component.set("v.selectedBranchCode", null);
        component.set("v.showBankTableDetails",true);
        component.set("v.showQuoteDetails",true);
        
    },
    updateQuoteDebitOrder :function(component, event, helper){
        helper.fetchData(component);
        component.set("v.showDebitOrderDetail", false);
        component.set("v.showValidateButton", true);
        component.set("v.editAccount", true);
        component.set("v.showNewDebitOrderButton", false);
        
        //clear all attribute
        //component.set("v.selectedBankName", null);
        //component.set("v.selectedBranchName", null);
       // component.set("v.selectedBranchCode", null);
       // component.set("v.opportunity.Debit_Order_Account_Number__c",'');
       // component.set("v.opportunity.Debit_Order_Date__c",'');
       // component.set("v.selectedPayMethod",'');
       // component.set("v.selectedAccType",'');
       // component.set("v.selectedSalaryDay",'');
        component.set("v.showBankTableDetails",true);
        component.set("v.showQuoteDetails",false);
        component.set("v.showNewBankDetails",true);
        component.set("v.showValidateButton",true);
        //Get the event using event name. 
        var appEvent = $A.get("e.c:updateBankDebitOrder"); 
        //Set event attribute value
        appEvent.setParams({"bank" : component.get("v.selectedBankName"), "branch" : component.get("v.selectedBranchName")}); 
        appEvent.fire(); 
        
    },
    clearAllBankAttribute : function(component, event, helper){
        var recordToBeclear = event.getParam("clearBranchName");
        component.set("v.selectedBankName", null);
        var bankname= component.get("v.selectedBankName");
        component.set("v.selectedBranchName", null);
        var branchname= component.get("v.selectedBranchName");
        component.set("v.selectedBranchCode", null);
        var branchcode= component.get("v.selectedBranchCode");
        console.log('Inside DO clearAllBankAttribute func' +recordToBeclear+bankname+branchname+branchcode);
        
        
    },
    
    handleBrachCodeComponentEvent:function(component, event, helper){
        
        //Event handler to get branch code from child comp
        var pselectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
        component.set("v.selectedBranchCode" , pselectedBranchCodeGetFromEvent);  
        
        
    },
    gettheSelectedBank: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        console.log('daata '+selectedRows[0].bankNum);
        console.log('daata '+selectedRows[0].aType);
        cmp.set("v.selectedbanknumber",selectedRows[0].bankNum);
        cmp.set("v.selbaName",selectedRows[0].bName);
        cmp.set("v.selbranchname",selectedRows[0].brName);
        cmp.set("v.selAccType",selectedRows[0].aType);
        cmp.set("v.selbrcode",selectedRows[0].bCode);
        if(selectedRows[0].bankNum != '' && selectedRows[0].bankNum != 'undefined' && selectedRows[0].bankNum != null){
            cmp.set("v.showBankButton",true);
        }
        cmp.set("v.opportunity.Debit_Order_Account_Number__c", selectedRows[0].bankNum);
        cmp.set("v.opportunity.Debit_Order_Account_Type__c", selectedRows[0].aType);
        cmp.set("v.selectedAccType", selectedRows[0].aType);
        cmp.set("v.selectedBankName", selectedRows[0].bName);
        cmp.set("v.selectedBranchName", selectedRows[0].brName);
        cmp.set("v.selectedBranchCode", selectedRows[0].bCode);
        //Get the event using event name. 
        var appEvent = $A.get("e.c:updateBankDebitOrder"); 
        //Set event attribute value
        appEvent.setParams({"bank" : selectedRows[0].bName, "branch" : selectedRows[0].brName}); 
        appEvent.fire(); 
        
    }
   /* copyBankDebitOrder: function (component, event) {
        
        alert('selectedbanknumber '+component.get("v.selectedbanknumber"));
        var oppId = component.get("v.recordId");
        var action = component.get("c.createBankDebitOrderForQuote");
        action.setParams({
            "oppId": oppId,
            "productName":component.get("v.ProductNameFromFlow"),
            "bNumber":component.get("v.selectedbanknumber"),
            "bName":component.get("v.selbaName"),
            "bCode":component.get("v.selbrcode"),
            "brName":component.get("v.selbranchname"),
            "accType":component.get("v.selAccType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Bank Details Updated Successfully",
                    "type":"Success"
                });
                toastEvent.fire();
                
                helper.fetchData(component);
             }
            else {
                console.log("Failed with state: " + state);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error in submitting the Debit Order Details. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },*/
    /*onPicklistselectedCaptureResponseChange : function(cmp, event, helper) {
        var selectedValue = event.getSource().get("v.value") ; 
        if(selectedValue == 'Yes'){
            cmp.set("v.showBankTableDetails",true);
            cmp.set("v.showNewBankDetails",false);
        }
        else if(selectedValue == 'No'){
            cmp.set("v.showBankTableDetails",false);
            cmp.set("v.showNewBankDetails",true);
        }
            else{
                cmp.set("v.showBankTableDetails",false);
                cmp.set("v.showNewBankDetails",false);
            }
    }*/
})