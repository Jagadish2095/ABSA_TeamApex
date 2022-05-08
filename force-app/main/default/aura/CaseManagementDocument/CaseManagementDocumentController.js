/**
 * @description controller for DocumnetUploade component .
 * @Change description added init function to get pick list values
 */
({
   /**
   * @description initiate function to fetch pick list values for filetype.
   * 
   **/
    
    doInit: function(component, event, helper) {
        helper.fetchFileTypesPickListVal(component);
        helper.fetchDocumentMetadata(component);
    },
    
   /**
   * @description handleFilesChange function.
   **/
    handleFilesChange: function(component, event, helper) {
        var fileName = "No File Selected..";
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]["name"];
        }
        component.set("v.fileName", fileName);
    },
   /**
   * @description doSave function.
   **/
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files") && component.find("fileId").get("v.files").length > 0) {
            if (component.get("v.fileType").length > 0) {
                helper.upload(component, event);
                
            } else {
                alert("Please Select File Type");
                //console.log(component.get("v.relatedPartyId"));
            }
        } 
        
     
    },
    
    onPicklistDocumentChange: function(component, event, helper) {
        var documents = component.get("v.documentMetadata");
        var radioGrp= component.find("radioGrp");
       
        var action = component.get("c.validateQAProcess");
        action.setParams({
            recordId: component.get("v.recordId")});
                         action.setCallback(this, function(response) {
            var state = response.getReturnValue();
                             console.log("response"+state);
            if (state === true) {
                
                 console.log("In True");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "You cannot make changes as this opportunity is undergoing QA review."
                });
                toastEvent.fire();
            }
            else {
                $A.util.addClass(radioGrp, 'slds-hide');
                component.set("v.selectSignedManuallyOption", false);
                component.set("v.disableRadioButtonGroup", true);
                for (var i = 0; i < documents.length; i++) {
                    if(documents[i].Document_Type__c == component.get("v.fileType") && documents[i].Signature_Required__c) {
                        component.set("v.disableRadioButtonGroup", false);
                        $A.util.removeClass(radioGrp, 'slds-hide');
                    }
                }
            }
                             
                             
        }); 
  
      $A.enqueueAction(action);
    },
    
    handleRelatedParty: function(component, event, helper) {
        console.log("handleRelatedParty 70");
        var relatedPartyID = event.getParam("relatedPartyID");
        component.set("v.relatedPartyID", relatedPartyID);
        console.log(" 74 Related Party " + component.get("v.relatedPartyID"));
    }
});