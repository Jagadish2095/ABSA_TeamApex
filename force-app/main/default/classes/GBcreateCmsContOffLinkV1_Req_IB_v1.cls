/*
 * Request Integration Bean for GBcreateCmsContOffLinkV1 Service
 * @author Diksha Wasekar
 * @created 2020-04-03
 */

public class GBcreateCmsContOffLinkV1_Req_IB_v1 extends Base_IB {

	public GBcreateCmsContOffLinkV1 GBcreateCmsContOffLinkV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Gsp020i {
		public String clientCode;
		public String branchCode;
		public String bankingSector;
		public String indvGroup;
		public String contOffType;
		public String contOffNum;
		public String capByEmployee;
		public String appByEmployee;
		public String overallControl;
		public String businessSeg;
		public String businessSubSeg;
		public String franchisorCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class GBcreateCmsContOffLinkV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Gsp020i gsp020i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    
        //Dummy Method for request
    public static GBcreateCmsContOffLinkV1_Req_IB_v1 createDummyRequest(){
           GBcreateCmsContOffLinkV1_Req_IB_v1 requestBean = new GBcreateCmsContOffLinkV1_Req_IB_v1();
           requestBean.GBcreateCmsContOffLinkV1 = new GBcreateCmsContOffLinkV1_Req_IB_v1.GBcreateCmsContOffLinkV1();
           requestBean.GBcreateCmsContOffLinkV1.gsp020i  = new GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i();
           requestBean.GBcreateCmsContOffLinkV1.nbsapdpi  = new GBcreateCmsContOffLinkV1_Req_IB_v1.Nbsapdpi();
           requestBean.GBcreateCmsContOffLinkV1.nbsmsgi = new GBcreateCmsContOffLinkV1_Req_IB_v1.Nbsmsgi();
        
           
           requestBean.GBcreateCmsContOffLinkV1.Nbsapdpi.channel = 'BDP';
           requestBean.GBcreateCmsContOffLinkV1.Nbsapdpi.application = 'BDP';
           requestBean.GBcreateCmsContOffLinkV1.Nbsapdpi.trace = 'Y';
           
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.clientCode = 'GROBBEL030';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.branchCode = '8198';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.bankingSector = '';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.indvGroup = 'I';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.contOffType = 'SBBM';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.contOffNum = '1';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.capByEmployee = '0939943';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.appByEmployee = '9091968';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.overallControl = '25698';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.businessSeg = '';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.businessSubSeg = '';
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.franchisorCode = '0';


           
           requestBean.GBcreateCmsContOffLinkV1.Nbsmsgi.msgLanguage = 'E';
           requestBean.GBcreateCmsContOffLinkV1.Nbsmsgi.msgTarget = 'STD';
           system.debug('GBcreateCmsContOffLinkV1 Request Bean: ' + requestBean);  
           return requestBean;
    }



}