/*
 * Request Integration Bean for PRICreationByCommSystem Service
 * @author Poulami Banerjee
 * @created 2021-28-06
 */

public class PRICreationByCommSystem_Resp_IB_v1 extends Base_IB{
    
    //public class Response {
		//@AuraEnabled public Message Message;
		@AuraEnabled public Result Result;
    
        @AuraEnabled public List<PRIResponses> PRIResponses;
	//}

	//@AuraEnabled public Response Response;

	/*public class Message {
		@AuraEnabled public List<PRIResponses> PRIResponses;
	}*/

	public class PRIResponses {
		@AuraEnabled public PRIResponse PRIResponse;
	}

	public class PRIResponse {
		@AuraEnabled public String PRINumber;
		@AuraEnabled public Object ErrorMessage;
		@AuraEnabled public String StatusCode;
		@AuraEnabled public String Status;
		@AuraEnabled public String ProposalNumber;
	}

	public class Result {
		@AuraEnabled public String TransactionId;
		@AuraEnabled public String Code;
		@AuraEnabled public String Status;
		@AuraEnabled public String Description;
	}
}