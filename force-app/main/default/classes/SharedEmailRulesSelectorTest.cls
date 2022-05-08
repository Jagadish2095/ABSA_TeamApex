@isTest 
private class SharedEmailRulesSelectorTest {

    @isTest
    private static void testAll() {
    
        SharedEmailRulesSelector sers = new SharedEmailRulesSelector();
        Schema.SObjectType so = sers.getSObjectType();
        List<Schema.SObjectField> lSers = new List<Schema.SObjectField>();
        lSers = sers.getSObjectFieldList();
    }
}