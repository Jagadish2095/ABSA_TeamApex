/*
 * Request Integration Bean for CCApplicationService applyComplete2
 * @author Aaron Castelyn : Absa
 * @created 2020-12-17 
 */

public class CCApplicationService_Complete2_Req_IB_v1 extends Base_IB {
    public apply apply;
	
	public class requestCommons{
		public String channelCode;
		public String employeeNumber;
		public String messageLanguage;
		public String systemName;
		public String userId;
		public String siteId;
	}
	
	public class primaryApplicant{
		public String clientCode;		        
        public cardCollection cardCollection;
        public cardTypeSelected cardTypeSelected;        
        public postalAddress deliveryAddress;
        public casaInformation casaInformation;
        public financialAccountInfo financialAccountInfo;		
    }
    
	public class postalAddress{
		public String addressLine1;	
		public String addressLine2;
		public String suburb;
		public String city;
		public String postalCode;
		public String country;	
    }
    
	public class pinOptionTypeAllowed{
		public String id;
		public String description;
	}
	public class pinOptionSelected{
		public String description;
		public String id;
	}
	public class paymentType{
		public String code;
		public String description;
	}
	
	public class mandateDetails{
		public String refferedDocType;
		public String contractRef;
		public String clientRef;
		public String macCode;
		public String authType;
	}
	
	public class knockOutQuestions{
		public String registeredForeingTax;
		public String monthlyGrossIncomeAboveMin;
		public String declaredInsolvent;
		public String olderThan18Years;
		public String debitOrderByPass;
		public String pendingDebtCounselling;
		public String currentlyUnderDebtCounselling;
		public String permanentSAResident;
		public String curatorship;
		public rehabilitation rehabilitation;
		public String creditLifeTermsAndConditionsRead;
		public String spouseConsent;
		public String creditBureauConsent;
		public String termsAndConditionsRead;
		public String casaClauseRead;
		public String absaRewards;
	}
    
    public class rehabilitation{
		public String rehabilitationDate;
		public String everBeenDeclaredInsolvent;
		public String everUndergoneDebtCounselling;
		public String debtCounsellingClearanceDate;
	}

	public class financialAccountInfo{
		public String accountNumber;
		public String salaryAccountType;
        public String branchName;
        public String branchCode;
		public String otherBankInstitutionName;
		public String bankInstitutionName;
	}
	
	public class externalConsumerData{
		public String customerSourceReferenceNumber;
		public String customerSourceCode;
		public String customerId;
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
		public debitOrderType debitOrderType;
		public String branchCode;
		public String bankInstitutionName;
		public String branchName;
		public accountType accountType;
		public String accountHolderName;
        public String accountNumber;
        public paymentType paymentType;
    }
    
	public class creditStatus{
		public String id;
		public String description;
    }
    
	public class casaInformation{
		public String nationality;
		public String countryOfResidence;		
		public String versionNumber;
		public String referenceNumber;
		public String riskRating;
	}
    
	public class cardCollection{
		public cardCollectionMethod cardCollectionMethod;
		public cardCollectionSite cardCollectionSite;
	}

    public class cardCollectionMethod{
		public String courierCollectionFee;
		public String id;
		public String description;
	}

    public class cardCollectionSite{
		public streetAddress streetAddress;
		public String nameLong;
		public String id;
		public String nameShort;
		public String type;
		public String status;
		public String subType;
	}

	public class cardTypeSelected{
		public String description;
		public String id;
    }
    
    public class streetAddress{
		public String addressLine2;
		public String addressLine1;
		public String city;
		public String suburb;
		public String country;
		public String postalCode;		
	}

	public class arg0{
		public application application;
		public String validateDetails;
		public requestCommons requestCommons;
    }
    
	public class apply{
		public arg0 arg0;
    }
    
	public class application{
        public String applicationNumber;
        public String applicationType;
        public String channelCode;
        public String corpCode;
        public creditStatus creditStatus;
		public pinOptionSelected pinOptionSelected;
        public externalConsumerData externalConsumerData;
        public String marketingSiteId;
        public String productGroupId;
        public String statusGroup;		
        public String transactionType;
        public String lockVersionId;
        public String cardProdSubProdGroupId;
        public String creditLimitApproved;
		public String creditLimitSelected;		
        public String hasAcceptedSpecifiedCreditLimit;
        public debitOrderDetails debitOrderDetails;
        public knockOutQuestions knockOutQuestions;
        public primaryApplicant primaryApplicant;
    }
    
	public class accountType{
		public String description;
		public String code;
    }
    
    public static CCApplicationService_Complete2_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_Complete2_Req_IB_v1 requestBean =  new CCApplicationService_Complete2_Req_IB_v1();
        
        requestBean.apply = new CCApplicationService_Complete2_Req_IB_v1.apply();
        
        requestBean.apply.arg0 = new CCApplicationService_Complete2_Req_IB_v1.Arg0();
        requestBean.apply.arg0.requestCommons = new CCApplicationService_Complete2_Req_IB_v1.RequestCommons();   
        
        requestBean.apply.arg0.application = new CCApplicationService_Complete2_Req_IB_v1.Application();
		
		requestBean.apply.arg0.application.creditStatus = new CCApplicationService_Complete2_Req_IB_v1.creditStatus();

        requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_Complete2_Req_IB_v1.ExternalConsumerData();
        
        requestBean.apply.arg0.application.knockOutQuestions = new CCApplicationService_Complete2_Req_IB_v1.KnockOutQuestions();

		requestBean.apply.arg0.application.debitOrderDetails = new CCApplicationService_Complete2_Req_IB_v1.debitOrderDetails();
		
		requestBean.apply.arg0.application.debitOrderDetails.mandateDetails = new CCApplicationService_Complete2_Req_IB_v1.mandateDetails();

		requestBean.apply.arg0.application.debitOrderDetails.debtorDetails = new CCApplicationService_Complete2_Req_IB_v1.debtorDetails();

		requestBean.apply.arg0.application.debitOrderDetails.debitOrderType = new CCApplicationService_Complete2_Req_IB_v1.debitOrderType();

		requestBean.apply.arg0.application.debitOrderDetails.accountType = new CCApplicationService_Complete2_Req_IB_v1.accountType();

		requestBean.apply.arg0.application.debitOrderDetails.paymentType = new CCApplicationService_Complete2_Req_IB_v1.paymentType();
		
        requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_Complete2_Req_IB_v1.primaryApplicant();

        requestBean.apply.arg0.application.primaryApplicant.cardCollection = new CCApplicationService_Complete2_Req_IB_v1.cardCollection();

        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod = new CCApplicationService_Complete2_Req_IB_v1.cardCollectionMethod();

		requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite = new CCApplicationService_Complete2_Req_IB_v1.cardCollectionSite();
		
		requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress = new CCApplicationService_Complete2_Req_IB_v1.streetAddress();

        requestBean.apply.arg0.application.primaryApplicant.cardTypeSelected = new CCApplicationService_Complete2_Req_IB_v1.cardTypeSelected();

        requestBean.apply.arg0.application.primaryApplicant.deliveryAddress = new CCApplicationService_Complete2_Req_IB_v1.postalAddress();

        requestBean.apply.arg0.application.primaryApplicant.casaInformation = new CCApplicationService_Complete2_Req_IB_v1.casaInformation();

        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo = new CCApplicationService_Complete2_Req_IB_v1.financialAccountInfo();

		return requestBean;
	}

	public override void setIntegrationTranslations()
   {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('apply.arg0.application.debitOrderDetails.accountType.code','CIFCodesList;Ccacqaccounttype' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod.id','CIFCodesList;Collection Method' );		
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.country','CIFCodesList;Casa Country' );		
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.casaInformation.riskRating','eCasa;Risk Rating' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.casaInformation.countryOfResidence','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.casaInformation.nationality','CIFCodesList;Nationality' );
		integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.deliveryAddress.country','CIFCodesList;Casa Country' );
   }

	public static CCApplicationService_Complete2_Req_IB_v1 createDummyRequest(){
		CCApplicationService_Complete2_Req_IB_v1 requestBean = CCApplicationService_Complete2_Req_IB_v1.getNewInstance();

		requestBean.apply.arg0.application.applicationNumber = '';
        requestBean.apply.arg0.application.applicationType = 'P';        
        requestBean.apply.arg0.application.channelCode = 'B';
        requestBean.apply.arg0.application.corpCode = 'ABSA';
        requestBean.apply.arg0.application.creditStatus.id = '';
        requestBean.apply.arg0.application.creditStatus.description = '';                
        requestBean.apply.arg0.application.lockVersionId = '';
        requestBean.apply.arg0.application.productGroupId = '1';
        requestBean.apply.arg0.application.cardProdSubProdGroupId = '';        
        requestBean.apply.arg0.application.statusGroup = '';        
        requestBean.apply.arg0.application.transactionType = '';
        requestBean.apply.arg0.application.marketingSiteId = '';        
        requestBean.apply.arg0.application.hasAcceptedSpecifiedCreditLimit = 'true';

        requestBean.apply.arg0.application.debitOrderDetails.accountHolderName = 'T MAKWANI';
        requestBean.apply.arg0.application.debitOrderDetails.accountNumber = '1727756957';
        requestBean.apply.arg0.application.debitOrderDetails.accountType.code = 'C';
        requestBean.apply.arg0.application.debitOrderDetails.accountType.description = 'Cheque Account';

        requestBean.apply.arg0.application.debitOrderDetails.bankInstitutionName = 'other';
        requestBean.apply.arg0.application.debitOrderDetails.branchCode = '470010';
        requestBean.apply.arg0.application.debitOrderDetails.branchName = '';

        requestBean.apply.arg0.application.debitOrderDetails.debitOrderType.description = 'Minimum Amount';
        requestBean.apply.arg0.application.debitOrderDetails.debitOrderType.id = 'M';

        requestBean.apply.arg0.application.debitOrderDetails.otherBankInstitutionName = 'Capitec';

        requestBean.apply.arg0.application.debitOrderDetails.paymentAmount = '';
        requestBean.apply.arg0.application.debitOrderDetails.paymentType.code = 'M';
        requestBean.apply.arg0.application.debitOrderDetails.paymentType.description = 'Maximum Amount';
        requestBean.apply.arg0.application.debitOrderDetails.paymentDay = '4';
        requestBean.apply.arg0.application.debitOrderDetails.payPerDC = 'Y';

        requestBean.apply.arg0.application.primaryApplicant.clientCode = '';

        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod.courierCollectionFee = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod.description = '';        
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionMethod.id = 'B';

        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.id = '8114';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.nameLong = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.nameShort = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.status = '';

        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.addressLine1 = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.addressLine2 = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.city = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.country = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.postalCode = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.streetAddress.suburb = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.subType = '';
        requestBean.apply.arg0.application.primaryApplicant.cardCollection.cardCollectionSite.type = '';

        requestBean.apply.arg0.application.primaryApplicant.cardTypeSelected.description = '';
        requestBean.apply.arg0.application.primaryApplicant.cardTypeSelected.id = 'C';

        requestBean.apply.arg0.application.primaryApplicant.casaInformation.countryOfResidence =  '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.nationality = '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.referenceNumber = '';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.versionNumber = '2';
        requestBean.apply.arg0.application.primaryApplicant.casaInformation.riskRating = 'M';

        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.accountNumber = '4083445601';
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.branchName = '';
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.branchCode = '250655';
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.bankInstitutionName = 'FNB';
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.otherBankInstitutionName = '';
        requestBean.apply.arg0.application.primaryApplicant.financialAccountInfo.salaryAccountType = 'C';

        requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.addressLine1 = '';
        requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.addressLine2 = '';
        requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.suburb = '';
        requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.city = '';
        requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.postalCode = '';
        requestBean.apply.arg0.application.primaryApplicant.deliveryAddress.country = '';
        		
		requestBean.apply.arg0.application.externalConsumerData.customerId = '9407229216088';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'ABSA';
		requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = 'This is a test3';
        
        requestBean.apply.arg0.application.knockOutQuestions.registeredForeingTax = 'false';
		
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