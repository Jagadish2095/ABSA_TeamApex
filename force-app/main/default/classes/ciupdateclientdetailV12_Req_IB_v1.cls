public class ciupdateclientdetailV12_Req_IB_v1 extends Base_IB {
  
public CIupdateClientDetailV12 CIupdateClientDetailV12; 
    
public class ForeignTaxData {
		public String foreignTaxCtry;
		public String foreignTaxNo;
		public String rsonFtaxNotGiven;
	}

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Cib004i {
		public String clientCode;
		public String initials;
		public String language;
		public String titleCode;
		public String surname;
		public String postlAddrLine1;
		public String postlAddrLine2;
		public String postlSuburb;
		public String postlTown;
		public String postlCodeRsa;
		public String idDocType;
		public String idNumber;
		public String birthDate;
		public String maritalStatus;
		public String smsMarketInd;
		public String gender;
		public String minorChildren;
		public String occupationCode;
		public String incomeGroup;
		public String bankingSector;
		public String securityIndicator;
		public String liabilityIndicator;
		public String telebankIndicator;
		public String unclaimedFundsInd;
		public String branchClientOpen;
		public String dateClientOpened;
		public String changeNumber;
		public String dateLastChanged;
		public String siteLastChanged;
		public String tellerLastChanged;
		public String nbrOfAccounts;
		public String prohibitedInd;
		public String postalAddrHold;
		public String absaRewardInd;
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
		public String occupancyType;
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
		public String cellphoneBankInd;
		public String siccCode5;
		public String subSegment;
		public String emailMarkInd;
		public String teleMarkInd;
		public String internetBankinInd;
		public String sourceOfIncome;
		public String dateIdentified;
		public String dateVerified;
		public String employeeIdentified;
		public String employeeVerified;
		public String vatRegistrationNo;
		public String clientNationality;
		public String countryOfOrigin;
		public String dateExempted;
		public String employeeExempted;
		public String exemptionStatus;
		public String exemptionIndicator;
		public String corporateDivision;
		public String haveQualification;
		public String whatQualification;
		public String socialGrant;
		public String notificationInd;
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
		public String employerAddrType;
		public String employerAddrSeqNbr;
		public String employerAdd1;
		public String employerAdd2;
		public String employerSuburb;
		public String employerTown;
		public String employerPostal;
		public String physicalAddrType;
		public String physicalAddrSeqNbr;
		public String physicalAdd1;
		public String physicalAdd2;
		public String physicalSuburb;
		public String physicalTown;
		public String physicalPostal;
		public String businessAddrType;
		public String businessAddrSeqNbr;
		public String businessAdd1;
		public String businessAdd2;
		public String businessSuburb;
		public String businessTown;
		public String businessPostal;
		public List<AgriData> agriData;
		public String resPermitNbr;
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
		public String contOride;
		public String updAddressInd;
		public String updTelephoneInd;
		public String updEmailInd;
		public String updDateInd;
		public String casaRefNum;
		public String pingitWallet;
		public String pingitReceive;
		public String regAddrLine1;
		public String regAddrLine2;
		public String regSuburb;
		public String regTown;
		public String regCodeRsa;
		public String hoAddrLine1;
		public String hoAddrLine2;
		public String hoSuburb;
		public String hoTown;
		public String hoCodeRsa;
		public String countryResAddress;
		public String countryHoAddress;
		public String countryRegAddress;
		public List<CountryEntOprtData> countryEntOprtData;
		public String countryOfBirth;
		public String mclInd;
		public String clntAgrmntIssued;
		public String sec129DeliveryAddr;
		public String saTaxRegis;
		public String rsonSaTaxNotGiven;
		public String foreignTaxRegis;
		public List<ForeignTaxData> foreignTaxData;
		public String ncrInd;
		public String ncrSms;
		public String ncrEmail;
		public String ncrAvoice;
		public String ncrTel;
		public String ncrPost;
		public String crInd;
		public String crSms;
		public String crEmail;
		public String crAvoice;
		public String crTel;
		public String crPost;
	}

	public class AgriData {
		public String agriClass;
		public String percentage;
	}

	public class CountryEntOprtData {
		public String countryEntOprt;
	}

	public class CIupdateClientDetailV12 {
	public Nbsapdpi nbsapdpi;
	public Nbsmsgi nbsmsgi;
	public Cib004i Cib003i;
	}

	

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

	
	public static ciupdateclientdetailV12_Req_IB_v1 parse(String json) {
		return (ciupdateclientdetailV12_Req_IB_v1) System.JSON.deserialize(json, ciupdateclientdetailV12_Req_IB_v1.class);
	} 
    
    // the dummy request
    public static ciupdateclientdetailV12_Req_IB_v1 createDummy(){
        ciupdateclientdetailV12_Req_IB_v1 requestBean = new ciupdateclientdetailV12_Req_IB_v1();
        requestBean.CIupdateClientDetailV12 = new ciupdateclientdetailV12_Req_IB_v1.CIupdateClientDetailV12();
        requestBean.CIupdateClientDetailV12.cib003i = new ciupdateclientdetailV12_Req_IB_v1.Cib004i();
        requestBean.CIupdateClientDetailV12.cib003i.initials= 'S';        
        requestBean.CIupdateClientDetailV12.cib003i.language = 'E';		//Translation
        requestBean.CIupdateClientDetailV12.cib003i.titleCode= '02';
        requestBean.CIupdateClientDetailV12.cib003i.surname= 'testing1';
        requestBean.CIupdateClientDetailV12.cib003i.idDocType=  '1';
        requestBean.CIupdateClientDetailV12.cib003i.idNumber= '3602265800086';
        requestBean.CIupdateClientDetailV12.cib003i.birthDate = '19680426';
        requestBean.CIupdateClientDetailV12.cib003i.gender = '1';						//Translation
        requestBean.CIupdateClientDetailV12.cib003i.occupationCode = '6';
        requestBean.CIupdateClientDetailV12.cib003i.firstNames = 'testAcc';
        requestBean.CIupdateClientDetailV12.cib003i.occupationStatus = '1';
        requestBean.CIupdateClientDetailV12.cib003i.prefrdCommtionMthd =  '01';
        requestBean.CIupdateClientDetailV12.cib003i.casaRefNum= '11246';
        requestBean.CIupdateClientDetailV12.cib003i.clientNationality = 'SOU01';

       return requestBean;
    }
}