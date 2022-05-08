/**
* Apex Integration Request Bean class for SVChangeAccountDomcileBranchv1 service
* @author  Anka Ganta : Absa
* @since   2020-07-23
*
**/
public class SVChangeAccountDomcileBranch_Req_IB_v1 extends Base_IB {
   public class SVchangeAccountDomcileBranchV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Svpp44i svpp44i;
	}

	public SVchangeAccountDomcileBranchV1 SVchangeAccountDomcileBranchV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Svpp44i {
		public String accountNumber;
		public String newSiteCode;
		public String chargeIndicator;
		public String savenotDepInd;
		public String divisionCode;
		public String workStation;
		public String branchCode;
		public String agencyCode;
		public String agencySiteType;
		public String tellerCode;
		public String supervisorCode;
		public String branchSiteType;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static SVChangeAccountDomcileBranch_Req_IB_v1 createDummyRequest(){
        SVChangeAccountDomcileBranch_Req_IB_v1 requestbean = new SVChangeAccountDomcileBranch_Req_IB_v1();
        SVChangeAccountDomcileBranch_Req_IB_v1.Nbsapdpi Nbsapdpibean = new SVChangeAccountDomcileBranch_Req_IB_v1.Nbsapdpi();
        SVChangeAccountDomcileBranch_Req_IB_v1.Nbsmsgi Nbsmsgibean = new SVChangeAccountDomcileBranch_Req_IB_v1.Nbsmsgi();
        SVChangeAccountDomcileBranch_Req_IB_v1.FinalMsgId FinalMsgIdbean = new SVChangeAccountDomcileBranch_Req_IB_v1.FinalMsgId();
        SVChangeAccountDomcileBranch_Req_IB_v1.Svpp44i Svpp44ibean = new SVChangeAccountDomcileBranch_Req_IB_v1.Svpp44i();
        SVChangeAccountDomcileBranch_Req_IB_v1.SVchangeAccountDomcileBranchV1 SVchangeAccountDomcileBranchV1bean = new SVChangeAccountDomcileBranch_Req_IB_v1.SVchangeAccountDomcileBranchV1();
        
        Nbsapdpibean.channel = 'BDP';
        Nbsapdpibean.application = 'BDP';
        Nbsapdpibean.trace = 'Y';
        
        FinalMsgIdbean.finalMsgClass = '';
        FinalMsgIdbean.finalMsgCode = '';
        Nbsmsgibean.msgLanguage = 'E';
        Nbsmsgibean.msgTarget = 'STD';
        Nbsmsgibean.finalMsgId = FinalMsgIdbean;
        
        Svpp44ibean.accountNumber = '9051324101';
        Svpp44ibean.newSiteCode = '8919';
        Svpp44ibean.chargeIndicator = 'N';
        Svpp44ibean.savenotDepInd = 'N';
        Svpp44ibean.divisionCode = 'ABS';
        Svpp44ibean.workStation = '99';
        Svpp44ibean.branchCode = '8919';
        Svpp44ibean.agencyCode = '034';
        Svpp44ibean.agencySiteType = '034';
        Svpp44ibean.tellerCode = '999999';
        Svpp44ibean.supervisorCode = '999999';
        Svpp44ibean.branchSiteType = '034';
        
        SVchangeAccountDomcileBranchV1bean.nbsapdpi = nbsapdpibean;
        SVchangeAccountDomcileBranchV1bean.nbsmsgi = nbsmsgibean;
        SVchangeAccountDomcileBranchV1bean.svpp44i = svpp44ibean;
        requestbean.SVchangeAccountDomcileBranchV1 = SVchangeAccountDomcileBranchV1bean;
        
       return requestbean; 
    }
}