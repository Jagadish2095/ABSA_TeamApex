/**
 *@description Integration Handler for SVcreateLinkSavingsAccount_Req_IB_v1 Service
 * @author khaliq Abdul 
 * @created 2021-08-26
 */
public without sharing class SVcreateLinkSavingsAccount_Req_IB_v1 extends Base_IB{
    
    /** 
     * @description ExpAccActivity
     */
    public class ExpAccActivity {
		public String creditChannel;
		public String creditSource;
		public String debitReason;
	}

	public Application application;
	public Header header;
	public Productdetails productdetails;
	public Incomedetails incomedetails;
	public Customerdetails customerdetails;
	public ExpAccActivity expAccActivity;

     /** 
     * @description Header
     */
	public class Header {
		public String sitecode;
		public String sitetype;
		public String tellerNumber;
		public String marketerCode;
		public String brokersSrc;
		public String brokersCode;
		public String supervisorCode;
		public String agencyCode;
		public String divisionCode;
		public String userid;
		public String deviceid;
		public String workStation;
	}

     /** 
     * @description SourceOfIncome
     */
	public class SourceOfIncome {
		public String sourceOfFunds1;
		public String sourceOfFunds2;
		public String sourceOfFunds3;
		public String sourceOfFunds4;
	}

     /** 
     * @description Customerdetails
     */
	public class Customerdetails {
		public String cifCode;
	}

     /** 
     * @description Incomedetails
     */
	public class Incomedetails {
		public SourceOfIncome sourceOfIncome;
	}

     /** 
     * @description Application
     */
	public class Application {
		public String applicationNumber;
		public String organization;
		public String applicationDateTime;
	}
     /** 
     * @description Productdetails
     */

	public class Productdetails {
		public String rbaRiskHoldIndicator;
		public String fraudHold;
		public String casaHold;
		public String digitalRiskIndicator;
		public String accountName;
		public String accountOpenDate;
		public String accountOpenReason;
		public String investTerm;
		public String investmentAmount;
		public String rateOption;
		public String crpCode;
		public String freqCode;
		public String groupSchCode;
		public String homeEmpPlan;
		public String grantType;
		public String specAcctType;
		public String versionNbr;
		public String productCode;
		public String productVersionNumber;
		public String noticePeriod;
		public String withdrwlPerc;
		public String channelInd;
	}

     public override void setIntegrationTranslations()
     {
         integrationTranslationsMap = new Map<String, String>();
         integrationTranslationsMap.put('incomedetails.sourceOfIncome.sourceOfFunds1','CIFCodesList;Sof' );
         integrationTranslationsMap.put('incomedetails.sourceOfIncome.sourceOfFunds2','CIFCodesList;Sof' );
         integrationTranslationsMap.put('incomedetails.sourceOfIncome.sourceOfFunds3','CIFCodesList;Sof' );
         integrationTranslationsMap.put('incomedetails.sourceOfIncome.sourceOfFunds4','CIFCodesList;Sof' );
         integrationTranslationsMap.put('incomedetails.sourceOfIncome.sourceOfFunds5','CIFCodesList;Sof' );
     }
    
     /** 
     * @description createDummyRequest
     * @return SVcreateLinkSavingsAccount_Req_IB_v1	
     */
    public static SVcreateLinkSavingsAccount_Req_IB_v1 createDummyRequest(){
        
        
        SVcreateLinkSavingsAccount_Req_IB_v1 requestBean = new SVcreateLinkSavingsAccount_Req_IB_v1();

        SVcreateLinkSavingsAccount_Req_IB_v1.ExpAccActivity expAccActivityRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.ExpAccActivity ();
        expAccActivityRequest.creditChannel = 'CASH';
        expAccActivityRequest.creditSource = 'income';
        expAccActivityRequest.debitReason = 'debitReason';
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Header headerRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Header ();
        headerRequest.sitecode = '8198';
        headerRequest.sitetype = '034';
        headerRequest.tellerNumber = '25698';
        headerRequest.marketerCode = '12';
        headerRequest.brokersSrc = '1';
        headerRequest.brokersCode = '12';
        headerRequest.supervisorCode = '25699';
        headerRequest.agencyCode = '34';
        headerRequest.divisionCode = 'ABS';
        headerRequest.userid = 'absa';
        headerRequest.deviceid = 'laptop';
        headerRequest.workStation = '12';

        SVcreateLinkSavingsAccount_Req_IB_v1.SourceOfIncome sourceOfIncomeRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.SourceOfIncome();
        sourceOfIncomeRequest.sourceOfFunds1 = '';
        sourceOfIncomeRequest.sourceOfFunds2 = '';
        sourceOfIncomeRequest.sourceOfFunds3 = '';
        sourceOfIncomeRequest.sourceOfFunds4 = '';
       
        SVcreateLinkSavingsAccount_Req_IB_v1.Customerdetails customerdetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Customerdetails();
        customerdetailsRequest.cifCode = 'MNYANM 012';
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Incomedetails incomedetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Incomedetails();
        incomedetailsRequest.sourceOfIncome = sourceOfIncomeRequest;
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Application applicationRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Application();
        applicationRequest.applicationNumber = '12340987103';
        applicationRequest.organization = 'ABS';
        applicationRequest.applicationDateTime = '2021-08-26 08:08:02';
        
        SVcreateLinkSavingsAccount_Req_IB_v1.Productdetails productdetailsRequest = new SVcreateLinkSavingsAccount_Req_IB_v1.Productdetails();
        productdetailsRequest.rbaRiskHoldIndicator =  ''  ;
        productdetailsRequest.fraudHold =  'Y'  ;
        productdetailsRequest.casaHold =  'Y'  ;
        productdetailsRequest.digitalRiskIndicator =  'Y'  ;
        productdetailsRequest.accountName =  '1234'  ;
        productdetailsRequest.accountOpenDate =  '2021-08-26 08:08:02'  ;
        productdetailsRequest.accountOpenReason =  ''  ;
        productdetailsRequest.investTerm =  '0'  ;
        productdetailsRequest.investmentAmount =  '1000'  ;        
        productdetailsRequest.rateOption =  ''  ;
        productdetailsRequest.crpCode =  ''  ;
        productdetailsRequest.freqCode =  '12'  ;
        productdetailsRequest.groupSchCode =  '1234'  ;
        productdetailsRequest.homeEmpPlan =  'A'  ;
        productdetailsRequest.grantType =  '1'  ;
        productdetailsRequest.specAcctType =  'A'  ;
        productdetailsRequest.versionNbr =  ''  ;
        productdetailsRequest.productCode =  '9040'  ;        
         productdetailsRequest.productVersionNumber =  '0'  ;
        productdetailsRequest.noticePeriod =  '12'  ;
        productdetailsRequest.withdrwlPerc =  '10'  ;
        productdetailsRequest.channelInd =  '0'  ;
         
        requestBean.Productdetails = productdetailsRequest;
        requestBean.Application = applicationRequest;
        requestBean.Incomedetails = incomedetailsRequest;
        requestBean.Customerdetails = customerdetailsRequest;
        requestBean.Header = headerRequest;
        requestBean.ExpAccActivity = expAccActivityRequest;

        return requestBean;
    }

}