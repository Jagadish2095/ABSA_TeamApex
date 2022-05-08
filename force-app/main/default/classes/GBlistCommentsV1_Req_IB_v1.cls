/**
* @description Request Integration Bean for GBlistCommentsV1 Service
* @author Jagadish Thummala
* @created 2022-03-16
*/
   

public class GBlistCommentsV1_Req_IB_v1 extends Base_IB{
   /**
* @description wrapper class FinalMsgId
*/
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
   /**
* @description wrapper class GBlistCommentsV1
*/
	public GBlistCommentsV1 GBlistCommentsV1;

	public class GBlistCommentsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Gsp007i gsp007i;
	}
  /**
* @description wrapper class Nbsapdpi
*/
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
/**
* @description wrapper class Gsp007i
*/
	public class Gsp007i {
		public String option;
		public String dateFrom;
		public String clientCode;
		public String type;
		public String inputBranch;
	}
 /**
* @description wrapper class Nbsmsgi
*/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
 /**
* @description method used for dummy request
* @return CardCommentsV1_Req_IB_v1
*/
	
	public static GBlistCommentsV1_Req_IB_v1 createDummyRequest() {
		GBlistCommentsV1_Req_IB_v1 requestBean= new GBlistCommentsV1_Req_IB_v1();
		requestBean.GBlistCommentsV1= new GBlistCommentsV1_Req_IB_v1.GBlistCommentsV1();
		requestBean.GBlistCommentsV1.nbsapdpi= new GBlistCommentsV1_Req_IB_v1.nbsapdpi();
		requestBean.GBlistCommentsV1.gsp007i = new GBlistCommentsV1_Req_IB_v1.gsp007i();
		requestBean.GBlistCommentsV1.nbsmsgi = new GBlistCommentsV1_Req_IB_v1.nbsmsgi();
        requestBean.GBlistCommentsV1.nbsmsgi.finalMsgId= new GBlistCommentsV1_Req_IB_v1.finalMsgId();
		requestBean.GBlistCommentsV1.nbsapdpi.application='SF';
		requestBean.GBlistCommentsV1.nbsapdpi.channel='SF';
		requestBean.GBlistCommentsV1.nbsapdpi.trace='Y';
		requestBean.GBlistCommentsV1.nbsmsgi.finalMsgId.finalMsgClass='';
		requestBean.GBlistCommentsV1.nbsmsgi.finalMsgId.finalMsgCode='';
		requestBean.GBlistCommentsV1.nbsmsgi.msgLanguage='E';
		requestBean.GBlistCommentsV1.nbsmsgi.msgTarget='STD';
		requestBean.GBlistCommentsV1.gsp007i.clientCode='JINPIX 001';
		requestBean.GBlistCommentsV1.gsp007i.dateFrom='20210531';
		requestBean.GBlistCommentsV1.gsp007i.inputBranch='8913';
		requestBean.GBlistCommentsV1.gsp007i.option='E';
		requestBean.GBlistCommentsV1.gsp007i.type='FAL';

        return requestBean;
	}

}