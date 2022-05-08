({
    getPickListItems: function (component) {
        var action = component.get("c.getPickListItems");

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.pickListOptions", result);
            }
            else {
                this.showError(response, "getPickListItems");
            }
        });

        $A.enqueueAction(action);
    },

    setCrytoSettings: function (component) {
        var action = component.get("c.addCryptoKey");

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();
            }
            else {
                this.showError(response, "addCryptoKey");
            }
        });

        $A.enqueueAction(action);
    },

    getChequeAccounts: function (component) {
        component.set("v.showSpinner", true);
        this.setCrytoSettings(component);
        var oppId = component.get("v.recordId");
        var selectedValue = component.get("v.selectedTab");
        var action = component.get("c.getLinkedChequeAccounts");

        action.setParams({
            oppId: oppId,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                component.set("v.facilityAccounts", []);
                component.set("v.numberOfAccountsSelected", 0);

                if (result != null && result.length > 2) {
                    component.set("v.chequeAccData", JSON.parse(result));

                    component.set("v.isActiveAccountAvailable", false);
                    component.set("v.isActiveAccountSelection", true);
                    console.log("chequeAccData::: " + JSON.stringify(component.get("v.chequeAccData")));
                    this.setDefaultAccountSelection(component);
                }
            }
            else {
                if (selectedValue && selectedValue == "TabOne") { //adding a check to show errors on ChequeAndOD tab only
                    this.showError(response, "getLinkedChequeAccounts");
                }
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    getAndSaveClientConductDetails: function (component, conItems) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAndSaveClientConductDetails");

        action.setParams({
            oppId: oppId,
            objData: JSON.stringify(conItems),
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    var isSuccess = (result.Status.search("Successfully") > 0);
                    component.set("v.isActiveSelectedAccountDetails", isSuccess);

                    var toastEvent = this.getToast((isSuccess ? "Success!" : "Error!"), result.Status, (isSuccess ? "Success" : "Error"));
                    toastEvent.fire();
                }
                else {
                    this.showError(response, "getAndSaveClientConductDetails");
                }
            }
            else {
                this.showError(response, "getAndSaveClientConductDetails");
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    getNewChequeAndOverdraft: function (component) {
        component.set("v.showSpinner", true);
        var selectedValue = component.get("v.selectedTab");
        var oppId = component.get("v.recordId");
        var action = component.get("c.getChequeAndOverdraft");

        action.setParams({
            oppId: oppId,
            isCurrCheque: false,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    component.set("v.newChequeAccounts", JSON.parse(result));
                    console.log("newChequeAccounts::: " + JSON.stringify(component.get("v.newChequeAccounts")));
                }
            }
            else {
                if (selectedValue && selectedValue == "TabOne") {   //adding a check to show errors on ChequeAndOD tab only
                    this.showError(response, "getChequeAndOverdraft");
                }
            }
            //component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    saveChequeAndOverdraft: function (component) {
        var oppId = component.get("v.recordId");

        this.buildCombinedFacChqAndOvrDft(component);
        var items = component.get("v.combinedFacChqAndOvrDft");
        var action = component.get("c.saveChequeAndOverdraft");
        var chequeAccData = component.get("v.chequeAccData");
        var primConductData = component.get("v.primaryConductData");
        var addConductData = component.get("v.additionalConductData");
        var isActSelAccDet = component.get("v.isActiveSelectedAccountDetails");

        console.log('ChequeOD: chequeAccData::: ' + JSON.stringify(chequeAccData));
        console.log('ChequeOD: primConductData::: ' + JSON.stringify(primConductData));
        console.log('ChequeOD: addConductData::: ' + JSON.stringify(addConductData));
        console.log('ChequeOD: items::: ' + JSON.stringify(items));

        if (items.length > 0) {
            if ((chequeAccData != null && chequeAccData.length >= 1 && primConductData != null && addConductData != null && isActSelAccDet)
                || (chequeAccData != null && chequeAccData.length == 1 && primConductData != null && isActSelAccDet)
                || (chequeAccData == null && !isActSelAccDet)) {

                var allValid = false, validFac = false, validNew = false;
                var facChild = component.find("idfacilityAccounts");
                var newChild = component.find("idNewCheqAndOvrDft");

                if (facChild != null) {
                    validFac = this.validateChildItems(facChild);
                    if (!validFac) {
                        var toastEvent = this.getToast("Error!", "Please enter required info in the Facility Account section", "Error");
                        toastEvent.fire();
                    }
                }

                if (newChild != null) {
                    validNew = this.validateChildItems(newChild);
                    if (!validNew) {
                        var toastEvent = this.getToast("Error!", "Please enter required info in the New Accounts section", "Error");
                        toastEvent.fire();
                    }
                }

                if (((facChild != null && validFac) && (newChild != null && validNew))
                    || (facChild == null && (newChild != null && validNew))
                    || ((facChild != null && validFac) && newChild == null)) {
                    allValid = true;
                }

                if (allValid) {
                    component.set("v.showSpinner", true);
                    action.setParams({
                        oppId: oppId,
                        objData: JSON.stringify(items),
                    });

                    action.setCallback(this, function (response) {
                        var state = response.getState();

                        if (state == "SUCCESS") {
                            var result = response.getReturnValue();

                            if (result != null) {
                                component.set("v.numberOfAccountsSelected", 0);
                                var isExCheq = component.get("v.isCurChqAndOvrD");
                                var isNewCheq = component.get("v.isNewChqAndOvrD");

                                if (isNewCheq) {
                                    component.set("v.newChequeAccounts", []);
                                    this.getNewChequeAndOverdraft(component);

                                }

                                if (isExCheq) {
                                    //component.set("v.facilityAccounts", []);
                                    this.getChequeAccounts(component);
                                }

                                var toastEvent = this.getToast("Success!", result.Status, "Success");
                                toastEvent.fire();

                                var appEvent = $A.get("e.c:creditOriginationEvent");

                                if (appEvent) {
                                    appEvent.setParams({ "sourceComponent": "CheckAndOverdraft" });
                                    appEvent.fire();
                                }

                                setTimeout(
                                    $A.getCallback(function () {
                                        component.set("v.showSpinner", false);
                                    }), 25000
                                );
                            }
                        }
                        else {
                            this.showError(response, "saveChequeAndOverdraft");
                        }
                    });

                    $A.enqueueAction(action);
                }
            }
            else {
                var toastEvent = this.getToast("Info!", "Please add required conduct data!", "Info");
                toastEvent.fire();
            }
        }
        else {
            var toastEvent = this.getToast("Info!", "Please choose either exisxting facility or new account", "Info");
            toastEvent.fire();
        }
    },

    addNewAccount: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var items = component.get("v.newChequeAccounts");

        var action = component.get("c.getTempChequeId");

        action.setParams({
            oppId: oppId,
            itemNum: items == null ? 0 : items.length,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    items.push(JSON.parse(result));
                    component.set("v.newChequeAccounts", items);
                }
            }
            else {
                this.showError(response, "getTempChequeId");
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    eventHander: function (component, rdAddConduct) {
        var numSelAccs = component.get("v.numberOfAccountsSelected");
        var numAvaAccs = component.get("v.chequeAccData");
        var prmCondSel = component.get("v.primaryConductSelected");
        var conductOnly = component.get("v.conductAccOnly");

        //if ((numSelAccs != null && numSelAccs != 0) || conductOnly) {
        if (numAvaAccs.length == 1) {
            component.set("v.isProceedDisabled", false);
            component.set("v.additionalConductData", rdAddConduct);
        }
        else if (numAvaAccs.length > 1 && (prmCondSel != null && rdAddConduct != null)
            && (prmCondSel[0].Selected && prmCondSel[0].PrimaryAccount != rdAddConduct)) {
            component.set("v.isProceedDisabled", false);
            component.set("v.primaryConductData", prmCondSel[0].PrimaryAccount);
            component.set("v.additionalConductData", rdAddConduct);
            component.set("v.isActiveAddConductDetails", (rdAddConduct != null ? true : false));
        }
        else {
            component.set("v.isProceedDisabled", true);
            component.set("v.isActiveSelectedAccountDetails", false);
        }

        this.populateConductReq(component);
        //}
    },

    setDefaultAccountSelection: function (component) {
        var chqAccounts = component.get("v.chequeAccData");
        var checkFac = component.find("facilityAccount");
        var radioPCond = component.find("primaryConduct");
        var radioACond = component.find("additionalConductAcc");
        var isSavedAccount = false;

        if (chqAccounts != null) {
            for (var i = 0; i < chqAccounts.length; i++) {
                var chqAcc = chqAccounts[i];
                if (chqAccounts.length == 1) {
                    if (chqAcc != null) {
                        this.selectFacilityAccounts(component, null, true, chqAcc.ItemId);
                        isSavedAccount = chqAcc.IsSavedAccount;
                        component.set("v.primaryConductData", chqAcc.ItemId);
                    }

                    if (checkFac != null) {
                        if (checkFac.length > 1) { checkFac.forEach((checkBox) => { checkBox.set("v.value", true); }) }
                        else { checkFac.set("v.value", true); }
                    }

                    if (radioPCond != null) {
                        if (radioPCond.length > 1) { radioPCond.forEach((radioBox) => { radioBox.set("v.value", true); }) }
                        else { radioPCond.set("v.value", true); }
                    }
                    //component.set("v.isFacilityDisabled", true);
                    component.set("v.isAddConductDisabled", true);
                    component.set("v.isProceedDisabled", false);
                }
                else {
                    if (chqAcc.IsSavedAccount || chqAcc.IsPrimaryConduct || chqAcc.IsAdditionalConduct) {
                        isSavedAccount = chqAcc.IsSavedAccount;

                        if (checkFac != null && chqAcc.IsSavedAccount) {
                            checkFac.forEach((checkBox) => { checkBox.set("v.value", true); })
                            this.selectFacilityAccounts(component, null, true, chqAcc.ItemId);
                        };

                        if (radioPCond != null) {
                            radioPCond.forEach((radioPBut) => {
                                if (radioPBut.get("v.text") == chqAcc.ItemId && chqAcc.IsPrimaryConduct) {
                                    radioPBut.set("v.value", true);
                                    isSavedAccount = true;
                                    component.set("v.primaryConductData", chqAcc.ItemId);
                                }
                            });

                        }
                        if (radioACond != null) {
                            radioACond.forEach((radioABut) => {
                                if (radioABut.get("v.text") == chqAcc.ItemId && chqAcc.IsAdditionalConduct) {
                                    radioABut.set("v.value", true);
                                    isSavedAccount = true;
                                    component.set("v.additionalConductData", chqAcc.ItemId);
                                }
                            });
                        }
                        component.set("v.isProceedDisabled", false);
                    }
                }
                this.populateConductReq(component, isSavedAccount);

            }
        }
        component.set("v.isActiveSelectedAccountDetails", isSavedAccount);
    },

    selectFacilityAccounts: function (component, target, chValue, chText) {
        var chqAccounts = component.get("v.chequeAccData");
        var fAccData = component.get("v.facilityAccounts");
        var numSelAccs = component.get("v.numberOfAccountsSelected");
        var changeD = false;

        for (var i = 0; i < chqAccounts.length; i++) {
            var chqAcc = chqAccounts[i];

            if (chqAcc != null) {
                if (chqAcc.ItemId == chText && !chValue) {
                    chqAcc.IsDeleteAccount = true;
                    var index = fAccData.indexOf(chqAcc);
                    fAccData.splice(index, 1);
                    numSelAccs--;
                    changeD = true;
                    break;
                }
                else if (chqAcc.ItemId == chText && chValue) {
                    chqAcc.IsDeleteAccount = false;
                    var index = chqAccounts.indexOf(chqAcc);

                    if (this.totalNumAccounts(component) < 5) {
                        fAccData.splice(index, 0, chqAcc);
                        numSelAccs++;
                        changeD = true;
                    }
                    else {
                        if (target != null) {
                            target.set("v.value", false);
                        }
                        var toastEvent = this.getToast("Info!", "The maximum number of accounts that can be done in a single application is 5", "Info");
                        toastEvent.fire();
                    }
                    break;
                }
            }
        }

        //change facility number order after removing an account
        if (changeD) {
            /*for (var i = 0; i < fAccData.length; i++) {
                fAccData[i].ItemId = (1 + i);
            }*/
            component.set("v.facilityAccounts", fAccData);
            //console.log('facilityAccounts::: ' + JSON.stringify(fAccData));
        }

        component.set("v.numberOfAccountsSelected", numSelAccs);
        //console.log('chqAccounts::: ' + JSON.stringify(chqAccounts));
    },

    populateConductReq: function (component, isSavedAccount) {
        var chqAccounts = component.get("v.chequeAccData");
        var pConduct = component.get("v.primaryConductData");
        var aConduct = component.get("v.additionalConductData");
        var conductData = [];

        for (var i = 0; i < chqAccounts.length; i++) {
            var chqAcc = chqAccounts[i];

            if (chqAcc != null) {
                if (chqAcc.ItemId == pConduct) {
                    conductData.push({ conductType: "Primary Conduct", accountNo: chqAcc.SevEncrytepAccountNumber, branchCode: chqAcc.SevBranchCode });
                    component.set("v.primaryConductData", "Primary Conduct");
                }
                else if (chqAcc.ItemId == aConduct) {
                    conductData.push({ conductType: "Additional Conduct", accountNo: chqAcc.SevEncrytepAccountNumber, branchCode: chqAcc.SevBranchCode });
                    component.set("v.additionalConductData", "Additional Conduct");
                }
            }
        }
        if (conductData) {
            component.set("v.conductData", conductData);
            var addConductData = component.get("v.additionalConductData");
            component.set("v.isActiveAddConductDetails", (addConductData ? true : false));
        }
    },

    buildCombinedFacChqAndOvrDft: function (component) {
        var curChqAndOvrD = component.get("v.facilityAccounts");
        var newChqAndOvrD = component.get("v.newChequeAccounts");
        var chqAndOvrDftObj = [];

        if (curChqAndOvrD.length > 0) {
            chqAndOvrDftObj.push({ CurChqAndOvrDft: curChqAndOvrD });
            component.set("v.isCurChqAndOvrD", true);
        }

        if (newChqAndOvrD.length > 0) {
            chqAndOvrDftObj.push({ NewChqAndOvrDft: newChqAndOvrD });
            component.set("v.isNewChqAndOvrD", true);
        }

        component.set("v.combinedFacChqAndOvrDft", this.removeNullProperties(chqAndOvrDftObj));
        console.log("combinedFacChqAndOvrDft:::: " + JSON.stringify(component.get("v.combinedFacChqAndOvrDft")));
    },

    removeNullProperties: function (obj) {
        Object.keys(obj).forEach((key) => {
            let value = obj[key];
            let hasProperties = value && Object.keys(value).length > 0;
            if (value === null || value === "") {
                delete obj[key];
            }
            else if (typeof value !== "string" && hasProperties) {
                this.removeNullProperties(value);
            }
        });
        return obj;
    },

    validateChildItems: function (objChild) {
        var allValid = false;
        if (objChild.length > 1) {
            objChild.forEach((child) => (allValid = child.doValidityCheck()));
        }
        else {
            allValid = objChild.doValidityCheck();
        }
        return allValid;
    },

    totalNumAccounts: function (component) {
        var facAccNum = component.get("v.numberOfAccountsSelected");
        var newChqAccNum = component.get("v.newChequeAccounts").length;
        var totalAccs = (facAccNum != null ? parseInt(facAccNum) : 0) + (newChqAccNum != null ? parseInt(newChqAccNum) : 0);
        return totalAccs;
    },

    /* Saurabh : 2021/04/23
     * Calling Apex method to delete the Facility Account and Conduct Account and reset the section for new selection
     Defect Id W: 11314
    */
    deleteFacilityAccountsAndReset: function (component) {
        var oppId = component.get("v.recordId");
        component.set("v.showSpinner", true);
        var action = component.get("c.deleteSelectedConductAndFacilityAccount");
        action.setParams({
            oppId: oppId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.showSpinner", false);
                var result = response.getReturnValue();
                var toastEvent = this.getToast("Success:  ", 'Account Reset Completed', "Success");
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            else {
                var toastEvent = this.getToast("Error:  " + 'deleteSelectedConductAndFacilityAccount' + "! ", 'Failed', "Error");
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
        });

        $A.enqueueAction(action);
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
        var toastEvent = this.getToast("Error: ChequeAndOverdraft " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
});