({
    setUpControls: function (component, event, helper,lstProducts,questionId,isRecProducts) 
    {
         var recommendedProductValues = [];
        var possibleAnswers = [];
        for (var i = 0; i < lstProducts.length > 0; i++) {
            var lstProductsRep = lstProducts[i].replace('_',' ');
            lstProductsRep = lstProductsRep.replace('_',' ');
            recommendedProductValues.push({ label: lstProductsRep, value: lstProductsRep });
            possibleAnswers.push(lstProductsRep);
           }
        if(isRecProducts)
        {
            component.set("v.recProductsOptions", recommendedProductValues);
        }
        else
        {
            component.set("v.selectedProductsOptions", recommendedProductValues);
            component.set("v.selectedProductsValue", possibleAnswers);
        } 
    },
    getROAQuestionnaireApplication: function (component, event, helper) 
    {
        var applicationId = component.get("v.applicationId");
        var recordId = component.get("v.recordId");
        var action = component.get("c.getROAQuestionnaire");
        action.setParams({
            "applicationId": applicationId,
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue(); 
                component.set("v.questionTracker",resp);
                if(resp == ''){
                    component.set("v.understandFeat", true);
                }
                
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
	
     knockoutHelper : function(component,listType) {
        // call the apex class method 
        var action = component.get("c.fetchKnockoutQuestion");
        // set param to method  
        action.setParams({
            'listType' : listType
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // set questionList with return value from server.
                component.set("v.questionList", storeResponse);
            }
            else{
                response.getError();
                var errorTxt;
                console.log('errors',errors);
                if(errors) {
                    var errorMsgs = [];
                    for(var index in errors) {
                        errorMsgs.push(errors[index].message);
                    }            
                    errorTxt = errorMsgs.join('<br/>');
                } else {
                    errorTxt = 'Something went wrong!';
                }
                component.set("v.Message", errorTxt);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },
    generateDocuments : function(component, helper) {
    return new Promise(function(resolve, reject) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.productCode");
        var action = component.get("c.callGenerateDocs");
        action.setParams({
            "oppId" : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnValue = response.getReturnValue();
            component.set("v.showSpinner", false);
            if(state == "SUCCESS"){
                resolve(returnValue);
            }else{
                reject(returnValue);
            }
        });
        $A.enqueueAction(action);
    })
    },
     generateDocumentsForRelated : function(component, helper) {
    return new Promise(function(resolve, reject) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.productCode");
        var action = component.get("c.callGenerateDocsForRelatedParty");
        action.setParams({
            "oppId" : recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var returnValue = response.getReturnValue();
            component.set("v.showSpinner", false);
            if(state == "SUCCESS"){
                resolve(returnValue);
            }else{
                reject(returnValue);
            }
        });
        $A.enqueueAction(action);
    })
    },
	OnNext: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
            
            var productType = component.get("v.initialAnswerId");
            var listOfQuestions = component.get("v.questionTracker");            
            var motivationArea = component.find('motivationArea');
            var motivationAreaValue = motivationArea.get("v.value");
            var productVal = component.get("v.productVal");
             var questionList = component.get("v.questionList");
            var knockoutQuestionResult = component.get("v.knockoutQuestionResult");
            if ( motivationAreaValue == '') {
                component.find('branchFlowFooter').set('v.heading', 'Product Details');
                component.find('branchFlowFooter').set('v.message', 'Please enter Reason for Product selection');
                component.find('branchFlowFooter').set('v.showDialog', true);
               reject('Failed');
            }                
            var listOfQuestionsNew = [];//JSON.parse(listOfQuestions);
            var sequenceNumberNew = 1;
          //  for (var i = listOfQuestionsNew.length - 1; i < listOfQuestionsNew.length; i++) {
               // sequenceNumberNew =  listOfQuestionsNew[i].sequenceNumber + 1
           // }
            
            var lstrecommendedProducts = component.get("v.recommendedProducts");
            var lstselectedProducts = component.get("v.selectedProducts");
            var recommendedProducts = lstrecommendedProducts.split('\,');
            var selectedProducts = lstselectedProducts.split('\,');
        
            var allRecommendedProducts ='';
            for (var i = 0; i < recommendedProducts.length > 0; i++) 
            {
                var lstrecommendedProducts = recommendedProducts[i].replace('_',' ');
                lstrecommendedProducts = lstrecommendedProducts.replace('_',' ');
                allRecommendedProducts = allRecommendedProducts + ' ' + lstrecommendedProducts + ' ';
            }
            listOfQuestionsNew.push({AnswerId: allRecommendedProducts ,AnswerType: 'dropdown',IsSelected:true, 
                                     QuestionId: 'Which Product(s) and Product Features were shortlisted for the Entity?'
                                     , RecommendedProducts: null, sequenceNumber: sequenceNumberNew});
            
            sequenceNumberNew = sequenceNumberNew + 1;                
             var allSelectedProducts ='';
            for (var i = 0; i < selectedProducts.length > 0; i++) 
            {
                var lstSelectedProduct = selectedProducts[i].replace('_',' ');
                lstSelectedProduct = lstSelectedProduct.replace('_',' ');
                allSelectedProducts = allSelectedProducts + ' ' + lstSelectedProduct + ' ';
            }
            listOfQuestionsNew.push({AnswerId: allSelectedProducts ,AnswerType: 'dropdown',IsSelected:true, 
                                     QuestionId: 'Which Product(s) and Product Features was selected for the Entity?'
                                     , RecommendedProducts: null, sequenceNumber: sequenceNumberNew});
            sequenceNumberNew = sequenceNumberNew + 1;
            listOfQuestionsNew.push({AnswerId: productVal,AnswerType: 'dropdown',IsSelected:true, 
                                     QuestionId: 'Do you understand the feature and benefits of the financial product that you want to apply for?'
                                     , RecommendedProducts: null, sequenceNumber: sequenceNumberNew});           
            
            //Reason for Product selection
            sequenceNumberNew = sequenceNumberNew + 1;
            listOfQuestionsNew.push({AnswerId: motivationAreaValue,AnswerType: 'dropdown',IsSelected:true, 
                                     QuestionId: 'Reason for Product selection', RecommendedProducts: null
                                     , sequenceNumber: sequenceNumberNew});
             //knockout Questions
            sequenceNumberNew = sequenceNumberNew + 1;
            listOfQuestionsNew.push({AnswerId: knockoutQuestionResult,AnswerType: 'dropdown',IsSelected:false, 
                                     QuestionId: questionList
                                     , RecommendedProducts: null, sequenceNumber: sequenceNumberNew});
            listOfQuestions = JSON.stringify(listOfQuestionsNew);
            
            var applicationId = component.get("v.applicationId");
            var recordId = component.get("v.recordId");
             component.set("v.knockoutQuestionResult",listOfQuestions);
            resolve("Continue");
		});
        
	}
});