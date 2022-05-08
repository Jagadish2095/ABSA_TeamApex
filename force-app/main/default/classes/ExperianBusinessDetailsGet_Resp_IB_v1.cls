/*
* Response Integration Bean for ExperianBusinessDetailsGet Service
* @author Prashant Jain
* @created 2020-01-31
*/

public class ExperianBusinessDetailsGet_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    
    public class HistoricalBankCodes {
		public List<BankCodeDetails> bankCodeDetails;
	}

	//public Object error;
	public String registrationNumber;
	public CompanyDownload companyDownload;
	public String pdf;

	public class Staff {
		public String total;
		public String permanent;
		public String salary;
		public String wages;
		public String casual;
	}

	public class ReportSummary {
		public String nameChangeIndicator;
		public String nameChangeDate;
		public String previousName;
		public String score;
		public String numberOfSubs;
		public String numberOfJU;
		public String dateLastJU;
		public String numberActPrincipals;
		public String numberActPrincipalsJU;
		public String lastestBankCode;
		public String lastestBankCodeDate;
		public String numberRDs;
		public String liqIndicator;
		public String totEnqLast12Mth;
		public String totEnqLast3Mth;
		public String refsNoOfReferences;
		public String refsHighMthPurchases;
		public String refsHighMthPurchasesTermGiven;
		public String refsHighMthPurchasesTermTaken;
		public String refsLowMthPurchases;
		public String refsLowMthPurchasesTermGiven;
		public String refsLowMthPurchasesTermTaken;
		public String kissNoOfSuppliers;
		public String kissNoOfODSuppliers;
		public String kissAmountOS;
		public String kissAmountOD;
		public String kissPercntage;
		public String latestBankCodeDesc;
		public String holdingCmpName;
	}

	public class PrevYr2Month {
		public String month01;
		public String month02;
		public String month03;
		public String month04;
		public String month05;
		public String month06;
		public String month07;
		public String month08;
		public String month09;
		public String month10;
		public String month11;
		public String month12;
		public String totalEnquiriesYear;
	}

	public class Premises {
		public List<PremisesDetails> premisesDetails;
	}

	public class Vehicles {
		public String total;
		public String cars;
		public String ldv;
		public String trailers;
		public String rigid;
		public String busses;
		public String trucks;
	}

	public class JudgementDetails {
		public String defendant;
		public String groupingCode;
		public String plaintiff;
		public String caseNumber;
		public String amount;
		public String address1;
		public String address2;
		public String address3;
		public String address4;
		public String address5;
		public String postCode;
		public String reason;
		public String date_Z; // in json: date
		public String townName;
		public String courtName;
		public String subsectionCode;
	}

	public class Pbidetails {
		public String name;
		public String kimNumber;
		public String regNumber;
		public String cmpStatus;
		public String dirStatus;
		public String liqIndicator;
		public String juindicator;
	}

	public class LinkDetails {
		public String sourceFileCode;
		public String reportDate;
		public String description;
		public String businessName;
		public String kikimNumber;
	}

	public class ContactDetails {
		public PhysicalAddress physicalAddress;
		public PostalAddress postalAddress;
		public StreetAddress streetAddress;
		public String telephoneArea;
		public String telephoneNumber;
		public String faxArea;
		public String faxNumber;
		public String cellNumber;
		public String auditorName;
		public String auditorType;
		public String auditorStatus;
		public String region;
		public String countryofOrigin;
		//public Object country;
	}

	public class Directors {
		public List<DirectorDetails> directorDetails;
	}

	public class Pbi {
		public List<Pbidetails> pbidetails;
	}

	public class NameChangeDetails {
		public String nameChange;
		public String nameChangeDate;
	}

	public class Subsidiaries {
		public List<SubsidiaryDetails> subsidiaryDetails;
	}

	public class Obi {
		public List<Obidetails> obidetails;
	}

	public class NameChanges {
		public List<NameChangeDetails> nameChangeDetails;
	}

	public class CompanyDownload {
		public Results results;
	}

	public class KiinternalNumberHistory {
		public List<KiinternalNumberChanges> kiinternalNumberChanges;
	}

	public class VatNumbers {
		public List<String> vatNo;
	}

	public class DirectorDetails {
		public String surname;
		public String firstNames;
		public String previousSurname;
		public String dateOfBirth;
		public String initials;
		public String cm29Date;
		public String appointmentDate;
		public String type_Z; // in json: type
		public String designation;
		public String withdrawnPublic;
		public String country;
		public String status;
		public String statusDate;
		public String ck12Date;
		public String interestSize;
		public String membersContribution;
		public String contributionType;
		public String profession;
		public String occupation;
		public String indicator;
		public String position;
		public String sharePercentage;
		public String title;
		public String confirmCIPRO;
		public String confirmCIPRODate;
		public String confirmKI;
		public String confirmKIDate;
		public RegisteredAddress registeredAddress;
		public ResidentialAddress residentialAddress;
		public BusinessAddress businessAddress;
		public PostalAddress postalAddress;
		public String idVerified;
		public String delphiIndicator;
		public String delphiScore;
		public String judgementIndicator;
		public String totNumberJU;
		public String totNumberNotices;
		//public Object judgements;
		public Obi obi;
		public Pbi pbi;
		public Bonds bonds;
		public String saresident;
		public String idwarning;
		public String ncrdebtCounsel;
		public String idnumber;
	}

	public class Operations {
		public String importExport;
		public TextList operationsText;
		//public Object siccode;
		//public Object sicdescription;
	}

	public class Judgements {
		public String indicator;
		public String indicatorDate;
		public String liqIndicator;
		public List<JudgementDetails> judgementDetails;
	}

	public class BondDetails {
		public String type_Z; // in json: type
		public String asset;
		public String holder;
		public String amount1;
		public String amount2;
		public String amount3;
		public String registrationDate;
		public String number_Z; // in json: number
		public String deedsOffice;
		public TextList bondText;
	}

	public class KreditSearchFile {
		public CompanyDetails companyDetails;
		public ContactDetails contactDetails;
		//public Object capitalStructure;
		public Directors directors;
		public Subsidiaries subsidiaries;
		public Branches branches;
		public Operations operations;
		public Premises premises;
		//public Object bonds;
		public FinancialDetails financialDetails;
		public Vehicles vehicles;
		public Staff staff;
		public BankDetails bankDetails;
		public HistoricalBankCodes historicalBankCodes;
		//public Object references;
		public Judgements judgements;
		//public Object possibleJudgements;
		//public Object lastAssessment;
		public EnquiryHistory enquiryHistory;
		public Kiss kiss;
		public Score score;
		//public Object wow;
		public ReportSummary reportSummary;
		public RelatedReportLinks relatedReportLinks;
	}

	public class Bonds {
		public List<BondDetails> bondDetails;
	}

	public class Branches {
		public String numberofBranches;
		//public Object branchGroup;
	}

	public class BankDetails {
		public String bankers;
		public String branch;
		public String accountNumber;
		public String accountHolder;
		public String bankCode;
		public String bankCodeDescription;
		public String bankCodeDate;
		public String enquiryAmount;
		public String terms;
		public String dateofLastRD;
		public String amountOfLastRD;
		public String accountDate;
		public String numberOfRD;
		public TextList bankText;
	}

	public class BankCodeDetails {
		public String date_Z; // in json: date
		public String bankers;
		public String branch;
		public String accountNumber;
		public String enquiryAmount;
		public String terms;
		public String bankCode;
		public String numberOfRD;
		public TextList historicalBankText;
	}

	public class KiinternalNumberChanges {
		public String oldKimNr;
		public String oldKimChangeDate;
	}

	public class RegisteredAddress {
		public String address1;
		public String address2;
		public String address3;
		public String address4;
		public String address5;
		public String postCode;
	}

	public class ResidentialAddress {
		public String address1;
		public String address2;
		public String address3;
		public String address4;
		public String address5;
		public String postCode;
	}

	public class BusinessAddress {
		public String address1;
		public String address2;
		public String address3;
		public String address4;
		public String address5;
		public String postCode;
	}

	public class PhysicalAddress {
		public String address1;
		public String address2;
		public String address3;
		public String address4;
		public String address5;
		public String postCode;
	}

	public class StreetAddress {
		public String address1;
		public String address2;
		public String address3;
		public String address4;
		public String address5;
		public String postCode;
	}

	public class PostalAddress {
		public String address1;
		public String address2;
		public String address3;
		public String address4;
		public String address5;
		public String postCode;
	}

	public class CompanyDetails {
		public String companyName;
		public String registrationNumber;
		public String reportDate;
		public String registrationDate;
		public String startDate;
		public String financialYear;
		public String financialYearDate;
		public String withdrawnPublic;
		public String taxNumber;
		public String entity;
		public String status;
		public String shortName;
		//public Object convertRegNumber;
		public String translatedName;
		public String tradingName;
		public String divisionName;
		public String subDivisionName;
		public NameChanges nameChanges;
		public VatNumbers vatNumbers;
		public TextList companyText;
		public String siccsource;
		public KiinternalNumberHistory kiinternalNumberHistory;
		public String jsename;
		public String siccode;
		public String sicdescription;
	}

	public class PremisesDetails {
		public String type_Z; // in json: type
		public String location;
		public String floorArea;
		public String leaseExpiryDate;
		public String ownerIndicator;
		public String ownerName;
		public String purchasePrice;
		public String purchaseDate;
		public String erfNumber;
		public String erfSize;
		public String erfValue;
		public String titleDeed;
		public String deedsOffice;
		public TextList premisesText;
	}

	public class FinancialDetails {
		//public Object cashSalesIndicator;
		//public Object creditIndicator;
		//public Object days30;
		//public Object days45;
		//public Object days60;
		//public Object days90;
		//public Object days90Plus;
		//public Object cod;
		//public Object letterofCredit;
		//public Object hp;
		public String creditTerms;
		public String turnoverHistory;
		public String turnoverCurrent;
		public String turnoverProjected;
		public String turnoverIndicator;
		public String currentAssets;
		//public Object currentLiabilities;
		//public Object cash;
		//public Object overdraft;
		//public Object debtors;
		//public Object creditors;
		//public Object stock;
		//public Object loans;
		//public Object fixedAssets;
		//public Object longTermLiabilities;
		//public Object profitPerAnnum;
		//public Object reserves;
		//public Object balanceSheetCompany;
		//public Object balanceSheetCompanyKimNo;
		public TextList financialText;
	}

	public class SubsidiaryDetails {
		public String associationIndicator;
		public String associationCode;
		public String internalLinkNumber;
		public String companyName;
		public String country;
		public String activity;
		public String sharePercentage;
		public TextList subsidiaryText;
		public String kikimNumber;
		public String jsename;
	}

	public class EnquiryHistory {
		public String prevYr2Year;
		public PrevYr2Month prevYr2Month;
		public String prevYr2High;
		public String prevYr2Low;
		public String prevYr2Ave;
		public String prevYr1Year;
		public PrevYr2Month prevYr1Month;
		public String prevYr1High;
		public String prevYr1Low;
		public String prevYr1Ave;
		public String prevCurYear;
		public PrevYr2Month prevCurMonth;
		public String prevCurHigh;
		public String prevCurLow;
		public String prevCurAve;
	}

	public class Score {
		public String scoreCard;
		public String scoreCardDescription;
		public String scoreSegment;
		public String scoreSegmentDescription;
		public TextList scoreSegmentText;
		public String riskGrade;
		//public Object searchScore;
		//public Object searchScoreCard;
		public String riskGradeMinimum;
		public String riskGradeMaximum;
		public String riskBand;
		public String failureOdds;
		public TextList scoreText;
	}

	public class RelatedReportLinks {
		public List<LinkDetails> linkDetails;
	}

	public class Results {
		//public Object kifile;
		//public Object ciprofile;
		public KreditSearchFile kreditSearchFile;
		//public Object judgementFile;
		//public Object scoreVariables;
		//public Object goldReport;
	}

	public class TextList {
		public List<String> text;
	}

	public class Obidetails {
		public String name;
		public String kimNumber;
		public String regNumber;
		public String cmpStatus;
		public String dirStatus;
		public String liqIndicator;
		public String juindicator;
	}

	public class Kissdetail {
		public String period;
		public String numberOfDebtors;
		public String numberOverdue;
		public String totalOutstanding;
		public String totalOverdue;
		public String totalPercentage;
		public String amountOutstanding30Days;
		public String amountOutstanding60Days;
		public String amountOutstanding90Days;
		public String amountOutstanding120Days;
		public String amountOutstanding150Days;
		public String amountOutstanding180Days;
		public String amountOutstanding210Days;
		public String amountOutstanding240Days;
		public String amountOutstanding240PlusDays;
	}

	public class Kiss {
		public List<Kissdetail> kissdetail;
	}
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map < String, String > ();
        fieldNameSubstitutionMap.put('"type":', '"type_Z":');
        fieldNameSubstitutionMap.put('"number":', '"number_Z":');
        fieldNameSubstitutionMap.put('"date":', '"date_Z":');
    }
}