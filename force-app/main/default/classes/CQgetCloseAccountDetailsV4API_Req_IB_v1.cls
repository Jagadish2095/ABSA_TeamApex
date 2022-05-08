/**

 * @description

 * @Author: Mbuyiseni Mbhokane
 * @Since: 21/10/2020
 */
public class CQgetCloseAccountDetailsV4API_Req_IB_v1 extends Base_IB {

    public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public CQS534I CQS534I;

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

	public class CQS534I {
		public String CQS534I_ACCOUNT_NBR;
		public String CQS534I_PROCESSING_SITE;
		public String CQS534I_PROCESSING_SITE_TYPE;
		public String CQS534I_TELLER_NBR;
		public String CQS534I_AGENCY_CODE;
		public String CQS534I_AGENCY_TYPE;
		public String CQS534I_CONTROLLER_NBR;
		public String CQS534I_CORP_CODE;
		public String CQS534I_EFFECTIVE_CLSD_DATE;
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
	* @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
	* @return CQgetCloseAccountDetailsV4API_Req_IB_v1 
	**/

	public static CQgetCloseAccountDetailsV4API_Req_IB_v1 createDummyRequest() {
        CQgetCloseAccountDetailsV4API_Req_IB_v1 requestBean = new CQgetCloseAccountDetailsV4API_Req_IB_v1();
        requestBean.NBSAPDPI = new CQgetCloseAccountDetailsV4API_Req_IB_v1.NBSAPDPI();
        requestBean.NBSMSGI = new CQgetCloseAccountDetailsV4API_Req_IB_v1.NBSMSGI();
        requestBean.CQS534I = new CQgetCloseAccountDetailsV4API_Req_IB_v1.CQS534I();

        requestBean.NBSAPDPI.NBNAPLI_APPLICATION = 'API';
        requestBean.NBSAPDPI.NBNAPLI_CHANNEL = 'Sales Force';
        requestBean.NBSAPDPI.NBNAPLI_TRACE = 'Y';

        requestBean.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        requestBean.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

        requestBean.CQS534I.CQS534I_ACCOUNT_NBR = '4048382672';
		requestBean.CQS534I.CQS534I_PROCESSING_SITE = '8198';
		requestBean.CQS534I.CQS534I_PROCESSING_SITE_TYPE = '034';
		requestBean.CQS534I.CQS534I_TELLER_NBR = '2243';
		requestBean.CQS534I.CQS534I_AGENCY_CODE = '0';
		requestBean.CQS534I.CQS534I_AGENCY_TYPE = '0';
		requestBean.CQS534I.CQS534I_CONTROLLER_NBR = '2243';
		requestBean.CQS534I.CQS534I_CORP_CODE = 'ABS';
		requestBean.CQS534I.CQS534I_EFFECTIVE_CLSD_DATE = '20201020';

		return requestBean;
	}
}