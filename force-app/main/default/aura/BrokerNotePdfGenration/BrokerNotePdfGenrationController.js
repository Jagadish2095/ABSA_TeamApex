({
    doInit : function(component, event, helper) {   
        //component.set("v.htmlData","<table>  <tr><td>Broker Note Releted Data</td></tr></table>");
        //component.set("v.fileName",	"Download");
        console.log('******'+JSON.stringify(component.get("v.recordId")));
        helper.fileNameDisplay(component, event, helper);
        helper.generateBrokerNotePDFLink(component, event, helper);
        helper.getContactNumbersforSMS(component, event, helper);
    },
    GenerateBrokerNotePDF : function(component, event, helper) { 
        console.log('Test--> GenerateBrokerNotePDF');
        var CaseId = component.get("v.recordId");
        console.log('CaseId CTRL-->'+CaseId);
        component.set("v.isLoading",	true);
        helper.GenerateBrokerNoteInECM(component, event, helper);
        
        
    },
    openModel: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },  
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    handleClick: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    
    downloadBrokerNote: function (component, event, helper) {
        helper.download(component, event, helper);
    },
    
    
    downloadBrokerNoteAIMS: function (component, event, helper) {
        component.set("v.isLoading",true);
        let DocId = component.get("v.AIMSPDFID");
        helper.download(component, event, helper,DocId);
        component.set("v.isLoading",false);
    },
    downloadBrokerNotMomentum: function (component, event, helper) {
        component.set("v.isLoading",true);
        let DocId = component.get("v.MomentumPDFID");
        helper.download(component, event, helper,DocId);
        component.set("v.isLoading",false);
    },
    downloadBrokerNoteLiberty: function (component, event, helper) {
        component.set("v.isLoading",true);
        let DocId = component.get("v.LibertyPDFID");
        helper.download(component, event, helper,DocId);
        component.set("v.isLoading",false);
    },
    downloadBrokerNoteSANLAM: function (component, event, helper) {
        component.set("v.isLoading",true);
        let DocId = component.get("v.SanlamPDFID");
        helper.download(component, event, helper,DocId);
        component.set("v.isLoading",false);
    },
    
    downloadBrokerNoteWills: function (component, event, helper) {
        component.set("v.isLoading",true);
        let DocId = component.get("v.WillsPDFID");
        console.log('WillsPDFID-->'+DocId);
        helper.download(component, event, helper,DocId);
        component.set("v.isLoading",false);
    },
    
    downloadBrokerNoteAbsaLife: function (component, event, helper) {
        component.set("v.isLoading",true);
        let DocId = component.get("v.AbsaLifePDFID");
        console.log('AbsaLifePDFID-->'+DocId);
        helper.download(component, event, helper,DocId);
        component.set("v.isLoading",false);
    },
    
    previewBrokerNoteFile: function (component, event, helper) {
        //helper.previewFile(component, event, helper);
        var selectedPillId =component.get("v.FileReferenceKey");// event.getSource().get("v.name");
        console.log('--',selectedPillId);
        $A.get('e.lightning:openFiles').fire({
            recordIds: [selectedPillId]
        });
    },
    getSelected : function(component,event,helper){
        // display modle and set seletedDocumentId attribute with selected record Id   
        component.set("v.hasModalOpen" , true);
        component.set("v.selectedDocumentId" ,component.get("v.FileReferenceKey"));       
    },
    Send : function(component,event,helper){
        component.set("v.showNewPanel",false);
        var allValid=true;
        /*var allValid = component.find('smsForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            inputCmp.focus();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);*/
        if(allValid){
            component.set("v.isLoading",true);
            var CaseId = component.get("v.recordId");//'5000E00000DUm0aQAD';//
            var userId=$A. get("$SObjectType.CurrentUser.Id");
            var Quicktext='BrokerNote';
            var IntegrationService='iTouch SMS Submit - VA';
            var saveAsActivity=true;
            var recipientNameOverride='';
            var phoneNumberOverride=component.get("v.PhoneNumber");
            var action = component.get("c.dispatchSMS");
            
            console.log('CaseId CTRL-->'+CaseId);
            console.log('CaseId CTRL-->'+userId);
            console.log('CaseId CTRL-->'+Quicktext);
            console.log('CaseId CTRL-->'+IntegrationService);
            console.log('CaseId CTRL-->'+phoneNumberOverride);
            console.log('CaseId CTRL-->'+saveAsActivity);
            
            action.setParams({
                "whoId": userId,
                "whatId" : CaseId,
                "phoneNumberOverride":phoneNumberOverride,
                "recipientNameOverride":recipientNameOverride,
                "quickTextName":Quicktext,
                "integrationService":IntegrationService,
                "saveAsActivity":saveAsActivity
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    component.set("v.showNewPanel",false); 
                    component.set("v.isLoading",false);
                    
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        title: 'Success!',
                        message: 'SMS Sent Successfully.',
                        type: 'success'
                    });
                    toastEvent.fire();  
                    
                    
                    
                }else{
                    
                    var toastEvent = $A.get('e.force:showToast');
                    toastEvent.setParams({
                        title: 'Success!',
                        message: 'SMS Sent Failed.',
                        type: 'success'
                    });
                    toastEvent.fire();  
                    component.set("v.isLoading",false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    sendSMS:function(component,event,helper){
        component.set("v.showNewPanel",true);
    },
    
    cancel: function(component, event) {
        component.set("v.showNewPanel",false);
        component.set("v.PhoneNumber",'');
    },
    sendEmails : function(component,event,helper){
        helper.sendEmailsToProviders(component, event, helper);
    }
})