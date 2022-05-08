/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-06-23
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

public without sharing class SVcreateLinkSavingsNoticeDepAccountV6 {
    private static final String INTEGRATION_SERVICE_NAME = 'SVcreateLinkSavingsNoticeDepAccountV6';
    /**
* @description Method createSavingsAccount
* @param requestBean
* @return responseBean
*/
    public   SVcreateLinkSavingsDepAccount_Resp_IB_v2 createSavingsAccount(SVcreateLinkSavingsDepAccount_Req_IB_v2 requestBean) {
        SVcreateLinkSavingsDepAccount_Resp_IB_v2 responseBean = (SVcreateLinkSavingsDepAccount_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, SVcreateLinkSavingsDepAccount_Resp_IB_v2.class);
        return responseBean;
    }
}