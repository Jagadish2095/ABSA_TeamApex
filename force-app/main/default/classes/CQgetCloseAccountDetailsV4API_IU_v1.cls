/**

 * 

 * @Author: Mbuyiseni Mbhokane
 * @Since: 21/10/2020
 */
public class CQgetCloseAccountDetailsV4API_IU_v1 extends Base_IB{


    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
    * @param CQS534I_ACCOUNT_NBR 
    * @param CQS534I_EFFECTIVE_CLSD_DATE 
    * @return CQgetCloseAccountDetailsV4API_Req_IB_v1 
    **/

    public static CQgetCloseAccountDetailsV4API_Req_IB_v1 mapRequiredFields(String CQS534I_ACCOUNT_NBR, String CQS534I_EFFECTIVE_CLSD_DATE){

        CQgetCloseAccountDetailsV4API_Req_IB_v1 requestBean = new CQgetCloseAccountDetailsV4API_Req_IB_v1();
        requestBean.NBSAPDPI = new CQgetCloseAccountDetailsV4API_Req_IB_v1.NBSAPDPI();
        requestBean.NBSMSGI = new CQgetCloseAccountDetailsV4API_Req_IB_v1.NBSMSGI();
        requestBean.CQS534I = new CQgetCloseAccountDetailsV4API_Req_IB_v1.CQS534I();

        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

        requestBean.NBSAPDPI.NBNAPLI_APPLICATION = 'API';
        requestBean.NBSAPDPI.NBNAPLI_CHANNEL = 'Sales Force';
        requestBean.NBSAPDPI.NBNAPLI_TRACE = 'Y';

        requestBean.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestBean.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

        requestBean.CQS534I.CQS534I_ACCOUNT_NBR = CQS534I_ACCOUNT_NBR;//'4048382672';
		requestBean.CQS534I.CQS534I_PROCESSING_SITE = currentUser.SiteCode__c;// '8198';
		requestBean.CQS534I.CQS534I_PROCESSING_SITE_TYPE = '034';
		requestBean.CQS534I.CQS534I_TELLER_NBR = currentUser.Teller_Operator_Code__c;// '2243';
		requestBean.CQS534I.CQS534I_AGENCY_CODE = '0';
		requestBean.CQS534I.CQS534I_AGENCY_TYPE = '0';
		requestBean.CQS534I.CQS534I_CONTROLLER_NBR = currentUser.Teller_Operator_Code__c;// '2243';
		requestBean.CQS534I.CQS534I_CORP_CODE = 'ABS';
		requestBean.CQS534I.CQS534I_EFFECTIVE_CLSD_DATE = CQS534I_EFFECTIVE_CLSD_DATE;//'20201020';

		return requestBean;
    }
}