/**
 * @description       : 
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-10-12
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public class XDSGetQuestions_IH_v2 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'GetXDSQuestions';

    /**
    * @description 
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-10-12 
    * @param cellularNo 
    * @param idNumber 
    * @param passportNo 
    * @return XDSGetQuetions_Resp_IB_v2 
    **/
    public static XDSGetQuetions_Resp_IB_v2 getXDSQuestions(String cellularNo, String idNumber, String passportNo) {
        XDSGetQuetions_Req_IB_v2 requestBean = XDSGetQuestions_IU_v2.mapRequestFields(cellularNo,idNumber,passportNo);
        XDSGetQuetions_Resp_IB_v2 responseBean = (XDSGetQuetions_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, XDSGetQuetions_Resp_IB_v2.class);
        
        return responseBean;
    }
}