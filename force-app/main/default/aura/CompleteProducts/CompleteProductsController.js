({
    init: function(cmp, event, helper) 
    {
        cmp.set('v.validate', function() 
                {
                    cmp.find("CompleteProduct").submit();
                })

        var Products = cmp.get("v.recommendedProducts");
        Products = Products.toString();
        console.log(`recommendedProducts : ${Products}`);
		var productType = cmp.get("v.productType");
        var getProductsAction = cmp.get("c.getProductDetails");
		if(productType =='SAVINGS_OR_INVESTMENT')
        {
             cmp.set("v.interestRate", true);
        }
        getProductsAction.setParams({
            Products: Products
        });
        
        getProductsAction.setCallback(this,function(response){
            var state = response.getState();
        	if(cmp.isValid && state==="SUCCESS") {
                var returnResponse = response.getReturnValue();
                console.log(`returnResponse : ${JSON.stringify(returnResponse)}`);
                console.log('returnResponse1 : ' + returnResponse);

                cmp.set("v.lstProducts", returnResponse);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                       
            }
        });
        $A.enqueueAction(getProductsAction);
    },
       
    handleSectionToggle: function (cmp, event) {
        var prodselected = true;
        var prodid = event.target.dataset.prodid;
        var checkboxes = cmp.find("productLineCheckbox");
        for(var i=0; i < checkboxes.length; i++) {
            var checkboxName = checkboxes[i].get("v.name");
            if (checkboxName == prodid) {
                checkboxes[i].set("v.checked", true);
            } else {
                checkboxes[i].set("v.checked", false);
            }
        }
        
        var compEvent = cmp.getEvent("roaProductSelectionEvent");
        compEvent.setParams({
            "productId": prodid,
            "productIsSelected" : prodselected
        });  
        compEvent.fire();

        var questionId = cmp.get("v.questionId");
        var selectedAnswer = cmp.get("v.answerId");
        var sequenceNumber = parseInt(cmp.get("v.sequenceNumber"));
        var possibleAnswers = cmp.get("v.possibleAnswers");
        var compEvent2 = cmp.getEvent("roaQuestionaireSelectionEvent");
        compEvent2.setParams({
            "questionId" : questionId,
            "answerId": selectedAnswer,
            "sequenceNumber" : sequenceNumber,
            "skipProductLoad" : "Y",
            "possibleAnswers" : possibleAnswers
        });            
        compEvent2.fire();      
    }
    
 })