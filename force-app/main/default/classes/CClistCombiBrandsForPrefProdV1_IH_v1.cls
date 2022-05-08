/**
 * @description       : Apex/Integration Handler class for cclistcombibrandsforpreferredproductv1 service
 * @author            : André Pietersen
 * @last modified on  : 2021-08-10
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/


public class CClistCombiBrandsForPrefProdV1_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'CClistCombiBrandsForPreferredProductV1';
    
    /**
    * @description 
    * @author 
    * @param requestBean 
    * @return CClistCombiBrandForPrefProdV1_Resp_IB_v1 
    **/
    public static CClistCombiBrandForPrefProdV1_Resp_IB_v1 cclistcombibrandsforpreferredproduct(CClistCombiBrandsForPrefProdV1_Req_IB_v1 requestBean){
        CClistCombiBrandForPrefProdV1_Resp_IB_v1 responseBean = (CClistCombiBrandForPrefProdV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CClistCombiBrandForPrefProdV1_Resp_IB_v1.class);
        return responseBean;
    }
    
}