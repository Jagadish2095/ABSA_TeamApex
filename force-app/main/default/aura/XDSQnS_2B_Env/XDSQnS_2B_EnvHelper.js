({
    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    //Lightning toastie
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        toastEvent.fire();
    },
    getQnA : function(component) {
        this.showSpinner(component);
        var action = component.get("c.getQuesAndAnsList");  //get all question and answers
        action.setParams({
           accountId : component.get("v.recordId") // accountId to get SA Identity number
          
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('xds response state---'+state);
            if (component.isValid() && state === "SUCCESS") {
                var responseBean1 = response.getReturnValue();
                console.log('response bean---'+JSON.stringify(responseBean1 ));
                debugger;
                if(responseBean1.errorMessage != null  && responseBean1.errorMessage != '' ){  //check error message  from service
                    component.set("v.xdsDecision",false);
                    component.set("v.isshowError",true); 
                 //Update SF field  

                    
                    //ending
                    component.set("v.xdsMessage",responseBean1.errorMessage );              
                    
                }else if(responseBean1.StatusCode == 500){ // error in service calling/or service is not up
                    component.set("v.xdsDecision",false);
                    component.set("v.isshowError",true);  
                    component.set("v.xdsMessage",responseBean1.Message);
                }else if(responseBean1.isUserBlocked == true){ // is user is blocked
                    console.log('Blocked Status>>>>>>' + component.set('v.accountRecord.AuthMessage__c','BLOCKED'));
                    component.set("v.xdsDecision",false);
                    component.set("v.isshowError",true);  
                    component.set("v.xdsMessage",'something went wrong user is blocked.' );
                } else{
                    //component.set("v.xdsDecision",true);
                    component.set("v.isshowError",false);  
                    
                    component.set("v.responseBean", responseBean1);
                    console.log('responseBean1.questions-----'+responseBean1.questions);
                    if(responseBean1.questions != null){
                        component.set("v.showVerifyButton",false); 
                    }
                }
            }
             this.hideSpinner(component);
        });     
        $A.enqueueAction(action);
    },

   // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
       // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
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
                this.getToast("Error", "Please select answer for Question: "+questNoAnswered, "error");
                
            }else{
                requestBeanForVerification.processAction = 'Authenticate';  // add authenticate
                delete requestBeanForVerification.StatusCode;  // delete extra param from paylaod
                delete requestBeanForVerification.StatusMessage;       
                delete requestBeanForVerification.Message;
                delete requestBeanForVerification.enquiryid;
                delete requestBeanForVerification.enquiryresultid;
                console.log('requestBeanForVerificationString12--- Message'+JSON.stringify(requestBeanForVerification));
                
                var action = component.get("c.verifyClientXDS");
                action.setParams({
                    requestBeanForVerificationString :JSON.stringify(requestBeanForVerification),  // send asnwer to xds system back
                    accountId : component.get("v.recordId") // accountId to get SA Identity number
                });
                // Add callback behavior for when response is received
                action.setCallback(this, function(response) {
                    
                    var state = response.getState();
                    
                    console.log('response state---'+state);
                    
                    if (component.isValid() && state === "SUCCESS") {
                        
                        var result = response.getReturnValue();
                        
                        console.log("result---"+JSON.stringify(result));
                        
                        if(result.authStatus == "Authenticated" || result.authStatus =="Successful"){  // xds decision
                            
                            component.set("v.xdsDecision",true);  
                            component.set("v.isshowError",false);
                            component.set("v.showAuthenticated",true);
                            component.set("v.showVerifyButton",true);
                            component.set("v.xdsMessage",'User authenticated Successfully!');
                            
                        }else{
                            component.set("v.xdsDecision",false);
                            component.set("v.isshowError",true);  
                            component.set("v.showVerifyButton",true);
                            
                            component.set("v.xdsMessage",result.message);
                        }
                        
                    }
                     this.hideSpinner(component); 
                }); 
                $A.enqueueAction(action);
            }  
        }else{
            this.getToast("Error", "Please select answer for Questions", "error");
            
        }
          
    },
    getAccountHelper: function(component, event, helper){
        var getAccountName = component.get("c.getAccountName");  
        getAccountName.setParams({
            accountId : component.get("v.recordId") 
        });
        getAccountName.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountName", response.getReturnValue());
            }
        });
        $A.enqueueAction(getAccountName);
    },
    
    getAccountProductsHelper : function(component, event, helper){
        this.showSpinner(component);
        debugger;
        var getAccountProducts = component.get("c.getAccountProducts");  
        getAccountProducts.setParams({
            accountId : component.get("v.recordId") 
        });
        getAccountProducts.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                
                // if storeResponse size is equal 0 ,display No Result Found... message on screen. 
                if (storeResponse.length == 0) {
                    this.getToast("Error", 'No Result Found...Please try again !!!', "error");  
                } else {
                    storeResponse.sort();
                    component.set("v.listOfSearchRecords", storeResponse);
                }
                // set searchResult list with return value from server.
                
            }
            this.hideSpinner(component); 
        });
        $A.enqueueAction(getAccountProducts);
        
    },
    getGeneralPAHelper : function(component, event, helper){
        this.showSpinner(component);
        debugger;
        var getGeneralPA = component.get("c.getGeneralPA");  
        getGeneralPA.setParams({
            accountnumber : component.get("v.selectedAccountNumber")
        });
        getGeneralPA.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.statusCode == 200 ){
                    if(result.CIgetGeneralPowerOfAttorneyV4Response.nbsmsgo3.msgEntry[0].msgErrInd == 'E'){
                        this.getToast("Error", 'General Power of Attorney : '+result.CIgetGeneralPowerOfAttorneyV4Response.nbsmsgo3.msgEntry[0].msgTxt, "error");  
                    }else{
                        var responsefinaltable = result.CIgetGeneralPowerOfAttorneyV4Response.cip081do.outputTable;
                        responsefinaltable.PAType = "General Power of Attorney";
                        responsefinaltable.customer = component.get("v.accountName");
                        component.set("v.generalPAList",responsefinaltable);
                        var data  = component.get("v.data");
                        data.push(responsefinaltable);
                        component.set("v.data",data);
                        
                    }
                }else{                      
                    this.getToast("Error", 'General Power of Attorney : '+result.StatusMessage, "error");
                } 
            }
            this.hideSpinner(component); 
        });
        $A.enqueueAction(getGeneralPA);
        
    },
    getSpecialPAHelper : function(component, event, helper){
        this.showSpinner(component);
        var getSpecialPA = component.get("c.getSpecialPA");  
        getSpecialPA.setParams({
            accountnumber : component.get("v.selectedAccountNumber") 
        });
        getSpecialPA.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.statusCode == 200 ){
                    if(result.CIgetSpecialPowerOfAttorneyV4Response.nbsmsgo3.msgEntry.msgErrInd == 'E'){
                        this.getToast("Error", 'Special Power of Attorney : '+result.CIgetSpecialPowerOfAttorneyV4Response.nbsmsgo3.msgEntry.msgTxt, "error");  
                    }else{
                        
                        var responsefinaltable = result.CIgetSpecialPowerOfAttorneyV4Response.cip080do.outputTable;
                        debugger;
                        responsefinaltable.PAType = "Special Power of Attorney";
                        responsefinaltable.customer = component.get("v.accountName");
                        component.set("v.specialPAList",responsefinaltable);
                        var data  = component.get("v.data");
                        data.push(responsefinaltable);
                        component.set("v.data",data);
                    }
                }else{                      
                    this.getToast("Error", 'Special Power of Attorney : '+result.StatusMessage, "error");
                }
            }
            this.hideSpinner(component); 
        });
        $A.enqueueAction(getSpecialPA);
        
        
    },
    getQuestionsHelper: function(component, event,helper){
        component.set("v.isQuestionsShow", false);
        this.showSpinner(component);
        component.set("v.showSpinner", true);
        var getQuestions = component.get("c.getQuestions");  
        getQuestions.setParams({
            accountNumber : component.get("v.selectedRows")[0].idNbr, surname : component.get("v.selectedRows")[0].surname
            //accountNumber : "5702270227081", surname : "SWART"
            
        });
        getQuestions.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                debugger;
                if(result.StatusCode == 200 ){
                    if(result.errorMessage != '' && result.errorMessage != undefined){
                        component.set("v.xdsDecision",false);
                        
                        this.getToast("Success", result.StatusMessage, "success");
                        
                    }else{
                        component.set("v.questionResponse", result);
                        component.set("v.isQuestionsShow", true); 
                        //component.set("v.xdsDecision",true);
                    }
                }else{
                    component.set("v.xdsDecision",false);                      
                    this.getToast("Error", result.StatusMessage, "error");
                }
            }
            this.hideSpinner(component); 
        });
        $A.enqueueAction(getQuestions);        
    },
    submitAnswersHelper: function(component, event,helper){
        
        
        
        this.showSpinner(component);
        var requestBeanForVerification = component.get("v.questionResponse");
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
                this.getToast("Error", "Please select answer for Question: "+questNoAnswered, "error");
                
            }else{
                requestBeanForVerification.processAction = 'Authenticate';  // add authenticate
                delete requestBeanForVerification.StatusCode;  // delete extra param from paylaod
                delete requestBeanForVerification.StatusMessage;       
                delete requestBeanForVerification.Message;
                delete requestBeanForVerification.enquiryid;
                delete requestBeanForVerification.enquiryresultid;
                console.log('requestBeanForVerificationString12--- Message'+JSON.stringify(requestBeanForVerification));
                
                var action = component.get("c.verifyClientXDS");
                action.setParams({
                    requestBeanForVerificationString :JSON.stringify(requestBeanForVerification),  // send asnwer to xds system back
                    accountId : component.get("v.recordId") // accountId to get SA Identity number
                });
                // Add callback behavior for when response is received
                action.setCallback(this, function(response) {
                    
                    var state = response.getState();
                    if (component.isValid() && state === "SUCCESS") {  
                        
                        var result = response.getReturnValue();                        
                        if(result.authStatus == "Authenticated"){  
                            this.getToast("Success", 'User authenticated! Please click Next button continue.', "success");
                            component.set("v.isQuestionsShow", false); 
                            component.set("v.xdsDecision",true);
                        }else if(result.authenticationStatus =="Successful"){
                            this.getToast("Sucess", result.authenticationStatus + ' : '+result.authenticationStatus, "success");
                        } else{
                            component.set("v.xdsDecision",false);
                            this.getToast("Error", result.message + ' : '+result.errorMessage, "error");
                        }                        
                    }
                }); 
                $A.enqueueAction(action);
            }  
        }else{
            this.getToast("Error", "Please select answer for Questions", "error");           
        }
        this.hideSpinner(component); 
    }
    
})