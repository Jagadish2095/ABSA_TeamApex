/**
* @description Integration Handler class for the ContractAddComponent
*
* @author  Koketso Mpshane
* @created 2021-08-16
*/
public class ContractAddComponent_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Contract Add Component';
    /**
    * @description Intergration Utility class for the ContractAddComponent
    * @param memberDetails
    * @return ContractAddComponent_Resp_IB_v1
    */
    public static ContractAddComponent_Resp_IB_v1 ContractAddComponent(Map<String, String> memberDetails) {
        ContractAddComponent_Req_IB_v1 requestBean = ContractAddComponent_IU_v1.mapRequestFields(memberDetails);
        ContractAddComponent_Resp_IB_v1 responseBean = (ContractAddComponent_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, ContractAddComponent_Resp_IB_v1.class);
        
        return responseBean;
    }

}