@isTest
public class CaseDiscountApprovalExtTest {
	public static Account account;
	public static Contact contact;
	public static Case caseRec;
	/**
	 * @description initdata description
	 *
	 */
	public static void initdata() {
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		account = new Account(Name = 'Test Account');
		insert account;

		contact = new Contact(LastName = 'Test contact', AccountId = account.Id);
		insert contact;

		caseRec = new Case(
			DD_Preferred_Communication_Method__c = 'Email',
			Comments__c = 'test',
			Category__c = 'Amendment',
			DD_Sub_Category__c = 'General',
			Status = 'New',
			Origin = 'Email',
			Policy_Number__c = '12334',
			Product_Provider__c = 'test',
			Accountid = Account.id,
			Email__c = 'test@test.com',
			Discount__c = 12,
			recordTypeId = caseRecordTypeMap.get('DD_STI_Case').getRecordTypeId(),
			Subject = 'test'
		);
		insert caseRec;
	}
	@isTest
	public static void casetest() {
		initdata();
		Test.startTest();
		system.assertNotEquals(null, caseRec.Id);

		CaseDiscountApprovalExt.approvalProccessChecks(caseRec.Id);

		CaseDiscountApprovalExt.submitapproval(caseRec.Id);
		Test.stopTest();
	}
}