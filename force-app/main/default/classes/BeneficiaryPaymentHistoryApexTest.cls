/**
* @description Test class for BeneficiaryPaymentHistoryApex
* @author Danie Booysen
* @created 2021-04-13
*/

@IsTest
public class BeneficiaryPaymentHistoryApexTest {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = MBgetPaymentDetailV3_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE;

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MBgetPaymentDetailV3_IH_v1.INTEGRATION_SERVICE_NAME, Sys_Utilities_General.getEnvironment(), DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR});

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

		Document_Template__c docTemp = new Document_Template__c(Name = 'Historical_Proof_of_Payments', Document_Type__c = 'Historical_Proof_of_Payments', XML__c='{beneficiaryPaymentList}');
		insert docTemp;
    }

    @IsTest
    static void testBeneficiaryTransactionHistory(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        MBgetPaymentDetailV3_Resp_IB_v1 testResponse = BeneficiaryPaymentHistoryApex.BeneficiaryTransactionHistory('80002D83AB');
        Test.stopTest();
        System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
    }

    @isTest
    static void testGetBenPaymentHistoryData() {
        String testBeneficiaryPayments = '[{"instrStatus":null,"intExtBenInd":null,"actDate":"20210406","trigDate":"20210406","amount":1,"srcAcc":"000000000000004047394278","srcAccType":"CQ","srcClrCode":"632005","srcInstCode":"ABSA BANK","srcStmtRef":"UAT Nyandane","trgAcc":"000000000000000203099621","trgAccType":"02","trgClrCode":"14442","trgInstCode":"STD S.A.","trgStmtRef":"Nyandane UAT","corpCode":"Z","sbu":"F","payDay":"0","doType":null,"cardAuth":null,"notifInd":null,"srcNotifMed":"N","trgNotifMed":"N","changeOverride":null,"changeOverride2":null,"lastMaintOvr2Id":null,"paymStatus":"COMPLPAYM","paymTime":"11495157","paymProcessAmnt":1,"paymErrCode":"000","iipInd":"D","iipAuth":"000000","busRef":"1605FA33C0","paymNotes":null},{"instrStatus":null,"intExtBenInd":null,"actDate":"20210406","trigDate":"20210406","amount":25,"srcAcc":"000000000000004047394278","srcAccType":"CQ","srcClrCode":"632005","srcInstCode":"ABSA BANK","srcStmtRef":"UAT Nyandane","trgAcc":"000000000000000203099621","trgAccType":"02","trgClrCode":"14442","trgInstCode":"STD S.A.","trgStmtRef":"Nyandane UAT","corpCode":"Z","sbu":"F","payDay":"0","doType":null,"cardAuth":null,"notifInd":null,"srcNotifMed":"N","trgNotifMed":"N","changeOverride":null,"changeOverride2":null,"lastMaintOvr2Id":null,"paymStatus":"COMPLPAYM","paymTime":"11472063","paymProcessAmnt":25,"paymErrCode":"000","iipInd":"D","iipAuth":"000000","busRef":"1605FA33BF","paymNotes":null}]';
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        String response = BeneficiaryPaymentHistoryApex.getBenPaymentHistoryData(testBeneficiaryPayments, 'beneficiaryName', '123456', 'Historical_Proof_of_Payments', acc.Id);
		//Using assertNotEquals to null because the DocumentTemplateProcessor returns no content when running tests
		// and as a result the code to retrieve the generated document cannot be test because of the underlying problem
        Test.stopTest();
        System.assertNotEquals(null, response, 'Assert Failed');
    }

    @isTest
	static void testSendBeneficiaryPayments() {
		Case testCase = [SELECT Id FROM Case LIMIT 1];
		//Using  an HTML template because the HTML body of the email is being set
		EmailTemplate eTemplate = [SELECT Id, DeveloperName FROM EmailTemplate WHERE TemplateType = 'HTML' LIMIT 1];

		Test.startTest();
		String sendEmailResp = BeneficiaryPaymentHistoryApex.sendBeneficiaryPayments(
			testCase.Id,
			'test@example.com',
			eTemplate.DeveloperName,
			'sampleBase64PdfData',
			'Historical_Proof_of_Payments'
		);
		Test.stopTest();
        System.assertEquals('Email sent Successfully', sendEmailResp, 'Assert Failed');
	}
}