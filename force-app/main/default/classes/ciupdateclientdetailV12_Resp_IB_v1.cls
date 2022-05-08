public class ciupdateclientdetailV12_Resp_IB_v1 extends Base_IB{
	public Integer retCode;
    public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public CIupdateClientDetailV12Response CIupdateClientDetailV12Response;

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public List<MsgEntry> msgEntry;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Cib004o {
		public String retCode;
	}

	public class CIupdateClientDetailV12Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cib004o cib004o;
	}
    
    public static ciupdateclientdetailV12_Resp_IB_v1 dummyResponse(){
        ciupdateclientdetailV12_Resp_IB_v1 respbean = new ciupdateclientdetailV12_Resp_IB_v1();
        ciupdateclientdetailV12_Resp_IB_v1.CIupdateClientDetailV12Response CIupdateClientDetailV12ResponseBean = new ciupdateclientdetailV12_Resp_IB_v1.CIupdateClientDetailV12Response();
        ciupdateclientdetailV12_Resp_IB_v1.Nbsapdpo Nbsapdpobean = new ciupdateclientdetailV12_Resp_IB_v1.Nbsapdpo();
        ciupdateclientdetailV12_Resp_IB_v1.Nbsmsgo3 Nbsmsgo3Bean = new ciupdateclientdetailV12_Resp_IB_v1.Nbsmsgo3();
        ciupdateclientdetailV12_Resp_IB_v1.Cib004o Cib004oBean = new ciupdateclientdetailV12_Resp_IB_v1.Cib004o();
        ciupdateclientdetailV12_Resp_IB_v1.MsgEntry MsgEntryBean = new ciupdateclientdetailV12_Resp_IB_v1.MsgEntry();
        List<ciupdateclientdetailV12_Resp_IB_v1.MsgEntry> MsgEntryBeanList = new List<ciupdateclientdetailV12_Resp_IB_v1.MsgEntry>();
        
        Nbsapdpobean.version = 'null';
        Nbsapdpobean.returnCode = '0';
        Nbsapdpobean.reasonCode = '0';
        Nbsapdpobean.serviceVersion = 'BUSO008';
        Nbsapdpobean.echoKey = 'null';
        
          MsgEntryBean.msgClass = 'CLSMGC01';
         MsgEntryBean.msgCode = '0003';
         MsgEntryBean.msgErrInd = 'E';
         MsgEntryBean.msgTxt = 'INVALID CLIENT CODE';
        MsgEntryBeanList.add(MsgEntryBean);
        
        Nbsmsgo3Bean.version = 'null';
        Nbsmsgo3Bean.sysErrTxt = 'null';
        Nbsmsgo3Bean.nbrUserMsgs = '1';
        Nbsmsgo3Bean.nbrUserErrs = '0';
        Nbsmsgo3Bean.msgEntry = MsgEntryBeanList;
      
        Cib004oBean.retCode = '3';
        
        CIupdateClientDetailV12ResponseBean.cib004o = cib004oBean;
        CIupdateClientDetailV12ResponseBean.nbsapdpo = nbsapdpoBean;
        CIupdateClientDetailV12ResponseBean.nbsmsgo3 = nbsmsgo3Bean;
        respbean.CIupdateClientDetailV12Response = CIupdateClientDetailV12ResponseBean;
        return respbean;
        
    }
}