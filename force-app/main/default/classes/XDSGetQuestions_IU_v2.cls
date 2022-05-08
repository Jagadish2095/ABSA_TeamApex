/**
 * @description       : 
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-10-12
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public with sharing class XDSGetQuestions_IU_v2 {
   
    /**
    * @description 
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-10-12 
    * @param cellularNo 
    * @param idNumber 
    * @param passportNo 
    * @return XDSGetQuetions_Req_IB_v2 
    **/
    public static XDSGetQuetions_Req_IB_v2 mapRequestFields(String cellularNo, String idNumber, String passportNo) {

        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        XDSGetQuetions_Req_IB_v2 requestBean = new XDSGetQuetions_Req_IB_v2();
        requestBean.agentId = currentUser.Agent_ID__c;
        requestBean.cellularNo = cellularNo;
        requestBean.idNumber = idNumber;
        requestBean.passportNo = passportNo;
        requestBean.percentage = '0';

        return requestBean;
    }
}