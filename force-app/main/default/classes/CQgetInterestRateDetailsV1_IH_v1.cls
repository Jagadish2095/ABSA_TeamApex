/**

* @description Integration Handler for CQgetInterestRateDetailsV1 Service
* @author Jason Q

 * @last modified on  : 2021-06-12
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-12   almas.aleem@absa.africa   Initial Version
**/


public class CQgetInterestRateDetailsV1_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CQ get Interest Rate Details V1';

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-12 
    * @param accnumber 
    * @return CQgetInterestRateDetailsV1_Resp_IB_v1 
    **/
    public static CQgetInterestRateDetailsV1_Resp_IB_v1 getInterestRateDetails(String accnumber) {
		CQgetInterestRateDetailsV1_Req_IB_v1 requestBean = CQgetInterestRateDetailsV1_IU_v1.mapRequestFields(accnumber);
        system.debug('requestBean---'+json.serializePretty(requestBean));
        CQgetInterestRateDetailsV1_Resp_IB_v1 responseBean = (CQgetInterestRateDetailsV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CQgetInterestRateDetailsV1_Resp_IB_v1.class);
        return responseBean;
    }
}