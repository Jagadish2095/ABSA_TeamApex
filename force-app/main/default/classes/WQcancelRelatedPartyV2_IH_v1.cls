/**
 * @description       : WQcancelRelatedPartyV2_IH_v1
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-06-27
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class WQcancelRelatedPartyV2_IH_v1 {   
    
    /**
	 * @description cancelRelatedParty
	 *
	 * @param requestBean
	 * @return responseBean
	 */
    public static WQcancelRelatedPartyV2_Resp_IB_v1 cancelRelatedParty(WQcancelRelatedPartyV2_Req_IB_v1 requestBean) { 
        WQcancelRelatedPartyV2_Resp_IB_v1 responseBean = (WQcancelRelatedPartyV2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, StringConstants.CASA_CANCEL_RELATED_PARTY_V7, WQcancelRelatedPartyV2_Resp_IB_v1.class);
        return responseBean;
  
    }
}