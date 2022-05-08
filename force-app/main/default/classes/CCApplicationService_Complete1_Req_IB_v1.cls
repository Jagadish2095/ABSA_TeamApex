/*
 * Request Integration Bean for CCApplicationService applyComplete1
 * @author Aaron Castelyn : Absa
 * @created 2020-12-03 
 */

public class CCApplicationService_Complete1_Req_IB_v1 extends Base_IB {
    public class KnockOutQuestions {		
        public String absaRewards;
        public String creditLifeTermsAndConditionsRead;
	}
	
	public Apply apply {get;set;} 
	
	public class Address {
		public String addressLine1 {get;set;} 
		public String addressLine2 {get;set;} 
		public String city {get;set;} 
		public String country {get;set;} 
		public String postalCode {get;set;} 
		public String suburb {get;set;} 
	}
	
	public class Arg0 {
		public Application application {get;set;} 
		public RequestCommons requestCommons {get;set;} 
		public String validateDetails {get;set;}
	}
	
	public class ExternalConsumerData {
		public String customerId {get;set;} 
		public String customerSourceCode {get;set;} 
		public String customerSourceReferenceNumber {get;set;}
	}
	
	public class Apply {
		public Arg0 arg0 {get;set;}
	}
	
	public class RequestCommons {
		public String channelCode {get;set;} 
		public String employeeNumber {get;set;} 
		public String messageLanguage {get;set;} 
		public String siteId {get;set;} 
		public String systemName {get;set;} 
		public String userId {get;set;}
	}
	
	public class Application {
		public String applicationNumber {get;set;} 
        public String applicationType {get;set;}
        public String annualCreditLimitIncreases {get;set;} 
		public String channelCode {get;set;} 
		public String corpCode {get;set;} 
		public String creditStatus {get;set;} 
		public String customerType {get;set;} 
		public ExternalConsumerData externalConsumerData {get;set;}
		public String lockVersionId {get;set;} 
		public String marketingSiteId {get;set;} 
        public String productGroupId {get;set;}
        public String cardProdSubProdGroupId {get;set;}
        public String creditLifeRequired {get;set;}
        public String creditLimitApproved {get;set;}
        public String creditLimitSelected {get;set;}
        public String hasAcceptedSpecifiedCreditLimit {get;set;}        
		public String statusGroup {get;set;} 
		public String transactionType {get;set;} 
        public KnockOutQuestions knockOutQuestions {get;set;}
        public Consents consents {get;set;}
    }

    public class Consents {
        public String noticeDelivery {get;set;}
    }

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"number_Z":');        
    }
    
    public static CCApplicationService_Complete1_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_Complete1_Req_IB_v1 requestBean =  new CCApplicationService_Complete1_Req_IB_v1();
        
        requestBean.apply = new CCApplicationService_Complete1_Req_IB_v1.apply();
        
        requestBean.apply.arg0 = new CCApplicationService_Complete1_Req_IB_v1.Arg0();
        requestBean.apply.arg0.requestCommons = new CCApplicationService_Complete1_Req_IB_v1.RequestCommons();   
        
        requestBean.apply.arg0.application = new CCApplicationService_Complete1_Req_IB_v1.Application();
        
        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_Complete1_Req_IB_v1.ExternalConsumerData();
        
        requestBean.apply.arg0.application.knockOutQuestions = new CCApplicationService_Complete1_Req_IB_v1.KnockOutQuestions();

        requestBean.apply.arg0.application.consents = new CCApplicationService_Complete1_Req_IB_v1.Consents();

		return requestBean;
	}

	public static CCApplicationService_Complete1_Req_IB_v1 createDummyRequest(){
		CCApplicationService_Complete1_Req_IB_v1 requestBean = CCApplicationService_Complete1_Req_IB_v1.getNewInstance();

		requestBean.apply.arg0.application.applicationNumber = '';
        requestBean.apply.arg0.application.applicationType = 'P';
        requestBean.apply.arg0.application.annualCreditLimitIncreases = '';
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.creditStatus = '';
        requestBean.apply.arg0.application.customerType = '001';
        requestBean.apply.arg0.application.lockVersionId = '';
        requestBean.apply.arg0.application.productGroupId = '1';
        requestBean.apply.arg0.application.cardProdSubProdGroupId = '';        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = '';
        requestBean.apply.arg0.application.creditLifeRequired = '';
        requestBean.apply.arg0.application.creditLimitApproved = '';
        requestBean.apply.arg0.application.creditLimitSelected = '';
        requestBean.apply.arg0.application.hasAcceptedSpecifiedCreditLimit = 'true';
        requestBean.apply.arg0.application.consents.noticeDelivery = ''; 

        requestBean.apply.arg0.application.knockOutQuestions.absaRewards = 'Y';
        requestBean.apply.arg0.application.knockOutQuestions.creditLifeTermsAndConditionsRead = 'Y';
        		
		requestBean.apply.arg0.application.externalConsumerData.customerId = '9407229216088';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'ABSA';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = 'This is a test3';
        
		requestBean.apply.arg0.requestCommons.channelCode = 'B';
		requestBean.apply.arg0.requestCommons.employeeNumber = '9019050';
		requestBean.apply.arg0.requestCommons.messageLanguage ='E';
		requestBean.apply.arg0.requestCommons.siteId = '4592';
		requestBean.apply.arg0.requestCommons.systemName = 'BSF';
		requestBean.apply.arg0.requestCommons.userId ='ABAJ013';

		requestBean.apply.arg0.validateDetails ='false';

		return requestBean;
	}
}