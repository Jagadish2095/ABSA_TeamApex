/**
* Apex Enterprise Design Patterns
* Selector Layer Test for FinancialNeedsAnalysisSelector
*
* @author  Nelson Chisoko (Dariel) & Himanshu Nimje
* @since   2019/03/31
*/
@IsTest
private class FinancialNeedsAnalysisSelectorTest {
    static testMethod void testGetSObjectType() {
        Schema.SObjectType result = new FinancialNeedsAnalysisSelector().getSObjectType();

        System.assert(result == Financial_Needs_Analysis__c.getSObjectType());
    }

    static testMethod void testGetSObjectFieldList() {
        List<Schema.SObjectField> result = new FinancialNeedsAnalysisSelector().getSObjectFieldList();

        System.assert(result != null);
    }

    static testMethod void testSelectById() {
        Financial_Needs_Analysis__c testFinancialNeedsAnalysis = new WillsTestDataFactory().testFna;

        List<Financial_Needs_Analysis__c> result = new FinancialNeedsAnalysisSelector().selectById(new Set<Id>{testFinancialNeedsAnalysis.Id});

        System.assert(result != null);
    }

    static testMethod void testSelectLatestById() {
        Financial_Needs_Analysis__c testFinancialNeedsAnalysis = new WillsTestDataFactory().testFna;

        List<Financial_Needs_Analysis__c> result = new FinancialNeedsAnalysisSelector().selectLatestById(testFinancialNeedsAnalysis.Id, 1);

        System.assert(result != null);
    }
}