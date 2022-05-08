/** 
 * @description Integration Handler for SVcreateLinkSavingsDepAccount_IH_v2 Service
 * @author Edited by Prudence Shirindzi
 * @created 2021-05-13
 */
public without sharing class SVcreateLinkSavingsDepAccount_IH_v2 {
    public static final String INTEGRATION_SERVICE_NAME = 'SVcreateLinkSavingsNoticeDepAccountV6';
    /**
    * @description callToSVcreateLinkSavingsDepAccount
    * @return SVcreateLinkSavingsDepAccount_Resp_IB_v2
    * @param oppId
    * @param productId
    * @param srcOfFnds1
    * @param srcOfFnds2
    * @param srcOfFnds3
    * @param srcOfFnds4
    * @param srcOfFnds5
    * @param rbaEddRating
    */
	
    public static SVcreateLinkSavingsDepAccount_Resp_IB_v2 callToSVcreateLinkSavingsDepAccount(String oppId, String productId, String srcOfFnds1, String srcOfFnds2, String srcOfFnds3, String srcOfFnds4, String srcOfFnds5, String rbaEddRating) {
        SVcreateLinkSavingsDepAccount_Req_IB_v2 requestBean = SVcreateLinkSavingsDepAccount_IU_v2.mapRequestdFields(oppId,  productId,  srcOfFnds1,  srcOfFnds2,  srcOfFnds3,  srcOfFnds4,  srcOfFnds5,  rbaEddRating);
        System.debug('#####' + requestBean.serialize(requestBean) + '#####');
        SVcreateLinkSavingsDepAccount_Resp_IB_v2 responseBean = (SVcreateLinkSavingsDepAccount_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, SVcreateLinkSavingsDepAccount_Resp_IB_v2.class);
        return responseBean;
    }
    

}