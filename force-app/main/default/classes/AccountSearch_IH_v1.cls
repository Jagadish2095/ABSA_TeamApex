/**
* @description Integration Handler class for AccountSearch Service
* @author Sourabh Yadav
* @created 2021-08-18
*/
public class AccountSearch_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Account Search';
/**
* @description AccountSearch_Resp_IB_v1
* @author Sourabh Yadav
* @created 2021-08-18
* @param creditorAccountLegacyIdentifier
* @return AccountSearch_Resp_IB_v1
*/
    public static AccountSearch_Resp_IB_v1 AccountSearch(String creditorAccountLegacyIdentifier) {
        AccountSearch_Req_IB_v1 requestBean = AccountSearch_IU_v1.mapRequestFields(creditorAccountLegacyIdentifier);
        AccountSearch_Resp_IB_v1 responseBean = (AccountSearch_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, AccountSearch_Resp_IB_v1.class);
        
        return responseBean;
    }
    
}