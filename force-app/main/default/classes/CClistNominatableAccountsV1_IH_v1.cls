/*
 * Response from CClistNominatableAccountsV1 Service
 * @author Satya Boyenepalli
 * @created 2020-11-04
 */
public class CClistNominatableAccountsV1_IH_v1 {
public static final String INTEGRATION_SERVICE_NAME = 'CClistNominatableAccountsV1';

    public static CClistNominatableAccountsV1_Resp_IB_v1 CClistNominatableAccounts(CClistNominatableAccountsV1_Req_IB_v1 requestBean) {
        System.debug('Satya nomitedlist request:' +  JSON.serializePretty(requestBean));
        CClistNominatableAccountsV1_Resp_IB_v1 responseBean = (CClistNominatableAccountsV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CClistNominatableAccountsV1_Resp_IB_v1.class);
       System.debug('Satya nomitedlist respone:' +  JSON.serializePretty(responseBean));
        return responseBean;
    }
}