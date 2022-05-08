/**
 * @description Integration Utility class for ContractPremiumSumAssured Service
 * @author Chandra Bhushan Singh
 * @created 2021-04-08
 */

public class ContractPremiumSumAssured_IU_v1 {

    /**
     * @description Creates a request bean
     * @param pstrContractGID -
	 * @param pstrLifeAssuredGid -
	 * @param pintProductId -
	 * @param pintCover -
     * @return ContractPremiumSumAssured_Req_IB_v1 bean object
     */
    public static ContractPremiumSumAssured_Req_IB_v1 mapRequestFields(String pstrContractGID, String pstrLifeAssuredGid, Integer pintProductId, Integer pintCover) {
        ContractPremiumSumAssured_Req_IB_v1 requestBean = new ContractPremiumSumAssured_Req_IB_v1();
		requestBean.Contract_Premium_SumAssured = new ContractPremiumSumAssured_Req_IB_v1.Contract_Premium_SumAssured();
		requestBean.Contract_Premium_SumAssured.pstrSessionGID= ExergyLoginController.getSessionId();
		requestBean.Contract_Premium_SumAssured.pstrContractGID = pstrContractGID;
		requestBean.Contract_Premium_SumAssured.pstrLifeAssuredGid = pstrLifeAssuredGid;
		requestBean.Contract_Premium_SumAssured.pintProductId = pintProductId;
		requestBean.Contract_Premium_SumAssured.pintCover = pintCover;

        return requestBean;
    }
}