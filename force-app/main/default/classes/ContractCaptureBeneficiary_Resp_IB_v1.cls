/*
* Response Integration Bean for contractCaptureBeneficiary Service
* @author chandra Bhushan Singh
* @created 2021-02-03
*/

public class ContractCaptureBeneficiary_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public String status;

    /* public class V3_DC2_LoggedMsg {
        @AuraEnabled public Object CreatedBy;
        @AuraEnabled public Object CreatedDate;
        @AuraEnabled public Object GID;
        @AuraEnabled public Object Level;
        @AuraEnabled public Object LevelID;
        @AuraEnabled public Object Message;
        @AuraEnabled public Object MessageID;
        @AuraEnabled public Object OverRideLevelID;
        @AuraEnabled public Object OverRideReason;
        @AuraEnabled public Object OverrideLevel;
    } */

    @AuraEnabled public Contract_Capture_BeneficaryResponse Contract_Capture_BeneficaryResponse;

    public class Contract_Capture_BeneficaryResponse {
        @AuraEnabled public String Contract_Capture_BeneficaryResult;
        @AuraEnabled public String pcolValidationMessages;
        // @AuraEnabled public V3_DC2_LoggedMsg V3_DC2_LoggedMsg;
    }
}