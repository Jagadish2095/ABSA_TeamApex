/*
 * Integration Handler class for CVMopteddata Service
 * @author Rankwe Lulu
 * @created  2020-10-12
 */
public class CVMopteddata_IH_v1 {
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'cvmopteddata';
	public static final String SERVICE_NAME = 'cvmopteddata';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static CVMopteddata_Res_IB_v1 cvMopteddata(CVMopteddata_Req_IB_v1 requestBean){

        CVMopteddata_Res_IB_v1 responseBean = (CVMopteddata_Res_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null,INTEGRATION_SERVICE_NAME, CVMopteddata_Res_IB_v1.class);
        return responseBean;
        
       
    }

}