({
    
    getAppPrdctCpfRec: function(component, event, helper) {
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appPrdctCpfRecId = response.getReturnValue();
                component.set("v.appPrdctCpfRec", appPrdctCpfRecId);
                console.log("appPrdctCpfRecId5656565: " + JSON.stringify(appPrdctCpfRecId));
                if(appPrdctCpfRecId.Facility_purpose__c == 'PURPOSE AS APPROVED BY CREDIT'  ){
                    component.set("v.showApprovedByCreditField", true);
                    component.set("v.showPortfolioDescriptionField", false);
                    //component.set("v.showcreditPropField", true);
                    component.set("v.showPropertyDescriptionField", false);
                }else if(appPrdctCpfRecId.Facility_purpose__c == 'To finance in whole or in part the acquisition of a portfolio of Properties' ){
                    component.set("v.showPortfolioDescriptionField", true);
                    //  component.set("v.showcreditPropField", false);
                    component.set("v.showApprovedByCreditField", false);
                    component.set("v.showPropertyDescriptionField", false);
                }else if(appPrdctCpfRecId.Facility_purpose__c == 'To finance in whole or in part the acquisition of the Property' ){
                    // component.set("v.showcreditPropField", true);
                    component.set("v.showApprovedByCreditField", false);
                    component.set("v.showPortfolioDescriptionField", false);
                    component.set("v.showPropertyDescriptionField", true);
                }
                if(appPrdctCpfRecId.Amendment_and_restatement_clause_app__c == 'Yes'  ){
                    console.log('v.showCIFField'+component.get("v.showCIFField"));
                    component.set("v.showCIFField", true);
                    console.log('v.showCIFField'+component.get("v.showCIFField"));
                    
                }else if(appPrdctCpfRecId.Amendment_and_restatement_clause_app__c == 'No'  ){
                    component.set("v.showCIFField", false);
                }
                if(appPrdctCpfRecId.Equity_contributions__c == 'Equity contribution amount'  ){
                    component.set("v.showEquityAmtField", true);
                }else if(appPrdctCpfRecId.Equity_contributions__c == 'Other'  ){
                    component.set("v.showOtherEquityField", true);
                }
                if(appPrdctCpfRecId.Transactional_banking_accounts__c == 'Yes'  ){
                    component.set("v.transactionalBankingAccounts", 'Yes');
                }else if(appPrdctCpfRecId.Transactional_banking_accounts__c == 'No'  ){
                    component.set("v.transactionalBankingAccounts", 'No');
                }
                if(appPrdctCpfRecId.Include_guarantor_s__c == 'Yes'  ){
                    component.set("v.includeGuarantors", 'Yes');
                }else if(appPrdctCpfRecId.Include_guarantor_s__c == 'No'  ){
                    component.set("v.includeGuarantors", 'No');
                }
                if(appPrdctCpfRecId.Undertakings_threshold__c == 'Yes'  ){
                    component.set("v.showThresholdFields", true);
                }else if(appPrdctCpfRecId.Undertakings_threshold__c == 'No'  ){
                    component.set("v.showThresholdFields", false);
                }
                if(appPrdctCpfRecId.Development_loan_Is_VAT_Facility_applica__c!=null && appPrdctCpfRecId.Development_loan_Is_VAT_Facility_applica__c!='')
                {
                    component.set("v.devloanisvat",appPrdctCpfRecId.Development_loan_Is_VAT_Facility_applica__c);
                }
                if(appPrdctCpfRecId.VAT_Repayment_Options__c!=null && appPrdctCpfRecId.VAT_Repayment_Options__c!='')
                {
                    component.set("v.vatrepayoptions",appPrdctCpfRecId.VAT_Repayment_Options__c);
                }
                if(appPrdctCpfRecId.Development_loan_VAT_Facility_amount__c!=null && appPrdctCpfRecId.Development_loan_VAT_Facility_amount__c!='')
                {
                    component.set("v.devloanvatfaciamt",appPrdctCpfRecId.Development_loan_VAT_Facility_amount__c);
                }
                if(appPrdctCpfRecId.Development_loan_Final_Repayment_Date__c!=null && appPrdctCpfRecId.Development_loan_Final_Repayment_Date__c!='')
                {
                    component.set("v.devloanfinalrepaypick",appPrdctCpfRecId.Development_loan_Final_Repayment_Date__c);
                }

                    
                    
                    }
            else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRecId));
            }
        });
        
        $A.enqueueAction(action);
    },
    getAppPortfolioCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppPortfolioRec");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //debugger;
                var appPortfolioRec = response.getReturnValue();
                console.log("newPortfolioList: " + JSON.stringify(appPortfolioRec));
                component.set("v.newPortfolioList",response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + JSON.stringify(appPortfolioRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    updateAppPrdctcpf: function(component, event, helper) { 
        var transactionalBankingAccountsVar,devfaciPurpose;
        var includeGuarantorsVar,devproptype,otherproptype,devpropDescription;
        var whenVar,devDescription,devloanvatfaciamt,aggmaxiamt,amtoutstanding;
        var OtherEcon,devloanterm,devloanfinalrepaypick,dateoffinalrepay,devloanpurpose;
        var equityContsAmt,vatfacifee,vatrepayoptions,insterestfreq,vatfacifinalinstalamt;
        var thresholdAmt,uThreshold,equityContributions,cdThresholdAmt,aFinanceDocsRequired;
        var thresholdP, pSelection,litThreshloldAmt,fPurpose;
        var addReqDoc;var purpAsAppByCred;var propertyDesc;var CPFAccnum;var propertyDesc1;
        // W-008841 - START 
        if($A.util.isUndefinedOrNull(component.get("v.transactionalBankingAccounts")) || component.get("v.transactionalBankingAccounts") == ''){
            transactionalBankingAccountsVar=null;
        }else{transactionalBankingAccountsVar = component.get("v.transactionalBankingAccounts");}
        if(transactionalBankingAccountsVar == 'Yes'){
            if($A.util.isUndefinedOrNull(component.get("v.includeGuarantors")) || component.get("v.includeGuarantors") == ''){
                includeGuarantorsVar=null;
            }else{includeGuarantorsVar = component.get("v.includeGuarantors");}
            if($A.util.isUndefinedOrNull(component.find("when").get("v.value")) || component.find("when").get("v.value") == ''){
                whenVar=null;
            }else{whenVar = component.find("when").get("v.value");}
        }    
        // W-008841 END
        
        if(component.find("OtherEqContribution") == undefined){
            OtherEcon=null;
        }else{
            OtherEcon = component.find("OtherEqContribution").get("v.value");
        }
        if(component.find("eContAmt") == undefined){
            equityContsAmt=null;
        }else{
            equityContsAmt = component.find("eContAmt").get("v.value");
        }
        if(component.find("tAmount") == undefined){
            thresholdAmt=null;
        }else{
            thresholdAmt = component.find("tAmount").get("v.value");
        }
        if(component.find("thresholdPeriods") == undefined){
            thresholdP=null;
        }else{
            thresholdP = component.find("thresholdPeriods").get("v.value");
        }
        if(component.find("additionalReqDoc") == undefined){
            addReqDoc=null;
        }else{
            addReqDoc = component.find("additionalReqDoc").get("v.value");
        }
        if(component.find("purpAsApprovedByCred") == undefined){
            purpAsAppByCred=null;
        }else{
            purpAsAppByCred = component.find("purpAsApprovedByCred").get("v.value");
        }
        if(component.find("propDescription") == undefined){
            propertyDesc=null;
        }else{
            propertyDesc = component.find("propDescription").get("v.value");
        }
        if(component.find("propDescription1") == undefined){
            propertyDesc1=null;
        }else{
            propertyDesc1 = component.find("propDescription1").get("v.value");
        }
        if(component.find("CPFF_accNo") == undefined){
            CPFAccnum=null;
        }else{
            CPFAccnum = component.find("CPFF_accNo").get("v.value");
        }
        if(component.find("propselection") == undefined){
            pSelection=null;
        }else{
            pSelection = component.find("propselection").get("v.value");
        }
        if(component.find("devfaciPurpose") == undefined){
            devfaciPurpose=null;
        }else{
            devfaciPurpose = component.find("devfaciPurpose").get("v.value");
        }
        if(component.find("devproptype") == undefined){
            devproptype=null;
        }else{
            devproptype = component.find("devproptype").get("v.value");
        }
        if(component.find("otherproptype") == undefined){
            otherproptype=null;
        }else{
            otherproptype = component.find("otherproptype").get("v.value");
        }
        if(component.find("devpropDescription") == undefined){
            devpropDescription=null;
        }else{
            devpropDescription = component.find("devpropDescription").get("v.value");
        }
        if(component.find("devDescription") == undefined){
            devDescription=null;
        }else{
            devDescription = component.find("devDescription").get("v.value");
        }
        if(component.find("devloanvatfaciamt") == undefined){
            devloanvatfaciamt=null;
        }else{
            devloanvatfaciamt = component.find("devloanvatfaciamt").get("v.value");
        }
        if(component.find("aggmaxiamt") == undefined){
            aggmaxiamt=null;
        }else{
            aggmaxiamt = component.find("aggmaxiamt").get("v.value");
        }
        if(component.find("amtoutstanding") == undefined){
            amtoutstanding=null;
        }else{
            amtoutstanding = component.find("amtoutstanding").get("v.value");
        }
        if(component.find("devloanterm") == undefined){
            devloanterm=null;
        }else{
            devloanterm = component.find("devloanterm").get("v.value");
        }
        if(component.find("devloanfinalrepaypick") == undefined){
            devloanfinalrepaypick=null;
        }else{
            devloanfinalrepaypick = component.find("devloanfinalrepaypick").get("v.value");
        }
        if(component.find("dateoffinalrepay") == undefined){
            dateoffinalrepay=null;
        }else{
            dateoffinalrepay = component.find("dateoffinalrepay").get("v.value");
        }
        if(component.find("devloanpurpose") == undefined){
            devloanpurpose=null;
        }else{
            devloanpurpose = component.find("devloanpurpose").get("v.value");
        }
        if(component.find("vatfacifee") == undefined){
            vatfacifee=null;
        }else{
            vatfacifee = component.find("vatfacifee").get("v.value");
        }
        if(component.find("vatrepayoptions") == undefined){
            vatrepayoptions=null;
        }else{
            vatrepayoptions = component.find("vatrepayoptions").get("v.value");
        }
        if(component.find("insterestfreq") == undefined){
            insterestfreq=null;
        }else{
            insterestfreq = component.find("insterestfreq").get("v.value");
        }
        if(component.find("vatfacifinalinstalamt") == undefined){
            vatfacifinalinstalamt=null;
        }else{
            vatfacifinalinstalamt = component.find("vatfacifinalinstalamt").get("v.value");
        }
        if(component.find("threshold") == undefined){
            uThreshold=null;
        }else{
            uThreshold = component.find("threshold").get("v.value");
        }
        if(component.find("equity") == undefined){
            equityContributions=null;
        }else{
            equityContributions = component.find("equity").get("v.value");
        }
        if(component.find("crossDefaultThresholdAmt") == undefined){
            cdThresholdAmt=null;
        }else{
            cdThresholdAmt = component.find("crossDefaultThresholdAmt").get("v.value");
        }
        if(component.find("additionalDoc") == undefined){
            aFinanceDocsRequired=null;
        }else{
            aFinanceDocsRequired = component.find("additionalDoc").get("v.value");
        }
        if(component.find("litAmt") == undefined){
            litThreshloldAmt=null;
        }else{
            litThreshloldAmt = component.find("litAmt").get("v.value");
        }
        if(component.find("fPurpose") == undefined){
            fPurpose=null;
        }else{
            fPurpose = component.find("fPurpose").get("v.value");
        }
        var appProductcpf = new Object();
        appProductcpf.amendmentClause = component.find("amendment").get("v.value");
        appProductcpf.CPFAccNumber= CPFAccnum;
        appProductcpf.chargingDate= component.find("cDate").get("v.value");
        appProductcpf.uThreshold= uThreshold;
        appProductcpf.withdrawal= component.find("withdrawal").get("v.value");
        appProductcpf.ownerOccupied=component.find("ownerOccupied").get("v.value");
        appProductcpf.equityContributions= equityContributions;
        appProductcpf.equityContributionsAmt= equityContsAmt;
        appProductcpf.otherEquity= OtherEcon;
        appProductcpf.bUnderCPA= component.find("underCPA").get("v.value");
        appProductcpf.thresholdAmount= thresholdAmt;
        appProductcpf.tPeriods= thresholdP;
        appProductcpf.cdThresholdAmt=  cdThresholdAmt;
        appProductcpf.aFinanceDocsRequired= aFinanceDocsRequired;
        appProductcpf.aFinanceDocsRequiredDocs= addReqDoc;
        appProductcpf.fLoanOptions= component.find("furtherLoanOptions").get("v.value");
        appProductcpf.litThreshloldAmt= litThreshloldAmt;
        appProductcpf.fPurpose= fPurpose;
        appProductcpf.pApprovedByCred=  purpAsAppByCred;
        appProductcpf.pDescription= propertyDesc;
        appProductcpf.pDescription1= propertyDesc1;
        appProductcpf.pSelection= pSelection;//propsel,
        appProductcpf.transactionalBankingAccounts=  transactionalBankingAccountsVar;
        appProductcpf.includeGuarantors= includeGuarantorsVar;
        appProductcpf.whenValue= whenVar;
        appProductcpf.devloanisvat= component.get("v.devloanisvat");
        appProductcpf.devfaciPurpose=devfaciPurpose;
        appProductcpf.devproptype=devproptype;
        appProductcpf.otherproptype=otherproptype;
        appProductcpf.devpropDescription=devpropDescription;
        appProductcpf.devDescription=devDescription;
        appProductcpf.devloanvatfaciamt=devloanvatfaciamt;
        appProductcpf.aggmaxiamt=aggmaxiamt;
        appProductcpf.amtoutstanding=amtoutstanding;
        appProductcpf.devloanterm=devloanterm;
        appProductcpf.devloanfinalrepaypick=devloanfinalrepaypick;
        appProductcpf.dateoffinalrepay=dateoffinalrepay;
        appProductcpf.devloanpurpose=devloanpurpose;
        appProductcpf.vatfacifee=vatfacifee;
        appProductcpf.vatrepayoptions=vatrepayoptions;
        appProductcpf.insterestfreq=insterestfreq;
        appProductcpf.vatfacifinalinstalamt=vatfacifinalinstalamt;
        appProductcpf.newPortfolios= component.get("v.newPortfolioList");
             
        var action = component.get("c.updateAppPrdctcpf");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "objData": JSON.stringify(appProductcpf),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
                console.log("generalinfo ="+JSON.stringify(oppRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Product CPF record updated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    
    fetchAccHelper : function(component, event, helper) {
        component.set('v.mycolumns', [
            {label: 'Portfolio Name', fieldName: 'Portfolio_description__c', type: 'text'}
            
            
        ]);
        var action = component.get("c.fetchApplicationPortfolio");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.acctList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    updatePropPortfolioData : function(component , event , helper){
        var action = component.get("c.updatePropPortfolio");
        action.setParams({
            "recId" : component.get("v.appPrdctCpfRec.Id"),
            "description" :  component.find("desc").get("v.value")
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRecord = response.getReturnValue();
                console.log("Opprec ="+JSON.stringify(oppRecord));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Product CPF record updated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    addPortfolio : function(component, event) {
        var portlist = component.get("v.newPortfolioList");
        portlist.push({
            'sobjectType' : 'Application_Portfolio__c',
            'Portfolio_Description__c' : ''
            
        });
        component.set("v.newPortfolioList",portlist);   
        component.set("v.showSpinner", false);
    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getprodNamelst = response.getReturnValue();
                console.log(":getprodName " + JSON.stringify(getprodNamelst));
                component.set("v.prodName",getprodNamelst[0].Product_Name__c);
                
            }else {
                console.log("Failed with state: " + JSON.stringify(getprodNamelst));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
});