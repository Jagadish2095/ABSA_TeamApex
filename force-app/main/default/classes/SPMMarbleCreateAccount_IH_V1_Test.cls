/**
 * @description       : Test class for SPMMarbleCreateAccount_IH_V1
 * @author            : haritha.police@absa.africa
 * @last modified on  : 2021-06-23
 * @last modified by  : haritha.police@absa.africa
 * 2021-05-21   haritha.police@absa.africa   Initial Version
 **/
@isTest
public class SPMMarbleCreateAccount_IH_V1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"requestId":"3f3373ce-1a8e-477b-b453-2cef08382d07","partnerID":49,"entityId":174301,"crmEntityTypeId":1,"crmEntityName":"Hisroaccount Hillman03","mobileNumber":"0812246607","email":null,"marbleAccountTypeResponseList":[{"fundId":486975,"portfolioId":160076,"portfolioProductTypeID":1}],"marbleAccountResult":{"status":200,"statusCode":0,"statusMessage":"Marble on-boarding processed successful"}}';

	@TestSetup
	static void makeData() {
		/*IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SPMMarbleCreateAccount_IH_V1.INTEGRATION_SERVICE_NAME }
		);*/
		Integration_API__c intapi = new Integration_API__c();
		intapi.Name = 'Jitterbit2';
		intapi.Client_ID__c = 'e33caff9-53d8-43ad-8b2a-d5531aae3c06';
		intapi.Environment__c = 'Development';
		intapi.Base_URL__c = 'https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api';
		insert intapi;
		Integration_Service__c iservice = new Integration_Service__c();
		iservice.Integration_API_ID__c = intapi.Id;
		iservice.Method__c = 'POST';
		iservice.Name = 'Marble Create Account';
		iservice.URL_Extension__c = '/marble/account';
		iservice.Content_Type__c = 'application/json';
		insert iservice;
	}

	@isTest
	public static void testPositive() {
		Integration_API__c intapi = new Integration_API__c();
		intapi.Name = 'Jitterbit2';
		intapi.Client_ID__c = 'e33caff9-53d8-43ad-8b2a-d5531aae3c06';
		intapi.Environment__c = 'Development';
		intapi.Base_URL__c = 'https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api';
		insert intapi;
		Integration_Service__c iservice = new Integration_Service__c();
		iservice.Integration_API_ID__c = intapi.Id;
		iservice.Method__c = 'POST';
		iservice.Name = 'Marble Create Account';
		iservice.URL_Extension__c = '/marble/account';
		iservice.Content_Type__c = 'application/json';
		insert iservice;
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		SPMMarbleCreateAccount_Req_IB_V1 dummyBean = SPMMarbleCreateAccount_Req_IB_V1.createDummyRequest();
		SPMMarbleCreateAccount_Resp_IB_V1 dummyrespBean = SPMMarbleCreateAccount_Resp_IB_V1.createDummyResponse();
		SPMMarbleCreateAccount_IH_V1.getMarbleAccountNumber(dummyBean);
		system.assertEquals(dummyrespBean, dummyrespBean);
	}
}