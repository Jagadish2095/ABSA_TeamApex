public class GBlistCommentsV1_Resp_IB_V1 extends Base_IB {

	@AuraEnabled
	public List<Body_cls> body;


	/**
	 * @description inner class
	 */
	public class Body_cls {
		@AuraEnabled
		public String timeCaptured;
		@AuraEnabled
		public String noOfLines;
		@AuraEnabled
		public List<Comments_cls> comments;
	}

	/**
	 * @description inner class
	 */
	public class Comments_cls {
		@AuraEnabled
		public String commentLineNo;
		@AuraEnabled
		public String commentText;
	}

}