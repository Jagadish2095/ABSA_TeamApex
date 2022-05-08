/*
 * Integration Handler for Exgery Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

public class ExergyPolicyGetCover_IH_v1 {
    
	public static final String INTEGRATION_SERVICE_NAME = 'Exergy Get Policy Cover';

    public static ExergyPolicyGetCover_Resp_IB_v1 ExergyPolicyGetCover(String IdType, String IdNumber) {

        ExergyPolicyGetCover_Req_IB_v1 requestBean = ExergyPolicyGetCover_IU_v1.mapRequestFields(IdType, IdNumber);
        ExergyPolicyGetCover_Resp_IB_v1 responseBean = (ExergyPolicyGetCover_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ExergyPolicyGetCover_Resp_IB_v1.class);
        return responseBean;
    }
}