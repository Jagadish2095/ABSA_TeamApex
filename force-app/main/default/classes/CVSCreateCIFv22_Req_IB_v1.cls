/**
 * @description CVSCreateCIFv22_Req_IB_v1 Request Bean
 * @author  Paul du Randt
 * @created 2020-09-18
 */

public without sharing class CVSCreateCIFv22_Req_IB_v1 extends Base_IB {

    public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;
	public CIB003I CIB003I;

	/**
	 * @description DetailClassificationDataTable
	 */
	public class DetailClassificationDataTable {
	}

	/**
	 * @description CIcreateClientV22RequestBean
	 */
	public class CIcreateClientV22Request {
		public String initials;
		public String commLanguageCode;
		public String titleCode;
		public String surname;
		public String postalAddrLine1;
		public String postalAddrLine2;
		public String postalSuburb;
		public String postalTown;
		public String postalAddrRsaCode;
		public String idDocTypeCode;
		public String idNumber;
		public String dateOfBirth;
		public String maritalStatusCode;
		public String genderCode;
		public String minorChildren;
		public String occupationCode;
		public String incomeGroupCode;
		public String marriageContractTypeCode;
		public String homeLanguageCode;
		public String clientTypeCode;
		public String voluntaryCreditConsolInd;
		public String residentialStatusCode;
		public String noOfJointParticipants;
		public String saTaxNumber;
		public String firstNames;
		public Integer companyYearEnd;
		public String homeTelephoneDialCode;
		public String homeTelephoneNumber;
		public Integer workTelephoneDialcode;
		public String workTelephoneNumber;
		public string cellphoneNumber;
		public Integer workFaxDialCode;
		public Integer workFaxNumber;
		public Integer homeFaxOrAlternativeNumDialCode;
		public String homeFaxOrAlternativeNumber;
		public String occupationStatusCode;
		public String employmentSectorCode;
		public String occupationLevelCode;
		public String practiceNumber;
		public String clientWebsite;
		public String contactPerson;
		public Integer contactPersonDesignationCode;
		public String emailAddress;
		public String preferredCommMethodCode;
		public String sicCode5;
		public String sourceOfIncomeCode;
		public String dateIdentified;
		public String dateVerified;
		public String employeeIdentified;
		public String employeeVerified;
		public String vatRegistrationNumber;
		public String clientNationalityCode;
		public String countryPassportIssuedCode;
		public Integer dateExempted;
		public String employeeExempted;
		public String exemptionStatusInd;
		public String exemptionCode;
		public String postMatricQualificationInd;
		public String postMatricQualificationCode;
		public String socialGrantInd;
		public Integer groupSchemeCode;
		public String groupSchemeEmp;
		public String secondaryPortfolioInd;
		public Integer excControlAffectedPersonCode;
		public Integer excControlExpiryDate;
		public string dateIdDocIssued;
		public String employerName;
		public String employerAddrLine1;
		public String employerSuburb;
		public String employerTown;
		public String employerRsaPostalCode;
		public String physicalAddrLine1;
		public String physicalAddrLine2;
		public String physicalSuburb;
		public String physicalTown;
		public string physicalRsaPostalCode;
		public String businessAddrLine1;
		public String businessAddrLine2;
		public String businessSuburb;
		public String businessTown;
		public string businessRsaPostalCode;
		public List<DetailClassificationDataTable> detailClassificationDataTable;
		public String tempResPermitNumber;
		public Integer tempResPermitExpDate;
		public String subClassificationCode;
		public String countryIncorporatedCode;
		public String cpaThresholdInd;
		public String nextOfkinSurname;
		public String nextOfkinFirstname;
		public String nextOfkinRelationCode;
		public String nextOfkinHomeDialCode;
		public String nextOfkinHomeTelNumber;
		public String nextOfKinWorkDialCode;
		public String nextOfKinWorkTelNumber;
		public String nextOfKinCellNumber;
		public String nextOfKinEmail;
		public String nextOfKinParticipantTitleCode;
		public String nextOfKinParticipantInitials;
		public String nextOfKinParticipantSurname;
		public Integer controllerOverride;
		public String creditWorthConsentInd;
		public String casaRefNumber;
		public String registeredAddrLine1;
		public String registeredAddrLine2;
		public String registeredSuburb;
		public String registeredTown;
		public Integer registeredAddrRsaPostalCode;
		public String headOfficeAddrLine1;
		public String headOfficeAddrLine2;
		public String headOfficeSuburb;
		public String headOfficeTown;
		public Integer headOfficeRsaPostalCode;
		public String countryOfPhysicalAddrCode;
		public String countryOfHeadOfficeAddrCode;
		public String countryOfRegisteredAddrCode;
		public List<CountryEntityOprtDataTable> countryEntityOprtDataTable;
		public String countryOfBirthCode;
		public String clientAgreementIssuedInd;
		public Integer sec129DeliveryAddrCode;
		public String saTaxRegisteredInd;
		public String reasonSaTaxNotGivenCode;
		public String foreignTaxRegisteredInd;
		public List<ForeignTaxDataTable> foreignTaxDataTable;
		public String nonCreditMarketingGroupInd;
		public String nonCreditMarketingSmsInd;
		public String nonCreditMarketingEmailInd;
		public String nonCreditMarketingAutoVoiceInd;
		public String nonCreditMarketingTelephoneInd;
		public String nonCreditMarketingPostInd;
		public String creditMarketingGroupInd;
		public String creditMarketingSmsInd;
		public String creditMarketingEmailInd;
		public String creditMarketingAutoVoiceInd;
		public String creditMarketingTelephoneInd;
		public String creditMarketingPostInd;
		public Integer forecastOfMembers;
	}

	/**
	 * @description CountryEntityOprtDataTable
	 */
	public class CountryEntityOprtDataTable {
		public String countryEntOprtCode;
	}

	/**
	 * @description ForeignTaxDataTable
	 */
	public class ForeignTaxDataTable {
		public String foreignTaxCountryCode;
		public String foreignTaxNumber;
		public String reasonFtaxNotGivenCode;
	}

	/**
	 * @description CIB003I
	 */
	public class CIB003I {
		public CIcreateClientV22Request CIcreateClientV22Request;
	}

	/**
	 * @description NBSMSGI_Z
	 */
	public class NBSMSGI_Z {
		public NBSMSGI NBSMSGI;
	}

	/**
	 * @description NBSMSGI
	 */
	public class NBSMSGI {
		public String messageLanguage;
		public String messageTarget;
	}

	/**
	 * @description NBSAPLI
	 */
	public class NBSAPLI {
		public String consumerChannel;
		public String providerApplication;
		public String traceIndicator;
	}

	/**
	 * @description NBSAPDPI
	 */
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}

	  /**
     * @description Get dummy Request Bean 
     * @return CVSCreateCIFv22_Req_IB_v1
     */
	public static CVSCreateCIFv22_Req_IB_v1 createDummyRequest() {
		CVSCreateCIFv22_Req_IB_v1 requestBean = new CVSCreateCIFv22_Req_IB_v1();
		requestBean.CIB003I = new CIB003I();
		requestBean.CIB003I.CIcreateClientV22Request = new CIcreateClientV22Request();
		requestBean.CIB003I.CIcreateClientV22Request.initials = 'B';
		requestBean.CIB003I.CIcreateClientV22Request.commLanguageCode = 'E';
		requestBean.CIB003I.CIcreateClientV22Request.titleCode = '20';
		requestBean.CIB003I.CIcreateClientV22Request.surname = 'test';
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrLine1 = '270 REPL ROAD';
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrLine2= '';
		requestBean.CIB003I.CIcreateClientV22Request.postalSuburb = '';
		requestBean.CIB003I.CIcreateClientV22Request.postalTown = 'Randburg';
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrRsaCode = '2194';
		requestBean.CIB003I.CIcreateClientV22Request.idDocTypeCode = '3';
		requestBean.CIB003I.CIcreateClientV22Request.idNumber = 'PC20121984';
		requestBean.CIB003I.CIcreateClientV22Request.dateOfBirth = '19931220';
		requestBean.CIB003I.CIcreateClientV22Request.maritalStatusCode = '2';
		requestBean.CIB003I.CIcreateClientV22Request.genderCode = '2';
		requestBean.CIB003I.CIcreateClientV22Request.minorChildren ='2';
		requestBean.CIB003I.CIcreateClientV22Request.occupationCode = '1';
		requestBean.CIB003I.CIcreateClientV22Request.incomeGroupCode = '21';
		requestBean.CIB003I.CIcreateClientV22Request.marriageContractTypeCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.homeLanguageCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.clientTypeCode = '101';
		requestBean.CIB003I.CIcreateClientV22Request.voluntaryCreditConsolInd ='N';
		requestBean.CIB003I.CIcreateClientV22Request.residentialStatusCode='0';
		requestBean.CIB003I.CIcreateClientV22Request.noOfJointParticipants='0';
		requestBean.CIB003I.CIcreateClientV22Request.saTaxNumber = '0' ;
		requestBean.CIB003I.CIcreateClientV22Request.firstNames = 'Piet';
		requestBean.CIB003I.CIcreateClientV22Request.companyYearEnd = 0;
		requestBean.CIB003I.CIcreateClientV22Request.homeTelephoneDialCode = '012';
		requestBean.CIB003I.CIcreateClientV22Request.homeTelephoneNumber = '12341234';
		requestBean.CIB003I.CIcreateClientV22Request.workTelephoneDialcode =0;
		requestBean.CIB003I.CIcreateClientV22Request.workTelephoneNumber ='';
		requestBean.CIB003I.CIcreateClientV22Request.cellphoneNumber = '825190015';
		requestBean.CIB003I.CIcreateClientV22Request.workFaxDialCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.workFaxNumber = 0;
		requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumDialCode = 12;
		requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumber = '1234566';
		requestBean.CIB003I.CIcreateClientV22Request.occupationStatusCode ='1';
		requestBean.CIB003I.CIcreateClientV22Request.employmentSectorCode ='2';
		requestBean.CIB003I.CIcreateClientV22Request.occupationLevelCode ='1';
		requestBean.CIB003I.CIcreateClientV22Request.practiceNumber = '11';
		requestBean.CIB003I.CIcreateClientV22Request.clientWebsite = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.contactPerson = '';
		requestBean.CIB003I.CIcreateClientV22Request.contactPersonDesignationCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.emailAddress = 'Piet@test.com';
		requestBean.CIB003I.CIcreateClientV22Request.preferredCommMethodCode ='2';
		requestBean.CIB003I.CIcreateClientV22Request.sicCode5 = '';
		requestBean.CIB003I.CIcreateClientV22Request.sourceOfIncomeCode = '20';
		requestBean.CIB003I.CIcreateClientV22Request.dateIdentified = '20201123';
		requestBean.CIB003I.CIcreateClientV22Request.dateVerified = '20201123';
		requestBean.CIB003I.CIcreateClientV22Request.employeeIdentified = '1057488';
		requestBean.CIB003I.CIcreateClientV22Request.employeeVerified = '1057488';
		requestBean.CIB003I.CIcreateClientV22Request.vatRegistrationNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.clientNationalityCode = 'SOU01';
		requestBean.CIB003I.CIcreateClientV22Request.countryPassportIssuedCode = 'SO003';
		requestBean.CIB003I.CIcreateClientV22Request.dateExempted = 20201108;
		requestBean.CIB003I.CIcreateClientV22Request.employeeExempted = '9988334';
		requestBean.CIB003I.CIcreateClientV22Request.exemptionStatusInd ='Y';
		requestBean.CIB003I.CIcreateClientV22Request.exemptionCode = '17';
		requestBean.CIB003I.CIcreateClientV22Request.postMatricQualificationInd = 'Y';
		requestBean.CIB003I.CIcreateClientV22Request.postMatricQualificationCode = '1';
		requestBean.CIB003I.CIcreateClientV22Request.socialGrantInd = 'Y';
		requestBean.CIB003I.CIcreateClientV22Request.groupSchemeCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.groupSchemeEmp = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.secondaryPortfolioInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.excControlAffectedPersonCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.excControlExpiryDate = 0;
		requestBean.CIB003I.CIcreateClientV22Request.dateIdDocIssued = '20110101';
		requestBean.CIB003I.CIcreateClientV22Request.employerName = 'ABSA';
		requestBean.CIB003I.CIcreateClientV22Request.employerAddrLine1 = '270 REPL ROAD';
		requestBean.CIB003I.CIcreateClientV22Request.employerSuburb = '';
		requestBean.CIB003I.CIcreateClientV22Request.employerTown = 'Randburg';
		requestBean.CIB003I.CIcreateClientV22Request.employerRsaPostalCode = '2194';
		requestBean.CIB003I.CIcreateClientV22Request.physicalAddrLine1 = '270 REPL ROAD';
		requestBean.CIB003I.CIcreateClientV22Request.physicalAddrLine2 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.physicalSuburb = '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalTown = 'RANDBURG';
		requestBean.CIB003I.CIcreateClientV22Request.physicalRsaPostalCode = '2194';
		requestBean.CIB003I.CIcreateClientV22Request.businessAddrLine1 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessAddrLine2 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessSuburb = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessTown = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessRsaPostalCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.detailClassificationDataTable = new List<DetailClassificationDataTable>();
		//detailClassificationDataTable
		requestBean.CIB003I.CIcreateClientV22Request.tempResPermitNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.tempResPermitExpDate = 0;
		requestBean.CIB003I.CIcreateClientV22Request.subClassificationCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryIncorporatedCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.cpaThresholdInd = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinSurname = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinFirstname = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinRelationCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinHomeDialCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinWorkDialCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinHomeTelNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinWorkTelNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinCellNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinEmail = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantTitleCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantInitials = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantSurname = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.controllerOverride = 0;
		requestBean.CIB003I.CIcreateClientV22Request.creditWorthConsentInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.casaRefNumber = '888';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrLine1 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrLine2 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredSuburb = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredTown = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrRsaPostalCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeAddrLine1 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeAddrLine2 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeSuburb = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeTown = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeRsaPostalCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.countryOfPhysicalAddrCode = 'SO003';
		requestBean.CIB003I.CIcreateClientV22Request.countryOfHeadOfficeAddrCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryOfRegisteredAddrCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryEntityOprtDataTable = new List<CountryEntityOprtDataTable>();

		CountryEntityOprtDataTable countryEntityitem = new CountryEntityOprtDataTable();
		countryEntityitem.countryEntOprtCode = ' ';

		requestBean.CIB003I.CIcreateClientV22Request.countryEntityOprtDataTable.Add(countryEntityitem);
		requestBean.CIB003I.CIcreateClientV22Request.countryOfBirthCode = 'SO003';
		requestBean.CIB003I.CIcreateClientV22Request.clientAgreementIssuedInd = 'Y';
		requestBean.CIB003I.CIcreateClientV22Request.sec129DeliveryAddrCode = 1;
		requestBean.CIB003I.CIcreateClientV22Request.saTaxRegisteredInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.reasonSaTaxNotGivenCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.foreignTaxRegisteredInd = 'Y';
		requestBean.CIB003I.CIcreateClientV22Request.foreignTaxDataTable = new List<ForeignTaxDataTable>();
		ForeignTaxDataTable foreignTaxData = new ForeignTaxDataTable();
		foreignTaxData.foreignTaxCountryCode = ' ';
		foreignTaxData.foreignTaxNumber = ' ';
		foreignTaxData.reasonFtaxNotGivenCode = '1';
		requestBean.CIB003I.CIcreateClientV22Request.foreignTaxDataTable.Add(ForeignTaxData);
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingGroupInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingSmsInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingEmailInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingAutoVoiceInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingTelephoneInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingGroupInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingSmsInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingEmailInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingAutoVoiceInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingTelephoneInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.forecastOfMembers = 0;
		return requestBean;
	}

	/**
     * @description Get dummy Request Bean 
     * @return CVSCreateCIFv22_Req_IB_v1
     */
    public static CVSCreateCIFv22_Req_IB_v1 getNewInstance()
    {
        CVSCreateCIFv22_Req_IB_v1 requestBean =  new CVSCreateCIFv22_Req_IB_v1();
		requestBean.NBSAPDPI = new CVSCreateCIFv22_Req_IB_v1.NBSAPDPI();
		requestBean.NBSAPDPI.NBSAPLI = new CVSCreateCIFv22_Req_IB_v1.NBSAPLI();
		requestBean.NBSMSGI = new CVSCreateCIFv22_Req_IB_v1.NBSMSGI_Z();
        requestBean.NBSMSGI.NBSMSGI = new CVSCreateCIFv22_Req_IB_v1.NBSMSGI();
    	requestBean.CIB003I = new CVSCreateCIFv22_Req_IB_v1.CIB003I();
        requestBean.CIB003I.CIcreateClientV22Request = new CVSCreateCIFv22_Req_IB_v1.CIcreateClientV22Request();
        requestBean.CIB003I.CIcreateClientV22Request.detailClassificationDataTable = new List<CVSCreateCIFv22_Req_IB_v1.DetailClassificationDataTable>();
        requestBean.CIB003I.CIcreateClientV22Request.countryEntityOprtDataTable = new List<CVSCreateCIFv22_Req_IB_v1.CountryEntityOprtDataTable>();
		requestBean.CIB003I.CIcreateClientV22Request.foreignTaxDataTable = new List<CVSCreateCIFv22_Req_IB_v1.ForeignTaxDataTable>();
		return requestBean;
    }


   public override void setIntegrationTranslations()
   {
     integrationTranslationsMap = new Map<String, String>();
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.titleCode','CIFCodesList;Titles' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.sourceOfIncomeCode','CIFCodesList;Sofsoi' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.countryOfBirthCode','CIFCodesList;Casa Country' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.clientNationalityCode','CIFCodesList;Nationality' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.countryPassportIssuedCode','CIFCodesList;Casa Country' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.countryOfPhysicalAddrCode','CIFCodesList;Casa Country' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.countryOfHeadOfficeAddrCode','CIFCodesList;Casa Country' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.countryOfRegisteredAddrCode','CIFCodesList;Casa Country' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.idDocTypeCode','CIFCodesList;Idtype' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.maritalStatusCode','CIFCodesList;Maritstat' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.marriageContractTypeCode','CIFCodesList;Marrcontype' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.homeLanguageCode','CIFCodesList;Lang' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.commLanguageCode','CIFCodesList;Lang' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.nextOfkinRelationCode','CIFCodesList;Nextofkinrelationship' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.preferredCommMethodCode','CIFCodesList;Prefcomms' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.occupationCode','CIFCodesList;Occucode' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.occupationStatusCode','CIFCodesList;Emplstatus' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.genderCode','CIFCodesList;Gender' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.occupationLevelCode','CIFCodesList;Occulvl' );
     integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.employmentSectorCode','CIFCodesList;Emplsector' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.postMatricQualificationCode','CIFCodesList;Postmatq' );
	 integrationTranslationsMap.put('CIB003I.CIcreateClientV22Request.reasonSaTaxNotGivenCode','CIFCodesList;ReasonSATaxNotGiven' );
   }

}