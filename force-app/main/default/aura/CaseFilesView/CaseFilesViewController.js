/**
* @author  Chenna
* @version v1.0
* @since   2020-09-11
**/

({
    doInit : function(component, event, helper) {
        helper.fetchCaseNumber(component, event, helper);
        var recId = component.get("v.recordId");
        console.log('recId::',recId);
        var action = component.get("c.fetchContentDocument");
        action.setParams({ caseId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('res::',response.getReturnValue());
                var filesizes = response.getReturnValue();
                component.set('v.noOfFiles', filesizes.length);
                var file;
                for(file of response.getReturnValue()){
                    console.log('date entered',file.LastModifiedDate);
                    console.log('date formatter',$A.localizationService.formatDate(file.LastModifiedDate, "YYYY/MM/dd hh:mm a"));
                    file.LastModifiedDate = $A.localizationService.formatDate(file.LastModifiedDate, "YYYY/MM/dd hh:mm a");
                    file.ContentSize = helper.bytesToSize(file.ContentSize);
                }
                
                component.set('v.lstContentDoc', response.getReturnValue());
            }
            else if (state === "ERROR") {
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
        $A.enqueueAction(action);  
    },
    getSelected : function(component,event,helper){
        // display modle and set seletedDocumentId attribute with selected record Id   
        component.set("v.hasModalOpen" , true);
        component.set("v.selectedDocumentId" , event.currentTarget.getAttribute("data-Id"));
        console.log('abc',event.currentTarget.getAttribute("data-Id"));
        
    },
    closeModel: function(component, event, helper) {
        component.set("v.hasModalOpen", false);
        component.set("v.selectedDocumentId" , null); 
    },
    
    openUploadModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closeUploadModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    UploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var fileName =  uploadedFiles[0].name;
        console.log('uploadedFiles:',uploadedFiles);
        component.set("v.isOpen", false);
        //refresh
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
        helper.showToastMsg('Document Uploaded Successfully');
    },
    previewFile :function(component, event, helper){
        var selectedPillId = event.getSource().get("v.name");
        console.log('--',selectedPillId);
        $A.get('e.lightning:openFiles').fire({
            recordIds: [selectedPillId]
        });
    },
    
    handleDelete:function(component, event, helper){
        var recId = event.getSource().get("v.value");
        var action = component.get("c.deleteDocument");
        action.setParams({ documentId : recId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('res::',response.getReturnValue());
                helper.showToastMsg('Document has been Deleted Successfully');
                var a = component.get('c.doInit');
                $A.enqueueAction(a);
            }
            else if (state === "ERROR") {
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
        $A.enqueueAction(action); 
        
    }
})