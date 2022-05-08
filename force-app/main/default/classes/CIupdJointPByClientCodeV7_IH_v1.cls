/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-11-30
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
public class CIupdJointPByClientCodeV7_IH_v1 {
    private static final string SERVICE_NAME = 'ciupdjointparticipantsbyclientcodev7';
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-30 
    * @param acc 
    * @param jointCIF 
    * @param translations 
    * @param responseBeanJointsParticipants 
    * @return CIupdJointPByClientCodeV7_IB_Resp_v1 
    **/
    public static CIupdJointPByClientCodeV7_IB_Resp_v1 updateJoints(Account acc , String jointCIF , Map<String,String> translations , GetJointParticipant_Resp_IB_v1 responseBeanJointsParticipants){
        CIupdJointPByClientCodeV7_IB_Req_v1 requestBean = CIupdJointPByClientCodeV7_IU_v1.mapJointsRequestFields(acc , jointCIF ,1,translations,responseBeanJointsParticipants);
        CIupdJointPByClientCodeV7_IB_Resp_v1 responseBean = (CIupdJointPByClientCodeV7_IB_Resp_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, SERVICE_NAME, CIupdJointPByClientCodeV7_IB_Resp_v1.class); 
        return responseBean;
    }
}