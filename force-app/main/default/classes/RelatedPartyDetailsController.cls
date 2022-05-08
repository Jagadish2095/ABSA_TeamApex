/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-10-21
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-10-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class RelatedPartyDetailsController {
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
	 * @description getRelatedPartiesDetails description
	 *
	 * @param accountId (String): accountId
	 * @return List<ACRWrapper>: Return description
	 */
	@AuraEnabled
	public static List<ACRWrapper> getRelatedPartiesDetails(String accountId) {
		// List<Account> aclist = AccountContactController.getRelatedAccounts(accountId);
		List<AccountContactRelation> aclist = AccountContactController.getRelatedAccounts(accountId);

		List<ACRWrapper> wrapperList = new List<ACRWrapper>();

		for (AccountContactRelation acr : aclist) {
			ACRWrapper wrapper = new ACRWrapper();
			wrapper.accountId = acr.ContactId;
			wrapper.contactName = acr.Contact.FirstName + ' ' + acr.Contact.LastName;
			wrapper.contactIdNumber = acr.Contact.ID_Number__c;
			wrapper.accountMandatorySignatory = acr.Control_of_Passive_Non_Financial_Entity__c;
			wrapper.contactController = acr.Controlling_Person_is_Taxed_Outside__c;
			//wrapper.accountCIF = acr.Contact.CIF__c;
			wrapper.accountCASA = acr.Contact.CASA_Reference_Number__c;

			wrapperList.add(wrapper);
		}

		return wrapperList;
	}

	/**
	 * @description ACRWrapper Description
	 */
	public class ACRWrapper {
		@AuraEnabled
		public String accountId;
		@AuraEnabled
		public String contactName;
		@AuraEnabled
		public String contactIdNumber;
		@AuraEnabled
		public Boolean contactController;
		@AuraEnabled
		public Boolean accountMandatorySignatory;
		@AuraEnabled
		public String accountCIF;
		@AuraEnabled
		public String accountCASA;
	}

	/**
	 * @description Method that screen related parties
	 * @param accountId -for main account.
	 *  @return string
	 */
	@AuraEnabled
	public static String generateORUpdateCIF(String accountId) {
		string cifcode = '';
		string returnmsg = 'Success';
		Account accountrelatedParty = [
			SELECT Id, CASA_Reference_Number__c, Client_Type__c, CASA_Screening_Status__c, CASA_Screening_Date__c, CIF__c,Valid_Update_Bypass__c
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];
		string accountCIF = BranchCIFSalesforceSyncHelper.getCIFCode(accountrelatedParty.ID);
		if (accountrelatedParty != null && (accountrelatedParty.CIF__c == null || accountrelatedParty.CIF__c == '') && accountCIF == null) {
			cifcode = CVSServicesHelper.createCIF(accountrelatedParty.Id);
			if (!cifcode.contains('Error')) {
               
				accountrelatedParty.CIF__c = cifcode;
				returnmsg = 'Success ' + cifcode;
			} else {
				returnmsg = cifcode;
			}
		} else {
			if (accountCIF != null) {
				cifcode = CVSServicesHelper.updateCIF(accountrelatedParty.ID, accountCIF);
				accountrelatedParty.CIF__c= accountCIF;
			} else {
				cifcode = CVSServicesHelper.updateCIF(accountrelatedParty.Id, accountrelatedParty.CIF__c);
			}
		}
		Account.SObjectType.getDescribe().isUpdateable();
	
		accountrelatedParty.Valid_Update_Bypass__c= true;
		update accountrelatedParty;

		return returnmsg; //cifcode;
	}

	/**
	 * @description Method that screen related parties
	 * @param accountId -for main account.
	 * @param casaRefNumber -for main account.
	 * @return Changed value> - list accounts with CASA fields
	 */
	@AuraEnabled
	public static String screenstokvelRelatedParties(String accountId, string casaRefNumber) {
		String errorMessage = '';
		try {
			List<AccountContactRelation> relatedParty = AccountContactController.getRelatedAccounts(accountId);

			List<AccountContactRelation> updaterelatedParty = new List<AccountContactRelation>();
			List<Account> updateAccountrelatedParty = new List<Account>();
			List<Contact> updateContactrelatedParty = new List<Contact>();

			//screenrelatedparties
			for (AccountContactRelation accountstokvel : relatedParty) {
				CASAScreenRelatedParty_Req_IB_v3 screenRelatedPartyRequest = CASAScreenRelatedParty_IU_v3.mapRequestStokvelaccountFields(
					accountstokvel,
					casaRefNumber
				);
				CASAScreenRelatedParty_Resp_IB_v3 response = CASAScreenRelatedParty_IH_v3.casaScreenRelatedClientV7(screenRelatedPartyRequest);

				if ((response != null && response.statusCode == 200 && response.msgNo == '0')) {
					if (accountstokvel.ContactId != null) {
						response.respStatus = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(response.refNo);

						//	updateContactrelatedParty.add(updateContactCasaDetails(accountstokvel.ContactId, response.refNo, response.respStatus));
						updateAccountrelatedParty.add(updateAccountCasaDetails(accountstokvel.ContactId, response.refNo, response.respStatus));
					}
				} else {
					errorMessage += accountstokvel.Contact.FirstName + ' ' + accountstokvel.Contact.LastName;
					errorMessage += ': ' + response.msg + '\n ';
				}
			}

		/*	if (updateContactrelatedParty.size() > 0) {
				if (Contact.SObjectType.getDescribe().isUpdateable()) {
					update updateContactrelatedParty;
				}
			}*/
			if (updateAccountrelatedParty.size() > 0) {
				if (Account.SObjectType.getDescribe().isUpdateable()) {
					update updateAccountrelatedParty;
				}
			}
		} catch (Exception e) {
			throw e;
		}

		if (errorMessage == '') {
			return 'SUCCESS';
		} else {
			return errorMessage;
		}
	}

	/**
	 * @description Method that screen related parties
	 * @param relatedPartyId -for main account.
	 * @param  mainaccountId for main account.
	 * @return Changed value> - list accounts with CASA fields
	 */

	@AuraEnabled
	public static String screenRelatedParty(String relatedPartyId, string mainaccountId) {
		string primaryClientRef = getCasaReferenceNum(mainaccountId);

		String errorMessage = '';
		try {
			Account accountP = [
				SELECT
					FirstName,
					MiddleName,
					LastName,
					ID_Type__pc,
					Country_of_Residence__pc,
					ID_Number__pc,
					PersonBirthdate,
					Country_of_Birth__pc,
					Nationality__pc,
					CASA_Reference_Number__c,
					CASA_Screening_Status__c,
					CASA_Screening_Date__c
				FROM Account
				WHERE Id = :relatedPartyId
				WITH SECURITY_ENFORCED
			];
		/*	Contact contacttrelatedParty = [
				SELECT CASA_Reference_Number__c, CASA_Screening_Date__c, CASA_Screening_Status__c
				FROM Contact
				WHERE AccountId = :relatedPartyId
				WITH SECURITY_ENFORCED
				LIMIT 1
			];*/

			Usersselector us = new Usersselector();
			List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
			CASAScreenRelatedParty_Req_IB_v3 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v3();
			screenRelatedParty.channel = 'SALESFORCE';
			screenRelatedParty.application = 'SALESFORCE';
			screenRelatedParty.trace = '';
			//screenRelatedParty.firstName;
			String firstNameString; //W-010679
			if (accountP.FirstName != null && accountP.MiddleName != null) {
				firstNameString = accountP.FirstName + ' ' + accountP.MiddleName;
			} else {
				firstNameString = accountP.FirstName;
			}
			screenRelatedParty.firstName = firstNameString;
			screenRelatedParty.surnameComp = accountP.LastName;
			screenRelatedParty.idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.ECASA_STRING,
				StringConstants.FIELD_IDENTITY_TYPE_STRING,
				accountP.ID_Type__pc,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			screenRelatedParty.idRegNo = accountP.ID_Number__pc;
			screenRelatedParty.clientTypeGrp = 'I';
			String dobstring = String.valueOf(accountP.PersonBirthdate).replace('-', '');
			if (dobstring != null) {
				screenRelatedParty.dob = dobstring;
			}

			String countryOfBirthValue = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.ECASA_STRING,
				StringConstants.FIELD_COUNTRY_STRING,
				accountP.Country_of_Birth__pc,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			String SuburbValue = '';

			//Get Related Party Residential address and pass to screening
			List<Address__c> addressLst = new AddressesSelector().addressesRelatedToAcc(relatedPartyId);
			if (addressLst != null) {
				for (Address__c eachAddress : addressLst) {
					if (eachAddress.Address_Type__c == 'Residential' && eachAddress.Address2__c != null) {
						SuburbValue = eachAddress.Address2__c;
						break;
					}
				}
			}

			screenRelatedParty.town = suburbValue;

			if (countryOfBirthValue != null) {
				screenRelatedParty.cntryOfBirth = countryOfBirthValue;
			} else {
				screenRelatedParty.cntryOfBirth = '';
			}

			screenRelatedParty.nationality = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.ECASA_STRING,
				StringConstants.FIELD_COUNTRY_STRING,
				accountP.Nationality__pc,
				StringConstants.OUTBOUND_RECORD_TYPE
			);

			screenRelatedParty.territory = '';
			screenRelatedParty.cntryOfRes = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.ECASA_STRING,
				StringConstants.FIELD_COUNTRY_STRING,
				accountP.Country_of_Residence__pc,
				StringConstants.OUTBOUND_RECORD_TYPE
			); //'SO003';//countryOfResP;

			screenRelatedParty.registerCity = '';
			screenRelatedParty.countryPassport = 'SO003';
			screenRelatedParty.headofficeTown = '';
			screenRelatedParty.headofficeCntry = '';
			screenRelatedParty.headofficeOtherCntry1 = ''; //'3456';
			screenRelatedParty.headofficeOtherCntry2 = '';
			screenRelatedParty.headofficeOtherCntry3 = '';
			screenRelatedParty.headofficeOtherCntry4 = '';
			screenRelatedParty.headofficeOtherCntry5 = '';
			screenRelatedParty.primaryClientRef = primaryClientRef;
			screenRelatedParty.relationship = '210305';
			screenRelatedParty.branch = userP[0].SiteCode__c; //'8198';
			screenRelatedParty.teller = userP[0].Teller_Operator_Code__c; //'2626'
			screenRelatedParty.originatingSys = 'ESP';

			CASAScreenRelatedParty_Resp_IB_v3 response = CASAScreenRelatedParty_IH_v3.casaScreenRelatedClientV7(screenRelatedParty);

			if ((response != null && response.statusCode == 200 && response.msgNo == '0')) {
				response.respStatus = WQgetCASAStatusByRefNoV7_IH_v1.getCASAStatus(response.refNo);

				/*contacttrelatedParty.CASA_Reference_Number__c = response.refNo;
				contacttrelatedParty.CASA_Screening_Date__c = System.today();
				contacttrelatedParty.CASA_Screening_Status__c = response.respStatus;*/
				accountP.Valid_Update_Bypass__c = true;
				accountP.CASA_Reference_Number__c = response.refNo;
				accountP.CASA_Screening_Date__c = System.today();
				accountP.CASA_Screening_Status__c = response.respStatus;
                accountP.CASA_Reference_Number__pc = response.refNo;
				accountP.CASA_Screening_Date__pc = System.today();
				accountP.CASA_Screening_Status__pc = response.respStatus;
			} else {
				errorMessage += accountP.FirstName + ' ' + accountP.LastName;
				errorMessage += ': ' + response.msg + '\n ';
			}

			/*if (Contact.SObjectType.getDescribe().isUpdateable()) {
				update contacttrelatedParty;
			}*/

			if (Account.SObjectType.getDescribe().isUpdateable()) {
				
				accountP.Valid_Update_Bypass__c= true;
				update accountP;
			}
		} catch (Exception e) {
			throw e;
		}

		if (errorMessage == '') {
			return 'SUCCESS';
		} else {
			return errorMessage;
		}
	}

	/**
	 * @description Method that get overall  Entity Casa status by refernce number,
	 *
	 * @param accountId -for main account.
	 * @return Changed value> - list accounts with CASA fields
	 */
	@AuraEnabled
	public static String getCasaReferenceNum(String accountId) {
		string casaRefNumber = '';

		Account accountRecord = [SELECT CASA_Reference_Number__c FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED LIMIT 1];
		casaRefNumber = accountRecord.CASA_Reference_Number__c;

		return casaRefNumber;
	}

	/**
	 * @description Method that get Entity Casa status,
	 *
	 * @param accountRecId -for main account.
	 * @return Changed value> - list accounts with CASA fields
	 */
	@AuraEnabled
	public static List<EntityWrapper> getEntityCasastatus(String accountRecId) {
		List<EntityWrapper> wrapperList = new List<EntityWrapper>();
		string casaRefNumber = '';

		List<Account> accountRecord = new List<Account>();
		accountRecord = [SELECT Id, Name, CASA_Reference_Number__c, CASA_Screening_Status__c FROM Account WHERE Id = :accountRecId WITH SECURITY_ENFORCED];

		for (Account acr : accountRecord) {
			EntityWrapper wrapper = new EntityWrapper();
			wrapper.entityName = acr.Name;
			wrapper.casaRefNumber = acr.CASA_Reference_Number__c;
			wrapper.status = acr.CASA_Screening_Status__c;

			wrapperList.add(wrapper);
		}
		return wrapperList;
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
	 * @description Method that updates the account object,
	 * Update all Control_of_Passive_Non_Financial_Entity__c to false, and set the selected to true.
	 * @param allIds - set Selected ID from the ThirdParty Grid.
	 * @param idToChange - All ids from the ThirdParty Grid.
	 *  @param accountId - isCheckedVal
	 * @return Changed value> - list accounts with CASA fields
	 */
	@AuraEnabled
	public static String updateAccountFromDatabase(List<String> allIds, String idToChange, string accountId) {
		List<AccountContactRelation> updaterelatedParty = new List<AccountContactRelation>();
		List<AccountContactRelation> listodAccounts = [
			SELECT Id, AccountId, ContactId, Controlling_Person_is_Taxed_Outside__c
			FROM AccountContactRelation
			WHERE AccountId = :accountId AND Primary_Entity_Id__c = :accountId
			WITH SECURITY_ENFORCED
		];

		for (AccountContactRelation acc : listodAccounts) {
			acc.Controlling_Person_is_Taxed_Outside__c = (acc.ContactId == idToChange);
			updaterelatedParty.add(acc);
		}

		if (AccountContactRelation.SObjectType.getDescribe().isUpdateable()) {
			update updaterelatedParty;
		}

		Integer isChairPersonSelected = [
			SELECT COUNT()
			FROM AccountContactRelation
			WHERE Controlling_Person_is_Taxed_Outside__c = TRUE AND AccountId = :accountId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		string theString = 'false';
		if (isChairPersonSelected == 1) {
			theString = 'true';
		} else {
			theString = 'false';
		}

		return theString;
	}

	/**
	 * @description Method that updates the account object,
	 * Update all Control_of_Passive_Non_Financial_Entity__c to false, and set the selected to true.
	 * @param allIds - set Selected ID from the ThirdParty Grid.
	 * @param idToChange - All ids from the ThirdParty Grid.
	 * @param isCheckedVal - isCheckedVal
	 *  @param accountId - isCheckedVal
	 * @return Changed value> - list accounts with CASA fields
	 */
	@AuraEnabled
	public static integer updateMandatorySignatoryAccountFromDatabase(List<String> allIds, String idToChange, Boolean isCheckedVal, string accountId) {
		AccountContactRelation accountChairPerson = [
			SELECT Id, AccountId, ContactId, Control_of_Passive_Non_Financial_Entity__c
			FROM AccountContactRelation
			WHERE ContactId = :idToChange AND AccountId = :accountId AND Primary_Entity_Id__c = :accountId
			WITH SECURITY_ENFORCED
		];
		Integer SelectedMandatoryVal = 0;
		if (accountChairPerson != null) {
			accountChairPerson.Control_of_Passive_Non_Financial_Entity__c = isCheckedVal;
			if (AccountContactRelation.SObjectType.getDescribe().isUpdateable()) {
				update accountChairPerson;
			}

			SelectedMandatoryVal = [
				SELECT COUNT()
				FROM AccountContactRelation
				WHERE Control_of_Passive_Non_Financial_Entity__c = TRUE AND AccountId = :accountId
				WITH SECURITY_ENFORCED
			];
		}

		return SelectedMandatoryVal;
	}

	/**
	 * @description Method that removes the relatedpaty object,
	 *
	 * @param relatedAccountId - set Selected ID from the ThirdParty Grid.
	 * @param mainAccountId - main account id.
	 * @return string
	 */
	@AuraEnabled
	public static String removeRelatedparty(String relatedAccountId, String mainAccountId) {
		Usersselector us = new Usersselector();

		List<User> userP = us.userwithSiteCode(UserInfo.getUserId());

		Account mainAccount = [SELECT ID, CASA_Reference_Number__c FROM Account WHERE Id = :mainAccountId WITH SECURITY_ENFORCED LIMIT 1];

		Contact relatedPartyContact = [SELECT ID, CASA_Reference_Number__c FROM Contact WHERE Id = :relatedAccountId WITH SECURITY_ENFORCED LIMIT 1];

		WQcancelRelatedPartyV2_Req_IB_v1 request = WQcancelRelatedPartyV2_Req_IB_v1.getNewInstance();
		request.WQCancelRelatedV7Request.InitialAB = userP[0].Teller_Operator_Code__c;
		request.WQCancelRelatedV7Request.OriginatingSystem = 'BDP';
		request.WQCancelRelatedV7Request.PrimaryRef = mainAccount.CASA_Reference_Number__c;
		request.WQCancelRelatedV7Request.RelatedRef = relatedPartyContact.CASA_Reference_Number__c;
		string req = JSON.serializePretty(request);

		WQcancelRelatedPartyV2_Resp_IB_v1 response = WQcancelRelatedPartyV2_IH_v1.cancelRelatedParty(request);

		string res = JSON.serializePretty(response);
		//system.debug('Happy res' + res);
		AccountContactRelation.SObjectType.getDescribe().isDeletable();

		AccountContactRelation accountPerson = [
			SELECT Id, IsActive
			FROM AccountContactRelation
			WHERE AccountId = :mainAccountId AND ContactId = :relatedAccountId
			WITH SECURITY_ENFORCED
		];

		delete accountPerson; // rembember to put this back

		//	Integer totalRelatedParties = [SELECT COUNT() FROM AccountContactRelation WHERE AccountId = :mainAccountId WITH SECURITY_ENFORCED];
		//	string s1 = string.valueof(totalRelatedParties);
		List<ACRWrapper> wrapperList = new List<ACRWrapper>();
		wrapperList = RelatedPartyDetailsController.getRelatedPartiesDetails(mainAccountId);

		return JSON.serialize(wrapperList);
		//return response.WQCancelRelatedV7Response.msg;
	}

	/**
	 * @description Method that get count of AccountContactRelation object,
	 *
	 * @param mainAccountId - main account id.
	 * @return string
	 */
	@AuraEnabled
	public static string getRelatedpartyCount(String mainAccountId) {
		try {
			Integer totalRelatedParties = [SELECT COUNT() FROM AccountContactRelation WHERE AccountId = :mainAccountId WITH SECURITY_ENFORCED];
			string s1 = string.valueof(totalRelatedParties);

			return s1;
		} catch (Exception e) {
			return e.getMessage();
		}
	}

	/**
	 * @description Method that get count of relatedpaty object,
	 *
	 * @param mainAccountId - main account id.
	 * @return string
	 */
	@AuraEnabled
	public static string getMandatorySignatoryCount(String mainAccountId) {
		try {
			Integer listofSignatories = [
				SELECT COUNT()
				FROM AccountContactRelation
				WHERE Control_of_Passive_Non_Financial_Entity__c = TRUE AND AccountId = :mainAccountId AND Primary_Entity_Id__c = :mainAccountId
				WITH SECURITY_ENFORCED
			];

			string s1 = string.valueof(listofSignatories);

			return s1;
		} catch (Exception e) {
			return e.getMessage();
		}
	}

	/**
	 * @description Method update Account CasaDetails
	 * @param contactId -
	 * @param refNo - .
	 * @param respStatus - .
	 * @return Contact
	 
	public static Contact updateContactCasaDetails(Id contactId, String refNo, String respStatus) {
		Contact contacttrelatedParty = [
			SELECT CASA_Reference_Number__c, CASA_Screening_Date__c, CASA_Screening_Status__c
			FROM Contact
			WHERE Id = :contactId
			WITH SECURITY_ENFORCED
			LIMIT 1
		];
		contacttrelatedParty.CASA_Reference_Number__c = refNo;
		contacttrelatedParty.CASA_Screening_Date__c = System.today();
		contacttrelatedParty.CASA_Screening_Status__c = respStatus;

		return contacttrelatedParty;
	}*/

	/**
	 * @description Method update Account CasaDetails
	 * @param contactId -
	 * @param refNo - .
	 * @param respStatus - .
	 *  @return Account
	 */
	public static Account updateAccountCasaDetails(Id contactId, String refNo, String respStatus) {
		Contact contacttrelatedParty = [SELECT Id, AccountID FROM Contact WHERE Id = :contactId WITH SECURITY_ENFORCED];

		Account accountrelatedParty = [
			SELECT
				CASA_Reference_Number__c,
				CASA_Screening_Status__c,
				CASA_Screening_Date__c,
				CASA_Reference_Number__pc,
				CASA_Screening_Status__pc,
				CASA_Screening_Date__pc
			FROM Account
			WHERE Id = :contacttrelatedParty.AccountID
			WITH SECURITY_ENFORCED
		];
		accountrelatedParty.Valid_Update_Bypass__c= true;
		accountrelatedParty.CASA_Reference_Number__pc = refNo;
		accountrelatedParty.CASA_Screening_Date__pc = System.today();
		accountrelatedParty.CASA_Screening_Status__pc = respStatus;
		accountrelatedParty.CASA_Reference_Number__c = refNo;
		accountrelatedParty.CASA_Screening_Date__c = System.today();
		accountrelatedParty.CASA_Screening_Status__c = respStatus;
		return accountrelatedParty;
	}

	/**
	 * @description Method update Account CasaDetails
	 * @param accountId -
	 * @param cif -
	 * @return Account
	 */
	public static Account updateCIFDetails(Id accountId, string cif) {
		//Contact contacttrelatedParty = [SELECT Id, CIF__c, AccountID FROM Contact WHERE Id = :contactId WITH SECURITY_ENFORCED];

		Account accountrelatedParty = [
			SELECT Id, CASA_Reference_Number__c, Client_Type__c, CASA_Screening_Status__c, CASA_Screening_Date__c, CIF__c
			FROM Account
			WHERE Id = :accountId
			WITH SECURITY_ENFORCED
		];
        accountrelatedParty.Valid_Update_Bypass__c = true;
		accountrelatedParty.Client_Type__c = 'Individual Client';
		accountrelatedParty.CIF__c = cif;

		return accountrelatedParty;
	}

	/**
	 * @description Method update Account insertDocumentInformation
	 * @param currentScannedDocuments -
	 * @param accountRecId
	 * @param relatedPartyRecordID
	 */
	@AuraEnabled
	public static void insertDocumentInformation(String currentScannedDocuments, String accountRecId, String relatedPartyRecordID) {
		EcmDocumentList scannedDocuments = new EcmDocumentList();
		List<Document__c> listDocument = new List<Document__c>();
		try {
			Contact contact = [SELECT Id, AccountId FROM Contact WHERE AccountId = :relatedPartyRecordID WITH SECURITY_ENFORCED LIMIT 1];

			scannedDocuments = EcmDocumentList.parse(currentScannedDocuments);

			for (EcmDocumentList.DocumentList documentList : scannedDocuments.DocumentList) {
				Document__c document = new Document__c();
				document.Account__c = accountRecId;
				document.Contact__c = contact.Id;
				document.ECM_Type__c = documentList.DocumentType;
				document.Reference__c = documentList.DocumentGUID;
				//document.File_Id__c = documentList.ECMPID;//File_Id__c error toolarge
				document.Case_External_Reference__c = documentList.ECMPID;
				document.Document_Sub_Type__c = documentList.DocumentCode;
				listDocument.add(document);
			}
			insert listDocument;
		} catch (Exception e) {
			listDocument = new List<Document__c>();
		}
	}
}