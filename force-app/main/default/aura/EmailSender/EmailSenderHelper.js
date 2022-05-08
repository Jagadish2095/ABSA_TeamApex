({
    getOpportunityLineItem : function(component) {
        console.log('caling.................');
        var action = component.get("c.getOppLineItems");
        action.setParams({
            'oppId': component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result.errorMessage != null && result.errorMessage != '' || result.errorMessage != undefined){
                    this.invoketostMessage(component,result.errorType,result.errorMessage,"sticky",true);                    
                }
                else{
                    var docs = [];
                    component.set("v.lineItemData", result);
                    for(var key in result.contentDocuments){
                        if(result.contentDocuments[key].FileType != 'SNOTE'){
                            docs.push(result.contentDocuments[key]);
                        }
                    }
                    component.set("v.noError",true);
                    component.set("v.douments",docs);
                }                
            }            
        });
        $A.enqueueAction(action);
    },
    
    invokeSendEmail : function(component,event) {
        var action = component.get("c.sendEmailtoCustomer"); 
        action.setParams({
            'lineItems': JSON.stringify(component.get("v.lineItemData")),
            'emailAddress' : event.getParam("toAddress")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.invoketostMessage(component,"success","Email has been sent successfully.","dismissable",true);
                $A.get("e.force:refreshView").fire();
            }
            else{
                this.invoketostMessage(component,"error","Email sent unsuccessfull.","sticky",true);
            }
        });
        $A.enqueueAction(action);
    },
    checkFieldValidations : function(component,event) {
        var messages = [];
        messages["noEmail"] = "Primary email address was not found. Please update in accounts.";
        messages["noSalutation"] = "Salutation/Title was not found. Please update in accounts.";
        messages["notValidStage"] = "Opportunity status should be \'Recommendation Stage\'.";
        let docTypes = component.get("v.oppRecord");
        if(docTypes.Account.Salutation === null || docTypes.Account.Salutation === '' || docTypes.Account.Salutation === undefined){
            this.invoketostMessage(component,"warning",messages["noSalutation"],"sticky",true);
        }
        else if(docTypes.Account.PersonEmail === null || docTypes.Account.PersonEmail === '' || docTypes.Account.PersonEmail === undefined){
            this.invoketostMessage(component,"warning",messages["noEmail"],"sticky",true);
        }
            else if(docTypes.Sub_Status__c != 'Recommendation Stage'){
                this.invoketostMessage(component,"warning",messages["notValidStage"],"sticky",true);
            }
                else{
                    this.getOpportunityLineItem(component);
                }
    },
    invoketostMessage : function(component,typeText,userMessage,modelMode,closeQuickAction){
        if(closeQuickAction === true){
            $A.get("e.force:closeQuickAction").fire();
        }
        component.find('notifLib').showToast({
            variant: typeText,
            message: userMessage,
            mode: modelMode
        });
    }
})