/**
 * @description       : Request Integration Bean for GetBalanceSheet Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/


public class GetBalanceSheet_Req_IB_v1 extends Base_IB  {
    public String client_code;

    /**
    * @description : Method to create dummy request
    * @author Englarmerdge Mongwe | 2021-06-15 
    * @return GetBalanceSheet_Req_IB_v1 
    **/
    public static GetBalanceSheet_Req_IB_v1 createDummyRequest() {
        GetBalanceSheet_Req_IB_v1 reqBean = new GetBalanceSheet_Req_IB_v1();
        reqBean.client_code = 'BRINKJH060';
        return reqBean;
    }
}