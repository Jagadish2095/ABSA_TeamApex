/*
* Service Request class for generating client CIF 
*
* @author  Haritha Police : Absa
* @version v1.0
* @since   2019-11-28
*
*/
public class GenerateClientCIFpty_Req_IB_v1 extends Base_IB {
	
    public String channel;	//BDP
	public String application;	//BDP
	public String trace;	//Y
	public String msgLanguage;	//E
	public String msgTarget;	//STD
	public String initials;	//
	public String language;	//E
	public String titleCode;	//0
	public String surname;	//ANKA PROJECTS (PTY) LTD
	public String postlAddrLine1;	//129 ABSA AVE
	public String postlAddrLine2;	//
	public String postlSuburb;	//
	public String postlTown;	//JHB
	public String postlCodeRsa;	//2001
	public String idType;	//5
	public String idNumber;	//201730633007
	public String birthDate;	//0
	public String maritalStatus;	//0
	public String smsMarketInd;	//Y
	public String gender;	//0
	public String minorChildren;	//
	public String occupationCode;	//0
	public String incomeGroup;	//0
	public String branchClientOpen;	//8604
	public String tellerLastChanged;	//1214414
	public String mariageCntrctType;	//0
	public String homeLanguage;	//
	public String marketingConcent;	//N
	public String clientType;	//002301
	public String militaryComtmntInd;	//
	public String occupancyType;	//
	public String noOfJointPartcpnt;	//0
	public String SAtaxNumber;	//0
	public String firstNames;	//
	public String companyYearEnd;	//1
	public String homeTelCode;	//0
	public String homeTelephone;	//
	public String workTelcode;	//0
	public String workTelephone;	//0
	public String cellphone;	//0820000000
	public String faxWorkCode;	//0
	public String faxWorkNumber;	//0
	public String faxHomeCode;	//0
	public String faxHomeNumber;	//0
	public String occupationStatus;	//0
	public String employmentSector;	//0
	public String occupationLevel;	//0
	public String practiceNumber;	//
	public String clientWebsite;	//
	public String contactPerson;	//
	public String designation;	//0
	public String emailAddress;	//A@ABSA.CO.ZA
	public String prefrdCommtionMthd;	//04
	public String siccCode5;	//
	public String emailMarkInd;	//
	public String teleMarkInd;	//0
	public String sourceOfIncome;	//0
	public String dateIdentified;	//20190905
	public String dateVerified;	//20190905
	public String employeeIdentified;	//0
	public String employeeVerified;	//Y
	public String vatRegistrationNo;	//
	public String clientNationality ;	//
	public String countryOfOrigin;	//
	public String dateExempted;	//0
	public String employeeExempted;	//N
	public String exemptionStatus ;	//
	public String exemptionIndicator;	//A
	public String corporateDivision;	//?
	public String haveQualification;	//
	public String whatQualification;	//0
	public String socialGrant;	//
	public String mailInd;	//Y
	public String groupScheme;	//0
	public String groupSchemeEmp;	//
	public String secondaryCard;	//
	public String affectedPerson;	//0
	public String exconExpiryDate;	//0
	public String dateIssued;	//0
	public String employerAddrType;	//0
	public String employerAdd1;	//
	public String employerAdd2;	//
	public String employerSuburb;	//
	public String employerTown;	//
	public String employerPostal;	//0
	public String physicalAddrType;	//0
	public String physicalAdd1;	//
	public String physicalAdd2;	//
	public String physicalSuburb;	//
	public String physicalTown;	//
	public String physicalPostal;	//0
	public String businessAddrType;	//0
	public String businessAdd1;	//
	public String businessAdd2;	//
	public String businessSuburb;	//
	public String businessTown;	//JHB
	public String businessPostal;	//2001
	public String agriClass;	//
	public String percentage;	//0
	public String resPermitNumber;	//
	public String permitExpDte;	//0
	public String subClassCde;	//
	public String countryIncorp;	//
	public String ncaThreshold;	//N
	public String cpaThreshold;	//N
	public String nkinSurname;	//
	public String nkinFname;	//
	public String nkinRela;	//
	public String nkinDcdh;	//
	public String nkinTelh;	//
	public String nkinDcdw;	//
	public String nkinTelw;	//
	public String nkinCell;	//
	public String nkinEmail;	//
	public String nkinTitle;	//
	public String nkinInitials;	//
	public String nkinJntSurname;	//
	public String contOride;	//0
	public String thrdPartyInd;	//
	public String updAddressInd;	//
	public String updTelephoneInd;	//
	public String updEmailInd;	//
	public String updDateInd;	//0
	public String casaRefNum;	//0
	public String pingitWallet;	//
	public String pingitReceive;	//
	public String regAddrLine1;	//129 ABSA AVE
	public String regAddrLine2;	//
	public String regSuburb;	//
	public String regTown;	//JHB
	public String regCodeRsa;	//2001
	public String hoAddrLine1;	//129 ABSA AVE
	public String hoAddrLine2;	//
	public String hoSuburb;	//
	public String hoTown;	//JHB
	public String hoCodeRsa;	//2001
	public String countryResAddress;	//SO003
	public String countryHoAddress;	//SO003
	public String countryRegAddress;	//SO003
	public String countryEntOprt;	//
	public String countryOfBirth;	//
	public String ClientAgrmntIssued;	//
	public String sec129DeliveryAddr;	//1
	public String saTaxRegis;	//Y
	public String rsonSaTaxNotGiven;	//3
	public String foreignTaxRegis;	//N
	public String foreignTaxCtry;	//
	public String foreignTaxNo;	//
	public String rsonFtaxNotRegis;	//
	public String NonCRInd;	//Y
	public String NonCRSMS;	//Y
	public String NonCREmail;	//Y
	public String NonCRVR;	//Y
	public String NonCRTel;	//Y
	public String NonCRPost;	//Y
	public String CRInd;	//Y
	public String CreditSMS;	//Y
	public String CreditEmail;	//Y
	public String CreditAutoVoice;	//Y
	public String CreditTel;	//Y
	public String CreditPost;
    public static GenerateClientCIFpty_Req_IB_v1 createDummyRequest() {
    GenerateClientCIFpty_Req_IB_v1 requestBean = new GenerateClientCIFpty_Req_IB_v1();

        requestBean.channel = 'BDP';
        requestBean.application = 'BDP';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.titleCode = '0';
        requestBean.surname = 'test company';
 		requestBean.clientType = '002301';
  		requestBean.idType = '5';
  		requestBean.SAtaxNumber = '0';
      	 return requestBean;
	}
}