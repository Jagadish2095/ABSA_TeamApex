/**
 * @description Integration Request Bean for ContractDeleteComponent Service
 * @author Koketso Mpshane
 * @created 2021-06-29
 */
public class ContractDeleteComponent_Req_IB_v1 extends Base_IB {

    public Contract_Delete_Component Contract_Delete_Component;
	/**
	 * @description wrapper class Contract_Delete_Component
	 */
	public class Contract_Delete_Component {
		public String pstrSessionGID;
		public String pstrContractGID;
		public String pstrLifeAssuredGid;
		public Integer pintProductId;
	}

    /**
	 * @description method used for dummy request
	 * @return ContractDeleteComponent_Req_IB_v1
	 */
	public static ContractDeleteComponent_Req_IB_v1 createDummyRequest() {
		ContractDeleteComponent_Req_IB_v1 requestBean = new ContractDeleteComponent_Req_IB_v1();
		requestBean.Contract_Delete_Component = new ContractDeleteComponent_Req_IB_v1.Contract_Delete_Component();
		requestBean.Contract_Delete_Component.pstrSessionGID = 'FF604F67-BDCC-459E-A94F-36C32121D6E0';
		requestBean.Contract_Delete_Component.pstrContractGID = 'BD642FEC-CDC8-488F-A5D2-ACD4015897FC';
		requestBean.Contract_Delete_Component.pstrLifeAssuredGid = 'DC79225A-B80C-4296-9E90-ACD4015315C5';
		requestBean.Contract_Delete_Component.pintProductId = 230140000;

		return requestBean;
	}

}