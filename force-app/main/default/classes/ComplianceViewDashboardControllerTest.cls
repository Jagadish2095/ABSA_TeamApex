/**
 * @description       : Test Class For ComplianceViewDashboardController
 * @author            : Sharath Chandra  
 * @group             :
 * @last modified on  : 2021-11-30
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-03-09   Sharath Chandra   Initial Version
 **/
@isTest
public class ComplianceViewDashboardControllerTest {
	@isTest
    public static void testMethod1(){
        Account testAccount = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');
        Test.startTest();
        ComplianceViewDashboardController.getPickListValues('Account', 'Source__c');
        ComplianceViewDashboardController.updateAddress(testAccount,'Individual','Postal','address1','address2','suburbName','cityName','South Africa','post');
        ComplianceViewDashboardController.checkAICUser();
        system.assertNotEquals(testAccount, null);
        Test.stopTest();
    }
	@isTest
	public static void testComplianceView() {
		//Adding it to pull request
		Account testAccount = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');
        Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Compliance Pack','Risk Rating service' });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'CASA Primary Client Screening v2' });
		Integration_Translation__c it = new Integration_Translation__c();
        it.System_Name__c = 'eCasa';
        it.Value_Type__c = 'Country';
        it.Internal_Value__c = 'South Africa';
        it.Direction__c = 'Outbound';
        it.External_Value__c = 'Test';
        it.Name = 'Test Record';
        insert it;
        Test.startTest();
		ComplianceViewDashboardController.getData(testAccount.id);
		system.assertEquals(testAccount.Client_group__c, 'Individual');
        ComplianceViewDashboardController.getDocumentSubType('ClientCommunication');
		Test.stopTest();
	}

	@isTest
	public static void testComplianceView1() {
        Account testAccount = FICTestDataFactory.getAccount('Sole Trader','SOLE TRADER CLIENT','Individual_Client');
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Service_Request').getRecordTypeId();

		Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Compliance Pack','Risk Rating service' });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'CASA Primary Client Screening v2' });
		Integration_Translation__c it = new Integration_Translation__c();
        it.System_Name__c = 'eCasa';
        it.Value_Type__c = 'Country';
        it.Internal_Value__c = 'South Africa';
        it.Direction__c = 'Outbound';
        it.External_Value__c = 'Test';
        it.Name = 'Test Record';
        insert it;
        Case c = new case();
        c.Subject= 'FIC Refresh Case';
        c.status = 'In Progress';
        c.Description = 'FIC Case';
        c.Origin = 'What do you want to do today?';
        c.Security_Type__c = 'Fic Refresh';
        C.AccountId = testAccount.id;
        c.RecordTypeId = devRecordTypeId;
        insert c;
		Test.startTest();
		ComplianceViewDashboardController.getData(testAccount.id);
		system.assertEquals(testAccount.Client_group__c, 'SOLE TRADER CLIENT');
		Test.stopTest();
		//ComplianceViewDashboardController.getTableFields(acc.id);
	}

	@isTest
	public static void testComplianceView2() {
        Account testAccount = FICTestDataFactory.getAccount('Individual','Non Individual','Individual_Client');
		Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Compliance Pack','Risk Rating service' });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'CASA Primary Client Screening v2' });
		Integration_Translation__c it = new Integration_Translation__c();
        it.System_Name__c = 'eCasa';
        it.Value_Type__c = 'Country';
        it.Internal_Value__c = 'South Africa';
        it.Direction__c = 'Outbound';
        it.External_Value__c = 'Test';
        it.Name = 'Test Record';
        insert it;
        Document__c doc = new Document__c();
                doc.Name = 'testFile.pdf';
                doc.Type__c = 'proofOfID';
                doc.Account__c = testAccount.id;
                doc.Reference__c = 'afdsasdfasdfasdfa';
                doc.Document_Sub_Type__c = 'Green Card';  
                insert doc;
		Test.startTest();
		ComplianceViewDashboardController.getData(testAccount.id);
		ComplianceViewDashboardController.addDocumentItem('testFile.pdf',testAccount.id, 'afdsasdfasdfasdfasf', 'proofOfID','SA ID Card');
		system.assertEquals(testAccount.Client_group__c, 'Non Individual');
		Test.stopTest();
	}

	@isTest
	public static void testComplianceView3() {
		Account testAccount = FICTestDataFactory.getAccount('Individual Client','Individual','Individual_Client');
		Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.NEGATIVE_STRING));

		Test.startTest();
		ComplianceViewDashboardController.getData(testAccount.id);
		ComplianceViewDashboardController.addDocumentItem('testFile.pdf', testAccount.id, 'afdsasdfasdfasdfasf', 'proofOfID', 'SA ID Card');
		system.assertNotEquals(testAccount.id, null);
		Test.stopTest();
	}
	@isTest
	public static void testComplianceView4() {
		Account testJointAccount = FICTestDataFactory.getjointAccount('Joint & Several','PARTNERSHIP CLIENT');
		Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Compliance Pack','Risk Rating service' });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'CASA Primary Client Screening v2' });
		Integration_Translation__c it = new Integration_Translation__c();
        it.System_Name__c = 'eCasa';
        it.Value_Type__c = 'Country';
        it.Internal_Value__c = 'South Africa';
        it.Direction__c = 'Outbound';
        it.External_Value__c = 'Test';
        it.Name = 'Test Record';
        insert it;
        Test.startTest();
		ComplianceViewDashboardController.getData(testJointAccount.id);
		system.assertEquals(testJointAccount.Client_group__c, 'PARTNERSHIP CLIENT');
		Test.stopTest();
	}
	@isTest
	public static void testComplianceView5() {
		Account testJointAccount = FICTestDataFactory.getjointAccount('Joint & Several','JOINT AND SEVERAL CLIENT');
		Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Compliance Pack','Risk Rating service' });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'CASA Primary Client Screening v2' });
		Integration_Translation__c it = new Integration_Translation__c();
        it.System_Name__c = 'eCasa';
        it.Value_Type__c = 'Country';
        it.Internal_Value__c = 'South Africa';
        it.Direction__c = 'Outbound';
        it.External_Value__c = 'Test';
        it.Name = 'Test Record';
        insert it;
        Test.startTest();
		ComplianceViewDashboardController.getData(testJointAccount.id);
		system.assertEquals(testJointAccount.Client_group__c, 'JOINT AND SEVERAL CLIENT');
		Test.stopTest();
	}

	@isTest
	public static void testComplianceView6() {
		//Adding it to pull request
		Account testAccount = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');

        //Test.setMock(HttpCalloutMock.class, new GetEcasaRefNoMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Test.setMock(HttpCalloutMock.class, new GetRiskRatingMock_ApiRest(StringConstants.POSITIVE_STRING));
        Test.setMock(HttpCalloutMock.class, new GetComplianceViewDashboardMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Compliance Pack','Risk Rating service' });
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'CASA Primary Client Screening v2' });
        Test.startTest();
		ComplianceViewDashboardController.getData(testAccount.id);
		system.assertEquals(testAccount.Client_group__c, 'Individual');
		Test.stopTest();
	}
	

	  @isTest
    public static void testUpdateCIF(){
        Account testAccount = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');

        Integration_Translation__c country = new Integration_Translation__c();
        country.Name = 'South African';
        country.Internal_Value__c = 'South Africa';
        country.External_Value__c = 'SOU01';
        country.System_Name__c = StringConstants.CIF_STRING;
        country.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        country.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert country;

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
        ComplianceViewDashboardController.updateCIF(testAccount.id, 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '1234', 'Y', 'Allowance', 'Full Time Employed');
        system.assertEquals(testAccount.Client_group__c, 'Individual');
        Test.stopTest();
    }

    @isTest
    public static void testUpdateCIF1(){
        Account testAccount = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');
        Integration_Translation__c country = new Integration_Translation__c();
        country.Name = 'South African';
        country.Internal_Value__c = 'South Africa';
        country.External_Value__c = 'SOU01';
        country.System_Name__c = StringConstants.CIF_STRING;
        country.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        country.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert country;

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
        ComplianceViewDashboardController.updateCIF(testAccount.id, 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '1234', 'U', 'Allowance','Full Time Employed');
        system.assertEquals(testAccount.Client_group__c, 'Individual');
        Test.stopTest();
    }

    @isTest
    public static void testUpdateCIF2(){
       Account testAccount = FICTestDataFactory.getAccount('Individual','Individual','Individual_Client');

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
        ComplianceViewDashboardController.updateCIF(testAccount.id, 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '1234', 'Y','Allowance','Full Time Employed');
        system.assertEquals(testAccount.Client_group__c, 'Individual');
        Test.stopTest();
    } 
    @isTest
    public static void testUpdateCIF3(){
        Account testAccount = FICTestDataFactory.getAccount('Sole Trader','Individual','Individual_Client');

        Integration_Translation__c country = new Integration_Translation__c();
        country.Name = 'South African';
        country.Internal_Value__c = 'South Africa';
        country.External_Value__c = 'SOU01';
        country.System_Name__c = StringConstants.CIF_STRING;
        country.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        country.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert country;

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
        ComplianceViewDashboardController.updateCIF(testAccount.id, 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '1234', 'Y', 'Allowance', 'Full Time Employed');
        system.assertEquals(testAccount.Client_group__c, 'Individual');
        Test.stopTest();
    }
    
    @isTest
    public static void testUpdateCIF4(){
        Account testAccount = FICTestDataFactory.getjointAccount('Joint & Several','PARTNERSHIP CLIENT');

        Integration_Translation__c country = new Integration_Translation__c();
        country.Name = 'South African';
        country.Internal_Value__c = 'South Africa';
        country.External_Value__c = 'SOU01';
        country.System_Name__c = StringConstants.CIF_STRING;
        country.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        country.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        insert country;

        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
        ComplianceViewDashboardController.updateCIF(testAccount.id, 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '1234', 'Y', 'Allowance', 'Full Time Employed');
        system.assertEquals(testAccount.Client_group__c, 'PARTNERSHIP CLIENT');
        Test.stopTest();
    }
    
     @isTest
    public static void testPicklistValues(){
        List<string> picklistValues;
        Test.startTest();
        picklistValues = ComplianceViewDashboardController.getPickListValues('Account', 'Source_of_Income__c');
        system.assertNotEquals(picklistValues, null);
        Test.stopTest();
    }
	@isTest
	public static void getDocument() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Document__c doc = new Document__c();
		doc.Name = 'testFile.pdf';
		doc.Type__c = 'proofOfId';
		doc.Account__c = testDataFactory.testAccount.id;
		doc.Reference__c = 'CISBISON_SIT Ent_ProofOfId B5C40FB9383D40059B45BD6C4F48DE74';
		insert doc;
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Get'});
        Test.setMock(HttpCalloutMock.class, new CIS_GetDocMock_ApiRest(StringConstants.POSITIVE_STRING));
		ComplianceViewDashboardController.getUploadedDoc(testDataFactory.testAccount.id, 'proofOfId');
		system.assertEquals(doc.Type__c, 'proofOfId');
	}

	/*  @isTest
    public static void LoginWithValidCredentials() {
        insertSettings();
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new Mock_ApiRest(body));
        Test.startTest();
       /* ECM_LoginResult_IB_V1 result = ComplianceViewDashboardController.getLoginCredentials();
        System.assertNotEquals(null, result);
        System.assertEquals('OK', result.LoginResult.Status);
        System.assertEquals('1234567890', result.Token);
        ComplianceViewDashboardController.getDocFromServer(result, 'pid');
        Test.stopTest();
    }   */

	@isTest
	public static void shouldSaveChunk() {
		
		/*insertSettings();
		String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
		Test.setMock(HttpCalloutMock.class, new Mock_ApiRest(body));
		QueueHttpMock mock = new QueueHttpMock();
		mock.addResponse(JSON.serialize(HotDocsToken.getExample()));
		mock.addResponse(JSON.serialize(ECM_AddResult_IB_V1.getExample()));
		Test.setMock(HttpCalloutMock.class, mock); */
		new WillsTestDataFactory(); 
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        

		//add a document
		Id objectId = [SELECT Id, AccountId FROM Opportunity LIMIT 1].Id;
		Id accId = [SELECT Id, AccountId FROM Opportunity WHERE Id = :objectId].AccountId;
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', '', 'proofOfId');
        ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', fileId, 'proofOfId');
		System.assert(fileId != null);
		String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
		Test.startTest();
		ComplianceViewDashboardController.completeUpload(fileId, 'proofOfId','SA ID card');
		ComplianceViewDashboardController.appendToFile(fileId, 'String base64Data');
		system.assertNotEquals(fileId, null);
		Test.stopTest();
	}
    
    @isTest
	public static void shouldSaveChunk1() {

		new WillsTestDataFactory(); 
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest('No DHA'));

		//add a document
		Id objectId = [SELECT Id, AccountId FROM Opportunity LIMIT 1].Id;
		Id accId = [SELECT Id, AccountId FROM Opportunity WHERE Id = :objectId].AccountId;
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', '', 'proofOfId');
        ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', fileId, 'proofOfId');
		System.assert(fileId != null);
		String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
		Test.startTest();
		ComplianceViewDashboardController.completeUpload(fileId, 'proofOfId','SA ID card');
		ComplianceViewDashboardController.appendToFile(fileId, 'String base64Data');
		system.assertNotEquals(fileId, null);
		Test.stopTest();
	}
    
    @isTest
	public static void shouldSaveChunk2() {
		
		new WillsTestDataFactory(); 
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest('Other Exceptions'));

		//add a document
		Id objectId = [SELECT Id, AccountId FROM Opportunity LIMIT 1].Id;
		Id accId = [SELECT Id, AccountId FROM Opportunity WHERE Id = :objectId].AccountId;
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', '', 'proofOfId');
        ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', fileId, 'proofOfId');
		System.assert(fileId != null);
		String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
		Test.startTest();
		ComplianceViewDashboardController.completeUpload(fileId, 'proofOfId','SA ID card');
		ComplianceViewDashboardController.appendToFile(fileId, 'String base64Data');
		system.assertNotEquals(fileId, null);
		Test.stopTest();
	}
    
    @isTest
	public static void shouldSaveChunk3() {

		new WillsTestDataFactory(); 
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest('OCR Failed'));

		//add a document
		Id objectId = [SELECT Id, AccountId FROM Opportunity LIMIT 1].Id;
		Id accId = [SELECT Id, AccountId FROM Opportunity WHERE Id = :objectId].AccountId;
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', '', 'proofOfId');
        ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', fileId, 'proofOfId');
		System.assert(fileId != null);
		String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
		Test.startTest();
		ComplianceViewDashboardController.completeUpload(fileId, 'proofOfId','SA ID card');
		ComplianceViewDashboardController.appendToFile(fileId, 'String base64Data');
		system.assertNotEquals(fileId, null);
		Test.stopTest();
	}
    
    @isTest
	public static void shouldSaveChunk4() {

		new WillsTestDataFactory(); 
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest('Other Docs'));

		//add a document
		Id objectId = [SELECT Id, AccountId FROM Opportunity LIMIT 1].Id;
		Id accId = [SELECT Id, AccountId FROM Opportunity WHERE Id = :objectId].AccountId;
		String chunk1 = EncodingUtil.base64Encode(Blob.valueOf('This is a test '));
		Id fileId = ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', '', 'proofOfIncome');
        ComplianceViewDashboardController.saveInChunk(accId, 'Test.txt', chunk1, 'txt', fileId, 'proofOfIncome');
		System.assert(fileId != null);
		String chunk2 = EncodingUtil.base64Encode(Blob.valueOf('file!'));
		Test.startTest();
		ComplianceViewDashboardController.completeUpload(fileId, 'proofOfIncome','test Doc');
		ComplianceViewDashboardController.appendToFile(fileId, 'String base64Data');
		system.assertNotEquals(fileId, null);
		Test.stopTest();
	}

	/**
	 * @description
	 **/
	public static void insertSettings() {
		List<String> endpoints = new List<String>();
		endpoints.add('Channel Integration Login');
		endpoints.add('Channel Integration Add');
		endpoints.add('Channel Integration Get');
		endpoints.add('Channel Integration Logout');
		IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
	}

	@isTest
	public static void validateHanisService() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new HanisValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.HANIS_VALIDATE });
		string result;
		Test.startTest();
		result = ComplianceViewDashboardController.callHanisService('7707077777087');
		Test.stopTest();
		system.assert(result != null);
	}

	/*  @isTest
    public static void validateAddDocToServer(){
        insertSettings();
        new WillsTestDataFactory();
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        Test.setMock(HttpCalloutMock.class, new Mock_ApiRest(body));
        Test.startTest();
      /*  ECM_LoginResult_IB_V1 result = ComplianceViewDashboardController.getLoginCredentials();
        System.assertNotEquals(null, result);
        Id objectId = [select Id, AccountId from Opportunity limit 1].accountId;
        account acc = [select Id, id_number__pc, cif__c from account where Id = :objectId];
        Attachment attach = new Attachment(Name='Details.pdf', parentId=acc.Id, Body=Blob.valueOf('test'));
        insert attach;
        ComplianceViewDashboardController.addDocToServer(result, 'test.pdf', 'proodOfId', attach , acc);
        system.assertEquals(body, '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}');
        Test.stopTest();

    } */
	/**
	 * @description
	 */
	public class Mock_ApiRest implements HttpCalloutMock {
		/**
		 * @description
		 */
		public String body { get; set; }
		/**
		 * @description constructor
		 */
		public Mock_ApiRest() {
		}

		/**
		 * @description
		 * @param body
		 **/
		public Mock_ApiRest(String body) {
			this.body = body;
		}
		/**
		 * @description
		 * @param request
		 * @return HTTPResponse
		 **/
		public HTTPResponse respond(HTTPRequest request) {
			HTTPResponse response = new HTTPResponse();
			response.setStatusCode(200);
			response.setBody(body);
			response.setHeader('Content-Type', 'application/json');
			return response;
		}
	}
    @isTest
	public static void validateCPBService() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CPB_VALIDATE });
		string result;
		Test.startTest();
		result = ComplianceViewDashboardController.callCPBService('7707077777087','TestData');
		Test.stopTest();
		system.assert(result != null);
	}
    @isTest
	public static void validateExperianService() {
        // Set mock callout class
		Test.setMock(HttpCalloutMock.class, new ExperianBusinessDetailsGet_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ 'Experian Business Details Get' });
		string result;
		Test.startTest();
		result = ComplianceViewDashboardController.callExperianHandler('7707077777087');
		Test.stopTest();
		system.assert(result != null);
	}
    
    @isTest
	public static void goldenServiceCall() {
 		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest('Other Docs'));
        String hanisResponse = '{ "transactionID":"6de221c1-d1f9-40fe-9e6f-c760b6ffdfd9", "idNumber":"0002090065083", "name":"MARIA ELENA", "surname":"SCHUTTE", "hasSmartCard":true, "dateIssued":"20200317", "idSequenceNo":3, "deadIndicator":false, "idBlocked":false, "dateOfDeath":"", "maritalStatus":"SINGLE", "dateOfMarriage":"", "image":"Image Found","onHanis":true, "onNpr":true, "birthPlaceCountryCode":"ZAF", "errorCode":0, "Cert":"otvajatafajgavaanahagva"}';
        string cpbResponse = '{ "SearchInformation":{ "SearchUserName":"9018540001", "ReportDate":"2020-02-06 11:30:44 AM", "Reference":"", "SearchToken":"3470fd48-1e34-4c04-8aed-334956e9ab49", "SearchTypeDescription":"", "SearchDescription":"7707077777087 BURGER", "CallerModule":"BureauHouseAPI", "SearchID":"1580981441.6252582", "DataSupplier":"Consumer Profile Bureau", "SearchType":"ProofOfResidence", "ExtendedSections":"", "ResponseType":"ProofOfResidence", "ResponseObjectType":"Person" }, "Person":{ "PersonInformation":{ "PersonID":"659e93a4ef4a905c40bceb3d8160f2d8", "Title":"", "DateOfBirth":"07/07/1977", "Initials":"CP", "FirstName":"CHRISTOPHER", "Surname":"BURGER", "IDNumber":"7707077777087", "PassportNumber":"", "MaritalStatus":"", "Gender":"Male", "MiddleName1":"PHILLIP", "MiddleName2":"", "MiddleName3":"", "Reference":"3470fd48-1e34-4c04-8aed-334956e9ab49", "DeceasedStatus":"YES", "DeceasedDate":"01/06/2010", "CurrentEmployer":"TEST FOR S3", "HasPostMatricQual":"UNKNOWN", "WhatQual":"UNKNOWN" }, "ContactInformation":{ "EmailAddress":"CB@CPB.CO.ZA", "MobileNumber":"0782658945", "HomeTelephoneNumber":"0100101111", "WorkTelephoneNumber":"0105909505", "FaxNumber":"" }, "FinancialInformation":{ "EverInsolvent":"UNKNOWN", "IncomeBracket":"UNKNOWN" }, "AddressInformation":{ "ResidentialAddress":{ "FirstReportedDate":"2019-07-12", "AddCert":"rauaiavajagaauvbjav","AddressID":"747020970", "TypeDescription":"RESIDENTIAL", "TypeCode":"R", "Line1":"50", "Line2":"50 BEARD STREET", "Line3":"CAPE TOWN", "Line4":"CAPE TOWN", "PostalCode":"8001", "FullAddress":"50, 50 BEARD STREET, CAPE TOWN, CAPE TOWN, 8001", "LastUpdatedDate":"2020-02-06" }, "PostalAddress":{ "AddressID":"149660225", "TypeDescription":"POSTAL", "TypeCode":"P", "Line1":"PO BOX 1234", "Line2":"", "Line3":"KROONSTAD", "Line4":"KROONSTAD", "PostalCode":"9499", "FullAddress":"PO BOX 1234, KROONSTAD, KROONSTAD, 9499", "LastUpdatedDate":"2020-02-06" } } } }';
        string experianResponse = '';
		Test.startTest();
		string pId = ComplianceViewDashboardController.goldenSourceUpload(hanisResponse, cpbResponse,  experianResponse, 'proofOfId', 'Hanis Certificate', testDataFactory.testAccount.id);
		system.assertEquals(pId, null);
		Test.stopTest();
	}
    @isTest
	public static void goldenServiceCall1() {
 		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new CIS_GetLoginCredentialsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'Channel Integration Login','Channel Integration Add'});
        Test.setMock(HttpCalloutMock.class, new CIS_AddDocMock_ApiRest(StringConstants.POSITIVE_STRING));
        String hanisResponse = '{ "transactionID":"6de221c1-d1f9-40fe-9e6f-c760b6ffdfd9", "idNumber":"0002090065083", "name":"MARIA ELENA", "surname":"SCHUTTE", "hasSmartCard":true, "dateIssued":"20200317", "idSequenceNo":3, "deadIndicator":false, "idBlocked":false, "dateOfDeath":"", "maritalStatus":"SINGLE", "dateOfMarriage":"", "image":"Image Found","onHanis":true, "onNpr":true, "birthPlaceCountryCode":"ZAF", "errorCode":0, "Cert":"otvajatafajgavaanahagva"}';
        string cpbResponse = '{ "SearchInformation":{ "SearchUserName":"9018540001", "ReportDate":"2020-02-06 11:30:44 AM", "Reference":"", "SearchToken":"3470fd48-1e34-4c04-8aed-334956e9ab49", "SearchTypeDescription":"", "SearchDescription":"7707077777087 BURGER", "CallerModule":"BureauHouseAPI", "SearchID":"1580981441.6252582", "DataSupplier":"Consumer Profile Bureau", "SearchType":"ProofOfResidence", "ExtendedSections":"", "ResponseType":"ProofOfResidence", "ResponseObjectType":"Person" }, "Person":{ "PersonInformation":{ "PersonID":"659e93a4ef4a905c40bceb3d8160f2d8", "Title":"", "DateOfBirth":"07/07/1977", "Initials":"CP", "FirstName":"CHRISTOPHER", "Surname":"BURGER", "IDNumber":"7707077777087", "PassportNumber":"", "MaritalStatus":"", "Gender":"Male", "MiddleName1":"PHILLIP", "MiddleName2":"", "MiddleName3":"", "Reference":"3470fd48-1e34-4c04-8aed-334956e9ab49", "DeceasedStatus":"YES", "DeceasedDate":"01/06/2010", "CurrentEmployer":"TEST FOR S3", "HasPostMatricQual":"UNKNOWN", "WhatQual":"UNKNOWN" }, "ContactInformation":{ "EmailAddress":"CB@CPB.CO.ZA", "MobileNumber":"0782658945", "HomeTelephoneNumber":"0100101111", "WorkTelephoneNumber":"0105909505", "FaxNumber":"" }, "FinancialInformation":{ "EverInsolvent":"UNKNOWN", "IncomeBracket":"UNKNOWN" }, "AddressInformation":{ "ResidentialAddress":{ "FirstReportedDate":"2019-07-12", "AddCert":"rauaiavajagaauvbjav","AddressID":"747020970", "TypeDescription":"RESIDENTIAL", "TypeCode":"R", "Line1":"50", "Line2":"50 BEARD STREET", "Line3":"CAPE TOWN", "Line4":"CAPE TOWN", "PostalCode":"8001", "FullAddress":"50, 50 BEARD STREET, CAPE TOWN, CAPE TOWN, 8001", "LastUpdatedDate":"2020-02-06" }, "PostalAddress":{ "AddressID":"149660225", "TypeDescription":"POSTAL", "TypeCode":"P", "Line1":"PO BOX 1234", "Line2":"", "Line3":"KROONSTAD", "Line4":"KROONSTAD", "PostalCode":"9499", "FullAddress":"PO BOX 1234, KROONSTAD, KROONSTAD, 9499", "LastUpdatedDate":"2020-02-06" } } } }';
        string experianResponse = '';
		Test.startTest();
		string pId = ComplianceViewDashboardController.goldenSourceUpload(hanisResponse, cpbResponse,  experianResponse, 'proofOfId', 'Hanis Certificate', testDataFactory.testAccount.id);
		system.assertNotEquals(pId, null);
		Test.stopTest();
	}
	/**
	 * @description
	 */
	public class QueueHttpMock implements HttpCalloutMock {
		HttpResponse[] responses = new HttpResponse[0];

		/**
		 * @description
		 * @param response
		 **/
		public void addResponse(HttpResponse response) {
			responses.add(response);
		}

		/**
		 * @description
		 * @param response
		 **/
		public void addResponse(String response) {
			addResponse(response, 200, 'application/json');
		}

		/**
		 * @description
		 * @param response
		 * @param code
		 * @param contentType
		 **/
		public void addResponse(String response, Integer code, String contentType) {
			HttpResponse res = new HttpResponse();
			res.setBody(response);
			res.setStatusCode(code);
			res.setHeader('Content-Type', contentType);
			responses.add(res);
		}
		/**
		 * @description
		 * @param request
		 * @return HttpResponse
		 **/
		public HttpResponse respond(HttpRequest request) {
			return responses.remove(0);
		}
	}
}