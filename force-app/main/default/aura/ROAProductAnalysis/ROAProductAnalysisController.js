({
    init : function(component, event, helper) 
    {
       var lstrecommendedProducts = component.get("v.recommendedProducts");
        var lstselectedProducts = component.get("v.selectedProducts");        
        var recordId = component.get("v.recordId");
        var listType = component.get('v.questionListType');
        //debugger;
        var recommendedProducts = lstrecommendedProducts.split('\,');
        var selectedProducts = lstselectedProducts.split('\,');
        var questionId='Which Product(s) and Product Features were shortlisted for the Entity?';
        helper.setUpControls(component, event, helper,recommendedProducts,questionId,true);
        questionId='Which Product(s) and Product Features was selected for the Entity?';
        helper.setUpControls(component, event, helper,selectedProducts,questionId,false);
        helper.getROAQuestionnaireApplication(component, event, helper);         
        helper.knockoutHelper(component,listType);
    },
    
    confirmProductSelection: function(cmp, evt) {        
        cmp.set("v.CanNavigate", true); 
        var selected = cmp.get("v.consentVal");
        cmp.set("v.showTextArea", true);        
    },
    
    handleNavigate: function(component, event, helper) {       
        component.set('v.updating', true);
        var navigate = component.get("v.navigateFlow");
        var actionClicked = event.getParam("action");
        switch(actionClicked) {
            case "NEXT":
            case "FINISH":
                var promise = helper.OnNext(component, event, helper)
                .then(
                    $A.getCallback(function(result){                                
                    navigate(actionClicked);
                    }),
                                  /* {
                                       var promise = helper.generateDocuments(component, event, helper)
                                       .then(
                                           $A.getCallback(function(result) {                                
                                               navigate(actionClicked);
                                           }),
                                           $A.getCallback(function(error) {
                                               component.set('v.updating', false);
                                           })
                                       )
                                       
                                       }),*/
                    $A.getCallback(function(error) {
                        component.set('v.updating', false);
                    })
                )
                break;
            case "BACK":
            case "PAUSE":
                component.set('v.updating', false);
                navigate(event.getParam("action"));
                break;
        }
    }
})