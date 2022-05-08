/**
 * @description Integration Utility for ContractCancel Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractCancel_IU_v1 {
    
    /**
	 * @description method to map request fields to creates a request bean
	 * @param pstrContractGID
	 * @param pintDecisionReason
	 * @param pstrDecisionNote
	 * @param pstrCancelRequestDate
	 * @param pstrDecisionReason
	 * @return ContractCancel_Req_IB_v1
	 */
     public static ContractCancel_Req_IB_v1 mapRequestFields(String pstrContractGID, Integer pintDecisionReason, String pstrDecisionNote, String pstrCancelRequestDate, String pstrDecisionReason) {
		ContractCancel_Req_IB_v1 requestBean = new ContractCancel_Req_IB_v1();
		requestBean.Contract_Cancel = new ContractCancel_Req_IB_v1.Contract_Cancel();
		requestBean.Contract_Cancel.pstrSessionGID = ExergyLoginController.getSessionId();
		requestBean.Contract_Cancel.pstrContractGID = pstrContractGID;
		requestBean.Contract_Cancel.pintDecisionReason = pintDecisionReason;
		requestBean.Contract_Cancel.pstrDecisionNote = pstrDecisionNote;
        requestBean.Contract_Cancel.pstrCancelRequestDate = pstrCancelRequestDate;
        requestBean.Contract_Cancel.pstrDecisionReason = pstrDecisionReason;

        return requestBean;
    }

}