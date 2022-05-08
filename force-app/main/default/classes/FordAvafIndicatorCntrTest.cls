/**
* @description       : FordAvafIndicatorCntrTest
* @author            : Mradul Maheshwari
* @last modified on  : 15-10-2021
* @last modified by  : Mradul Maheshwari
* @Work Id           : W-014878
**/
@isTest
public with sharing class FordAvafIndicatorCntrTest {
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ BAPISFContrDetails_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }
    
    @IsTest
    static void getContractDetails() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        
        Test.startTest();
        String response = FordAvafIndicatorCntr.getContractDetailsfromServer(
            '00073552449'
        );
        System.assert(response.StartsWith('['));
        Test.stopTest();
    }
    
    @IsTest
    static void getContractDetailsNegative() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                BAPISFContrDetails_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        User u3 = [SELECT Id FROM User LIMIT 1];
        
        Test.startTest();
        List<Account> accountList = TestDataFactory.getPersonAccounts(
            'lastName',
            'Individual_Client',
            1
        );
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc = 'SA Identity Document';
        accountList[0].ID_Number__pc = '8505225522085';
        insert accountList;
        String response = FordAvafIndicatorCntr.getContractDetailsfromServer(
            null
        );
        System.assert(response.StartsWith('Error'));
        Test.stopTest();
        
    }
    
    @IsTest
    static void getContractDetailsNegative2(){
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        User au = new User(
            Alias = 'standt',
            Email = 'aemail@email.cpom',
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ap.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = 'auniqueUserName@em.com',
            MobilePhone = '0823389021',
            Advisor_Code__c = '112233'
        );
        insert au;
        System.runAs(au) {
            Test.startTest();
            String response = FordAvafIndicatorCntr.getContractDetailsfromServer(
                null
            );
            System.assert(response.StartsWith('Error'));
        }
    }

}