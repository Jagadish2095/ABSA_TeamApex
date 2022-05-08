@isTest
public class CreditRiskChecksSelectorTest {

    @isTest
    private static void selectByAccountIdAndServiceTypeTest() {

        Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
        List<Credit_Risk_Check__c> crcList =  new CreditRiskChecksSelector().selectByAccountIdAndServiceType(acc.Id, 'TransUnion');
        Test.stopTest();
        System.assertEquals(1, crcList.size());
    }

    @TestSetup
    static void createTestData(){

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Credit_Risk_Check__c crc = new Credit_Risk_Check__c();
        crc.AccountId__c = testDataFactory.testAccount.Id;
        crc.Service_Type__c = 'TransUnion';
        insert crc;
    }
}