/**
 * @description Integration Utility class for ContractAlterSumAssured Service
 * @author Chandra Bhushan Singh
 * @created 2021-04-08
 */

public class ContractAlterSumAssured_IU_v1 {

    /**
     * @description Creates a request bean
     * @param pstrContractGID -
	 * @param pstrLifeAssuredGid -
	 * @param pintProductId -
	 * @param pintCover -
     * @return ContractAlterSumAssured_Req_IB_v1 bean object
     */
    public static ContractAlterSumAssured_Req_IB_v1 mapRequestFields(String pstrContractGID, String pstrLifeAssuredGid, Integer pintProductId, Integer pintCover) {
        ContractAlterSumAssured_Req_IB_v1 requestBean = new ContractAlterSumAssured_Req_IB_v1();
		requestBean.Contract_Alter_SumAssured = new ContractAlterSumAssured_Req_IB_v1.Contract_Alter_SumAssured();
		requestBean.Contract_Alter_SumAssured.pstrSessionGID= ExergyLoginController.getSessionId();
		requestBean.Contract_Alter_SumAssured.pstrContractGID = pstrContractGID;
		requestBean.Contract_Alter_SumAssured.pstrLifeAssuredGid = pstrLifeAssuredGid;
		requestBean.Contract_Alter_SumAssured.pintProductId = pintProductId;
		requestBean.Contract_Alter_SumAssured.pintCover = pintCover;

        return requestBean;
    }
}