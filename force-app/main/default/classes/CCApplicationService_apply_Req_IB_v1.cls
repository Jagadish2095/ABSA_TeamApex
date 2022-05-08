/*
 * Request Integration Bean for CCApplicationService apply
 * @author Rajani Bommasani
 * @created 2020-10-07
 */

public class CCApplicationService_apply_Req_IB_v1 extends Base_IB
{
	public apply apply;
	public class workTelephoneNumber{
		public String areaCode;
		public String z_number; // in json: number
		public String countryCode;
		public String extension;		
	}
	public class workFaxNumber{
		public String areaCode;
		public String z_number; // in json: number
		public String countryCode;
		public String extension;		
	}
	public class streetAddress{
		public String addressLine2;
		public String addressLine1;
		public String city;
		public String suburb;
		public String country;
		public String postalCode;		
	}
	public class statementDeliveryMethodSelected{
		public String code;
		public String description;
	}
	public class secondaryApplicants{
		public String dateOfBirth;
		public expense expense;
		public familyStatus familyStatus;
		public String employmentSector;
		public financialAccountInfo financialAccountInfo;
		public employer employer;
		public String financialInformationSuppliedCorrect;
		public String emailAddress;
		public String firstNames;
		public String datePermitExpires;
		public String gender;
		public String customerType;
		public String hasSocialGrant;
		public String countryPassportIssued;
		public homeFaxNumber homeFaxNumber;
		public String communicationLanguage;
		public String homeLanguage;
		public String clientCode;
		public homeTelephoneNumber homeTelephoneNumber;
		public String cifUpdateAllowed;
		public String idIssuedDate;
		public cellPhoneNumber cellPhoneNumber;
		public String idOrRegistrationNo;
		public casaInformation casaInformation;
		public String identificationType;
		public list<cards> cards;
		public income income;
		public cardTypeSelected cardTypeSelected;
		public String incomeTaxNumber;
		public cardCollection cardCollection;
		public String initials;
		public String preferredCommunicationChannel;
		public preAssessed preAssessed;
		public qualification qualification;
		public String practiceNumber;
		public postalAddress postalAddress;
		public String placeOfResidence;
		public residentialAddress residentialAddress;
		public String passportNationality;
		public String residentialStatus;
		public String occupationStatus;
		public String shareInfoWithCreditProviders;
		public String occupationLevel;
		public String sourceOfIncome;
		public String occupationCode;
		public String sourceOfFunds;
		public nextOfKin nextOfKin;
		public String surname;
		public String mayReceiveMarketingViaTelephone;
		public String tempPermitNumber;
		public String mayReceiveMarketingViaSMS;
		public String titleType;
		public String mayReceiveMarketingViaPost;
		public workFaxNumber workFaxNumber;
		public String mayReceiveMarketingViaEmail;
		public workTelephoneNumber workTelephoneNumber;
		public String mayCheckCreditWorthiness;
		public String cardProdSubProdGroupId;
		public String marketingConsentGiven;
		public String countryOfBirth;
		public linkedAccounts linkedAccounts;
		public cardDetails cardDetails;
		public String isInBusinessRescueAffectedParty;
	}
	public class residentialAddress{
		public String addressLine1;
		public String addressLine2;
		public String city;
		public String suburb;
		public String country;
		public String postalCode;
	}
	public class requestCommons{
		public String channelCode;
		public String employeeNumber;
		public String messageLanguage;
		public String systemName;
		public String userId;
		public String siteId;
	}
	public class rehabilitation{
		public String rehabilitationDate;
		public String everBeenDeclaredInsolvent;
		public String everUndergoneDebtCounselling;
		public String debtCounsellingClearanceDate;
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
	public class qualification{
		public String hasPostMatricQualification;
		public String qualificationType;
	}
	public class productInformation{
		public String principalBankCorpCode;
		public linkedAccountsAllowed linkedAccountsAllowed;
		public String lowValuePaymentAllowed;
		public String linkedAccountRequired;
		public String maximumCreditLimit;
		public String isStaff;
		public String minimumCreditLimit;
		public String garageCardAllowed;
		public pinOptionTypeAllowed pinOptionTypeAllowed;
		public String electronicStatementDeliveryAllowed;
		public String productFamilyId;
		public debitOrderTypeAllowed debitOrderTypeAllowed;
		public String productGroupDescription;
		public String creditLifeOffered;
		public String productId;
		public String creditLifeMaxAge;
		public String productgroupId;
		public String cardProductOrder;
		public String secondariesAllowed;
		public String cardProductDescription;
		public String sourceId;
		public String cardProdSubProdGroupId;
		public String subProductGroupDescription;
		public cardCollectionMethodsAllowed cardCollectionMethodsAllowed;
		public String subProductgroupId;
		public String accountType;
	}
	public class primaryApplicant{
		public residentialAddress residentialAddress;
		public String mayReceiveMarketingViaSMS;
		public String mayReceiveMarketingViaTelephone;
		public String mayReceiveMarketingViaPost;
		public nextOfKin nextOfKin;
		public String mayReceiveMarketingViaEmail;
		public String occupationCode;
		public String mayCheckCreditWorthiness;
		public String occupationLevel;
		public String marketingConsentGiven;
		public String occupationStatus;
		public linkedAccounts linkedAccounts;
		public String passportNationality;
		public String isInBusinessRescueAffectedParty;
		public String placeOfResidence;
		public String initials;
		public String practiceNumber;
		public String homeLanguage;
		public homeFaxNumber homeFaxNumber;
		public homeTelephoneNumber homeTelephoneNumber;
		public String hasSocialGrant;
		public String idIssuedDate;
		public String gender;
		public String idOrRegistrationNo;
		public String firstNames;
		public String identificationType;
		public String financialInformationSuppliedCorrect;
		public income income;
		public financialAccountInfo financialAccountInfo;
		public String incomeTaxNumber;
		public familyStatus familyStatus;
		public postalAddress postalAddress;
		public expense expense;
		public preAssessed preAssessed;
		public String employmentSector;
		public String preferredCommunicationChannel;
		public employer employer;
		public qualification qualification;
		public String emailAddress;
		public String residentialStatus;
		public String datePermitExpires;
		public String shareInfoWithCreditProviders;
		public String dateOfBirth;
		public String sourceOfIncome;
		public String customerType;
		public String sourceOfFunds;
		public String countryPassportIssued;
		public String surname;
		public String communicationLanguage;
		public String tempPermitNumber;
		public String clientCode;
		public String titleType;
		public String cifUpdateAllowed;
		public workFaxNumber workFaxNumber;
		public cellPhoneNumber cellPhoneNumber;
		public workTelephoneNumber workTelephoneNumber;
		public casaInformation casaInformation;
		public String cardProdSubProdGroupId;
		public list<cards> cards;
		public String countryOfBirth;
		public cardTypeSelected cardTypeSelected;
		public cardDetails cardDetails;
		public cardCollection cardCollection;
	}
	public class preAssessed{
		public String preAmrDisposableIncome;		
		public String preAssessedCreditLimit;
		public String preTmrNettIncome;
		public String preAssessedCreditLimitAccepted;
		public String preAssessedTotalLivingExpenses;
		public String preAssessedGrossIncome;
		public String preAssessedMaintanance;
		public String preAssessedGrossIncomeAccepted;		
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
	public class otherIncome{
		public String description;
		public String amount;
	}
	public class otherFixedDebtExpense{
		public String amount;
		public String description;
	}
	public class otherExpense{
		public String amount;
		public String description;
	}
	public class nextOfKin{
		public String fullNames;
		public String emailAddress;
		public String titleType;
		public workTelephoneNumber workTelephoneNumber;
		public String surname;
		public homeTelephoneNumber homeTelephoneNumber;
		public cellPhoneNumber cellPhoneNumber;
		public String relationship;
		
	}
	public class mandateDetails{
		public String refferedDocType;
		public String contractRef;
		public String clientRef;
		public String macCode;
		public String authType;
	}
	public class linkedAccountSelected{
		public String productDescription;
		public accountType accountType;
		public String productCode;
		public String accountNumber;
	}
	public class linkedAccountsAllowed{
		public String accountNumber;
		public String productCode;
		public String productDescription;
		public accountType accountType;
	}
	public class linkedAccounts{
		public accountType accountType;
		public String accountNumber;		
		public String productDescription;
		public String productCode;		
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
	public class income{		
		public String disposableMonthlyIncome;
		public String grossMonthlyIncome;
		public otherIncome otherIncome;
		public String grossMonthlySalary;
		public String nettMonthlyIncome;		
	}
	public class homeTelephoneNumber{
		public String areaCode;	
		public String countryCode;	
		public String extension;		
		public String z_number;	// in json : number
	}
	public class homeFaxNumber{
		public String z_number; // in json: number
		public String extension;
		public String countryCode;		
		public String areaCode;	
	}
	public class financialAccountInfo{
		public String accountNumber;
		public String salaryAccountType;
		public String accountHolderName;
		public String otherBankInstitutionName;
		public String bankInstitutionName;
	}
	public class familyStatus{
		public String maritalContractType;
		public String maritalStatus;
		public String numberOfDependents;
	}
	public class externalConsumerData{
		public String customerSourceReferenceNumber;
		public String customerSourceCode;
		public String customerId;
	}
	public class expense{
		public String rent;
		public String bondInstalmentOrRent;
		public String creditCardInstalment;
		public String vehicleInstalment;
		public String household;
		public String transport;
		public String insuranceOrFuneralPolicy;
		public String totalLivingExpense;
		public String jointDebt;
		public String totalFixedDebtExpense;
		public String maintenance;
		public String schoolOrUniversityFee;
		public otherExpense otherExpense;
		public String personalLoanInstalment;
		public otherFixedDebtExpense otherFixedDebtExpense;				
	}
	public class employer{
		public String name;
		public address address;
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
	public class consents{
		public String noticeDelivery;
		public String deaConsent;
	}
	public class cellPhoneNumber{

		public String areaCode;
		public String countryCode;
		public String z_number;	// in json: number	
		public String extension;
	}

	public class casaInformation{
		public String nationality;
		public String countryOfResidence;		
		public String versionNumber;
		public String referenceNumber;
		public String riskRating;
	}

	public class cardTypeSelected{
		public String description;
		public String id;
	}
	public class cards{
		public String id;
		public String description;		
	}
	public class cardDetails{
		public String plasticNumber;
		public String accountNo;
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
	public class cardCollectionMethodsAllowed{
		public String id;
		public String description;
		public String courierCollectionFee;
	}
	public class cardCollectionMethod{
		public String courierCollectionFee;
		public String id;
		public String description;
	}
	public class cardCollection{
		public cardCollectionMethod cardCollectionMethod;
		public cardCollectionSite cardCollectionSite;
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
		public String lockVersionId;
		public String hasAcceptedCourierCollectionFee;
		public String hasAcceptedSpecifiedCreditLimit;
		public externalConsumerData externalConsumerData;
		public knockOutQuestions knockOutQuestions;
		public String electronicStatementEmailAddress2;
		public linkedAccountSelected linkedAccountSelected;
		public String electronicStatementEmailAddress1;
		public String lowValuePaymentRequired;
		public String declineReasonCode;
		public String marketingSiteId;
		public String declineLetterDescription;
		public String numberOfSecondaryApplicantsRequested;
		public debitOrderDetails debitOrderDetails;
		public String packageId;
		public String dateCreated;
		public String personWhoCreatedApplication;
		public creditStatus creditStatus;
		public pinOptionSelected pinOptionSelected;
		public String creditLimitSelected;
		public String pricingSchemeCode;
		public String creditLimitApproved;
		public primaryApplicant primaryApplicant;
		public String creditLifeRequired;
		public String productAwareness;
		public String corpCode;
		public String productGroupId;
		public consents consents;
		public productInformation productInformation;
		public String channelCode;
		public quote quote;
		public String cardProdSubProdGroupId;
		public secondaryApplicants secondaryApplicants;
		public String cardAccountPaymentMethod;
		public String srmNumber;
		public String campaignId;
		public statementDeliveryMethodSelected statementDeliveryMethodSelected;
		public String applicationType;
		public String statusGroup;
		public String applicationNumber;
		public String transactionType;
		public String annualCreditLimitIncreases;
	}
	public class address{
		public String city;
		public String addressLine1;
		public String addressLine2;
		public String suburb;
		public String postalCode;
		public String country;

	}
	public class accountType{
		public String description;
		public String code;
	}

	public static CCApplicationService_apply_Req_IB_v1 createDummyRequest(){
	CCApplicationService_apply_Req_IB_v1 requestBean = new CCApplicationService_apply_Req_IB_v1();
	requestBean.apply = new CCApplicationService_apply_Req_IB_v1.apply();
	//requestBean.apply.arg0 = new CCApplicationService_apply_Req_IB_v1.apply.arg0();
	requestBean.apply.arg0 = new CCApplicationService_apply_Req_IB_v1.arg0();
	//requestBean.apply.arg0.application = new CCApplicationService_apply_Req_IB_v1.apply.arg0.application();
	requestBean.apply.arg0.application = new CCApplicationService_apply_Req_IB_v1.application();
	//requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_apply_Req_IB_v1.apply.arg0.application.externalConsumerData();
	requestBean.apply.arg0.application.externalConsumerData = new CCApplicationService_apply_Req_IB_v1.externalConsumerData();
	//requestBean.apply.arg0.application.knockOutQuestions = new CCApplicationService_apply_Req_IB_v1.apply.arg0.application.knockOutQuestions();
	requestBean.apply.arg0.application.knockOutQuestions = new CCApplicationService_apply_Req_IB_v1.knockOutQuestions();
	//requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_apply_Req_IB_v1.apply.arg0.application.primaryApplicant(); 
	requestBean.apply.arg0.application.primaryApplicant = new CCApplicationService_apply_Req_IB_v1.primaryApplicant(); 
	//requestBean.apply.arg0.application.primaryApplicant.cellPhoneNumber = new CCApplicationService_apply_Req_IB_v1.apply.arg0.application.primaryApplicant.cellPhoneNumber() ;
	requestBean.apply.arg0.application.primaryApplicant.cellPhoneNumber = new CCApplicationService_apply_Req_IB_v1.cellPhoneNumber() ;
	//requestBean.apply.arg0.requestCommons = new CCApplicationService_apply_Req_IB_v1.apply.arg0.requestCommons();
	requestBean.apply.arg0.requestCommons = new CCApplicationService_apply_Req_IB_v1.requestCommons();
   
      
   requestBean.apply.arg0.application.statementDeliveryMethodSelected = new CCApplicationService_apply_Req_IB_v1.statementDeliveryMethodSelected();
   requestBean.apply.arg0.application.primaryApplicant.nextOfKin = new CCApplicationService_apply_Req_IB_v1.nextOfKin();
   requestBean.apply.arg0.application.primaryApplicant.nextOfKin.cellPhoneNumber = new CCApplicationService_apply_Req_IB_v1.cellPhoneNumber();
   requestBean.apply.arg0.application.primaryApplicant.familyStatus = new CCApplicationService_apply_Req_IB_v1.familyStatus();
   requestBean.apply.arg0.application.primaryApplicant.residentialAddress = new CCApplicationService_apply_Req_IB_v1.residentialAddress();

	requestBean.apply.arg0.application.applicationNumber = '';	
	requestBean.apply.arg0.application.applicationType = 'P';
	requestBean.apply.arg0.application.campaignId = '';	
	requestBean.apply.arg0.application.channelCode = 'B';
	requestBean.apply.arg0.application.corpCode = 'ABSA';
	//requestBean.apply.arg0.application.creditStatus = '';	
	//requestBean.apply.arg0.application.customerType = '001';

	
	requestBean.apply.arg0.application.externalConsumerData.customerId = '9407229216088';
	requestBean.apply.arg0.application.externalConsumerData.customerSourceCode = 'ABSA';
	requestBean.apply.arg0.application.externalConsumerData.customerSourceReferenceNumber = 'This is a test3';
   
    requestBean.apply.arg0.application.primaryApplicant.gender = '01';

	requestBean.apply.arg0.application.knockOutQuestions.curatorship = 'true';
	requestBean.apply.arg0.application.knockOutQuestions.casaClauseRead = 'true';
	
	requestBean.apply.arg0.application.marketingSiteId = '4592';
	requestBean.apply.arg0.application.productGroupId = '1';
	requestBean.apply.arg0.application.transactionType = '';
	
	requestBean.apply.arg0.application.primaryApplicant.firstNames = 'FABIAN GERONE';
	requestBean.apply.arg0.application.primaryApplicant.idOrRegistrationNo ='9407229216088';
	requestBean.apply.arg0.application.primaryApplicant.identificationType = '01';
	requestBean.apply.arg0.application.primaryApplicant.initials = 'FG';
	requestBean.apply.arg0.application.primaryApplicant.titleType = '01';
	requestBean.apply.arg0.application.primaryApplicant.surname = 'PALADI';
	requestBean.apply.arg0.application.primaryApplicant.placeOfResidence = '01';

	requestBean.apply.arg0.application.primaryApplicant.cellPhoneNumber.z_number =  '0725845698';

	requestBean.apply.arg0.requestCommons.channelCode = 'B';
	requestBean.apply.arg0.requestCommons.employeeNumber = '9019050';
	requestBean.apply.arg0.requestCommons.messageLanguage ='E';
	requestBean.apply.arg0.requestCommons.siteId = '4592';
	requestBean.apply.arg0.requestCommons.systemName = 'BSF';
	requestBean.apply.arg0.requestCommons.userId ='ABAJ013';

	requestBean.apply.arg0.validateDetails ='true';

	return requestBean;
	}

	public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}
   
   public override void setIntegrationTranslations()
   {
    integrationTranslationsMap = new Map<String, String>();
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.preferredCommunicationChannel','CIF;Preferred Communication Method' );
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.countryOfBirth','CIF;Country' );
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.casaInformation.nationality','CIF;Country' );
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.communicationLanguage','CIF;Language' );
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.homeLanguage','CIF;Language' );
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.gender','CIF;Gender' ); 
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.identificationType','CIF;Identity Type' ); 
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.familyStatus.maritalStatus','CIF;Marital Status' );
	integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.familyStatus.maritalContractType','CIF;Marital Contract Type' ); 
    integrationTranslationsMap.put('apply.arg0.application.primaryApplicant.nextOfKin.relationship','CIF;Relationship' );
   }
}