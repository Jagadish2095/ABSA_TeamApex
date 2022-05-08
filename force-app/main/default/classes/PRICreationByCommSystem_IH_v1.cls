/*
 * Integration Handler for PRICreationByCommSystem Service
 * @author Poulami Banerjee
 * @created 2021-28-06
 */

public class PRICreationByCommSystem_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'PRI Creation By Commission System';

    public static PRICreationByCommSystem_Resp_IB_v1 GetPRIforAtowrk(Id opportunityIdP) {

        PRICreationByCommSystem_Req_IB_v1 requestBean = PRICreationByCommSystem_IU_v1.mapRequestFieldsfotAtwork(opportunityIdP);
        PRICreationByCommSystem_Resp_IB_v1 responseBean = (PRICreationByCommSystem_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, PRICreationByCommSystem_Resp_IB_v1.class);
        return responseBean;
    }

}