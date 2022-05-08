/**
 * @description Integration Utility for ContractLapse Service
 * @author Koketso Mpshane
 * @created 2021-06-30
 */
public class ContractLapse_IU_v1 {
    
    /**
	 * @description method to map request fields to creates a request bean
	 * @param pstrContractGID
	 * @param p8dtMovementDate
	 * @param pintLapseReasonID
	 * @param pstrLapseReasonDesc
	 * @param lapseNote - not required, empty ('') string can be passed
	 * @return ContractLapse_Req_IB_v1
	 */
     public static ContractLapse_Req_IB_v1 mapRequestFields(String pstrContractGID, String p8dtMovementDate, Integer pintLapseReasonID, String pstrLapseReasonDesc, String lapseNote) {
        ContractLapse_Req_IB_v1 requestBean = new ContractLapse_Req_IB_v1();
		 
        requestBean.contractLapse = new ContractLapse_Req_IB_v1.contractLapse();
		requestBean.contractLapse.pstrSessionGID = ExergyLoginController.getSessionId();
		requestBean.contractLapse.pstrContractGID = pstrContractGID;
		requestBean.contractLapse.p8dtMovementDate = p8dtMovementDate;
		requestBean.contractLapse.pintLapseReasonID = pintLapseReasonID;
        requestBean.contractLapse.pstrLapseReasonDesc = pstrLapseReasonDesc;
		requestBean.contractLapse.lapseNote = lapseNote;

        return requestBean;
    }

}