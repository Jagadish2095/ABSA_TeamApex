@isTest 
public class UploadEmailToCaseControllerTest {
    
    @testSetup
    static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    	
        Account account = new Account(Name = 'Test Account', Active_Email__c = 'from@email.com' );
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'from@email.com');
        insert contact;
                
        Service_Group__c sg = new Service_Group__c(Name='SG',Queue__c='Absa Client Services',Active__c=true, Assign_Record_Type__c = 'Service Request');
        insert sg;
        
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true);
        insert sl;
        
        Service_Type__c st = new Service_Type__c(Name='Type Subtype', Type__c='Type', Subtype__c='Subtype');
        insert st;
        
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=sg.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
        
        Shared_Email__c se = new Shared_Email__c(Active__c = true, Inbox_Address__c = 'test@email.com', Salesforce_Email_Address__c = 'test@email.com');
        insert se;
        
        Email_Rule__c er = new Email_Rule__c(Active__c = true, Default_Email_Rule__c = true, Route_To_Queue__c =sg.Id, Service_Type__c = st.Id);
        insert er;
        
        Shared_Email_Rule__c ser = new Shared_Email_Rule__c(Shared_Email__c = se.Id, Email_Rule__c = er.Id);
        insert ser;
    }
    
    static testMethod void testUploadFiles(){
        
        Email_Rule__c rule = [Select Id From Email_Rule__c Limit 1];
        
        String jsonStr = '[{"attachments":[],';
        jsonStr += '"recipients":[{"name":"ToTest","email":"test@email.com"}],';
        jsonStr += '"subject":"Re: Test With Attachment",';
        jsonStr += '"senderEmail":"from@email.com",';
        jsonStr += '"senderName":"FromTest",';
        jsonStr += '"body":"Test reply"}]';
        
        UploadEmailToCaseController.CaseRulesData crd = new UploadEmailToCaseController.CaseRulesData();
        crd.ruleId = rule.Id;
        crd.hasMathingRule = true;
        crd.ruleType = 'Routing_Rule';
        crd.caseRecord = new Case();
        crd.retentionPeriod = 0;
        
        UploadEmailToCaseController.AttachmentFiles afile = new UploadEmailToCaseController.AttachmentFiles();
        afile.attachmentName = 'Test';
        afile.attachmentFile = Blob.valueOf('TestBlob');
        
        UploadEmailToCaseController ctrl = new UploadEmailToCaseController();
        
        ctrl.jsonEmailMessage = jsonStr;
        ctrl.uploadFiles();
        
    }

}