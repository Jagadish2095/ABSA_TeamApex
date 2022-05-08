/*
* Response Integration Bean for IZcreateUniqueKeyV1 Service
* @author  Satya Boyenepalli
* @created 10-11-2020
*/

public class IZcreateUniqueKeyV1_Resp_IB_v1 extends Base_IB {
    public class IZBKEYO {
		@AuraEnabled public OutputDetails outputDetails;
	}
	public class OutputDetails {
		@AuraEnabled public Long uniqueKey;
	}

	@AuraEnabled public IZBKEYO IZBKEYO;
	@AuraEnabled public NBSAPDPO NBSAPDPO;
	@AuraEnabled public NBSMSGO3 NBSMSGO3;

	public class OutputHeaders {
		public String serviceVersion;
		public Integer returnCode;
		public String echoKey;
		public Integer reasonCode;
		public String version;
	}

	public class OutputErrorMessages {
		public String systemErrorText;
		public List<MessageEntryTable> messageEntryTable;
		public String messageVersion;
		public Integer numberUserErrors;
		public Integer numberUserMessages;
	}

	public class NBSAPDPO {
		public OutputHeaders outputHeaders;
	}

	public class MessageEntryTable {
		public String errorMessageCode;
		public String errorMessageIndicator;
		public String errorMessageText;
		public String errorMessageClass;
	}

	public class NBSMSGO3 {
		public OutputErrorMessages outputErrorMessages;
	}
    
}