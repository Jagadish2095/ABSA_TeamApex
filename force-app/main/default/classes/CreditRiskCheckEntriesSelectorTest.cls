@isTest
public class CreditRiskCheckEntriesSelectorTest {

    @isTest
    private static void selectByAccountIdAndServiceTypeTest() {

        Credit_Risk_Check__c crc =  [SELECT Id FROM Credit_Risk_Check__c LIMIT 1];
        List<String> crcIds = new List<String>();
        crcIds.add(crc.id);

        Test.startTest();
        List<Credit_Risk_Check_Entry__c> crceList = new CreditRiskCheckEntriesSelector().selectByCreditRiskCheckIdList(crcIds);
        Test.stopTest();
        System.assertEquals(1, crceList.size());
    }

    @TestSetup
    static void createTestData(){

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        Credit_Risk_Check__c crc = new Credit_Risk_Check__c();
        crc.AccountId__c = testDataFactory.testAccount.Id;
        crc.Service_Type__c = 'TransUnion';
        insert crc;

        Credit_Risk_Check_Entry__c crce = new Credit_Risk_Check_Entry__c();
        crce.Credit_Risk_Check__c = crc.Id;
        crce.Entry_Type__c = 'Default';
        insert crce;
    }
}