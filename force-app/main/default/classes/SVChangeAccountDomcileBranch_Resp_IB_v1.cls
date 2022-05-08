/**
* Apex Integration Response Bean class for SVChangeAccountDomcileBranchv1 service
* @author  Anka Ganta : Absa
* @since   2020-07-23
*
**/
public class SVChangeAccountDomcileBranch_Resp_IB_v1 extends Base_IB {
    public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public class Svpp44o {
		public String eventNumber;
		public String newSiteCde;
		public String oldSiteCode;
		public String clientName;
		public String newDomicile;
		public String oldDomicile;
	}

	public SVchangeAccountDomcileBranchV1Response SVchangeAccountDomcileBranchV1Response;

	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		//public MsgEntry msgEntry;
		public List<MsgEntry> msgEntry;
	}

	public class SVchangeAccountDomcileBranchV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Svpp44o svpp44o;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
    
     public static SVChangeAccountDomcileBranch_Resp_IB_v1 createDummyResponse(){
         SVChangeAccountDomcileBranch_Resp_IB_v1 respbean = new SVChangeAccountDomcileBranch_Resp_IB_v1();
         SVChangeAccountDomcileBranch_Resp_IB_v1.Nbsapdpo Nbsapdpobean = new SVChangeAccountDomcileBranch_Resp_IB_v1.Nbsapdpo();
         SVChangeAccountDomcileBranch_Resp_IB_v1.Nbsmsgo Nbsmsgobean = new SVChangeAccountDomcileBranch_Resp_IB_v1.Nbsmsgo();
         SVChangeAccountDomcileBranch_Resp_IB_v1.MsgEntry MsgEntrybean = new SVChangeAccountDomcileBranch_Resp_IB_v1.MsgEntry();
         List<SVChangeAccountDomcileBranch_Resp_IB_v1.MsgEntry> MsgEntrybeanList = new List<SVChangeAccountDomcileBranch_Resp_IB_v1.MsgEntry>();
         SVChangeAccountDomcileBranch_Resp_IB_v1.Svpp44o Svpp44obean = new SVChangeAccountDomcileBranch_Resp_IB_v1.Svpp44o();
         SVChangeAccountDomcileBranch_Resp_IB_v1.SVchangeAccountDomcileBranchV1Response SVchangeAccountDomcileBranchV1Responsebean = new SVChangeAccountDomcileBranch_Resp_IB_v1.SVchangeAccountDomcileBranchV1Response();
         
         Nbsapdpobean.returnCode = '0';
         Nbsapdpobean.reasonCode = '0';
         Nbsapdpobean.serviceVersion = 'BUSO001';
         
         Nbsmsgobean.version = 'MSG3001';
         Nbsmsgobean.sysErrTxt = '*EXCEPTION* 23/07/2020 20:24:56. EXCP CODE: 0001. IN PGM: RZPMG0C .   LABEL/SECTION: GRB030  . CALLING PGM: NBM102D .                       PROCESS ID: WSDL STUB -SVPP44  -';
         Nbsmsgobean.nbrUserMsgs = '1';
         Nbsmsgobean.nbrUserErrs = '1';
         MsgEntrybean.msgClass = 'RZSMGAB';
         MsgEntrybean.msgCode = '3';
         MsgEntrybean.msgErrInd = 'E';
         MsgEntrybean.msgTxt = 'A technical/system error has occured.';
         MsgEntrybeanList.add(MsgEntrybean);
         Nbsmsgobean.msgEntry = MsgEntrybeanList;

         
         Svpp44obean.eventNumber = '0';
         Svpp44obean.newSiteCde = '0';
         Svpp44obean.oldSiteCode = '0';
         Svpp44obean.clientName = 'MANUAL (PTY) LTD';
         Svpp44obean.newDomicile = 'DIG INST BUS';
         Svpp44obean.oldDomicile = 'TEST CENTRE';
         
         SVchangeAccountDomcileBranchV1Responsebean.Nbsapdpo = Nbsapdpobean;
         SVchangeAccountDomcileBranchV1Responsebean.Nbsmsgo = Nbsmsgobean;
         SVchangeAccountDomcileBranchV1Responsebean.Svpp44o = Svpp44obean;
         respbean.SVchangeAccountDomcileBranchV1Response = SVchangeAccountDomcileBranchV1Responsebean;
         return respbean;
     }
}