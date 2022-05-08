/**
 * @description short term insurance services test class
 * @author Mbuyiseni Mbhokane
 * @since 08/05/2021
 * Last Modiefied by Monde Masiza
 */
@isTest
public class ShortTermInsurancePushLeadTest {

    @testSetup
    static void testDataCreation(){

        //create individual account
        Account indivAccount = new Account();
        indivAccount.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        indivAccount.FirstName = 'Test';
        indivAccount.LastName = 'Individual';
        indivAccount.Communication_Language__pc = 'English';
        indivAccount.PersonTitle = 'Mr.';
        indivAccount.Initials__pc = 'T';
        indivAccount.Client_Group__c = 'Individual';
        indivAccount.Client_Type__c = 'Private Individual';
        indivAccount.Work_Phone__c = '0115850987';
        indivAccount.ID_Type__c = 'SA Identity Document';
        indivAccount.ID_Number__pc='8001014800080';
        indivAccount.Client_Creation_Reason__c='Is not an Absa Client';
        
        insert indivAccount;
        
        //create related addresses
        List<Address__c> relatedAddresses = new List<Address__c>();
        Address__c physicalAddress = new Address__c(); 
        physicalAddress.Address_Type__c = 'Physical Address';
        physicalAddress.Shipping_Street__c = indivAccount.Physical_Address_Line_1__c;
        physicalAddress.Shipping_Street_2__c = indivAccount.Physical_address_line_2_c__c;
        physicalAddress.Shipping_Suburb__c = indivAccount.Physical_Address_Suburb__c;
        physicalAddress.Shipping_City__c = indivAccount.Physical_Address_City__c;
        physicalAddress.Shipping_Zip_Postal_Code__c = indivAccount.Physical_Address_Physical_Code__c;
        physicalAddress.Shipping_Country__c = indivAccount.Physical_Address_Country__c;
        physicalAddress.Client_Entity_Type__c = 'Individual';
        physicalAddress.Account__c = indivAccount.Id;
        physicalAddress.Contact__c = indivAccount.PersonContactId;
        relatedAddresses.add(physicalAddress);
        
        
        Address__c postalAddress = new Address__c(); 
        postalAddress.Address_Type__c = 'Postal';
        postalAddress.Shipping_Street__c = indivAccount.Physical_Address_Line_1__c;
        postalAddress.Shipping_Street_2__c = indivAccount.Physical_address_line_2_c__c;
        postalAddress.Shipping_Suburb__c = indivAccount.Physical_Address_Suburb__c;
        postalAddress.Shipping_City__c = indivAccount.Physical_Address_City__c;
        postalAddress.Shipping_Zip_Postal_Code__c = indivAccount.Physical_Address_Physical_Code__c;
        postalAddress.Shipping_Country__c = indivAccount.Physical_Address_Country__c;
        postalAddress.Client_Entity_Type__c = 'Individual';
        postalAddress.Account__c = indivAccount.Id;
        postalAddress.Contact__c = indivAccount.PersonContactId;
        relatedAddresses.add(postalAddress);
        
        insert relatedAddresses;

        //Create opportunity
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId=indivAccount.Id;
        insert testOpp;

    }

    @isTest static void updateLeadDetailsPositiveTest(){
        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, UpdateLeadDetails_IH_v1_Test.UPDATE_LEAD_DETAILS_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{UpdateLeadDetails_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        test.startTest();
        String accountId;

        Opportunity opp = [SELECT Id,Name FROM Opportunity  Limit 1]; 
        
        //Monde Masiza - Test the value retrived from the query 
        system.AssertEquals('Test Opp Onboarding 1', opp.Name,'Opportunity Name does not match');
        
        String updateLeadDetailsResult = ShortTermInsurancePushLead.leadDetailsUpdate(opp.Id, accountId);
        test.stopTest();
    }

    @isTest static void updateClientDetailsPositiveTest(){

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, UpdateLeadDetails_IH_v1_Test.UPDATE_LEAD_DETAILS_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{UpdateLeadDetails_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        test.startTest();
        String opportunityId;
        Account acc = [SELECT Id, FirstName FROM Account];
        //Monde Masiza - Test the value retrived from the query
        system.AssertEquals('Test', acc.FirstName, 'Account name does not match');
        String updateLeadDetailsResult = ShortTermInsurancePushLead.leadDetailsUpdate(opportunityId, acc.Id);
        test.stopTest();

    }

    @isTest static void pushToPortalPositiveTest(){

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CreateLead_IH_v1.INTEGRATION_SERVICE_NAME});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        test.startTest();

        String opportunityId;
        Opportunity opportunityRecord =  [SELECT Id,Name FROM Opportunity  Limit 1];
        //Monde Masiza - Test the value retrived from the query 
        system.assertEquals('Test Opp Onboarding 1', opportunityRecord.Name, 'Test Opp Onboarding 1');
        String createLeadResult = ShortTermInsurancePushLead.PushToPortal(opportunityRecord.Id);
        test.stopTest();
    }
}