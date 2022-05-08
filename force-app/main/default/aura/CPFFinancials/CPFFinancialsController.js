({
    doInit: function (component, event, helper) {
        helper.getAppPrdctCpfRec(component, event, helper);
        //helper.getAppFinancialrec(component, event, helper);
        helper.getContractClauseData(component, event);
    },

    showHiddenFields: function (component, event, helper) {
        var amendmentVal = component.find("amendment").get("v.value");

        console.log("amendmentVal " + amendmentVal);

        if (amendmentVal == "Copies of its audited financial statements") {
            component.set("v.showCIFField", true);
            component.set("v.showCIFField1", false);
            component.set("v.showCIFField2", false);
        } else if (amendmentVal == "Copies of its unaudited  management accounts") {
            component.set("v.showCIFField1", true);
            component.set("v.showCIFField", false);
            component.set("v.showCIFField2", false);
        } else if (amendmentVal == "Other financial information required") {
            component.set("v.showCIFField2", true);
            component.set("v.showCIFField1", false);
            component.set("v.showCIFField", false);
        }
        // if(amendmentVal == "copies of its unaudited management accounts" ){
        //   component.set("v.showCIFField1",true);
        // }
        else if (amendmentVal == "") {
            component.set("v.showCIFField2", false);
            component.set("v.showCIFField1", false);
            component.set("v.showCIFField", false);
        }
    },

    addNewLeaseRecord: function (component, event, helper) {
        helper.addNewLeaseRecord(component, event);
    },

    addNewOtherLeaseRecord: function (component, event, helper) {
        helper.addNewOtherLeaseRecord(component, event);
    },

    Addentityandsubsidary: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.Addentityandsubsidary(component, event);
    },

    Addentityfinstmt: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.Addentityfinstmt(component, event);
    },

    handleFinancialStatementSubmit: function (component, event, helper) {
        var isValid = true;
        var theBankReserveRightTo = component.get("v.theBankReserveRightTo");
        var alreadyHeld = component.get("v.alreadyHeld");
        var fstatement = component.get("v.fstatement");
        if (
            theBankReserveRightTo != "" &&
            theBankReserveRightTo != null &&
            theBankReserveRightTo != undefined &&
            alreadyHeld != "" &&
            alreadyHeld != null &&
            alreadyHeld != undefined &&
            fstatement != "" &&
            fstatement != null &&
            fstatement != undefined
        ) {
            if (fstatement == "Financial statements of the Borrower") {
                var finStmtBorrow = component.get("v.finStmtBorrow");
                var Includingfinstatement = component.get("v.Includingfinstatement");
                if (
                    finStmtBorrow != "" &&
                    finStmtBorrow != null &&
                    finStmtBorrow != undefined &&
                    Includingfinstatement != "" &&
                    Includingfinstatement != null &&
                    Includingfinstatement != undefined
                ) {
                    if (Includingfinstatement == "Yes") {
                        var finStmtGurator = component.get("v.finStmtGurator");
                        if (finStmtGurator != "" && finStmtGurator != null && finStmtGurator != undefined) {
                        } else {
                            isValid = false;
                        }
                    } else if (Includingfinstatement == "No") {
                    } else {
                        isValid = false;
                    }
                } else {
                    isValid = false;
                }
            } else if (fstatement == "Consolidated financial statements of the Parent and each of its Subsidiaries") {
                var finConsolaated = component.get("v.finConsolaated");
                if (finConsolaated == undefined || finConsolaated == "" || finConsolaated == null) {
                    isValid = false;
                }
            } else if (fstatement == "Consolidated financial statements of other entitles and each of its Subsidiaries") {
                var newFinChild = component.get("v.newFinChild");
                if (newFinChild != null && newFinChild != undefined) {
                    for (var i in newFinChild) {
                        if (
                            newFinChild[i].Entity_Name__c == null ||
                            newFinChild[i].Entity_Name__c == "" ||
                            newFinChild[i].Entity_Name__c == undefined ||
                            newFinChild[i].Registration_number__c == null ||
                            newFinChild[i].Registration_number__c == "" ||
                            newFinChild[i].Registration_number__c == undefined ||
                            newFinChild[i].Date__c == null ||
                            newFinChild[i].Date__c == "" ||
                            newFinChild[i].Date__c == undefined
                        ) {
                            isValid = false;
                            break;
                        }
                    }
                }
            } else if (fstatement == "other entity") {
                var newFinStmtChild = component.get("v.newFinStmtChild");
                if (newFinStmtChild != null && newFinStmtChild != undefined) {
                    for (var i in newFinStmtChild) {
                        if (
                            newFinStmtChild[i].Entity_Name__c == null ||
                            newFinStmtChild[i].Entity_Name__c == "" ||
                            newFinStmtChild[i].Entity_Name__c == undefined ||
                            newFinStmtChild[i].Registration_number__c == null ||
                            newFinStmtChild[i].Registration_number__c == "" ||
                            newFinStmtChild[i].Registration_number__c == undefined ||
                            newFinStmtChild[i].Date__c == null ||
                            newFinStmtChild[i].Date__c == "" ||
                            newFinStmtChild[i].Date__c == undefined
                        ) {
                            isValid = false;
                            break;
                        }
                    }
                }
            }
        } else {
            isValid = false;
        }
        //alert(isValid);
        if (!isValid) {
            var toast = helper.getToast("Error!", "Please fill all required fields indicated with a red asterisk (*)", "Error");
            toast.fire();
            return;
        }

        component.set("v.showSpinner", true);
        helper.InsertFinancialStatementCpf(component, event, helper);
    },

    handleFinancialChildEvent: function (component, event, helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex = event.getParam("UnlimitedRowIndex");
        var unlimitedChildlist = component.get("v.newFinChild");
        unlimitedChildlist.splice(unlimitedrowinex, 1);
        component.set("v.newFinChild", unlimitedChildlist);
    },

    handleFinancialStmtEvent: function (component, event, helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex = event.getParam("UnlimitedRowIndex");
        var unlimitedloanlist = component.get("v.newFinStmtChild");
        unlimitedloanlist.splice(unlimitedrowinex, 1);
        component.set("v.newFinStmtChild", unlimitedloanlist);
    },
    handleFinancialEvent: function (component, event, helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex = event.getParam("UnlimitedRowIndex");
        var unlimitedloanlist = component.get("v.lease");
        unlimitedloanlist.splice(unlimitedrowinex, 1);
        component.set("v.lease", unlimitedloanlist);
    },
    //Financial Insert
    handleInsert: function (component, event, helper) {
        helper.updateAppPrdctcpffinancial(component, event, helper);
    },

    handleLeaseSave: function (component, event, helper) {
        component.set("v.showSpinner", true);

        var leaseRecordList = component.get("v.leaseRecordList");
        var isError = false;

        for (var i = 0; i < leaseRecordList.length; i++) {
            var leaseRecord = leaseRecordList[i];
            if (
                !leaseRecord.Tenant_Name__c || 
                !leaseRecord.Lease_Area__c ||
                !leaseRecord.Tenant_until_Date__c ||
                !leaseRecord.Tenant_from_Date__c ||
                !leaseRecord.Tenant_Escalations__c ||
                !leaseRecord.Rent_per_Month__c ||
                !leaseRecord.Rent_Type__c
            ) {
                isError = true;
            }
        }
        if (isError == true) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "error!",
                type: "Error",
                message: "Please complete all required fields"
            });
            toastEvent.fire();
        } else {
            helper.saveLeaseRecords(component, event, helper, 'Lease');
        }
    },

    handleOtherLeaseSave: function (component, event, helper) {
        component.set("v.showSpinner", true);

        var otherLeaseRecordList = component.get("v.otherLeaseRecordList");
        var isError = false;

        for (var i = 0; i < otherLeaseRecordList.length; i++) {
            var leaseRecord = otherLeaseRecordList[i];
            if (!leaseRecord.Other_Lease__c) {
                isError = true;
            }
        }

        if (isError == true) {
            component.set("v.showSpinner", false);

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "error!",
                type: "Error",
                message: "Please complete all required fields"
            });
            toastEvent.fire();
        } else {
            helper.saveLeaseRecords(component, event, helper, 'Other Lease');
        }
    },

    addOtherLease: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddOtherLease(component, event);
    },

    addLease: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.AddLease(component, event);
    }
});