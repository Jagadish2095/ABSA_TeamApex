/**
 * @description Response bean for Absa Life get policy schedule
 * @author Bhanumurty Rayala
 * @created 2021-10-19
 */
public class AbsaLifeGetPolicySchedule_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;
    
    @AuraEnabled public Header header;
	@AuraEnabled public Body body;

    /**
     * @description Header inner class for input variables
	 */
	public class Header {
		@AuraEnabled public String status;
		@AuraEnabled public String response;
		@AuraEnabled public String comment;
	}

    /**
     * @description Body
	 */
	public class Body {
		@AuraEnabled public String document;
		@AuraEnabled public String impressionId;
	}
}