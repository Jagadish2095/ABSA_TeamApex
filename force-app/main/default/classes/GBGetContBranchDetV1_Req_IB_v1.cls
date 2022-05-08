/*
 * Req Bean for GBGetContBranchDetV1_Req_IB_v1 Service
 * @author Saurabh Pandey
 * @created 2020-09-21
 */

public class GBGetContBranchDetV1_Req_IB_v1 extends Base_IB  {

	public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;
	public GSB021I_Z GSB021I;
    
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}
    public class GSB021I_Z {
		public GSB021I GSB021I;
	}
	public class GSB021I {
		public String GSB021I_CLIENT_CODE;
	}

	public class NBSMSGI_Z {
		public NBSMSGI NBSMSGI;
	}

	public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}


    
     public static GBGetContBranchDetV1_Req_IB_v1 createDummyRequest() {
      GBGetContBranchDetV1_Req_IB_v1 requestBean = new GBGetContBranchDetV1_Req_IB_v1();
      requestbean.NBSAPDPI = new GBGetContBranchDetV1_Req_IB_v1.NBSAPDPI();
      requestbean.NBSMSGI = new GBGetContBranchDetV1_Req_IB_v1.NBSMSGI_Z();
      requestbean.NBSMSGI.NBSMSGI = new GBGetContBranchDetV1_Req_IB_v1.NBSMSGI(); 
      requestbean.GSB021I = new GBGetContBranchDetV1_Req_IB_v1.GSB021I_Z();
      requestbean.GSB021I.GSB021I = new GBGetContBranchDetV1_Req_IB_v1.GSB021I();
      requestbean.NBSAPDPI.NBSAPLI = new GBGetContBranchDetV1_Req_IB_v1.NBSAPLI();
      requestbean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';   
      requestbean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';
      requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'ukzoloircer'; 
      requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'natogehoc';
      requestbean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'i';
      requestbean.GSB021I.GSB021I.GSB021I_CLIENT_CODE = 'pojorej' ;// 'pojorej';
      return requestBean;   
         
     }
}