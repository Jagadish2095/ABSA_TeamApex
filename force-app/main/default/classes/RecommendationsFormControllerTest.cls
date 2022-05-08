@isTest
public class RecommendationsFormControllerTest {
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
    }
    
    @isTest private static void getUserAccessTest(){
        Id oppId = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity' LIMIT 1].Id;
        Test.startTest();
        Map<String,Boolean> result = RecommendationsFormController.getUserAccess(oppId);
        Test.stopTest();
        system.assertEquals(result.get('recordAccess'), true);
    }
    @isTest private static void saveOpportunityLineItemTest(){
        Id oppId = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity' LIMIT 1].Id;
        Id productId = [SELECT Id FROM Product2 WHERE Family='Investments' LIMIT 1].Id;
        Test.startTest();
        Map<String, String> result = RecommendationsFormController.saveOpportunityLineItem(oppId, productId);
        Test.stopTest();
        system.assertEquals(result.get('opportunityProductId') != null, true);        
    }
    @isTest private static void getOpportunityLineItemTest(){
        Id oppId = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity' LIMIT 1].Id;
        Id productId = [SELECT Id FROM Product2 WHERE Family='Investments' LIMIT 1].Id;
        Test.startTest();
        RecommendationsFormController.saveOpportunityLineItem(oppId, productId);
        RecommendationsFormController.OppLineItems result = RecommendationsFormController.getOpportunityLineItem(oppId);
        Test.stopTest();
        system.assertEquals(result.appProduct != null, true);
        system.assertEquals(result.financialProduct != null, true);
    }
    @isTest private static void updateOpportunityLineItemTest(){
        Id oppId = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity' LIMIT 1].Id;
        Id productId = [SELECT Id FROM Product2 WHERE Family='Investments' LIMIT 1].Id;
        Test.startTest();
        RecommendationsFormController.saveOpportunityLineItem(oppId, productId);
        RecommendationsFormController.OppLineItems result = RecommendationsFormController.getOpportunityLineItem(oppId);
        result.appProduct.Product_Amount__c = 10;
        result.financialProduct.Source_of_Funds__c = 'BONUS';
        RecommendationsFormController.updateOpportunityLineItem(JSON.serialize(result));
        Test.stopTest();
        Opportunity_Product_History__c prodHistory = [SELECT Id,New_Value__c FROM Opportunity_Product_History__c WHERE Field_Name__c='Premium' LIMIT 1];
        system.assertEquals(prodHistory.New_Value__c =='10.0', true);
    }
}