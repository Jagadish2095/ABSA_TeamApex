/**
 * @author  Thabo Senkomane
 * @since   2020-09-25
*/
@isTest
public class ApplicationExposureCashInvSelectorTest {
    @testSetup static void createData(){
       ClientDetailsSectionCreditTest.dataCreation();
    }

/*    static testMethod void testGetSObjectType() {
        System.assert(new ApplicationExposureCashInvSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {
        System.assert(new ApplicationExposureCashInvSelector().getSObjectFieldList() != null);
    }*/

    static testmethod void testgetAppCashInvestByCientCode(){
        String clientCode = 'AABK   007';
        Application__c app = [SELECT Id FROM Application__c LIMIT 1];
        Test.startTest();
        System.assert(new ApplicationExposureCashInvSelector().getAppCashInvestByCientCode(clientCode, app.Id) != null);
        Test.stopTest();
    }

    static testMethod void testselectByApplicationId() {
        Application__c app = [SELECT Id FROM Application__c LIMIT 1];
        Test.startTest();
        System.assert(new ApplicationExposureCashInvSelector().getAllApplicationExposureCashInvestByAppId(app.Id) != null);
        Test.stopTest();
    }
}