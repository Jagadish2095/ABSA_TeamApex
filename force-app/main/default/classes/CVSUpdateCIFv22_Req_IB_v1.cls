/**
 * @description CVSCreateCIFv22_Req_IB_v1 Request Bean
 * @author  Paul du Randt
 * @created 2020-09-18
 */

public class CVSUpdateCIFv22_Req_IB_v1 extends Base_IB {

	public CIB004I CIB004I;
	public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;

	/**
	 * @description DetailClassificationDataTable
	 */
	public class DetailClassificationDataTable {
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
	 * @description CIupdateClientDetailsV22Request
	 */
	public class CIupdateClientDetailsV22Request {
		public String clientCode;
		public String securityInd;
		public String liabilityInd;
		public String telephonebankingInd;
		public String unclaimedFundsInd;
		public String postalAddrHoldInd;
		public String absaRewardInd;
		public String idRequiredHoldInd;
		public String deceasedEstateHoldInd;
		public String deceasedSpouseHoldInd;
		public String insolventEstateHoldInd;
		public String curatorshipHoldInd;
		public String savingStatementHoldInd;
		public String insolventInd;
		public String physicalAddrHoldInd;
		public String employerAddrHoldInd;
		public String internalLifePolicyInd;
		public String externalLifePolicyInd;
		public String internalShortTermPolicyInd;
		public String externalShortTermPolicyInd;
		public String internalInvestmentPolicyInd;
		public String cellphoneBankingInd;
		public String internetBankingInd;
		public String debtCounselAppliedInd;
		public String debtCounselAppliedDate;
		public String notifyMeInd;
		public String debtCounselOrderIssuedInd;
		public String inbusinessRescueAffectedInd;
		public String debtCounselOrderIssuedDate;
		public String inBusinessRescuePlacedByCode;
		public String inBusinessRescueIssuedDate;
		public String inBusinessRescueInd;
		public String flexiFuneralPolicyInd;
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
		public String companyYearEnd;
		public String homeTelephoneDialCode;
		public String homeTelephoneNumber;
		public String workTelephoneDialcode;
		public String workTelephoneNumber;
		public String cellphoneNumber;
		public String workFaxDialCode;
		public String workFaxNumber;
		public String homeFaxOrAlternativeNumDialCode;
		public String homeFaxOrAlternativeNumber;
		public String occupationStatusCode;
		public String employmentSectorCode;
		public String occupationLevelCode;
		public String practiceNumber;
		public String clientWebsite;
		public String contactPerson;
		public String contactPersonDesignationCode;
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
		public String dateExempted;
		public String employeeExempted;
		public String exemptionStatusInd;
		public String exemptionCode;
		public String postMatricQualificationInd;
		public String postMatricQualificationCode;
		public String socialGrantInd;
		public String groupSchemeCode;
		public String groupSchemeEmp;
		public String secondaryPortfolioInd;
		public String excControlAffectedPersonCode;
		public String excControlExpiryDate;
		public String dateIdDocIssued;
		public String employerName;
		public String employerAddrLine1;
		public String employerSuburb;
		public String employerTown;
		public String employerRsaPostalCode;
		public String physicalAddrLine1;
		public String physicalAddrLine2;
		public String physicalSuburb;
		public String physicalTown;
		public String physicalRsaPostalCode;
		public String businessAddrLine1;
		public String businessAddrLine2;
		public String businessSuburb;
		public String businessTown;
		public String businessRsaPostalCode;
		public List<DetailClassificationDataTable> detailClassificationDataTable;
		public String tempResPermitNumber;
		public String tempResPermitExpDate;
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
		public String controllerOverride;
		public String creditWorthConsentInd;
		public String casaRefNumber;
		public String registeredAddrLine1;
		public String registeredAddrLine2;
		public String registeredSuburb;
		public String registeredTown;
		public String registeredAddrRsaPostalCode;
		public String headOfficeAddrLine1;
		public String headOfficeAddrLine2;
		public String headOfficeSuburb;
		public String headOfficeTown;
		public String headOfficeRsaPostalCode;
		public String countryOfPhysicalAddrCode;
		public String countryOfHeadOfficeAddrCode;
		public String countryOfRegisteredAddrCode;
		public List<CountryEntityOprtDataTable> countryEntityOprtDataTable;
		public String countryOfBirthCode;
		public String clientAgreementIssuedInd;
		public String sec129DeliveryAddrCode;
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
		public String forecastOfMembers;
	}

	/**
	 * @description CIB004I
	 */
	public class CIB004I {
		public CIupdateClientDetailsV22Request CIupdateClientDetailsV22Request;
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
     * @description createDummyRequest
     * @return CVSCreateCIFv22_Req_IB_v1
     */
    public static CVSUpdateCIFv22_Req_IB_v1 createDummyRequest() {
		CVSUpdateCIFv22_Req_IB_v1 requestBean = new CVSUpdateCIFv22_Req_IB_v1();
		requestBean.CIB004I = new CIB004I();
		requestBean.CIB004I.CIupdateClientDetailsV22Request = new CIupdateClientDetailsV22Request();

		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.securityInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.liabilityInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.telephonebankingInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.unclaimedFundsInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.absaRewardInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idRequiredHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.deceasedEstateHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.deceasedSpouseHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.insolventEstateHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.curatorshipHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.savingStatementHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.insolventInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerAddrHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalLifePolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.externalLifePolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalShortTermPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.externalShortTermPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalInvestmentPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneBankingInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internetBankingInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselAppliedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselAppliedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.notifyMeInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselOrderIssuedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inbusinessRescueAffectedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselOrderIssuedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescuePlacedByCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescueIssuedDate = '20200505';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescueInd = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.flexiFuneralPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.initials = 'NRK';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.commLanguageCode = 'E';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.titleCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.surname = 'ESTATE LATEVUSI';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrLine1 = '123 zone';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrLine2 = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalSuburb = 'town';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalTown = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrRsaCode = '2001';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idDocTypeCode = '3';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idNumber = '1930718';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateOfBirth = '19840718';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.maritalStatusCode = '2';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.genderCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.minorChildren = '2';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.incomeGroupCode = '21';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.marriageContractTypeCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeLanguageCode = '5';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientTypeCode = '101';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.voluntaryCreditConsolInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.residentialStatusCode = 'O';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.noOfJointParticipants = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxNumber = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.firstNames = 'SURYARAO';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.companyYearEnd = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneDialCode = '012';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneNumber = '8933322';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneDialcode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneNumber = '825190013';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxDialCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxNumber = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumDialCode = '11';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumber = '12345';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationStatusCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employmentSectorCode = '2';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationLevelCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.practiceNumber = '12345';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientWebsite = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPerson = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPersonDesignationCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.emailAddress = 'vusilikotsi@yahoo.com';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.preferredCommMethodCode = '2';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sicCode5 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sourceOfIncomeCode = '20';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdentified = '20201113';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateVerified = '20201113';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeIdentified = '1057488';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeVerified = '1057488';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.vatRegistrationNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientNationalityCode = 'SOU01';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryPassportIssuedCode = 'SO003';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateExempted = '20201013';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeExempted = 'Y';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionStatusInd = 'Y';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionCode = '04';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.socialGrantInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeEmp = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.secondaryPortfolioInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlAffectedPersonCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlExpiryDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdDocIssued = '19890608';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerName = 'ABSA';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerAddrLine1 = '12 REJR';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerSuburb = 'JHB';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerTown = 'JHB';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerRsaPostalCode = '2001';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrLine1 = '12 2K34';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrLine2 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalSuburb = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalTown = 'VALL';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalRsaPostalCode = '2001';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessAddrLine1 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessAddrLine2 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessSuburb = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessTown = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessRsaPostalCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.detailClassificationDataTable = new List<DetailClassificationDataTable>();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitExpDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.subClassificationCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryIncorporatedCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cpaThresholdInd = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinSurname = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinFirstname = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinRelationCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeDialCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeTelNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkDialCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkTelNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinCellNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinEmail = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantTitleCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantInitials = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantSurname = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.controllerOverride = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditWorthConsentInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.casaRefNumber = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrLine1 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrLine2 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredSuburb = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredTown = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrRsaPostalCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeAddrLine1 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeAddrLine2 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeSuburb = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeTown = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeRsaPostalCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfPhysicalAddrCode = 'SO003';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfHeadOfficeAddrCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfRegisteredAddrCode = 'SO003';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryEntityOprtDataTable = new List<CountryEntityOprtDataTable>();
		CountryEntityOprtDataTable CountryEntityitem = new CountryEntityOprtDataTable();
		CountryEntityitem.countryEntOprtCode = ' ';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryEntityOprtDataTable.Add(CountryEntityitem);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfBirthCode = 'SO003';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientAgreementIssuedInd = 'Y';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sec129DeliveryAddrCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxRegisteredInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.reasonSaTaxNotGivenCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxRegisteredInd = 'Y';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxDataTable = new List<ForeignTaxDataTable>();
		ForeignTaxDataTable foreignTaxData = new ForeignTaxDataTable();
		foreignTaxData.foreignTaxCountryCode = ' ';
		foreignTaxData.foreignTaxNumber = ' ';
		foreignTaxData.reasonFtaxNotGivenCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxDataTable.Add(ForeignTaxData);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingGroupInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingSmsInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingEmailInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingAutoVoiceInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingTelephoneInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingPostInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingGroupInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingSmsInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingEmailInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingAutoVoiceInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingTelephoneInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingPostInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.forecastOfMembers = '0';
		return requestBean;
	}

    /**
     * @description createDummyRequest
     * @return CVSUpdateCIFv22_Req_IB_v1
     */
	  public static CVSUpdateCIFv22_Req_IB_v1 getNewInstance(){
        CVSUpdateCIFv22_Req_IB_v1 requestBean =  new CVSUpdateCIFv22_Req_IB_v1();
		 requestBean.NBSAPDPI = new CVSUpdateCIFv22_Req_IB_v1.NBSAPDPI();
		 requestBean.NBSAPDPI.NBSAPLI = new CVSUpdateCIFv22_Req_IB_v1.NBSAPLI();
		 requestBean.NBSMSGI = new CVSUpdateCIFv22_Req_IB_v1.NBSMSGI_Z();
         requestBean.NBSMSGI.NBSMSGI = new CVSUpdateCIFv22_Req_IB_v1.NBSMSGI();
    	 requestBean.CIB004I = new CVSUpdateCIFv22_Req_IB_v1.CIB004I();
         requestBean.CIB004I.CIupdateClientDetailsV22Request = new CVSUpdateCIFv22_Req_IB_v1.CIupdateClientDetailsV22Request();
         requestBean.CIB004I.CIupdateClientDetailsV22Request.detailClassificationDataTable = new List<CVSUpdateCIFv22_Req_IB_v1.DetailClassificationDataTable>();
         requestBean.CIB004I.CIupdateClientDetailsV22Request.countryEntityOprtDataTable = new List<CVSUpdateCIFv22_Req_IB_v1.CountryEntityOprtDataTable>();
		 requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxDataTable = new List<CVSUpdateCIFv22_Req_IB_v1.ForeignTaxDataTable>();
		return requestBean;
    }

	public override void setIntegrationTranslations(){
    	integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.titleCode','CIFCodesList;Titles' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.sourceOfIncomeCode','CIFCodesList;Sofsoi;99' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.countryOfBirthCode','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.clientNationalityCode','CIFCodesList;Nationality' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.countryPassportIssuedCode','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.countryOfPhysicalAddrCode','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.countryOfHeadOfficeAddrCode','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.countryOfRegisteredAddrCode','CIFCodesList;Casa Country' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.idDocTypeCode','CIFCodesList;Idtype' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.maritalStatusCode','CIFCodesList;Maritstat' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.marriageContractTypeCode','CIFCodesList;Marrcontype' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.homeLanguageCode','CIFCodesList;Lang' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.commLanguageCode','CIFCodesList;Lang' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.nextOfkinRelationCode','CIFCodesList;Nextofkinrelationship' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.preferredCommMethodCode','CIFCodesList;Prefcomms' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.occupationCode','CIFCodesList;Occucode' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.occupationStatusCode','CIFCodesList;Emplstatus' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.occupationLevelCode','CIFCodesList;Occulvl' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationCode','CIFCodesList;Postmatq' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.clientTypeCode','CIFCodesList; Ib Client Type' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.employmentSectorCode','CIFCodesList;Emplsector' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.genderCode','CIFCodesList;Gender' );
		integrationTranslationsMap.put('CIB004I.CIupdateClientDetailsV22Request.reasonSaTaxNotGivenCode','CIFCodesList;ReasonSATaxNotGiven' );
	 //Add
    }
}