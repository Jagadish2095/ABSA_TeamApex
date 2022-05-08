/*
 * Request Integration Bean for CCApplicationService InitiateDebiCheck
 * @author Aaron Castelyn : Absa
 * @created 2021-01-26 
 */

public class CCApplicationService_DebiCheck_Req_IB_v1  extends Base_IB {
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
    
    public class accountType{
		public String description;
		public String code;
    }
    
    public class creditStatus{
		public String id;
		public String description;
    }

    public class creditorDetails{
		public String mandCredAccountID;
		public String mandCredName;
		public String mandCredBranch;
		public String mandUltCredName;
		public String mandUltCredShortName;
    }
    
    public class mandateDetails{
		public String refferedDocType;
		public String contractRef;
		public String clientRef;
		public String macCode;
		public String authType;
    }
    
    public class debtorDetails{
		public String ownAccount;
		public String idOrRegistrationNo;
		public String idtype;
		public String debtorPhone;
		public String ultDebtorName;
		public String debtorEmail;
    }
    
	public class debitOrderTypeAllowed{
		public String description;
		public String id;
    }
    
	public class debitOrderType{
		public String id;
		public String description;
    }
    
	public class debitOrderDetails{
		public mandateDetails mandateDetails;
		public String payPerDC;
		public String paymentAmount;
		public String otherBankInstitutionName;
		public String paymentDay;
		public debtorDetails debtorDetails;
		public paymentDetails paymentDetails;
		public debitOrderType debitOrderType;
		public String branchCode;
		public String bankInstitutionName;
		public String branchName;
		public accountType accountType;
		public String accountHolderName;
		public String accountNumber;
		public creditorDetails creditorDetails;
	}

    public class paymentDetails{
		public String RMSDoSubtyp;
		public String RMSCustFxdAmt;
		public String RMSCollStDate;
		public String supllAdjCategory;
		public String mandTrackingInd;
		public String supplAdjAmount;
		public String mandMaxAmount;
		public String supplAdjRate;
		public String mandInstalcollAmount;
		public String supplDtValueTyp;
		public String mandFrequencyTyp;
		public String supplDteAdjRuleInd;
		public String instalmentOccurrence;
		public String supplFirstCollAmount;
		public String firstCollDate;
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
        public debitOrderDetails debitOrderDetails;
        public String marketingSiteId;
        public String productGroupId;
        public String statusGroup;		
        public String transactionType;
        public externalConsumerData externalConsumerData;		
        public quote quote;
        public primaryApplicant primaryApplicant;        
    }
    
    public static CCApplicationService_DebiCheck_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_DebiCheck_Req_IB_v1 requestBean =  new CCApplicationService_DebiCheck_Req_IB_v1();
        
        requestBean.apply = new CCApplicationService_DebiCheck_Req_IB_v1.apply();
        
        requestBean.apply.arg0 = new CCApplicationService_DebiCheck_Req_IB_v1.Arg0();

        requestBean.apply.arg0.requestCommons = new CCApplicationService_DebiCheck_Req_IB_v1.RequestCommons();   
        
		requestBean.apply.arg0.application = new CCApplicationService_DebiCheck_Req_IB_v1.Application();
		
		requestBean.apply.arg0.application.creditStatus = new CCApplicationService_DebiCheck_Req_IB_v1.creditStatus();

		requestBean.apply.arg0.application.debitOrderDetails = new CCApplicationService_DebiCheck_Req_IB_v1.debitOrderDetails();
        
        requestBean.apply.arg0.application.debitOrderDetails.mandateDetails = new CCApplicationService_DebiCheck_Req_IB_v1.mandateDetails();
		
        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_DebiCheck_Req_IB_v1.ExternalConsumerData();
        
        requestBean.apply.arg0.application.quote = new CCApplicationService_DebiCheck_Req_IB_v1.quote();

        requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_DebiCheck_Req_IB_v1.primaryApplicant();

		return requestBean;
	}

	public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}

	public override void setIntegrationTranslations()
   	{
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('apply.arg0.application.debitOrderDetails.mandateDetails.authType','CIFCodesList;Authenticationtypecode' );
   	}

	public static CCApplicationService_DebiCheck_Req_IB_v1 createDummyRequest(){
		CCApplicationService_DebiCheck_Req_IB_v1 requestBean = CCApplicationService_DebiCheck_Req_IB_v1.getNewInstance();

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