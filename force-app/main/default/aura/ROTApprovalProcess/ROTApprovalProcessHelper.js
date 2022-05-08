({
    submit : function(component, event, helper){
        var caseRecord = component.get("v.caseRecord");
        if(caseRecord.ROT_Approval_Stage__c == null || caseRecord.ROT_Approval_Stage__c == 'Leg 1'){
            helper.submitForApproval(component, event, helper);
        }
        else if(caseRecord.ROT_Approval_Stage__c == 'Leg 2'){
            helper.validate(component, event, helper);
        }
        
    },
    
    submitForApproval : function(component, event, helper) {
        window.scrollTo(0, 0);
        component.set("v.showSpinner", true);
        var action = component.get("c.submitROTApprovalProcess");
        
        action.setParams({
            "caseId": component.get("v.recordId"),
            "caseRecord" : component.get("v.caseRecord")
        });
        
        action.setCallback(this, function(response) {
            
            if (response.getState() == "SUCCESS") {
                component.set("v.showSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Success!",
                    "type" : "success",
                    "message" : "Approval Request submitted Successfully",
                    "mode" : "dismissible"
                    
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire(); 
                //window.location.reload();
            } 
            
            else if(response.getState() == "ERROR"){
                component.set("v.showSpinner", false);
                var errors = response.getError();
                console.log(' Error : [' + JSON.stringify(errors) + ']');
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title" : "Error!",
                    "type" : "error",
                    "message" : 'ROT Approval Request failed to submit. ' +errors[0].message,
                    "mode" : "dismissible"
                });
                toastEvent.fire();
            } 
                else {
                    component.set("v.showSpinner", false);
                    console.log('Failed.');
                }
            
        });
        $A.enqueueAction(action);
    },
    
    validate : function(component, event, helper){
        var action = component.get("c.validateRequest");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            if (response.getState() == "SUCCESS") {
                var res = response.getReturnValue();
                var restrictions =res.groupRestrictions;
                var documents =res.documents;
                var indemnityFormCount = 0;
                var resolutionFormCount = 0;
                var restrictionCount = 0;
                var customerCount = 0;
                var accountsCount = 0;
                var transactionTypesCount = 0;
                console.log('restrictions before '+JSON.stringify(restrictions));
                for(var i=0; i<documents.length; i++){
                    if(documents[i].ContentDocument.Title.toUpperCase().includes('INDEMNITY')){
                        indemnityFormCount++;
                    }
                    else if(documents[i].ContentDocument.Title.toUpperCase().includes('RESOLUTION')){
                        resolutionFormCount++; 
                    }
                }
                for(var j =0;j<restrictions.length ;j++){
                    var data =restrictions[j];
                        var customers = data.customers != undefined ? data.customers.length : 0;
                        var accounts = data.accounts != undefined ? data.accounts.length : 0;
                        var transactions = data.transactionTypes != undefined ? data.transactionTypes.length : 0;
                    	if(data.restriction != undefined){
                        	restrictionCount++;
                        }
                        if( customers > 0){
                            customerCount++;
                        }
                        if( accounts > 0){
                            accountsCount++;
                        }
                        if(transactions > 0){
                            transactionTypesCount++;
                        } 
                }
                if(customerCount > 0 || accountsCount> 0 || transactionTypesCount > 0 ){
                    if(documents.length > 0 ){
                        if(indemnityFormCount == 0){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title" : "Error!",
                                "type" : "error",
                                "message" : 'Please Upload Indemnity Form before Submitting for Approval',
                                "mode" : "dismissible"
                            });
                            toastEvent.fire();
                        }
                        else if(resolutionFormCount == 0){
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title" : "Error!",
                                "type" : "error",
                                "message" : 'Please Upload Resolution Form before Submitting for Approval',
                                "mode" : "dismissible"
                            });
                            toastEvent.fire();
                        }
                            else{
                                this.submitForApproval(component, event, helper);
                            }
                    }
                     else if(documents.length == 0){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title" : "Error!",
                            "type" : "error",
                            "message" : 'Please Upload Required Documents before Submitting for Approval',
                            "mode" : "dismissible"
                        });
                        toastEvent.fire();
                    }
                }
                
                else if(restrictionCount == 0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title" : "Error!",
                        "type" : "error",
                        "message" : 'Please Create Restrictions before Submitting for Approval',
                        "mode" : "dismissible"
                    });
                    toastEvent.fire();
                }
                
                else if(customerCount == 0 && accountsCount == 0 && transactionTypesCount ==0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title" : "Error!",
                        "type" : "error",
                        "message" : 'Please Add Customer/Account/TransactionType for the Restrictions before Submitting for Approval',
                        "mode" : "dismissible"
                    });
                    toastEvent.fire();
                }
                
            }    
        });
        $A.enqueueAction(action);
    }
})