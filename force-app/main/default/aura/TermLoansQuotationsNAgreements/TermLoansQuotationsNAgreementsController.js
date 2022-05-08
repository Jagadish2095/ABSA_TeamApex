({
    doInit: function (component, event, helper) {
        helper.initPickLisOptions(component);
        helper.getPriceRate(component);
        helper.getCaseRec(component);
        helper.getAppProdRec(component);
    },
    
    onPickListRepayFreqChange: function(component, event, helper) {
        var rePayFreq = event.getSource().get("v.value");
        if(rePayFreq=='Monthly'){
            component.set("v.showDefSkipmonths" , false); 
        }else{
            component.set("v.showDefSkipmonths" , true);
            component.set("v.selectedSkipMonths",0);
        }
        
    },    
    
    calculate : function(component, event, helper) {
        var allValid = component.find('quoteForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            var AccNumber = component.get("v.appProduct.Account_Number__c");
            var CIF = component.get("v.case.CIF__c");
            console.log('AccNumber' + AccNumber);
            console.log('CIF' + CIF);
            if(AccNumber == null || AccNumber == 'undefined'){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    title: "Error!",
                    message: "Term Loan Account Number is Empty ",
                    type:  "Error",
                    mode: "sticky"
                });
                toastEvent.fire();
            }/*else if(CIF == null || CIF == 'undefined'){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    title: "Error!",
                    message: "CIF is Empty ",
                    type:  "Error",
                    mode: "sticky"
                });
                toastEvent.fire();
            }*/else{
                helper.getCalculateQuote(component);
            }
        } else {
            var toastEvent = helper.getToast("Error:!", "Please update the invalid form entries and try again.", "Error");
            toastEvent.fire();
        }
       
    },
    
    generateQuote : function(component, event, helper) {
        // TOBE used by Document Generation 
        
    },
    
    checkContractDt : function(component, event, helper) {
        console.log('Inside');
        
        component.set("v.contractDate", event.getSource().get("v.value"));
        component.set("v.contDtError" , '');
        var contractDate = component.get("v.contractDate");
        console.log('contractDate' + contractDate);
        var ncaStatus=component.get("v.appProduct.NCA_Appplicable__c");
  		console.log('ncaStatus' + ncaStatus);
        if(ncaStatus =='IN NCA'){
            
        }else{
            
        }
        //Contract Date 
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
        //Restrict in past date
        if(contractDate < todayFormattedDate){
            console.log('past date');
            component.set("v.contractDate", '');
            component.set("v.isContDtError" , true);
        }else{
            component.set("v.isContDtError" , false);
        }
        
        
         //Restrict Future date  
        var futureDate = new Date(todayFormattedDate);
        futureDate.setDate(futureDate.getDate() + 4);
        futureDate=futureDate.toISOString().slice(0,10);
        var dd = contractDate ;
        
        var dayOfMonth = dd.substring(8, dd.length);
        
        if( dd > futureDate ){
            component.set("v.contDtError" , 'Selected date cannot be more than 4 days from today');
            component.set("v.contractDate", '');
        }
        
    },
})