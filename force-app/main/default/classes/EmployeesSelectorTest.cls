@isTest
private class EmployeesSelectorTest {
    
    static testMethod void testGetSObjectType() {
        
        Schema.SObjectType result = new EmployeesSelector().getSObjectType();
        
        System.assert(result != null);
    }
    
    static testMethod void testGetSObjectFieldList() {
        
        List<Schema.SObjectField> result = new EmployeesSelector().getSObjectFieldList();
        
        System.assert(result != null);
    }
    
    static testMethod void testSelectById() {
        
        WillsTestDataFactory testdata = new WillsTestDataFactory();
        Opportunity opportunity = new OpportunitiesSelector().selectByOpportunityId(testdata.testOpportunity.Id).get(0);
        system.debug('opportunity'+opportunity);
        Employee__c result = new EmployeesSelector().selectById(opportunity.Adviser_Employee__c);
 		system.debug('Employee__c'+result);
        System.assert(result != null);
    }
    
}