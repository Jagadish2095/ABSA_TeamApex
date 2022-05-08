/**
* @description Request Bean class for the ContractGetComponent
*
* @author  Kabelo Aphane
* @since   16 July 2021
* @updated Koketso Mpshane 2021-08-13
*/
public class ContractGetComponent_IU_v1 {
	/**
	* @description mapRequestFields
	* @param pintContractTypeID
	* @return GetClaimsRequest_Req_IB_V1
	* 
	*/
    public static ContractGetComponent_Req_IB_v1 mapRequestFields(Integer pintContractTypeID){
        ContractGetComponent_Req_IB_v1 requestBean = new ContractGetComponent_Req_IB_v1();
        requestBean.Contract_getComponents = new ContractGetComponent_Req_IB_v1.Contract_getComponents();
        requestBean.Contract_getComponents.pstrSessionGID = ExergyLoginController.getSessionId();
        requestBean.Contract_getComponents.pintContractTypeID = pintContractTypeID;
        
        return requestBean;
    }
}