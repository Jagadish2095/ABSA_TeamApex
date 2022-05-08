/*
* Request Integration Bean for IBlistBeneficiariesV1 Service
* @author Rudolf Niehaus
* @created 2020-03-19
*/

public class IBlistBeneficiariesV1_Req_IB_v1 extends Base_IB {
    
    public IBlistBeneficiariesV1 IBlistBeneficiariesV1;
    
    public class IBlistBeneficiariesV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nhp457i nhp457i;
	}

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nhp457i {
		public String branch;
		public String subBranch;
		public String siteType;
		public String teller;
		public String manager;
		public String agencyCode;
		public String workstation;
		public String supervisor;
		public String accessAccount;
		public String instructionType;
		public String pageKey;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static IBlistBeneficiariesV1_Req_IB_v1 createDummyRequest() {
        
        IBlistBeneficiariesV1_Req_IB_v1 requestBean = new IBlistBeneficiariesV1_Req_IB_v1();
        requestBean.IBlistBeneficiariesV1 = new IBlistBeneficiariesV1_Req_IB_v1.IBlistBeneficiariesV1();
        requestBean.IBlistBeneficiariesV1.nbsapdpi = new IBlistBeneficiariesV1_Req_IB_v1.nbsapdpi();
        requestBean.IBlistBeneficiariesV1.nbsmsgi = new IBlistBeneficiariesV1_Req_IB_v1.nbsmsgi();
        requestBean.IBlistBeneficiariesV1.nhp457i = new IBlistBeneficiariesV1_Req_IB_v1.nhp457i();
		requestBean.IBlistBeneficiariesV1.nbsmsgi.finalMsgId = new IBlistBeneficiariesV1_Req_IB_v1.FinalMsgId();

        requestBean.IBlistBeneficiariesV1.nbsapdpi.channel = 'BPD';
        requestBean.IBlistBeneficiariesV1.nbsapdpi.application = 'BPD';
        requestBean.IBlistBeneficiariesV1.nbsapdpi.trace = 'Y';
		
		requestBean.IBlistBeneficiariesV1.nbsmsgi.msgLanguage = 'E';
		requestBean.IBlistBeneficiariesV1.nbsmsgi.msgTarget = 'STD';
		requestBean.IBlistBeneficiariesV1.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.IBlistBeneficiariesV1.nbsmsgi.finalMsgId.finalMsgCode = '';

		requestBean.IBlistBeneficiariesV1.nhp457i.branch = '8198';
		requestBean.IBlistBeneficiariesV1.nhp457i.subBranch = '8198';
        requestBean.IBlistBeneficiariesV1.nhp457i.siteType = '034';
        requestBean.IBlistBeneficiariesV1.nhp457i.teller = '25699';
        requestBean.IBlistBeneficiariesV1.nhp457i.manager = '25698';
		requestBean.IBlistBeneficiariesV1.nhp457i.agencyCode = '034';
		requestBean.IBlistBeneficiariesV1.nhp457i.workstation = '99';
		requestBean.IBlistBeneficiariesV1.nhp457i.supervisor = '25698';
		requestBean.IBlistBeneficiariesV1.nhp457i.accessAccount = '4048017641';
		requestBean.IBlistBeneficiariesV1.nhp457i.instructionType = 'VP';
		requestBean.IBlistBeneficiariesV1.nhp457i.pageKey = '1e';
        
        return requestBean;
    }
}