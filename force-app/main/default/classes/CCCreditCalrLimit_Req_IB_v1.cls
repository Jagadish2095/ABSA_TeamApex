public class CCCreditCardLimit_Req_IB_v1 {

	public class KnockOutQuestions {
		public String absaRewards;
		public String creditLifeTermsAndConditionsRead;
	}

	public class Consents {
		public String noticeDelivery;
	}

	public class RequestCommons {
		public String channelCode;
		public String employeeNumber;
		public String messageLanguage;
		public String siteId;
		public String systemName;
		public String userId;
	}

	public class Arg0 {
		public Application application;
		public RequestCommons requestCommons;
		public String validateDetails;
	}

	public class ExternalConsumerData {
		public String customerId;
		public String customerSourceCode;
		public String customerSourceReferenceNumber;
	}

	public class Apply {
		public Arg0 arg0;
	}

	public class PrimaryApplicant {
	}

	public Apply apply;

	public class Application {
		public String applicationNumber;
		public String applicationType;
		public String channelCode;
		public String corpCode;
		public String lockVersionId;
		public String creditStatus;
		public String customerType;
		public Consents consents;
		public ExternalConsumerData externalConsumerData;
		public String marketingSiteId;
		public String productGroupId;
		public String statusGroup;
		public String transactionType;
		public KnockOutQuestions knockOutQuestions;
		public String cardProdSubProdGroupId;
		public String creditLimitApproved;
		public String creditLimitSelected;
		public String hasAcceptedSpecifiedCreditLimit;
		public String creditLifeRequired;
		public String annualCreditLimitIncreases;
		public PrimaryApplicant primaryApplicant;
	}

    public static CCCreditCardLimit_Req_IB_v1 createDummyRequest(){
        CCCreditCardLimit_Req_IB_v1 requestBean = new CCCreditCardLimit_Req_IB_v1();

        requestBean.apply.arg0.application.applicationNumber='102202030723366330';
        requestBean.apply.arg0.application.applicationType='P';
        requestBean.apply.arg0.application.cardProdSubProdGroupId='56';
        requestBean.apply.arg0.application.channelCode='T';
        requestBean.apply.arg0.application.consents.noticeDelivery='1';
        requestBean.apply.arg0.application.corpCode='ABSA';
        requestBean.apply.arg0.application.creditLifeRequired='Y';
        requestBean.apply.arg0.application.creditLimitApproved='80000';
        requestBean.apply.arg0.application.creditLimitSelected='';
        requestBean.apply.arg0.application.creditStatus='';
        requestBean.apply.arg0.application.customerType='001';
        requestbean.apply.arg0.application.externalConsumerData.customerId='8210077042197';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceCode='VFS';
        requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber='This is a test3';
        requestBean.apply.arg0.application.hasAcceptedSpecifiedCreditLimit='true';
        requestBean.apply.arg0.application.knockOutQuestions='';
        requestBean.apply.arg0.application.lockVersionId='';
        requestBean.apply.arg0.application.marketingSiteId='';
        requestBean.apply.arg0.application.primaryApplicant='';
        requestBean.apply.arg0.application.productGroupId='';
        requestBean.apply.arg0.application.statusGroup='';
        requestBean.apply.arg0.application.transactionType='';
        requestBean.apply.arg0.requestCommons.channelCod='';
        requestBean.apply.arg0.requestCommons.employeeNumber='';
        requestBean.apply.arg0.requestCommons.messageLanguage='';
        requestBean.apply.arg0.requestCommons.siteId = '4592';
        requestBean.apply.arg0.requestCommons.systemName = 'BSF';
        requestBean.apply.arg0.requestCommons.userId ='ABAJ013';
        requestBean.apply.arg0.validateDetails='true';
        return requestBean;
    }
	
	
}
