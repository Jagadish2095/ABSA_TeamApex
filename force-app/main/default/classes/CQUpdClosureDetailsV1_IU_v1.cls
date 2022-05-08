/**

 * @description

 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CQUpdClosureDetailsV1_IU_v1 {


    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param CQN960I_ACCOUNT_NBR 
    * @param CQN960I_CLOSE_REASON 
    * @return CQUpdClosureDetailsV1_Req_IB_v1 
    **/

    public static CQUpdClosureDetailsV1_Req_IB_v1 mapRequiredFields(String CQN960I_ACCOUNT_NBR, String CQN960I_CLOSE_REASON) {

        CQUpdClosureDetailsV1_Req_IB_v1 requestBean = new CQUpdClosureDetailsV1_Req_IB_v1();
        requestBean.NBSAPDPI = new CQUpdClosureDetailsV1_Req_IB_v1.NBSAPDPI();
        requestBean.NBSMSGI = new CQUpdClosureDetailsV1_Req_IB_v1.NBSMSGI();
        requestBean.CQS960I = new CQUpdClosureDetailsV1_Req_IB_v1.CQS960I();

        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

        requestBean.NBSAPDPI.NBNAPLI_APPLICATION = 'API';
        requestBean.NBSAPDPI.NBNAPLI_CHANNEL = 'Sales Force';
        requestBean.NBSAPDPI.NBNAPLI_TRACE = 'Y';

        requestBean.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestBean.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

        requestBean.CQS960I.CQN960I_ACCOUNT_NBR = CQN960I_ACCOUNT_NBR;//'4048380523';
        requestBean.CQS960I.CQN960I_AGENCY_CODE = '0';//need to confirm with Sizwe.
        requestBean.CQS960I.CQN960I_AGENCY_SITE_TYPE = '034';
        requestBean.CQS960I.CQN960I_CLOSE_REASON = CQN960I_CLOSE_REASON;//'3';
        requestBean.CQS960I.CQN960I_CORP_CODE = 'ABS';
        requestBean.CQS960I.CQN960I_PROCESSING_SITE = currentUser.SiteCode__c;//'8198';
        requestBean.CQS960I.CQN960I_PROCESSING_SITE_TYP = '034';
        requestBean.CQS960I.CQN960I_SUPERVISOR_CODE = currentUser.Supervisor__c;//'333333';
        requestBean.CQS960I.CQN960I_TELLER_NBR = currentUser.Teller_Operator_Code__c;// '2243';

		return requestBean;
    }
}