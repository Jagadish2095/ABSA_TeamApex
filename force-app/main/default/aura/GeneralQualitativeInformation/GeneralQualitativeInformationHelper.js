({
    borrowingPowersVisible: function (component) {
        var oppRecord = component.get("v.oppRecord");
        var isVisible = ((oppRecord.Account != null && (oppRecord.Account.Client_Type__c == "Company"
            || oppRecord.Account.Client_Type__c == "Private Company"
            || oppRecord.Account.Client_Type__c == "Incorporated Company")) ? true : false);
        component.set("v.isActiveBorrowingPower", isVisible);
    },

    initialiseOptions: function (component, options, optionCmpId, defaultAns) {
        var selOptions = [{ class: "optionClass", label: "--Please Select--", value: "None", selected: ((defaultAns != null ? defaultAns.search("Please Select") : 0) > 0 ? true : false) }];

        for (var i = 0; i < options.length; i++) {
            selOptions.push({ class: "optionClass", label: options[i], value: options[i], selected: (defaultAns == options[i] ? true : false) });
        }

        if (selOptions != null) {
            component.set(optionCmpId, selOptions);
        }
    },

    initializeLimitOpt: function (component) {
        var limitOpt = [
            { ShareholderFunds: "Issued Share Capital", BorrowingPercentage: 0, Rands: 0.00, Total: 0.00, IsVisible: true },
            { ShareholderFunds: "Authorised Share Capital", BorrowingPercentage: 0, Rands: 0.00, Total: 0.00, IsVisible: true },
            { ShareholderFunds: "Shareholder Equity", BorrowingPercentage: 0, Rands: 0.00, Total: 0.00, IsVisible: true },
            { ShareholderFunds: "Share Premium Account", BorrowingPercentage: 0, Rands: 0.00, Total: 0.00, IsVisible: true },
            { ShareholderFunds: "Total Limited Amount", BorrowingPercentage: 0, Rands: 0.00, Total: 0.00, IsVisible: false }
        ];
        component.set("v.limitOther", limitOpt);
    },

    updateLimitOpt: function (component, data) {
        var ques = data.Question, answ = data.Answer;

        var IssuedShareCapP = (ques == "Issued Share Capital Percentage" && answ != "" ? true : false),
            IssuedShareCapR = (ques == "Issued Share Capital Rands" && answ != "" ? true : false),
            IssuedShareCapT = (ques == "Issued Share Capital Total" && answ != "" ? true : false),
            AuthShareCapP = (ques == "Authorised Share Capital Percentage" && answ != "" ? true : false),
            AuthShareCapR = (ques == "Authorised Share Capital Rands" && answ != "" ? true : false),
            AuthShareCapT = (ques == "Authorised Share Capital Total" && answ != "" ? true : false),
            ShareholderEquityP = (ques == "Shareholder Equity Percentage" && answ != "" ? true : false),
            ShareholderEquityR = (ques == "Shareholder Equity Rands" && answ != "" ? true : false),
            ShareholderEquityT = (ques == "Shareholder Equity Total" && answ != "" ? true : false),
            SharePremiumAccP = (ques == "Share Premium Account Percentage" && answ != "" ? true : false),
            SharePremiumAccR = (ques == "Share Premium Account Rands" && answ != "" ? true : false),
            SharePremiumAccT = (ques == "Share Premium Account Total" && answ != "" ? true : false),
            TotalLimitedAmtT = (ques == "Total Limited Amount Total" && answ != "" ? true : false);

        var limitOptUp = component.get("v.limitOther");

        if (limitOptUp.length > 0) {
            for (var i = 0; i < limitOptUp.length; i++) {
                var name = limitOptUp[i].ShareholderFunds;
                if (ques.search(name) >= 0) {
                    limitOptUp[i].BorrowingPercentage = ((IssuedShareCapP || AuthShareCapP || ShareholderEquityP || SharePremiumAccP) ? answ : limitOptUp[i].BorrowingPercentage);
                    limitOptUp[i].Rands = ((IssuedShareCapR || AuthShareCapR || ShareholderEquityR || SharePremiumAccR) ? answ : limitOptUp[i].Rands);
                    limitOptUp[i].Total = ((IssuedShareCapT || AuthShareCapT || ShareholderEquityT || SharePremiumAccT || TotalLimitedAmtT) ? answ : limitOptUp[i].Total);
                    break;
                }
            }
            component.set("v.limitOther", limitOptUp);
        }
    },

    getGQIQuestionsAndAnswers: function (component) {
        component.set("v.showSpinner", true);
        this.initializeLimitOpt(component);

        var oppId = component.get("v.recordId");
        var tempName = "General Qualitative Information";
        var action = component.get("c.getQuestionsAndAnswers");

        action.setParams({
            oppId: oppId,
            tempName: tempName,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    component.set("v.gqInfo", result);
                    component.set("v.isActiveQuestions",true);
                    this.populateGQQuestions(component, result);
                }
            } else {
                this.showError(response, "getQuestionsAndAnswers");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    saveGQInformation: function (component) {
        var oppId = component.get("v.recordId");
        var gqQAndA = component.get("v.gqInfo");

        this.updateObjectData(component, gqQAndA);
        var isBorrowingPowerSel = component.get("v.isBorrowingPowerSel");
        var isActiveBorrowingPower = component.get("v.isActiveBorrowingPower");
        var isValid = ((isActiveBorrowingPower && isBorrowingPowerSel) || (!isActiveBorrowingPower && isBorrowingPowerSel) ? true : false);
        if(isValid) {
            component.set("v.showSpinner", true);
            var action = component.get("c.saveGeneralQualitativeInformation");
            action.setParams({
                oppId: oppId,
                qqQAndAObj: JSON.stringify(gqQAndA)
            });

            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state === "SUCCESS") {
                    var result = response.getReturnValue();

                    if (result != null) {
                        var toastEvent = this.getToast("Success!", result, "Success");
                        toastEvent.fire();

                        var eventHandler = $A.get("e.c:creditOriginationEvent");
                        eventHandler.setParams({ "sourceComponent": "GeneralQualitativeInfo" });
                        eventHandler.fire();
                    }
                }
                else {
                    this.showError(response, "saveGeneralQualitativeInformation");
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        }
        else{
            var toastEvent = this.getToast("Error!", 'Please select Limitation Of Borrowing Power!', "Error");
            toastEvent.fire();
        }
    },

    populateGQQuestions: function (component, data) {
        this.borrowingPowersVisible(component);
        var elemIds = [];

        for (var i = 0; i < data.length; i++) {
            var ques = data[i].Question;
            var comment = data[i].IncludeComment;
            var quesSec = data[i].Section;
            var answerCtrlType = data[i].AnswerControlType;
            var quesId = "qq" + ques.replace(/\s/g, "");
            elemIds.push({ Id: quesId });

            if (comment) {
                var quesCId = "qc" + ques.replace(/\s/g, "");
                elemIds.push({ Id: quesCId });
                this.setElementData(component, quesCId, data[i]);
            }

            if (answerCtrlType != "Option") {
                this.setElementData(component, quesId, data[i]);
                if (quesSec == "Info about Borrowing Power")
                    this.updateLimitOpt(component, data[i]);
            }
            else if (answerCtrlType == "Option") {
                var qOptions = data[i].AnswerOptions.split(";");
                var qDef = (data[i].Answer != "" ? data[i].Answer : data[i].DefaultAnswer);
                var qOptId = "v.sel" + ques.replace(/\s/g, "");

                this.setElementData(component, quesId, data[i]);
                this.initialiseOptions(component, qOptions, qOptId, qDef);
            }
        }

        if (elemIds.length > 0) {
            component.set("v.elementIds", elemIds);
        }
    },

    setElementData: function (component, elmId, data) {
        var quesLabel = data.QuestionLabel;
        var quesValue = (data.Answer == "true" ? true : data.Answer);
        var quesComment = data.Comment;
        var quesCtrlType = data.AnswerControlType;

        var cmpName = elmId.substr(2, elmId.length);

        if (quesValue && (quesCtrlType == "Checkbox" || quesCtrlType == "Option")) {
            this.eventHandlerChkBox(component, cmpName, quesValue);
            this.eventHandlerSelOpt(component, quesValue, false);
        }

        var cmpQues = component.find(elmId);

        if (cmpQues) {
            var preFix = elmId.substr(0, 2).toLowerCase();

            if (preFix != "qc") {
                if (quesCtrlType == "Checkbox") {
                    var curLabel = cmpQues.get("v.label");
                    cmpQues.set("v.label", (curLabel.trim() != "" ? curLabel : (curLabel + quesLabel)));
                }
                else {
                    cmpQues.set("v.label", quesLabel);
                }
                cmpQues.set("v.value", quesValue);
            }
            else {
                cmpQues.set("v.value", quesComment);
            }
        }
    },

    updateObjectData: function (component, gqQAndA) {
        var elemIds = component.get("v.elementIds");
        var limitOther = component.get("v.limitOther");
        var isLimitedOther, isUnLimited, isFixedAmount;
		console.log('@@ gqQAndA' + JSON.stringify(gqQAndA));

        for (var i = 0; i < gqQAndA.length; i++) {
            var ques = gqQAndA[i].Question.replace(/\s/g, "");
            var quesSec = gqQAndA[i].Section;
            var answerCtrlType = gqQAndA[i].AnswerControlType;
            var qAnswer = gqQAndA[i].Answer;

            for (var j = 0; j < elemIds.length; j++) {
                var id = elemIds[j].Id

                if (quesSec == "Info about Borrowing Power" && id.search(ques) > 0) {
                    if (id == "qqBorrowingPowerLimit") {
                        isLimitedOther = (qAnswer == "Limited - Other" ? true : false);
                        isUnLimited = (qAnswer == "Unlimited" ? true : false);
                        isFixedAmount = (qAnswer == "Limited - Fixed Amount" ? true : false);
                        var isActiveBorrowingPower = component.get("v.isActiveBorrowingPower");
                        component.set("v.isBorrowingPowerSel", ((qAnswer == "None" || qAnswer == "Please Select" || qAnswer == undefined) && isActiveBorrowingPower ? false : true))
                    }

                    for (var x = 0; x < limitOther.length; x++) {
                        var tbQues = "qq" + limitOther[x].ShareholderFunds.replace(/\s/g, "");
                        var tbQuesP = tbQues + "Percentage";
                        var tbQuesR = tbQues + "Rands";
                        var tbQuesT = tbQues + "Total";

                        if (tbQues == id) {
                            gqQAndA[i].Answer = limitOther[x].ShareholderFunds;
                            break;
                        }
                        if (tbQuesP == id) {
                            gqQAndA[i].Answer = ((isFixedAmount || isUnLimited) ? 0 : limitOther[x].BorrowingPercentage);
                            break;
                        }
                        if (tbQuesR == id) {
                            gqQAndA[i].Answer = ((isFixedAmount || isUnLimited) ? 0 : limitOther[x].Rands);
                            break;
                        }
                        if (tbQuesT == id) {
                            gqQAndA[i].Answer = ((isFixedAmount || isUnLimited) ? 0 : limitOther[x].Total);
                            break;
                        }
                    }

                    var obj = component.find(id);
                    if (obj) {
                        if (id == "qqBorrowingPowerLimit") {
                            gqQAndA[i].Answer = obj.get("v.value");
                        }
                        else {
                            gqQAndA[i].Answer = (isFixedAmount ? obj.get("v.value") : "");
                        }
                    }
                    else {
                        if (id == "qqFixedAmount" && !isFixedAmount) {
                            gqQAndA[i].Answer = "";
                        }
                    }

                    break;
                }
                else {
                    if (id.search(ques) > 0) {
                        var obj = component.find(id);
                        if (obj) {
                            var preFix = id.substr(0, 2).toLowerCase();
                            var qAnswer = obj.get("v.value");

                            if (preFix != "qc") {
                                gqQAndA[i].Answer = (answerCtrlType == "Checkbox" && qAnswer == "" ? false : qAnswer);
                            }
                            else {
                                gqQAndA[i].Comment = qAnswer;
                            }
                        }
                    }
                }
            }
        }
        console.log('** gqQAndA ' + JSON.stringify(gqQAndA));
        component.set("v.gqInfo", gqQAndA);
    },

    eventHandlerChkBox: function (component, chName, chValue) {
        switch (chName) {
            case "KeyManagementPersonnelChanges":
                component.set("v.isActiveKeyManagementPers", chValue);
                break;
            case "BusinessDirectionChanges":
                component.set("v.isActiveBusinessDirection", chValue);
                break;
            case "ExposureIncrease":
                component.set("v.isActiveExposureIncrease", chValue);
                break;
            case "OtherFinancialInstitutions":
                component.set("v.isActiveOtherFinancialInstitutions", chValue);
                break;
            case "ArreasOrSars":
                component.set("v.isActiveArreasOrSars", chValue);
                break;
            case "DisputeBetweenParties":
                component.set("v.isActiveDisputeBetweenParties", chValue);
                break;
            case "WriteoffFailure":
                component.set("v.isActiveWriteoffFailure", chValue);
                break;
            case "OtherKnowledge":
                component.set("v.isActiveOtherKnowledge", chValue);
                break;
            case "DebtorBookFunding":
                component.set("v.isActiveDebtorBookFunding", chValue);
                break;
            case "IndustryLegislation":
                component.set("v.isActiveIndustryLegislation", chValue);
                break;
            case "SuccessionPlanning":
                component.set("v.isActiveSuccessionPlanning", chValue);
                break;
            case "SupportApplication":
                component.set("v.isActiveSupportApplication", chValue);
                break;
        }
    },

    eventHandlerSelOpt: function (component, selValue, eventHit) {
        var gqQAndA = component.get("v.gqInfo");

        switch (selValue) {
            case "Limited - Fixed Amount":
                //this.initializeLimitOpt(component);
                component.set("v.isActiveFixedAmount", true);
                component.set("v.isActiveOther", false);
                if (eventHit) {
                    this.updateObjectData(component, gqQAndA);
                    this.populateGQQuestions(component, gqQAndA);
                }
                break;
            case "Limited - Other":
                //component.find("qqFixedAmount").set("v.value", "");
                component.set("v.isActiveFixedAmount", false);
                component.set("v.isActiveOther", true);
                if (eventHit) {
                    this.updateObjectData(component, gqQAndA);
                    this.populateGQQuestions(component, gqQAndA);
                }
                break;
            case "Unlimited":
                //this.initializeLimitOpt(component);
                //component.find("qqFixedAmount").set("v.value", "");
                component.set("v.isActiveFixedAmount", false);
                component.set("v.isActiveOther", false);
                if (eventHit) {
                    this.updateObjectData(component, gqQAndA);
                }
                break;
            case "None":
                component.set("v.isActiveFixedAmount", false);
                component.set("v.isActiveOther", false);
                if (eventHit) {
                    this.updateObjectData(component, gqQAndA);
                }
                break;
        }
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
        var toastEvent = this.getToast("Error: GeneralQualitativeInformation " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
});