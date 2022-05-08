/*
* Integration Handler for CVSCreateCIFv22 Service
* @author  Thomas Dry : ABSA (IQ Business)
* @version v1.0
* @since   2021-02-15
*/

public class CASAScreenPrimaryClientV7_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'CASA Primary Client Screening v2';
  
    public static CASAScreenPrimaryClientV7_Resp_IB_v1 CASAScreenPrimaryClientV7(CASAScreenPrimaryClientV7_Req_IB_v1 requestBean) { 
        CASAScreenPrimaryClientV7_Resp_IB_v1 responseBean = (CASAScreenPrimaryClientV7_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CASAScreenPrimaryClientV7_Resp_IB_v1.class);
        return responseBean;
    }
}