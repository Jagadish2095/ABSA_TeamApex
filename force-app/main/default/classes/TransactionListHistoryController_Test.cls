/**
 * @description Controller Test Class For transactionHistory
 * @author Mashudu Raidimi
 * @created   2020/03/05
 */
@isTest
public class TransactionListHistoryController_Test {
	@testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account');
		insert account;

		Account testAcc = new Account(Name = 'Test Acc', CIF__c = 'TEST01');
		insert testAcc;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = testAcc.Id, Email = 'agents@support.co.za');
		insert contact;

		Service_Group__c serviceGroupRecord = new Service_Group__c(
			Name = 'Everyday Banking',
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Service Request',
			Response_Email_Address__c = 'businessbanking@absa.africa'
		);

		insert serviceGroupRecord;
		Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Document_Template__c docTemp = new Document_Template__c(
			Name = 'Transaction_History_List',
			Document_Type__c = 'Transaction_History_List',
			XML__c = '{TransactionInfo}'
		);
		insert docTemp;

		Case testCase = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			AccountId = testAcc.Id,
			Risk_Management_Centre__c = 'Digital Fraud',
			Email__c = 'test@test.com',
			recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			sd_Service_Group_Id__c = serviceGroupRecord.Id,
			Incident_Date__c = date.today()
		);

		insert testCase;
	}

	@isTest
	public static void testCIGetAccount() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';
		accountList[0].CIF__c = 'ARENTAL001';
		insert accountList;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		String responseBean = TransactionListHistoryController.getAccountDetails(accountList[0].Id);
		system.assertEquals(true, responseBean.startsWith('['), 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	public static void testtransactionHistory() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '9302212347096';
		accountList[0].AccountNumber = '4047995828';

		insert accountList;

		List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
		caseList[0].Subject = 'TESTCASE123';

		Date sla = Date.today().addDays(15);
		caseList[0].External_SLA_End_Date__c = sla;
		caseList[0].AccountId = accountList[0].Id;

		insert caseList;

		Transaction_Filter_List__c trans = new Transaction_Filter_List__c();

		trans.Processing_Date__c = Date.today().addDays(-15);
		trans.Effective_Date__c = Date.today().addDays(-15);
		trans.Description1__c = 'TEST1232';
		trans.Description2__c = 'TEST1232';
		trans.Description3__c = 'TEST1232';
		trans.Transaction_Amount__c = '2000';
		trans.Transaction_Cost__c = '10';
		trans.Balance_After_Transaction__c = '25400';
		trans.Transaction_Type__c = '21';
		trans.Event_Number__c = '1';
		trans.Line_Number__c = '12';
		trans.Transaction_Category__c = '12';

		insert trans;

		Test.setMock(HttpCalloutMock.class, new NhlistAcctTransHIstoryv5_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.GET_TRANSACTION_HISTORY });
		//IntegrationTestDataFactory.insertIntegrationTranslations();

		Test.startTest();

		String res = TransactionListHistoryController.viewTransactionHistory('4047995828', '20191101', '20200317');
		system.assertEquals(true, res.startsWith('{'), 'Assert Failed');

		Date fromDate = Date.today().addDays(-60);
		Date toDate = Date.today();

		TransactionListHistoryController.loadTransactions('4047995828', fromDate, toDate);

		List<Transaction_Filter_List__c> filterList = TransactionListHistoryController.filterTransactions(
			'',
			String.valueOf(Date.today().addDays(-15)),
			'TEST1232',
			'TEST1232',
			'TEST1232',
			'TEST1232',
			'TEST1232'
		);

		System.assertEquals(0, filterList.size(), 'Assert Failed');

		Test.stopTest();
	}

	@isTest
	static void testGetDocumentData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{
				StringConstants.GET_TRANSACTION_HISTORY,
				Sys_Utilities_General.getEnvironment(),
				DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR
			}
		);
		Test.setMock(HttpCalloutMock.class, new NhlistAcctTransHIstoryv5_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		List<String> endpoints = new List<String>();
		endpoints.add('ECM Query Path');
		endpoints.add('ECM Authenication Path');
		endpoints.add('ECM Add Path');
		endpoints.add('ECM Logout Path');
		endpoints.add('ECM GetItemType Path');
		endpoints.add('ECM Get Path');
		endpoints.add('ECM GetItemTypes Path');

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, endpoints);

		String filteredList = '[{"Processing_Date__c":"2021-03-01","Description1__c":"CREDIT INTEREST","Balance_After_Transaction__c":"+ R 65,152,057.85","Transaction_Amount__c":"+ R 49,941.35","Transaction_Cost__c":" R 0","Event_Number__c":"9972","Line_Number__c":"0","Transaction_Category__c":"0","Id":"a1m7Z000001Ru6fQAC"},{"Processing_Date__c":"2021-03-01","Description1__c":"STOP ORDER TO","Description2__c":"ABSA BANK Journal","Balance_After_Transaction__c":"+ R 65,152,027.85","Transaction_Amount__c":"- R 30.00","Transaction_Cost__c":" R 0","Event_Number__c":"9975","Line_Number__c":"0","Transaction_Category__c":"60","Id":"a1m7Z000001Ru6gQAC"}]';
		String responseBean = '{"NHlistAcctTransactionHistoryV5Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO004","echoKey":"DP78001832493519"},"nhp021o":{"rcde":"0","rcdeType":"0","rcdeSource":null,"rcdeReason":"0","rdesc":null,"moreToCome":"Y","currentBal":"+000000000000264.00","availableBal":"+000000000000264.00","unclearedAmt":"+000000000000000.00","unclearedEffects":"N","pagingKey":"00000{0000{0010{S2021031E00001179E0000000{0000000000{00{00{","count":"100","statementDetails":[{"processingDate":"20210301","effectiveDate":"0","description1":"CREDIT INTEREST","description2":null,"description3":null,"tranAmount":"+000000000049941.35","tranCost":"0","balAfterTran":"+000000065152057.85","tranType":null,"eventNum":"9972","lineNum":"0","tranCat":"0"}]}}}';
		Account acc = [SELECT Id FROM Account LIMIT 1];
		Test.startTest();

		String response = TransactionListHistoryController.getDocumentData(
			responseBean,
			filteredList,
			'123456',
			'Transaction_History_List',
			acc.Id,
			'01.04.2020',
			'10.10.2020',
			'CQ'
		);
		//Using assertNotEquals to null because the DocumentTemplateProcessor returns no content when running tests
		// and as a result the code to retrieve the generated document cannot be test because of the underlying problem
		Test.stopTest();
		System.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	static void testSendTransactions() {
		Case testCase = [SELECT Id FROM Case LIMIT 1];
		//Using  an HTML template because the HTML body of the email is being set
		EmailTemplate eTemplate = [SELECT Id, DeveloperName FROM EmailTemplate WHERE TemplateType = 'HTML' LIMIT 1];

		Test.startTest();
		String sendEmailResp = TransactionListHistoryController.sendTransactions(
			testCase.Id,
			'test@example.com',
			eTemplate.DeveloperName,
			'sampleBase64PdfData',
			'Transaction History'
		);
		Test.stopTest();
		System.assertEquals('Email sent Successfully', sendEmailResp, 'Assert Failed');
	}
}