/** 
 * @description Request Integration Bean for MLgetAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 */
public class  MLgetAcctInfoCUS1V1_Req_IB_v1 extends Base_IB {

    public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;
	public MLB854I MLB854I;

    /**
	* @description NBSMSGI_Z class
	*/
	public class NBSMSGI_Z {
		public NBSMSGI NBSMSGI;
	}

    /**
	* @description MLB854I class
	*/
	public class MLB854I {
		public MLB854I_INPUT_AREA MLB854I_INPUT_AREA;
	}

    /**
	* @description NBSMSGI class
	*/
	public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

    /**
	* @description NBSAPLI class
	*/
	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}

    /**
	* @description NBSAPDPI class
	*/
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}

    /**
	* @description MLB854I_INPUT_AREA class
	*/
	public class MLB854I_INPUT_AREA {
		public Long MLB854I_ACCT_NUMBER;
		public String MLB854I_USER_ID;
		public String MLB854I_SITE_CODE;
		public String MLB854I_REQ_TYPE;
	}

    /**
	* @description createDummyRequest 
    * @return requestBean
	*/
    public static MLgetAcctInfoCUS1V1_Req_IB_v1 createDummyRequest() {
        MLgetAcctInfoCUS1V1_Req_IB_v1 requestBean = new MLgetAcctInfoCUS1V1_Req_IB_v1();
        requestBean.NBSAPDPI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSAPDPI();
        requestBean.NBSAPDPI.NBSAPLI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSAPLI();
        requestBean.NBSMSGI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSMSGI_Z();
        requestBean.NBSMSGI.NBSMSGI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSMSGI();
        requestBean.MLB854I = new MLgetAcctInfoCUS1V1_Req_IB_v1.MLB854I();
        requestBean.MLB854I.MLB854I_INPUT_AREA = new MLgetAcctInfoCUS1V1_Req_IB_v1.MLB854I_INPUT_AREA();
        
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL ='API';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION ='Gateway';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE ='';
        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE= 'E';
        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET= 'STD';
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_ACCT_NUMBER= long.valueOf('8050306640');
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_USER_ID = 'ABGE081';
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_SITE_CODE = 'TEST';
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_REQ_TYPE = 'DUE';

        return requestBean;

    }

}