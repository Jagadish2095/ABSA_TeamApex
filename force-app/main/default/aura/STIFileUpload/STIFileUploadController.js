({
    doInit: function(component, event, helper) {
        component.set("v.showSpinner",true);
        var recId = component.get("v.recordId");
        var action = component.get("c.getFiles");
        
        action.setParams({
            "recordId":recId
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var recordtype = component.get("v.oppRecord");
                var result = response.getReturnValue();
                if(result != null){
                    helper.documentProcess(component,recordtype,result);
                }
                component.set("v.showSpinner",false);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
    onDocTypeChange: function(component, event, helper) {
        component.set("v.showSpinner",true);
        var recordType = component.get("v.oppRecord").RecordType.Name;
        console.log('recordType:',recordType);
        if(recordType === "Investment Opportunity"){
            var action = component.get("c.getDocumentTypes");
            action.setParams({
                "oppId":component.get("v.recordId")
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    if(result.length> 0){
                        var docType=component.find('select').get('v.value');
                        if(docType != '--None--'){
                            component.set("v.documenttype",docType);
                        }
                        else{
                            component.set("v.documenttype",null);
                        }
                        component.set("v.showSpinner",false);
                    }
                    else{
                        $A.get('e.force:refreshView').fire();
                        component.find('select').set('v.value',null);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"warning",
                            "message": "You have not selected any required Compliance document types. Please select required Compliance Document types before sending the email!"
                        });
                        toastEvent.fire();
                        
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
            if(docType != '--None--'){
                component.set("v.documenttype",docType);
            }
            else{
                component.set("v.documenttype",null);
            }
        }
    },
    
    
    UploadFinished : function(component, event, helper) {
        
        var uploadedFiles = event.getParam("files");
        var fileName =  uploadedFiles[0].name;
        if(uploadedFiles !== null)
            component.set("v.isFileUpload",true);
        var documentId = uploadedFiles[0].documentId;
        component.set("v.docId",documentId);
        var documentType = component.get("v.documenttype");
        
        var action = component.get("c.UpdateFiles");
        
        action.setParams({
            
            "documentId":documentId ,
            "description":documentType ,
            "recordId": component.get("v.recordId")
            
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var recordtype = component.get("v.oppRecord");
                var result = response.getReturnValue();
                if(result != null){
                    helper.documentProcess(component,recordtype,result);
                    component.set("v.documenttype",'');
                    helper.uploadToEcm(component, event, helper);
                }
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})