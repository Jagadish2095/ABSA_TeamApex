/*
 * Request Integration Bean for Websure Get Token Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

public class WebsureGetToken_Resp_IB_v1 extends Base_IB {

	@AuraEnabled public String Token;
	@AuraEnabled public Integer ReturnCode;
	@AuraEnabled public String ReturnMessage;
	@AuraEnabled public String UserID;
	@AuraEnabled public String SessionID;
	@AuraEnabled public String Expiry;


}