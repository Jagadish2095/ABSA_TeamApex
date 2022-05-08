/*
* @description Integration Handler Test class for RulesEngineService_IH_v1 Service
* @author Saurabh
* @created 2020-07-14
*/
@isTest
public class RulesEngineService_IH_v1_Test { 
    
    
    public static final String POSITIVE_RESPONSE_BODY = '{"msg":"OK from container \'Onboarding_1.0.1-SNAPSHOT\'","result":{"dmn_evaluation_result":{"decision_results":{"x_43E7DD07_6150_419F_8E12_5AC01258C1AA":{"decision_id":"_43E7DD07-6150-419F-8E12-5AC01258C1AA","decision_name":"BankingSectorDecision","status":"SUCCEEDED"},"x_49C14D30_146F_4F8D_9BD4_6416569CF2E8":{"decision_id":"_49C14D30-146F-4F8D-9BD4-6416569CF2E8","decision_name":"BusinessAreaDecision","status":"SUCCEEDED"},"x_70C97339_8373_4D64_AB61_534E6F5E8C3C":{"decision_id":"_70C97339-8373-4D64-AB61-534E6F5E8C3C","decision_name":"BusinessSubSegmentDecision","status":"SUCCEEDED"},"x_8352CC8A_BEAD_493B_8AC4_A0C27C80B117":{"decision_id":"_8352CC8A-BEAD-493B-8AC4-A0C27C80B117","decision_name":"BusinessSegmentsDecision","status":"SUCCEEDED"},"x_A3254AF6_49DD_42BC_B8EC_D44AE1F2CD8B":{"decision_id":"_A3254AF6-49DD-42BC-B8EC-D44AE1F2CD8B","decision_name":"ClientTypeGroupDecision","status":"SUCCEEDED"},"x_E0630042_E9E0_4668_9F97_A83209F0CC8E":{"decision_id":"_E0630042-E9E0-4668-9F97-A83209F0CC8E","decision_name":"SicDecision","status":"SUCCEEDED"},"x_F8299673_69DE_4B8B_B67F_4A8BBB840D0B":{"decision_id":"_F8299673-69DE-4B8B-B67F-4A8BBB840D0B","decision_name":"ClientTypeDecision","result":"FAIL|ClientType|Invalid Client Type","status":"SUCCEEDED"}},"dmn_context":{"BankingSectorModel":"function BankingSectorModel( BankingSector )","BusinessAreaModel":"function BusinessAreaModel( BusinessArea )","BusinessSegmentsModel":"function BusinessSegmentsModel( BusinessSegments )","BusinessSubSegmentModel":"function BusinessSubSegmentModel( BusinessSubSegment )","ClientTypeDecision":"FAIL|ClientType|Invalid Client Type","ClientTypeGroupModel":"function ClientTypeGroupModel( ClientTypeGroup )","ClientTypeModel":"function ClientTypeModel( ClientType )","SicModel":"function SicModel( Sic )"},"messages":[{"dmn_message_severity":"ERROR","message":"ClientTypeGroup=\'null\' does not match any of the valid values null for decision table \'ClientTypeGroupModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_899322AE-4DEA-4A1C-B720-57B52C7B615C"},{"dmn_message_severity":"ERROR","message":"BusinessArea=\'null\' does not match any of the valid values null for decision table \'BusinessAreaModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_94C7C3FE-50E2-4C03-BB28-6C1F8C40CC9A"},{"dmn_message_severity":"WARN","message":"No rule matched for decision table \'SicModel\' and no default values were defined. Setting result to null.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_DBCDC7EF-6EA0-40DD-972D-92C988E0CF1A"},{"dmn_message_severity":"WARN","message":"No rule matched for decision table \'BankingSectorModel\' and no default values were defined. Setting result to null.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_1AE11C81-1542-473E-BEBC-6C40E55C6673"},{"dmn_message_severity":"ERROR","message":"BusinessSegments=\'null\' does not match any of the valid values null for decision table \'BusinessSegmentsModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_03D7EC15-6D0D-43BC-845D-3D040C99C672"},{"dmn_message_severity":"ERROR","message":"BusinessSubSegment=\'null\' does not match any of the valid values null for decision table \'BusinessSubSegmentModel\'.","message_type":"FEEL_EVALUATION_ERROR","source_id":"_485E42B2-D75C-4FFF-82FA-2355C6F17035"}],"model_namespace":"https://kiegroup.org/dmn/_617F61F6-79BE-47A7-9A57-0F9D173B6BC1"}},"status":"OK","statusCode":200,"type":"SUCCESS"}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.Jitterbit, new List<String>{RulesEngineService_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        
           RulesEngineService_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static RulesEngineService_Resp_IB_v1 callHandlerMethod() {
        RulesEngineService_Req_IB_v1 dummyBean = RulesEngineService_Req_IB_v1.createDummyRequest();
        RulesEngineService_Resp_IB_v1 responseBean = RulesEngineService_IH_v1.RulesEngineService(dummyBean);
        return responseBean;
    }
        
    
}