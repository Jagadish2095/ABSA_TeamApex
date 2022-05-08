/**
 * @description       : Integration Handler for GetBalanceSheet Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/


public class GetBalanceSheet_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Get Balance Sheet';

    /**
    * @description : Method to get the response from GetBalanceSheet Service
    * @author Englarmerdge Mongwe | 2021-06-15 
    * @param clientCode 
    * @return GetBalanceSheet_Resp_IB_v1 
    **/
    public static GetBalanceSheet_Resp_IB_v1 getBalanceSheet(String clientCode) {
        String endPointSuffix = '?client_code=' + clientCode;
        GetBalanceSheet_Resp_IB_v1 responseBean = (GetBalanceSheet_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(null, endPointSuffix, INTEGRATION_SERVICE_NAME, GetBalanceSheet_Resp_IB_v1.class);
        return responseBean;
    }
}