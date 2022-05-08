/**
 * Integration Handler for MbCreateInstructionV2 Service
 * @author Englarmerdge Mongwe
 * @created 2020-12-07
 */

public class MbCreateInstructionV2_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Mb Create Instruction V2';

    public static MbCreateInstructionV2_Resp_IB_v1 MbCreateInstructionV2(MbCreateInstructionV2_Req_IB_v1 requestBean) {
        MbCreateInstructionV2_Resp_IB_v1 responseBean = (MbCreateInstructionV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MbCreateInstructionV2_Resp_IB_v1.class);
        return responseBean;
    }
}