({
    //Get newly created case
    doInit : function(component, event, helper) {
        
        //Method to get Case record 
        var action = component.get("c.getCaseRecord");
        
        action.setParams({
            "recId" : component.get("v.caseRecordId")
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var caseRec = response.getReturnValue();
                component.set("v.caseRecord", caseRec);
                console.log('caseRec:',caseRec);
                //Koketso - get all products associated with a case service group
                if(caseRec.sd_Service_Group_Id__c != null) {
                    var action = component.get("c.findProductsByServiceGroup");
                    action.setParams({
                        serviceGroupId : caseRec.sd_Service_Group_Id__c
                    });        
                    action.setCallback(this, function(response) {
                        var state = response.getState();            
                        if (state === "SUCCESS") {
                            var productOptions = response.getReturnValue();
                            console.log("productOptions:", productOptions);
                            
                            if(productOptions.length > 0){
                                component.set("v.productOptions", productOptions);
                            }
                        }            
                    });
                    $A.enqueueAction(action);
                }
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
    //Smanga - function to handle onchange action on the Amount Refunded field
    handleOnChangeAction : function(component, event, helper) {
        
        if(component.get("v.amountRefunded") !== null || component.get("v.amountRefunded") !== undefined || component.get("v.amountRefunded") !== ""){
            helper.showUploadField(component,event, true);
        
        }else{
            helper.showUploadField(component,event, false);
        }

        /*var amountRefunded = component.get("v.amountRefunded");
        amountRefunded = amountRefunded.includes(',') ? amountRefunded.replace(',' , '.') : amountRefunded;
        console.log('AmountRefunded ==> ' + amountRefunded);
        if(isNaN(amountRefunded)){
            component.set("v.amountRefunded","");
        }*/
        
    },
    
    handleOncommitAction: function(component, event, helper) {
        console.log('component.get("v.amountRefunded") ==> '+ component.get("v.amountRefunded"));
        var enteredValue = component.get("v.amountRefunded");
        console.log('enteredValue ==> '+ enteredValue);

        if(enteredValue){

            helper.checkIfNotNumber(component,event);
        }
    },
    
    //Map fields to Case and call method to close case
    caseResolution : function(component, event, helper) {
        helper.showSpinner(component);
        var whoCausedIt = component.find("iWhoCausedIt").get("v.value");
        var resolutionSummary = component.find("iResolutionSummary").get("v.value");
        var amountRefunded = component.get("v.amountRefunded"); //component.find("iAmountRefunded").get("v.value");
        var originatedBy = component.find("iOriginatedBy").get("v.value");
        var entity = component.find("iEntity").get("v.value");
        var goodwill = component.find("iGoodwill").get("v.value");
        var glAccount = component.find("iGlAccount").get("v.value");
        var resolvedInFavour = component.find("iResolveInFavour").get("v.value");
        var whereDidThisHappen = component.find("iWhereDidThisHappen").get("v.value");
        var responsibleSite = component.find("iResponsibleSite").get("v.value");
        var tradeLoss = component.find("iTradeLoss").get("v.value");
        var subTypeSearch = component.find("iSubTypeSearch").get("v.value");
        //Smanga -start - validate if POP is uploaded
        var amountRefunded = component.get("v.amountRefunded");
        var popFileIds     = component.get("v.proofOfPaymentfileIds");
        var showAmountRefundedPopup = component.get("v.showTheReminder");
        console.log('amountRefunded ==> '+ amountRefunded);
        console.log('popFileIds length ==> '+ popFileIds.length);
        //Smanga -end
        
        component.set("v.caseRecord.Who_Caused_It__c", whoCausedIt);
        component.set("v.caseRecord.Summary_of_Resolution__c", resolutionSummary);
        component.set("v.caseRecord.Resolved_in_Favour_of__c", resolvedInFavour);
        component.set("v.caseRecord.Amount_Refunded__c", amountRefunded);
        component.set("v.caseRecord.Originated_By__c", originatedBy);
        component.set("v.caseRecord.Entity__c", entity);
        component.set("v.caseRecord.Gesture_Of_Goodwill__c", goodwill);
        component.set("v.caseRecord.General_Ledger_GL_Account_to_be_debit__c", glAccount);
        component.set("v.caseRecord.Where_Did_This_Happen__c", whereDidThisHappen);
        component.set("v.caseRecord.Responsible_Site__c", responsibleSite);
        component.set("v.caseRecord.Trade_Loss__c", tradeLoss);
        component.set("v.caseRecord.Sub_Type_Search__c", subTypeSearch);
        
        //Method to get Case record 
        var action = component.get("c.updateAndCloseCase");
        
        var newCaseRecord = component.get("v.caseRecord");
        var caseRecordId = component.get("v.caseRecordId");
        var serviceTypeRecord = component.get("v.serviceTypeRecord");
        var productId = component.get("v.productId");
        
        //No Subject  
		if(!serviceTypeRecord || !productId){
            var toast = helper.getToast("Validation Warning", "Please search and select a Service Type for your case", "warning"); 
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }else if( !whoCausedIt ){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Who Caused It?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !resolutionSummary){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide Summary of Resolution",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !whereDidThisHappen){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Where Did This Happen?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !responsibleSite){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Responsible Site?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if(amountRefunded && showAmountRefundedPopup ){ //Smanga - start

                console.log("<===inside if statement* ===>");
                helper.showReminderAction(component, event);
                helper.hideSpinner(component);
                return null;          
                //Smanga -end
            
            }else if( !tradeLoss){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Trade Loss?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !entity){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please complete Entity?",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }
        
        action.setParams({
            "caseRecord" : newCaseRecord,
            "serviceTypeRecord" : serviceTypeRecord
        });
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                //Koketso - get all uploaded files
                var caseRecId = response.getReturnValue();
                var uploadedFileIds =  component.get("v.fileIds");

               //Smanga - add POP to the files
               if(popFileIds.length> 0){
                    uploadedFileIds.push.apply(uploadedFileIds,popFileIds);
                }

                if(uploadedFileIds.length > 0) {
                    var action = component.get("c.uploadContentDocuments");
                    action.setParams({
                        caseId : caseRecId, 
                        contentDocumentIds : uploadedFileIds
                    });        
                    action.setCallback(this, function(response) {
                        var state = response.getState();            
                        if (state === "SUCCESS") {
                            console.log(response.getReturnValue());
                        }            
                    });
                    $A.enqueueAction(action);
                }
                
                // show success notification
                var toastEvent = helper.getToast("Success!", "Case Closed", "Success");
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
                helper.closeFocusedTabAndOpenNewTab(component,caseRecordId);
                
            }else if(state === "ERROR"){
                
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
    //Case Classification
    getClassification : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.findServiceType");
        var serviceId = component.get("v.serviceTypeId");
        
        action.setParams({
            "recId":serviceId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                component.set("v.serviceTypeRecord", response.getReturnValue());
                
                var primary = component.find("iPrimary");
                var secondary = component.find("iSecond");
                var product = component.find("iProduct");
                primary.set("v.value", component.get("v.serviceTypeRecord.Type__c")); 
                secondary.set("v.value", component.get("v.serviceTypeRecord.Subtype__c"));
                product.set("v.value", component.get("v.serviceTypeRecord.Product__c"));
                
                helper.hideSpinner(component);
                
            }else if(state === "ERROR"){
                
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Koketso - handle multiple files, and display selected file names
    handleFilesChange: function(component, event, helper) {
        
        var uploadedFileIds = [];
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles:',uploadedFiles);
        
        if(uploadedFiles.length > 0){
            var filenames = '';
            for(var f = 0; f < uploadedFiles.length; f++){
                uploadedFileIds.push(uploadedFiles[f]['documentId']);
                filenames += uploadedFiles[f]['name']+"; ";
            }
            if(filenames != ''){
                var fpocfileText = component.find('fpocfileText');
                $A.util.removeClass(fpocfileText, 'slds-text-color_error');
                $A.util.addClass(fpocfileText, 'slds-text-color_success');
            }else{
               	var fpocfileText = component.find('fpocfileText');
                $A.util.removeClass(fpocfileText, 'slds-text-color_success');
                $A.util.addClass(fpocfileText, 'slds-text-color_error'); 
            }
            console.log('uploadedFileIds:',uploadedFileIds);
            component.set("v.fileStr", filenames);
            component.set("v.fileIds", uploadedFileIds);
        }
        
    },
    
    //Koketso - get all Service Types linked to a selected product by Product ID
    getServiceTypesByProduct : function(component, event, helper) {
        
        var serviceGroupId;
        
        var serviceGroupSearch = component.find("serviceGroupLookupSearch"); 
        
        var productId = component.get("v.productId");
        
        if(serviceGroupSearch != null){
            serviceGroupId = serviceGroupSearch.get("v.value");
        }else{
            serviceGroupId = null;
        }

        component.set("v.serviceTypeOptions", []);
        component.set("v.serviceTypeId", null);
        
        var action = component.get("c.findServiceTypesByProductAndServiceGroup");
        
        action.setParams({
            "caseId": component.get("v.caseRecordId"),
            "productId": productId,
            "serviceGroupId": serviceGroupId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var serviceTypeOptions = response.getReturnValue();
                console.log("serviceTypeOptions:", serviceTypeOptions);
                
                if(serviceTypeOptions.length > 0){
                    component.set("v.serviceTypeOptions", serviceTypeOptions);
                }
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    handleOnuploadfinished : function(component, event, helper) {

        helper.handlePOPFilesChange(component, event);
    },
    
})