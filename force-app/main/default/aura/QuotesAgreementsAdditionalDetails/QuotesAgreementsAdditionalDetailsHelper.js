({ 
    initPickLisOptions: function (component) {
        // Initialize input select options
      /*  var laonPurposes = [
            { class: "optionClass", label: "--Select an Option--", value: "", selected: "true" },
            { class: "optionClass", label: "Live Stock Purchase", value: "Live Stock Purchase" },
            { class: "optionClass", label: "Fixed Property Purchases", value: "Fixed Property Purchases" },
            { class: "optionClass", label: "Plant and Equipment", value: "Plant and Equipment" },
            { class: "optionClass", label: "Purchase of Business", value: "Purchase of Business" },
            { class: "optionClass", label: "Renovations", value: "Renovations" },
            { class: "optionClass", label: "Improvement of Fixed Property", value: "Improvement of Fixed Property" },
            { class: "optionClass", label: "Restructuring of Debts", value: "Restructuring of Debts" },
            { class: "optionClass", label: "Agricultural Development", value: "Agricultural Development" },
            { class: "optionClass", label: "Established Orchards(Existing Code in ABF)", value: "Established Orchards(Existing Code in ABF)" },
            { class: "optionClass", label: "Replace Orchards(Existing Code in ABF)", value: "Replace Orchards (Existing Code in ABF)" },
            { class: "optionClass", label: "Start New Business (Existing Code in ABF)", value: "Start New Business (Existing Code in ABF)" },
            { class: "optionClass", label: "Other", value: "000" },
        ];*/
            
            var marketSector = [
            { class: "optionClass", label: "--Select an Option--", value: "", selected: "true" },
            { class: "optionClass", label: "Agriculture", value: "004" },
            { class: "optionClass", label: "Commercial", value: "009" },
            { class: "optionClass", label: "Commercial Union Loans", value: "005" },
            { class: "optionClass", label: "Consumer", value: "000" },
            { class: "optionClass", label: "Electronic", value: "003" },
            { class: "optionClass", label: "Full Maintenance Rental", value: "007" },
            { class: "optionClass", label: "Industrial", value: "002" },
            { class: "optionClass", label: "Motfin (Motor Finance)", value: "008" },
            { class: "optionClass", label: "Motor", value: "001" },
            { class: "optionClass", label: "Not Applicable", value: "000" },
            { class: "optionClass", label: "Professional", value: "010" },
            { class: "optionClass", label: "Project Finance", value: "006" },
            { class: "optionClass", label: "Property finance", value: "000" }, 
			{ class: "optionClass", label: "Other", value: "000" },
        ];  
        
       /* var schemeType = [
            { class: "optionClass", label: "Personal Loan", value: "", selected: "true" },
        ];*/
        
            var paymentMethod = [
            { class: "optionClass", label: "--Select an Option--", value: "", selected: "true" },
            { class: "optionClass", label: "Cash Payment", value: "Cash Payment" },
            { class: "optionClass", label: "Debit Account", value: "Debit Account" },
        ];
        
       /* var agreementCategory = [
            { class: "optionClass", label: "Large", value: "", selected: "true" },
        ];*/
        
        var financeType = [
            { class: "optionClass", label: "--Select an Option--", value: "", selected: "true" },
            { class: "optionClass", label: "Flexi Type", value: "Flexi Type" },
            { class: "optionClass", label: "Lease Agreement", value: "Lease Agreement" },
            { class: "optionClass", label: "Not Applicable", value: "Not Applicable" },
            { class: "optionClass", label: "Personal Loan", value: "Personal Loan" },
            { class: "optionClass", label: "Surplus Funds", value: "Surplus Funds" },
            { class: "optionClass", label: "Term Loan", value: "Term Loan" },
        ];
            
                // component.set("v.optionLoanPurposes", laonPurposes);
                 component.set("v.optionMarketSector", marketSector);
                 //component.set("v.optionSchemeType", schemeType);
                 component.set("v.optionPaymentMethod", paymentMethod);
                 //component.set("v.optionAgreementCategory", agreementCategory);
                 component.set("v.optionFinanceType", financeType);
            
        var action = component.get("c.getSavedValues");
        var appProdId = component.get("v.caseRecord.Application_Product_Id__c");
        action.setParams({
            "appProdId": appProdId 
        }); 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                if (response.getReturnValue() != null) {
                  var resp = response.getReturnValue();
            	  var mandateNumber = resp.mandateNumber;
            	  var selectLoanPurposes = resp.selectLoanPurposes;
            	  var selectSchemeType = resp.selectSchemeType;
                  var selectPaymentMethod = resp.selectPaymentMethod;  
                  var selectAgreementCategory = resp.selectAgreementCategory;
            	  var selectFinanceType = resp.selectFinanceType;
            	  var selectedSecReq = resp.securityReqInd;
                  var selectMarketSector = resp.marketSector;  
                  var selectedPermitWD = resp.permitWithdrawalInd;
            	  var selectedElectronicTransfer = resp.electronicTransferReq;
            if(mandateNumber!=Null || mandateNumber!=''){
            component.set("v.mandateNumber",mandateNumber);
            } 
            if(selectLoanPurposes!=Null || selectLoanPurposes!=''){
            component.set("v.selectLoanPurposes",selectLoanPurposes);
            } 
            if(selectSchemeType!=Null || selectSchemeType!=''){
            component.set("v.selectSchemeType",selectSchemeType);
            } 
            if(selectPaymentMethod!=Null || selectPaymentMethod!=''){
            component.set("v.selectPaymentMethod",selectPaymentMethod);
            } 
            if(selectAgreementCategory!=Null || selectAgreementCategory!=''){
            component.set("v.selectAgreementCategory",selectAgreementCategory);
            } 
            if(selectFinanceType!=Null || selectFinanceType!=''){
            component.set("v.selectFinanceType",selectFinanceType);
            } 
            if(selectedSecReq!=Null || selectedSecReq!=''){
            component.set("v.selectedSecReq",selectedSecReq);
            } 
            if(selectMarketSector!=Null || selectMarketSector!=''){
            component.set("v.selectMarketSector",selectMarketSector);
            } 
            if(selectedPermitWD!=Null || selectedPermitWD!=''){
            component.set("v.selectedPermitWD",selectedPermitWD);
            } 
            if(selectedElectronicTransfer!=Null || selectedElectronicTransfer!=''){
            component.set("v.selectedElectronicTransfer",selectedElectronicTransfer);
            } 
                }
                
            }
            else {
                var toastEvent = this.getToast("Error in fetching saved data","Data is not returned","Error");
                    toastEvent.fire();
               // this.showError(response, "Agreement Service Error:");
               component.set("v.showSpinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
                 
    },
    calculate: function(component,event,helper){
       component.set("v.showSpinner", true);
       var contractDate = component.get("v.contractDate");
       var termLoanType = component.get("v.selectedTermLoanType");
        if(termLoanType=='Ordinary Term Loan')
        { termLoanType='TLON'}
        else if(termLoanType=='Mortgage Backed Term Loan')
        {termLoanType='MBTL'}
        else if(termLoanType=='Covid 19 Guarantee Term Loan')
        {termLoanType='RETL'}
        else if(termLoanType=='Agri Mortgage Term Loan')
        {termLoanType='AMTL'}
       var securityReq = component.get("v.securityReq");
       var selectMarketSector = component.get("v.selectMarketSector");
       var selectedPermitWD = component.get("v.selectedPermitWD");
       var selectedElectronicTransfer = component.get("v.selectedElectronicTransfer");
       var mandateNumber = component.get("v.mandateNumber"); 
       var selectLoanPurposes = component.get("v.selectLoanPurposes"); 
       var selectSchemeType = component.get("v.selectSchemeType"); 
       var selectPaymentMethod = component.get("v.selectPaymentMethod"); 
       var selectedSecReq = component.get("v.selectedSecReq"); 
       var selectAgreementCategory = component.get("v.selectAgreementCategory");
       var selectFinanceType = component.get("v.selectFinanceType");
        var action = component.get("c.getCalculateQuotesService1");
        var appProdId = component.get("v.caseRecord.Application_Product_Id__c");
        action.setParams({
            "appProdId": appProdId ,
            "contractDate"      : contractDate,
            "termLoanType"		: termLoanType,
            "securityReq"		: selectedSecReq,
            "selectMarketSector": selectMarketSector,
            "selectedPermitWD"  : selectedPermitWD,
            "selectedElectronicTransfer" : selectedElectronicTransfer,
            "mandateNumber":mandateNumber,
            "selectLoanPurposes":selectLoanPurposes,
            "selectSchemeType":selectSchemeType,
            "selectPaymentMethod":selectPaymentMethod,
            "selectAgreementCategory":selectAgreementCategory,
            "selectFinanceType":selectFinanceType
        }); 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                //var respQuotes = JSON.parse(response.getReturnValue());
                //console.log("-=-=-= respQuotes : " + JSON.stringify(respQuotes));
                //var resp = respQuotes.ABFgetQuoteInfoForEspV4Response.plpa71o;
                if (response.getReturnValue() != null && response.getReturnValue()=='Success') {
                    
                      helper.callservice2(component,event,helper)                                  
                    //component.set("v.respObjData", resp);
                   
                }else{
                    var toastEvent = this.getToast("ABF Service Error","ABFgetAndCalcConfDetailV4 Service Error","Error");
                    toastEvent.fire();
                    //this.showError(response, "ABF Service Error:");
                    component.set("v.showSpinner", false);
                }
                
            } else {
                var toastEvent = this.getToast("Agreement Service Error","ABFgetAndCalcConfDetailV4 Service Error","Error");
                    toastEvent.fire();
               // this.showError(response, "Agreement Service Error:");
               component.set("v.showSpinner", false);
            }
            
        });
        
        $A.enqueueAction(action);
        
    },
    callservice2 :function(component,event,helper){
      var contractDate = component.get("v.contractDate");
       var securityReq = component.get("v.securityReq");
       var selectMarketSector = component.get("v.selectMarketSector");
       var selectedPermitWD = component.get("v.selectedPermitWD");
       var selectedElectronicTransfer = component.get("v.selectedElectronicTransfer"); 
        var action = component.get("c.getCalculateQuotesService2");
        var appProdId = component.get("v.caseRecord.Application_Product_Id__c");
        action.setParams({
            "appProdId": appProdId ,
            "contractDate"      : contractDate,
            "securityReq"		: securityReq,
            "selectMarketSector": selectMarketSector,
            "selectedPermitWD"  : selectedPermitWD,
            "selectedElectronicTransfer" : selectedElectronicTransfer
        }); 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                //var respQuotes = JSON.parse(response.getReturnValue());
                //console.log("-=-=-= respQuotes : " + JSON.stringify(respQuotes));
                //var resp = respQuotes.ABFgetQuoteInfoForEspV4Response.plpa71o;
                if (response.getReturnValue() != null && response.getReturnValue()=='Success') {
                    helper.callservice3(component,event,helper)                                  
                    //component.set("v.respObjData", resp);
                   
                }else{
                    var toastEvent = this.getToast("ABF Service Error","ABFupdAgreementDetailsV2 service Error","Error");
                    toastEvent.fire();
                    //this.showError(response, "ABF Service Error:");
                    component.set("v.showSpinner", false);
                }
                
            } else {
                var toastEvent = this.getToast("Agreement Service Error"," ABFupdAgreementDetailsV2 Service Error","Error");
                    toastEvent.fire();
                component.set("v.showSpinner", false);
               // this.showError(response, "Agreement Service Error:");
            }
            
        });
        
        $A.enqueueAction(action);  
    },
    callservice3 :function(component,event,helper){
     var action = component.get("c.getCalculateQuotesService3");
        var appProdId = component.get("v.caseRecord.Application_Product_Id__c");
        action.setParams({
            "appProdId": appProdId 
        }); 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                //var respQuotes = JSON.parse(response.getReturnValue());
                //console.log("-=-=-= respQuotes : " + JSON.stringify(respQuotes));
                //var resp = respQuotes.ABFgetQuoteInfoForEspV4Response.plpa71o;
                if (response.getReturnValue() != null && response.getReturnValue()!='Error') {
                    var respQuotes = response.getReturnValue();
                    var accountstatus ='2';
                    console.log('respQuotes'+JSON.stringify(respQuotes));
                    accountstatus = respQuotes;  
                    
                    
                      helper.callservice4(component,event,helper,accountstatus)                                  
                    //component.set("v.respObjData", resp);
                   
                }else{
                    var toastEvent = this.getToast("ABF Service Error","ABFgetAccountStatusInfoV1","Error");
                    toastEvent.fire();
                    component.set("v.showSpinner", false);
                    //this.showError(response, "ABF Service Error:");
                }
                
            } else {
                var toastEvent = this.getToast("Agreement Service Error","ABFgetAccountStatusInfoV1","Error");
                    toastEvent.fire();
                component.set("v.showSpinner", false);
               // this.showError(response, "Agreement Service Error:");
            }
            
        });
        
        $A.enqueueAction(action);  
    },
    callservice4 :function(component,event,helper,accountstatus){
      
       var mandateNumber = component.get("v.mandateNumber"); 
        var action = component.get("c.getCalculateQuotesService4");
        var appProdId = component.get("v.caseRecord.Application_Product_Id__c");
        action.setParams({
            "appProdId": appProdId ,
            "accountstatus"      : accountstatus,
            "mandateNumber" : mandateNumber
        }); 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                //var respQuotes = JSON.parse(response.getReturnValue());
                //console.log("-=-=-= respQuotes : " + JSON.stringify(respQuotes));
                //var resp = respQuotes.ABFgetQuoteInfoForEspV4Response.plpa71o;
                if (response.getReturnValue() != null && response.getReturnValue()=='Success') {
                    var toastEvent = this.getToast("Success!", "Agreement Calculation Done Successfully", "Success");
                    toastEvent.fire();  
                    component.set("v.showSpinner", false);
                    //component.set("v.respObjData", resp);
                   
                }else{
                    var toastEvent = this.getToast("ABF Service ABFupdAccountStatusV1 Error","Error","Error");
                    toastEvent.fire();
                    component.set("v.showSpinner", false);
                    //this.showError(response, "ABF Service Error:");
                }
                
            } else {
                var toastEvent = this.getToast("Agreement Service Error","ABFupdAccountStatusV1","Error");
                    toastEvent.fire();
                component.set("v.showSpinner", false);
               // this.showError(response, "Agreement Service Error:");
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);  
    },
   showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        /*if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }
       */
        
        // show error notification
        var toastEvent = this.getToast("Error:" + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
    
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });
        
        return toastEvent;
    },
})