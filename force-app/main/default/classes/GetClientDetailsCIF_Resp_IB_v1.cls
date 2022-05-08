/**
 * @description Response Bean for the GetClientDetailsCIF service
 * @author
 * @created 2020-11-03
 * @updated Danie Booysen. 2021-04-26
 */
public class GetClientDetailsCIF_Resp_IB_v1 extends Base_IB {
	@AuraEnabled public String status;
	@AuraEnabled public Integer statusCode;
	@AuraEnabled public String message;

	public String indCifRecFound;
	public String clientCode;
	public String initials;
	public String language;
	public String titleCode;
	public String surname;
	//Postal
	public String postlAddrLine1;
	public String postlAddrLine2;
	public String postlSuburb;
	public String postlTown;
	public String postlCodeRsa;

	public String idDocType;
	public String idNumber;
	public String birthDate;
	public String maritalStatus;
	public String smsMarkInd;
	public String gender;
	public String minorChildren;
	public String occupationCode;
	public String incomeGroup;
	public String bankingSector;
	@AuraEnabled public String securityIndicator;
	public String liabilityIndicator;
	@AuraEnabled public String telebankIndicator;
	@AuraEnabled public String unclaimedFundsInd;
	public String branchClientOpened;
	public String dateClientOpened;
	public String changeNumber;
	public String dateLastChanged;
	public String siteLastChanged;
	public String tellerLastChanged;
	public String nbrOfAccounts;
	public String prohibitedInd;
	public String postalAddrHold;
	@AuraEnabled public String absaRewardIndctor;
	public String idRequiredHold;
	public String deceasedEstateHld;
	public String deceasedSpouseHld;
	public String insolvntEstateHld;
	public String curatorshipHold;
	public String savngStatementHold;
	public String courtAuthrityHold;
	public String thirdPartyInd;
	public String mandateCaptureHld;
	public String powerAttornyHold;
	public String sbuSegment;
	public String mariageContrctType;
	public String homeLanguage;
	public String marketingConcent;
	public String clientType;
	public String miltaryComtmntInd;
	public String occupationType;
	public String noOfJointPartcpnt;
	public String taxNumber;
	public String sicCode;
	public String firstNames;
	public String insolventIndicator;
	public String companyYearEnd;
	public String homeTelCode;
	public String homeTelephone;
	public String workTelCode;
	public String workTelephone;
	public String physicalAddrHold;
	public String employerAddrHold;
	public String cellphone;
	public String faxWorkCode;
	public String faxWorkNumber;
	public String faxHomeCode;
	public String faxHomeNumber;
	public String occupationStatus;
	public String employmentSector;
	public String occupationLevel;
	public String practiceNumber;
	public String clientWebsite;
	public String contactPerson;
	public String designation;
	public String emailAddress;
	public String inliPolicy;
	public String exliPolicy;
	public String instPolicy;
	public String exstPolicy;
	public String inivPolicy;
	public String flexiFuneralPolicy;
	public String prefrdCommtionMthd;
	@AuraEnabled public String cellphoneBankInd;
	public String siccCode5;
	public String subSegment;
	public String emailMarkInd;
	public String teleMarkInd;
	@AuraEnabled public String internetBankinInd;
	public String sourceOfIncome;
	public String dateIdentified;
	public String dateVerified;
	public String employeeIdentified;
	public String employeeVerified;
	public String vatRegistrationNo;
	public String clientNationality;
	public String countryOfOrigin;
	public String dateNClntExempted;
	public String dateAClntExempted;
	public String statusOfExemption;
	public String exemptionIndicator;
	public String corporateDivision;
	public String postMatricQualifd;
	public String postMatricQualfton;
	public String receiveSocialGrant;
	@AuraEnabled public String notifyMeIndicator;
	public String mailInd;
	public String applyDebtCounsel;
	public String dteApplyCounsel;
	public String counselOrderIssue;
	public String dteOrderIssue;
	public String groupScheme;
	public String groupSchemeEmp;
	public String secondaryCard;
	public String affectedPerson;
	public String exconExpiryDate;
	public String dateIssued;
	public String ibrAffected;
	public String clientGroup;
	public String nbrOfAddressesRtrv;

	public String tempPermitNbr;
	public String permitExpDte;
	public String subClassCde;
	public String countryIncorp;
	public String inBusinessRescue;
	public String placedBy;
	public String dateBusRescueIss;
	public String ncaThreshold;
	public String cpaThreshold;
	public String nkinSurname;
	public String nkinFname;
	public String nkinRela;
	public String nkinDcdh;
	public String nkinTelh;
	public String nkinDcdw;
	public String nkinTelw;
	public String nkinCell;
	public String nkinEmail;
	public String nkinTitle;
	public String nkinInitials;
	public String nkinJntSurname;
	public String reasonCodeO;

	public String forensicHold;
	public String updAddressInd;
	public String updTelephoneInd;
	public String updEmailInd;
	public String updDateInd;
	@AuraEnabled public String pingitWallet;
	@AuraEnabled public String pingitReceive;
	public String clntExstOnFica;
	public String regAddrLine1;
	public String regAddrLine2;
	public String regSuburb;
	public String regTown;
	public String regCodeRsa;
	//Home Address
	public String hoAddrLine1;
	public String hoAddrLine2;
	public String hoSuburb;
	public String hoTown;
	public String hoCodeRsa;

	public String countryResAddress;
	public String countryHoAddress;
	public String countryRegAddress;

	public String countryOfBirth;
	public String mclInd;
	public String finCrimeHold;
	public String clntAgrmntIssued;
	public String sec129DeliveryAddr;
	public String saTaxRegis;
	public String rsonSaTaxNotGiven;
	public String foreignTaxRegis;

	public String safeCustody;
	public String safeCustBoxSmall;
	public String safeCustBoxMedium;
	public String safeCustBoxLarge;
	public String safeCustEnvelope;
	public String nonCreditIndicator;
	public String nonCreditDateChanged;
	public String nonCreditSms;
	public String nonCreditEmail;
	public String nonCreditAvoice;
	public String nonCreditTelephone;
	public String nonCreditPost;
	public String creditIndicator;
	public String creditDateChanged;
	public String creditSms;
	public String creditEmail;
	public String creditAvoice;
	public String creditTelephone;
	public String creditPost;

	public String employerTown;
	public String employerSuburb;
	public String employerPostal;
	public String employerAddrType;
	public String employerAdd2;
	public String employerAdd1;

	/****************************/
	public String dateExempted;
	/****************************/

	public cls_addressEntry[] addressEntry;
	public cls_clsPercEntry[] clsPercEntry;
	public cls_duplClntCode[] duplClntCode;
	public cls_countryEntOprtData[] countryEntOprtData;
	public cls_foreignTaxData[] foreignTaxData;

	/**
	 * @description Inner class representing the cls_addressEntry structure
	 * @author
	 * @created 2020-11-03
	 */
	public class cls_addressEntry {
		public String addrType;
		public String addrSeqNbr;
		public String addrLine1;
		public String addrLine2;
		public String addrSuburbRsa;
		public String addrTown;
		public String addrPostlCode;
	}

	/**
	 * @description Inner class representing the cls_clsPercEntry structure
	 * @author
	 * @created 2020-11-03
	 */
	public class cls_clsPercEntry {
		public String classification;
		public String percentage;
	}

	/**
	 * @description Inner class representing the cls_duplClntCode structure
	 * @author
	 * @created 2020-11-03
	 */
	public class cls_duplClntCode {
		public String duplCode;
	}

	/**
	 * @description Inner class representing the cls_countryEntOprtData structure
	 * @author
	 * @created 2020-11-03
	 */
	public class cls_countryEntOprtData {
		public String countryEntOprt;
	}

	/**
	 * @description Inner class representing the cls_foreignTaxData structure
	 * @author
	 * @created 2020-11-03
	 */
	public class cls_foreignTaxData {
		public String foreignTaxCtry;
		public String foreignTaxNo;
		public String rsonFtaxNotGiven;
	}
}