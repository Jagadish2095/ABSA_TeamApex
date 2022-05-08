/**


 * @Author: Mbuyiseni Mbhokane
 * @Since: 21/10/2020
 */
public class CQgetCloseAccountDetailsV4API_IH_v1 extends Base_IB{

    public static final String INTEGRATION_SERVICE_NAME = 'CQgetCloseAccountDetailsV4API';


    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param requestBean 
    * @return CQgetCloseAccountDetailsV4API_Resp_IB_v1 
    **/

    public static CQgetCloseAccountDetailsV4API_Resp_IB_v1 getCloseAccountDetails(CQgetCloseAccountDetailsV4API_Req_IB_v1 requestBean){
        CQgetCloseAccountDetailsV4API_Resp_IB_v1 responseBean = (CQgetCloseAccountDetailsV4API_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQgetCloseAccountDetailsV4API_Resp_IB_v1.class);
        return responseBean;
    }
}