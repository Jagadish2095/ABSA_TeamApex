/*
 * Request Integration Bean for CCApplicationService quoteAccept
 * @author Aaron Castelyn : Absa
 * @created 2020-12-18 
 */

public class CCApplicationService_QteAccept_Req_IB_v1 extends Base_IB {
    public apply apply;
	
	public class requestCommons{
		public String channelCode;
		public String employeeNumber;
		public String messageLanguage;
		public String systemName;
		public String userId;
		public String siteId;
	}
	
	public class quote{
		public String statusCode;
		public String emailOrFaxInfo;
		public String decision;
		public String linkedAccountNumberSelected;
		public String creditLimit;
		public String z_number; // in json: number
		public String creditLifeRequired;
		public String numberOfQuotesIssued;
		public String cardProdSubProdGroupId;
	}
	
	public class primaryApplicant{
    }
    	
	public class knockOutQuestions{		
    }
    	
	public class arg0{
		public application application;
		public String validateDetails;
		public requestCommons requestCommons;
    }
    
	public class apply{
		public arg0 arg0;
    }
    
    public class creditStatus{
		public String id;
		public String description;
    }

    public class externalConsumerData{
		public String customerSourceReferenceNumber;
		public String customerSourceCode;
		public String customerId;
    }
    
	public class application{
        public String applicationNumber;
        public String applicationType;
        public String channelCode;
        public String corpCode;
        public String lockVersionId;
        public creditStatus creditStatus;
        public String marketingSiteId;
        public String productGroupId;
        public String statusGroup;		
        public String transactionType;
        public externalConsumerData externalConsumerData;
		public knockOutQuestions knockOutQuestions;
        public quote quote;
        public primaryApplicant primaryApplicant;        
    }
    
    public static CCApplicationService_QteAccept_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_QteAccept_Req_IB_v1 requestBean =  new CCApplicationService_QteAccept_Req_IB_v1();
        
        requestBean.apply = new CCApplicationService_QteAccept_Req_IB_v1.apply();
        
        requestBean.apply.arg0 = new CCApplicationService_QteAccept_Req_IB_v1.Arg0();

        requestBean.apply.arg0.requestCommons = new CCApplicationService_QteAccept_Req_IB_v1.RequestCommons();   
        
		requestBean.apply.arg0.application = new CCApplicationService_QteAccept_Req_IB_v1.Application();
		
		requestBean.apply.arg0.application.creditStatus = new CCApplicationService_QteAccept_Req_IB_v1.creditStatus();
        
        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_QteAccept_Req_IB_v1.ExternalConsumerData();
        
        requestBean.apply.arg0.application.knockOutQuestions = new CCApplicationService_QteAccept_Req_IB_v1.KnockOutQuestions();

        requestBean.apply.arg0.application.quote = new CCApplicationService_QteAccept_Req_IB_v1.quote();

        requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_QteAccept_Req_IB_v1.primaryApplicant();

		return requestBean;
	}

	public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}

	public static CCApplicationService_QteAccept_Req_IB_v1 createDummyRequest(){
		CCApplicationService_QteAccept_Req_IB_v1 requestBean = CCApplicationService_QteAccept_Req_IB_v1.getNewInstance();

		requestBean.apply.arg0.application.applicationNumber = '';
        requestBean.apply.arg0.application.applicationType = 'P';        
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.creditStatus.id = '';        
        requestBean.apply.arg0.application.creditStatus.description = '';        
        requestBean.apply.arg0.application.lockVersionId = '';
        requestBean.apply.arg0.application.productGroupId = '1';        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = '';

        requestBean.apply.arg0.application.quote.cardProdSubProdGroupId = '';
        requestBean.apply.arg0.application.quote.creditLifeRequired = '';
        requestBean.apply.arg0.application.quote.creditLimit = '';
        requestBean.apply.arg0.application.quote.decision = '';
        requestBean.apply.arg0.application.quote.emailOrFaxInfo = '';
        requestBean.apply.arg0.application.quote.linkedAccountNumberSelected = '';
        requestBean.apply.arg0.application.quote.z_number = '';
        requestBean.apply.arg0.application.quote.numberOfQuotesIssued = '';
        requestBean.apply.arg0.application.quote.statusCode = '';
        		
		requestBean.apply.arg0.application.externalConsumerData.customerId = '9407229216088';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'ABSA';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = 'This is a test3';
        
		requestBean.apply.arg0.requestCommons.channelCode = 'B';
		requestBean.apply.arg0.requestCommons.employeeNumber = '9019050';
		requestBean.apply.arg0.requestCommons.messageLanguage ='E';
		requestBean.apply.arg0.requestCommons.siteId = '4592';
		requestBean.apply.arg0.requestCommons.systemName = 'BSF';
		requestBean.apply.arg0.requestCommons.userId ='ABAJ013';

		requestBean.apply.arg0.validateDetails ='true';

		return requestBean;
	}
}