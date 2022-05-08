({
    AddTranConv : function(component, event) {
        var TransactionalConvenants = component.get("v.newOtherTrans");
        TransactionalConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Description__c' : ''
            
        });
        component.set("v.newOtherTrans",TransactionalConvenants);   
        component.set("v.showSpinner", false);
    },
    AddCopConv: function(component, event) {
        var CopConvenants = component.get("v.newOtherCoperate");
        CopConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Description__c' : ''
            
        });
        component.set("v.newOtherCoperate",CopConvenants);   
        component.set("v.showSpinner", false);
    },
    addLoanValue : function(component, event) {
        var loanvalueConvenants = component.get("v.newLoanValue");
        loanvalueConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Description__c' : ''
            
        });
        component.set("v.newLoanValue",loanvalueConvenants);
        //alert('line 20'+component.get("v.newLoanValue"))
        component.set("v.showSpinner", false);
    },
    addDebitService : function(component, event) {
        var debitserviceConvenants = component.get("v.newDebitCoverList");
        debitserviceConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Description__c' : ''
            
        });
        component.set("v.newDebitCoverList",debitserviceConvenants);   
        component.set("v.showSpinner", false);
    },
     addInterestService : function(component, event) {
        var interestserviceConvenants = component.get("v.newInterestCoverList");
        interestserviceConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Description__c' : ''
            
        });
        component.set("v.newInterestCoverList",interestserviceConvenants);   
        component.set("v.showSpinner", false);
    },
    AddOtherentityCVT : function(component, event) {
        var OtherentityConvenants = component.get("v.newOtherEntityList");
        OtherentityConvenants.push({
            'sobjectType' : 'Application_Contract_Clause__c',
            'Description__c' : ''
            
        });
        component.set("v.newOtherEntityList",OtherentityConvenants);   
        component.set("v.showSpinner", false);
    },
    removeNewUnlimitedtrnas: function (component) {
        component.getEvent("CPFCovenents").setParams({
            "RowIndex" : component.get("v.rowindex")
        }).fire();
    },
    
    InsertOtherTransCpf : function(component, event, helper) {
        var action = component.get("c.insertOtherTransactions");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "OtherTransList" : component.get("v.newOtherTrans"),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedOtherTransRec = response.getReturnValue();
                console.log('UnlimitedOtherTransRec---'+JSON.stringify(UnlimitedOtherTransRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Other Transactional convenants CPF record updated Successfully"
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
        });
        $A.enqueueAction(action);
        
    },
    
    InsertOtherCoperateCpf : function(component, event, helper) {
        var action = component.get("c.insertOtherCorporateCovenants");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "OtherCoperateList" : component.get("v.newOtherCoperate"),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedOtherTransRec = response.getReturnValue();
                console.log('UnlimitedOtherTransRec---'+JSON.stringify(UnlimitedOtherTransRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Other Corporate convenants CPF record updated Successfully"
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
        });
        $A.enqueueAction(action);
        
    },
    
    InsertLoanValueCpf: function(component, event, helper,indebtedness,loanToValueCovenant,propertyValueNTE,period) {
        console.log('newLoanValue=='+JSON.stringify(component.get("v.newLoanValue")));
        //alert('line 92'+component.get("v.newLoanValue"));
        var action = component.get("c.insertOtherLoanValue");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "OtherLoanList" : component.get("v.newLoanValue"),
            "indebtedness":indebtedness,
            "loanToValueCovenant":loanToValueCovenant,
            "propertyValueNTE":propertyValueNTE,
            "period":period
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedLoanValueRec = response.getReturnValue();
                //alert('line 107'+UnlimitedLoanValueRec)
                console.log('UnlimitedLoanValueRec---'+JSON.stringify(UnlimitedLoanValueRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Other Loan & Value CPF record updated Successfully"
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
    InsertVacancyCoverRatio: function(component, event, helper,vacancyCoverRatio) {
        
        
        //alert('line 92'+component.get("v.newLoanValue"));
        var action = component.get("c.insertVacancyCoverValue");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "vacancyCoverRatio":vacancyCoverRatio
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedLoanValueRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Other Loan & Value CPF record updated Successfully"
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
    Insertloantocost: function(component, event, helper) {
        var loantocost;
        if(component.find("loantocost") == undefined){
            loantocost=null;
        }else{
            loantocost = component.find("loantocost").get("v.value");
        }

        var action = component.get("c.insertloantocostvalue");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "loantocostpicklist":component.get("v.loantocostpicklist"),
            "loantocost":loantocost
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var loantocostValueRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Loan to Cost Value CPF record updated Successfully"
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
        });
        $A.enqueueAction(action);
    },
    InsertDebitCoverCpf: function(component, event, helper) {
        
        console.log('newDebitCoverList=='+JSON.stringify(component.get("v.newDebitCoverList")));
        //alert('line 92'+component.get("v.newDebitCoverList"));
        var debtServiceCoverRatio = component.get("v.debtServiceCoverRatio");
        var debtservicecvrration = component.get("v.debtservicecvrration");
        var action = component.get("c.insertDebitCoverList");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "DebitCoverList" : component.get("v.newDebitCoverList"),
            "debtServiceCoverRatio":debtServiceCoverRatio,
            "debtservicecvrration":debtservicecvrration
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedLoanValueRec = response.getReturnValue();
                //alert('line 107'+UnlimitedLoanValueRec)
                console.log('UnlimitedLoanValueRec---'+JSON.stringify(UnlimitedLoanValueRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Debit Service Cover CPF record updated Successfully"
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
    InsertInterestCoverCpf: function(component, event, helper) {
        
        console.log('newInterestCoverList=='+JSON.stringify(component.get("v.newInterestCoverList")));
        var interestServiceCoverRatio = component.get("v.interestServiceCoverRatio");
        var interestervicecvrration = component.get("v.interestervicecvrration");
        var action = component.get("c.insertInterestCoverList");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "InterestCoverList" : component.get("v.newInterestCoverList"),
            "interestServiceCoverRatio":interestServiceCoverRatio,
            "interestervicecvrration":interestervicecvrration
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var InterestcoverValueRec = response.getReturnValue();
                console.log('InterestcoverValueRec---'+JSON.stringify(InterestcoverValueRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Interest Service Cover CPF record updated Successfully"
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
    InsertOtherEntityCpf: function(component, event, helper) {
        
        var applicableToTheBorrower = component.get("v.applicableToTheBorrower");
        var applicable_to_the_Parent = component.get("v.applicable_to_the_Parent");
        var applicable_to_the_Guarantor = component.get("v.applicable_to_the_Guarantor");
        var applicable_to_the_Security_Pro = component.get("v.applicable_to_the_Security_Pro");
        var otherentity = component.get("v.otherentity");
        
        console.log('newOtherEntityList=='+JSON.stringify(component.get("v.newOtherEntityList")));
        //alert('line 92'+component.get("v.newOtherEntityList"));
        var action = component.get("c.insertOtherEntityList");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "OtherEntityList" : component.get("v.newOtherEntityList"),
            "applicableToTheBorrower":applicableToTheBorrower,
            "applicable_to_the_Parent":applicable_to_the_Parent,
            "applicable_to_the_Guarantor":applicable_to_the_Guarantor,
            "applicable_to_the_Security_Pro":applicable_to_the_Security_Pro,
            "otherentity":otherentity
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedLoanValueRec = response.getReturnValue();
                //alert('line 107'+UnlimitedLoanValueRec)
                console.log('UnlimitedLoanValueRec---'+JSON.stringify(UnlimitedLoanValueRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Other Entity CPF record updated Successfully"
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
    updateFCG : function(component, event, helper,financialYear,measurementPeriod,consecutivePeriod,financialCovRef,transactionalConvenantApplicable,financialConvenantApplicable) {
        var action = component.get("c.insertFgc");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "measurementPeriod":measurementPeriod,
            "financialYear":financialYear,
            "consecutivePeriod":consecutivePeriod,
            "financialCovRef":financialCovRef,
            "transactionalConvenantApplicable":transactionalConvenantApplicable,
            "financialConvenantApplicable":financialConvenantApplicable,
            
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('inside');
            if (state === "SUCCESS"){
                var UnlimitedLoanValueRec = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Financial covenants applicable Convenant Record updated Successfully"
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
    
    getAppContractClausedata :function(component, event, helper) {
        var action = component.get("c.getApplicationConClause");
        var oppRecId=component.get("v.recordId");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Other Transactional Covenants'
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS"){
                var appContClauseRecTrans = response.getReturnValue();
                component.set("v.newOtherTrans",appContClauseRecTrans);
            }else {
                var errors = response.getError();
                console.log(' ERROR 334'+JSON.stringify(errors));
            }
        });
        
        $A.enqueueAction(action);
    }, 
        getAppContractClausedatacoperate :function(component, event, helper) {
        var action = component.get("c.getApplicationConClause");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
            "type":'Other Corporate Covenants'

        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS"){
                var appContClauseReccoperate = response.getReturnValue();
                component.set("v.newOtherCoperate",appContClauseReccoperate);
            }else {
                var errors = response.getError();
                console.log(' ERROR 334'+JSON.stringify(errors));
            }
        });
        
        $A.enqueueAction(action);
    }, 
    getLoanToValueCovenant :function(component, event, helper) {
        
        var action = component.get("c.getLoanConData");
        var oppRecId=component.get("v.recordId");
        
        action.setParams({
            "oppId": component.get("v.recordId"),  
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appContClauseRec = response.getReturnValue();
                //alert(": appContClauseRec   " + JSON.stringify(appContClauseRec));
                component.set("v.newLoanValue",appContClauseRec.LoanData);
                component.set("v.Indebtedness",appContClauseRec.Indebtedness);
                component.set("v.loanToValueCovenant",appContClauseRec.loanToValueCovenant);
                component.set("v.propertyValueNTE",appContClauseRec.propertyValueNTE);
                component.set("v.period",appContClauseRec.period);
                component.set("v.vacancyCoverRatio",appContClauseRec.vacancyCoverRatio);
                component.set("v.debtServiceCoverRatio",appContClauseRec.appPrdctCpf.Debt_service_cover_ratio2__c);
                component.set("v.interestServiceCoverRatio",appContClauseRec.appPrdctCpf.Interest_Service_Cover_Ratio__c);
                if(appContClauseRec.appPrdctCpf != undefined && appContClauseRec.appPrdctCpf != ''){
                    if(appContClauseRec.appPrdctCpf.Debt_service_cover_ratio__c != undefined && appContClauseRec.appPrdctCpf.Debt_service_cover_ratio__c !=''){
                        component.set("v.debtservicecvrration",appContClauseRec.appPrdctCpf.Debt_service_cover_ratio__c);
                    }
                    if(appContClauseRec.appPrdctCpf.Interest_Cover_Ratio__c != undefined && appContClauseRec.appPrdctCpf.Interest_Cover_Ratio__c !=''){
                        component.set("v.interestervicecvrration",appContClauseRec.appPrdctCpf.Interest_Cover_Ratio__c);
                    }
                }
                component.set("v.measurementPeriod",appContClauseRec.measurementPeriod);
                component.set("v.financialYear",appContClauseRec.financialYear);
                component.set("v.consecutivePeriod",appContClauseRec.consecutivePeriod);
                component.set("v.financialCovRef",appContClauseRec.financialCovRef);
                if(appContClauseRec.appPrdctCpf != undefined && appContClauseRec.appPrdctCpf != ''){
                    if(appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Borrower__c != undefined && appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Borrower__c !=''){
                        component.set("v.applicableToTheBorrower",appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Borrower__c);
                    }
                    if(appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Parent__c != undefined && appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Parent__c != ''){
                        component.set("v.applicable_to_the_Parent",appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Parent__c);
                    }
                    if(appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c != undefined && appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c != ''){
                        component.set("v.applicable_to_the_Guarantor",appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Guarantor_s__c);
                    }
                    if(appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c != undefined && appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c !=''){
                        component.set("v.applicable_to_the_Security_Pro",appContClauseRec.appPrdctCpf.Covenants_applicable_to_the_Security_Pro__c);
                    }
                    if(appContClauseRec.appPrdctCpf.Transactional_covenants_applicable__c != undefined && appContClauseRec.appPrdctCpf.Transactional_covenants_applicable__c != ''){
                        component.set("v.transactionalConvenantApplicable",appContClauseRec.appPrdctCpf.Transactional_covenants_applicable__c);
                    }
                    if(appContClauseRec.appPrdctCpf.Financial_covenants_applicable__c != undefined && appContClauseRec.appPrdctCpf.Financial_covenants_applicable__c !=''){
                        component.set("v.financialConvenantApplicable",appContClauseRec.appPrdctCpf.Financial_covenants_applicable__c);
                    }
                    if(appContClauseRec.appPrdctCpf.Other_Entity__c != undefined && appContClauseRec.appPrdctCpf.Other_Entity__c != ''){
                        component.set("v.otherentity",appContClauseRec.appPrdctCpf.Other_Entity__c);
                    }
                }
                component.set("v.newDebitCoverList",appContClauseRec.DebitClaseList);
                component.set("v.newInterestCoverList",appContClauseRec.InterestCoverList);
                component.set("v.newOtherEntityList",appContClauseRec.OtherEntityClauseList);
                
                
            }else {
                var errors = response.getError();
                console.log(' ERROR '+JSON.stringify(errors));
            }
        });
        
        $A.enqueueAction(action);
    },
    //Function to show toast for Errors/Warning/Success
    getToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
    },
    
    //Function to show spinner when loading
    showSpinner: function(component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function(component) {
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
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
    getAppProdRec :function(component, event, helper) {
        var action = component.get("c.getApplicationProductCPF");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getappProdRec = response.getReturnValue();
                console.log(":getappProdRec " + JSON.stringify(getappProdRec));
                component.set("v.appProdId",getappProdRec.Id);
                if(getappProdRec.Corporate_covenants_applicable__c!='' && getappProdRec.Corporate_covenants_applicable__c!= undefined){
                    component.set("v.carporateConvenantApplicable",getappProdRec.Corporate_covenants_applicable__c);} 
                if(getappProdRec.Loan_To_Cost_Picklist__c!='' && getappProdRec.Loan_To_Cost_Picklist__c!= undefined){
                    component.set("v.loantocostpicklist",getappProdRec.Loan_To_Cost_Picklist__c); }
                    if(getappProdRec.Loan_To_Cost__c!='' && getappProdRec.Loan_To_Cost__c!= undefined){
                        component.set("v.loantocost",getappProdRec.Loan_To_Cost__c); }
    
                
            }else {
                console.log("Failed with state: " + JSON.stringify(getappProdRec));
            }
        });
        
        $A.enqueueAction(action);
    },
    UpdateAppProdDetails:function(component, event, helper) {
        var corporateintrest ,gearingratio,assestType,leverageratio,cashflowcover,dividendcover,
            miniNTAType,miniNTARatio;
        if(component.find("corporateintrest") == undefined){
            corporateintrest=null;
        }else{
            corporateintrest = component.find("corporateintrest").get("v.value");
        }
        if(component.find("gearingratio") == undefined){
            gearingratio=null;
        }else{
            gearingratio = component.find("gearingratio").get("v.value");
        }
        if(component.find("assestType") == undefined){
            assestType=null;
        }else{
            assestType = component.find("assestType").get("v.value");
        }
        if(component.find("leverageratio") == undefined){
            leverageratio=null;
        }else{
            leverageratio = component.find("leverageratio").get("v.value");
        }
        if(component.find("cashflowcover") == undefined){
            cashflowcover=null;
        }else{
            cashflowcover = component.find("cashflowcover").get("v.value");
        }
        if(component.find("dividendcover") == undefined){
            dividendcover=null;
        }else{
            dividendcover = component.find("dividendcover").get("v.value");
        }
        if(component.find("miniNTAType") == undefined){
            miniNTAType=null;
        }else{
            miniNTAType = component.find("miniNTAType").get("v.value");
        }
        if(component.find("miniNTARatio") == undefined){
            miniNTARatio=null;
        }else{
            miniNTARatio = component.find("miniNTARatio").get("v.value");
        }
        var carporateConvenantApplicable= component.get("v.carporateConvenantApplicable");
        var action = component.get("c.updateAppProdDetails");
        action.setParams({
            "oppId": component.get("v.recordId"),
            "corporateintrest":corporateintrest,
            "gearingratio":gearingratio,
            "assestType":assestType,
            "leverageratio":leverageratio,
            "cashflowcover":cashflowcover,
            "dividendcover":dividendcover,
            "miniNTAType":miniNTAType,
            "miniNTARatio":miniNTARatio,
            "carporateConvenantApplicable":carporateConvenantApplicable
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Corporate covenants applicable Convenant Record updated Successfully"
                });
                toastEvent.fire();
                
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    
})