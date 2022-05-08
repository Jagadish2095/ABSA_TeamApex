@isTest
public class EmailRequestServiceTest {
    
    @testSetup
    static void dataCreation(){
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Group gQueue = [Select Id, Name, DeveloperName From Group Where Type = 'Queue' Limit 1];
        
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Test1';
        serviceGr.Assign_Record_Type__c = 'Service Request';
        serviceGr.Response_Email_Address__c = 'testfrom@email.com';
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        serviceGr.Active__c = true;
        serviceGr.Queue__c = gQueue.Name;
        insert serviceGr;
        
        Service_Level__c serviceLevel = new Service_Level__c();
        serviceLevel.Name = 'Test1';
        serviceLevel.External_SLA_Time_Measure__c = 'Hour(s)';
        serviceLevel.External_SLA_Units__c = '8';
        serviceLevel.Default_Service_Level__c = true;
        serviceLevel.Max_SLA_Units__c = '4';
        serviceLevel.Max_SLA_Time_Measure__c = 'Hour(s)';
        insert serviceLevel;
        
        Shared_Email__c sharedEmail = new Shared_Email__c();
        sharedEmail.Name = 'Test Email';
        sharedEmail.Active__c = true;
        sharedEmail.Inbox_Address__c = 'testfrom@email.com';  
        sharedEmail.Salesforce_Email_Address__c = 'testfrom@email.com';
        sharedEmail.Verified__c = false;
        sharedEmail.Prioritise__c = false;
        insert sharedEmail;
        
        Email_Rule__c emailRule = new Email_Rule__c();
        emailRule.Name = 'Test Rule';  
        emailRule.Active__c = true;
        emailRule.Default_Email_Rule__c = true; 
        emailRule.Route_To_Queue__c	= serviceGr.Id;
        emailRule.Service_Level__c = serviceLevel.Id;
        insert emailRule;
             
        Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c();
        sharedEmailRule.Shared_Email__c = sharedEmail.Id;
        sharedEmailRule.Email_Rule__c = emailRule.Id; 
        insert sharedEmailRule;
        
    }
        
    @isTest static void testAimsRequestService(){
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('fromAddress', 'testfrom@email.com');
        gen.writeStringField('toAddress', 'testto@email.com');
        gen.writeStringField('ccAddress', 'testcc@email.com');
        gen.writeStringField('bccAddress', 'testbcc@email.com');
        gen.writeStringField('subject', 'Test Subject');
        gen.writeStringField('content', 'Test Content');
        gen.writeFieldName('attachments');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeBlobField('attachmentFile', Blob.valueof('Attachment'));
        gen.writeStringField('attachmentName', 'test.pdf');
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        
        RestRequest request = new RestRequest();
        
        request.requestUri ='/services/apexrest/AimsRequestService';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonString);
        
        RestContext.request = request;
        AimsRequestService.processRequest();
        
    }
    
    @isTest static void testQualityAndTranslipsECRequestService(){
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('fromAddress', 'testfrom@email.com');
        gen.writeStringField('toAddress', 'testto@email.com');
        gen.writeStringField('ccAddress', 'testcc@email.com');
        gen.writeStringField('bccAddress', 'testbcc@email.com');
        gen.writeStringField('subject', 'Test Subject');
        gen.writeStringField('content', 'Test Content');
        gen.writeFieldName('attachments');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeBlobField('attachmentFile', Blob.valueof('Attachment'));
        gen.writeStringField('attachmentName', 'test.pdf');
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        
        RestRequest request = new RestRequest();
        
        request.requestUri ='/services/apexrest/QualityAndTranslipsECRequestService';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(jsonString);
        
        RestContext.request = request;
        QualityAndTranslipsECRequestService.processRequest();
        
    }

}