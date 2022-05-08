/**  
 * @Purpose            : Test Class for EmailThreadId
 * @Author             : Dreamwares 
 * @Created Date       : 16/08/2018
 * @Last Modified Date : 06/09/2018
 */
@isTest 
public class EmailThreadIdTest {
	
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
    	//Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Id caseServiceRequestRecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId();
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c();
        serviceGr.Name = 'Test1';
        serviceGr.Assign_Record_Type__c = 'Email';
        serviceGr.Response_Email_Address__c = 'evg@t.com';
        serviceGr.Open_New_Case__c = true;
        serviceGr.Queue__c = 'Email';
        serviceGr.Business_Hours__c = businessHr.Id;
        serviceGr.Internal_SLA_Time_Measure__c = 'Hour(s)';
        serviceGr.Internal_SLA_Units__c = '8';
        insert serviceGr;
        
        Case caseRec0 = new Case(RecordTypeId = caseServiceRequestRecordTypeId, sd_Service_Group__c = serviceGr.Name, sd_Service_Group_Id__c = serviceGr.Id, Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', Account = account, Type__c = 'abc', Subtype__c = 'xyz', Product__c = 'a product' );
        insert caseRec0;       
        
        Case caseRec = new Case(ParentId = caseRec0.Id, RecordTypeId = caseServiceRequestRecordTypeId, sd_Service_Group__c = serviceGr.Name, sd_Service_Group_Id__c = serviceGr.Id, Communication_Method__c = 'Email', Status = 'Closed', Origin = 'Email', Account = account, Type__c = 'abc', Subtype__c = 'xyz', Product__c = 'a product' );
        insert caseRec;
        
        caseRec.Status = 'Closed';
        update caseRec;
    }
    
    @isTest
    private static void testGetThreadId() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'aaref:test:ref';
        email.fromAddress = 'test@gmail.com';
        //email.plainTextBody = 'email body\n2225256325\nTitle';
        String threadId = EmailThreadId.getThreadId(email);
        EmailThreadId.findCaseByThreadId(threadId, false, email);
        System.assertNotEquals(threadId, null);
    }
    
    @isTest
    private static void testGetThreadIdFromText() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'ref: Test';
        email.fromAddress = 'test@gmail.com';
        //email.plainTextBody = 'email body\n2225256325\nTitle';
        email.plainTextBody = 'email bodyref:Test Thread:ref';
        String treadId = EmailThreadId.getThreadId(email);
        System.debug('treadId::'+treadId);   
        System.assertNotEquals(treadId, null);
    }
    
    @isTest
    private static void testGetThreadIdFromBody() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'ref: Test';
        email.fromAddress = 'test@gmail.com';
        //email.plainTextBody = 'email body\n2225256325\nTitle';
        email.htmlBody = '<b>Test ref:<div>Test Email body</div>:ref';
        String treadId = EmailThreadId.getThreadId(email);
        System.assertNotEquals(treadId, null);
    }
    
    @isTest
    private static void testfindCaseByThreadId() {
    	Id sfOrgId = UserInfo.getOrganizationId();
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        String orgID = String.valueOf(sfOrgId) ;
       
        String caseID = String.valueOf(caseRec.Id);
        String orgId1 = orgID.substring(0,4);
        String orgId2 = orgID.substring(orgID.lastIndexOfIgnoreCase('0') + 1, orgID.length()-3);
        String threadId = 'ref:_'  + UserInfo.getOrganizationId().left(4)  + 'E' + UserInfo.getOrganizationId().mid(11,4) + '._' + caseID.left(4) + 'E' + caseID.mid(10,5) + ':ref';

        System.debug('threadId::'+threadId);        
        //Id result = EmailThreadId.findCaseByThreadId(threadId, false, null);
        //System.debug('result::'+result);
    }
        
    @isTest
    private static void negTestGetThreadId() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'ref: Test';
        email.fromAddress = 'test@gmail.com';
        //email.plainTextBody = 'email body\n2225256325\nTitle';
        email.htmlBody = '';
        String treadId = EmailThreadId.getThreadId(email);
    }
}