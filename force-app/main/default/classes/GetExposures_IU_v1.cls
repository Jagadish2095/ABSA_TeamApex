/**
 * @description       : Integration utility class for GetExposures service
 * @author            : Himani Joshi
 * @last modified on  : 2021-06-11
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-10   Himani Joshi   Initial Version
**/

public class GetExposures_IU_v1 {

    /**
    * @description : Method to map request fields
    * @author Himani Joshi | 2021-06-10 
    * @param clientCode 
    * @return GetExposures_Req_IB_v1 
    **/
    public static GetExposures_Req_IB_v1 mapRequestFields(String clientCode){
        GetExposures_Req_IB_v1 requestBean = new GetExposures_Req_IB_v1();
        requestBean.GSB001I = new GetExposures_Req_IB_v1.GSB001I_Z();
        requestBean.GSB001I.GSB001I = new GetExposures_Req_IB_v1.GSB001I();
        requestBean.GSB001I.GSB001I.GSB001I_INPUT_FIELDS = new GetExposures_Req_IB_v1.GSB001I_INPUT_FIELDS();
        requestBean.GSB001I.GSB001I.GSB001I_INPUT_FIELDS.clientCode = clientCode;
        return requestBean;
    }
}