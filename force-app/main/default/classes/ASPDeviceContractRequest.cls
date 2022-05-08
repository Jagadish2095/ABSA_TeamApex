/**
 * @description Request for ASPDeviceContractRequest
 * @author  Paul du Randt
 * @created 2021-02-01
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-07-01   Arrie.Castelyn@absa.africa    Added Address Street 2
 * 1.0   2021-07-01   PaulJohn.duRand@absa.africa   Added getNewInstance method
 */

public class ASPDeviceContractRequest {
	/**
	 * @description Request for ASPDeviceContractRequest
	 * @author  Paul du Randt
	 * @created 2021-02-01
	 */
	public String name { get; set; }
	public String casaReferenceNumber;
	public String customerCode;
	public String customerType;
	public String placeofResidence;
	public String title;
	public String initials;
	public String fullName;
	public String surname;
	public String gender;
	public String dateofBirth;
	public String countryofbirth;
	public String idNumber;
	public String dateIssued;
	public String nationality;
	public String countryPassportIssued;
	public String maritalStatus;
	public String maritalContractType;
	public String hasTheCustomerEverBeenDeclaredInsolvent;
	public String doesTheCustomerReceiveASocialGrant;
	public String doesTheCustomerHaveAPostMatricQualification;
	public String postmatricQualification;
	public String residentialAddressCountry;
	public String residentialStatus;
	public String section129NoticeDeliveryAddress;
	public String homTelephoneNumber;
	public String cellphoneNumber;
	public String email;
	public String preferredCommunicationChannel;
	public String correspondenceLanguage;
	public String creditworthinessConsent;
	public String absaGroupMarketingConsent;
	public String absaGroupCreditMarketingConsent;
	public List<String> absaGroupMarketingItems;
	public List<String> absaGroupCreditMarketingItems;
	public String occupationalStatus;
	public String employmentSector;
	public String occupationCode;
	public String occupationLevel;
	public String groupScheme;
	public String employersName;
	public String employersAddress;
	public String areyouregisteredforSouthAfricanIncomeTax;
	public String areyouregisteredforForeignIncomeTax;
	public String southAfricanTaxNumber;
	public String reasonSouthAfricanTaxNumberNotGiven;
	public String monthlyIncome;
	public String sourceofIncome;
	public String ficaDateIdentified;
	public String ficaIdentifiedBy;
	public String ficaDateVerified;
	public String ficaVerifiedBy;
	public String nextofKinSurname;
	public String nextofKinfullName;
	public String nextofKinrelationship;
	public String nextofKinWorkTelephoneNumber;
	public String nextofKincellphoneNumber;
	public String nextofKinemail;
	public String quoteNumber;
	public String registeringSite;
	public String capturedBy;
	public String recipientName;
	public String deliveryDetails;
	public String preferredLanguage;
	public String product;
	public String accountNumber;
	public String notifyTime;
	public String minimumAmount;
	public String absaRepresentativeName;
	public String numberofDependents;
	public String idType;
	public String age;
	public String employerWorktelephoneNumber;
	public String knockoutAttestationOptions;
	public String knockoutQuestions;
	public String roaQuestionnaire;
	public String frequencyofIncome;
	public String totalGrossIncome;
	public String totalNetIncome;
	public String maintenanceExpense;
	public String totalFixedDebitInstalments;
	public String totalLivingExpenses;
	public String totalSurplus;
	public String incomeAndExpensesDeclaration;
	public String incomeAndExpensesDebtCounselling;
	public String accountType;
	public String managerNumber;
	public String chequeAccountOpenDate;
	public String reasonforOpening;
	public String siteName;
	public String riskType;
	public String newAccount;
	public String abcUser;
	public String accountStopped;
	public String creditBackdateLimit;
	public String debitBackdateLimit;
	public String corporateSubProduct;
	public String absaEmployeeNumber;
	public String mandateHolderName;
	public String customerName;
	public String productType;
	public String accNumber;
	public String domicileBranch;
	public String domicilebranchCode;
	public String salesConsultant;
	public String bankClearingCode;
	//Value Added Service Fields
	public String rewardsSelected;
	public String creditLifeSelected;
	public String eStatementDelivery;
	//Debit Order Fields
	public String debitOrderSurname;
	public String debitOrderInitials;
	public String debitOrderIdNumber;
	public String debitOrderphoneNumber;
	public String contractRef;
	public String debitedAcc;
	public String accHoldername;
	public String institutionName;
	public String branch;
	public String branchClearingCode;
	public String authenticationtype;
	public String accType;
	public String ultimateCreditorName;
	public String creditorName;
	public String creditorAbbrName;
	public String branchClearingCode1;
	public String firstCollectionDate;
	public String contractNumber;
	public String instalmentOccurence;
	public String frequency;
	public String mandatetype;
	public String paymentAmountOpt;
	public String maximumAmount;
	public String collectionDay;
	public String adjustmentCategory;
	public String dateAdjustment;
	public String paymentFrequency;
	public String trackingIndicator;
	public String packageName;
	public ContractTypes contractTypes;
	public String sourceofFunds;
	public Address residential;
	public Address postal;
	public Boolean isDEA;
	public Boolean isACL;
	public string disposableMonthlyIncome;
	public Boolean isNotify;
	public String notifyMeCode;
	public String notifyMeDescription;
	public Boolean isRewards;
	public String rewardsMembershipNumber;
    public String rewardsMonthlyFee;
    public String rewardsDebitDay;
	public Boolean isEStatement;
	public Boolean isInternetBanking;
	public Switching switching;
	public RelatedParty relatedParty;
    //public List<WimiContractSection> WimiProducs;

	public enum ContractTypes {
		PACKAGES,
		LINKING,
		CHEQUES,
		CREDITCARD,
		PERSONALLOAN,
		STOKVEL,
		SAVINGS,
        CUSTOMERAGREEMENT,
        INSTANTLIFE
	}

	/**
	 * @description Request Address
	 * @author  Paul du Randt
	 * @created 2021-02-01
	 */
	public class Address {
		public String street;
		public String street2;
		public String suburb;
		public String city;
		public String postalCode;
		public String country;
	}

	/**
	 * @description Switching Request
	 * @author  Paul du Randt
	 * @created 2021-02-01
	 */
	public class Switching {
		public String previousAccountNo;
		public String previousBranchCode;
		public String previousFinancialInstitution;
		public String previousProductType;
		public String previousBranchName;

		public String absaAccountNo;
		public String absaBranchCode;
		public String absaAccoutType;
		public String absaBranchName;

		public Boolean isSalarySwitch;
		public Boolean isBeneficiarySwitch;
		public Boolean isDebitOrderSwitch;

		public String employer;
		public String dueDate;

		public List<DebitOrder> debitOrders;
	}

	/**
	 * @description DebitOrder Request
	 * @author  Paul du Randt
	 * @created 2021-02-01
	 */
	public class DebitOrder {
		public String beneficiary;
		public String refAccountNo;
		public String telUserCode;
		public String dateDue;
		public String frequency;
		public String amount;
	}

    /**
	 * @description RelatedPartyDetails Request
	 * @author  Khaliq Abdul
	 * @created 2021-09-27
	 */
	public class RelatedParty {
        public String relSignatoryCount;
		public List<RelatedPartyDetails> relatedPartyDetails;
	}
    
    /**
	 * @description RelatedPartyDetails
	 * @author  Khaliq Abdul
	 * @created 2021-09-27
	 */
	public class RelatedPartyDetails {
		public String relCasaRefNumber;
		public String relTitle;
		public String relInitials;
        public String relCustomerCode;
		public String relSurName;
		public String relFirstName;
		public String relDateOfBirth;        
        public String relGender;
        public String relCellNumber;
		public String relIdType;
		public String relIdNumber;
		public String relDateIssued;
		public String relNationality;
		public String relCountryOfBirth;
        public String relCountryOfResidence;
		public String relOccupationalStatus;
		public String relOccupationalCode;
        public String relOccupationCategory;
		public String relDesignation;
		public String relHomeTelNumber;
		public String relCompulsorySignature;
        public String relDateIdentified;
		public String relDateVerified;
		public String relVerifiedBy;
        public Boolean relController;
        public Boolean relSignatory;        
        public Address relResidential;
		public Address relPostal;
	}
    
	/**
	 * @description Get Instance of ASPDeviceContractRequest
	 * @author PaulJohn.duRand@absa.africa | 2021-07-27
	 * @return ASPDeviceContractRequest
	 **/
	public static ASPDeviceContractRequest getNewInstance() {
		ASPDeviceContractRequest aspContractRequest = new ASPDeviceContractRequest();
		aspContractRequest.Residential = new ASPDeviceContractRequest.Address();
		aspContractRequest.Postal = new ASPDeviceContractRequest.Address();
       
		return aspContractRequest;
	}
}