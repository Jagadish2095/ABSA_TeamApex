/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-10-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class StokvelEntityCasaCIFController
{
	public static final String FAILED = 'FAILED';
	public static final String PROCEED = 'PROCEED';
	public static final String MATCHED = 'MATCHED';
	public static final String COMPLETE = 'COMPLETE';
	public static final String INCOMPLETE = 'INCOMPLETE';
	public static final String INCOMPLETE_RISK = 'INCOMPLETE-RISK';
	public static final String INCOMPLETE_PARTY = 'INCOMPLETE-PARTY';
	public static final String CANCELLED = 'CANCELlED';
	public static final String PENDING_APPROVAL = 'PENDING_APPROVAL';
	public static final String DECLINED = 'DECLINED';
	public static final String CONTINUE_STRING = 'CONTINUE';

	/**
	 * @description Method that get Entity Casa status,
	 *
	 * @param accountRecId -for main account.
	 * @return Changed value> - list accounts with CASA fields
	 */
	@AuraEnabled
	public static StokvelWrapper getEntityCasastatus(String accountRecId) {
		List<EntityWrapper> wrapperList = new List<EntityWrapper>();
		List<RelatedPartyWrapper> relatedwrapperList = new List<RelatedPartyWrapper>();
		StokvelWrapper stokvlwrapper = new StokvelWrapper();
		Account accountRecord = [
			SELECT Id, Name, CASA_Reference_Number__c, CASA_Screening_Status__c,Valid_Update_Bypass__c
			FROM Account
			WHERE Id = :accountRecId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		String Status = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(accountRecord.CASA_Reference_Number__c);
		accountRecord.Valid_Update_Bypass__c = true;
		accountRecord.CASA_Screening_Status__c = Status;
		update accountRecord;

		StokvelWrapper wrapper = new StokvelWrapper();
		EntityWrapper mainAcc = new EntityWrapper();
		mainAcc.entityName = accountRecord.Name;
		mainAcc.casaRefNumber = accountRecord.CASA_Reference_Number__c;
		mainAcc.status = Status;
		wrapperList.add(mainAcc);
		stokvlwrapper.mainAccount = wrapperList;
/*
		List<AccountContactRelation> relatedParty = AccountContactController.getRelatedAccounts(accountRecId);
		List<ID> contactids = new List<ID>();
		for (AccountContactRelation accountcontactrelation : relatedParty) {
			contactids.add(accountcontactrelation.ContactId);
		}

		List<Account> stokvelrelatedParty = AccountContactController.GetAccountRelatedpartyDetails(contactids);
		for (Account accountstokvel : stokvelrelatedParty) {
			RelatedPartyWrapper relwrapper = new RelatedPartyWrapper();
			relwrapper.relatedPartyaccountID = accountstokvel.Id;
			String relStatus = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(accountstokvel.CASA_Reference_Number__c);
			relwrapper.status = relStatus;
			
			relwrapper.relatedPartyName = accountstokvel.FirstName;
			relwrapper.relatedPartySurName = accountstokvel.LastName;
			relwrapper.relatedPartyId = accountstokvel.ID_Number__pc;
			relwrapper.casaRefNumber = accountstokvel.CASA_Reference_Number__c;
			relwrapper.relatedPartyScreeningdate = accountstokvel.CASA_Screening_Date__c;
			relatedwrapperList.add(relwrapper);
		}
		stokvlwrapper.relatedparty = relatedwrapperList;
*/
		return stokvlwrapper;
	}
	/**
	 * @description Method that get Entity Casa status,
	 *
	 * @param accountRecId -for main account.
	 * @return Changed value> - list accounts with CASA fields
	 */
	@AuraEnabled
	public static StokvelWrapper getrelatedCasastatus(String accountRecId) {
		List<EntityWrapper> wrapperList = new List<EntityWrapper>();
		List<RelatedPartyWrapper> relatedwrapperList = new List<RelatedPartyWrapper>();
		StokvelWrapper stokvlwrapper = new StokvelWrapper();
	/*	Account accountRecord = [
			SELECT Id, Name, CASA_Reference_Number__c, CASA_Screening_Status__c,Valid_Update_Bypass__c
			FROM Account
			WHERE Id = :accountRecId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		String Status = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(accountRecord.CASA_Reference_Number__c);
		accountRecord.Valid_Update_Bypass__c = true;
		accountRecord.CASA_Screening_Status__c = Status;
		update accountRecord;

		StokvelWrapper wrapper = new StokvelWrapper();
		EntityWrapper mainAcc = new EntityWrapper();
		mainAcc.entityName = accountRecord.Name;
		mainAcc.casaRefNumber = accountRecord.CASA_Reference_Number__c;
		mainAcc.status = Status;
		wrapperList.add(mainAcc);
		stokvlwrapper.mainAccount = wrapperList;
*/
		List<AccountContactRelation> relatedParty = AccountContactController.getRelatedAccounts(accountRecId);
		List<ID> contactids = new List<ID>();
		for (AccountContactRelation accountcontactrelation : relatedParty) {
			contactids.add(accountcontactrelation.ContactId);
		}

		List<Account> stokvelrelatedParty = AccountContactController.GetAccountRelatedpartyDetails(contactids);
		for (Account accountstokvel : stokvelrelatedParty) {
			RelatedPartyWrapper relwrapper = new RelatedPartyWrapper();
			relwrapper.relatedPartyaccountID = accountstokvel.Id;
			String relStatus = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(accountstokvel.CASA_Reference_Number__c);
			relwrapper.status = relStatus;
			relwrapper.relatedPartyName = accountstokvel.FirstName;
			relwrapper.relatedPartySurName = accountstokvel.LastName;
			relwrapper.relatedPartyId = accountstokvel.ID_Number__pc;
			relwrapper.casaRefNumber = accountstokvel.CASA_Reference_Number__c;
			relwrapper.relatedPartyScreeningdate = accountstokvel.CASA_Screening_Date__c;
			relatedwrapperList.add(relwrapper);
		}
		stokvlwrapper.relatedparty = relatedwrapperList;

		return stokvlwrapper;
	}
	/**
	 * @description EntityWrapper Description
	 */
	public class EntityWrapper {
		@AuraEnabled
		public String entityName;
		@AuraEnabled
		public String casaRefNumber;
		@AuraEnabled
		public String status;
	}

	/**
	 * @description RelatedPartyWrapper Description
	 */
	public class RelatedPartyWrapper {
		@AuraEnabled
		public String relatedPartyaccountID;
		@AuraEnabled
		public String relatedPartyName;
		@AuraEnabled
		public String relatedPartySurName;
		@AuraEnabled
		public String relatedPartyId;
		@AuraEnabled
		public date relatedPartyScreeningdate;
		@AuraEnabled
		public String casaRefNumber;
		@AuraEnabled
		public String status;
	}
	/**
	 * @description Controller class for Account Contact Wrapper
	 * @author  Happy
	 * @created 2020-11-12
	 */
	public without sharing class StokvelWrapper {
		@AuraEnabled
		public List<EntityWrapper> mainAccount;
		@AuraEnabled
		public List<RelatedPartyWrapper> relatedparty;
	}

	/**
	 * @description Method check if CIFKey exist
	 * @param accountId - main account id.
	 * @return string
	 */

	@AuraEnabled
	public static String checkifCIFExist(Id accountId) {
		String cifKey = '';
		Account accountRecord = [SELECT ID, CIF__c FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED LIMIT 1];
		if (accountRecord != null) {
			cifKey = accountRecord.CIF__c;
		}

		if (cifKey != '') {
			string response = updateCIF(accountRecord.ID);
		}
		return cifKey;
	}

	/**
	 * @description Method create CIF
	 *
	 * @param accountId - main account id.
	 * @return string
	 */
	@AuraEnabled
	public static String createstokvelCIF(Id accountId) {
		Account accountObject = [
			SELECT
				Id,
				CASA_Reference_Number__c,
				Phone,
				Country_of_Incorporation__c,
				Country_of_Registration__c,
				RepresetentiveName__c,
				RepresentativeLastname__c,
				Date_Identified__c,
				Date_Verified__c,
				Active_Email__c,
				Number_of_Participants__c,
				Communication_Method__c,
				Name
			FROM Account
			WHERE ID = :accountId
			WITH SECURITY_ENFORCED
		];
		CVSCreateCIFv22_Req_IB_v1 requestBean = CVSCreateCIFv22_Req_IB_v1.getNewInstance();

		requestBean = StokvelEntityCasaCIFController.getAccountPopulatedCreateRequest(accountId);
		CVSCreateCIFv22_Resp_IB_v1 cvsCreateCIFv22resp = CVSCreateCIFv22_IH_v1.CVSCreateCIFv22(requestBean, 'nonIndividual'); //(requestBean);
		if (CVSCreateCIFv22resp.body != null) {
			if (
				CVSCreateCIFv22resp.body.CIB003O.CIcreateClientV22Response.outputClientKey != null &
				CVSCreateCIFv22resp.body.CIB003O.CIcreateClientV22Response.outputClientKey != ''
			) {
				accountObject.Valid_Update_Bypass__c= true;
				accountObject.CIF__c = cvsCreateCIFv22resp.body.CIB003O.CIcreateClientV22Response.outputClientKey;
				update accountObject;
				return JSON.serializePretty(cvsCreateCIFv22resp);
			} else {
				if (CVSCreateCIFv22resp.body.NBSMSGO3.nbsmsgo3.msgEntry != null) {
					for (CVSCreateCIFv22_Resp_IB_v1.MsgEntry mess : CVSCreateCIFv22resp.body.NBSMSGO3.nbsmsgo3.msgEntry) {
						if (mess.msgErrInd == 'Y') {
							return JSON.serializePretty(CVSCreateCIFv22resp);
						}
					}
				}
				return JSON.serializePretty(CVSCreateCIFv22resp);
			}
		} else {
			return JSON.serializePretty(CVSCreateCIFv22resp);
		}
	}
	/**
	 * @description Method getAddessByType
	 *@param accountId - main account id.
	 * @param addressType - addressType.
	 * @return Address__c
	 */
	public static Address__c getAddessByType(String accountId, String addressType) {
		Address__c selectedAddress = [
			SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :accountId AND Address_TYpe__c = :addressType
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		return selectedAddress;
	}
	/**
	 * @description getAccountPopulatedCreateRequest
	 *
	 * @param accountId - main account id.
	 * @return CVSCreateCIFv22_Req_IB_v1
	 */
	private static CVSCreateCIFv22_Req_IB_v1 getAccountPopulatedCreateRequest(Id accountId) {
		Usersselector us = new Usersselector();
		List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
		//    Account account = new AccountsSelector().selectAllById(accountId);
		Account accountObject = [
			SELECT
				Id,
				CASA_Reference_Number__c,
				Phone,
				Country_of_Incorporation__c,
				Country_of_Registration__c,
				RepresetentiveName__c,
				RepresentativeLastname__c,
				Date_Identified__c,
				Date_Verified__c,
				Active_Email__c,
				Number_of_Participants__c,
				Communication_Method__c,
				Name,
				Preferred_Communication_Method__c,
				Language__c
			FROM Account
			WHERE ID = :accountId
			WITH SECURITY_ENFORCED
		];
		List<AccountContactRelation> stokvelrelatedPartyController = AccountContactController.getRelatedAccounts(accountId);

		//get controller of stokvel
		AccountContactRelation accountcontroler = AccountContactController.GetAccountContactController(accountId);
		Account accountcontrolerdetail = AccountContactController.GetAccountControllerDetails(accountcontroler.ContactId);
		// pls dod a null check
		Address__c postalAddress = getAddessByType(accountcontrolerdetail.Id, 'Postal');
		Address__c residentialAddress = getAddessByType(accountcontrolerdetail.Id, 'Residential');

		CVSCreateCIFv22_Req_IB_v1 requestBean = CVSCreateCIFv22_Req_IB_v1.getNewInstance();
		requestBean.CIB003I.CIcreateClientV22Request.businessAddrLine1 = (residentialAddress != null &&
			residentialAddress.Shipping_Street__c != null)
			? residentialAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.businessAddrLine2 = (residentialAddress != null &&
			residentialAddress.Address2__c != null)
			? residentialAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.businessSuburb = (residentialAddress != null &&
			residentialAddress.Shipping_Suburb__c != null)
			? residentialAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.businessTown = (residentialAddress != null &&
			residentialAddress.Shipping_City__c != null)
			? residentialAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.businessRsaPostalCode = (residentialAddress != null &&
			residentialAddress.Shipping_Zip_Postal_Code__c != null)
			? residentialAddress.Shipping_Zip_Postal_Code__c
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.casaRefNumber = (accountObject.CASA_Reference_Number__c != null)
			? accountObject.CASA_Reference_Number__c
			: '0';
		//    }
		requestBean.CIB003I.CIcreateClientV22Request.cellphoneNumber = accountcontrolerdetail.PersonMobilePhone;
		 //.substring(1, 9);
		//system.debug('wawa' + requestBean.CIB003I.CIcreateClientV22Request.cellphoneNumber);
		requestBean.CIB003I.CIcreateClientV22Request.clientAgreementIssuedInd = 'Y';
		requestBean.CIB003I.CIcreateClientV22Request.clientNationalityCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.clientTypeCode = '07401';
		requestBean.CIB003I.CIcreateClientV22Request.clientWebsite = '';
		requestBean.CIB003I.CIcreateClientV22Request.commLanguageCode = accountObject.Language__c.substring(0, 1);
		requestBean.CIB003I.CIcreateClientV22Request.companyYearEnd = 0;
		requestBean.CIB003I.CIcreateClientV22Request.contactPerson = accountcontrolerdetail.FirstName+ ' ' + 
		accountcontrolerdetail.LastName;
		requestBean.CIB003I.CIcreateClientV22Request.contactPersonDesignationCode = 1;
		requestBean.CIB003I.CIcreateClientV22Request.controllerOverride = 0;

		string countryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Country',
			accountObject.Country_of_Incorporation__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		string countryOfPhysical = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Country',
			accountObject.Country_of_Registration__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		CVSCreateCIFv22_Req_IB_v1.CountryEntityOprtDataTable countryEntityitem = new CVSCreateCIFv22_Req_IB_v1.CountryEntityOprtDataTable();
		countryEntityitem.countryEntOprtCode = countryTranslated;
		requestBean.CIB003I.CIcreateClientV22Request.countryEntityOprtDataTable.Add(countryEntityitem);
		requestBean.CIB003I.CIcreateClientV22Request.countryIncorporatedCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryOfBirthCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryOfHeadOfficeAddrCode = countryTranslated;
		requestBean.CIB003I.CIcreateClientV22Request.countryOfPhysicalAddrCode = countryOfPhysical;
		requestBean.CIB003I.CIcreateClientV22Request.countryOfRegisteredAddrCode = countryOfPhysical;
		requestBean.CIB003I.CIcreateClientV22Request.countryPassportIssuedCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.cpaThresholdInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingAutoVoiceInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingEmailInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingGroupInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingSmsInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingTelephoneInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditWorthConsentInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.dateExempted = 0;
		requestBean.CIB003I.CIcreateClientV22Request.dateIdDocIssued = '0';
		requestBean.CIB003I.CIcreateClientV22Request.dateOfBirth = '0';
		string dtIdentified = '0';

		dtIdentified = (datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day())).format('yyyyMMdd');

		string dtVerified = '0';

		dtVerified = (datetime.newInstance(Date.today().year(), Date.today().month(), Date.today().day())).format('yyyyMMdd');

		requestBean.CIB003I.CIcreateClientV22Request.dateVerified = dtVerified;
		requestBean.CIB003I.CIcreateClientV22Request.dateIdentified = dtIdentified;

		requestBean.CIB003I.CIcreateClientV22Request.detailClassificationDataTable = new List<CVSCreateCIFv22_Req_IB_v1.DetailClassificationDataTable>();
		requestBean.CIB003I.CIcreateClientV22Request.emailAddress = accountcontrolerdetail.PersonEmail;

		requestBean.CIB003I.CIcreateClientV22Request.employeeIdentified = userP[0].Teller_Operator_Code__c;
		requestBean.CIB003I.CIcreateClientV22Request.employeeVerified = userP[0].Teller_Operator_Code__c;
		requestBean.CIB003I.CIcreateClientV22Request.employeeExempted = ' ';
		//Employer
		requestBean.CIB003I.CIcreateClientV22Request.employerName = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.employerAddrLine1 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.employerRsaPostalCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.employerSuburb = '';
		requestBean.CIB003I.CIcreateClientV22Request.employerTown = '';
		requestBean.CIB003I.CIcreateClientV22Request.employmentSectorCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.excControlAffectedPersonCode = 0;

		requestBean.CIB003I.CIcreateClientV22Request.excControlExpiryDate = 0;
		requestBean.CIB003I.CIcreateClientV22Request.exemptionCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.exemptionStatusInd = 'N';

		string numberOfParticipants = string.valueOf(accountObject.Number_of_Participants__c);

		requestBean.CIB003I.CIcreateClientV22Request.firstNames = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.forecastOfMembers = Integer.valueOf(numberOfParticipants);
		requestBean.CIB003I.CIcreateClientV22Request.foreignTaxRegisteredInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.foreignTaxDataTable = new List<CVSCreateCIFv22_Req_IB_v1.ForeignTaxDataTable>();

		requestBean.CIB003I.CIcreateClientV22Request.genderCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.groupSchemeCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.groupSchemeEmp = '';

		requestBean.CIB003I.CIcreateClientV22Request.headOfficeAddrLine1 = (postalAddress != null &&
			postalAddress.Shipping_Street__c != null)
			? postalAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeAddrLine2 = (postalAddress != null &&
			postalAddress.Address2__c != null)
			? postalAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeSuburb = (postalAddress != null &&
			postalAddress != null &&
			postalAddress.Shipping_Suburb__c != null)
			? postalAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeTown = (postalAddress != null &&
			postalAddress.Shipping_City__c != null)
			? postalAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeRsaPostalCode = integer.valueof(
			(postalAddress != null && postalAddress.Shipping_Zip_Postal_Code__c != null) ? postalAddress.Shipping_Zip_Postal_Code__c : '0'
		);

		requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumber = '0';
		requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumDialCode = 0;

		requestBean.CIB003I.CIcreateClientV22Request.homeLanguageCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.homeTelephoneDialCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.homeTelephoneNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.idDocTypeCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.idNumber = '';
		requestBean.CIB003I.CIcreateClientV22Request.incomeGroupCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.initials = '';

		requestBean.CIB003I.CIcreateClientV22Request.maritalStatusCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.marriageContractTypeCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.minorChildren = '';

		//Next of Kin
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinCellNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinEmail = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinFirstname = '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinHomeDialCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinHomeTelNumber = '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantInitials = '';

		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantSurname = '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantTitleCode = '0';

		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinRelationCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinSurname = '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinWorkDialCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinWorkTelNumber = '';
		//NON redit marketing indicator
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingAutoVoiceInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingEmailInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingGroupInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingSmsInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingTelephoneInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.noOfJointParticipants = '0';

		requestBean.CIB003I.CIcreateClientV22Request.occupationCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.occupationLevelCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.occupationStatusCode = '0';

		requestBean.CIB003I.CIcreateClientV22Request.physicalAddrLine1 = '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalAddrLine2 = '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalRsaPostalCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.physicalSuburb = '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalTown = '';

		requestBean.CIB003I.CIcreateClientV22Request.postalAddrLine1 = (postalAddress != null &&
			postalAddress.Shipping_Street__c != null)
			? postalAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrLine2 = (postalAddress != null &&
			postalAddress.Address2__c != null)
			? postalAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.postalSuburb = (postalAddress != null &&
			postalAddress.Shipping_Suburb__c != null)
			? postalAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.postalTown = (postalAddress != null &&
			postalAddress.Shipping_City__c != null)
			? postalAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrRsaCode = (postalAddress != null &&
			postalAddress.Shipping_Zip_Postal_Code__c != null)
			? postalAddress.Shipping_Zip_Postal_Code__c
			: '0';

		requestBean.CIB003I.CIcreateClientV22Request.postMatricQualificationCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.postMatricQualificationInd = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.practiceNumber = '';
		string prefferdCommunicationMethod = accountObject.Preferred_Communication_Method__c;
		if (prefferdCommunicationMethod == 'Post') {
			prefferdCommunicationMethod = 'Mail';
		}

		requestBean.CIB003I.CIcreateClientV22Request.preferredCommMethodCode = StokvelEntityCasaCIFController.getTranslationValues(
			'CIFCodesList',
			prefferdCommunicationMethod,
			'Prefcomms',
			'Outbound'
		); //prefermethod;

		requestBean.CIB003I.CIcreateClientV22Request.reasonSaTaxNotGivenCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrLine1 = (residentialAddress != null &&
			residentialAddress.Shipping_Street__c != null)
			? residentialAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrLine2 = (residentialAddress != null &&
			residentialAddress.Address2__c != null)
			? residentialAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrRsaPostalCode = integer.valueof(
			(residentialAddress != null && residentialAddress.Shipping_Zip_Postal_Code__c != null) ? residentialAddress.Shipping_Zip_Postal_Code__c : '0'
		);
		requestBean.CIB003I.CIcreateClientV22Request.registeredSuburb = (residentialAddress != null &&
			residentialAddress.Shipping_Suburb__c != null)
			? residentialAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.registeredTown = (residentialAddress != null &&
			residentialAddress.Shipping_City__c != null)
			? residentialAddress.Shipping_City__c.toUpperCase()
			: '';

		requestBean.CIB003I.CIcreateClientV22Request.residentialStatusCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.saTaxNumber = '0';
		requestBean.CIB003I.CIcreateClientV22Request.saTaxRegisteredInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.sec129DeliveryAddrCode = 1;
		requestBean.CIB003I.CIcreateClientV22Request.secondaryPortfolioInd = 'N';

		requestBean.CIB003I.CIcreateClientV22Request.sicCode5 = '95990'; //get it from sic f
		requestBean.CIB003I.CIcreateClientV22Request.socialGrantInd = '';
		requestBean.CIB003I.CIcreateClientV22Request.sourceOfIncomeCode = 'MEMBERS CONTRIBUTIONS';

		requestBean.CIB003I.CIcreateClientV22Request.subClassificationCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.surname = accountObject.Name.toUpperCase();

		requestBean.CIB003I.CIcreateClientV22Request.tempResPermitExpDate = 0;
		requestBean.CIB003I.CIcreateClientV22Request.tempResPermitNumber = '';
		requestBean.CIB003I.CIcreateClientV22Request.titleCode = '0';

		requestBean.CIB003I.CIcreateClientV22Request.vatRegistrationNumber = '';
		requestBean.CIB003I.CIcreateClientV22Request.voluntaryCreditConsolInd = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.workFaxDialCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.workFaxNumber = 0;
		requestBean.CIB003I.CIcreateClientV22Request.workTelephoneNumber = '';
		requestBean.CIB003I.CIcreateClientV22Request.workTelephoneDialcode = 0;

		requestBean.NBSAPDPI.NBSAPLI.consumerChannel = 'BRANCH';
		requestBean.NBSAPDPI.NBSAPLI.providerApplication = 'ASP';
		requestBean.NBSAPDPI.NBSAPLI.traceIndicator = 'N';

		requestBean.NBSMSGI.NBSMSGI.messageLanguage = 'E';
		requestBean.NBSMSGI.NBSMSGI.messageTarget = 'STD';
		return requestBean;
	}

	/**
	 * @description cifGetClientDetails description
	 *
	 * @param cifCode (string): cifCode
	 * @return CIgetClientDetailsV12_Resp_IB_v1: Return description
	 */
	public static CIgetClientDetailsV12_Resp_IB_v1 cifGetClientDetails(string cifCode) {
		CIgetClientDetailsV12_Resp_IB_v1 cifClientDetails = BranchCIFSalesforceSyncHelper.GetUpdateAccount(cifCode);
		return cifClientDetails;
	}

	/**
	 * @description Method translate service values
	 * @param systemName -
	 * @param internalvalue - .
	 * @param valueType - .
	 * @param direction
	 * @return string
	 */
	public static String getTranslationValues(String systemName, String internalvalue, String valueType, String direction) {
		Integration_Translation__c returnValues = [
			SELECT External_Value__c
			FROM Integration_Translation__c
			WHERE Value_Type__c = :valueType AND Internal_Value__c = :internalvalue AND System_Name__c = :systemName AND Direction__c = :direction
			WITH SECURITY_ENFORCED
		];
		return returnValues.External_Value__c;
	}
	/**
	 * @description Function used to Create customer in CIF
	 * @param accountId
	 * @return String
	 */
	public static String updateCIF(id accountId) {
		CVSUpdateCIFv22_Req_IB_v1 requestBean = CVSUpdateCIFv22_Req_IB_v1.getNewInstance();
		requestBean = StokvelEntityCasaCIFController.GetCIFtoupdate(accountId);

		CVSUpdateCIFv22_Resp_IB_v1 updateCIFv22resp = CVSUpdateCIFv22_IH_v1.CVSUpdateCIFv22(requestBean, 'nonIndividual');
		
		if (updateCIFv22resp.body != null) {
			return 'Success';
		} else {
			if (updateCIFv22resp.statusMessage != null) {
				return 'Error: ' + JSON.serialize(updateCIFv22resp);
			} else {
				return 'CVS Service Error';
			}
		}
	}
	/**
	 * @description Method GetCIFtoupdate
	 * @param accountId -
	 * @return CVSUpdateCIFv22_Req_IB_v1
	 */
	public static CVSUpdateCIFv22_Req_IB_v1 GetCIFtoupdate(Id accountId) {
		Account accountobj = [
			SELECT
				Id,
				CASA_Reference_Number__c,
				Phone,
				Source_of_Income__c,
				Country_of_Incorporation__c,
				Country_of_Registration__c,
				RepresetentiveName__c,
				RepresentativeLastname__c,
				Date_Identified__c,
				Date_Verified__c,
				Active_Email__c,
				Number_of_Participants__c,
				Communication_Method__c,
				Name,
				CIF__c,
				Website,
				Preferred_Communication_Method__c,
				Is_Marketing_Consent_Email__c,
				Is_Non_Credit_Marketing_Consent_SMS__c,
				Is_Marketing_Consent_voice_rec__c,
				Is_Marketing_Consent_Phone__c,
				Is_Marketing_Consent_Post__c,
				Language__c
			FROM Account
			WHERE ID = :accountId
			WITH SECURITY_ENFORCED
		];
		CIgetClientDetailsV12_Resp_IB_v1 cifClientDetails = BranchCIFSalesforceSyncHelper.GetUpdateAccount(accountobj.CIF__c);
		//get controller of stokvel
		AccountContactRelation accountcontroler = AccountContactController.GetAccountContactController(accountId);
		Account accountcontrolerdetail = AccountContactController.GetAccountControllerDetails(accountcontroler.ContactId);
		// pls dod a null check
		Address__c postalAddress = getAddessByType(accountcontrolerdetail.Id, 'Postal');
		Address__c residentialAddress = getAddessByType(accountcontrolerdetail.Id, 'Residential');

		Usersselector us = new Usersselector();
		List<User> userP = us.userwithSiteCode(UserInfo.getUserId());

		CVSUpdateCIFv22_Req_IB_v1 requestBean = CVSUpdateCIFv22_Req_IB_v1.getNewInstance();

		requestBean.NBSAPDPI.NBSAPLI.consumerChannel = 'BRANCH';
		requestBean.NBSAPDPI.NBSAPLI.providerApplication = 'ASP';
		requestBean.NBSAPDPI.NBSAPLI.traceIndicator = 'N';
		requestBean.NBSMSGI.NBSMSGI.messageLanguage = 'E';
		requestBean.NBSMSGI.NBSMSGI.messageTarget = 'STD';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientCode = accountobj.CIF__c;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.initials = ''; //CIFClientDetails.initials;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.commLanguageCode = accountobj.Language__c.substring(0, 1);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.titleCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.surname = ''; //CIFClientDetails.surname.toUpperCase();

		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrLine1 = (postalAddress != null &&
			postalAddress.Shipping_Street__c != null)
			? postalAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrLine2 = (postalAddress != null &&
			postalAddress.Address2__c != null)
			? postalAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalSuburb = (postalAddress != null &&
			postalAddress.Shipping_Suburb__c != null)
			? postalAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalTown = (postalAddress != null &&
			postalAddress.Shipping_City__c != null)
			? postalAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrRsaCode = (postalAddress != null &&
			postalAddress.Shipping_Zip_Postal_Code__c != null)
			? postalAddress.Shipping_Zip_Postal_Code__c
			: '0';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.idDocTypeCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateOfBirth = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.maritalStatusCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.genderCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.minorChildren = ''; //CIFClientDetails.minorChildren;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.incomeGroupCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.securityInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.liabilityInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.telephonebankingInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.unclaimedFundsInd = 'N';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.absaRewardInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idRequiredHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.deceasedEstateHoldInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.deceasedSpouseHoldInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.insolventEstateHoldInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.curatorshipHoldInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.savingStatementHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditWorthConsentInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.marriageContractTypeCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeLanguageCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientTypeCode = '07401';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.voluntaryCreditConsolInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.residentialStatusCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.noOfJointParticipants = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxNumber = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.firstNames = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.insolventInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.companyYearEnd = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneDialCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneDialcode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrHoldInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerAddrHoldInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneNumber =  accountcontrolerdetail.PersonMobilePhone; //.substring(1, 9);
		//system.debug('wawadd' + requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneNumber);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxDialCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxNumber = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumDialCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumber = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationStatusCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employmentSectorCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationLevelCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.practiceNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientWebsite = accountobj.Website;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPerson =  accountcontrolerdetail.FirstName+ ' ' + 
		accountcontrolerdetail.LastName;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPersonDesignationCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.emailAddress = accountcontrolerdetail.PersonEmail;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalLifePolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.externalLifePolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalShortTermPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.externalShortTermPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalInvestmentPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.flexiFuneralPolicyInd = 'N';
		string prefferdCommunicationMethod = accountobj.Preferred_Communication_Method__c;
		if (prefferdCommunicationMethod == 'Post') {
			prefferdCommunicationMethod = 'Mail';
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.preferredCommMethodCode = StokvelEntityCasaCIFController.getTranslationValues(
			'CIFCodesList',
			prefferdCommunicationMethod,
			'Prefcomms',
			'Outbound'
		);

		requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneBankingInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sicCode5 = '95990';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.internetBankingInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sourceOfIncomeCode = 'MEMBERS CONTRIBUTIONS';//accountobj.Source_of_Income__c;

		Date dateToday = Date.today();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdentified = CVSServicesHelper.getDateForSalesforce(dateToday);

		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateVerified = CVSServicesHelper.getDateForSalesforce(dateToday);
		//requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdentified = dtIdentified;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeIdentified = userP[0].Teller_Operator_Code__c;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeVerified = userP[0].Teller_Operator_Code__c;

		requestBean.CIB004I.CIupdateClientDetailsV22Request.vatRegistrationNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientNationalityCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryPassportIssuedCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateExempted = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeExempted = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionStatusInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.socialGrantInd = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.notifyMeInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselAppliedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselAppliedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselOrderIssuedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselOrderIssuedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeEmp = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.secondaryPortfolioInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlAffectedPersonCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlExpiryDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdDocIssued = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inbusinessRescueAffectedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerName = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerAddrLine1 = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerSuburb = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerTown = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerRsaPostalCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrLine1 = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrLine2 = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalSuburb = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalTown = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalRsaPostalCode = '0';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessAddrLine1 = (residentialAddress != null &&
			residentialAddress.Shipping_Street__c != null)
			? residentialAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessAddrLine2 = (residentialAddress != null &&
			residentialAddress.Address2__c != null)
			? residentialAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessSuburb = (residentialAddress != null &&
			residentialAddress.Shipping_Suburb__c != null)
			? residentialAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessTown = (residentialAddress != null &&
			residentialAddress.Shipping_City__c != null)
			? residentialAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessRsaPostalCode = (residentialAddress != null &&
			residentialAddress.Shipping_Zip_Postal_Code__c != null)
			? residentialAddress.Shipping_Zip_Postal_Code__c
			: '';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.detailClassificationDataTable = new List<CVSUpdateCIFv22_Req_IB_v1.DetailClassificationDataTable>();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitExpDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.subClassificationCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryIncorporatedCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescueInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescuePlacedByCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescueIssuedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cpaThresholdInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinSurname = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinFirstname = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinRelationCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeDialCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeTelNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkDialCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkTelNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinCellNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinEmail = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantTitleCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantInitials = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantSurname = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.controllerOverride = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.casaRefNumber = accountobj.CASA_Reference_Number__c;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrLine1 = (residentialAddress != null &&
			residentialAddress.Shipping_Street__c != null)
			? residentialAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrLine2 = (residentialAddress != null &&
			residentialAddress.Address2__c != null)
			? residentialAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrRsaPostalCode = ((residentialAddress != null &&
			residentialAddress.Shipping_Zip_Postal_Code__c != null)
			? residentialAddress.Shipping_Zip_Postal_Code__c
			: '0');
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredSuburb = (residentialAddress != null &&
			residentialAddress.Shipping_Suburb__c != null)
			? residentialAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredTown = (residentialAddress != null &&
			residentialAddress.Shipping_City__c != null)
			? residentialAddress.Shipping_City__c.toUpperCase()
			: '';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeAddrLine1 = (postalAddress != null &&
			postalAddress.Shipping_Street__c != null)
			? postalAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeAddrLine2 = (postalAddress != null &&
			postalAddress.Address2__c != null)
			? postalAddress.Address2__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeSuburb = (postalAddress != null &&
			postalAddress != null &&
			postalAddress.Shipping_Suburb__c != null)
			? postalAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeTown = (postalAddress != null &&
			postalAddress.Shipping_City__c != null)
			? postalAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeRsaPostalCode = ((postalAddress != null &&
			postalAddress.Shipping_Zip_Postal_Code__c != null)
			? postalAddress.Shipping_Zip_Postal_Code__c
			: '0');

		string countryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Country',
			accountobj.Country_of_Incorporation__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		string countryOfPhysical = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Country',
			accountobj.Country_of_Registration__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfPhysicalAddrCode = countryOfPhysical;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfHeadOfficeAddrCode = countryOfPhysical;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfRegisteredAddrCode = countryOfPhysical;

		CVSUpdateCIFv22_Req_IB_v1.CountryEntityOprtDataTable CountryEntityitem = new CVSUpdateCIFv22_Req_IB_v1.CountryEntityOprtDataTable();
		CountryEntityitem.countryEntOprtCode = countryTranslated;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryEntityOprtDataTable.Add(CountryEntityitem);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfBirthCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientAgreementIssuedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sec129DeliveryAddrCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxRegisteredInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.reasonSaTaxNotGivenCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxRegisteredInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxDataTable = new List<CVSUpdateCIFv22_Req_IB_v1.ForeignTaxDataTable>();

		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingGroupInd = 'N';

		string nonCreditMarketingSmsInd = '';
		if (accountobj.Is_Non_Credit_Marketing_Consent_SMS__c == null) {
			nonCreditMarketingSmsInd = 'N';
		} else if (accountobj.Is_Non_Credit_Marketing_Consent_SMS__c == false) {
			nonCreditMarketingSmsInd = 'N';
		} else if (accountobj.Is_Non_Credit_Marketing_Consent_SMS__c == true) {
			nonCreditMarketingSmsInd = 'Y';
		}

		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingSmsInd = nonCreditMarketingSmsInd;

		string nonCreditMarketingEmailInd = '';
		/*  if(accountobj.Is_Non_Credit_Marketing_Consent_Email__c == null)
        {
         nonCreditMarketingEmailInd = 'N';
        }
        else if(accountobj.Is_Non_Credit_Marketing_Consent_Email__c == false)
        {
                 nonCreditMarketingEmailInd = 'N';   
        }
        else if(accountobj.Is_Non_Credit_Marketing_Consent_Email__c == true)
        {
                  nonCreditMarketingEmailInd = 'Y';  
        }*/
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingEmailInd = 'N'; //nonCreditMarketingEmailInd;

		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingAutoVoiceInd = 'N';

		string nonTelInd = '';
		
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingTelephoneInd = 'N'; //nonTelInd;

		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingPostInd = 'N';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingGroupInd = 'N';
		string smsind = '';
	
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingSmsInd = 'N'; //smsind;
		string EmailIn = '';
		if (accountobj.Is_Marketing_Consent_Email__c == null) {
			EmailIn = 'N';
		} else if (accountobj.Is_Marketing_Consent_Email__c == false) {
			EmailIn = 'N';
		} else if (accountobj.Is_Marketing_Consent_Email__c == true) {
			EmailIn = 'Y';
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingEmailInd = 'N'; // EmailIn;
		string creditVoice = '';
		if (accountobj.Is_Marketing_Consent_voice_rec__c == null) {
			creditVoice = 'N';
		} else if (accountobj.Is_Marketing_Consent_voice_rec__c == false) {
			creditVoice = 'N';
		} else if (accountobj.Is_Marketing_Consent_voice_rec__c == true) {
			creditVoice = 'Y';
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingAutoVoiceInd = 'N'; // creditVoice;

		string TelephoneInd = '';
		if (accountobj.Is_Marketing_Consent_Phone__c == null) {
			TelephoneInd = 'N';
		} else if (accountobj.Is_Marketing_Consent_Phone__c == false) {
			TelephoneInd = 'N';
		} else if (accountobj.Is_Marketing_Consent_Phone__c == true) {
			TelephoneInd = 'Y';
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingTelephoneInd = 'N'; // TelephoneInd;
		string PostInd = '';
		if (accountobj.Is_Marketing_Consent_Post__c == null) {
			PostInd = 'N';
		} else if (accountobj.Is_Marketing_Consent_Post__c == false) {
			PostInd = 'N';
		} else if (accountobj.Is_Marketing_Consent_Post__c == true) {
			PostInd = 'Y';
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingPostInd = 'N'; //PostInd;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.forecastOfMembers = String.valueof(accountobj.Number_of_Participants__c);
		//System.debug(' CIF update ' + JSON.serializePretty(requestBean));
		return requestBean;
	}
}