/*
 * Request Integration Bean for vBlistusersv1 Service
 * @author Mashudu Raidimi
 * @created 2020-07-15
 */
public class vBlistusersv1_Req_IB_v1 extends Base_IB{
  public VBlistUsersV1 VBlistUsersV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Vbp451i {
		public String accNo;
		public String custId;
		public String userNo;
		public String cifKey;
	}

	public class VBlistUsersV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Vbp451i vbp451i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    public static vBlistusersv1_Req_IB_v1 createDummyRequest(){
        vBlistusersv1_Req_IB_v1 requestBean = new vBlistusersv1_Req_IB_v1();
        requestBean.VBlistUsersV1 = new vBlistusersv1_Req_IB_v1.VBlistUsersV1();
        requestBean.VBlistUsersV1.nbsapdpi = new vBlistusersv1_Req_IB_v1.Nbsapdpi();
        requestBean.VBlistUsersV1.nbsapdpi.application = 'BDP';
        requestBean.VBlistUsersV1.nbsapdpi.channel = 'BDP';
        requestBean.VBlistUsersV1.nbsapdpi.trace = 'Y';
        requestBean.VBlistUsersV1.nbsmsgi = new vBlistusersv1_Req_IB_v1.Nbsmsgi();
        requestBean.VBlistUsersV1.nbsmsgi.finalMsgId = new vBlistusersv1_Req_IB_v1.FinalMsgId();
        requestBean.VBlistUsersV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.VBlistUsersV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.VBlistUsersV1.nbsmsgi.msgLanguage = 'E';
        requestBean.VBlistUsersV1.nbsmsgi.msgTarget = 'STD';
        requestBean.VBlistUsersV1.vbp451i = new vBlistusersv1_Req_IB_v1.Vbp451i();
        requestBean.VBlistUsersV1.vbp451i.accNo = '1011110050';
        requestBean.VBlistUsersV1.vbp451i.custId = '0';
        requestBean.VBlistUsersV1.vbp451i.userNo = '001';
        requestBean.VBlistUsersV1.vbp451i.cifKey = 'PIERIDO001';
        return requestBean;
    }

}