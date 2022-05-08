({
    doInit: function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Power of Attorney type', fieldName: 'PAType', type: 'text'},
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Id Type', fieldName: 'idType', type: 'text'},
            {label: 'Id Number', fieldName: 'idNbr', type: 'text'},
            {label: 'Signature', fieldName: 'signature', type: 'text'},
            {label: 'Customer', fieldName: 'customer', type: 'text'},
            {label: 'May Collect Cheque', fieldName: 'consentCollChqsInd', type: 'text'}
        ]);    
        helper.getAccountHelper(component, event, helper);  
    },
    initComp: function(component, event, helper) {
        //Get Questions and Answer From XDS 
        helper.getQnA(component); 
    },
    onChangePOWTabSelection: function(component, event, helper) {
        component.set("v.byPassXDS",false);
        
        if ('POAverification' === event.getParam('id')) {
            component.set("v.data",[]);
            
            helper.getAccountProductsHelper(component, event, helper);
            
        }
    },
    onAccountSelect: function(component, event, helper) {
        
        component.set("v.data",[]);
        component.find("PASelect").set("v.value",'all');
        if(component.get("v.selectedAccountNumber") != ''){
            helper.getGeneralPAHelper(component, event, helper);    
            helper.getSpecialPAHelper(component, event, helper);
        }else{
            component.set("v.specialPAList",null);
            component.set("v.generalPAList",null);
        }
    },
    handleChange: function(component, event, helper) {
        helper.showSpinner(component);
        var question = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");
        
        if(selectedValue == '-Please Select-'){
            helper.getToast("Error", "Please select proper answer", "error");
            
        }
        var requestBeanForVerification1 = component.get("v.requestBeanForVerification");
        if(!requestBeanForVerification1){
            
            requestBeanForVerification1 = component.get("v.responseBean");
        }
        requestBeanForVerification1.questions.questionDocument.forEach(function(quest){
            
            if(quest.question == question){
                
                quest.answers.answerDocument.forEach(function (ans){
                    
                    if(ans.answer == selectedValue && ans.isEnteredAnswerYN == false){
                        
                        ans.isEnteredAnswerYN = true;
                    }
                    else{
                        ans.isEnteredAnswerYN = false;
                    }
                });
            }
        });
        
        component.set("v.requestBeanForVerification",requestBeanForVerification1);
        helper.hideSpinner(component);
    },
    sendAnswers: function(component, event, helper) {
       // helper.showSpinner(component);
        helper.setAnswers(component);
        
    },
    handleXDSbyPass: function (component, event) {
        
        var xdsBypassChecked = component.get("v.byPassXDS");
        
        var action = component.get("c.logXDSBypass");
        
        action.setParams({
            caseRecId : component.get("v.caseId"),
            bypassChecked : xdsBypassChecked
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var result = response.getReturnValue();
                
                if(xdsBypassChecked == true){
                    
                    component.set("v.byPassXDSBy", result.xdsBypassBy);  
                    component.set("v.byPassXDSDate", result.xdsBypassDate);
                    component.set("v.showVerifyButton", false);
                    component.set("v.xdsDecision", true);  
                    component.set("v.isshowError", false);
                    component.set("v.xdsMessage",'User authenticated! Please click Next button continue.');
                    
                }else{
                    
                    component.set("v.byPassXDSBy", null);
                    component.set("v.byPassXDSDate", null);
                    component.set("v.showVerifyButton", true);
                    component.set("v.xdsDecision", false);
                }
            }
            
        });  
        
        $A.enqueueAction(action);         
        
    },
    
    handleXDSMandatebyPass : function (component, event) {
        var xdsBypassMandateChecked = component.get("v.byPassXDSMandate");
        
        if(xdsBypassMandateChecked){
            
            component.set("v.xdsDecision", true);
        }else{
            component.set("v.xdsDecision", false);
        }
    },
    
    resetTableData: function (component, event) {
        var selectedValue = event.getSource().get("v.value");
        var data = [];
        if(selectedValue == 'all'){
            if(component.get("v.generalPAList") != null) data.push(component.get("v.generalPAList")); 
            if(component.get("v.specialPAList") != null) data.push(component.get("v.specialPAList"));
        }else if(selectedValue == 'general'){
            if(component.get("v.generalPAList") != null) data.push(component.get("v.generalPAList"));            
        }else if(selectedValue == 'special'){
            if(component.get("v.specialPAList") != null)  data.push(component.get("v.specialPAList"));            
        }
        component.set("v.data",data);
    },
    getSelectedName: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedRows",selectedRows);
    },
    verifySelected: function (component, event,helper) {
        helper.getQuestionsHelper(component, event,helper);
    },
    setSelectedAnswer : function (component, event,helper) {
        helper.showSpinner(component);
        var ChangeQuestion = event.getSource().get("v.name");
        var selectedValue = event.getSource().get("v.value");
        
        if(selectedValue == '-Please Select-'){
            helper.getToast("Error", "Please select proper answer", "error");
            
        }
        var questionResponse = component.get("v.questionResponse");
        questionResponse.questions.questionDocument.forEach(function(question){
            if(question.question == ChangeQuestion){                
                question.answers.answerDocument.forEach(function (ans){                    
                    if(ans.answer == selectedValue && ans.isEnteredAnswerYN == false){                        
                        ans.isEnteredAnswerYN = true;
                    }
                    else{
                        ans.isEnteredAnswerYN = false;
                    }
                });
            }
        });
        
        component.set("v.questionResponse",questionResponse);
        helper.hideSpinner(component);
        
    },
    submitAnswers: function (component, event,helper){
        helper.submitAnswersHelper(component);  
    },
        
       navigateToForm : function(component, event, helper ) {
        
        var evt = $A.get("e.force:navigateToComponent");
        
        //alert(myComponent);
        
            evt.setParams({
                componentDef : "c:ABSA_EditAccountDetails",
                componentAttributes: {
                  recordId : component.get("v.recordId")
                }
        });
        
        evt.fire();
    }
})