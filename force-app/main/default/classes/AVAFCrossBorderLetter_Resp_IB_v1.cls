/*
 * Response Integration Bean for crossBorderLetter Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-13
 * @W-006962
 */

public class AVAFCrossBorderLetter_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
}