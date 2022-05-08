/**
* Integration Handler Test for Switches
* @author Edgar Blount
* @created 2020-09-25
*/
@isTest
public class Switches_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{ "createdBy": "bdp_user", "lastModifiedBy": "bdp_user", "creationDate": "2020-09-23T12:00:04.849+0000", "lastModifiedDate": "2020-09-23T12:00:04.849+0000", "state": "READY_TO_SUBMIT", "switchType": "DEBIT_ORDER", "accountNumber": "9090090898", "frequency": "MONTHLY", "dueDate": "2020-06-30T00:00:00.000+0000", "amount": 450.0, "notes": "Debit Order", "referenceNumber": "2020/09/2339107", "reason": null, "nextPremiumDate": null, "allocatedTo": "UNALLOCATED", "followUp": null, "previousAccountNumber": "5754654654654", "previousAccountType": "SAVINGS", "previousBranch": "2555", "previousInstitution": "SANLAM PERSONAL LOAN", "channel": "ASP", "originEmployeeName": null, "originEmployeeSurname": null, "originEmployeeNumber": null, "originSiteCode": null, "originSiteName": null, "valid": true, "primaryTrigger": "", "friendlyState": "Ready to send", "formattedDueDate": "30/06/2020", "age": 0, "overdue": false, "triggers": [], "channelValid": true, "_links": { "self": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509" }, "switchRequest": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509" }, "history": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/history" }, "letter": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/letter" }, "download": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/letter/download" }, "follow-up": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/follow-up" }, "institution": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/institution" }, "customer": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/customer" } } }';
    public static final String POSITIVE_RESPONSE_BODY_LETTER = 'base64 pdf';  
    public static final String POSITIVE_RESPONSE_BODY_LINK_CUSTOMER = '{     "exceptiondetails": {         "status": "NOT_FOUND",         "timestamp": "12-10-2020 14:09:54",         "message": "Requested resource could not be found in the Switch-It Database",         "path": "/switches/2064/customer",         "subErrors": null     } }';
    public static final String POSITIVE_RESPONSE_BODY_LINK_INSTITUTION = '{     "exceptiondetails": {         "status": "NOT_FOUND",         "timestamp": "12-10-2020 14:22:54",         "message": "Requested resource could not be found in the Switch-It Database",         "path": "/switches/2059/institution",         "subErrors": null     } }';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Switches_IH_v1.SwitchesGET});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Switches_IH_v1.SwitchesPOST});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Switches_IH_v1.SwitchesPUT});
    }


    @isTest static void testcreateSwitchPositive() {        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        Switches_Resp_IB_v1 responseBean = callcreateSwitchHandlerMethod();
        Test.stopTest();
    }

    @isTest static void testswitchTriggerPositive() {        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        Switches_Resp_IB_v1 responseBean = callswitchTriggerHandlerMethod();
        Test.stopTest();
    }

    @isTest static void testgetSwitchPositive() {        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        Switches_Resp_IB_v1 responseBean = callgetSwitcgHandlerMethod();
        Test.stopTest();
    }

    @isTest static void testgetSwitchLetterPositive() {        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LETTER));
        Test.startTest();
        String responseBean = callgetSwitchLetterHandlerMethod();
        Test.stopTest();
    }

    @isTest static void testLinkCustomerSwitchPositive() {        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LINK_CUSTOMER));
        Test.startTest();
        String responseBean = callLinkCustomerSwitchHandlerMethod();
        Test.stopTest();
    }

    @isTest static void testLinkInstitutionSwitchPositive() {        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LINK_INSTITUTION));
        Test.startTest();
        String responseBean = callLinkInstitutionSwitchHandlerMethod();
        Test.stopTest();
    }

    private static Switches_Resp_IB_v1 callcreateSwitchHandlerMethod() {
        Switches_Req_IB_v1 dummyReqBean = Switches_Req_IB_v1.createDummyRequest();        
        Switches_Resp_IB_v1 responseBean = Switches_IH_v1.createSwitch(dummyReqBean);
        return responseBean;
    }

    private static Switches_Resp_IB_v1 callswitchTriggerHandlerMethod() {        
        Switches_Resp_IB_v1 responseBean = Switches_IH_v1.switchTrigger('3456','SUBMIT');
        return responseBean;
    }

    private static Switches_Resp_IB_v1 callgetSwitcgHandlerMethod() {        
        Switches_Resp_IB_v1 responseBean = Switches_IH_v1.getSwitch('16509');
        return responseBean;
    }

    private static String callgetSwitchLetterHandlerMethod() {        
        String responseBean = Switches_IH_v1.getSwitchLetter('16659');
        return responseBean;
    }

    private static String callLinkCustomerSwitchHandlerMethod() {   
        String requestBody = 'https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/customers/2056';     
        String responseBean = Switches_IH_v1.LinkCustomerSwitch('3445', requestBody);
        return responseBean;
    }

    private static String callLinkInstitutionSwitchHandlerMethod() {   
        String requestBody = 'https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/616';     
        String responseBean = Switches_IH_v1.LinkInstitutionSwitch('3445', requestBody);
        return responseBean;
    }
}