({
    
    
    getPriceRate: function (component) {
        
        component.set("v.showSpinner", true);
        var action = component.get("c.getPrimeRates");
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var resPriceRate = response.getReturnValue();
                if(resPriceRate != null){
                    //console.log("-=-=-= priceRate retrieved from service: " + resPriceRate);
                    component.set("v.primeRate",resPriceRate);
                }else {
                    this.showError(response, "Please Try Again, PriceRate Service returns NULL:");
                }
            }
            else {
                this.showError(response, "getPriceRate Service Error:");
            }
            
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
        
    }, 
    
    getCaseRec: function (component) {
        
        component.set("v.showSpinner", true);
        var action = component.get("c.getCaseRecord");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var caseRec = response.getReturnValue();
                if(caseRec != null){
                    //console.log("-=-=-=@@@@ Quotes Case Record : " + JSON.stringify(caseRec));
                    component.set("v.case",caseRec);
                    component.set("v.quoteNumber",caseRec.CaseNumber);
                    console.log("-=-=-=@@@@ CIF : " + JSON.stringify(caseRec.CIF__c));
                    
                }else {
                    this.showError(response, "No Case Record Found:");
                }
                
            } else {
                this.showError(response, "Missing Case Record :");
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
        
    }, 
    
    getAppProdRec: function (component) {
        
        component.set("v.showSpinner", true);
        var action = component.get("c.getCaseApplicationProductRecord");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var appProdRec = response.getReturnValue();
                if(appProdRec != null){
                    // console.log("-=-=-= Quotes AppProd Record : " + JSON.stringify(appProdRec));
                    console.log(" ---@@@@@ Account Number : " + JSON.stringify(appProdRec.Account_Number__c));
                    component.set("v.appProduct",appProdRec);
                }else {
                    this.showError(response, "No AppProd Record Found:");
                }
                
            } else {
                this.showError(response, "Missing AppProd Record :");
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
        
    },
    
    getCalculateQuote: function  (component) { 
        component.set("v.showSpinner", true);
        
        var caseId = component.get("v.recordId");
        console.log("-=-=-= caseId : " + caseId);
        var loanAmt = component.get("v.loanAmount");
        console.log("-=-=-= loanAmt : " + loanAmt);
        var contractDt = component.get("v.contractDate");
        console.log("-=-=-= contractDt : " + contractDt);
        var dtfirstInst= component.get("v.dateoffirstinstalment")
        console.log("-=-=-= dtfirstInst : " + dtfirstInst);
        var contractTerm = component.get("v.contractTerm");
        console.log("-=-=-= dtfirstInst : " + dtfirstInst);
        var initiationFeetobeChargedUpfront = component.get("v.initiationFeetobeChargedUpfront");
        console.log("-=-=-= initiationFeetobeChargedUpfront : " + initiationFeetobeChargedUpfront);
        var servicefee = component.get("v.serviceFee");
        console.log("-=-=-= servicefee : " + servicefee);        
        
        var repayFreq = component.get("v.selectedRepaymentFrequency");
        if(repayFreq=='Annually'){repayFreq='12';}
        else if(repayFreq=='Monthly'){repayFreq='1';}
            else if(repayFreq=='Quarterly'){repayFreq='3';}
                else if(repayFreq=='Semi-Annually'){repayFreq='6';}
        console.log("-=-=-= repayFreq : " + repayFreq);
        
        var skipmonths = component.get("v.selectedSkipMonths");
        if(repayFreq=='1'){  // Only for Monthly Frequency
            skipmonths=skipmonths;
        }else{
            skipmonths='0'; 
        }
        console.log("-=-=-= skipmonths : " + skipmonths);
        
        var primeRt = component.get("v.primeRate");
        var margin = component.get("v.marginPercentage");
        var SelAbOrBel = component.get("v.selectedRateAboveorBelow");
        console.log("-=-=-= SelAbOrBel : " + SelAbOrBel);
        if(SelAbOrBel == 'Margin Above Prime'){
            primeRt=(parseFloat(primeRt) + parseFloat(margin)).toFixed(2) ;
        }else{
            primeRt= (parseFloat(primeRt) - parseFloat(margin)).toFixed(2) ;
        }
        console.log("-=-=-= primeRt : " + primeRt);
        var creditLifReq=component.get("v.selectedCreditLifeRequired");
        if(creditLifReq=='NO'){creditLifReq='N'}else{creditLifReq='Y'}
        console.log("-=-=-= creditLifReq : " + creditLifReq);
        var debitOrder=component.get("v.selectedDebitOrder");
        if(debitOrder=='NO'){debitOrder='N'}else{debitOrder='Y'}
        console.log("-=-=-= debitOrder : " + debitOrder);
        var complexStr = component.get("v.selectedComplexStructure");
        if(complexStr=='NO'){complexStr='N'}else{complexStr='Y'}
        console.log("-=-=-= complexStr : " + complexStr);
        var initMethod = component.get("v.selectedInitiationFeePaymentMethod");
        if(initMethod=='Debit Account'){initMethod='D'}else{initMethod='P'}
        console.log("-=-=-= initMethod : " + initMethod);
        
        var termLoanType = component.get("v.selectedTermLoanType");
        if(termLoanType=='Ordinary Term Loan')
        { termLoanType='TLON'}
        else if(termLoanType=='Mortgage Backed Term Loan')
        {termLoanType='MBTL'}
            else if(termLoanType=='Covid 19 Guarantee Term Loan')
            {termLoanType='RETL'}
                else if(termLoanType=='Agri Mortgage Term Loan')
                {termLoanType='AMTL'}
        console.log("-=-=-= termLoanType : " + termLoanType);
        
        var purposeOfLoan = component.get("v.selectedLoanPurposes");
        if(purposeOfLoan=='Live Stock Purchases')
        { purposeOfLoan='21'}
        else if(purposeOfLoan=='Fixed Property Purchases')
        {purposeOfLoan='24'}
            else if(purposeOfLoan=='Plant and Equipment')
            {purposeOfLoan='25'}
                else if(purposeOfLoan=='Purchase of Business')
                {purposeOfLoan='28'}
                    else if(purposeOfLoan=='Renovations')
                    {purposeOfLoan='29'}
                        else if(purposeOfLoan=='Improvement of Fixed Property')
                        {purposeOfLoan='30'}
                            else if(purposeOfLoan=='Restrucring of Debts')
                            {purposeOfLoan='31'}
                                else if(purposeOfLoan=='Agricultural Development')
                                {purposeOfLoan='32'}
                                    else if(purposeOfLoan=='Established Orchards (Existing Code in ABF)')
                                    {purposeOfLoan='35'}
                                        else if(purposeOfLoan=='Replace Orchards (Existing Code in ABF)')
                                        {purposeOfLoan='36'}
                                            else if(purposeOfLoan=='Start New Business (Existing Code in ABF)')
                                            {purposeOfLoan='37'}
                                                else if(purposeOfLoan=='Other')
                                                {purposeOfLoan='08'}
        console.log("-=-=-= purposeOfLoan : " + purposeOfLoan);
        
        var rateFixed = component.get("v.selectedInterestRateType");
        if(rateFixed=='Fixed'){rateFixed='Y'}else{rateFixed='N'}
        console.log("-=-=-= rateFixed : " + rateFixed);
        
        
        var action = component.get("c.getCalculateQuotes");
        action.setParams({
            "caseIdP"            : caseId,
            "loanAmountP"        : loanAmt,     			 //'855000.00', 
            "contractDateP"      : contractDt,					 // '20201021',  NCA Out-today and four days in future   -/ NCA IN today 
            "firstRepayDateP"    : dtfirstInst, 		//'20201130',
            "repayFreqP"         : repayFreq, 										//'01',  
            "contractTermP"      : contractTerm, 				 //'66',
            "mortgageP"          : 'N',            //TBC    //Secured by Mortgage Bond field on case
            "ratePrimeP"         : 'Y',                  
            "rateFixedP"         : rateFixed,							//'N', 
            "interestRateP"      : primeRt,              							   //'7.25000', 
            "initiationFeeP"     : initiationFeetobeChargedUpfront,  //'42350',  
            "serviceFeeP"        : servicefee,      				  //'0',
            "skipMonthsP"        : skipmonths,       			   						 //'9',	
            "creditLifeP"        : creditLifReq,                                            //'N',                
            "debitOrderP"        : debitOrder,             							 //'Y',
            "quoteNumberP"       : '848160',								//component.get("v.quoteNumber"),						                               
            "complexStrP"        : complexStr,                                                   //'N',                   
            "initMethodP"        : initMethod,                                		    //'P',   
            "applicationNumberP" : '00',   									  //Default -00(Nonscored
            "purposeOfLoanP"     : '02',                                  //purposeOfLoan,                                   			     						   
            "maxRateTypeP"       : '52',     	//Bongani Defaulted to 52
            "totalSettleAmountP" : '0',     //default 0
            "loanAccToSettleP"   : '0',     //default 0
            "loanSettleAmountP"  : '0',     //default 0
            "termLoanTypeP"      : termLoanType,                            //'TLON', 
            "quoteCreatedByP"    : 'E',    
            "schemeCodeP"        : '0',     //default 0
            "clifeSchemeCodeP"   : '0',     //Default 0
            "clifePremiumP"      : '0',    
            "nlrRefNoP"          : '0',         
            "ncaIndP"            : '0',     						//NCAStatus TBC
            "visibleCreditP"     : 'N'       
            
        }); 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var respQuotes = JSON.parse(response.getReturnValue());
                console.log("-=-=-= respQuotes : " + JSON.stringify(respQuotes));
                var respCheck = respQuotes.NBSMSGO3.outputErrorMessage.outputErrorMessageTable[0].errorMessageText;
                
                if (respQuotes != null && respCheck.includes("000000")) {
                    var resp = respQuotes.PLSA71O.outputCopybookLayout;
                    console.log("-=-=-=Inside not null and No error  : " + resp);
                    var toastEvent = this.getToast("Success!", "Quotes Fetched Successfully", "Success");
                    toastEvent.fire();
                    
                    component.set("v.respObjData", resp);
                    
                }else {
                    
                    //this.showError(response, "Quotes Service Error:");
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        title: "Error!",
                        message: respCheck,
                        type:  "Error",
                        mode: "sticky"
                    });
                    toastEvent.fire();
                } 
                
            } else {
                this.showError(response, "ABFgetQuoteInfoForEspV5 Service Error:");
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
        
    },
    
    
    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
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
    
    initPickLisOptions: function (component) {
        // Initialize input select options
        var rePayFreq = [
            { class: "optionClass", label: "--Please Select--", value: "", selected: "true" },
            { class: "optionClass", label: "Annually", value: "Annually" },
            { class: "optionClass", label: "Monthly", value: "Monthly" },
            { class: "optionClass", label: "Quarterly", value: "Quarterly" },
            { class: "optionClass", label: "Semi-Annually", value: "Semi-Annually" },
        ];
            var skipMonths = [
            { class: "optionClass", label: "--Please Select--", value: "", selected: "true" },
            { class: "optionClass", label: "0", value: "0" },
            { class: "optionClass", label: "1", value: "1" },
            { class: "optionClass", label: "2", value: "2" },
            { class: "optionClass", label: "3", value: "3" },
            { class: "optionClass", label: "4", value: "4" },
            { class: "optionClass", label: "5", value: "5" },
            { class: "optionClass", label: "6", value: "6" },
            { class: "optionClass", label: "7", value: "7" },
            { class: "optionClass", label: "8", value: "8" },
            { class: "optionClass", label: "9", value: "9" },
            { class: "optionClass", label: "10", value: "10" },
            { class: "optionClass", label: "11", value: "11" },
            { class: "optionClass", label: "12", value: "12" },
        ]; 
        var initFeePayMethod = [
            { class: "optionClass", label: "--Please Select--", value: "", selected: "true" },
            { class: "optionClass", label: "Debit Account", value: "Debit Account" },
            { class: "optionClass", label: "Payable Upfront", value: "Payable Upfront" },
            
        ];
            var rateAboveBelow = [
            { class: "optionClass", label: "--Please Select--", value: "", selected: "true" },
            { class: "optionClass", label: "Margin Above Prime", value: "Margin Above Prime" },
            { class: "optionClass", label: "Margin Below Prime", value: "Margin Below Prime" },
            
        ];
        var termLoanType = [
            { class: "optionClass", label: "--Please Select--", value: "", selected: "true" },
            { class: "optionClass", label: "Agri Mortgage Term Loan", value: "Agri Mortgage Term Loan" },
            { class: "optionClass", label: "Covid 19 Guarantee Term Loan", value: "Covid 19 Guarantee Term Loan" },
            { class: "optionClass", label: "Mortgage Backed Term Loan", value: "Mortgage Backed Term Loan" },
            { class: "optionClass", label: "Ordinary Term Loan", value: "Ordinary Term Loan" },
            
        ];
            var interestRateType = [
            { class: "optionClass", label: "--Please Select--", value: "", selected: "true" },
            { class: "optionClass", label: "Fixed", value: "Fixed" },
            { class: "optionClass", label: "Variable", value: "Variable" },
            
        ];
        var loanPurposes = [
            { class: "optionClass", label: "--Please Select--", value: "", selected: "true" },
            { class: "optionClass", label: "Live Stock Purchases", value: "Live Stock Purchases" },
            { class: "optionClass", label: "Fixed Property Purchases", value: "Fixed Property Purchases" },
            { class: "optionClass", label: "Plant and Equipment", value: "Plant and Equipment" },
            { class: "optionClass", label: "Purchase of Business", value: "Purchase of Business" },
            { class: "optionClass", label: "Renovations", value: "Renovations" },
            { class: "optionClass", label: "Improvement of Fixed Property", value: "Improvement of Fixed Property" },
            { class: "optionClass", label: "Restrucring of Debts", value: "Restrucring of Debts" },
            { class: "optionClass", label: "Agricultural Development", value: "Agricultural Development" },
            { class: "optionClass", label: "Established Orchards (Existing Code in ABF)", value: "Established Orchards (Existing Code in ABF)" },
            { class: "optionClass", label: "Replace Orchards (Existing Code in ABF)", value: "Replace Orchards (Existing Code in ABF)" },
            { class: "optionClass", label: "Start New Business (Existing Code in ABF)", value: "Start New Business (Existing Code in ABF)" },
            { class: "optionClass", label: "Other", value: "Other" },
            
            
        ];
            
            
            component.set("v.optionRepaymentFrequency", rePayFreq);
            component.set("v.optionSkipMonths", skipMonths);
            component.set("v.optionInitiationFeePaymentMethod", initFeePayMethod);
            component.set("v.optionRateAboveorBelow", rateAboveBelow);
            component.set("v.optionTermLoanType", termLoanType);
            component.set("v.optionInterestRateType", interestRateType);
            component.set("v.optionLoanPurposes", loanPurposes);
            
            },
            
            })