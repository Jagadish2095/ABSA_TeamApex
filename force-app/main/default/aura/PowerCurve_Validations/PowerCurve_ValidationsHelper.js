({
    forceSolePropAddition: function (component, event) {
        // $A.get('e.force:refreshView').fire();
        var oppId = component.get("v.recordId");
        var action = component.get("c.isSoleTraderAccount");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            this.hideSpinner(component);
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.isSoleTraderForced", result);
                // $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },

    /* Trying to init the cmp on Attest popup for Lazy loading
       Handler for applicationEvent */
    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        var opportunityId = event.getParam("opportunityId");
        console.log('App event Fired ++ ' + sourceComponent);
        if (sourceComponent == "CheckAndOverdraft") {
            var a = component.get("c.doInit");
            $A.enqueueAction(a);
        }

        if (sourceComponent == "Validation02") {
            var b = component.get("c.doInit");
            $A.enqueueAction(b);
        }
    },

    handleValidationDetailDisplay: function (component) {
        var validationStep = component.get("v.validationScreen");

        if (validationStep == "03") {
            var action = component.get("c.getFinResponseAppScoringEntities");
            var opportunityId = component.get("v.recordId");
            component.set("v.showSpinner", true);

            action.setParams({
                "oppId": opportunityId
            });

            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    component.set("v.valTwoData", data);
                    component.set("v.isRefreshed", true);

                    if (data && data != null) {
                        if (data[0] && data[0] != null) {
                            component.set("v.lastRefresh", data[0].lastModified);
                        }
                    }
                } else {
                    var errors = response.getError();

                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            //this.showToast("error","Validation 2 Error!",errors[0].message);
                            console.log("PowerCurve_Validations: " + errors[0].message);
                        }
                    } else {
                        //this.showToast("error","Error!","Validation 2 unknown error");
                    }
                }

                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },

    getValidationfields: function (component) {
        var action = component.get("c.getValidationMap");
        var oppId = component.get("v.recordId");

        this.showSpinner(component);
        action.setParams({
            "oppId": oppId
        });

        action.setCallback(this, function (response) {
            this.hideSpinner(component);
            var state = response.getState();
            console.log('==getValidationfields state==' + state);
            if (state == "SUCCESS") {
                //var respObj = new Map();
                var respObj = response.getReturnValue();
                component.set("v.validationMap", respObj);

                //now the set the value for each attribute
                var valMap = component.get("v.validationMap");

                //Search for the section/FieldName and set the attribute values based upon result
                //Validation1
                var chequeAndOverDraft = valMap['Cheque_Overdraft_Validated'];
                var creditCard = valMap['Credit_Card_Validated'];
                var bankGuarantee = valMap['Bank_Guarantee_Validated'];
                var securitiesOffered = valMap['Securities_Offered'];
                var isSpouseCaptured = valMap['Is_Spouse_Captured'];
                var externalBankingRelationships = valMap['External_Banking_Relationships'];
                var nonScoredApprovedFacilities = valMap['Non_Scored_Approved_Facilities'];

                //set the attribute Values based upon validations
                component.set("v.Cheque_OverDraft", chequeAndOverDraft);
                component.set("v.Credit_Card", creditCard);
                component.set("v.Bank_Guarantee", bankGuarantee);
                component.set("v.Securities_Offered", securitiesOffered);
                component.set("v.Is_Spouse_Captured", isSpouseCaptured);
                component.set("v.External_Banking_Relationships", externalBankingRelationships);
                component.set("v.Non_Scored_Approved_Facilities", nonScoredApprovedFacilities);

                //Validation2
                var applicantFinCaptured = valMap['Applicant_Financials_Captured'];
                component.set("v.Applicant_Financials", applicantFinCaptured);

                //Validation3
                var principalFinCaptured = valMap['Principal_Financials_Captured'];
                component.set("v.Principal_Finacials", principalFinCaptured);
                if (applicantFinCaptured == null) {
                    component.set("v.Applicant_Financials", principalFinCaptured);
                }

                /*if(principalFinCaptured==null){
                     component.set("v.Principal_Finacials", applicantFinCaptured);
                }*/

                //Validation5
                var incomeExpense = valMap['Income_Expenses'];
                component.set("v.Income_Expenses", incomeExpense);

                var generalQualitative = valMap['General_Qualitative'];
                component.set("v.General_Qualitative", generalQualitative);

                var borrowingPower = valMap['Borrowing_Power'];
                component.set("v.Borrowing_Power", borrowingPower);

                console.log('==LAST LINE== ' + component.get("v.validationScreen"));
            }
            else {
                console.log('something went wrong while refreshing opp record');
            }
        });
        $A.enqueueAction(action);
    },

    // function to call PowerCurve service
    submitToPCORequest: function (component, event, helper) {
        var oppId = component.get("v.recordId");
        var stageId = component.get("v.validationScreen");
        // alert('stageId='+stageId);
        var isBorrowingPowerCaptured = component.get("v.Borrowing_Power");
        // alert('isBorrowingPowerCaptured='+isBorrowingPowerCaptured);

        var isSoleTraderForced = component.get("v.isSoleTraderForced");
        //   alert('isSoleTraderForced='+isSoleTraderForced);

        var isValid = true;
        var Cheque_OverDraft = component.get("v.Cheque_OverDraft");
        //   alert('Cheque_OverDraft='+Cheque_OverDraft);
        var Credit_Card = component.get("v.Credit_Card");
        var Bank_Guarantee=component.get("v.Bank_Guarantee");

        if (!(Cheque_OverDraft || Credit_Card || Bank_Guarantee) && stageId == '01') {
            var toastEvent = this.getToast("Error!", "Please enter required info in the Cheque And Overdraft/Credit Card section", "Error");
            toastEvent.fire();
            isValid = false;
        }

        if (isSoleTraderForced == true && stageId == '01') {
            var toastEvent = this.getToast("Error!", "Please enter required info in the Spouse section, as applicant is married in community of property!", "Error");
            toastEvent.fire();
            isValid = false;
        }

        var oppRecord = component.get("v.oppRecord");
        var isVisible = ((oppRecord.Account != null && (oppRecord.Account.Client_Type__c == "Company"
            || oppRecord.Account.Client_Type__c == "Private Company"
            || oppRecord.Account.Client_Type__c == "Incorporated Company")) ? true : false);

        if (!isBorrowingPowerCaptured && isVisible && stageId == '07') {
            var toastEvent = this.getToast("Error!", "Please enter required info for Borrowing Powers in the General Qualitative section", "Error");
            toastEvent.fire();
            isValid = false;
        }

        console.log('isValid---' + isValid);
        if (isValid) {
            var action = component.get("c.pcoStageHandler");
            //var Illustrative_Decision = component.get("v.record").Illustrative_Decision__c;
            //alert('stageID---'+stageId);
            this.showSpinner(component);
            action.setParams({
                "oppId": oppId,
                "stageId": stageId,
                "Illustrative_Decision": false
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    $A.get('e.force:refreshView').fire();

                    var respObj = response.getReturnValue();
                    if (respObj != '' && !respObj.includes("Failed")) {
                        var toastEvent = this.getToast("Power Curve Service Submitted Successfully!", respObj, "Success");
                        toastEvent.fire();
                    } else {
                        var toastEvent = this.getToast("Power Curve Request Submitted, But Data was not sufficient!", respObj, "Error");
                        toastEvent.fire();
                        this.fireAppEvent(oppId, "Validation02");

                    }

                    //firing the app event on Validation screen
                    if (stageId == '03') {
                        this.handleValidationDetailDisplay(component);
                        this.handleLoadResponseData(component);
                        this.fireAppEvent(oppId, "Validation03");
                    }
                    else if (stageId == '01') {
                        this.fireAppEvent(oppId, "Validation01");
                    }
                    else if (stageId == '04') {
                        this.fireAppEvent(oppId, "Validation03");
                    }
                    else if (stageId == '06') {
                        this.fireAppEvent(oppId, "Validation04");
                    }
                    else if (stageId == '07') {
                        this.fireAppEvent(oppId, "Validation07");
                    }
                    else if (stageId == '02') {  // AG
                        this.fireAppEvent(oppId, "Validation02");
                    }
                }
                if (state == "ERROR") {
                    var error = action.getError();
                    var toastEvent = this.getToast("Power Curve request Failed!  ", error[0].message, "Error");
                    toastEvent.fire();
                }
                this.hideSpinner(component);
            });
            $A.enqueueAction(action);
        }
        //}
    },

    //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    handleLoadResponseData: function (component) {
        var action = component.get("c.getApplicationScoringEntities");
        var opportunityId = component.get("v.recordId");

        action.setParams({
            "oppId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.data", data);

                if (data && data != null) {
                    if (data[0] && data[0] != null) {
                        component.set("v.lastRefresh", data[0].lastModified);
                    }
                }
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.getToast("error", "Validation 2 Error!", errors[0].message);
                    }
                } else {
                    this.getToast("error", "Error!", "Validation 2 unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

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

    //fireAppEvent
    fireAppEvent: function (oppId, cmpSource) {
        var eventHandler = $A.get("e.c:creditOriginationEvent");
        eventHandler.setParams({ "sourceComponent": cmpSource });
        eventHandler.setParams({ "opportunityId": oppId });
        eventHandler.fire();
    }

})