/**
* @description Request Bean class for the ContractGetComponent
*
* @author  Kabelo Aphane
* @since   16 July 2021
*/
public class ContractGetComponent_Resp_IB_v1 extends Base_IB{
/**
* @description Contract_getComponentsResult
*/
	public class Contract_getComponentsResult {
		public List<DC2LookUp> DC2LookUp;
	}
/**
* @description DC2LookUp
*/
	public class DC2LookUp {
		public String Description;
		public Integer ID;
		public String IsActive;
		public String Key;
		public String Value1;
		public String Value2;
		public String Value3;
		public String Value4;
	}

	public Contract_getComponentsResponse Contract_getComponentsResponse;
/**
* @description Contract_getComponentsResponse
*/
	public class Contract_getComponentsResponse {
		public Contract_getComponentsResult Contract_getComponentsResult;
	}

}