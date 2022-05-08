/*
 * Response Integration Bean for crossBorderLetter Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-12-02
 * @W-
 */

public class MLRetrieveOnDemandStatement_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public String error;

    @AuraEnabled public String accountNumber;
    @AuraEnabled public String statements;
}