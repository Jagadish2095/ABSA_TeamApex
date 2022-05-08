@isTest
public class EmailSenderControllerTest {
    @testSetup private static void setupData(){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Account');
        Id accRecordTypeId = rtInfo.get('Individual_Prospect').getRecordTypeId();
        Account account = new Account();
        account.FirstName = 'Test';
        account.LastName = 'Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic = '35790';
        account.AccountNumber = '0';
        account.RecordTypeId = accRecordTypeId;
        account.Registration_Number__c = '1990/011515/23';
        account.PersonEmail=userinfo.getUserEmail();
        insert account;
        Account acc = new Account();
        acc.Name = 'Test Service';
        acc.Type = 'Service';
        insert acc;
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = account.Id;
        insert oppsList;
        Product2 prod = new Product2(Name = 'Investments Product', Family = 'Investments', Primary_Service_Provider__c=acc.Id);
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = oppsList[0].id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = standardPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        Regulatory_Financial_Account__c rfa = new Regulatory_Financial_Account__c();
        rfa.Account__c = oppsList[0].AccountId;
        rfa.Product__c = oppLineItem.Id;
        rfa.Source_of_Funds__c = '';
        insert rfa;
        Application_Product__c apc = new Application_Product__c();
        apc.Opportunity_Product_Id__c = oppLineItem.Id;
        apc.Opportunity__c = oppsList[0].id;
        apc.Product_Amount__c = 10;
        insert apc;
    }
    
    @isTest private static void testRequiredDocuments(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        Test.startTest();
        EmailSenderController.WrapperOppLineItem wrpperData = EmailSenderController.getOppLineItems(opp.Id);
        Test.stopTest();
        System.assertEquals(wrpperData.errorMessage.contains('You have not selected any required document types'), true);
    }
    
    @isTest private static void testupdateAccountEmail(){
        Account a = [Select PersonContactId from Account where CIF__c='SNIFFEL001' limit 1];
        Opportunity opp = [SELECT Id,AccountId FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        Test.startTest();
        EmailSenderController.updateAccount(opp.AccountId,'testaccount@absa.africa');        
        Test.stopTest();
        String email = [SELECT PersonEmail FROM Account WHERE Id=:opp.AccountId LIMIT 1].PersonEmail;
        System.assertEquals(email, 'testaccount@absa.africa');
    }
    
    @isTest private static void testGetOppLineItems(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true,
            Description = 'Application'
        );
        insert contentVersionInsert;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId 
                                           FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = opp.Id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;        
        Note newNote = new Note();
        newNote.ParentId = opp.Id;
        newNote.IsPrivate = true;
        newNote.Title = 'RequiredDocuments';
        newNote.Body = 'Application';
        insert newNote;
        Test.startTest();
        EmailSenderController.WrapperOppLineItem wrpperData = EmailSenderController.getOppLineItems(opp.Id);
        System.assertEquals(wrpperData.errorMessage == null, true);
        EmailSenderController.sendEmailtoCustomer(JSON.serialize(wrpperData),'testaccount@absa.africa');
        Test.stopTest();
        String subStatus =[SELECT Sub_Status__c FROM Opportunity WHERE Id=:opp.Id LIMIT 1].Sub_Status__c;
        System.assertEquals('Await customer feedback',subStatus , 'Email sent successfully.');
    }
}