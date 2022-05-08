/**
 * @description       : Response Integration Bean for TotalGroupExposure Service
 * @author            : Thabo Senkomane
 * @last modified on  : 2021-06-11
 * @last modified by  : Thabo Senkomane
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   2021-06-11   Thabo Senkomane   Initial Version
**/

public class TotalGroupExposure_Resp_IB_v1 extends Base_IB{
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    public TotalGroupExposure totalGroupExposure;
    /**
 * @description       : Inner class with params
 * @author            : Thabo Senkomane
 **/
    public class TotalGroupExposure {
		public Double tgoe;
		public Double tgie;
		public Double tge;
		public Double tgbe;
		public Double tgae;
	}
}