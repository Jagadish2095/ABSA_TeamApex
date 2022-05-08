/**
 * @description Test class for ProofOfPaymentSelController
 *
 * @author  Danie Booysen
 * @version v1.0
 * @since   2021-02-10
 * @updated Koketso Mpshane 2021-03-23
 */
@isTest
public class ProofOfPaymentSelControllerTest {
	@TestSetup
	static void makeData() {
		Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ Sys_Utilities_General.getEnvironment(), DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR }
		);

        List<String> endpoints = new List<String>();
        endpoints.add('ECM Query Path');
        endpoints.add('ECM Authenication Path');
        endpoints.add('ECM Add Path');
        endpoints.add('ECM Logout Path');
        endpoints.add('ECM GetItemType Path');
        endpoints.add('ECM Get Path');
        endpoints.add('ECM GetItemTypes Path');
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, endpoints);

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

		Document_Template__c docTemp = new Document_Template__c(Name = 'Proof of Payment - Beneficiary', Document_Type__c = 'Proof of Payment - Beneficiary');
		insert docTemp;
	}

	@isTest
	static void testGenerateProofOfPayment() {
		String initiatePaymentRespMock = '{"MBinitiatePaymentV10Response":{"nbsapdpo":{"version":"","returnCode":"0","reasonCode":"0","serviceVersion":"","echoKey":""},"nbsmsgo3":{"version":"","sysErrTxt":"","nbrUserMsgs":"0","nbrUserErrs":"0"},"mbn301o":{"todaysDate":"20210212","timeNow":"10060686","respCode":"0","respOther":"0","recsReturn":"1","respDesc":"SUCCESSFUL PROCESS","instrTypeDrcr":"D","instrTypeDuepe":"P","instrTypeAccs":"Y","keyFormat":"","fwWarnInd":"","uniqueEft":"80004B7AD7","intExtBenInd":"I","actDate":"20210212","trigDate":"0","startDate":"20210212","endDate":"20991231","freq":"OOP","srcAccType":"CQ","srcClrCode":"632005","srcInstCode":"ABSA BANK","trgAcc":"000000000000004048254631","trgAccType":"CQ","trgClrCode":"632005","trgInstCode":"ABSA BANK","corpCode":"Z","sbu":"F","clientType":"I","minPayAmnt":"0","maxPayAmnt":"9999999999999.99","iipAllowInd":"N","lastChangeNo":"2","lastMaintFunc":"ADD","lastMaintDate":"20210212","lastMaintTime":"10060686","lastMaintBrnch":"00008980","lastMaintTell":"99999","lastMaintOvrId":"","paymNo":"1","paymBusRef":"","lastMaintOvr2Id":"","lastPaymDate":"20210212","lastPaymAmnt":"500","lastPaymErr":"","abal":"65110044.5","avbl":"65110044.5","statusCde":"0","statusIndx":"0","statusDesc":"","primEvno":"9286","secEvno":"795","emvscScriptDataLgth":"0","emvscScriptData":"","productsSpa":"","initpaymOverride":"","benGender":"","benNonResStat":""}}}';
		String uiInputFieldsMock = '{"YourReference":"MyRef","Amount":250.00,"ImmediatePayment":false,"RecipientRef":"RecRef","RecipientName":"Name"}';
		Account acc = [SELECT Id FROM Account LIMIT 1];

		Test.startTest();
		String response = ProofOfPaymentSelController.generateProofOfPayment(
			initiatePaymentRespMock,
			uiInputFieldsMock,
			'Proof of Payment - Beneficiary',
			acc.Id
		);
		//Using assertNotEquals to null because the DocumentTemplateProcessor returns no content when running tests
		// and as a result the code to retrieve the generated document cannot be test because of the underlying problem
		System.assertNotEquals(null, response, 'Assert Failed');
		Test.stopTest();
	}

    @isTest
    static void generateHistoricalOOP() {
        String testOnceOffPayment = '{"targetBusinessCode": "0000000","endDate": "20991231","sourceClrCode": "632005","sourceAccountType": "CQ","uniqueEFT": "800037414E","ivrNominate": "00000","sourceInstCode": "ABSA BANK","sourceStatementRef": "kk","actDate": "20200311","frequency": "OOP","mandNumber": "0000000","clientType": "I","lastMaintDate": "20200311","cifKey": "JINPIX 001","targetAccountType": "CQ","timeRange": "000","iipAllowIndicator": "N","amount": "2.00","freeBankIndicator": "N","tieb": "00001","sourceAccount": "000000000000004048154875","instrStatus": "CURRENT","instrType": "OOP","multiNumber": "00000","targetInstCode": "ABSA BANK","intExtBenIndicator": "I","targetClrCode": "632005","priNumber": "000","lastMaintTeller": "11012","instrNumber": "0000001","payDay": "00","targetAccount": "000000000000004048254681","startDate": "20200311"}';
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        String response = ProofOfPaymentSelController.generateHistoricalOOP(
            testOnceOffPayment,
            'Proof of Payment - Beneficiary',
            acc.Id
        );
		//Using assertNotEquals to null because the DocumentTemplateProcessor returns no content when running tests
		// and as a result the code to retrieve the generated document cannot be test because of the underlying problem
        System.assertNotEquals(null, response, 'Assert Failed');
        Test.stopTest();
    }

    @isTest
    static void generateHistoricalBenPayment() {
        String testBeneficiaryPayment = '{"instrStatus": null,"intExtBenInd": null,"actDate": "20201028","trigDate": "20201028","amount": 1,"srcAcc": "000000000000001011110050","srcAccType": "CQ","srcClrCode": "632005","srcInstCode": "ABSA BANK","srcStmtRef": "Example3","trgAcc": "000000000000001655549691","trgAccType": "01","trgClrCode": "470010","trgInstCode": "CAPITEC","trgStmtRef": "Example3","corpCode": "Z","sbu": "B","payDay": "0","doType": null,"cardAuth": null,"notifInd": null,"srcNotifMed": "N","trgNotifMed": "N","changeOverride": null,"changeOverride2": null,"lastMaintOvr2Id": null,"paymStatus": "COMPIIPENQ","paymTime": "113012","paymProcessAmnt": 1,"paymErrCode": "476","iipInd": "D","iipAuth": null,"busRef": "1605F9F3A5","paymNotes": null}';
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        String response = ProofOfPaymentSelController.generateHistoricalBenPayment(
            testBeneficiaryPayment,
            'John Doe',
            '80002D83AB',
            'Proof of Payment - Beneficiary',
            acc.Id
        );
		//Using assertNotEquals to null because the DocumentTemplateProcessor returns no content when running tests
		// and as a result the code to retrieve the generated document cannot be test because of the underlying problem
        System.assertNotEquals(null, response, 'Assert Failed');
        Test.stopTest();
    }

	@isTest
	static void testSendEmailWithAttach() {
		Case testCase = [SELECT Id FROM Case LIMIT 1];
		//Using  an HTML template because the HTML body of the email is being set
		EmailTemplate eTemplate = [SELECT Id, DeveloperName FROM EmailTemplate WHERE TemplateType = 'HTML' LIMIT 1];

		Test.startTest();
		String sendEmailResp = ProofOfPaymentSelController.sendEmailWithAttach(
			testCase.Id,
			'test@example.com',
			eTemplate.DeveloperName,
			'sampleBase64PdfData',
			'Proof of Payment - Beneficiary'
		);
		System.assertEquals('Email sent Successfully', sendEmailResp, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	public static void testSendEmailNegativeNoOrgWideEmail() {
		Case testCase = [SELECT Id FROM Case LIMIT 1];
		//Using  an HTML template because the HTML body of the email is being set
		EmailTemplate eTemplate = [SELECT Id, DeveloperName FROM EmailTemplate WHERE TemplateType = 'HTML' LIMIT 1];
		//Change the Service_Group__c Response_Email_Address__c to an invalid email to not find an org wide email address
		Service_Group__c serviceGroupRecord = [SELECT Id, Response_Email_Address__c FROM Service_Group__c LIMIT 1];
		serviceGroupRecord.Response_Email_Address__c = 'badEmail@absa.africa';
		update serviceGroupRecord;

		Test.startTest();
		String sendEmailResp = ProofOfPaymentSelController.sendEmailWithAttach(
			testCase.Id,
			'test@example.com',
			eTemplate.DeveloperName,
			'sampleBase64PdfData',
			'Proof of Payment - Beneficiary'
		);
		System.assertEquals(
			'Error: Unable to find a matching Org Wide Email Address from the Email Address specified on the Service_Group__c of this Case. ',
			sendEmailResp,
			'Assert Failed'
		);
		Test.stopTest();
	}
}