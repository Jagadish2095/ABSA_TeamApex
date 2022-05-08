/**
* Test class for SubmitDocumentsController
* @author  Kyle Alexander
* @created 2018-10-11
*/

@IsTest
public class SubmitDocumentsControllerTest {
    
    public static testMethod void testSubmitDocuments(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        List<Account> accounts = new List<Account>();
        accounts.add(testDataFactory.testAccount);
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(testDataFactory.testOpportunity);
        
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'EPP ROA';
        dt.XML__c = '<Account> <LastName>{Account.LastName}</LastName>';
        insert dt;
        
        dt = new Document_Template__c();
        dt.Name = 'EPP Acceptance Quote';
        dt.XML__c = '<Account> <LastName>{Account.LastName}</LastName>';
        insert dt;
        
        dt = new Document_Template__c();
        dt.Name = 'EPP T&C';
        insert dt;
        
        dt = new Document_Template__c();
        dt.Name = 'EPP FAQ';
        insert dt;
        
        Test.startTest();
                
        SubmitDocumentsController.sendEmail(testDataFactory.testOpportunity.Id, accounts, opps, 'test@test.com', false);
        SubmitDocumentsController.getPolicyNumber(testDataFactory.testOpportunity.Id);
        SubmitDocumentsController.checkEmailStatus(testDataFactory.testOpportunity.Id);
                
        Test.stopTest();
    }  
    
    public static testMethod void testSendAlternatives(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        SubmitDocumentsController.sendAlternativeEmail(testDataFactory.testOpportunity.Id, 'test@test.com');
        SubmitDocumentsController.sendAlternativeEmail(testDataFactory.testOpportunity.Id, 'test1@test.com');
        SubmitDocumentsController.sendAlternativeEmail(testDataFactory.testOpportunity.Id, 'test2@test.com');
        SubmitDocumentsController.sendAlternativeEmail(testDataFactory.testOpportunity.Id, 'test3@test.com');
        SubmitDocumentsController.sendAlternativeEmail(testDataFactory.testOpportunity.Id, 'test4@test.com');
        
        Test.stopTest();
    }
    
    public static testMethod void testGetEmails(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        SubmitDocumentsController.getEmails(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
    }
}