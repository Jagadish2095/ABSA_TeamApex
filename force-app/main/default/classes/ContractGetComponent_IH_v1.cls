/**
* @description Request Bean class for the ContractGetComponent
*
* @author  Kabelo Aphane
* @since   16 July 2021
* @updated Koketso Mpshane 2021-08-13
*/
public class ContractGetComponent_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Contract Get Component';
    /**
    * @description Intergration Utility class for the ContractGetComponent
    * @param pintContractTypeID
    * @return GetPolicyPremiumRequest_Resp_IB_v1
    */
    public static ContractGetComponent_Resp_IB_v1 ContractGetComponent(Integer pintContractTypeID) {
        
        ContractGetComponent_Req_IB_v1 requestBean = ContractGetComponent_IU_v1.mapRequestFields(pintContractTypeID);
        ContractGetComponent_Resp_IB_v1 responseBean = (ContractGetComponent_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, ContractGetComponent_Resp_IB_v1.class);
        
        return responseBean;
    }
}