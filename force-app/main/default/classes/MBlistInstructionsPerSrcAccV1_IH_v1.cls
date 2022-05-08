/*
 * Integration Handler class for MBlistInstructionsPerSourceAccV1 Service
 * @author Mashudu Raidimi
 * @created 2020-08-11
 */
public class MBlistInstructionsPerSrcAccV1_IH_v1 {

    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'mblistinstrpersourceaccv1';
	public static final String SERVICE_NAME = 'mblistinstrpersourceaccv1';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static MBlistInstructionsPerSrcAccV1_Resp_IB_v1 mblistinstrpersourceaccv1(String  cifKeyP, String srcAccP){
        MBlistInstructionsPerSrcAccV1_Req_IB_v1 requestBean = MBlistInstructionsPerSrcAccV1_IU_v1.mapRequestFields(cifKeyP,srcAccP);
        MBlistInstructionsPerSrcAccV1_Resp_IB_v1 responseBean = (MBlistInstructionsPerSrcAccV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MBlistInstructionsPerSrcAccV1_Resp_IB_v1.class);
        return responseBean;
    }
}