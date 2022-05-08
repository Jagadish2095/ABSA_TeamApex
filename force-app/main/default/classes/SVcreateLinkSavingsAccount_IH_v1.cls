/**
* @description       :
* Test Integration Handler for SVcreateLinkSavingsAccount_IH_v1 Service
* @author Khaliq A
* @created 2021-08-26
*/
public without sharing class SVcreateLinkSavingsAccount_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'SVcreateLinkSavingsAccountV1';
    /**
	 * @description SVcreateLinkSavingsAccount
	 * @return SVcreateLinkSavingsAccount_Resp_IB_v1
	 * @param requestBean	 
	 */
    public static SVcreateLinkSavingsAccount_Resp_IB_v1 SVcreateLinkSavingsAccount(SVcreateLinkSavingsAccount_Req_IB_v1 requestBean) {
        SVcreateLinkSavingsAccount_Resp_IB_v1 responseBean = (SVcreateLinkSavingsAccount_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, SVcreateLinkSavingsAccount_Resp_IB_v1.class);
        return responseBean;
    }

}