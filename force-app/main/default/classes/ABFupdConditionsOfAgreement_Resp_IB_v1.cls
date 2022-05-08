/*
* Integration Response Bean for get conditions of agreement
* @author Almas Aleem:Absa  
* @created 2020-12-02
*/
public class ABFupdConditionsOfAgreement_Resp_IB_v1 extends Base_IB{
    
public class MessageErrors {
		public OutPutMessageErrors outPutMessageErrors;
	}

	public MessageHeaders messageHeaders;
	public MessageErrors messageErrors;

	public class OutPutMessageErrors {
		public String sysErrorText;
		public Integer nbrUserMessages;
		public List<MessageEntryTabel> MessageEntryTabel;
		public Integer nbrUserErrors;
		public String version;
	}

	public class MessageEntryTabel {
		public String messageText;
		public String messageErrorInd;
		public String messageClass;
		public String messageCode;
	}

	public class OutPutMessageHeaders {
		public String serviceVersion;
		public Integer returnCode;
		public Integer reasonCode;
	}

	public class MessageHeaders {
		public OutPutMessageHeaders outPutMessageHeaders;
	}

}