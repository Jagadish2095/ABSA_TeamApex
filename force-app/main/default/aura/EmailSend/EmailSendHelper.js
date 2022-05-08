({
    getEmailBody: function (component, rowId) {    
        component.set("v.showSpinner", true);
            
        var action = component.get("c.fetchEmailBody");
        action.setParams({
            "recId": rowId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set("v.emailBody", a.getReturnValue()); 
            }
        	component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    getEmailDetails: function (component, rowId) {    
        component.set("v.showSpinner", true);
            
        var action = component.get("c.fetchEmailDetails");
        action.setParams({
            "recId": rowId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set("v.email", a.getReturnValue()); 
            }
        	component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    fetchData: function (component) {
        component.set("v.showSpinner", true);

        var recId = component.get("v.recordId");
        var action = component.get("c.getData");
        action.setParams({
            "recId": recId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var hasData = false;
                var data = response.getReturnValue();
                data.forEach(function(record){
                    hasData = true;
                    if(record.HasAttachment){
                        record.provenanceIconName = 'utility:attach';
                    }
                });
                
                component.set("v.data", data);
                
                if(hasData){
                    component.set("v.emailsExist", true);
                }
                else{
                    component.set("v.emailsExist", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    fetchDataAtt: function (component, rowId) {
        component.set("v.showSpinner", true);

        var recId = component.get("v.recordId");
        var action = component.get("c.getDataAtt");
        action.setParams({
            "recId": rowId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                data.forEach(function(record){
                    record.linkName = record.ContentUrl;
                });
                component.set("v.dataAtt", data);
                if(data.length > 0){
                    component.set("v.showAttachements", true);
                }
                else{
                    component.set("v.showAttachements", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    setEmailDetails: function (component, rowId) {    
        component.set("v.showSpinner", true);
            
        var action = component.get("c.fetchEmailDetails");
        action.setParams({
            "recId": rowId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var resp = a.getReturnValue();
                component.set("v.toAddress", resp.FromAddress);
				component.set("v.fromAddress", resp.ToAddress);
                component.set("v.body", resp.HtmlBody);
                component.set("v.emailLeadId", resp.Lead__c);
                if(!resp.Subject.includes("ref")){
                    component.set("v.subject", resp.Subject + ' ' + resp.Lead__r.Lead_Thread_Id__c);
                }
                else{
                    component.set("v.subject", resp.Subject);
                }
                
            }
        	component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    setNewEmailDetails: function (component) {    
        component.set("v.showSpinner", true);
            
        var action = component.get("c.fetchNewEmailDetails");
        action.setParams({
            "recId": component.get("v.recordId") 
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") { 
                var resp = a.getReturnValue();
                component.set("v.toAddress", resp.Email);
				component.set("v.fromAddress", resp.sd_Response_Email_Address__c);
                component.set("v.body", "");
                component.set("v.emailLeadId", resp.Id);
                component.set("v.subject", resp.Lead_Thread_Id__c);
            }
        	component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    sendHelper: function(component, getToEmail, getFromEmail, getSubject, getbody, getLeadId) {
        // call the server side controller method 	
        var action = component.get("c.sendMailMethod");
        // set the 3 params to sendMailMethod method   
        action.setParams({
            'toAddress': getToEmail,
            'fromAddress': getFromEmail,
            'mSubject': getSubject,
            'mbody': getbody,
            'emailLeadId': getLeadId,
            'cdIds': component.get("v.cdIds")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Email Sent Successfully",
                    "type":"success"
                });
                toastEvent.fire();
                
                component.set("v.showReply", false);
                component.set("v.showEmailList", true);
                
                $A.get('e.force:refreshView').fire();
            }
            else{
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error sending the email occured, please refresh and try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    getuploadedFiles:function(component){
        var action = component.get("c.getFiles");  
        action.setParams({  
            "recordId":component.get("v.recordId") 
        });      
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){  
                var result = response.getReturnValue();           
                component.set("v.files",result);  
            }  
        });  
        $A.enqueueAction(action);  
    },
    
    delUploadedfiles : function(component,documentId) {  
        var action = component.get("c.deleteFiles");           
        action.setParams({
            "sdocumentId":documentId            
        });  
        action.setCallback(this,function(response){  
            var state = response.getState();  
            if(state=='SUCCESS'){ 
                var cdIds = component.get("v.cdIds");
                var files = component.get("v.files");
                var i;
                for (i = 0; i < cdIds.length; i++) {
                    if(cdIds[i] == documentId){
                        delete cdIds[i];
                    }
                }
                component.set("v.cdIds", cdIds);
                for (i = 0; i < files.length; i++) {
                    if(files[i].documentId == documentId){
                        delete files[i];
                    }
                }
                component.set("v.files", files);
                component.set("v.Spinner", false); 
            }  
        });  
        $A.enqueueAction(action);  
    },  
})