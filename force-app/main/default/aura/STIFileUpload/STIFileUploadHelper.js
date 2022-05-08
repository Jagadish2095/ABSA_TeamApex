({
    uploadToEcm: function(component, event, helper){
        
        var action2 = component.get("c.uploadFiles");
        var documentId = component.get("v.docId");
        action2.setParams({
            "recordId": component.get("v.recordId"),
            "docId": documentId,
        });
        
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log("Success");
                component.set("v.docId",'');
            }
        });
        $A.enqueueAction(action2);
    },
    documentProcess : function(component, recordtype, result){
        if(recordtype!= null && recordtype.RecordType.Name === 'Investment Opportunity'){
            var agentdocs = [];
            var customerDocs = [];
            for(var key in result){
                if(result[key].Description != null){
                    var docTypes = component.get("v.investmentDocumentTypes");
                    for(var docType in docTypes){
                        if(docTypes[docType] === result[key].Description){
                            agentdocs.push(result[key]);
                        }
                    }
                }
                else {
                    var title = result[key].Title.toString();
                    if(!title.toLowerCase().includes('qa_certificate')){
                        customerDocs.push(result[key].Title);
                    }
                }
            }
            component.set("v.files",agentdocs);
            component.set("v.isFileUpload",true);
            if(customerDocs.length>0){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "message": "Customer attached new documents. Please review it."
                });
                toastEvent.fire();
            }
        }
        else{
            component.set("v.files",result);
            component.set("v.isFileUpload",true);
        }
    }
})