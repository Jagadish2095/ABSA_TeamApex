/** @description Integration Handler Bean for Quote_IH_v1 Service
* @author Satya Boyenepalli
* @created 27-07-2021
*/

public with sharing class  Quote_IH_v1 {
 public static final String INTEGRATION_SERVICE_NAME = 'quote';
    /**
* @description Quot Absa Instant Life
* @param requestBean
* @return Quote_Res_IB_v1
*/

public static  Quote_Res_IB_v1 AbsaInstantLifeQuote(Quote_Req_IB_v1 requestBean){
   Quote_Res_IB_v1 responseBean = (Quote_Res_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  Quote_Res_IB_v1.class);
        return responseBean;
    }
}