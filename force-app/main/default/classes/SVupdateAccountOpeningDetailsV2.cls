/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 05-04-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   05-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public without sharing class SVupdateAccountOpeningDetailsV2 {
    private static final String INTEGRATION_SERVICE_NAME = 'SVupdateAccountOpeningDetailsV2';
/**
* @description Method updateAccountOpeningDetails
* @param requestBean
* @return responseBean
*/
    public static SVupdateAccount_Resp_IB_v1 updateAccountOpeningDetails(SVupdateAccount_Req_IB_v1 requestBean) {
        SVupdateAccount_Resp_IB_v1 responseBean = (SVupdateAccount_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean,StringConstants.SVUPDATEACCOUNTOPENINGDETAILSV2, SVupdateAccount_Resp_IB_v1.class);
        return responseBean;

    }

}