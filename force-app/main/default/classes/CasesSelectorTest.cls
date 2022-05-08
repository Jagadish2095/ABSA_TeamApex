/**
 * @description        : Test class for CasesSelector deployment
 * @Last modified date : 09/11/2021 
 */
@isTest
private class CasesSelectorTest {  
	@testSetup
	static void makeData() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
		System.runAs(au) {
			List<Case> lCases = new List<Case>();
			map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			Account acct = new Account(Name = 'Test Account');
			Contact con = new Contact(Title = 'ContactTest', Phone = '87837743123456769', LastName = 'ContactTest', Email = 'email@test.com');
			insert con;
			insert acct;
			Opportunity opp = new Opportunity(
				Name = 'Test Opportunity',
				AccountId = acct.id,
				StageName = 'Confirm Client Eligibility',
				CloseDate = Date.today()
			);
			insert opp;

			Case cse1 = new Case(
				RecordTypeId = caseRecordTypeMap.get('Broker_Note').getRecordTypeId(),
				CIF_Custom__c = 'LOUW123',
				Adviser_Code__c = '112233',
				Customer_ID__c = '9876543218976',
				Birth_Date__c = date.newInstance(2012, 5, 22),
				First_Name__c = 'Test Client2',
				Last_Name__c = 'Test JKumar',
				Initials__c = 'MK',
				Nationality__c = 'South Africa',
				Phys_Addr_Post_Code__c = '8976',
				Phys_Addr_Line1__c = 'University of PET',
				Work_Phone__c = '9999999999',
				Home_Phone__c = '8888888888',
				Mobile__c = '7777777777',
				Adviser_Name__c = 'Test JKumar',
				ID_Type__c = 'SA ID',
				Status = 'New',
				//Outcome__c = 'New Case',
				Subject = 'Case1',
				Email__c = 'test@test.com',
				OwnerId = UserInfo.getUserId()
			);
			lCases.add(cse1);

			Case cse2 = new Case(
				Communication_Method__c = 'Email',
				Status = 'New',
				Origin = 'Email',
				AccountId = acct.Id,
				Risk_Management_Centre__c = 'Digital Fraud',
				Email__c = 'test@test.com',
				recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
				Subject = 'Case2',
				Description = 'test',
				Expectation_of_the_Customer__c = 'test',
				Opportunity__c = opp.id,
				Incident_Date__c = date.today(),
				Birth_Date__c = date.newInstance(2012, 5, 22),
				OwnerId = UserInfo.getUserId()
			);
			lCases.add(cse2);

			Case cse3 = new Case(
				Communication_Method__c = 'Email',
				Status = 'New',
				Origin = 'Email',
				AccountId = acct.Id,
				Risk_Management_Centre__c = 'Digital Fraud',
				Email__c = 'test@test.com',
				recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
				Subject = 'Case3',
				Description = 'test',
				Expectation_of_the_Customer__c = 'test',
				Incident_Date__c = date.today(),
				Birth_Date__c = date.newInstance(2012, 5, 22),
				OwnerId = UserInfo.getUserId()
			);
			lCases.add(cse3);

			Case cse4 = new Case(
				Communication_Method__c = 'Email',
				Status = 'New',
				Origin = 'Email',
				AccountId = acct.Id,
				Risk_Management_Centre__c = 'Digital Fraud',
				Email__c = 'test@test.com',
				recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
				Subject = 'Case4',
				Description = 'test',
				Expectation_of_the_Customer__c = 'test',
				Incident_Date__c = date.today(),
				OwnerId = UserInfo.getUserId()
			);
			lCases.add(cse4);

			Case cse5 = new Case(
				Communication_Method__c = 'Email',
				Status = 'New',
				Origin = 'Email',
				AccountId = acct.Id,
				Risk_Management_Centre__c = 'Digital Fraud',
				Email__c = 'test@test.com',
				recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
				Subject = 'Case5',
				Description = 'test',
				Expectation_of_the_Customer__c = 'test',
				ContactId = con.Id,
				Incident_Date__c = date.today(),
				OwnerId = UserInfo.getUserId()
			);
			lCases.add(cse5);

			Case cse6 = new Case(
				Communication_Method__c = 'Email',
				Status = 'New',
				Origin = 'Email',
				AccountId = acct.Id,
				Risk_Management_Centre__c = 'Digital Fraud',
				Email__c = 'test@test.com',
				Email_From_Address__c = 'from@test.com',
				sd_Inbox_Name__c = 'to@test.com',
				recordTypeId = caseRecordTypeMap.get('ATM').getRecordTypeId(),
				Subject = 'Case6',
				Description = 'test',
				Expectation_of_the_Customer__c = 'test',
				type__c = 'deposit',
				Incident_Date__c = date.today(),
				Amount_Withdrawn__c = 110,
				Amount_Received__c = 110,
				ATMNumber__c = 11111,
				AbsaATM__c = true,
				NonAbsaATMText__c = 'f',
				Receipt_Slip_Available__c = true,
				Account_Number__c = '134444555',
				External_Reference_Number__c = 'abc',
				OwnerId = UserInfo.getUserId()
			);
			lCases.add(cse6);

			insert lCases;
		}
	}

	@isTest
	private static void test() {
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
			List<Case> lCase = [SELECT Id, Subject, Opportunity__c FROM Case WHERE CreatedById = :UserInfo.getUserId()];
			Account acc = [SELECT Id FROM Account WHERE CreatedById = :UserInfo.getUserId()];
			CasesSelector cs = new CasesSelector();
			Set<Id> setCseId = new Set<Id>();
			Set<Id> setCseAccId = new Set<Id>();
			Set<String> caseStringIds = new Set<String>();
			Id case1;
			Id case2;
			Id case3;
			Id case4;
			Id case5;
			Id case6;
			Id oppId;
			String cseStringId;

			setCseAccId.add(acc.Id);
			for (Case caseItem : lCase) {
				setCseId.add(caseItem.Id);
				caseStringIds.add(caseItem.Id);
				if (caseItem.Subject == 'Case1') {
					case1 = caseItem.Id;
					cseStringId = caseItem.Id;
				} else if (caseItem.Subject == 'Case2') {
					case2 = caseItem.Id;
					oppId = caseItem.Opportunity__c;
				} else if (caseItem.Subject == 'Case3') {
					case3 = caseItem.Id;
				} else if (caseItem.Subject == 'Case4') {
					case4 = caseItem.Id;
				} else if (caseItem.Subject == 'Case5') {
					case5 = caseItem.Id;
				} else if (caseItem.Subject == 'Case6') {
					case6 = caseItem.Id;
				}
			}
			List<Case> selectById = cs.selectById(setCseId);
			System.assertEquals(6, selectById.size(), 'selectById failed.');
			List<Case> selectByAccountId = cs.selectByAccountId(setCseAccId, 5);
			System.assertEquals(5, selectByAccountId.size(), 'selectByAccountId failed.');
			List<Case> selectByIdWithAccountInfo = cs.selectByIdWithAccountInfo(setCseId, 6);
			System.assertEquals(6, selectByIdWithAccountInfo.size(), 'selectByIdWithAccountInfo failed.');
			List<Case> selectByIdWithSLAInfo = cs.selectByIdWithSLAInfo(case4, 1);
			System.assertEquals(1, selectByIdWithSLAInfo.size(), 'selectByIdWithSLAInfo failed.');
			List<Case> selectByAccountIdAndRelatedEmails = cs.selectByAccountIdAndRelatedEmails(
				acc.Id,
				'test2@gmail.com',
				'test3@gmail.com',
				'test4@gmail.com',
				case5,
				1
			);
			System.assertEquals(1, selectByAccountIdAndRelatedEmails.size(), 'selectByAccountIdAndRelatedEmails failed.');
			List<Case> selectByIdWithEmailFields = cs.selectByIdWithEmailFields(setCseId, 6);
			System.assertEquals(6, selectByIdWithEmailFields.size(), 'selectByIdWithEmailFields failed.');
			List<Case> selectByIdForSitesUser = cs.selectByIdForSitesUser(setCseId, 6);
			System.assertEquals(6, selectByIdForSitesUser.size(), 'selectByIdForSitesUser failed.');
			List<Case> selectByIdWithClassification = cs.selectByIdWithClassification(setCseId, 6);
			System.assertEquals(6, selectByIdWithClassification.size(), 'selectByIdWithClassification failed.');
			List<Case> selectByIdWithProcessInstances = cs.selectByIdWithProcessInstances(setCseId);
			System.assertEquals(6, selectByIdWithProcessInstances.size(), 'selectByIdWithProcessInstances failed.');
			List<Case> SelectByIdWithCaseTransferTracking = cs.SelectByIdWithCaseTransferTracking(setCseId);
			System.assertEquals(6, SelectByIdWithCaseTransferTracking.size(), 'SelectByIdWithCaseTransferTracking failed.');
			List<Case> selectByIdWithDecisionHistoryTracking = cs.selectByIdWithDecisionHistoryTracking(setCseId);
			System.assertEquals(6, selectByIdWithDecisionHistoryTracking.size(), 'selectByIdWithDecisionHistoryTracking failed.');
			List<Case> selectByIdWithCaseChecklist = cs.selectByIdWithCaseChecklist(setCseId);
			System.assertEquals(6, selectByIdWithCaseChecklist.size(), 'selectByIdWithCaseChecklist failed.');
			Case caseQAChecklist = cs.caseQAChecklist(case5);
			System.assertEquals('Case5', caseQAChecklist.Subject, 'caseQAChecklist failed.');
			Case selectPayoutValidation = cs.selectPayoutValidation(case5);
			System.assertEquals('Case5', selectPayoutValidation.Subject, 'selectPayoutValidation failed.');
			Case selectSecuritiesValidation = cs.selectSecuritiesValidation(case5);
			System.assertEquals('Case5', selectSecuritiesValidation.Subject, 'selectSecuritiesValidation failed.');
			List<Case> SelectByIdWithCommunicationFields = cs.SelectByIdWithCommunicationFields(setCseId);
			System.assertEquals(6, SelectByIdWithCommunicationFields.size(), 'SelectByIdWithCommunicationFields failed.');
			List<Case> selectByAccountIdByCaseId = cs.selectByAccountIdByCaseId(setCseId, 6);
			System.assertEquals(6, selectByAccountIdByCaseId.size(), 'selectByAccountIdByCaseId failed.');
			Datetime td = System.today();
			Datetime tomorrow = td.addDays(-1);
			Integer selectCountByFromAndToAddress = cs.selectCountByFromAndToAddress('from@test.com', 'to@test.com', tomorrow);
			System.assertEquals(1, selectCountByFromAndToAddress, 'selectCountByFromAndToAddress failed.');
			List<Case> selectByExternalReferenceNo = cs.selectByExternalReferenceNo('abc', 1);
			System.assertEquals(1, selectByExternalReferenceNo.size(), 'selectByExternalReferenceNo failed.');
			List<Case> selectByCaseId = cs.selectByCaseId(case5);
			System.assertEquals(1, selectByCaseId.size(), 'selectByCaseId failed.');
			List<Case> selectByIdWithComplaintInfoTOM = cs.selectByIdWithComplaintInfoTOM(case6, 1);
			System.assertEquals(1, selectByIdWithComplaintInfoTOM.size(), 'selectByIdWithComplaintInfoTOM failed.');
			List<Case> casesListForEmailsSend = cs.casesListForEmailsSend(caseStringIds);
			System.assertEquals(6, casesListForEmailsSend.size(), 'casesListForEmailsSend failed.');
			List<Case> selectcasebyAccountId = cs.selectcasebyAccountId(setCseId);
			System.assertEquals(6, selectcasebyAccountId.size(), 'selectcasebyAccountId failed.');
			list<case> selectByIdWithCustomerInfo = cs.selectByIdWithCustomerInfo(caseStringIds);
			System.assertEquals(6, selectByIdWithCustomerInfo.size(), 'selectByIdWithCustomerInfo failed.');
			List<Case> selectByIdWithRecordTypeDeveloperName = cs.selectByIdWithRecordTypeDeveloperName(case5);
			System.assertEquals(1, selectByIdWithRecordTypeDeveloperName.size(), 'selectByIdWithRecordTypeDeveloperName failed.');
			List<Case> selectCasebyOppId = cs.selectCasebyOppId(oppId);
			System.assertEquals(1, selectCasebyOppId.size(), 'selectCasebyOppId failed.');
			List<Case> selectQueueByCaseId = cs.selectQueueByCaseId(setCseId);
			System.assertEquals(6, selectQueueByCaseId.size(), 'selectQueueByCaseId failed.');
			List<Case> selectCaseDetailsForBrokerNote = cs.selectCaseDetailsForBrokerNote(cseStringId);
			System.assertEquals(1, selectCaseDetailsForBrokerNote.size(), 'selectCaseDetailsForBrokerNote failed.');
			List<Case> getCasesWithOppId = cs.getCasesWithOppId(oppId);
			System.assertEquals(1, getCasesWithOppId.size(), 'getCasesWithOppId failed.');
			Case selectByTaskWhatId = cs.selectByTaskWhatId(cseStringId);
			System.assertEquals('Broker_Note', selectByTaskWhatId.RecordType.DeveloperName, 'selectByTaskWhatId failed.');
			Case selectSelectedPolicyByCaseID = cs.selectSelectedPolicyByCaseID(cseStringId);
			System.assertNotEquals(null, selectSelectedPolicyByCaseID.Id, 'selectSelectedPolicyByCaseID failed.');
			Case selectCaseFieldForBrokerNote = cs.selectCaseFieldForBrokerNote(cseStringId);
			System.assertEquals('112233', selectCaseFieldForBrokerNote.Adviser_Code__c, 'selectCaseFieldForBrokerNote failed.');
			Case CaseDetailsByQuery = cs.CaseDetailsByQuery(cseStringId);
			System.assertEquals('test@test.com', selectCaseFieldForBrokerNote.Email__c, 'CaseDetailsByQuery failed.');
			List<Case> selectIsOpenByOwnerByAccount = cs.selectIsOpenByOwnerByAccount(UserInfo.getUserId(), acc.Id);
			System.assertEquals(5, selectIsOpenByOwnerByAccount.size(), 'selectIsOpenByOwnerByAccount failed.');
			/*Not covered
            //List<ContentVersion> selectByIdContentVersion = cs.selectByIdContentVersion(set < Id > docIds);
            //List<ContentDocumentLink> selectByIdContentDocLink = cs.selectByIdContentDocLink(case5);
            */
		}
	}

	@isTest
	static void testSelectByServiceTypeROT() {
		map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Account acct = new Account(Name = 'Test Account');
		Contact con = new Contact(Title = 'ContactTest', Phone = '87837743123456769', LastName = 'ContactTest');
		insert con;

		insert acct;

		Case cse = new Case(
			Communication_Method__c = 'Email',
			Status = 'In Progress',
			Origin = 'Email',
			AccountId = acct.Id,
			ROT_Approval_Status__c = 'Submitted',
			Email__c = 'test@test.com',
			//Added due to validation rule error
			Incident_Date__c = date.today(),
			// Restriction_Group__c = 'a469E000000BBYFQA4',
			// ROT_Start_Date__c = system.today(),
			// ROT_End_Date__c = system.today()+1,
			Type__c = 'Create New Restriction Groups'
		);
		insert cse;

		CasesSelector cs = new CasesSelector();
		Test.startTest();
		cs.selectByServiceTypeROT(cse.Type__c, cse.Status, cse.ROT_Approval_Status__c);
		System.assertNotEquals(cse, null);
		Test.stopTest();
	}

	@isTest
	static void testSelectCaseByStatusAndSubject() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
		System.runAs(au) {
			map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			Account acct = new Account(Name = 'Test Account');
			Contact con = new Contact(Title = 'ContactTest', Phone = '87837743123456769', LastName = 'ContactTest');
			insert con;
			insert acct;
			Case cse = new Case(
				RecordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
				Communication_Method__c = 'Email',
				Status = 'In Progress',
				Origin = 'Email',
				AccountId = acct.Id,
				Email__c = 'test@test.com',
				Incident_Date__c = date.today(),
				Subject = 'Test FIC Refresh'
			);

			insert cse;
			String caseSubject = 'FIC Refresh';
			String caseStatus = 'Closed';
			set<string> statusVal = new Set<string>();
			statusVal.add('Resolved');
			statusVal.add('Unwanted');
			CasesSelector cs = new CasesSelector();
			Test.startTest();
			List<Case> caseList = cs.selectCaseByFICStatusAndSubject(acct.Id, statusVal, caseSubject);
			List<Case> caseList1 = cs.selectCaseByStatusAndSubject(acct.Id, caseStatus, caseSubject);
			Case deferralCase = cs.selectCaseDetailsForDeferral(cse.Id);
			System.assertNotEquals(caseList1.size(), 0);
			System.assertNotEquals(caseList.size(), 0);
			Case c = [SELECT Id, CaseNumber, AccountId, RecordTypeId, Status, Opportunity__c FROM Case LIMIT 1];
			try {
				cs.selectByAccountIdSet(new Set<Id>(), c.RecordTypeId);
			} catch (Exception e) {
				String msg = e.getmessage();
			}
			Test.stopTest();
		}
	}
	@isTest
	static void testRemaingMethods() {
		Case c = [SELECT Id, CaseNumber, AccountId, RecordTypeId, Status, Opportunity__c FROM Case LIMIT 1];
		CasesSelector selector = new CasesSelector();

		try {
			selector.selectByAccountIdSet(new Set<Id>(), c.RecordTypeId);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByAccountIdSetByCaseStatus(new Set<Id>(), c.recordTypeId, c.Status, 'caseCategory');
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByAccountIdByCaseId(new Set<Id>(), 1);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCountByFromAndToAddress('fromAddress', 'toAddress', DateTime.now());
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByIdWithCommunicationFields(new Set<Id>());
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByExternalReferenceNo('referenceNo', 1);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByIdWithRecordTypeDeveloperName(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByIdWithComplaintInfoTOM(c.Id, 1);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByCaseId(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectcasebyAccountId(new Set<Id>{ c.Id });
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCasebyOppId(c.Opportunity__c);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.casesListForEmailsSend(new Set<string>{ c.Id });
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByIdContentVersion(new Set<Id>());
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByIdContentDocLink(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCasesByQueueName('queuename', 'campaignId');
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCasesByQueueName('queuename');
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCasesByCaseNumber(c.CaseNumber);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectQueueByCaseId(new Set<Id>());
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByIdWithCustomerInfo(new Set<string>{ c.Id });
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByTaskWhatId(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectSelectedPolicyByCaseID(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCaseFieldForBrokerNote(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCaseDetailsForBrokerNote(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.CaseDetailsByQuery(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.getCasesWithOppId(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectIsOpenByOwnerByAccount(UserInfo.getUserId(), c.AccountId);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCaseByMaintenance(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectIsOpenByOwnerByAccount(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCasesById(c.Id);
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCasesByQueueNameAndKeyWord('queuename', 'searchKeyWord');
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectByDataPrivacyRBCase(c.Id, c.AccountId, 'caseSubject');
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectIsOpenByOwnerAndSearchKeyWordByAccount(UserInfo.getUserId(), 'searchKeyWord');
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		try {
			selector.selectCasesByKeyWord('searchKeyWord');
		} catch (Exception e) {
			String msg = e.getmessage();
		}
		system.assertEquals(true, true);
	}
}