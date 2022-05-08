/**
 * @description       : Test class for TotalGroupExposure_IH_v1 class
 * @author            : Thabo Senkomane
 * @last modified on  : 2021-06-18
 * @last modified by  : Saurabh
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   2021-06-11   Thabo Senkomane   Initial Version
**/


@isTest
public class TotalGroupExposure_IH_V1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"totalGroupExposure":{"tgoe":200,"tgie":200,"tge":200,"tgbe":200,"tgae":200}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{TotalGroupExposure_IH_v1.INTEGRATION_SERVICE_NAME});
    }

     @isTest static void testPositive() {
        // Set mock callout class
        totalGroupTestMock();

        Test.startTest();
        TotalGroupExposure_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

    
    /**
    * @description :Method to set the test mock
    * @author Thabo Senkomane | 2021-06-11 
    **/
    public static void totalGroupTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    /**
    * @description :Method to call the handler method
    * @author Thabo Senkomane | 2021-06-11 
    * @return TotalGroupExposure_Resp_IB_v1 
    **/
    private static TotalGroupExposure_Resp_IB_v1 callHandlerMethod() {
        ExposureControllerTest.dataCreation();
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'UoW Test Name' LIMIT 1];
        Application__c application = new ApplicationsSelector().selectByOpportunityId(opp.Id).get(0);
        Application_Exposure_Total_Group__c totalGroupRecord = new Application_Exposure_Total_Group__c();
        totalGroupRecord.Application__c = application.id;
        totalGroupRecord.Client_Code__c = 'SNIFFEL001';
        totalGroupRecord.Control_Branch__c = 'test';
        totalGroupRecord.Branch_code__c = 'test';
        totalGroupRecord.Business_Segment__c = 'test';
        totalGroupRecord.Overall_Control_Branch__c = 'test';
        totalGroupRecord.Application_Total_Group__c = 'Total Group Exposure';
        totalGroupRecord.TGAE__c = 10.00;
        totalGroupRecord.TGBE__c = 10.00;
        totalGroupRecord.TGE__c = 10.00;
        totalGroupRecord.TGIE__c = 10.00;
        totalGroupRecord.TGOE__c = 10.00;
        insert totalGroupRecord;
        List<Application_Profile__c> appProfList = [SELECT Client_Name__c, Client_CIF_Code__c, Applicant_Type__c,Related_to_Client_Id_Or_Reg_Number__c FROM Application_Profile__c];
        List<Application_Exposure_Total_Group__c>appExTot=[select Client_Code__c,Control_Branch__c,Branch_code__c,Business_Segment__c,Overall_Control_Branch__c,Application_Total_Group__c,TGAE__c,TGBE__c,TGE__c,TGIE__c,Primary_Client_of_Group__c,TGOE__c,Ultimate_Primary_Client__c from Application_Exposure_Total_Group__c];
        TotalGroupExposure_Req_IB_v1 req=TotalGroupExposure_UI_v1.mapRequestFields(appExTot, appProfList);
        TotalGroupExposure_Req_IB_v1 requestBean = TotalGroupExposure_Req_IB_v1.createDummyRequest();
        TotalGroupExposure_Resp_IB_v1 responseBean = TotalGroupExposure_IH_v1.GetTotalGroup(requestBean);
        return responseBean;
    }
}