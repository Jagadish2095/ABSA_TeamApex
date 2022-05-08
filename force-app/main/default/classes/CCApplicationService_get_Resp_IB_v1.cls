/**
 * @description CCApplicationService get response bean
 * @author Aaron Castelyn: ABSA
 * @created 2021-03-25 
 */
public without sharing class CCApplicationService_get_Resp_IB_v1  extends Base_IB {
	
	/**
	 * @description creditStatus
	 */
	public class creditStatus {
		public String description;
		public String id;
	}
	
	/**
	 * @description creditStatus
	 */
	public class knockOutQuestions {
		public String absaRewards; 
		public String casaClauseRead;
		public String creditBureauConsent;
		public String creditLifeTermsAndConditionsRead;
		public String curatorship;
		public String currentlyUnderDebtCounselling; 
		public String debitOrderByPass; 
		public String declaredInsolvent; 
		public String monthlyGrossincomeAboveMin; 
		public String olderThan18Years; 
		public String pendingDebtCounselling; 
		public String permanentSAResident; 
		public String registeredForeingTax; 
		public rehabilitation rehabilitation; 
		public String spouseConsent; 
		public String termsAndConditionsRead;
	}
	
	/**
	 * @description creditStatus
	 */
	public class cellPhoneNumber {
		public String countryCode; 
		public String extension; 
		public String z_number;
	}
	
	/**
	 * @description creditStatus
	 */
    public class homeTelephoneNumber{
		public String areaCode;	
		public String countryCode;	
		public String extension;		
		public String z_number;
	}
	
	/**
	 * @description homeFaxNumber
	 */
    public class homeFaxNumber{
		public String z_number;
		public String extension;
		public String countryCode;		
		public String areaCode;	
	}

	/**
	 * @description workTelephoneNumber
	 */
    public class workTelephoneNumber{
		public String areaCode;
		public String z_number;
		public String countryCode;
		public String extension;		
	}
	
	/**
	 * @description workFaxNumber
	 */
    public class workFaxNumber{
		public String areaCode;
		public String z_number;
		public String countryCode;
		public String extension;		
	}

	/**
	 * @description consents
	 */
	public class consents {
        public String noticeDelivery;
		public String deaConsent;
	}
	
	/**
	 * @description otherFixedDebtExpense
	 */
	public class otherFixedDebtExpense {
		public String amount; 
		public String description;
	}
	
	/**
	 * @description familyStatus
	 */
	public class familyStatus {
		public String maritalStatus; 
		public String numberOfDependents;
	}
	
	public getApplicationInformationResponse getApplicationInformationResponse; 

	/**
	 * @description address
	 */
	public class address {
		public String addressLine1; 
		public String city; 
		public String postalCode;
	}
	
	/**
	 * @description externalConsumerData
	 */
	public class externalConsumerData {
		public String customerId; 
		public String customerSourceCode; 
		public String customerSourceReferenceNumber;
	}
	
	/**
	 * @description income
	 */
	public class income {
		public String disposableMonthlyIncome; 
		public String grossMonthlyIncome; 
		public String grossMonthlySalary; 
		public String nettMonthlyIncome; 
		public otherFixedDebtExpense otherIncome; 
		public String rentalIncome;
	}
	
	/**
	 * @description preAssessed
	 */
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

	/**
	 * @description primaryApplicant
	 */
	public class primaryApplicant {
		public cardDetails cardDetails;
		public cardCollection cardCollection;
		public String cardProdSubProdGroupId; 
		public CasaInformation casaInformation; 
		public cellPhoneNumber cellPhoneNumber; 
		public String communicationLanguage; 
		public String countryOfBirth; 
		public String customerType; 
		public String dateOfBirth; 
		public postalAddress deliveryAddress; 
		public String emailAddress; 
		public employer employer; 
		public String employmentSector; 
		public expense expense; 
		public familyStatus familyStatus; 
		public String financialInformationSuppliedCorrect; 
		public String firstNames; 
		public String gender; 
		public String hasSocialGrant; 
		public homeFaxNumber homeFaxNumber; 
		public String homeLanguage; 
		public homeTelephoneNumber homeTelephoneNumber; 
		public String idOrRegistrationNo; 
		public String identificationType; 
		public income income; 
		public String incomeTaxNumber; 
		public String initials; 
		public String isInBusinessRescueAffectedParty; 
		public String marketingConsentGiven; 
		public String mayCheckCreditWorthiness; 
		public String mayReceiveMarketingViaEmail; 
		public String mayReceiveMarketingViaPost; 
		public String mayReceiveMarketingViaSMS; 
		public String mayReceiveMarketingViaTelephone; 
		public nextOfKin nextOfKin; 
		public String occupationCode; 
		public String occupationLevel; 
		public String occupationStatus; 
		public String placeOfResidence; 
		public postalAddress postalAddress; 
		public preAssessed preAssessed; 
		public String preferredCommunicationChannel; 
		public qualification qualification; 
		public residentialAddress residentialAddress; 
		public String shareInfoWithCreditProviders; 
		public List<String> sourceOfFunds; 
		public String sourceOfIncome; 
		public String surname; 
		public String tempPermitNumber; 
		public String titleType; 
		public workFaxNumber workFaxNumber; 
		public workTelephoneNumber workTelephoneNumber;
	}
	
	/**
	 * @description cardDetails
	 */
    public class cardDetails{
		public String plasticNumber;
		public String accountNo;
	}

	/**
	 * @description cardCollectionSite
	 */
    public class cardCollectionSite{
		public streetAddress streetAddress;
		public String nameLong;
		public String id;
		public String nameShort;
		public String type;
		public String status;
		public String subType;
	}
	
	/**
	 * @description cardCollectionMethodsAllowed
	 */
    public class cardCollectionMethodsAllowed {
		public String courierCollectionFee; 
		public String description; 
		public String id;
	}

	/**
	 * @description cardCollectionMethod
	 */
	public class cardCollectionMethod{
		public String courierCollectionFee;
		public String id;
		public String description;
	}

	/**
	 * @description cardCollection
	 */
	public class cardCollection{
		public cardCollectionMethod cardCollectionMethod;
		public cardCollectionSite cardCollectionSite;
	}
	
	/**
	 * @description debitOrderTypeAllowed
	 */
    public class debitOrderTypeAllowed{
		public String description;
		public String id;
	}

	/**
	 * @description pinOptionTypeAllowed
	 */
    public class pinOptionTypeAllowed{
		public String id;
		public String description;
	}

	/**
	 * @description responseCommons
	 */
	public class responseCommons {
		public String messageTimeStamp; 
		public String z_success;
	}
	
	/**
	 * @description getApplicationInformationResponse
	 */
	public class getApplicationInformationResponse {
		public z_return z_return;
	}
	
	/**
	 * @description expense
	 */
	public class expense {
		public String bondInstalmentOrRent; 
		public String creditCardInstalment; 
		public String household; 
		public String insuranceOrFuneralPolicy; 
		public String jointDebt; 
		public String maintenance; 
		public otherExpense otherExpense; 
		public otherFixedDebtExpense otherFixedDebtExpense; 
		public String personalLoanInstalment; 
		public String rent; 
		public String schoolOrUniversityFee; 
		public String totalFixedDebtExpense; 
		public String totalLivingExpense; 
		public String transport; 
		public String vehicleInstalment;
	}
	
	/**
	 * @description residentialAddress
	 */
	public class residentialAddress {
		public String addressLine1; 
		public String addressLine2; 
		public String city; 
		public String country; 
		public String postalCode; 
		public String suburb;
	}

	/**
	 * @description streetAddress
	 */
    public class streetAddress {
		public String addressLine1; 
		public String addressLine2; 
		public String city; 
		public String country; 
		public String postalCode; 
		public String suburb;
	}
	
	/**
	 * @description CasaInformation
	 */
	public class CasaInformation {
		public String countryOfResidence; 
		public String nationality; 
		public String referenceNumber; 
		public String riskRating; 
		public String versionNumber;
	}
	
	/**
	 * @description debtorDetails
	 */
	public class debtorDetails{
		public String ownAccount;
		public String idOrRegistrationNo;
		public String idtype;
		public String debtorPhone;
		public String ultDebtorName;
		public String debtorEmail;
	}

	/**
	 * @description creditorDetails
	 */
	public class creditorDetails{
		public String mandCredAccountID;
		public String mandCredName;
		public String mandCredBranch;
		public String mandUltCredName;
		public String mandUltCredShortName;
	}

	/**
	 * @description debitOrderType
	 */
	public class debitOrderType{
		public String id;
		public String description;
	}

	/**
	 * @description debitOrderDetails
	 */
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

	/**
	 * @description mandateDetails
	 */
	public class mandateDetails{
		public String refferedDocType;
		public String contractRef;
		public String clientRef;
		public String macCode;
		public String authType;
	}

	/**
	 * @description paymentDetails
	 */
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

	/**
	 * @description z_return
	 */
	public class z_return {
		public application application; 
		public responseCommons responseCommons;
	}
	
	/**
	 * @description employer
	 */
	public class employer {
		public address address; 
		public String name;
	}
	
	/**
	 * @description accountType
	 */
	public class accountType{
		public String description;
		public String code;
	}

	/**
	 * @description linkedAccountSelected
	 */
	public class linkedAccountSelected{
		public String productDescription;
		public accountType accountType;
		public String productCode;
		public String accountNumber;
	}

	/**
	 * @description pinOptionSelected
	 */
	public class pinOptionSelected{
		public String description;
		public String id;
	}

	/**
	 * @description productInformation
	 */
	public class productInformation {
		public String accountType; 
		public List<cardCollectionMethodsAllowed> cardCollectionMethodsAllowed; 
		public String cardProdSubProdGroupId; 
		public String cardProductDescription; 
		public String cardProductOrder; 
		public String creditLifeMaxAge; 
		public String creditLifeOffered; 
		public List<debitOrderTypeAllowed> debitOrderTypeAllowed; 
		public String electronicStatementDeliveryAllowed; 
		public String garageCardAllowed; 
		public String isStaff; 
		public String linkedAccountRequired; 
		public String lowValuePaymentAllowed; 
		public String maximumCreditLimit; 
		public String minimumCreditLimit; 
		public List<pinOptionTypeAllowed> pinOptionTypeAllowed; 
		public String principalBankCorpCode; 
		public String productFamilyId; 
		public String productGroupDescription; 
		public String productId; 
		public String productgroupId; 
		public String secondariesAllowed; 
		public String sourceId; 
		public String subProductGroupDescription; 
		public String subProductgroupId;
	}
	
	/**
	 * @description postalAddress
	 */
	public class postalAddress {
		public String addressLine1; 
		public String addressLine2; 
		public String city; 
		public String country; 
		public String postalCode; 
		public String suburb;
	}
	
	/**
	 * @description nextOfKin
	 */
	public class nextOfKin {
		public cellPhoneNumber cellPhoneNumber; 
		public String emailaddress; 
		public String fullNames; 
		public homeTelephoneNumber homeTelephoneNumber; 
		public String relationship; 
		public String surname; 
		public workTelephoneNumber workTelephoneNumber;
	}
	
	/**
	 * @description qualification
	 */
	public class qualification {
		public String hasPostMatricqualification;
	}
	
	/**
	 * @description quote
	 */
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

	/**
	 * @description otherExpense
	 */
	public class otherExpense {
		public String amount; 
		public String description;
	}
	
	/**
	 * @description rehabilitation
	 */
	public class rehabilitation {
		public String everBeenDeclaredInsolvent; 
		public String everUndergoneDebtCounselling;
	}
	
	/**
	 * @description application
	 */
	public class application {
		public String annualCreditLimitIncreases; 
		public String applicationNumber; 
		public String applicationType; 
		public String campaignId; 
		public String cardProdSubProdGroupId; 
		public String channelCode; 
		public consents consents; 
		public String corpCode; 
		public String creditLifeRequired; 
		public String creditLimitApproved; 
		public String creditLimitSelected; 
		public creditStatus creditStatus; 
		public String dateCreated; 
		public debitOrderDetails debitOrderDetails; 
		public String electronicStatementEmailAddress1; 
		public externalConsumerData externalConsumerData; 
		public String hasAcceptedCourierCollectionFee; 
		public String hasAcceptedSpecifiedCreditLimit; 
		public knockOutQuestions knockOutQuestions; 
		public linkedAccountSelected linkedAccountSelected; 
		public String lockVersionId; 
		public String lowValuePaymentRequired; 
		public String marketingSiteId; 
		public String numberOfSecondaryApplicantsRequested; 
		public String packageId; 
		public String personWhoCreatedApplication; 
		public pinOptionSelected pinOptionSelected; 
		public String pricingSchemeCode; 
		public primaryApplicant primaryApplicant; 
		public String productGroupId; 
		public productInformation productInformation; 
		public quote quote; 
		public StatementDeliveryMethodSelected statementDeliveryMethodSelected; 
		public String statusGroup;
		public String declineLetterDescription;
	}
	
	/**
	 * @description StatementDeliveryMethodSelected
	 */
	public class StatementDeliveryMethodSelected {
		public String code; 
		public String description;
	}

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('"number":', '"z_number":');
		fieldNameSubstitutionMap.put('"return":', '"z_return":');
		fieldNameSubstitutionMap.put('"success":', '"z_success":');        
	}
}