/**
* Test Class for AssignmentRulesSelector
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2019-04-12
*
**/
@isTest 
private class AssignmentRulesSelectorTest {   
    
    @isTest
    private static void testselectByActiveSoBjectType() {
   
        AssignmentRulesSelector assignmentRulesSelectorTest = new AssignmentRulesSelector();
        List<AssignmentRule> assignmentRuleTestList = assignmentRulesSelectorTest.selectByActiveSoBjectType('Lead', 1);

    }
    
    @isTest
    private static void testselectById() {
   
        AssignmentRulesSelector assignmentRulesSelectorTest = new AssignmentRulesSelector();
        Set<Id> idSet = new Set<Id>();
        List<AssignmentRule> assignmentRuleTestList = assignmentRulesSelectorTest.selectById(idSet);

    }
}