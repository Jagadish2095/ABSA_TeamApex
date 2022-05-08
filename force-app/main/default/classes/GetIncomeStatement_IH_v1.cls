/**
 * @description       : Integration Handler for GetIncomeStatement Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/


public class GetIncomeStatement_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Get Income Statement';

    /**
    * @description : Method to get the response from GetIncomeStatement service
    * @author Englarmerdge Mongwe | 2021-06-15 
    * @param clientCode 
    * @return GetIncomeStatement_Resp_IB_v1 
    **/
    public static GetIncomeStatement_Resp_IB_v1 getIncomeStatement(String clientCode) {
        String endPointSuffix = '?client_code=' + clientCode;
        GetIncomeStatement_Resp_IB_v1 responseBean = (GetIncomeStatement_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(null, endPointSuffix, INTEGRATION_SERVICE_NAME, GetIncomeStatement_Resp_IB_v1.class);
        return responseBean;
    }
}