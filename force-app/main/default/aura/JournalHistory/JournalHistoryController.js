({
    doInit : function(component, event, helper) {
        
        
        //Set the default 3 month transaction window
        var d = new Date();
        d.setMonth(d.getMonth() - 2);
        component.set("v.fromDate", d.getFullYear() + "-" + ((d.getMonth() < 10 ? '0' : '') + d.getMonth()) + "-" + (d.getDate() < 10 ? '0' : '') + d.getDate());
        
        var d = new Date();
        d.setMonth(d.getMonth() + 1);
        component.set("v.toDate", d.getFullYear() + "-" + ((d.getMonth() < 10 ? '0' : '') + d.getMonth()) + "-" + (d.getDate() < 10 ? '0' : '') + d.getDate());
        
        
        
        //Todate equals to Todays date
        var today = new Date();
        component.set('v.toDate1', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        
        // Fromdate equal to Todays date minus 120
        var result = new Date();
        result.setDate(result.getDate() - 120);
        component.set('v.fromDate1', result.getFullYear() + "-" + (result.getMonth() + 1) + "-" + result.getDate());
        
        
        helper.showSpinner(component);
        component.set("v.showForm",false);

        
        var accountNumber = component.get('v.selectedAccountNumberToFlow');
        var fdate =  component.get('v.fromDate');
        var tdate =  component.get('v.toDate');
        console.log('from date :'+fdate);
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
                console.log('result : '+result);
                //console.log('Length : '+result.length);
                
                
                if(result.length === 0){
                    
                    console.log("Length is zero");
                    var toast = helper.getToast("Error", "There's no journal history for selected dates", "error");
                    helper.hideSpinner(component);
                    
                    toast.fire();
                }
                else{
                    
                    component.set("v.transData", result); 
                    var tranData = component.get("v.transData");
                    for(var i = 0; i < tranData.length; i++){
                        console.log(tranData[i].Description1__c);
                        if((tranData[i].Description1__c).includes('CREDIT') &&(tranData[i].Description1__c).includes('TEST')){
                            console.log('Journal credit string test');
                            component.set('v.creditTest',tranData[i].Description1__c);
                        } 
                        
                        if((tranData[i].Description1__c).includes('DEBIT') &&(tranData[i].Description1__c).includes('TEST')){
                            console.log('Journal debit string test');
                            component.set('v.debitTest',tranData[i].Description1__c);
                        } 
                    }
                    console.log(result);
                    helper.hideSpinner(component);
                }
                
            } else if (state === "ERROR") {
                
                var toast = helper.getToast("Error", "There was an error retrieving a list of transaction history for this account", "error");
                
                helper.hideSpinner(component);
                
                toast.fire();
            }
            
        });
        
        $A.enqueueAction(action);
        
        
    },
    
    getAccountNumbers : function(component, event, helper) {
        
        var selectedProdType = component.get('v.selectedProductValue');
        var respObj = component.get('v.responseList');
        
        var acc = [];
        
        for(var key in respObj){
            if(respObj[key].productType == selectedProdType){
                acc.push(respObj[key].oaccntnbr);
                
            }
        }
        component.set('v.accNumList',acc);
    },
    getSelectedAccount : function(component, event, helper) {
        var selectedAccountValue = component.get('v.selectedAccountNumber');
        
        component.set('v.selectedAccountNumberToFlow',selectedAccountValue);
        
        var respObj = component.get('v.responseList');
        var accBalance;
        for(var key in respObj){
            if(respObj[key].oaccntnbr == selectedAccountValue){
                accBalance= respObj[key].availableBalance;
            }
        }
        
        component.set('v.selectedAccountBalance',accBalance);
    },
    
    dispTransactionHistory : function(component, event, helper) {
        var fDate = component.find("fDate").get('v.value');
        var tDate = component.find("tDate").get('v.value');
        
    },
    
    filterTransactionData : function( component, event, helper ){
        
        
        //Load transcation data with a 3 month window
        
        helper.showSpinner(component);
        var filterAdmin = component.get('v.admin');
        var filterDebit = component.get('v.debit');
        var filterCredit = component.get('v.credit');
        var filterCorrection = component.get('v.Correction');
        var filterDebitTest = component.get('v.debitTest');
        var filterCreditTest = component.get('v.creditTest');
        console.log('Journal Debit Test Value : '+filterDebit);
        var action = component.get('c.filterTransactions');
        
        action.setParams({
            
            "admin" : filterAdmin,
            "debit" : filterDebit,
            "credit" : filterCredit,
            "correction" : filterCorrection,
            "debitTest" : filterDebitTest,
            "creditTest" : filterCreditTest
            
        });
        
        action.setCallback(this, function(response) { 
            
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                var result = response.getReturnValue();
                console.log('Length : '+result.length);
                if(result.length === 0){
                    
                    console.log("Length is zero");
                    var toast = helper.getToast("Error", "There's no journal history for selected dates", "error");
                    helper.hideSpinner(component);
                    
                    toast.fire();
                }
                else{
                    console.log("Length is greater than zero");
                    component.set("v.transactionData", result); 
                    helper.hideSpinner(component);
                }
                
            } else if (state === "ERROR") {
                
                var toast = helper.getToast("Error", "There was an error retrieving a list of transaction history for this account", "error");
                
                helper.hideSpinner(component);
                
                toast.fire();
            }
            
        });
        
        $A.enqueueAction(action);
        
        
    },
    
    updateColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
        
    },
    
    filterTrData:function(component, event, helper) {
        
        var data = component.get("v.viewTransactionList.statementDetails"),
            //console.log('Data :'+data);
            
            term = component.get("v.filterTr"),
            //console.log('Term :'+term);
            results = data, regex;
        
        regex = new RegExp(term, "i");
        
        // filter checks each row, constructs new array where function returns true
        console.log('Results  : '+term+ results)
        if(results!=null){
            results = data.filter(row => regex.test(row.description1));
            console.log('Check term : '+term+data);
            
        }
        if((term != '') && (data != null)){
            
            component.set("v.viewTransactionList.statementDetails", results); 
            
        }else{
            
            if(((term === '') && (data === null))){
                
                this.transactionHistory(component);
                
            }
        }
        /*else{
            this.transactionHistory(component);
        }*/
        
        
    },
    closeCase: function (component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.caseClose");
        action.setParams({caseId:component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                var caseResponse = response.getReturnValue();
                debugger;
                if(caseResponse.isSuccess == 'true'){
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Case successfully closed!",
                        "type":"success"
                    });
                    
                    $A.get('e.force:refreshView').fire();
                }else{
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": caseResponse.errorMessage,
                        "type":"error"
                    });  
                }
                
            }else if(state === "ERROR"){
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
            } 
            
            toastEvent.fire();
        });
        
        $A.enqueueAction(action);
        
    }
    
    
})