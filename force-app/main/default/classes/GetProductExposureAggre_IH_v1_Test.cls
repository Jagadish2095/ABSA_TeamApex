/**
* @description       : Test class for GetProductExposureAggre_IH_v1
* @author            : Englarmerdge Mongwe
* @last modified on  : 2021-06-17
* @last modified by  : Saurabh
* Modifications Log 
* Ver   Date         Author                Modification
* 1.0   2021-06-11   Englarmerdge Mongwe   Initial Version
**/

@IsTest
public class GetProductExposureAggre_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"client":[{"name":"ABC","clientProfile":[{"clientCode":"ABC+001","aggregation":[{"type":"Recovery Exposure","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage CPF","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage Agri","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Asset Finance","liability":250,"exposure":250,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage Residential","liability":600,"exposure":600,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Ordinary Credit Exposure","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Ordinary Credit Exposure","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Ordinary Credit","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Exposure","liability":850,"exposure":850,"limit":0,"excess":0,"arrears":0,"installment":0}]},{"clientCode":"ABC+002","aggregation":[{"type":"Recovery Exposure","liability":600,"exposure":600,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage CPF","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage Agri","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Asset Finance","liability":500,"exposure":1000,"limit":0,"excess":1000,"arrears":0,"installment":0},{"type":"Mortgage Residential","liability":600,"exposure":600,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Ordinary Credit Exposure","liability":600,"exposure":600,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Ordinary Credit Exposure","liability":1200,"exposure":1200,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Ordinary Credit","liability":1200,"exposure":1200,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Exposure","liability":2300,"exposure":2800,"limit":0,"excess":1000,"arrears":0,"installment":0}]}],"aggregation":[{"type":"Ordinary Credit Total","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Ordinary Credit Total","liability":50,"exposure":0,"limit":0,"excess":700,"arrears":0,"installment":800}]},{"name":"John Hammond","clientProfile":[{"clientCode":"JHMMD+001","aggregation":[{"type":"Recovery Exposure","liability":850,"exposure":850,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage CPF","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage Agri","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Asset Finance","liability":850,"exposure":850,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage Residential","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Ordinary Credit Exposure","liability":850,"exposure":850,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Ordinary Credit Exposure","liability":1700,"exposure":1700,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Ordinary Credit","liability":1700,"exposure":1700,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Total Exposure","liability":2550,"exposure":2550,"limit":0,"excess":0,"arrears":0,"installment":0}]},{"clientCode":"JHMMD+002","aggregation":[{"type":"Recovery Exposure","liability":1100,"exposure":1600,"limit":0,"excess":1000,"arrears":0,"installment":0},{"type":"Mortgage CPF","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Mortgage Agri","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Asset Finance","liability":1100,"exposure":1600,"limit":0,"excess":1000,"arrears":0,"installment":0},{"type":"Mortgage Residential","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Ordinary Credit Exposure","liability":1100,"exposure":1600,"limit":0,"excess":1000,"arrears":0,"installment":0},{"type":"Total Ordinary Credit Exposure","liability":2200,"exposure":3200,"limit":0,"excess":2000,"arrears":0,"installment":0},{"type":"Total Ordinary Credit","liability":2200,"exposure":3200,"limit":0,"excess":2000,"arrears":0,"installment":0},{"type":"Total Exposure","liability":3300,"exposure":4800,"limit":0,"excess":3000,"arrears":0,"installment":0}]}],"aggregation":[{"type":"Ordinary Credit Total","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0},{"type":"Ordinary Credit Total","liability":0,"exposure":0,"limit":0,"excess":0,"arrears":0,"installment":0}]}]}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetProductExposureAggre_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        productExpTestMock();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Client_Type__c = 'Private Individual';
        acc.CIF__c = 'SNIFFEL001';
        acc.Sic = '35790';
        acc.AccountNumber = '0';
        acc.Registration_Number__c = '1990/011515/23';
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'UoW Test Name';
        opp.StageName = 'Open';
        opp.accountid = acc.id;
        opp.CloseDate = System.today();
        insert opp;
        
        Application__c app2 = new Application__c();
        app2.Opportunity__c = opp.Id;
        insert app2;
        
        List<Application_Profile__c> appProfList = new List<Application_Profile__c>();
        Application_Profile__c appProf = new Application_Profile__c();
        appProf.Client_CIF_Code__c = acc.CIF__c;
        appProf.Client_Name__c = acc.Name;
        appProf.Application__c = app2.Id;
        appProf.Applicant_Type__c = 'Main Applicant';
        appProf.Related_to_Client_ID_or_Reg_Number__c = acc.Registration_Number__c;
        insert appProf;
        
        Application_Exposure__c appExposure = new Application_Exposure__c();
        appExposure.Application__c = app2.Id;
        appExposure.Client_Name__c = appProf.Client_Name__c;
        appExposure.Client_Code__c = appProf.Client_CIF_Code__c;
        appExposure.Product__c = 'TERMLN';
        appExposure.subIndicator__c = 'O';
        appExposure.Exposure__c = '300';
        appExposure.Arrears__c = '300';
        appExposure.Excess__c = '300';
        appExposure.Installment__c = '300';
        appExposure.Liability__c = '300';
        appExposure.Limit__c = '300';
        appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
        insert appExposure;
        
        //Application__c app2 = [SELECT Id FROM Application__c LIMIT 1];
        List<Application_Exposure__c> appExposures = new ApplicationExposureSelector().getAllApplicationExposure(app2.Id);
        List<Application_Profile__c> appProfList1 = [SELECT Id, Client_CIF_Code__c, Client_Name__c, Application__c, Applicant_Type__c, Related_to_Client_ID_or_Reg_Number__c FROM Application_Profile__c LIMIT 1];
        Test.startTest();
        
        GetProductExposureAggre_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        GetProductExposureAggre_Req_IB_v1 reqBean =GetProductExposureAggre_IU_v1.mapRequestFields(appExposures,appProfList1);
        Test.stopTest();
    }
    
    /**
* @description :Method to set the mock
* @author Englarmerdge Mongwe | 2021-06-11 
**/
    public static void productExpTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }
    
    /**
* @description :Method to call the handler method
* @author Englarmerdge Mongwe | 2021-06-11 
* @return GetProductExposureAggre_Resp_IB_v1 
**/
    public static GetProductExposureAggre_Resp_IB_v1 callHandlerMethod() {
        /*
ExposureControllerTest.dataCreation();
List<Application_Profile__c> appProfList = [SELECT Client_Name__c, Client_CIF_Code__c, Applicant_Type__c,Related_to_Client_Id_Or_Reg_Number__c FROM Application_Profile__c];
List<Application_Exposure__c>appExposures=[select Client_Code__c,Client_Name__c,exposure_data_type__c,Arrears__c,Excess__c,Exposure__c,Installment__c,Liability__c,Limit__c,subIndicator__c,Product__c from application_exposure__c];
*/
        GetProductExposureAggre_Req_IB_v1 dummyBean = GetProductExposureAggre_Req_IB_v1.createDummyRequest();
        //GetProductExposureAggre_Req_IB_v1 requestBean=GetProductExposureAggre_IU_v1.mapRequestFields(appExposures,appProfList);
        GetProductExposureAggre_Resp_IB_v1 responseBean = GetProductExposureAggre_IH_v1.getProductExposure(dummyBean);
        return responseBean;
    }
}