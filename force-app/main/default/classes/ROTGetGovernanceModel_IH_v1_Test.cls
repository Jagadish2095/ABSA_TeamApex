/**
* Descripton: Test class for ROTGetGovernanceModel_IH_v1_,ROTGetGovernanceModel_Req_IB_v1.
* Class Name: ROTGetGovernanceModel_IH_v1_Test
* @author   : Manish
* @since    : 2021-1-19
**/
@isTest
public class ROTGetGovernanceModel_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"GetGovernanceModelResponse":{"GetGovernanceModelResult":{"Data":{"GovernanceModelTransactionGroup":[{"Description": "CASH DEPOSITS","EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00","IsEffectiveEndDateInfinity": true,"ObjectID": "CASH DEPOSITS","TransactionTypes":{"GovernanceModelTransactionType":[{"Description": "CARDLESS CASH DEPOSIT", "EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00","IsEffectiveEndDateInfinity": true,"ObjectID": "FN71 CLAD"},{"Description": "CASH ACCEPTOR DEP","EffectiveEndDate": "9999-12-31T00:00:00","EffectiveStartDate": "2019-10-02T00:00:00", "IsEffectiveEndDateInfinity": true,"ObjectID": "FN71 CAD"}]}}]},"HasErrors": false,"HasSystemError": false,"HasValidationErrors": false,"Information": null,"SystemErrorMessage":null,"Tag":null}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTGetGovernanceModel_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ROTGetGovernanceModel_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTGetGovernanceModel_Resp_IB_v1 callHandlerMethod() {
        ROTGetGovernanceModel_Req_IB_v1 dummyBean = ROTGetGovernanceModel_Req_IB_v1.createDummyRequest();
        ROTGetGovernanceModel_Resp_IB_v1 responseBean = ROTGetGovernanceModel_IH_v1.getGovernanceModel(dummyBean);
        return responseBean;
    }
    
}