/**
* @description Request Bean class for the ContractGetComponent
*
* @author  Kabelo Aphane
* @since   16 July 2021
* @updated Koketso Mpshane 2021-08-13
*/
public class ContractGetComponent_Req_IB_v1 extends Base_IB {
	/**
	* @description Contract_getComponents
	*/
	public class Contract_getComponents {
		public String pstrSessionGID;
		public Integer pintContractTypeID;
	}

	public Contract_getComponents Contract_getComponents;
    
    /**
	 * @description method used for dummy request
	 * @return ContractGetComponent_Req_IB_v1
	 */
	public static ContractGetComponent_Req_IB_v1 createDummyRequest() {
		ContractGetComponent_Req_IB_v1 requestBean = new ContractGetComponent_Req_IB_v1();
        requestBean.Contract_getComponents = new ContractGetComponent_Req_IB_v1.Contract_getComponents();
        requestBean.Contract_getComponents.pstrSessionGID = '9A52AF7B-99A0-4A48-AE0C-3571D0CAAA6C';
        requestBean.Contract_getComponents.pintContractTypeID = 240100000;

		return requestBean;
	}

}