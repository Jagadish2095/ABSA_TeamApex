/**

 * @description Request Integration Bean for CQUpdClosureDetailsV1 service

 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CQUpdClosureDetailsV1_Req_IB_v1 extends Base_IB {

    public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public CQS960I CQS960I;

     /**
    * @description
	*/

	public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

     /**
    * @description
	*/

	public class NBSAPDPI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}

     /**
    * @description
	*/

	public class CQS960I {
		public String CQN960I_ACCOUNT_NBR;
		public String CQN960I_PROCESSING_SITE;
		public String CQN960I_PROCESSING_SITE_TYP;
		public String CQN960I_TELLER_NBR;
		public String CQN960I_AGENCY_CODE;
		public String CQN960I_AGENCY_SITE_TYPE;
		public String CQN960I_SUPERVISOR_CODE;
		public String CQN960I_CORP_CODE;
		public String CQN960I_CLOSE_REASON;
	}
	

	/**
	* @description 
	* @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
	* @return CQUpdClosureDetailsV1_Req_IB_v1 
	**/

	public static CQUpdClosureDetailsV1_Req_IB_v1 createDummyRequest() {
        CQUpdClosureDetailsV1_Req_IB_v1 requestBean = new CQUpdClosureDetailsV1_Req_IB_v1();
        requestBean.NBSAPDPI = new CQUpdClosureDetailsV1_Req_IB_v1.NBSAPDPI();
        requestBean.NBSMSGI = new CQUpdClosureDetailsV1_Req_IB_v1.NBSMSGI();
        requestBean.CQS960I = new CQUpdClosureDetailsV1_Req_IB_v1.CQS960I();

        requestBean.NBSAPDPI.NBNAPLI_APPLICATION = 'API';
        requestBean.NBSAPDPI.NBNAPLI_CHANNEL = 'Sales Force';
        requestBean.NBSAPDPI.NBNAPLI_TRACE = 'Y';

        requestBean.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestBean.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

        requestBean.CQS960I.CQN960I_ACCOUNT_NBR = '4048380523';
        requestBean.CQS960I.CQN960I_AGENCY_CODE = '0';
        requestBean.CQS960I.CQN960I_AGENCY_SITE_TYPE = '034';
        requestBean.CQS960I.CQN960I_CLOSE_REASON = '3';
        requestBean.CQS960I.CQN960I_CORP_CODE = 'ABS';
        requestBean.CQS960I.CQN960I_PROCESSING_SITE = '8198';
        requestBean.CQS960I.CQN960I_PROCESSING_SITE_TYP = '034';
        requestBean.CQS960I.CQN960I_SUPERVISOR_CODE = '333333';
        requestBean.CQS960I.CQN960I_TELLER_NBR = '2243';

		return requestBean;
	}
}