/**
 * @description Integration Request Bean for ContractCancel Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractCancel_Req_IB_v1 extends Base_IB {
    
    public Contract_Cancel Contract_Cancel;
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
	 * @description wrapper class Contract_Cancel
	 */
	public class Contract_Cancel {
		public String pstrSessionGID;
		public String pstrContractGID;
		public Integer pintDecisionReason;
		public String pstrDecisionNote;
		public String pstrCancelRequestDate;
		public String pstrDecisionReason;
		public PlstLoggedMessages plstLoggedMessages;
	}
    
    /**
	 * @description method used for dummy request
	 * @return ContractCancel_Req_IB_v1
	 */
	public static ContractCancel_Req_IB_v1 createDummyRequest() {
		ContractCancel_Req_IB_v1 requestBean = new ContractCancel_Req_IB_v1();
		requestBean.Contract_Cancel = new ContractCancel_Req_IB_v1.Contract_Cancel();
		requestBean.Contract_Cancel.pstrSessionGID = '18C48E89-BFE4-4BD6-B45E-C0902602C655';
		requestBean.Contract_Cancel.pstrContractGID = 'D25F49B0-F533-43B9-B4B0-ACC701107828';
		requestBean.Contract_Cancel.pintDecisionReason = 1;
		requestBean.Contract_Cancel.pstrDecisionNote = '6635932147';
        requestBean.Contract_Cancel.pstrCancelRequestDate = '20210630';
        requestBean.Contract_Cancel.pstrDecisionReason = 'Cooling off';

		return requestBean;
	}

}