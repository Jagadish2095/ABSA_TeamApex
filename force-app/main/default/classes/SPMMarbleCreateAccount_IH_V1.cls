/**
 * @description Controller for Handler class Component
 * @author  Haritha P : Absa
 * @version v1.0
 * @since   2021-03-08
 * @param integration service
 */
public class SPMMarbleCreateAccount_IH_V1 {
public static final String INTEGRATION_SERVICE_NAME = 'Marble Create Account';
	/**
     * @description Method that maps request parameters based on Opportunity Id
     * @param requestBean
     * @return  SPMMarbleCreateAccount_Req_IB_V1
    */
    public static SPMMarbleCreateAccount_Resp_IB_V1 getMarbleAccountNumber(SPMMarbleCreateAccount_Req_IB_V1 requestBean ) {
        SPMMarbleCreateAccount_Resp_IB_V1 responseBean = (SPMMarbleCreateAccount_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, SPMMarbleCreateAccount_Resp_IB_V1.class);
       system.debug('responseBean'+responseBean);
        return responseBean;
    }
}