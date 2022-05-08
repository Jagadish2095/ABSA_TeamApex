/**
* @description Controller Test Class For XDSGetQuestions_IH_v1 class
*
* @author  Koketso Mpshane
* @version v1.0
* @since   2021-09-29
*/
@IsTest
public class XDSGetQuestions_IH_v1_Test {
    
    @isTest
	public static void testCallToXDSGetQuetionsService() {
    	//Get test data
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';

		insert accountList;
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{StringConstants.XDS_GetQuestions});
        
        Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
        
        Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> xdsQuestions = XDSGetQuestions_IH_v1.callToXDSGetQuetionsService(accountList[0].Id);

		System.assertNotEquals(null, xdsQuestions, 'Assert Failed');

		Test.stopTest();
    }
    
    @isTest
	public static void testGetToXDSGetQuetionsService() {
    	
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{StringConstants.XDS_GetQuestions});
        
        Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
        
        XDSGetQuetions_Req_IB_v1 reqbean = new XDSGetQuetions_Req_IB_v1();
		reqbean.creatDummyRequest();
        
        Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> xdsQuestions = XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqbean);

		System.assertNotEquals(null, xdsQuestions, 'Assert Failed');

		Test.stopTest();
    } 
    
    @isTest
	public static void testCallToXDSGetQuetionsServiceNeg() {
    	//Get test data
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';

		insert accountList;
                
        Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
        
        Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> xdsQuestions = XDSGetQuestions_IH_v1.callToXDSGetQuetionsService(accountList[0].Id);

		System.assertNotEquals(null, xdsQuestions, 'Assert Failed');

		Test.stopTest();
    }
    
    @isTest
	public static void testGetToXDSGetQuetionsServiceNeg() {
    	        
        Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
        
        XDSGetQuetions_Req_IB_v1 reqbean = new XDSGetQuetions_Req_IB_v1();
		reqbean.creatDummyRequest();
        
        Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> xdsQuestions = XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqbean);

		System.assertNotEquals(null, xdsQuestions, 'Assert Failed');

		Test.stopTest();
    }

}