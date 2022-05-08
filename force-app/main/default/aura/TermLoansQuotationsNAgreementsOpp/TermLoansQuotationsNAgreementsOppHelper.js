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
        var action = component.get("c.getOpportunityRecord");
        action.setParams({
            "opportunityId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var opportunityRec = response.getReturnValue();
                if(opportunityRec != null){
                    //console.log("-=-=-=@@@@ Quotes Case Record : " + JSON.stringify(caseRec));
                    component.set("v.opportunity",opportunityRec);
                    component.set("v.quoteNumber",opportunityRec.OpportunityNumber);
                    console.log("-=-=-=@@@@ CIF : " + JSON.stringify(opportunityRec.CIF__c));
                    
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
    
    getAppProdRec: function (component,helper) {
        
        component.set("v.showSpinner", true);
        var action = component.get("c.getOpportunityApplicationProductRecord");
        action.setParams({
            "RecId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var appProdRec = response.getReturnValue();
                if(appProdRec != null){
                    console.log(" ---@@@@@ Account Number id : " + JSON.stringify(appProdRec));
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
    fetchQuoteResponseData: function (component,helper) {
        
        component.set("v.showSpinner", true);
        var action = component.get("c.QuoteResponseData");
        action.setParams({
            "RecId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
              //  var appProdRec = response.getReturnValue();
                var respQuotes = JSON.parse(response.getReturnValue());
                if(respQuotes != null){
                    console.log("+++++ " + JSON.stringify(respQuotes.PLSA71O));
                     var resp = respQuotes.PLSA71O.outputCopybookLayout;
                    console.log("-=-=-=Inside not null and No error  : " + resp);
                    component.set("v.respObjData",resp);
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
    fetchQuoteRequestData: function (component,helper) {
        
        component.set("v.showSpinner", true);
        var action = component.get("c.QuoteRequestData");
        action.setParams({
            "RecId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
              //  var appProdRec = response.getReturnValue();
                var reqQuotes = JSON.parse(response.getReturnValue());
                if(reqQuotes != null){
                    console.log("+++++reqQuotes " + JSON.stringify(reqQuotes.PLSA71I.inputCopybookLayout.inputRateFixedIndicator));
                    //var Lamount=component.get("v.loanAmount");
                    //if(Lamount!=null || Lamount!=undefined){
                        component.set("v.loanAmount",reqQuotes.PLSA71I.inputCopybookLayout.inputLoanAmount);
                   		component.set("v.contractTerm",reqQuotes.PLSA71I.inputCopybookLayout.inputContractTerm);
                    	component.set("v.contractDate",reqQuotes.PLSA71I.inputCopybookLayout.inputContractDate);
                    	component.set("v.dateoffirstinstalment",reqQuotes.PLSA71I.inputCopybookLayout.inputFirstRepaymentDate);
                        var repayfreqnew;
                        if(reqQuotes.PLSA71I.inputCopybookLayout.inputRepaymentFrequency=='12'){
                            repayfreqnew='Annually';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputRepaymentFrequency=='1'){
                            repayfreqnew='Monthly'
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputRepaymentFrequency=='3'){
                           repayfreqnew='Quarterly';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputRepaymentFrequency=='6'){
                            repayfreqnew='Semi-Annually'
                        }
                   		component.set("v.selectedRepaymentFrequency",repayfreqnew);
                    	component.set("v.selectedSkipMonths",reqQuotes.PLSA71I.inputCopybookLayout.inputSkipMonths);
                    	component.set("v.serviceFee",reqQuotes.PLSA71I.inputCopybookLayout.inputServiceFee);
                    	component.set("v.initiationFeetobeChargedUpfront",reqQuotes.PLSA71I.inputCopybookLayout.inputInitiationFee);
                        component.set("v.selectedCreditLifeRequired",reqQuotes.PLSA71I.inputCopybookLayout.creditLifeP=='N'?'NO':'YES');
                        
                        var initmethodval;
                        if(reqQuotes.PLSA71I.inputCopybookLayout.inputInitiationFeeMethod=='D'){
                            initmethodval='Debit Account';
                        }else{
                            initmethodval='Payable Upfront';
                        }
                        component.set("v.selectedInitiationFeePaymentMethod", initmethodval);
                    component.set("v.selectedDebitOrder",reqQuotes.PLSA71I.inputCopybookLayout.inputDebitOrderIndicator=='N'?'NO':'YES');
                    	component.set("v.primeRate",reqQuotes.PLSA71I.inputCopybookLayout.inputRatePrimeIndicator);
                    	component.set("v.marginPercentage",reqQuotes.PLSA71I.inputCopybookLayout.inputMargin);
                    var Rateabovebelow;
                    if(reqQuotes.PLSA71I.inputCopybookLayout.inputRateAbovebelow=='Margin Above Prime'){
                        Rateabovebelow='Margin Above Prime';
                    }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputRateAbovebelow=='Margin Above Prime'){
                        Rateabovebelow='Margin below Prime';
                    } 
                    component.set("v.selectedRateAboveorBelow",Rateabovebelow);
                    var termLoanType;
                    if(reqQuotes.PLSA71I.inputCopybookLayout.inputTermLoanType=='TLON'){
                        termLoanType='Ordinary Term Loan';
                    }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputTermLoanType=='MBTL'){
                        termLoanType='Mortgage Backed Term Loan';
                    }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputTermLoanType=='RETL'){
                        termLoanType='Covid 19 Guarantee Term Loan';
                    }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputTermLoanType=='AMTL'){
                        termLoanType='Agri Mortgage Term Loan';
                    }
           
                   component.set("v.selectedTermLoanType",termLoanType);
                    component.set("v.selectedComplexStructure",reqQuotes.PLSA71I.inputCopybookLayout.inputComplexStructureIndicator=='N'?'NO':'YES');
                   
                        var purposeOfLoan; 
                        if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='21'){
                           purposeOfLoan='Live Stock Purchases';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='24'){
                            purposeOfLoan='Fixed Property Purchases';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='25'){
                            purposeOfLoan='Plant and Equipment';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='28'){
                            purposeOfLoan='Purchase of Business';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='29'){
                            purposeOfLoan='Renovations';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='30'){
                            purposeOfLoan='Improvement of Fixed Property';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='31'){
                            purposeOfLoan='Restrucring of Debts';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='32'){
                            purposeOfLoan='Agricultural Development';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='35'){
                            purposeOfLoan='Established Orchards (Existing Code in ABF)';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='36'){
                            purposeOfLoan='Replace Orchards (Existing Code in ABF)';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='37'){
                            purposeOfLoan='Start New Business (Existing Code in ABF)';
                        }else if(reqQuotes.PLSA71I.inputCopybookLayout.inputPurposeOfLoanCode=='08'){
                            purposeOfLoan='Other';
                        }

                        component.set("v.selectedLoanPurposes",purposeOfLoan);
                    component.set("v.selectedInterestRateType",reqQuotes.PLSA71I.inputCopybookLayout.inputRateFixedIndicator=='Y'?'Fixed':'Variable');
                    component.set("v.empowermentFundCode",reqQuotes.PLSA71I.inputCopybookLayout.inputEmpowermentCode);
                    component.set("v.quoteNumber",reqQuotes.PLSA71I.inputCopybookLayout.inputQuoteNumber);
                    //}
                    
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
        
        var RecId = component.get("v.recordId");
        var loanAmt = component.get("v.loanAmount");
        var contractDt = component.get("v.contractDate");
        var dtfirstInst= component.get("v.dateoffirstinstalment")
        var contractTerm = component.get("v.contractTerm");
        var initiationFeetobeChargedUpfront = component.get("v.initiationFeetobeChargedUpfront");
        var servicefee = component.get("v.serviceFee");
        var repayFreq = component.get("v.selectedRepaymentFrequency");
        if(repayFreq=='Annually'){repayFreq='12';}
        else if(repayFreq=='Monthly'){repayFreq='1';}
            else if(repayFreq=='Quarterly'){repayFreq='3';}
                else if(repayFreq=='Semi-Annually'){repayFreq='6';}
        
        var skipmonths = component.get("v.selectedSkipMonths");
        if(repayFreq=='1'){  // Only for Monthly Frequency
            skipmonths=skipmonths;
        }else{
            skipmonths='0'; 
        }
        
        var primeRt = component.get("v.primeRate");
        var margin = component.get("v.marginPercentage");
        var SelAbOrBel = component.get("v.selectedRateAboveorBelow");
        if(SelAbOrBel == 'Margin Above Prime'){
            primeRt=(parseFloat(primeRt) + parseFloat(margin)).toFixed(2) ;
        }else{
            primeRt= (parseFloat(primeRt) - parseFloat(margin)).toFixed(2) ;
        }
        var creditLifReq=component.get("v.selectedCreditLifeRequired");
        if(creditLifReq=='NO'){creditLifReq='N'}else{creditLifReq='Y'}
        var debitOrder=component.get("v.selectedDebitOrder");
        if(debitOrder=='NO'){debitOrder='N'}else{debitOrder='Y'}
        var complexStr = component.get("v.selectedComplexStructure");
        if(complexStr=='NO'){complexStr='N'}else{complexStr='Y'}
        var initMethod = component.get("v.selectedInitiationFeePaymentMethod");
        if(initMethod=='Debit Account'){initMethod='D'}else{initMethod='P'}
        
        var termLoanType = component.get("v.selectedTermLoanType");
        if(termLoanType=='Ordinary Term Loan')
        { termLoanType='TLON'}
        else if(termLoanType=='Mortgage Backed Term Loan')
        {termLoanType='MBTL'}
            else if(termLoanType=='Covid 19 Guarantee Term Loan')
            {termLoanType='RETL'}
                else if(termLoanType=='Agri Mortgage Term Loan')
                {termLoanType='AMTL'}
        
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
        
        var rateFixed = component.get("v.selectedInterestRateType");
        if(rateFixed=='Fixed'){rateFixed='Y'}else{rateFixed='N'}
         var action = component.get("c.getCalculateQuotes");
        action.setParams({
            
            "RecId"            : RecId,
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
            "purposeOfLoanP"     : purposeOfLoan,                                  //purposeOfLoan,                                   			     						   
            "maxRateTypeP"       : '52',     	//Bongani Defaulted to 52
            "totalSettleAmountP" : '0',     //default 0
            "loanAccToSettleP"   : '0',     //default 0
            "loanSettleAmountP"  : '0',     //default 0
            "termLoanTypeP"      : termLoanType,                            //'TLON', 
            "quoteCreatedByP"    : 'E',    
            "inpmargin" : margin,
            "inpRate" : SelAbOrBel,      
            
        }); 
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var respQuotes = JSON.parse(response.getReturnValue());
                var respCheck = respQuotes.NBSMSGO3.outputErrorMessage.outputErrorMessageTable[0].errorMessageText;
                
                if (respQuotes != null && respCheck.includes("000000")) {
                    var resp = respQuotes.PLSA71O.outputCopybookLayout;
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
            component.set("v.optionInterestRateType",interestRateType);
            component.set("v.optionLoanPurposes", loanPurposes);
            },
            
            })