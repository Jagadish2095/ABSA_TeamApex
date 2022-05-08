/*
 * Request Bean for Triad Service
 * @author Almas Aleem
 * @created 2020-09-16
 */
public class GetTriads_Req_IB_v1 extends Base_IB {
    public class TRC519I {
		public TRC519I_INPUT_DATA TRC519I_INPUT_DATA;
	}

	public NBSAPDPI NBSAPDPI;
	public TRC519I TRC519I;

	public class TRC519I_INPUT_DATA {
		public String TRC519I_CLIENT;
		//public Long TRC519I_ACCOUNT_NO;
	}

	public class NBSAPLI {
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}

	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}

    
      //dummy request
 /*	public static GetTriads_Req_IB_v1 createDummyRequest() {
        GetTriads_Req_IB_v1 requestBean = new GetTriads_Req_IB_v1();
        requestBean.TRC519I = new GetTriads_Req_IB_v1.TRC519I();
        requestBean.TRC519I.TRC519I_INPUT_DATA = new GetTriads_Req_IB_v1.TRC519I_INPUT_DATA();
        requestBean.TRC519I.TRC519I_INPUT_DATA.TRC519I_CLIENT='absa   002'; //client code
       // requestBean.TRC519I.TRC519I_INPUT_DATA.TRC519I_ACCOUNT_NO = '00981223'; //account number optional field
        requestBean.NBSAPDPI  = new GetTriads_Req_IB_v1.NBSAPDPI();
       	GetTriads_Req_IB_v1.NBSAPLI  nbsapli = new GetTriads_Req_IB_v1.NBSAPLI();
        nbsapli.NBNAPLI_APPLICATION='jofp';
        nbsapli.NBNAPLI_TRACE='k';     
        requestBean.NBSAPDPI.NBSAPLI = nbsapli;
        
        system.debug('json parse'+JSON.serialize(requestBean));
        return requestBean;
        
    }*/
}