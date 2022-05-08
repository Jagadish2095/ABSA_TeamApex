/**
 * @description Integration Utility for ContractDeleteComponent Service
 * @author Koketso Mpshane
 * @created 2021-06-29
 */
public class ContractDeleteComponent_IU_v1 {

    /**
     * @description map request fields to creates a request bean
     * @param pstrContractGID
	 * @param pstrLifeAssuredGid
	 * @param pintProductId
     * @return ContractDeleteComponent_Req_IB_v1
     */
    public static ContractDeleteComponent_Req_IB_v1 mapRequestFields(String pstrContractGID, String pstrLifeAssuredGid, Integer pintProductId) {
        ContractDeleteComponent_Req_IB_v1 requestBean = new ContractDeleteComponent_Req_IB_v1();
		requestBean.Contract_Delete_Component = new ContractDeleteComponent_Req_IB_v1.Contract_Delete_Component();
		requestBean.Contract_Delete_Component.pstrSessionGID= ExergyLoginController.getSessionId();
		requestBean.Contract_Delete_Component.pstrContractGID = pstrContractGID;
		requestBean.Contract_Delete_Component.pstrLifeAssuredGid = pstrLifeAssuredGid;
		requestBean.Contract_Delete_Component.pintProductId = pintProductId;

        return requestBean;
    }

}