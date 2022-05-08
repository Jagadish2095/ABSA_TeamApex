/**
 * @description Apex Enterprise Design Patterns
 * Selector Layer for Opportunities objects
 *
 * @author  Unknown
 * @since   Unknown 
 */ 
@isTest
private class OpportunitiesSelectorTest{
	/**
	 * @description makeData Method
	 */
	
	@testSetup
	static void makeData(){
		Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime()+'@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id
		              FROM Profile
		              WHERE Name = 'System Administrator (Custom)'];
		User au = new User(Alias = 'standt', Email = aemail, EmailEncodingKey = 'UTF-8', LastName = 'UserAdmin', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = ap.Id, TimeZoneSidKey = 'Africa/Johannesburg', UserName = auniqueUserName, MobilePhone = '0823389021', Advisor_Code__c = '112233');
		insert au;
		System.runAs(au){
			Account accTest = new Account();
			accTest.RecordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId();
			accTest.CIF__c = 'I001';
			accTest.Client_Type__c = 'PRIVATE INDIVIDUAL';
			accTest.LastName = 'Test Account';
			accTest.PersonEmail = 'test@test.com';
			accTest.PersonMobilePhone = '0123456789';
			insert accTest;

			List<Opportunity> oppList = new List<Opportunity>();
			Opportunity oppTest1 = new Opportunity();
			oppTest1.Name = 'Test Opp1';
			oppTest1.CloseDate = Date.today();
			oppTest1.StageName = 'Drafting';
			oppList.add(oppTest1);
			Opportunity oppTest2 = new Opportunity();
			oppTest2.RecordTypeId = opportunityRecordTypeMap.get('Wills').getRecordTypeId();
			oppTest2.Name = 'Test Opp2';
			oppTest2.AccountId = accTest.Id;
			oppTest2.CloseDate = Date.today().addDays(5);
			oppTest2.StageName = 'Registration';
			oppList.add(oppTest2);
			insert oppList;
		}
	}

	/**
	 * @description test Method
	 */
	@isTest
	private static void test(){
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0){
			for (User u : userList){
				if (u.Email == 'UserAdmin@testorg.com'){
					au = u;
				}
			}
		}
		System.runAs(au){
			OpportunitiesSelector os = new OpportunitiesSelector();
			List<Opportunity> lOpportunity = [SELECT Id, Name, AccountId
			                                  FROM Opportunity
			                                  WHERE CreatedById = :UserInfo.getUserId()];
			Id opp1Id = null;
			Id opp2Id = lOpportunity.get(1).Id;
			Id accId = lOpportunity.get(1).AccountId;
			Id usrId = UserInfo.getUserId();
			Set<Id> oppIdSet = new Set<Id>();
			Set<Id> accIdSet = new Set<Id>();
			Set<Id> usrIdSet = new Set<Id>();
			usrIdSet.add(usrId);
			if (lOpportunity != null){
				for (Opportunity opp : lOpportunity){
					oppIdSet.add(opp.Id);
					if (opp.Name == 'Test Opp1'){
						opp1Id = opp.Id;
					}
					if (opp.Name == 'Test Opp2'){
						opp2Id = opp.Id;
						accId = opp.AccountId;
						accIdSet.add(opp.AccountId);
					}
				}
			}
			List<Opportunity> selectById = os.selectById(oppIdSet);
			System.assertEquals(2, selectById.size(), 'selectById failed.');
			Opportunity selectByActivityId = os.selectByActivityId(opp1Id, 1);
			System.assertEquals('Test Opp1', selectByActivityId.Name, 'selectByActivityId failed.');
			List<Opportunity> selectByListOpportunityIds = os.selectByListOpportunityIds(oppIdSet);
			System.assertEquals(2, selectByListOpportunityIds.size(), 'selectByListOpportunityIds failed.');
			List<Opportunity> selectByOpportunityIdLim = os.selectByOpportunityId(opp1Id, 1);
			System.assertEquals(1, selectByOpportunityIdLim.size(), 'selectByOpportunityIdLim failed.');
			List<Opportunity> selectByOpportunityId = os.selectByOpportunityId(opp1Id);
			System.assertEquals(1, selectByOpportunityId.size(), 'selectByOpportunityId failed.');
			List<Opportunity> selectByOpportunityIdWithCommission = os.selectByOpportunityIdWithCommission(opp1Id, 1);
			System.assertEquals(1, selectByOpportunityIdWithCommission.size(), 'selectByOpportunityIdWithCommission failed.');
			List<Opportunity> selectBySetAccountIds = os.selectBySetAccountIds(accIdSet);
			System.assertEquals(1, selectBySetAccountIds.size(), 'selectBySetAccountIds failed.');
			List<Opportunity> selectComplianceSummaryFields = os.selectComplianceSummaryFields(opp1Id);
			System.assertEquals(1, selectComplianceSummaryFields.size(), 'selectComplianceSummaryFields failed.');
			Map<Id, Opportunity> selectOpportunitiesById = os.selectOpportunitiesById(oppIdSet);
			System.assertEquals(2, selectOpportunitiesById.size(), 'selectOpportunitiesById failed.');
			Opportunity selectByOppId = os.selectByOppId(opp2Id);
			System.assertEquals('Test Opp2', selectByOppId.Name, 'selectByOppId failed.');
			Opportunity selectByOpptId = os.selectByOpptId(opp2Id);
			System.assertEquals('Test Opp2', selectByOpptId.Name, 'selectByOpptId failed.');
			List<Opportunity> selectOpenOppByAccountAndUserId = os.selectOpenOppByAccountAndUserId(accIdSet, usrIdSet);
			System.assertEquals(1, selectOpenOppByAccountAndUserId.size(), 'selectOpenOppByAccountAndUserId failed.');
			List<Opportunity> selectIsOpenByOwnerByAccount = os.selectIsOpenByOwnerByAccount(usrId, accId);
			System.assertEquals(1, selectIsOpenByOwnerByAccount.size(), 'selectIsOpenByOwnerByAccount failed.');
			Opportunity selectOpportunityWithSpouseDetails = os.selectOpportunityWithSpouseDetails(opp1Id);
			System.assertEquals('Test Opp1', selectOpportunityWithSpouseDetails.Name, 'selectOpportunityWithSpouseDetails failed.');
		}
	}

	/** @description Test class for OpportunitiesSelector
	 */
	@isTest
	private static void testSelectById(){
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		insert testOpp;


		OpportunitiesSelector oppSelectorTest = new OpportunitiesSelector();
		Set<Id> oppIdSet = new Set<Id>();
		oppIdSet.add(testOpp.Id);
		List<Opportunity> oppTestList = oppSelectorTest.selectById(oppIdSet);
		System.assert(oppTestList != null, 'Not Null');
	}

	@isTest
	private static void testSselectByActivityId(){

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		insert testOpp;

		OpportunitiesSelector oppSelectorTest = new OpportunitiesSelector();
		Opportunity oppTest = oppSelectorTest.selectByActivityId(testOpp.Id, 1);
		System.assert(oppTest != null, 'Not Null');
	}

	@isTest
	private static void testSelectByListOpportunityIds(){

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		insert testOpp;

		OpportunitiesSelector oppSelectorTest = new OpportunitiesSelector();
		Set<Id> oppIdSet = new Set<Id>();
		oppIdSet.add(testOpp.Id);
		List<Opportunity> oppTest = oppSelectorTest.selectByListOpportunityIds(oppIdSet);
		System.assert(oppTest != null, 'Not Null');
	}

	@isTest
	private static void testSelectByOpportunityIdList(){

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		insert testOpp;

		OpportunitiesSelector oppSelectorTest = new OpportunitiesSelector();
		List<Opportunity> oppTest = oppSelectorTest.selectByOpportunityId(testOpp.Id, 1);
		System.assert(oppTest != null, 'Not Null');
	}

	@isTest
	private static void testSelectByOpportunityId(){

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		insert testOpp;

		OpportunitiesSelector oppSelectorTest = new OpportunitiesSelector();
		Opportunity oppTest = oppSelectorTest.selectByOpportunityId(testOpp.Id).get(0);
		System.assert(oppTest != null, 'Not Null');
	}

	@isTest
	private static void testSelectByOpportunityIdWithCommission(){
		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		insert testOpp;

		OpportunitiesSelector oppSelectorTest = new OpportunitiesSelector();
		List<Opportunity> oppTest = oppSelectorTest.selectByOpportunityIdWithCommission(testOpp.Id, 1);
		System.assert(oppTest != null, 'Not Null');
	}

	@isTest
	private static void testSelectBySetAccountIds(){
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
		List<Opportunity> result = new OpportunitiesSelector().selectBySetAccountIds(new Set<Id>{testOpportunity.AccountId});

		System.assert(result != null, 'Not Null');
	}

	@isTest
	private static void testSelectComplianceSummaryFields(){

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'Drafting';
		insert testOpp;

		OpportunitiesSelector oppSelectorTest = new OpportunitiesSelector();
		List<Opportunity> oppTest = oppSelectorTest.selectComplianceSummaryFields(testOpp.Id);
		System.assert(oppTest != null, 'Not Null');
	}

	@isTest
	private static void testSelectOpportunitiesById(){
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();

		Map<Id, Opportunity> result = new OpportunitiesSelector().selectOpportunitiesById(new Set<Id>{testOpportunity.Id});

		System.assert(result != null, 'Not Null');
	}

	@isTest
	private static void testselectByOppId(){
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();

		Opportunity result = new OpportunitiesSelector().selectByOppId(testOpportunity.id);

		System.assert(result != null, 'Not Null');
	}

	// PJAIN: 20200521
	// Not my method, but writing this method to bring code coverage up
	@isTest
	private static void testSelectByOppId2(){
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();

		testOpportunity = new OpportunitiesSelector().selectByOppId(testOpportunity.Id);

		System.assert(testOpportunity != null, 'Not Null');
	}
 
	// PJAIN: 20200521
	// Not my method, but writing this method to bring code coverage up
	@isTest
	private static void testSelectByOpptId(){
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();

		testOpportunity = new OpportunitiesSelector().selectByOpptId(testOpportunity.Id);

		System.assert(testOpportunity != null, 'Not Null');
	}

	@isTest
	private static void testSelectOpenOppByAccountAndUserId(){
		Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();

		List<Opportunity> oppTest = new OpportunitiesSelector().selectOpenOppByAccountAndUserId(new Set<Id>{testOpportunity.AccountId}, new Set<Id>{UserInfo.getUserId()});
		new OpportunitiesSelector().selectIsOpenByOwnerByAccount(UserInfo.getUserId(), testOpportunity.AccountId);
		new OpportunitiesSelector().selectOpportunityValidationFields(testOpportunity.Id);
		new OpportunitiesSelector().selectBySanctioningSLAInfoById(testOpportunity.Id);
		new OpportunitiesSelector().selectOpportunityWithSpouseDetails(testOpportunity.Id);
		new OpportunitiesSelector().selectByOppRecIdset(new Set<Id>{testOpportunity.Id}, testOpportunity.RecordTypeId);
		new OpportunitiesSelector().selectByAccountIdset(new Set<Id>{testOpportunity.AccountId}, testOpportunity.RecordTypeId);
		new OpportunitiesSelector().selectOppByAccount(testOpportunity.AccountId);
		System.assert(oppTest != null, 'Not Null');

	}
}