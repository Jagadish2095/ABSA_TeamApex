public class CardCommentsV1_Resp_IB_V1 extends Base_IB {

	@AuraEnabled
	public String timeCaptured;
	@AuraEnabled
	public String noOfLines;
	@AuraEnabled
	public List<Comments> comments;

	public class Comments {
		@AuraEnabled
		public String commentLineNo;
		@AuraEnabled
		public String commentText;
	}

}