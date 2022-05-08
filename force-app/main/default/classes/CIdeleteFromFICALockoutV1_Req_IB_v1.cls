/**
 * Request Integration Bean for CIdeleteFromFICALockoutV1
 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CIdeleteFromFICALockoutV1_Req_IB_v1 extends Base_IB {

    public CIdeleteFromFICALockoutV1 CIdeleteFromFICALockoutV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class CIdeleteFromFICALockoutV1 {
		public Nbsapli nbsapli;
		public Nbsmsgi nbsmsgi;
		public Cip600i cip600i;
	}

	public class Nbsapli {
		public String channel;
		public String application;
		public String trace;
	}

	public class Cip600i {
		public String clientCode;
		public String dateIdentified;
		public String dateVerified;
		public String employeeIdentified;
		public String employeeVerified;
		public String branchCode;
		public String delNewToBank;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
	
	public static CIdeleteFromFICALockoutV1_Req_IB_v1 createDummyRequest() {
        CIdeleteFromFICALockoutV1_Req_IB_v1 requestBean = new CIdeleteFromFICALockoutV1_Req_IB_v1();
        requestBean.CIdeleteFromFICALockoutV1 = new CIdeleteFromFICALockoutV1_Req_IB_v1.CIdeleteFromFICALockoutV1();
        requestBean.CIdeleteFromFICALockoutV1.nbsapli = new CIdeleteFromFICALockoutV1_Req_IB_v1.Nbsapli();
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi = new CIdeleteFromFICALockoutV1_Req_IB_v1.Nbsmsgi();
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.finalMsgId = new CIdeleteFromFICALockoutV1_Req_IB_v1.FinalMsgId();
        requestBean.CIdeleteFromFICALockoutV1.cip600i = new CIdeleteFromFICALockoutV1_Req_IB_v1.Cip600i();

        requestBean.CIdeleteFromFICALockoutV1.nbsapli.application = 'BDP';
        requestBean.CIdeleteFromFICALockoutV1.nbsapli.channel = 'BDP';
        requestBean.CIdeleteFromFICALockoutV1.nbsapli.trace = 'Y';

        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.msgTarget = 'STD';

        requestBean.CIdeleteFromFICALockoutV1.cip600i.branchCode = '8918';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.clientCode = 'TREEA+ 020';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.dateIdentified = '20200623';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.dateVerified = '20200623';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.delNewToBank = 'Y';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.employeeIdentified = '999999';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.employeeVerified = '999999';

		return requestBean;
	}
}