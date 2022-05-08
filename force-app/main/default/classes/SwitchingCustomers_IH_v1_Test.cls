/**
* Integration Handler for Switching Customers Test
* @author André Pietersen
* @created 2020-10-01
* Edgar Blount 2020-10-05 - Added customerTrigger test method
*/
@isTest
public class SwitchingCustomers_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY_GET = '{     "createdBy": "bdp_user",     "lastModifiedBy": "bdp_user",     "creationDate": "2020-05-18T07:22:04.772+0000",     "lastModifiedDate": "2020-05-22T12:05:01.508+0000",     "state": "WELCOMED",     "name": "FRANK",     "surname": "TANK",     "identifier": "7105243441086",     "email": "ASDADAS@ASDAS.COM",     "telephoneNumber": "0",     "mobileNumber": "0821234567",     "ecmAttachmentKey": null,     "title": "Ms",     "communicationMethod": "SMS",     "bankAccountNumber": "9051304529",     "bankAccountType": "SAVINGS",     "bankBranch": "8007",     "previousAccountNumber": "12345678",     "previousAccountType": "SAVINGS",     "previousBranch": "632005",     "previousInstitution": "SANLAM PERSONAL LOAN",     "preferredLanguage": "ENG",     "fullName": "Ms. FRANK TANK",     "gender": "FEMALE",     "triggers": [         "WELCOME"     ],     "_links": {         "self": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.nonprod.caas.absa.co.za/customers/2323"         },         "customer": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.nonprod.caas.absa.co.za/customers/2323"         },         "history": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.nonprod.caas.absa.co.za/customers/2323/history"         },         "welcome_trigger": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.nonprod.caas.absa.co.za/customers/2323/trigger?triggerName=WELCOME"         }     } } ';
    public static final String POSITIVE_RESPONSE_BODY_POST = '{     "exceptiondetails": {         "status": "CONFLICT",         "timestamp": "12-10-2020 13:51:27",         "message": "Resource already exists in the Database. Please try again with a different account",         "path": "/customers",         "subErrors": null     } }';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SwitchingCustomers_IH_v1.SwitchingCustomersPOST});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SwitchingCustomers_IH_v1.SwitchingCustomersGET});
    }
    
    @isTest static void testgetSwitchingCustomer() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET));
        Test.startTest();
        SwitchingCustomers_Resp_IB_v1 responseBean = 
        callgetCustomerHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    @isTest static void testcreateSwitchingCustomer() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_POST));
        Test.startTest();
        SwitchingCustomers_Resp_IB_v1 responseBean = 
        callcreateCustomerHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    @isTest static void testgetSwitchingCustomerTrigger() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET));
        Test.startTest();
        SwitchingCustomers_Resp_IB_v1 responseBean = callCustomerTriggerHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static SwitchingCustomers_Resp_IB_v1 callgetCustomerHandlerMethod() {        
        SwitchingCustomers_Resp_IB_v1 responseBean = 
        SwitchingCustomers_IH_v1.getSwitchingCustomer('7105243441086');
        return responseBean;
    }

    private static SwitchingCustomers_Resp_IB_v1 callcreateCustomerHandlerMethod() {        
        SwitchingCustomers_Req_IB_v1 dummyReqBean = SwitchingCustomers_Req_IB_v1.createDummyRequest();
        SwitchingCustomers_Resp_IB_v1 responseBean =
        SwitchingCustomers_IH_v1.createSwitchingCustomer(dummyReqBean);
        return responseBean;
    }
    private static SwitchingCustomers_Resp_IB_v1 callCustomerTriggerHandlerMethod() {        
        SwitchingCustomers_Resp_IB_v1 responseBean = 
        SwitchingCustomers_IH_v1.customerTrigger('12345', 'WELCOME');
        return responseBean;
    }
}