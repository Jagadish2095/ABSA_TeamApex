/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-08-05   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public with sharing class svupdateaccountconditionsv2_IH_v1 {
	
    public static final String INTEGRATION_SERVICE_NAME = 'svupdateaccountconditionsv2';

    /**
	 * @description updateaccountcondition
	 *
	 * @param requestBean
	 * @return responseBean
	 */ public static svupdateaccountconditionsv2_IB_Resp_v1 updateaccountcondition(svupdateaccountconditionsv2_IB_Req_v1 requestBean) {
		
        svupdateaccountconditionsv2_IB_Resp_v1 responseBean = (svupdateaccountconditionsv2_IB_Resp_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, svupdateaccountconditionsv2_IB_Resp_v1.class);
	
		return responseBean;
	}

    
}