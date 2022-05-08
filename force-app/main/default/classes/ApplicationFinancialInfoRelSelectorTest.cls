/**
 * Test class for ApplicationFinancialInfoRelSelector class
 *
 * @author  Englarmerdge Mongwe
 * @since   2021-02-24
**/
@IsTest
public class ApplicationFinancialInfoRelSelectorTest {
    @testSetup
    public static void dataCreation() {
        FinancialInformationTriggerTest.FinancialInfoTriggertest();
    }

    static testMethod void testGetSObjectType() {
        System.assert(new ApplicationFinancialInfoRelSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {
        System.assert(new ApplicationFinancialInfoRelSelector().getSObjectFieldList() != null);
    }

    static testMethod void testAllSelectorMethods() {
        Application__c app = [SELECT Id, Name, Account__r.Id FROM Application__c LIMIT 1];
        Financial_Information__c finInfo = new FinancialInformationSelector().selectByAccountId(app.Account__r.Id).get(0);
        Set<ID> idSet = new Set<ID>();
        idSet.add(finInfo.Id);

        System.assert(new ApplicationFinancialInfoRelSelector().selectByApplicationId(app.Id) != null);
        System.assert(new ApplicationFinancialInfoRelSelector().selectByFinancialInfoIds(idSet) != null);
    }
}