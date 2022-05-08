({
    doInit: function(component, event, helper) {
        var actions = [
            { label: 'View', iconName: 'utility:preview', name: 'view_details' },
            { label: 'Reply', iconName: 'utility:reply', name: 'reply_details' }
        ];
        
        component.set('v.columns', [
            //{ label: 'From', fieldName: 'FromAddress', type: 'text' },
            {label: 'From', fieldName: 'FromName', type: 'url', typeAttributes: { label: { fieldName: 'FromAddress' }, target: '_blank' }},
            { label: 'Subject', fieldName: 'Subject', type: 'text' },
            { label: 'Date', fieldName: 'MessageDate', type: 'date' },
            { label: '', fieldName: 'provenance', fixedWidth: 40, cellAttributes:{ iconName: { fieldName: 'provenanceIconName' }, iconLabel: { fieldName: 'provenanceIconLabel' }, iconPosition: 'right' }},
            
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        helper.fetchData(component);
        
        //helper.getuploadedFiles(component);
    },
    
    handleRowAction: function (component, event, helper) {
        component.set("v.showEmailList", false);
        
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            case 'view_details':
                helper.getEmailBody(component, row.Id);
                helper.getEmailDetails(component, row.Id);
                
                component.set('v.columnsAtt', [
                    {label: 'Name', fieldName: 'Description', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
                    {label: 'Created Date', fieldName: 'CreatedDate', type: 'date'}
                ]);
                
                helper.fetchDataAtt(component, row.Id);
                break;
            case 'reply_details':
                component.set("v.showReply", true);
                helper.setEmailDetails(component, row.Id);
                break;
        }
    },
    
    backPressed: function (component, event, helper) {
        component.set("v.showEmailList", true);    
    },
    
    sendMail: function(component, event, helper) {
        // when user click on Send button 
        // First we get all 3 fields values 	
        var getToEmail = component.get("v.toAddress");
        var getFromEmail = component.get("v.fromAddress");
        var getSubject = component.get("v.subject");
        var getbody = component.get("v.body");
        var getLeadId = component.get("v.emailLeadId");
        // check if Email field is Empty or not contains @ so display a alert message 
        // otherwise call call and pass the fields value to helper method    
        if ($A.util.isEmpty(getToEmail) || !getToEmail.includes("@")) {
            alert('Please Enter valid To Address');
        }
        else if($A.util.isEmpty(getFromEmail) || !getFromEmail.includes("@")) {
            alert('Please Enter valid From Address');
        }
        else {
            helper.sendHelper(component, getToEmail, getFromEmail, getSubject, getbody, getLeadId);
        }
    },
    
    // when user click on the close buttton on message popup ,
    // hide the Message box by set the mailStatus attribute to false
    // and clear all values of input fields.   
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.toAddress", null);
        component.set("v.fromAddress", null);
        component.set("v.subject", null);
        component.set("v.body", null);
        component.set("v.emailLeadId", null);
    },
    
    cancelEmailSend: function(component, event, helper) {
        component.set("v.showReply", false);
        component.set("v.showEmailList", true);
    },
    
    newEmailSend: function(component, event, helper) {
        component.set("v.showReply", true);
        helper.setNewEmailDetails(component);
    },
    
    previewFile :function(component,event,helper){  
        var rec_id = event.currentTarget.id;  
        $A.get('e.lightning:openFiles').fire({ 
            recordIds: [rec_id]
        });  
    },  
    
    UploadFinished : function(component, event, helper) {  
        var uploadedFiles = event.getParam("files");  
        var documentId = uploadedFiles[0].documentId;  
        var fileName = uploadedFiles[0].name; 
        var cdIds = component.get("v.cdIds");
        component.set("v.files", uploadedFiles);
        
        var i;
        for (i = 0; i < uploadedFiles.length; i++) {
            cdIds.push(uploadedFiles[i].documentId);
        }
        
        //helper.getuploadedFiles(component);         
    }, 
    
    delFiles:function(component,event,helper){
        component.set("v.Spinner", true); 
        var documentId = event.currentTarget.id;        
        helper.delUploadedfiles(component,documentId);  
    },
})