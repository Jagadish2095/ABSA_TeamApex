/*
 * Response Integration Bean for AvafChangeDebitOrder Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafChangeDebitOrder_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public List<BAPI_SF_DO_CHG> BAPI_SF_DO_CHG;

    public class BAPI_SF_DO_CHG {
        @AuraEnabled public Integer E_RESPONSE;
        @AuraEnabled public String E_RESPONSE_DESC;
    }
}