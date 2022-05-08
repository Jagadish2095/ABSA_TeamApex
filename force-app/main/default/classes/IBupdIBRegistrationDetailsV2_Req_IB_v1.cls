/*
 * Request Integration Bean for IBupdIBRegistrationDetailsV2 Service
 * @author Linda Motaung
 * @created 2020-10-15
 */

public class IBupdIBRegistrationDetailsV2_Req_IB_v1 extends Base_IB {

	public IBupdIBRegistrationDetailsV2 IBupdIBRegistrationDetailsV2;
	
	public class IBupdIBRegistrationDetailsV2 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nhp295i nhp295i;
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

	public class Nhp295i {
		public String branch;
		public String subBranch;
		public String siteType;
		public String teller;
		public String manager;
		public String agencyCode;
		public String workstation;
		public String supervisor;
		public String accessAccount;
		public String combiCardNumber;
		public String clientType;
		public String serviceType;
		public String numOfAuthRequired;
		public String operatorSystemEnabled;
		public String feeStructure;
		public String costAccount;
		public String salesEmployeeNumber;
		public String ussdCellNumber;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}


    public static IBupdIBRegistrationDetailsV2_Req_IB_v1 createDummyRequest() {
		IBupdIBRegistrationDetailsV2_Req_IB_v1 requestBean = new IBupdIBRegistrationDetailsV2_Req_IB_v1();
		
		IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsapdpi reqObjNbsapdpi = new IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsapdpi();
		reqObjNbsapdpi.channel = 'BDP';
		reqObjNbsapdpi.application = 'BDP';
		reqObjNbsapdpi.trace = 'N';

		IBupdIBRegistrationDetailsV2_Req_IB_v1.FinalMsgId reqObjFinalMsgId = new IBupdIBRegistrationDetailsV2_Req_IB_v1.FinalMsgId();
		reqObjFinalMsgId.finalMsgClass = '';
		reqObjFinalMsgId.finalMsgCode = '';


		IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsmsgi reqObjNbsmsgi = new IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsmsgi ();
		reqObjNbsmsgi.msgLanguage = 'E';
		reqObjNbsmsgi.msgTarget = 'STD';
		//reqObjNbsmsgi.finalMsgId = '';

		IBupdIBRegistrationDetailsV2_Req_IB_v1.Nhp295i reqObjNhp295i = new IBupdIBRegistrationDetailsV2_Req_IB_v1.Nhp295i();
		reqObjNhp295i.branch = '8392';
		reqObjNhp295i.subBranch = 'F';
		reqObjNhp295i.siteType = 'ABS';
		reqObjNhp295i.teller = '00878';
		reqObjNhp295i.manager = '';
		reqObjNhp295i.agencyCode = '0';
		reqObjNhp295i.workstation = '';
		reqObjNhp295i.supervisor = '';
		reqObjNhp295i.accessAccount = '9051337380';
		reqObjNhp295i.combiCardNumber = '9051337380';
		reqObjNhp295i.clientType = 'I';
		reqObjNhp295i.serviceType = 'I';
		reqObjNhp295i.numOfAuthRequired = '0';
		reqObjNhp295i.operatorSystemEnabled = 'N';
		reqObjNhp295i.feeStructure = '02';
		reqObjNhp295i.costAccount = '9051337380';
		reqObjNhp295i.salesEmployeeNumber = '9069257';
		reqObjNhp295i.ussdCellNumber = '0';

        return requestBean;
    }
}