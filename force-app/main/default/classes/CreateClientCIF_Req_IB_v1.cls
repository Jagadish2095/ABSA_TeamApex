/*******
 * Tracy de Bruin
 * Re-wrap Service to use Jotterbit structure 
 * 17-08-2020
 * ******/
Public class CreateClientCIF_Req_IB_v1 extends Base_IB{
    
    public class ForeignTaxData {
		public String foreignTaxCtry;
		public String foreignTaxNo;
		public String rsonFtaxNotGiven;
	}

	public class CIcreateClientV12 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cib003i cib003i;
	}

	public CIcreateClientV12 CIcreateClientV12;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class AgriData {
		public String agriClass;
		public String percentage;
	}

	public class Cib003i {
		public String initials;
		public String language;
		public String titleCode;
		public String surname;
		public String postlAddrLine1;
		public String postlAddrLine2;
		public String postlSuburb;
		public String postlTown;
		public String postlCodeRsa;
		public String idType;
		public String idNumber;
		public String birthDate;
		public String maritalStatus;
		public String smsMarketInd;
		public String gender;
		public String minorChildren;
		public String occupationCode;
		public String incomeGroup;
		public String branchClientOpen;
		public String tellerLastChanged;
		public String mariageContrctType;
		public String homeLanguage;
		public String marketingConcent;
		public String clientType;
		public String miltaryComtmntInd;
		public String occupancyType;
		public String noOfJointPartcpnt;
		public String taxNumber;
		public String firstNames;
		public String companyYearEnd;
		public String homeTelCode;
		public String homeTelephone;
		public String workTelCode;
		public String workTelephone;
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
		public String prefrdCommtionMthd;
		public String siccCode5;
		public String emailMarkInd;
		public String teleMarkInd;
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
		public String mailInd;
		public String groupScheme;
		public String groupSchemeEmp;
		public String secondaryCard;
		public String affectedPerson;
		public String exconExpiryDate;
		public String dateIssued;
		public String employerAddrType;
		public String employerAdd1;
		public String employerAdd2;
		public String employerSuburb;
		public String employerTown;
		public String employerPostal;
		public String physicalAddrType;
		public String physicalAdd1;
		public String physicalAdd2;
		public String physicalSuburb;
		public String physicalTown;
		public String physicalPostal;
		public String businessAddrType;
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
		public String thrdPartyInd;
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
		public String clntAgrmntIssued;
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

	public class CountryEntOprtData {
		public String countryEntOprt;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static CreateClientCIF_Req_IB_v1 createDummyRequest(){
        
        CreateClientCIF_Req_IB_v1 bean = new CreateClientCIF_Req_IB_v1();
        bean.CIcreateClientV12 = new CreateClientCIF_Req_IB_v1.CIcreateClientV12();
        bean.CIcreateClientV12.Nbsapdpi = new CreateClientCIF_Req_IB_v1.Nbsapdpi();
        bean.CIcreateClientV12.Nbsmsgi = new CreateClientCIF_Req_IB_v1.Nbsmsgi();
        bean.CIcreateClientV12.Nbsmsgi.finalMsgId = new CreateClientCIF_Req_IB_v1.FinalMsgId();
        bean.CIcreateClientV12.Cib003i = new CreateClientCIF_Req_IB_v1.Cib003i();
        bean.CIcreateClientV12.Cib003i.agriData = new List<CreateClientCIF_Req_IB_v1.AgriData>();
        bean.CIcreateClientV12.Cib003i.countryEntOprtData = new List<CreateClientCIF_Req_IB_v1.CountryEntOprtData>();
        bean.CIcreateClientV12.Cib003i.foreignTaxData = new List<CreateClientCIF_Req_IB_v1.ForeignTaxData>();

        bean.CIcreateClientV12.Cib003i.initials = 'T';
        bean.CIcreateClientV12.Cib003i.language = 'E';
        bean.CIcreateClientV12.Cib003i.titleCode = '01';
        bean.CIcreateClientV12.Cib003i.surname = 'TESTP';
        bean.CIcreateClientV12.Cib003i.postlAddrLine1 = '1 RUBGY ST';
        bean.CIcreateClientV12.Cib003i.postlAddrLine2 = 'POSTALADDRESSLINE2';
        bean.CIcreateClientV12.Cib003i.postlTown = 'AALWYNFLEUR';
        bean.CIcreateClientV12.Cib003i.postlCodeRsa = '6670';
        bean.CIcreateClientV12.Cib003i.idType = '03';
        bean.CIcreateClientV12.Cib003i.idNumber = 'P595959';
        bean.CIcreateClientV12.Cib003i.birthDate = '19991115';
        bean.CIcreateClientV12.Cib003i.maritalStatus = '1';
        //bean.smsMarketInd = 'N';
        bean.CIcreateClientV12.Cib003i.gender = '1';
        bean.CIcreateClientV12.Cib003i.occupationCode = '15';
        bean.CIcreateClientV12.Cib003i.branchClientOpen = '8136';
        bean.CIcreateClientV12.Cib003i.tellerLastChanged = '09999996';
        bean.CIcreateClientV12.Cib003i.mariageContrctType = '2';
        bean.CIcreateClientV12.Cib003i.marketingConcent = 'Y';
        bean.CIcreateClientV12.Cib003i.clientType = '00101';
        bean.CIcreateClientV12.Cib003i.miltaryComtmntInd = 'N';
        bean.CIcreateClientV12.Cib003i.occupancyType = '0';
        bean.CIcreateClientV12.Cib003i.firstNames = 'TestP';
        bean.CIcreateClientV12.Cib003i.homeTelCode = '011';
        bean.CIcreateClientV12.Cib003i.homeTelephone = '0845560989';
        bean.CIcreateClientV12.Cib003i.workTelCode = '011';
        bean.CIcreateClientV12.Cib003i.workTelephone = '0115077000';
        bean.CIcreateClientV12.Cib003i.cellphone = '0845560989';
        bean.CIcreateClientV12.Cib003i.occupationStatus = '01';
        bean.CIcreateClientV12.Cib003i.emailAddress = 'testp@gmail.com';
        bean.CIcreateClientV12.Cib003i.prefrdCommtionMthd = '3';
        //bean.emailMarkInd = 'N';
        //bean.teleMarkInd = 'Y';
        bean.CIcreateClientV12.Cib003i.clientNationality = 'SOU01';
        bean.CIcreateClientV12.Cib003i.countryOfOrigin = 'SO003';
        bean.CIcreateClientV12.Cib003i.dateExempted = '20181107';
        bean.CIcreateClientV12.Cib003i.corporateDivision = 'A';
        bean.CIcreateClientV12.Cib003i.haveQualification = 'N';
        bean.CIcreateClientV12.Cib003i.socialGrant = 'N';
        //bean.mailInd = 'N';
        bean.CIcreateClientV12.Cib003i.secondaryCard = 'N';
        bean.CIcreateClientV12.Cib003i.dateIssued = '0';
        bean.CIcreateClientV12.Cib003i.employerAddrType = '70';
        bean.CIcreateClientV12.Cib003i.physicalAddrType = '10';
        bean.CIcreateClientV12.Cib003i.physicalAdd1 = '1 RUBGY ST';
        bean.CIcreateClientV12.Cib003i.physicalAdd2 = 'POSTALADDRESSLINE2';
        bean.CIcreateClientV12.Cib003i.physicalTown = 'AALWYNFLEUR';
        bean.CIcreateClientV12.Cib003i.physicalPostal = '6670';
        bean.CIcreateClientV12.Cib003i.thrdPartyInd = 'N';
        bean.CIcreateClientV12.Cib003i.updAddressInd = 'N';
        bean.CIcreateClientV12.Cib003i.updTelephoneInd = 'N';
        bean.CIcreateClientV12.Cib003i.updEmailInd = 'N';
        bean.CIcreateClientV12.Cib003i.updDateInd = '20181107';
        bean.CIcreateClientV12.Cib003i.casaRefNum = '2021992';
        bean.CIcreateClientV12.Cib003i.countryOfBirth = 'SO003';
        bean.CIcreateClientV12.Cib003i.clntAgrmntIssued = 'N';
        
        return bean;
    }        
    
}