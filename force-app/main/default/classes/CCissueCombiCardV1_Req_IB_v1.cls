public class CCissueCombiCardV1_Req_IB_v1 extends Base_IB {
    
   	public String channel;
	public String application;
	public String trace;
	public String msgLanguage;
	public String msgTarget;
	public String tellerCode;
	public String workStation;
	public String supervisor;
	public String branchCode;
	public String consumerId;
	public String cardType;
	public String cardNbr;
	public String clntCode;
	public String acctNbr;
	public String prodCode;
	public String brandNbr;
	public String issueBranch;
	public String sbuCode;
	public String persInd;
	public String persName;
	public String persTitl;
	public String persInit;
	public String persSurn;
	public String idType;
	public String idNbr;
	public String nomCheq;
	public String nomSavs;
	public String nomCred;
	public String delvMethod;
	public String delvBranch;
	public String autoLink;
	public String blindInd;
	public String secClntCde;
     
    public override void setIntegrationTranslations()
    {
      	integrationTranslationsMap = new Map<String, String>();
	 	integrationTranslationsMap.put('brandNbr','Combi;Brands');
	}

    public CCissueCombiCardV1_Req_IB_v1 createDummyRequest(){
        CCissueCombiCardV1_Req_IB_v1 reqBean = new CCissueCombiCardV1_Req_IB_v1();
        
        reqBean.channel = 'SF';
        reqBean.application = 'SF';
        reqBean.trace = 'Y';
        reqBean.msgLanguage = 'E';   
        reqBean.issueBranch = '12';
        reqBean.sbuCode = '';
        reqBean.brandNbr = '2698';
        reqBean.persInd = '';
        reqBean.prodCode = '11032';
        reqBean.persName = '';
        reqBean.acctNbr = '4048374867';
        reqBean.persTitl = '';
        reqBean.clntCode = 'PRETOK 003';
        reqBean.persInit = '';
        reqBean.cardNbr = '4483860000145958';
        reqBean.persSurn = '';
        reqBean.cardType = '';
        reqBean.idType = '2';
        reqBean.consumerId = '';
        reqBean.idNbr = 'sd45676';
        reqBean.branchCode = '8198';
        reqBean.nomCheq = '4048374867';
        reqBean.supervisor = '0';
        reqBean.nomSavs = '';
        reqBean.workStation = 'c';
        reqBean.nomCred = '4787692002472012';
        reqBean.tellerCode = '878';
        reqBean.delvMethod = '1';
        reqBean.msgTarget = '';
        reqBean.delvBranch = '6003';		
        reqBean.autoLink = 'Y';		
        reqBean.blindInd = '';		
        reqBean.secClntCde = '';
        
        return reqBean;
    }
}