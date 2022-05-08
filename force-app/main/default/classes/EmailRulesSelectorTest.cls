/**
@description EmailRulesSelectorTest description
*/
@isTest
private class EmailRulesSelectorTest {
	@isTest
	private static void testSelectById() {
		Service_Group__c sq = new Service_Group__c();
		insert sq;
		Email_Rule__c emailRule = new Email_Rule__c();
		emailRule.Route_To_Queue__c = sq.Id;
		emailRule.Active__c = true;
		insert emailRule;

		EmailRulesSelector ers = new EmailRulesSelector();
		Set<Id> tstSet = new Set<Id>();
		tstSet.add(emailRule.Id);
		List<Email_Rule__c> ler = ers.selectById(tstSet);

		System.assertEquals(ler.size(), 1);
	}

	@isTest
	private static void testSelectByIdWithRelatedInfo() {
		Service_Group__c sq = new Service_Group__c();
		insert sq;
		Email_Rule__c emailRule = new Email_Rule__c();
		emailRule.Route_To_Queue__c = sq.Id;
		emailRule.Active__c = true;
		insert emailRule;

		EmailRulesSelector ers = new EmailRulesSelector();
		Set<Id> tstSet = new Set<Id>();
		tstSet.add(emailRule.Id);
		List<Email_Rule__c> ler = ers.selectByIdWithRelatedInfo(tstSet, 1);

		System.assertEquals(ler.size(), 1);
	}

	@isTest
	private static void testSelectSharedEmailDefaultWithRelatedInfo() {
		Service_Group__c sq = new Service_Group__c();
		insert sq;
		Email_Rule__c emailRule = new Email_Rule__c();
		emailRule.Route_To_Queue__c = sq.Id;
		emailRule.Active__c = true;
		insert emailRule;

		EmailRulesSelector ers = new EmailRulesSelector();

		List<Email_Rule__c> ler = ers.selectSharedEmailDefaultWithRelatedInfo(emailRule.Id);

		System.assertEquals(ler.size(), 1);
	}

	@isTest
	private static void testSelectOrgWideDefaultWithRelatedInfo() {
		Service_Group__c sq = new Service_Group__c();
		insert sq;
		Email_Rule__c emailRule = new Email_Rule__c();
		emailRule.Route_To_Queue__c = sq.Id;
		emailRule.Active__c = true;
		emailRule.Org_Wide_Default_Rule__c = true;
		insert emailRule;

		EmailRulesSelector ers = new EmailRulesSelector();

		List<Email_Rule__c> ler = ers.selectOrgWideDefaultWithRelatedInfo();

		System.assertEquals(ler.size(), 1);
	}

	@isTest
	private static void testSelectByExternalCaseReference() {
		Service_Group__c sq = new Service_Group__c();
		insert sq;
		Email_Rule__c emailRule = new Email_Rule__c();
		emailRule.Route_To_Queue__c = sq.Id;
		emailRule.Active__c = true;
		emailRule.Detect_External_Case_Reference__c = true;
		insert emailRule;

		EmailRulesSelector ers = new EmailRulesSelector();

		List<Email_Rule__c> ler = ers.selectByExternalCaseReference();

		System.assertEquals(ler.size(), 1);
	}
}