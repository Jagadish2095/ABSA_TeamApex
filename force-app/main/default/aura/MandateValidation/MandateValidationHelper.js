({
	showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        component.set("v.HideSpinner" , true);
        //$A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        component.set("v.HideSpinner" , false);
        //$A.util.addClass(spinner, "slds-hide");
    },
    getToast : function(title, msg, type) {

		 var toastEvent = $A.get("e.force:showToast");

            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });

        return toastEvent;
    },
    getQnA : function(component) {
        this.showSpinner(component);
        var idNumber = component.get("v.idNumber");
        var surname = component.get("v.surname");

        console.log('ID Number-----------------> ' + idNumber);
        console.log('Surname ------------------> ' + surname);
        var action = component.get("c.getQuestions");  //get all question and answers
        action.setParams({
            accountNumber : idNumber,
            surname : surname
        });

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('xds response state---'+state);
            if (component.isValid() && state === "SUCCESS") {
                var responseBean1 = response.getReturnValue();
                console.log('response bean---'+JSON.stringify(responseBean1 ));

                if(responseBean1.errorMessage != null  && responseBean1.errorMessage != '' ){  //check error message  from service
                    component.set("v.xdsDecision",false);
           			component.set("v.isshowError",true);
                    component.set("v.xdsMessage",responseBean1.errorMessage );
                    this.hideSpinner(component);
                }else if(responseBean1.StatusCode == 500){ // error in service calling/or service is not up
                    component.set("v.xdsDecision",false);
                    component.set("v.isshowError",true);
                    component.set("v.xdsMessage",responseBean1.Message);
                    this.hideSpinner(component);
                }else if(responseBean1.isUserBlocked == true){ // is user is blocked
                    component.set("v.xdsDecision",false);
                    component.set("v.isshowError",true);
                    component.set("v.xdsMessage",'something went wrong user is blocked.' );
                } else{
                    component.set("v.xdsDecision",true);
                    component.set("v.isshowError",false);

                    component.set("v.responseBean", responseBean1);
                    console.log('responseBean1.questions-----'+responseBean1.questions);
                    this.hideSpinner(component);
                    if(responseBean1.questions != null){
                        component.set("v.showVerifyButton",false);
                    }
                }
            }

        });
        $A.enqueueAction(action);
    },

    setAnswers: function(component) {

        this.showSpinner(component);
        var requestBeanForVerification = component.get("v.requestBeanForVerification");
        var isSendAnswer;
        var questNoAnswered;

        if(requestBeanForVerification != null){
              // validations to check if all questions are answered
            for(var i=0;i<requestBeanForVerification.questions.questionDocument.length;i++ ){
                var quest = requestBeanForVerification.questions.questionDocument[i];
                var flag;
                for(var j =0;j<quest.answers.answerDocument.length ;j++ ){
                    var ans = quest.answers.answerDocument[j];
                    if(ans.isEnteredAnswerYN ){
                        flag = ans.isEnteredAnswerYN;
                        break;
                    }else{
                        flag = ans.isEnteredAnswerYN;
                    }
                }
                if(flag ){
                    isSendAnswer = true;

                    continue;
                }else{
                    isSendAnswer = false;
                    questNoAnswered = JSON.stringify(quest.question);
                    break;
                }
            }
            if(!isSendAnswer){
                var toastEvent = this.getToast("Error", "Please select answer for Question: "+questNoAnswered, "error");
                toastEvent.fire();
            }else{
                 requestBeanForVerification.processAction = 'Authenticate';  // add authenticate
                 delete requestBeanForVerification.StatusCode;  // delete extra param from paylaod
                 delete requestBeanForVerification.StatusMessage;
                 delete requestBeanForVerification.Message;
                 delete requestBeanForVerification.enquiryid;
                delete requestBeanForVerification.enquiryresultid;
                console.log('requestBeanForVerificationString12--- Message'+JSON.stringify(requestBeanForVerification));

                var action = component.get("c.verifyClient");
                action.setParams({
                    requestBeanForVerificationString :JSON.stringify(requestBeanForVerification)  // send asnwer to xds system back
                });
                // Add callback behavior for when response is received
                action.setCallback(this, function(response) {

                    var state = response.getState();

                    console.log('response state---'+state);

                    if (component.isValid() && state === "SUCCESS") {

                        var result = response.getReturnValue();

                        console.log("result---"+JSON.stringify(result));

                        if(result.authStatus == "Successful"){  // xds decision

                            component.set("v.xdsDecision",true);
                            component.set("v.isshowError",false);
                            component.set("v.showAuthenticated",true);
                            component.set("v.showVerifyButton",true);
                            component.set("v.xdsMessage",'User authenticated! Please click Next button continue.');

                        }else{
                            component.set("v.xdsDecision",false);
                            component.set("v.isshowError",true);
                            component.set("v.showVerifyButton",true);

                            component.set("v.xdsMessage",result.message);
                        }

                    }

                });
                $A.enqueueAction(action);
            }
        }else{
            var toastEvent = this.getToast("Error", "Please select answer for Questions", "error");
            toastEvent.fire();
        }
         this.hideSpinner(component);
    }
})