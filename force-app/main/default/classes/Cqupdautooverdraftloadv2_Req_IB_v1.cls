/**
 * Integration request class for cqupdautooverdraftloadv2
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 */
public class Cqupdautooverdraftloadv2_Req_IB_v1 extends Base_IB {
	
	public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public CQS573I CQS573I;

	public class InputHeaders {
		public String channelName;
		public String applicationName;
		public String traceIndicator;
	}

	public class VariableDetailTable {
		public Long variableLimit;
		public Integer variableEffectiveDate;
	}

	public class CQS573I {
		public InputAreaCopybook inputAreaCopybook;
	}

	public class ErrorMessageCopybook {
		public String errorMessageLanguage;
		public String errorMessageTarget;
	}

	public class NBSMSGI {
		public ErrorMessageCopybook errorMessageCopybook;
	}

	public class DebitInfoTable {
		public Long debitBalance;
		public Double debitOffset;
		public Double debitEffectiveRate;
	}

	public class NBSAPDPI {
		public InputHeaders inputHeaders;
	}

	public class InputAreaCopybook {
		public Long accountNumber;
		public Integer processingSite;
		public String processingSiteType;
		public Integer branchCode;
		public Integer agencyCode;
		public String workstationNumber;
		public Integer supervisorCode;
		public Long overdraftLimitRequiredAmount;
		public Integer expiryDate;
		public Integer reviewDate;
		public String securityRequiredIndicator;
		public Long securityAmount;
		public String overdraftStatus;
		public Long dayLimitRequiredAmount;
		public Integer dayLimitExpiryDate;
		public Long reductionAmount;
		public String reductionFrequency;
		public Integer reductionEffectiveDate;
		public Long onceOffReductionAmount;
		public Integer onceOffReductionEffectiveDate;
		public Long overdraftGranted;
		public String reductionLimitEnforced;
		public Integer employeeNumber;
		public Integer mandateNumber;
		public Integer regularPayDay;
		public Integer repaymentEffectiveDate;
		public String repaymentFrequency;
		public List<VariableDetailTable> variableDetailTable;
		public Integer tellerNumber;
		public Integer controllerNumber;
		public String corpCode;
		public Long applicationNumber;
		public Long quoteNumber;
		public String action;
		public Integer overdraftType;
		public String armsLengthIndicator;
		public String stateOrOrganIndicator;
		public Long annualTurnover;
		public Long netAssetValue;
		public Integer numberOfTrustees;
		public String allTrusteesPrivateIndividuals;
		public String defaultedOverdraft;
		public Integer pricingIndicator;
		public String ncaInOutIndicator;
		public String espIndicator;
		public String scoringRequiredIndicator;
		public String paymentStructure;
		public Integer factor;
		public Long fixedAmount;
		public String creditLifeIndicator;
		public String debitOrderIndicator;
		public String ncaRequiredIndicator;
		public Long instalmentAmount;
		public Integer creditLifePremium;
		public Integer overdraftLedgerFee;
		public String debitInterestType;
		public Integer initiationFee;
		public Double debitPrimeRate;
		public Integer numberOccurance;
		public List<DebitInfoTable> debitInfoTable;
		public Long settlementTotal;
		public String clientKey;
		public String agreementType;
		public Integer creditLifeNetPremium;
		public Integer creditLifeCommission;
		public Integer creditLifePolicyFee;
		public String debitIntBalanceMethod;
		public String debitIntRateStructure;
		public String pnlInterestType;
		public Double pnlInterestRatePercentage;
		public Double effectiveRate;
		public String securityProvided;
		public Integer excessFee;
		public String empowermentFund;
		public Double overdraftFacilityFee;
	}
    public static Cqupdautooverdraftloadv2_Req_IB_v1 createDummyRequest() {
        Cqupdautooverdraftloadv2_Req_IB_v1 requestnew = new Cqupdautooverdraftloadv2_Req_IB_v1();
        list<Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable> vartablist = new list<Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable>();
        Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable vartab = new Cqupdautooverdraftloadv2_Req_IB_v1.VariableDetailTable();
        vartab.variableLimit = 0;
        vartab.variableEffectiveDate = 0;
        vartablist.add(vartab);
        
        list<Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable> debttablist = new list<Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable>();
        Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable debttab = new Cqupdautooverdraftloadv2_Req_IB_v1.DebitInfoTable();
        debttab.debitBalance = 0;
        debttab.debitOffset = 0.0;
        debttab.debitEffectiveRate = 0.0;
        debttablist.add(debttab);
        
        Cqupdautooverdraftloadv2_Req_IB_v1.InputAreaCopybook req = new Cqupdautooverdraftloadv2_Req_IB_v1.InputAreaCopybook();
        req.accountNumber =4048459685L;
        req.processingSite = 8392; // (Need to Check - Domicile)
        req.branchCode= 8392;
        
        req.processingSiteType = '034';
        req.agencyCode=8392; // Optional Default is 34 (Problem)//Use 113 if 34 is not working
        req.workstationNumber= '99'; // Default is 99
        req.supervisorCode= 1; 
        req.overdraftLimitRequiredAmount= 0; //need more information
        req.expiryDate= 20220310;
        req.reviewDate= 20220311;
        req.securityRequiredIndicator= 'N'; //Default is "N"
        req.securityAmount= 0; //Default is 0;
        req.overdraftStatus= 'GRNT'; //Default is GRNT
        req.dayLimitRequiredAmount= 0; //Default is 0
        req.dayLimitExpiryDate= 0; //Default is 0
        req.reductionAmount=0; 
        
        req.reductionFrequency= ''; //Need to check
         
         
        req.reductionEffectiveDate= 0;
        req.onceOffReductionAmount= 0;
        
        req.onceOffReductionEffectiveDate= 0;
       
        req.overdraftGranted = 0;
        req.reductionLimitEnforced= 'N';
        req.employeeNumber= 1189895;
        
        req.mandateNumber= 113;
        
        req.regularPayDay= 0;
        
        req.repaymentEffectiveDate= 0; //Default is 0
        req.repaymentFrequency = ''; //Default is empty string
        req.tellerNumber= 60;//Integer.valueof(app.Teller_Number__c);//Need to check again
       
        req.controllerNumber= 6;  //Leave it blank 
        req.corpCode= 'ABS'; //default is ABS
        
        req.applicationNumber=0;
        req.quoteNumber= 0; 
        req.action= '1'; //1 is add overdraft, 4 is increase overdraft need more info  
        req.overdraftType= 2;
        
        req.armsLengthIndicator= 'N'; //Default is Y
        req.stateOrOrganIndicator= 'N';
        req.allTrusteesPrivateIndividuals= 'N';
        req.ncaRequiredIndicator = 'N';
       
        req.annualTurnover= 0;
        
        req.netAssetValue= 0;
        
        req.numberOfTrustees= 0;
        
        req.defaultedOverdraft= 'N'; //Default is N
        req.pricingIndicator= 0;// Need to recheck 
        req.ncaInOutIndicator= 'O';
        
        req.espIndicator= 'Y';
        req.scoringRequiredIndicator= 'N';//default to Y
        req.paymentStructure= 'N';//default to N
        req.factor= 0;
        req.fixedAmount= 0;
        req.creditLifeIndicator= 'N'; //default is N
        req.debitOrderIndicator= 'N'; //default is N
        req.instalmentAmount= 0;
        req.creditLifePremium= 0; //default is 0
        req.overdraftLedgerFee= 0;//Need to check again
        req.debitInterestType= 'P';
        req.initiationFee= 0;
        req.debitPrimeRate= 10.35;
        req.numberOccurance= 1; //default is 1 
        req.settlementTotal=0;
        req.clientKey='BLACK  025';
        req.agreementType='S';
        req.creditLifeNetPremium=0; //default is 0
        req.creditLifeCommission=0; //default is 0
        req.creditLifePolicyFee=0; //default is 0
        req.debitIntBalanceMethod='M';
        req.debitIntRateStructure='S';
        req.pnlInterestType='F';
        req.pnlInterestRatePercentage=10.0000;
        req.effectiveRate=20.000;
        req.securityProvided='N'; //default to N need to discuss
        req.excessFee=69;
        req.empowermentFund='';
        req.overdraftFacilityFee=0;
        req.variableDetailTable = vartablist;
        system.debug('vartablist'+vartablist);
        req.debitInfoTable = debttablist;
        system.debug('debitInfoTable'+debttablist);
        
        Cqupdautooverdraftloadv2_Req_IB_v1.InputHeaders inputhead = new Cqupdautooverdraftloadv2_Req_IB_v1.InputHeaders();
        inputhead.channelName = 'ESP'; 
        inputhead.applicationName = 'ESP';
        inputhead.traceIndicator = 'Y';
        
        Cqupdautooverdraftloadv2_Req_IB_v1.ErrorMessageCopybook errcopybook = new Cqupdautooverdraftloadv2_Req_IB_v1.ErrorMessageCopybook();
        errcopybook.errorMessageLanguage = 'E';
        errcopybook.errorMessageTarget = 'STD';
        
        Cqupdautooverdraftloadv2_Req_IB_v1.NBSAPDPI reqmain1 = new Cqupdautooverdraftloadv2_Req_IB_v1.NBSAPDPI();
        reqmain1.inputHeaders = inputhead;
        
        Cqupdautooverdraftloadv2_Req_IB_v1.NBSMSGI reqmain2 = new Cqupdautooverdraftloadv2_Req_IB_v1.NBSMSGI();
        reqmain2.ErrorMessageCopybook = errcopybook;
        
        Cqupdautooverdraftloadv2_Req_IB_v1.CQS573I reqmain3 = new Cqupdautooverdraftloadv2_Req_IB_v1.CQS573I();
        reqmain3.inputAreaCopybook = req;
        
        requestnew.NBSAPDPI = reqmain1;
        requestnew.NBSMSGI = reqmain2;
        requestnew.CQS573I = reqmain3;
        system.debug('reqmain1'+reqmain1);
        system.debug('reqmain2'+reqmain2);
        system.debug('reqmain3'+reqmain3);
        system.debug('test '+JSON.serializePretty(requestnew));
        return requestnew;
        
}
}