/**
 * Test class for FinancialInformationrmationSelector class
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-09-20
**/
@IsTest
public class FinancialInformationSelectorTest {
    @testSetup
    public static void dataCreation() {
        FinancialInformationTriggerTest.FinancialInfoTriggertest();
    }

    static testMethod void testGetSObjectType() {
        System.assert(new FinancialInformationSelector().getSObjectType() != null);
    }

    static testMethod void testGetSObjectFieldList() {
        System.assert(new FinancialInformationSelector().getSObjectFieldList() != null);
    }

    static testMethod void testAllSelectorMethods() {
        Account acc = [SELECT Id, Name FROM Account LIMIT 1];
        Financial_Information__c finInfo = new FinancialInformationSelector().selectByAccountId(acc.Id).get(0);
        Set<ID> idSet = new Set<ID>();
        idSet.add(finInfo.Id);

        System.assert(new FinancialInformationSelector().selectById(idSet) != null);
        System.assert(new FinancialInformationSelector().selectByFinancialIdsAndYearSel(idSet, new Set<String>{'Forecast'}) != null);
        System.assert(new FinancialInformationSelector().selectByAccountIds(new Set<Id>{acc.Id}) != null);
        System.assert(new FinancialInformationSelector().selectApplicationFinancialById(finInfo.Id) != null);
        System.assert(new FinancialInformationSelector().selectByAccountIdDate(new Set<Id>{acc.Id},Date.today().adddays(-15),'Verified Complete') != null);
    }
}