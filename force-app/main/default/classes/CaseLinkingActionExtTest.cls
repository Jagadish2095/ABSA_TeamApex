/**  
 * @Purpose      	   : Test Class for CaseLinkingActionExt
 * @Author       	   : Dreamwares 
 * @Created Date 	   : 05/09/2018
 * @Last modified date : 07/09/2018
 */
@isTest
public class CaseLinkingActionExtTest {
    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
         map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
    	Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'Case@contact.com');
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email', 
                                Status = 'New', 
                                Origin = 'Email',
                                Account = account,
                                Contact = contact, 
                                SLA_Extension_Approval_Required__c = true, 
                                External_SLA_End_Date__c = Date.today(),
                                Subject = 'Test', 
                                Type__c = 'Sample test',
                                Email__c = 'test@sp.com', 
                                SuppliedEmail = 't@t.com',
                                Accountid = Account.id,
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today());
        insert caseRec;
        
        Case caseRec2 = new Case(Communication_Method__c = 'Email',
                                 Status = 'New', 
                                 Origin = 'Email', 
                                 Account = account,
                                 Contact = contact,                                 
                                 Email__c = 'test@sp.com', 
                                 ParentId = caseRec.Id,
                                 Subject = 'Test', 
                                 Email_From_Address__c = 'test@ali.com',
                                 SuppliedEmail = 't@t.com',
                                 Accountid = Account.id,
                                 recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                 Description = 'test',
                                 Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today());
        insert caseRec2;
    }
    
    //Method to test
    static testMethod void testCaseExtendSlaAction(){
    	Case caseRec = [SELECT Id, CaseNumber, Subject FROM Case WHERE ParentId = NULL LIMIT 1];
        Case childCase = [SELECT Id, CaseNumber, Subject FROM Case WHERE ParentId != NULL LIMIT 1];
        
        Test.startTest();
        try{
            List<Case> cases = CaseLinkingActionExt.getRelatedCase(String.valueOf(caseRec.Id));
        }catch(Exception e){
            System.debug('Exception::'+e.getMessage());
        }
        
        CaseLinkingActionExt.searchCases(caseRec.CaseNumber, 'rte', 'gfhf');
        List<Case> caseList = CaseLinkingActionExt.searchCases('', caseRec.Subject, 'test@ali.com');
        System.assertNotEquals(0, caseList.size());
        caseList = CaseLinkingActionExt.searchCases('', caseRec.Subject, '');
        System.assertNotEquals(0, caseList.size());
        caseList = CaseLinkingActionExt.searchCases('', '', 'test@ali.com');
        System.assertNotEquals(0, caseList.size());
        
        CaseLinkingActionExt.linkEmailToCase(caseRec.Id, childCase.Id);
		        
        Test.stopTest();
        Case testCase = [SELECT Id, Type__c FROM Case WHERE Status = 'Closed'];
        System.assertEquals(testCase.Type__c, 'Sample test');
    }
}