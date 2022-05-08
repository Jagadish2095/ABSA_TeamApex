/**
 * @description Integration Request Bean for ContractLapse Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractLapse_Req_IB_v1 extends Base_IB {
    
    public contractLapse contractLapse;
	
    /**
	 * @description wrapper class Contract_Lapse
	 */
	public class contractLapse{
		public String pstrSessionGID;
		public String pstrContractGID;
		public String p8dtMovementDate;
		public Integer pintLapseReasonID;
		public String pstrLapseReasonDesc;
		public String lapseNote;
		public PlstLoggedMessages plstLoggedMessages;
	}
	
    /**
	 * @description wrapper class DC2LoggedMsg
	 */
	public class DC2LoggedMsg {
		public Integer CreatedBy;
		public String CreatedDate;
		public String GID;
		public String Level;
		public Integer LevelID;
		public String Message;
		public Integer MessageID;
		public Integer OverRideLevelID;
		public String OverRideReason;
		public String OverrideLevel;
	}
	
    /**
	 * @description wrapper class PlstLoggedMessages
	 */
	public class PlstLoggedMessages {
		public List<DC2LoggedMsg> DC2LoggedMsg;
	}
    
    /**
	 * @description method used for dummy request
	 * @return ContractLapse_Req_IB_v1
	 */
	public static ContractLapse_Req_IB_v1 createDummyRequest() {
		ContractLapse_Req_IB_v1 requestBean = new ContractLapse_Req_IB_v1();
		
        requestBean.contractLapse = new ContractLapse_Req_IB_v1.contractLapse();
		requestBean.contractLapse.pstrSessionGID = '9A52AF7B-99A0-4A48-AE0C-3571D0CAAA6C';
		requestBean.contractLapse.pstrContractGID = '054EDA9D-8100-4F3A-B5CE-ACD40156526E';
		requestBean.contractLapse.p8dtMovementDate = '20210620';
		requestBean.contractLapse.pintLapseReasonID = 17;
        requestBean.contractLapse.pstrLapseReasonDesc = 'Retrenched';
		requestBean.contractLapse.lapseNote = '';

		return requestBean;
	}

}