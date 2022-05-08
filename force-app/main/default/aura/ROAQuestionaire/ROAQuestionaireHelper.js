({
    loadNextQuestion: function (component, event, helper) 
    {
        // Get the selected question and answer
        var selectedQuestion = event.getParam("questionId");
        var sequenceNumber = parseInt(event.getParam("sequenceNumber"));
        var selectedAnswer = event.getParam("answerId");
        var skipProductLoad = event.getParam("skipProductLoad");
        var previousStage = event.getParam("nextStage");
        var previousPossibleAnswers = event.getParam("possibleAnswers");
        var questionTracker = component.get("v.questionTracker");
        var action = component.get("c.getNextQuestion");
        var productType = component.get("v.initialAnswerId");
        action.setParams({
            answerId: selectedAnswer,
            currentQuestionId: selectedQuestion,
            possibleAnswers: previousPossibleAnswers,
            sequenceNumber: sequenceNumber,
            questionTracker: questionTracker
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            component.set("v.updating",false);
            component.set("v.CanNavigate", false);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var contextObject = JSON.parse(storeResponse);
                if(contextObject != null && contextObject.RecommendedProducts != null && productType == 'SAVINGS_OR_INVESTMENT')
                {
                    component.set("v.recommendedProducts", contextObject.RecommendedProducts);
                }

                if (contextObject.hasValue == false) {
                    if (previousStage == "POST_ROA") {
                        if (selectedQuestion == "POST_ROA_THE_ABSA_REPRESENTATIVE_IS_REGISTERED_TO_PROVIDE_ADVICE" && selectedAnswer == "") {
                            component.set("v.CanNavigate", false);
                            alert("Please answer all questions");
                        } else {
                            component.set("v.CanNavigate", true);
                        }
                        if (
                            selectedQuestion == "PACKAGES_DO_YOU_UNDERSTAND_THE_FINANCIAL_PRODUCT_YOU_WANT_TO_BUY" &&
                            selectedAnswer == "PACKAGES_NO_I_DONT_UNDERSTAND"
                        ) {
                            alert("Please explain the Features and  benefits of the product to the client again");
                            component.set("v.CanNavigate", false);
                        }
                        component.set("v.questionTracker", contextObject.QuestionTracker);
                        return;
                    }
                    return;
                }
                if (selectedQuestion == "PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY" && selectedAnswer == "PACKAGES_NO_I_CAN_NOT_AFFORD") {
                    component.set("v.CanNavigate", false);
                    return;
                }
                component.set("v.questionTracker", contextObject.QuestionTracker);
                if (contextObject.NextStage == "END_ROA" && skipProductLoad != "Y") {
                    var optionListItems = [];
                    var possibleAnswers = [];
                    for (var i = 0; i < contextObject.Answers.length; i++) {
                        var ans = contextObject.Answers[i];
                        optionListItems.push({ label: ans.AnswerText, value: ans.AnswerId });
                        possibleAnswers.push(ans.AnswerId);
                    }
                    component.set("v.possibleAnswers", possibleAnswers);
				console.log(`RECCOM Products: ${JSON.stringify(contextObject.RecommendedProducts)}`);
                    
                    $A.createComponent(
                        "c:CompleteProducts",
                        {
                            questionId: contextObject.QuestionId,
                            answerId: selectedAnswer,
                            sequenceNumber: sequenceNumber + 1,
                            recommendedProducts: contextObject.RecommendedProducts,
                            possibleAnswers: possibleAnswers,
                            productType: productType
                        },
                        function (newCmp) {
                            if (component.isValid()) {
                                var body = component.get("v.body");
                                body.push(newCmp);
                                component.set("v.body", body);
                            }
                        }
                    );
                } else {
                    var optionListItems = [];
                    var possibleAnswers = [];
                    for (var i = 0; i < contextObject.Answers.length; i++) {
                        var ans = contextObject.Answers[i];
                        optionListItems.push({ label: ans.AnswerText, value: ans.AnswerId });
                        possibleAnswers.push(ans.AnswerId);
                    }
                    component.set("v.possibleAnswers", possibleAnswers);
                    
                    if (contextObject.AnswerType == "checkbox") {
                        $A.createComponent(
                            "c:ROAQuestionCheckBoxGroup",
                            {
                                questionId: contextObject.QuestionId,
                                questionText: contextObject.QuestionText,
                                nextStage: contextObject.NextStage,
                                sequenceNumber: sequenceNumber + 1,
                                possibleAnswers: possibleAnswers
                            },
                            function (newCmp) {
                                if (component.isValid()) {
                                    newCmp.set("v.answerOptions", optionListItems);
                                    var body = component.get("v.body");
                                    body.push(newCmp);
                                    component.set("v.body", body);
                                }
                            }
                        );
                    } else {
                        $A.createComponent(
                            "c:ROAQuestionRadioGroup",
                            {
                                questionId: contextObject.QuestionId,
                                questionText: contextObject.QuestionText,
                                nextStage: contextObject.NextStage,
                                sequenceNumber: sequenceNumber + 1,
                                possibleAnswers: possibleAnswers
                            },
                            function (newCmp) {
                                if (component.isValid()) {
                                    newCmp.set("v.answerOptions", optionListItems);
                                    var body = component.get("v.body");
                                    body.push(newCmp);
                                    component.set("v.body", body);
                                }
                            }
                        );
                    }
                }
                if((contextObject.QuestionText == null ||contextObject.QuestionText == '')
                   && ((contextObject.NextStage == "END_ROA") || (contextObject.NextStage == "PRODUCT_TAKEUP")) && component.get("v.productIsSelected")){
                    component.set("v.CanNavigate", true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    removeFutureQuestions: function (component, event, helper) {
        var sequenceNumber = parseInt(event.getParam("sequenceNumber"));
        var body = component.get("v.body");
        if (body.length > sequenceNumber) {
            var questionTracker = component.get("v.questionTracker");
            var listOfQuestions = JSON.parse(questionTracker);
            for (var i = 0; i < listOfQuestions.length; i++) {
                if (
                    listOfQuestions[i].sequenceNumber > sequenceNumber ||
                    (listOfQuestions[i].sequenceNumber >= sequenceNumber && listOfQuestions[i].AnswerType != "checkbox")
                ) {
                    listOfQuestions.splice(i);
                }
            }
            var splicedListOfQuestions = JSON.stringify(listOfQuestions);
            component.set("v.questionTracker", splicedListOfQuestions);
            body.splice(sequenceNumber, body.length - sequenceNumber);
            component.set("v.body", body);
        }
    },
    
    OnNext: function (component, event, helper) {
        return new Promise(function (resolve, reject) {
            var IsSelected = component.get("v.productIsSelected");
            if (!IsSelected) {
                alert("Please select a product");
                reject("Failed");
            }
            var productType = component.get("v.initialAnswerId");
            var listOfQuestions = component.get("v.questionTracker");
            let action = component.get("c.getNewOpportunity");
            var recordId = component.get("v.recordId");
            var productId = component.get("v.productId");			
            var flowname = component.get("v.flowName");
            
            var listOfQuestions = component.get("v.questionTracker");
            action.setParams({
                accountID: recordId,
                productCode: productId,
                productType: productType,
                flowname: flowname,
                listOfQuestions: listOfQuestions
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    component.set("v.opportunityId", res["opportunityId"]);
                    component.set("v.applicationId", res["applicationId"]);
                    resolve("Continue");
                } else if (response.getState() === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert("Error message: " + errors[0].message);
                        }
                    }
                    reject("Failed");
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    //Added by Diksha 20/09/2021 for Voice as we didn't needed ROA questions 
    //so to hide Questions and to directly go to products
    getrecommendedProductsforVocie : function(component, event, helper) {
    var initialAnswerId = component.get('v.initialAnswerId');
    var action = component.get("c.getrecommendedProducts");
    action.setParams({
    'answerId' : initialAnswerId
});
action.setCallback(this, function(response) {
    var state = response.getState();
    if (state === "SUCCESS") {
        var recommendedProducts = response.getReturnValue();
        $A.createComponent("c:CompleteProducts", {
            "answerId" : initialAnswerId,
            "recommendedProducts" :recommendedProducts
        }, function(newCmp) {
            if (component.isValid()) {
                var body = component.get("v.body");
                body.push(newCmp);
                component.set("v.body", body);
            }
        });
    }
    else if (response.getState() === "ERROR") {
        var errors = response.getError();
        if(errors) {
            if(errors[0] && errors[0].message){
                alert("Error message: " + errors[0].message);
            }
        }
    }
    
})
$A.enqueueAction(action);

}

});