/**
 * @description       : Integration Utility for GetBalanceSheet Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/

public class GetBalanceSheet_IU_v1 {
    
    /**
    * @description : Creates a request bean
    * @author Englarmerdge Mongwe | 2021-06-15 
    * @param clientCode 
    * @return GetBalanceSheet_Req_IB_v1 
    **/
    public static GetBalanceSheet_Req_IB_v1 mapRequestFields(String clientCode) {
        GetBalanceSheet_Req_IB_v1 requestBean = new GetBalanceSheet_Req_IB_v1();
        requestBean.client_code = clientCode;
        return requestBean;
    }
}