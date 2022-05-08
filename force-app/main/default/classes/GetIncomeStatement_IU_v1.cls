/**
 * @description       : Integration Utility for GetIncomeStatement Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/

public class GetIncomeStatement_IU_v1 {
    
    /**
    * @description : Creates a requestBean
    * @author Englarmerdge Mongwe | 2021-06-15 
    * @param clientCode 
    * @return GetIncomeStatement_Req_IB_v1 
    **/
    public static GetIncomeStatement_Req_IB_v1 mapRequestFields(String clientCode) {
        GetIncomeStatement_Req_IB_v1 requestBean = new GetIncomeStatement_Req_IB_v1();
        requestBean.client_code = clientCode;
        return requestBean;
    }
}