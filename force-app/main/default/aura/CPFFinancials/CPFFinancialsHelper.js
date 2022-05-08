({
    //Function to show toast for Errors/Warning/Success
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
    },
    
    //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("spinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    getAppPrdctCpfRec: function (component, event, helper) {
        
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            oppId: component.get("v.recordId")
        });
        
        action.setCallback(this, function (response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var appPrdctCpfRec = response.getReturnValue();
                // alert()
                component.set("v.appPrdctCpfRec", appPrdctCpfRec);
                if(appPrdctCpfRec.Lease_options__c!=null && appPrdctCpfRec.Lease_options__c!='')
                component.set("v.leaseOptionsValue", appPrdctCpfRec.Lease_options__c);
                if(appPrdctCpfRec.Other_Leases__c!=null && appPrdctCpfRec.Other_Leases__c!='')
                component.set("v.otherLeasesValue", appPrdctCpfRec.Other_Leases__c);
                if(appPrdctCpfRec.Unaudited_interim_statements_required__c!=null && appPrdctCpfRec.Unaudited_interim_statements_required__c!=''){
                    component.set("v.Unauditedinterimstmtreq",appPrdctCpfRec.Unaudited_interim_statements_required__c);}
                if(appPrdctCpfRec.Parent_to_provide_the_bank_with_financia__c!=null && appPrdctCpfRec.Parent_to_provide_the_bank_with_financia__c!=''){
                    component.set("v.Parenttoprovidethebankwithfinancia",appPrdctCpfRec.Parent_to_provide_the_bank_with_financia__c);}
                if(appPrdctCpfRec.Guarantor_s_to_provide_the_bank_with_fi__c!=null && appPrdctCpfRec.Guarantor_s_to_provide_the_bank_with_fi__c!=''){
                    component.set("v.GuarantortoprovideBankfinancialinfo",appPrdctCpfRec.Guarantor_s_to_provide_the_bank_with_fi__c);}
                if(appPrdctCpfRec.Borrower_has_subsidiaries__c!=null && appPrdctCpfRec.Borrower_has_subsidiaries__c!=''){
                    component.set("v.Borrowerhassubsidiaries",appPrdctCpfRec.Borrower_has_subsidiaries__c);}
                if(appPrdctCpfRec.Guarantor_s_has_have_subsidiaries__c!=null && appPrdctCpfRec.Guarantor_s_has_have_subsidiaries__c!=''){
                    component.set("v.Guarantorshashavesubsidiaries",appPrdctCpfRec.Guarantor_s_has_have_subsidiaries__c);}
                if (appPrdctCpfRec.Financial_information_required__c == "Copies of its audited financial statements") {
                    component.set("v.showCIFField", true);
                    component.set("v.showCIFField1", false);
                    component.set("v.showCIFField2", false);
                } else if (appPrdctCpfRec.Financial_information_required__c == "Copies of its unaudited  management accounts") {
                    component.set("v.showCIFField1", true);
                    component.set("v.showCIFField", false);
                    component.set("v.showCIFField2", false);
                } else if (appPrdctCpfRec.Financial_information_required__c == "Other financial information required") {
                    component.set("v.showCIFField2", true);
                    component.set("v.showCIFField1", false);
                    component.set("v.showCIFField", false);
                }
                
                helper.getAppLease(component, event);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    updateAppPrdctcpf: function (component, event, helper) {
        var action = component.get("c.updateAppPrdctcpf");
        action.setParams({
            recId: component.get("v.appPrdctCpfRec.Id"),
            amendmentClause: component.find("amendment").get("v.value"),
            chargingDate: component.find("cDate").get("v.value"),
            uThreshold: component.find("threshold").get("v.value"),
            withdrawal: component.find("withdrawal").get("v.value"),
            ownerOccupied: component.find("ownerOccupied").get("v.value"),
            equityContributions: component.find("equity").get("v.value"),
            equityContributionsAmt: component.find("eContAmt").get("v.value"),
            otherEquity: component.find("OtherEqContribution").get("v.value"),
            bUnderCPA: component.find("underCPA").get("v.value"),
            uThreshold: component.find("threshold").get("v.value"),
            thresholdAmount: component.find("tAmount").get("v.value"),
            tPeriods: component.find("thresholdPeriods").get("v.value"),
            cdThresholdAmt: component.find("crossDefaultThresholdAmt").get("v.value"),
            aFinanceDocsRequired: component.find("additionalDoc").get("v.value"),
            aFinanceDocsRequiredDocs: component.find("additionalReqDoc").get("v.value"),
            
            fLoanOptions: component.find("furtherLoanOptions").get("v.value"),
            litThreshloldAmt: component.find("litAmt").get("v.value"),
            fPurpose: component.find("fPurpose").get("v.value"),
            pApprovedByCred: component.find("purpAsApprovedByCred").get("v.value"),
            pDescription: component.find("propDescription").get("v.value")
        });
        //  console.log("Under CPA :"+JSON.Stringyfy(component.find("underCPA").get("v.value")));
        // Add callback behavior for when response is received
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var oppRec = response.getReturnValue();
                console.log("Opprec =" + JSON.stringify(oppRec));
                console.log("oppRec---" + JSON.stringify(oppRec.Application_Product_CPF__c));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "Application Product CPF record updated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    fetchAccHelper: function (component, event, helper) {
        component.set("v.mycolumns", [{ label: "Portfolio Name", fieldName: "Portfolio_description__c", type: "text" }]);
        var action = component.get("c.fetchApplicationPortfolio");
        action.setParams({});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.acctList", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    /*  updatePropPortfolioData : function(component , event , helper){
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

    },*/
    /* addPortfolio : function(component, event) {
        var facacountlist = component.get("v.newFacilityAccount");
        facacountlist.push({
            'sobjectType' : 'Application_Portfolio__c',
            'Portfolio_number__c' : '',
            'Portfolio_Description__c' : ''

        });
        component.set("v.newFacilityAccount",facacountlist);
        component.set("v.showSpinner", false);
    },*/
    
    addNewLeaseRecord: function (component, event) {
        var leaseRecordList = component.get("v.leaseRecordList");
        leaseRecordList.push({
            sObjectType: "Application_Lease_CPF__c",
            Type__c: "Lease",
            Application_Product_CPF__c: component.get("v.appPrdctCpfRec.Id"),
            Rent_Type__c: "Gross"
        });
        component.set("v.leaseRecordList", leaseRecordList);
    },
    
    addNewOtherLeaseRecord: function (component, event) {
        var otherLeaseRecordList = component.get("v.otherLeaseRecordList");
        otherLeaseRecordList.push({
            sObjectType: "Application_Lease_CPF__c",
            Type__c: "Other Lease",
            Application_Product_CPF__c: component.get("v.appPrdctCpfRec.Id")
        });
        component.set("v.otherLeaseRecordList", otherLeaseRecordList);
    },
    
    Addentityandsubsidary: function (component, event) {
        var subsidaryfinancials = component.get("v.newFinChild");
        subsidaryfinancials.push({
            sobjectType: "Application_Contract_Clause__c",
            Description__c: ""
        });
        component.set("v.newFinChild", subsidaryfinancials);
        component.set("v.showSpinner", false);
    },
    Addentityfinstmt: function (component, event) {
        var subsidaryfinancialsstmt = component.get("v.newFinStmtChild");
        subsidaryfinancialsstmt.push({
            sobjectType: "Application_Contract_Clause__c",
            Description__c: ""
        });
        component.set("v.newFinStmtChild", subsidaryfinancialsstmt);
        component.set("v.showSpinner", false);
    },
    
    // W-008364 - Anka Ganta
    InsertFinancialStatementCpf: function (component, event, helper) {
        var theBankReserveRightTo = component.get("v.theBankReserveRightTo");
        var alreadyHeld = component.get("v.alreadyHeld");
        var fstatement = component.get("v.fstatement");
        var finStmtBorrow = component.get("v.finStmtBorrow");
        var Includingfinstatement = component.get("v.Includingfinstatement");
        var finStmtGurator = component.get("v.finStmtGurator");
        var finConsolaated = component.get("v.finConsolaated");
        //alert('newFinChild'+component.get("v.newFinChild"));
        var otherEntitySubsidoriesList = component.get("v.newFinChild");
        var otherEntitiesList = component.get("v.newFinStmtChild");
        //alert('otherEntitiesList--'+otherEntitiesList);
        //alert('otherEntitySubsidoriesList--'+otherEntitySubsidoriesList);
        var FinancialStatementListVar;
        var otherEntitySubsidoriesListVar;
        var otherEntitiesListVar;
        if (!$A.util.isUndefinedOrNull(otherEntitySubsidoriesList) || otherEntitySubsidoriesList != "") {
            otherEntitySubsidoriesListVar = otherEntitySubsidoriesList;
        } else {
            otherEntitySubsidoriesListVar = null;
        }
        if (!$A.util.isUndefinedOrNull(otherEntitiesList) || otherEntitiesList != "") {
            otherEntitiesListVar = otherEntitiesList;
        } else {
            otherEntitiesListVar = null;
        }
        //alert('otherEntitySubsidoriesListVar--'+otherEntitySubsidoriesListVar);
        //alert('otherEntitiesListVar--'+otherEntitiesListVar);
        var action = component.get("c.insertFinancialStatement");
        action.setParams({
            recId: component.get("v.recordId"),
            otherEntitySubsidoriesList: otherEntitySubsidoriesListVar,
            otherEntitiesList: otherEntitiesListVar,
            theBankReserveRightTo: theBankReserveRightTo,
            alreadyHeld: alreadyHeld,
            fstatement: fstatement,
            finStmtBorrow: finStmtBorrow,
            Includingfinstatement: Includingfinstatement,
            finStmtGurator: finStmtGurator,
            finConsolaated: finConsolaated
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var UnlimitedLoanValueRec = response.getReturnValue();
                // alert('line 107'+UnlimitedLoanValueRec)
                console.log("UnlimitedLoanValueRec---" + JSON.stringify(UnlimitedLoanValueRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "Original/Certified Copies of Financial Statements record updated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    // W-008364 - Anka Ganta
    getContractClauseData: function (component, event, helper) {
        var action = component.get("c.getContractClauseData");
        var oppRecId = component.get("v.recordId");
        
        action.setParams({
            oppId: component.get("v.recordId")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                var appContClauseRec = response.getReturnValue();
                //alert(": appContClauseRec   " + JSON.stringify(appContClauseRec));
                if(appContClauseRec.theBankReserveRightTo!=null && appContClauseRec.theBankReserveRightTo!='')
                component.set("v.theBankReserveRightTo", appContClauseRec.theBankReserveRightTo);
                if(appContClauseRec.alreadyHeld!=null && appContClauseRec.alreadyHeld!='')
                component.set("v.alreadyHeld", appContClauseRec.alreadyHeld);
                component.set("v.fstatement", appContClauseRec.fstatement);
                component.set("v.finStmtBorrow", appContClauseRec.finStmtBorrow);
                if(appContClauseRec.Includingfinstatement!=null && appContClauseRec.Includingfinstatement!='')
                component.set("v.Includingfinstatement", appContClauseRec.Includingfinstatement);
                component.set("v.finStmtGurator", appContClauseRec.finStmtGurator);
                component.set("v.finConsolaated", appContClauseRec.finConsolaated);
                component.set("v.newFinChild", appContClauseRec.otherEntitiessubsideries); //FinancialData
                component.set("v.newFinStmtChild", appContClauseRec.otherentites); //FinancialData
            } else {
                var errors = response.getError();
                console.log(" ERROR " + JSON.stringify(errors));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    saveLeaseRecords: function (component, event, helper, type) {
        var leaseOptionsValue = component.get("v.leaseOptionsValue");
        var otherLeasesValue = component.get("v.otherLeasesValue");
        var action = component.get("c.synchronizeLeaseRecords");
        var leaseRecordList;
        
        if (type == "Lease") {
            leaseRecordList = component.get("v.leaseRecordList");
        } else if (type == "Other Lease") {
            leaseRecordList = component.get("v.otherLeaseRecordList");
        }
        
        action.setParams({
            leaseRecordList: leaseRecordList,
            deletedLeaseRecordList: component.get("v.deletedLeaseRecordList"),
            appProductCPFId: component.get("v.appPrdctCpfRec.Id"),
            leaseOptionsValue: leaseOptionsValue,
            otherLeasesValue: otherLeasesValue
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.deletedLeaseRecordList", []);
                helper.getAppLease(component, event);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "Lease CPF records saved successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Error!",
                            type: "error",
                            message: "Error message: " + errors[0].message
                        });
                        toastEvent.fire();
                    }
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error!",
                        type: "error",
                        message: "Unknown error"
                    });
                    toastEvent.fire();
                }
                component.set("v.showSpinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getAppLease: function (component, event, helper) {
        var action = component.get("c.getLease");
        
        action.setParams({
            appProductCPFId: component.get("v.appPrdctCpfRec.Id")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                var leaseRecordList = [];
                var otherLeaseRecordList = [];
                
                for (var i = 0; i < resp.length; i++) {
                    var leaseRecord = resp[i];
                    if (leaseRecord.Type__c == "Lease") {
                        leaseRecordList.push(leaseRecord);
                    }
                    if (leaseRecord.Type__c == "Other Lease") {
                        otherLeaseRecordList.push(leaseRecord);
                    }
                }
                component.set("v.leaseRecordList", leaseRecordList);
                component.set("v.otherLeaseRecordList", otherLeaseRecordList);
            } else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
    
    
    updateAppPrdctcpffinancial: function (component, event, helper) {
        var action = component.get("c.addParentAccount");
        var appPrdctCpfRec=component.get("v.appPrdctCpfRec");
        console.log("ApplicationProductCPF " + JSON.stringify(appPrdctCpfRec.Id));
        
        var amendment,Financialstmtavailablenolater,available,Otherfinancialinformation,Period,unauditedinterimavailableval;
        
        
        if(component.find("amendment") == undefined){
            amendment=null;
        }else{
            amendment = component.find("amendment").get("v.value");
        }
        if(component.find("Financialstmtavailablenolater") == undefined){
            Financialstmtavailablenolater=null;
        }else{
            Financialstmtavailablenolater = component.find("Financialstmtavailablenolater").get("v.value");
        }
        if(component.find("available") == undefined){
            available=null;
        }else{
            available = component.find("available").get("v.value");
        }
        if(component.find("Otherfinancialinformation") == undefined){
            Otherfinancialinformation=null;
        }else{
            Otherfinancialinformation =component.find("Otherfinancialinformation").get("v.value");
        }
        if(component.find("Period") == undefined){
            Period=null;
        }else{
            Period =component.find("Period").get("v.value");
        }
        if(component.find("unauditedinterimavailable") == undefined){
            unauditedinterimavailableval=null;
        }else{
            unauditedinterimavailableval =component.find("unauditedinterimavailable").get("v.value");
        }
        
        action.setParams({
            "appPrdId": component.get("v.appPrdctCpfRec.Id"),
            "Parenttoprovidethebankwithfinancia":component.get("v.Parenttoprovidethebankwithfinancia"),
            "GuarantortoprovideBankfinancialinfo":component.get("v.GuarantortoprovideBankfinancialinfo"),
            "amendment":amendment,
            "Financialstmtavailablenolater":Financialstmtavailablenolater,
            "Borrowerhassubsidiaries":component.get("v.Borrowerhassubsidiaries"),
            "Guarantorshashavesubsidiaries":component.get("v.Guarantorshashavesubsidiaries"),
            "Unauditedinterimstmtreq":component.get("v.Unauditedinterimstmtreq"),
            "unauditedinterimavailablevalue" : unauditedinterimavailableval,
            "Period":Period,
            // "Borrowerhassub":component.get("v.Borrowerhassub"),
            //  "Guarantorhashavesub":component.get("v.Guarantorhashavesub"),
            "Includebalancesheetprofitlossacc":component.get("v.Includebalancesheetprofitlossacc"), 
            "available":available,
            "Otherfinancialinformation":Otherfinancialinformation,
            
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var oppRec = response.getReturnValue();
                console.log("AppRec =" + JSON.stringify(oppRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "Application Product CPF record updated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            // this.hideSpinner(component);
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }
});