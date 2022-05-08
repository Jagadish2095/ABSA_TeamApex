({
    // function automatic called by aura:waiting event
    showSpinner: function (component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // add slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    /*getApplication: function (component) {
        var opportunityId = component.get("v.recordId");

        var action = component.get("c.getApplicationProduct");
        action.setParams({
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue !== null) {
                    component.set("v.apcId", responseValue.Id);

                    if (responseValue != null && responseValue.Id != null) {
                        component.set("v.applicationId", responseValue.Id);
                        component.set('v.isHide', false);
                    }
                    else {
                        component.set('v.isHide', true);
                    }
                }
            }
            else {
                this.showError(response, "getApplicationProduct");
            }
        });
        $A.enqueueAction(action);
    }, */
    getEDFdetails: function (component, event, helper,apprec) {
        var opportunityId = component.get("v.recordId");

        var action = component.get("c.getEnDevFundDetails");
        action.setParams({
            "oppId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue !== null) {
                    if(responseValue.EDF_Name__c!=null && responseValue.EDF_Name__c!='' && responseValue.EDF_Code__c!=null && responseValue.EDF_Code__c!=''){
                        component.set("v.EDFName", responseValue.EDF_Name__c);
                        component.set("v.EDFCode", responseValue.EDF_Code__c);
                        component.set("v.isEDFExisting", true);
                        component.set("v.showEDFList", true);
                    }
                    else if(apprec.EDF_ReqName__c!=null && apprec.EDF_ReqName__c!='' && apprec.EDF_ReqCode__c!=null && apprec.EDF_ReqCode__c!=''){
                        component.set("v.ReqEDFName", apprec.EDF_ReqName__c);
                        component.set("v.ReqEDFCode", apprec.EDF_ReqCode__c);
                        component.set("v.isEDFExisting", false);
                        component.set("v.showEDFList", true);

                    }
                    if(responseValue.Franchise_Code__c!=null && responseValue.Franchise_Code__c!="" && responseValue.Franchise_Name__c!=undefined && responseValue.Franchise_Name__c!=null && responseValue.Franchise_Name__c!=""){
                       component.set("v.FranchiseCodeName", responseValue.Franchise_Code__c+' '+responseValue.Franchise_Name__c);
                       component.set("v.isFranchiseExisting", true);
                       component.set("v.showFranchiseList", true);
                    }
                    else if(apprec.Requested_Franchise_Code__c!=null && apprec.Requested_Franchise_Code__c!='' && apprec.Requested_Franchise_Name__c!=null && apprec.Requested_Franchise_Name__c!=''){
                        //component.set("v.selectedfranciseRecord", responseValue.Requested_Franchise_Code__c+' '+responseValue.Requested_Franchise_Name__c);
                        //component.set("v.showFranchiseList", true);
                        helper.getreqFranchisedetails(component, event, helper,apprec.Requested_Franchise_Code__c);
                    }




                 }
            }
            else {
                this.showError(response, "getEDFdetails");
            }
        });
        $A.enqueueAction(action);
    },
    getreqFranchisedetails: function (component, event, helper,code) {
        var action = component.get("c.getReqFranchiseDetails");
        action.setParams({
            "FranchCode": code
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                alert(responseValue);
                if (responseValue !== null) {
                   responseValue["Name"] = responseValue.Franchise_Code__c;
                   component.set("v.selectedfranciseRecord", responseValue);
                   console.log('responseValue'+JSON.stringify(responseValue));
                   component.set("v.showFranchiseList", true);
                   component.set("v.showReqFranchise", true);

              }
            }
            else {
                this.showError(response, "getreqFranchisedetails");
            }
        });
        $A.enqueueAction(action);
    },
    updateEDFDetails: function (component, event, helper) {
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.updateEnDevFundDetails");
        var toastEvent;
        var ReqEDFCode = '';
        var ReqEDFName = '';
        var isFranchiseExisting = component.get("v.isFranchiseExisting");
        var showFranchiseList = component.get("v.showFranchiseList");
        var isEDFExisting = component.get("v.isEDFExisting");
        var showEDFList = component.get("v.showEDFList");
        var index;
        var combinedString;
        var FarnchiseCode='';
        var FranchiseName='';
        var combinedStringbefore;
        var list1=[];
        if(!isFranchiseExisting && showFranchiseList && component.get("v.selectedfranciseRecord")!=null){
        console.log(JSON.stringify(component.get("v.selectedfranciseRecord")));
        combinedStringbefore = component.get("v.selectedfranciseRecord");
        combinedString= combinedStringbefore.Franchise_Code__c;
        index = combinedString.indexOf(' ');
        if(combinedString.indexOf(' ')> -1){
        FarnchiseCode =  combinedString.substring(0, index);
        FranchiseName =  combinedString.substring(index + 1); }
       /*  if(combinedString!=null){
         list1 = combinedString.split(" ");
  		 var retcode='';
         var retname='';
         for(var i=0;i<list1.length;i++){
         //retcode=combinedString[i];
         if(i==0){
             FarnchiseCode=list1[i];
          }
         console.log(list1[i]);
         if(i==(list1.length-1)){
             FranchiseName=list1[i];

         }
         }
         }*/
        }
        console.log('isEDFExisting'+isEDFExisting);
        console.log('showEDFList'+showEDFList);
        console.log('ReqEDFName'+component.get("v.ReqEDFName"));
        console.log('ReqEDFCode'+component.get("v.ReqEDFCode"));
        if(!isEDFExisting && showEDFList && component.get("v.ReqEDFName")!=null && component.get("v.ReqEDFCode")!=null){
         ReqEDFCode =  component.get("v.ReqEDFCode");
         ReqEDFName =  component.get("v.ReqEDFName");
        }
        action.setParams({
            "oppId": opportunityId,
            "reqEDFName": ReqEDFName,
            "reqEDFCode": ReqEDFCode,
            "FranchiseName":FranchiseName,
            "FarnchiseCode":FarnchiseCode,
            "ReqEDFIndicator":showEDFList,
            "ReqFranchiseIndicator":showFranchiseList
         });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();
                  toastEvent = this.getToast("Success!", "Enterprise Development Fund Data updated Successfully", "success");
                  toastEvent.fire();
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                this.showError(response, "updateEDFSection");
            }
        });
        $A.enqueueAction(action);
    },
    checkStockNumber: function (component) {
        var action = component.get("c.getStockNumber");

        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();

                if (responseValue != null && responseValue.Id != null) {
                    component.set("v.applicationId", responseValue.Id);
                }
            }
            else {
                this.showError(response, "getStockNumber");
            }
        });

        $A.enqueueAction(action);
    },

    linkAccountToClient: function (component, event, helper) {
        this.showSpinner(component);
        var action2 = component.get("c.linkStockNumberToCIF");

        action2.setParams({
            "oppId": component.get("v.recordId")
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent;

            if (state == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.toUpperCase() == 'SUCCESS') {
                    toastEvent = this.getToast("Success!", responseValue, "success");
                }
                else {
                    toastEvent = this.getToast("Info!", responseValue, "info");
                }
                toastEvent.fire();
            }
            else {
                this.showError(response, "linkStockNumberToCIF");
            }
            this.hideSpinner(component);
        });

        $A.enqueueAction(action2);
    },

    //update NCA Section
    updateNCA: function (component, event, helper) {
        this.linkAccountToClient(component, event, helper);
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.updateNCAsection");
        var isEDFExisting = component.get("v.isEDFExisting");
        var showEDFList = component.get("v.showEDFList");
        var edfval = false;
        var isFranchiseExisting = component.get("v.isEDFExisting");
        var showFranchiseList = component.get("v.showFranchiseList");
        var selectedfranciseRecord = component.get("v.selectedfranciseRecord");
        var franchiseval = false;
        if(isEDFExisting || showEDFList){
            edfval = true;
        }
         if((showFranchiseList && selectedfranciseRecord!=null) || isFranchiseExisting){
            franchiseval = true;
        }

        var toastEvent;

        action.setParams({
            "creditAgreement": component.find("creditAgreement").get("v.value"),
            "numberOfTrustees": component.find("numberOfTrustees").get("v.value"),
            "anyJuristicTrustee": component.find("anyJuristicTrustee").get("v.value"),
            "annualTurnover": component.find("annualTurnover").get("v.value"),
            "assetValue": component.find("assetValue").get("v.value"),
            "clientState": component.find("clientState").get("v.value"),
            "underExistingFranchise": franchiseval,
            "partOfEnterpriseDevFund": edfval,
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var response = response.getReturnValue();

                if (response === 'SUCCESS') {
                    toastEvent = this.getToast("Success!", "NCA Record updated Successfully", "success");
                    this.updateOppStageName(component, event);
                }
                else {
                    toastEvent = this.getToast("Error!", "Failed to update NCA record!", "error");
                }
                toastEvent.fire();
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                this.showError(response, "updateNCAsection");
            }
        });
        $A.enqueueAction(action);
    },

    submitStockDetails: function (component, event, helper) {
        this.showSpinner(component);
        var action2 = component.get("c.callToAllocateStockNo");
        action2.setParams({
            "oppId": component.get("v.recordId")
        });

        action2.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent;

            if (state == "SUCCESS") {
                if (response.getReturnValue().toUpperCase() == 'SUCCESS') {
                    toastEvent = this.getToast("Success!", "Stock number generated successfully.", "success");
                    toastEvent.fire();
                }
                else {
                    this.showError(response, "callToAllocateStockNo");
                }
            }
            else {
                this.showError(response, "callToAllocateStockNo");
            }

            this.hideSpinner(component);
        });

        $A.enqueueAction(action2);
    },

    updateClientDetails: function (component, event, helper) {
        //updated by almas
        var toastEvent;
        var account1 = component.get("v.account");
        const account = JSON.parse(JSON.stringify(account1)); //(account1 != null ? JSON.parse(JSON.stringify(account1)) : null);  //change to proxy object

        console.log('account :::: ', account);

        /*if (!account.BusinessStartDate) {
            toastEvent = this.getToast("Error!", "Business Start Date field is not captured!", "error");
            toastEvent.fire();
        }*/

        /*if (!account.IsTradingIndicator) {
            toastEvent = this.getToast("Error!", "Trading Indicator field is not captured!", "error");
            toastEvent.fire();
        }*/

        if (account.DateEstablished)// && account.IsTradingIndicator)
        {
            var toupdateAccount = true;
            //check for email fields
            /*if ((account.IsEmailNonCredit && !account.EmailNonCredit) || (account.IsEmailCredit && !account.EmailCredit)) {
                toupdateAccount = false;
                toastEvent = this.getToast("Error!", "Email box is selected, Email field is not captured!", "error");
                toastEvent.fire();
            }

            if ((account.IsSMSNonCredit && !account.SMSNonCredit) || (account.IsSMSCredit && !account.SMSCredit)) {
                toupdateAccount = false;
                toastEvent = this.getToast("Error!", "SMS box is selected, SMS field is not captured!", "error");
                toastEvent.fire();
            }

            if ((account.IsPhoneNonCredit && !account.PhoneNonCredit) || (account.IsPhoneCredit && !account.PhoneCredit)) {
                toupdateAccount = false;
                toastEvent = this.getToast("Error!", "phone box is selected, phone field is not captured!", "error");
                toastEvent.fire();
            }
            if(account.ResidentialStatusAddress != null && account.ResidentialStatusBorder != null) {
                if ((account.ResidentialStatusAddress.toLowerCase() == "select an option") || (account.ResidentialStatusBorder.toLowerCase() == "select an option")) {
                    toupdateAccount = false;
                    toastEvent = this.getToast("Error!", "Residential Status, is not captured!", "error");
                    toastEvent.fire();
                }
            }*/

            //validate if stage moves or not
            component.set("v.isClntValidated", toupdateAccount);

            if (toupdateAccount) {
                var action = component.get("c.updateClientDetails");
                this.showSpinner(component);

                action.setParams({
                    "oppId": component.get("v.recordId"),
                    "accountObj": JSON.stringify(account)
                });

                action.setCallback(this, function (response) {
                    var state = response.getState();
                    var result = response.getReturnValue();

                    if (state === "SUCCESS") {

                        if (result.accountUpdate == "Updated") {
                            toastEvent = this.getToast("Success!", "Client details updated successfully.", "success");
                            toastEvent.fire();
                        }
                    }
                    else {
                        toastEvent = this.getToast("Error!", 'Din\'t update client details', "error");
                        toastEvent.fire();
                    }

                    this.hideSpinner(component);
                });

                $A.enqueueAction(action);
            }
        }
    },

    updateOppStageName: function (component, event) {
        var isClntValidated = component.get("v.isClntValidated");
        var isNcaValidated = component.get("v.isNcaValidated");

        if (isClntValidated && isNcaValidated) {
            //update stage when validate
            var action = component.get("c.updateOpportunityStage");
            var toastEvent;

            action.setParams({
                "oppId": component.get("v.recordId")
            });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue().toUpperCase() == "SUCCESS") {
                        toastEvent = this.getToast("Success!", "Opportunity Stage moved successfully!", "success");
                        toastEvent.fire();

                        $A.get("e.force:refreshView").fire();
                    }
                    else {
                        this.showError(response, "updateOpportunityStage");
                    }
                }
                else {
                    this.showError(response, "updateOpportunityStage");
                }
            });
            $A.enqueueAction(action);
        }
    },

    updatePrincipal: function (component) {
        var oppId = component.get("v.recordId")
        var selectedIDs = component.get("v.selectedPrincipal");
        var selectedMainID = component.get("v.selectedMainPrincipal");
        var isInfoCorrect = component.get("v.isPrincipalInfoCorrect");
        var action = component.get("c.updatePrincipal");
        var toastEvent;

        if (selectedIDs != null && selectedIDs.length > 0) {
            action.setParams({
                "oppId": oppId,
                "selectedIDs": selectedIDs,
                "selectedMainID": selectedMainID,
                "isInfoCorrect": isInfoCorrect
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                console.log("updatePrincipal response::: " + JSON.stringify(response));
                if (state === "SUCCESS") {
                    toastEvent = this.getToast("Success!", "Principals Added Successfully!", "success");
                    toastEvent.fire();
                }
                else {
                    this.showError(response, "updatePrincipal");
                }
            });
            $A.enqueueAction(action);
        }
    },

    validatePrincipalsDet: function (component) {
        var allValid = true;
        var objPrin = component.get("v.principalsDetails");
        var objSelPrin = component.get("v.selectedPrincipal");
        var allValids = [];
        var prinMissingInfo = "";

        for(var i = 0; i < objSelPrin.length; i++) {
            for(var x = 0; x < objPrin.length; x++) {
                if(objSelPrin[i] == objPrin[x].Id) {
                    allValid = ((this.isEmpty(objPrin[x].HighestQualification) || this.isEmpty(objPrin[x].DateShareholdingAcquired) || this.isEmpty(objPrin[x].NumberOfYearInTheSpecificIndustry) || this.isEmpty(objPrin[x].MonthsActivelyInvolvedInTheBusiness)) ? false : true);
                    allValids.push(allValid);
                    if(!allValid) {
                        prinMissingInfo += (", " + objPrin[x].FullName);
                    }
                    break;
                }
            }
        }
        component.set("v.prinMissingInfo", prinMissingInfo);
        console.log("allValids::: " + JSON.stringify(allValids));

        return allValid = (allValids.includes(false) ? false : true);
    },

    isEmpty: function(strVal) {
        return (!strVal || strVal.length === 0);
    },

    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            duration: 10000,
            title: title,
            message: msg,
            type: type
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
        var toastEvent = this.getToast("Error: AllocateStockNumber " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})