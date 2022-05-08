/**
 * @description Request Integration Bean for ContractAlterSumAssured Service
 * @author Chandra Bhushan
 * @created 2021-04-08
 */

public class ContractAlterSumAssured_Req_IB_v1 extends Base_IB {

    /**
	 * @description wrapper class Contract_Alter_SumAssured
	 */
	public class Contract_Alter_SumAssured {
		public String pstrSessionGID;
		public String pstrContractGID;
		public String pstrLifeAssuredGid;
		public Integer pintProductId;
		public Integer pintCover;
	}

	public Contract_Alter_SumAssured Contract_Alter_SumAssured;


	/**
	 * @description method used for dummy request
	 * @return ContractAlterSumAssured_Req_IB_v1
	 */
	public static ContractAlterSumAssured_Req_IB_v1 createDummyRequest() {
		ContractAlterSumAssured_Req_IB_v1 requestBean = new ContractAlterSumAssured_Req_IB_v1();
		requestBean.Contract_Alter_SumAssured = new ContractAlterSumAssured_Req_IB_v1.Contract_Alter_SumAssured();
		requestBean.Contract_Alter_SumAssured.pstrSessionGID= 'FF604F67-BDCC-459E-A94F-36C32121D6E0';
		requestBean.Contract_Alter_SumAssured.pstrContractGID = '88883773-4B76-4A31-A3CB-ACCD00FB3A9B';
		requestBean.Contract_Alter_SumAssured.pstrLifeAssuredGid = '0A234980-D8C2-4415-9DA9-ACCC00A104F2';
		requestBean.Contract_Alter_SumAssured.pintProductId = 230110000;
		requestBean.Contract_Alter_SumAssured.pintCover = 80000;

		return requestBean;
	}
}