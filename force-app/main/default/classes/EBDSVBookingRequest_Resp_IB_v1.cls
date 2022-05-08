/**
 * @description Response Bean for Everyday Banking Card Delivery Booking Request
 * @author Bhanumurty Rayala
 * @created 2021-03-26
 */
public class EBDSVBookingRequest_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public list<String> Messages;
	@AuraEnabled
	public String ReferenceNo;
	@AuraEnabled
	public String Successful;
}