/*
 * Integration Resp for IBgetRegistrationDetailsV1 Service
 * @author Srinivas
 * @created 2020-10-07
 */

public class IBgetRegistrationDetailsV1_Resp_v1 extends Base_IB {
    
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String StatusMessage;
    @AuraEnabled public String status;
    
    public IBgetRegistrationDetailsV1Response IBgetRegistrationDetailsV1Response;
	public class nhp292o{
		public String feeStructure;
		public String clientType;
		public String pinValidationRequired;
		public String clientName;
	}
	public class nbsmsgo3{
		public String sysErrTxt;
		public Integer nbrUserErrs;
		public String version;
		public Integer nbrUserMsgs;
	}
	public class nbsapdpo{
		public String version;
		public Integer returnCode;
		public String serviceVersion;
		public Integer reasonCode;
		public String echoKey;
	}
	public class IBgetRegistrationDetailsV1Response{
		public nbsapdpo nbsapdpo;
		public nhp292o nhp292o;
		public nbsmsgo3 nbsmsgo3;
	}

}