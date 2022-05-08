/*
 * Response Integration Bean for AVAFStatementRequest Service
 * @author Danie Booysen
 * @created 2020-11-06
 */
public class AVAFStatementRequest_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public BAPI_SF_STMT_REQ[] BAPI_SF_STMT_REQ;

    public class BAPI_SF_STMT_REQ{
        @AuraEnabled public String E_RESPONSE;
        @AuraEnabled public String E_RESPONSE_DESC;
    }
}