/**
 * @description Response bean for EBDSVReceiveInstructionArray
 * @author Bhannumurty Rayala
 * @created 2021-03-26
 */
public class EBDSVReceiveInstructionArray_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public ReceiveInstructionRequestArrayResponse ReceiveInstructionRequestArrayResponse;
	/**
	 * @description Inner class
	 */
	public class ReceiveInstructionRequestArrayResult {
		@AuraEnabled
		public Items Items;
	}
	/**
	 * @description Inner class
	 */
	public class ReceiveInstructionRequestArrayResponse {
		@AuraEnabled
		public ReceiveInstructionRequestArrayResult ReceiveInstructionRequestArrayResult;
	}
	/**
	 * @description Inner class
	 */
	public class Items {
		@AuraEnabled
		public list<InstructionItemArrayReply> InstructionItemArrayReply;
	}
	/**
	 * @description Inner class
	 */
	public class InstructionItemArrayReply {
		@AuraEnabled
		public String ErrorDetails;
		@AuraEnabled
		public String Success;
		@AuraEnabled
		public String Status;
		@AuraEnabled
		public String SecureItemNo;
		@AuraEnabled
		public String ErrorCode;
		@AuraEnabled
		public String OrderNumber;
	}
}