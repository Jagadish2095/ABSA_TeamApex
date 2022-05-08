/*
 * Request Integration Bean for CCApplicationService Instance Account Opening
 * @author Aaron Castelyn : Absa
 * @created 2021-01-19 
 */

public class CCApplicationService_InstAcc_Req_IB_v1 extends Base_IB {
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
	}
	
	public class primaryApplicant{
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
        public quote quote;
        public primaryApplicant primaryApplicant;        
    }
    
    public static CCApplicationService_InstAcc_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_InstAcc_Req_IB_v1 requestBean =  new CCApplicationService_InstAcc_Req_IB_v1();
        
        requestBean.apply = new CCApplicationService_InstAcc_Req_IB_v1.apply();
        
        requestBean.apply.arg0 = new CCApplicationService_InstAcc_Req_IB_v1.Arg0();

        requestBean.apply.arg0.requestCommons = new CCApplicationService_InstAcc_Req_IB_v1.RequestCommons();   
        
		requestBean.apply.arg0.application = new CCApplicationService_InstAcc_Req_IB_v1.Application();
		
		requestBean.apply.arg0.application.creditStatus = new CCApplicationService_InstAcc_Req_IB_v1.creditStatus();
        
        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_InstAcc_Req_IB_v1.ExternalConsumerData();
        
        requestBean.apply.arg0.application.quote = new CCApplicationService_InstAcc_Req_IB_v1.quote();

        requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_InstAcc_Req_IB_v1.primaryApplicant();

		return requestBean;
	}

	public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}

	public static CCApplicationService_InstAcc_Req_IB_v1 createDummyRequest(){
		CCApplicationService_InstAcc_Req_IB_v1 requestBean = CCApplicationService_InstAcc_Req_IB_v1.getNewInstance();

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