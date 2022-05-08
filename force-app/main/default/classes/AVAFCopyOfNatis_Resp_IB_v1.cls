/**
 * @description Response Integration Bean for CopyOfNatis Response Service
 * @author Bhanumurty Rayala
 * @created 2021-03-04
 */

public class AVAFCopyOfNatis_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;
}