/**
 * Response Integration Bean for CIdeleteFromFICALockoutV1 service
 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CIdeleteFromFICALockoutV1_Resp_IB_v1 extends Base_IB{

    public class CIdeleteFromFICALockoutV1Response {
		public Nbsaplo nbsaplo;
		public Nbsmsgo3 nbsmsgo3;
	}

	public class Nbsaplo {
		public String echoKey;
		public String reasonCode;
		public String returnCode;
		public String serviceVersion;
		public String version;
	}

	public CIdeleteFromFICALockoutV1Response CIdeleteFromFICALockoutV1Response;

	public class Nbsmsgo3 {
		public MsgEntry msgEntry;
		public String nbrUserErrs;
		public String nbrUserMsgs;
		public String sysErrTxt;
		public String version;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
	
	public static CIdeleteFromFICALockoutV1_Resp_IB_v1 createDummyResponse() {
        CIdeleteFromFICALockoutV1_Resp_IB_v1 responseBean = new CIdeleteFromFICALockoutV1_Resp_IB_v1();
        responseBean.CIdeleteFromFICALockoutV1Response = new CIdeleteFromFICALockoutV1_Resp_IB_v1.CIdeleteFromFICALockoutV1Response();
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3 = new CIdeleteFromFICALockoutV1_Resp_IB_v1.Nbsmsgo3();
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.msgEntry = new CIdeleteFromFICALockoutV1_Resp_IB_v1.MsgEntry();
        responseBean.CIdeleteFromFICALockoutV1Response.nbsaplo = new CIdeleteFromFICALockoutV1_Resp_IB_v1.Nbsaplo();

        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.nbrUserErrs = '0';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.nbrUserMsgs = '1';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.sysErrTxt = '';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.version = 'MSG3001';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.msgEntry.msgClass = 'CLSMGC01';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.msgEntry.msgCode = '0731';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.msgEntry.msgErrInd = 'E';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.msgEntry.msgTxt = 'The client has not been removed from the FICA lock-out database.';

        responseBean.CIdeleteFromFICALockoutV1Response.nbsaplo.echoKey = '';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsaplo.reasonCode = '0';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsaplo.returnCode = '0';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsaplo.serviceVersion = 'BUSO001';
        responseBean.CIdeleteFromFICALockoutV1Response.nbsaplo.version = '';

		return responseBean;
	}
}