/*
 * Integration Utility class for AvafGetPartner Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetPartner_IU_v1 {
    public static AvafGetPartner_Req_IB_v1 mapRequestFields(String avafAccNum){
        AvafGetPartner_Req_IB_v1 requestBean = new AvafGetPartner_Req_IB_v1();
        requestBean.BAPI_SF_PARTNER_GET = new AvafGetPartner_Req_IB_v1.BAPI_SF_PARTNER_GET();

        requestBean.BAPI_SF_PARTNER_GET.I_ACCOUNT = avafAccNum.replaceFirst('^0+','').leftPad(11, '0');
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        requestBean.BAPI_SF_PARTNER_GET.I_USER = currentUser.AB_Number__c;

        return requestBean;
    }
}