/**

 * @description

 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CQUpdClosureDetailsV1_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'CQUpdClosureDetailsV1';


    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param requestBean 
    * @return CQUpdClosureDetailsV1_Resp_IB_v1 
    **/

    public static CQUpdClosureDetailsV1_Resp_IB_v1 updateCloseAccountDetails(CQUpdClosureDetailsV1_Req_IB_v1 requestBean){
        CQUpdClosureDetailsV1_Resp_IB_v1 responseBean = (CQUpdClosureDetailsV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQUpdClosureDetailsV1_Resp_IB_v1.class);
        return responseBean;
    }
}