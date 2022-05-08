/***
 *@description Test class for AccountsSelector deployment
 *@Updated: 2021/11/16 
 *@Updated: 2021/11/29 Added TB Charge account field. Hloni Matsoso
 */
@isTest
public class AccountsSelectorTest {
	@isTest
	
	private static void testSelectByName() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();
		Set<String> accStringSet = new Set<String>();
		accStringSet.add('test Individual0');
		System.Test.startTest();
		List<Account> accByName = acs.selectByName(accStringSet);
		Id testProspectAccountContactId = [SELECT Id, PersonContactId FROM Account WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
		System.assert(acs.selectByOpportunityIdRel(testProspectAccountContactId, 1) != null);
		System.assert(acs.selectIndvByOpportunityId(testDataFactory.testOpportunity.id) != null);
		List<Account> accByCifLKimit = acs.selectByCIF('test', 1);

		Account tstParentAccount = testDataFactory.testAccount;
		tstAccount.ParentId = tstParentAccount.id;
		Set<Id> accParentIdSet = new Set<Id>();
		accParentIdSet.add(tstParentAccount.Id);
		List<Account> accByParentId = acs.selectByParentId(accParentIdSet, 1);
		System.Test.stopTest();
	}

	@isTest
	private static void testSelectByNameSplit1() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();
		System.Test.startTest();
		List<Account> accByNameLimit = acs.selectByName('Test Account', 1);
		List<Account> accByIdNumLimit = acs.SelectByIdNumber('7311277865082', 1);
		List<Account> accByIdNum = acs.SelectAccountByIdNumber('7311277865082');
		//List<Account> accByPaasOrRegLimt = acs.selectByPassportOrRegistrationNumber('7311277865082', 1);
		Account accByCIF = acs.selectByCIF('AFIFTAP001');

		Account testJointAccount = testDataFactory.testJointAccount;
		List<Account> accCasaJointByAccIdLimit = acs.selectCasaFieldsJointAccountById(testJointAccount.Id, 1);
		Account accByOppIdLimit = acs.selectByOpportunityId(tstAccount.Id, 1);
		List<Account> accByAllFieldsLimit = acs.searchByValueOnAllFields('EPP', 2);
		System.assertNotEquals(null, accByAllFieldsLimit, 'not null');
		System.Test.stopTest();
	}

	@isTest
	private static void testSelectByNameTwo() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();

		Set<string> iDNumberSet = new Set<string>();
		iDNumberSet.add('7311205103082');
		System.Test.startTest();
		List<Account> accByIdNumSet = acs.selectbyIDNumbers(iDNumberSet);

		Set<String> cifSet = new Set<String>();
		cifSet.add('AFIFTAP001');
		List<Account> accByCifSet = acs.selectByCIF(cifSet, 1);

		Set<String> emailSet = new Set<String>();
		emailSet.add('test@test.co.za');
		List<Account> accByEmailSet = acs.selectByEmail(emailSet, 1);

		List<Account> accList = new List<Account>();
		accList.add(testDataFactory.testAccount);
		List<Account> accByAccList = acs.selectbyaccContacts(accList);
		Account accByOppId = acs.selectByOpportunityId(testDataFactory.testOpportunity.Id);
		System.assertNotEquals(null, accByOppId, 'not null');
		System.Test.stopTest();
	}

	@isTest
	private static void testSelectByNameTwoSplit2() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();
		System.Test.startTest();
		AccountContactRelation acr = [SELECT Id, ContactId FROM AccountContactRelation WHERE AccountId = :testDataFactory.testJointAccount.id LIMIT 1];
		Account accByPersContIdLimit = acs.selectAccountByPersonContactId(acr.ContactId, 1);
		Account accIndByOppIdNew = acs.selectIndvByOpportunityIdNew(testDataFactory.testOpportunity.Id);
		Account accIndByOppIdUpdate = acs.selectIndvByOpportunityIdUpdate(testDataFactory.testOpportunity.Id);
		list<Account> accAll = acs.selectAllByType('Customer', 2);
		Account accSingle = acs.selectFinancialStatementRedirectFieldsById(testDataFactory.testJointAccount.id);
		list<Account> accLists = acs.selectAccountByCIFAndID('HGYRPW 001', '9010164800088');
		list<Account> accListsNew = acs.selectAccountByIdPassportRegNumber('9010164800088');
		Set<String> pcs = new Set<String>();
		pcs.add('9010164800088');
		list<Account> accSetNew = acs.selectAccountByIdPassportRegNumber(pcs);
		System.assert(accSetNew != null, 'Test Working');
		System.Test.stopTest();
	}

	@isTest
	private static void testgetbyAccountIDset() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();
		Set<Id> accIdSet = new Set<Id>();

		accIdSet.add(tstAccount.Id);
		List<Account> accbyIdSet = acs.selectById(accIdSet);
		//List<Account> accCasaBySetID = acs.selectCasaFieldsBySetId(accIdSet);
		List<Account> accCasaPersByAccIdSet = acs.selectCasaFieldsByPersonContactSetId(accIdSet);
		System.assert(accbyIdSet != null, 'Test Working');
	}

	@isTest
	private static void testgetbyAccountID() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();

		System.Test.startTest();
		Account accRulesEngineByAccId = acs.selectFieldsforRulesEnginebyId(tstAccount.id);
		Account accRulesEngineByAccId2 = acs.selectAccountFieldsCIFById(tstAccount.id);
		Account accPhoneDetailsByID = acs.selectAccountPhoneDetailsByID(tstAccount.id);
		List<Account> accRelPartyByAddressType = acs.selectRelatedPatiesByAddressType(tstAccount.id, 'Registered');
		Account accIndByAccId = acs.selectByIdForIndividual(tstAccount.Id);
		System.assertNotEquals(null, accIndByAccId, 'not null');
		System.Test.stopTest();
	}

	@isTest
	private static void testgetbyAccountIDSplit1() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();

		System.Test.startTest();
		List<Account> accCasaIndByAccIdLimit = acs.selectCasaIndividualFieldsById(tstAccount.Id, 1);
		Account accRefreshByAccId = acs.selectforRefreshById(tstAccount.Id);
		List<Account> accEmailByAccIdLimit = acs.selectEmailFieldsById(tstAccount.Id, 1);
		List<Account> accPhoneByAccIdLimit = acs.selectPhoneFieldsById(tstAccount.Id, 1);
		List<Account> accCasaByAccIdLimit = acs.selectCasaFieldsById(tstAccount.Id, 1);
		System.assertNotEquals(null, accCasaByAccIdLimit, 'not null');
		System.Test.stopTest();
	}

	@isTest
	private static void testgetbyAccountIDSplit2() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();

		System.Test.startTest();
		Account accAllByIdFOrDocs = acs.selectAllByIdFOrDocs(tstAccount.Id);
		Account accByAccId = acs.selectById(tstAccount.Id);
		Account accByAccIdLimit = acs.SelectByAccountId(tstAccount.Id, 1);
		List<Account> accRiskByAccIdLimit = acs.selectRiskFieldsById(tstAccount.Id, 1);
		List<Account> accPriceSchemeByAccId = acs.selectFranchisePriceSchemeIdById(tstAccount.Id);
		System.assertNotEquals(null, accPriceSchemeByAccId, 'not null');
		System.Test.stopTest();
	}

	@isTest
	private static void testgetbyAccountIDSplit3() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		AccountsSelector acs = new AccountsSelector();
		System.Test.startTest();
		Account accAllById = acs.selectAllById(tstAccount.Id);
		System.assert(acs.selectCasaFieldsByIds(tstAccount.Id, 1) != null);
		System.assert(acs.selectByIdForIndividual(tstAccount.Id) != null);
		acs.selectPersonAccountById(tstAccount.Id);
		System.assert(acs.selectRelatedPartyCASAByAccountId(tstAccount.Id) != null);
		System.Test.stopTest();
	}

	@isTest
	private static void testGetByCustomArgs() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		AccountsSelector acs = new AccountsSelector();
		Account testAcc = new Account(Name = 'Test Account', Registration_Number__c = '1997/05');
		insert testAcc;
		List<Account> testAccountList = acs.selectAccountByIdPassportRegNumber('1997/05');
		System.assertNotEquals(0, testAccountList.size(), 'Assert Failed');

		//List<Account> accountIdOrCIFList = acs.selectByIdOrCIF(new Set<String>{ testAcc.Id }, new Set<String>{ 'AFIFTAP001' });
		List<Account> accountCasaBus = acs.selectCasaBusinessFieldsBySetId(new Set<Id>{ testAcc.Id });
		List<Account> accountRelatedParty = acs.selectRelatedPartyBusinessCASAByAccountId(testAcc.Id);
		//System.assertNotEquals(0, accountIdOrCIFList.size(), 'Assert Failed');
	}
}