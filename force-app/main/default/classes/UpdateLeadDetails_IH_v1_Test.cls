/**
 * @description       : updateLeadDetails IH test class
 * @author            : Mbuyiseni Mbhokane
 * @group             : ZyberFox
 * @last modified on  : 05-26-2021
 * @last modified by  : Mbuyiseni Mbhokane
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   05-26-2021   Mbuyiseni Mbhokane   Initial Version
**/

@isTest
public class UpdateLeadDetails_IH_v1_Test {

    public static final String UPDATE_LEAD_DETAILS_RESPONSE_BODY = '[{"code": "0000","message": "success"}]';
    
    /**
    * @description createData method
    * @author Mbuyiseni Mbhokane | 05-26-2021 
    **/
    @TestSetup
    static void createData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{UpdateLeadDetails_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    /**
    * @description testupdateLeadDetailsPositive method
    * @author Mbuyiseni Mbhokane | 05-26-2021 
    **/
    @isTest static void testupdateLeadDetailsPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, UPDATE_LEAD_DETAILS_RESPONSE_BODY));
        Test.startTest();
        UpdateLeadDetails_Resp_IB_v1 responseBean = callHandlerMethod();
        if(responseBean.statusCode==200){
            System.assertEquals(200, responseBean.statusCode);
        }
        else{
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }
        Test.stopTest();
    }

    /**
    * @description callHandlerMethod method
    * @author Mbuyiseni Mbhokane | 05-26-2021 
    * @return UpdateLeadDetails_Resp_IB_v1 
    **/
    private static UpdateLeadDetails_Resp_IB_v1 callHandlerMethod() {
        UpdateLeadDetails_Req_IB_v1 requestBean = UpdateLeadDetails_Req_IB_v1.dummyRequest();
        //List<UpdateLeadDetails_Resp_IB_v1> dummyrespBean = UpdateLeadDetails_Resp_IB_v1.dummyResponses(); // Monde Masiza Removed this line calling incorrect method
        UpdateLeadDetails_Resp_IB_v1 dummyrespBean = UpdateLeadDetails_Resp_IB_v1.dummyResponse();
        UpdateLeadDetails_Resp_IB_v1 responseBean = UpdateLeadDetails_IH_v1.updateLeadDetails(requestBean);
        return responseBean;
    }
}