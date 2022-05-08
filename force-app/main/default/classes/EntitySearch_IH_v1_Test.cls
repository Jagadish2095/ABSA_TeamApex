/**
* @description       : Integration Handler class Test for Credit Group View
* @author            : ravi.bodepalli@absa.africa
* @last modified on  : 09-11-2021
* @last modified by  : Tawanda M.
* Modifications Log
* Ver   Date         Author                       Modification
* 1.0   2021-26-10   ravi.bodepalli@absa.africa   Initial Version
**/ 

@IsTest
public class EntitySearch_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"payLoad":[{"EntityId":38,"LongName":"TestPower","ShortName":"SGPower6","SystemId":"0011q00000qPTaTST","EntityType":"001","BusinessPortfolio":"SGP","CreditPortfolio":"Commercial","WFId_":"00000000-0000-0000-0000-000000000000","TaskId_":"00000000-0000-0000-0000-000000000000","VersionId_":1,"CreatedBy_":"93a54b4e-533e-4832-a6e3-c2aefaf4ea97","CreatedDate_":"2021-09-10T11:53:03.371781","t_":"Entity","IsVisible_":true,"Access_":5}],"status":{"info":[{"IsOverMax":false,"ResultCount":1}]}}';
    
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ EntitySearch_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }
    
    @isTest
    static void testPositive() {
        // Set mock callout class
        entitySearch();
        Test.startTest();
       	EntitySearch_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertNotEquals(null, responseBean);
        Test.stopTest();
    }
    
    /**
    * @description Mock Test
    * @author ravi.bodepalli@absa.africa | 2021-26-10
    **/
    public static void entitySearch() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }
    
    private static EntitySearch_Resp_IB_v1 callHandlerMethod() {
        EntitySearch_Req_IB_v1 dummyBean = EntitySearch_Req_IB_v1.createDummyRequest();
        EntitySearch_Resp_IB_v1 responseBean = EntitySearch_IH_v1.entitySearch(dummyBean.payLoad.SystemId);
        return responseBean;
    }
}