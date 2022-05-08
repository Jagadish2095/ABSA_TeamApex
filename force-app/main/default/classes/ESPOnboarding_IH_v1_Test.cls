/**
* Test class for ESP Handler -ESPOnboarding_IH_v1.cls
* @author  Manoj Danthala : Absa
* @since   2019-02-28
*
**/
@isTest
public class ESPOnboarding_IH_v1_Test {
    @testSetup
    static void createTestData(){
        List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 4);
        insert leadsList;
        Lead leadRef = [SELECT Id, Lead_Ref_No__c FROM Lead WHERE Id =: leadsList[0].Id];
        System.debug('Lead_Ref_No__c ==> '+leadRef.Lead_Ref_No__c);
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(leadRef.Lead_Ref_No__c,'Opportunity_Business_Bank', 4);
        insert oppsList;
        
    }
    
    @isTest static void convertLead(){
        
        List<Lead> leadList = [SELECT Id, Name FROM Lead WHERE Name LIKE '%Test%'];
        
        Account acc = new Account(Name='TestAccount Absa');
        insert acc;
        
        Contact con = new Contact(
            Accountid = acc.Id,
            FirstName='fname',
            LastName = 'lname',
            Email = 'email@gmail.com',
            Phone = '9743800309'); 
        insert con; 
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadList[0].id);
        lc.setAccountId(acc.id);
        lc.setContactId(con.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Qualified');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
    }
    
    @isTest static void getESPStatusPositive(){
        List<Opportunity> oppList = [SELECT Id, Name, Lead_Number__c FROM Opportunity WHERE Name LIKE '%Test%'];
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ESPServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ESP_STRING});
        
        Test.startTest();
            ESPOnboarding_IH_v1.callToESPOnboarding(oppList[0].Id);
        Test.stopTest();
        
    }
    
    @isTest static void getESPStatusNegative(){
        List<Opportunity> oppList = [SELECT Id, Name, Lead_Number__c FROM Opportunity WHERE Name LIKE '%Test%'];
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ESPServiceMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ESP_STRING});
        
        Test.startTest();
            ESPOnboarding_IH_v1.callToESPOnboarding(oppList[0].Id);
        Test.stopTest();
        
    }
    
    @isTest static void noIntegrationSettings(){
        List<Opportunity> oppList = [SELECT Id, Name, Lead_Number__c FROM Opportunity WHERE Name LIKE '%Test%'];
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ESPServiceMock_ApiRest(StringConstants.POSITIVE_STRING));
        Test.startTest();
            ESPOnboarding_IH_v1.callToESPOnboarding(oppList[0].Id);
        Test.stopTest();
        
    }
}