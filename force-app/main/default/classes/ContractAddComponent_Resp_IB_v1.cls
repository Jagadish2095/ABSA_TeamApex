/**
* @description Request Bean class for the ContractAdd
*
* @author  Kabelo Aphane
* @since   16 July 2021
* @updated Koketso Mpshane 2021-08-13
*/
public class ContractAddComponent_Resp_IB_v1 extends Base_IB {
	/**
	* @description wrapper class Contract_Add_ComponentResponse
	*/
	public class Contract_Add_ComponentResponse {
		public Contract_Add_ComponentResult Contract_Add_ComponentResult;
	}

	public Contract_Add_ComponentResponse Contract_Add_ComponentResponse;
	/**
	* @description wrapper class Contract_Add_ComponentResult
	*/
	public class Contract_Add_ComponentResult {
		public String IsSuccess;
		public String ValidationError;
	}

}