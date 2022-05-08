@IsTest
public class DocumentsMenuControllerTest {
     @testSetup
    public static void dataCreation(){
        
        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=account.Id;
        // testOpp.Site__c='Test';
        insert testOpp;
        
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        
        Application__c app= new Application__c();
        app.Opportunity__c=testOpp.id; 
       
        insert app;
        
        Account testJointAccount = new Account();
        //testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'TEST MR JA & TEST MRS J';
        testJointAccount.Client_Type__c = 'Joint & Several';
        testJointAccount.CASA_Reference_Number__c = '1712994';
        testJointAccount.CASA_Risk_Status__c = 'Low';
        testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testJointAccount.CASA_Screening_Status__c = 'Approved';
        testJointAccount.CASA_Analyst_Comments__c = '30406';
        testJointAccount.Country_of_Registration__c='South Africa';
        testJointAccount.CIF__c = 'NAIARA+001';
        insert testJointAccount;
        
        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.AccountId = account.Id;         
        insert testContact;
        
        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = testJointAccount.Id;
        acr.ContactId = testContact.Id;
        insert acr;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Onboarding';
        opp2.CloseDate = Date.today();
        opp2.StageName = 'New';
        opp2.AccountId=account.Id;
        insert opp2;
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Sales';
        opp3.CloseDate = Date.today();
        opp3.StageName = 'New';
        opp3.AccountId=account.Id;
        insert opp3;
        
        //IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Opportunity opp = new Opportunity(Name = 'my opportunity');
        opp.CloseDate = Date.today();
        opp.StageName = 'Drafting';
        insert opp;
        
        String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = DocumentController.saveChunk(opp.Id, 'mydoc.pdf', chunk1, 'txt', '', false, 'Absa 3741 Client Engagement', true, '');
		
        
        Document__c doc = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Opportunity__c = opp.Id,File_Id__c=fileId);
        insert doc;
        
        Document__c doc2 = new Document__c(Name = 'mydoc2.pdf', Reference__c = '123456', Opportunity__c = opp.Id,File_Id__c= fileId);
        insert doc2;
        
        Document_Template__c dt = new Document_Template__c(Name = 'Absa 3741 Client Engagement', Client_Type__c = 'Private Individual', Document_Type__c = 'Absa 3741 Client Engagement',Parent_Document_Type__c ='Business Client Agreement');
        insert dt;
        
        Document_Template__c dts = new Document_Template__c(Name = 'Will', Client_Type__c = 'Private Individual', Document_Type__c = 'Will',Parent_Document_Type__c ='Proof of Address');
        insert dts;
    }
 public static testMethod void testGetAllDocuments(){
        
        Opportunity testOpportunity = [SELECT Id,Name FROM Opportunity Where Name = 'my opportunity'];
        
        Test.startTest();
        List<Document__c> documentAuditList = DocumentsMenuController.getAlDocuments(testOpportunity.Id);
       DocumentsMenuController.getOpportunity(testOpportunity.Id);
            Test.stopTest();
    }
}