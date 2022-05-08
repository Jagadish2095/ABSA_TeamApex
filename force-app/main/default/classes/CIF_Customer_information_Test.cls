/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-11-17
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@IsTest
private class CIF_Customer_information_Test {

    @testSetup
    static void testSetup() {
        /*
        Account theAcc = new Account();
        theAcc.name = 'test acc';
        theAcc.Client_group__c = 'Individual';
		theAcc.Client_Type__c = 'Individual';
        insert theAcc;
        */
        Account theAcc = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');

        
        Case caseInTest = new Case( Birth_Date__c = null,
                                    Product_Type__c = 'Some type',
                                    Last_Name__c = 'TestName' , AccountId = theAcc.Id
                                    );
        insert caseInTest;
    }
    @IsTest
    static void testGetCase() {
        Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Compliance Pack','Risk Rating service' });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'CASA Primary Client Screening v2' });
        Case casSelect = [SELECT Id, AccountId ,Product_Type__c FROM Case LIMIT 1];
        Integration_Translation__c it = new Integration_Translation__c();
        it.System_Name__c = 'eCasa';
        it.Value_Type__c = 'Country';
        it.Internal_Value__c = 'South Africa';
        it.Direction__c = 'Outbound';
        it.External_Value__c = 'Test';
        it.Name = 'Test Record';
        insert it;
        Test.startTest();
        Case cas = CIF_Customer_information.getCase(casSelect.Id);
        Account acc = new Account();
        CIF_Customer_information.getselectOptions(acc,'Occupation_Category__pc');
        Test.stopTest();

        System.assertEquals(casSelect.Product_Type__c, cas.Product_Type__c, false);
    }

}