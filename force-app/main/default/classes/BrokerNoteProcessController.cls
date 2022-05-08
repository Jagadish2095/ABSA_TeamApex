/*
 * This class used to handle Broker Note related functionalities
 * @author   Vitthal Jivrag,Poornima Aduru,Venkatesh Kanukuntla
 * @since    2020-11-12
 */
/**
 * @description BrokerNoteProcessController
 */
public class BrokerNoteProcessController extends ClientFinderBase {
	/**
	 * @description ListsWrapper
	 */
	public class ListsWrapper {
		/** @description callSCripts  */
		@AuraEnabled
		public List<Call_Script__c> callSCripts { get; set; }
		/** @description confirmation  */
		@AuraEnabled
		public Case confirmation { get; set; }
	}
	/**
	 * @description CaseWrapper
	 */
	public class CaseWrapper {
		/** @description isNewAlternateConBlank  */
		@AuraEnabled
		public Boolean isNewAlternateConBlank { get; set; }
		/** @description caseObject  */
		@AuraEnabled
		public Case caseObject { get; set; }
	}
	/**
	 * @description OutcomeWrapper
	 */
	public class OutcomeWrapper {
		/** @description currentOutcome  */
		@AuraEnabled
		public String currentOutcome { get; set; }
		/** @description statusOutcomesMap  */
		@AuraEnabled
		public Map<String, List<String>> statusOutcomesMap { get; set; }
		/** @description caseStatus  */
		@AuraEnabled
		public String caseStatus { get; set; }
	}
	/**
	 * @description LtngWrap
	 */
	public class LtngWrap {
		/** @description mapUserSites  */
		@AuraEnabled
		public map<String, list<String>> mapUserSites { get; set; }
		/** @description lstUserRecs  */
		@AuraEnabled
		public List<User> lstUserRecs { get; set; }
	}
	/**
	 * @description policyConsentWrapper
	 */
	public class policyConsentWrapper { //VK
		/** @description CaseSupportIdList  */
		@AuraEnabled
		public List<Id> CaseSupportIdList = new List<Id>();
		/** @description consent  */
		@AuraEnabled
		public String consent = 'No';
		//public Boolean consent = false;
	}
	/**
	 * @description userDetailsMethod
	 * @param userIds
	 * @param  uId
	 * @return null
	 */
	@AuraEnabled
	public static List<user> userDetailsMethod(List<Id> userIds, string uId) {
		//System.debug('userIds==>' + userIds + '----------uId-->' + uId);
		return null;
	}
	/**
	 * @description userDetailsMethod
	 * @param   userIds
	 * @return null
	 */
	@AuraEnabled
	public static List<user> userDetailsMethod(List<Id> userIds) {
		// System.debug('userIds==>'+userIds);
		// List<User> lstusers=[select id,lastName from user where id IN :userIds];
		//  system.debug('lstusers===>'+lstusers);
		return null;
	}
	/**
	 * Author - vj
	 * @description getPolicyDetails
	 * Method is created to retun policies associated with case
	 * @param   caseId
	 * @return null
	 */
	@AuraEnabled
	public static list<Case_Support__c> getPolicyDetails(String caseId) {
		List<Case_Support__c> listOfPolicies = new List<Case_Support__c>();
		CaseSupportSelector cSupportSelector = new CaseSupportSelector();
		if (String.isNotBlank(caseId)) {
			listOfPolicies = cSupportSelector.selectByCaseID(caseId);
		}
		if (!listOfPolicies.isEmpty()) {
			return listOfPolicies;
		}
		return null;
	}
	/**
	 * Author - vj
	 * @description getVirtualAdviserDetails
	 * Method is created to retun user deatils who is virtual adviser for this case
	 * @param   caseId
	 * @return uObj
	 */
	@AuraEnabled
	public static user getVirtualAdviserDetails(String caseId) {
		//vk
		CasesSelector cSelector = new CasesSelector();
		UsersSelector uSelector = new UsersSelector();
		list<case> cObj = cSelector.selectCaseDetailsForBrokerNote(caseId);
		if (cObj[0].Status != 'Completed') {
			cObj[0].Status = 'In Progress'; //vk
			cObj[0].Outcome__c = 'In Progress'; //vk
			update cobj[0]; //vk
		}
		String adviserCode = cObj[0].Adviser_Code__c;
		User uObj = uSelector.selectByAdviserCode(adviserCode);
		return uObj;
	}
    /**
     * Method is  to return Users
     * @description getAdvisorFace2Face
     * @param  caseId
     * @return user
     */
    @AuraEnabled
    public static user getAdvisorFace2Face(String caseId) {
        CasesSelector cSelector = new CasesSelector();
        UsersSelector uSelector = new UsersSelector();
        list<case> cObj = cSelector.selectCaseDetailsForBrokerNote(caseId);
        String adviser = cObj[0].SelectedAdvisorIdF2F__c;
        User uObj = [SELECT id, name, email FROM user WHERE id = :adviser LIMIT 1];
        return uObj;
    }
	/**
	 * Author : Poornima Aduru
	 * This method saves new contact number entered by Virtual Advisor or Agent to Case Object.
	 * @description  saveNewContact
	 * @param  newContact   New Contact Number to be saved to the Case Object.
	 * @param  caseID       ID of the case record to be updated with new contact number.
	 * @return string
	 **/
	@AuraEnabled
	public static String saveNewContact(String newContact, String caseID) {
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(CaseId);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		cases[0].New_Alternate_Contact__c = newContact;
		try {
			update cases[0];
		} catch (exception e) {
			//system.debug('Inside error');
			throw new AuraHandledException(
				'Telephone number can only be numeric of length 9 or 10. Allowed formats examples : 999999999 or 9999999999 or (999) 999-9999'
			);
		}
		return 'Success';
	}
	/**
	 * Author : Poornima Aduru
	 * This method deletes value of New_Alternate_Contact__c field on Case Object.
	 * @description deleteNewContact
	 * @param  caseID       ID of the case record to be updated with null contact number.
	 **/
	@AuraEnabled
	public static void deleteNewContact(String caseID) {
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(CaseId);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		cases[0].New_Alternate_Contact__c = null;
		update cases[0];
	}
	/**
	 * Author : Poornima Aduru
	 * This method gets the call script and disclosure and consent information.
	 * @description  getScriptsInfo
	 * @param  CaseId   ID of the case record to be updated with new contact number.
	 * @return ListWrapper
	 **/
	@AuraEnabled
	public static ListsWrapper getScriptsInfo(String CaseId) {
		Set<String> caseidSet = new Set<String>();
		Set<Id> useridSet = new Set<Id>();
		caseidSet.add(CaseId);
		List<Case> cases = new List<Case>();
		List<Call_Script__c> callscripts = new List<Call_Script__c>();
		List<User> users2 = new List<User>();
		cases = new CasesSelector().selectByIdWithCustomerInfo(caseidSet);
		useridSet.add(cases[0].OwnerId);
		//System.debug('mytest useridSet=' + useridSet);
		users2 = new UsersSelector().selectById(useridSet);
		List<String> sections = new List<String>();
		if ((users2.size() > 0 && !(String.isBlank(users2[0].Advisor_Code__c))) && (cases[0].Adviser_Code__c == users2[0].Advisor_Code__c)) {
			//system.debug('Inside VA disclosure');
			sections.add('Disclosure (VA)');
		} else {
			// system.debug('Inside Agent disclosure');
			sections.add('Disclosure (Agent)');
		}
		sections.add('Astute Consent');
		callscripts = new CallScriptsSelector().selectBySection(sections);
		callscripts = dynamicReplacement(callscripts, cases[0]);
		ListsWrapper listwrap = new ListsWrapper();
		listwrap.callSCripts = callscripts;
		listwrap.confirmation = cases[0];
		// system.debug(listwrap);
		return listwrap;
	}
	/**
	 * This method gets the call script and disclosure and consent information.
	 * @description dynamicReplacement
	 * @param  callScripts
	 * @param caserecord
	 * @return list
	 **/
	public static List<Call_Script__c> dynamicReplacement(List<Call_Script__c> callScripts, Case caserecord) {
		for (Call_Script__c callScript : callScripts) {
			if ((callScript.Section__c == 'Disclosure (VA)') || (callScript.Section__c == 'Disclosure (Agent)')) {
				String Script = callScript.Script__c;
				Script = Script.replace('#clientName', caserecord.Customer_Full_Name__c);
				Script = Script.replace('#customerID', caserecord.Customer_ID__c);
				Script = Script.replace('#advisorName', caserecord.Adviser_Name__c);
				callScript.Script__c = Script;
			}
		}
		return callScripts;
	}

	/**
	 * Author : Poornima Aduru
	 * This method saves the disclosure information.
	 * @description  setScriptConfirmation
	 * @param  scriptCheckVal       Boolean value that represents the disclosure.
	 * @param  CaseId       ID of the case record to be updated with new contact number.
	 **/
	@AuraEnabled
	public static void setScriptConfirmation(Boolean scriptCheckVal, String CaseId) {
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(CaseId);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		cases[0].isDisclosureConfirmed__c = scriptCheckVal;
		update cases[0];
	}

	/**
	 * Author : Poornima Aduru
	 * This method saves the consent information.
	 * @description setAstuteConsent
	 * @param  consentChoice       String value that represents the consent choice.
	 * @param  CaseId       ID of the case record to be updated with new contact number.
	 */
	@AuraEnabled
	public static void setAstuteConsent(String consentChoice, String CaseId) {
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(CaseId);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		cases[0].Consent_Choice__c = consentChoice;
		update cases[0];

		if (consentChoice == 'No') {
			addRemoveSelectedPolicyId(CaseId, '', 'RemoveAllOther');
		}
	}

	/**
	 * Author : Poornima Aduru
	 * This method gets the values of Case before initialization of component to maintain state.
	 * @param  caseID       ID of the case record to be updated with new contact number.
	 * @description getInitValues
	 * @return CaseWrap
	 **/
	@AuraEnabled
	public static CaseWrapper getInitValues(String caseID) {
		CaseWrapper casewrap = new CaseWrapper();
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		casewrap.caseObject = cases[0];
		if (String.isBlank(cases[0].New_Alternate_Contact__c)) {
			casewrap.isNewAlternateConBlank = true;
		} else {
			casewrap.isNewAlternateConBlank = false;
		}
		return casewrap;
	}

	/**
	 * Author : Poornima Aduru
	 * This method saves the Advisor type selected.
	 * @param  caseID       ID of the case record to be updated with new contact number.
	 * @param  advType      String that represents the Advisor type selected.
	 * @description saveAdvisorType
	 **/
	@AuraEnabled
	public static void saveAdvisorType(String caseID, String advType) {
		// system.debug('advtype' + advType);
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		cases[0].Virtual_Advisor_Selected__c = advType;
		update cases[0];
	}
	/**
	 * @description saveIDVStatus
	 * @param caseID
	 * @param IDVStatus
	 **/
	@AuraEnabled
	public static void saveIDVStatus(String caseID, Boolean IDVStatus) {
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		if (IDVStatus == true) {
			cases[0].ID_V_Completed__c = true;
		} else {
			cases[0].ID_V_Completed__c = false;
		}
		update cases[0];
		saveAdvisorType(caseID, 'VA');
	}
	/**
	 * @param  caseID
	 * @description getAdvisorTypeInitValues
	 * @return case
	 **/
	@AuraEnabled
	public static Case getAdvisorTypeInitValues(String caseID) {
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		return cases[0];
	}
	/** Adapt360 search
	 * @param  caseID
	 * @description getAdapt360ClientBean
	 * @return null
	 */
	@AuraEnabled
	public static Account getAdapt360ClientBean(String caseID) {
		//  System.debug('Inside getAdapt360ClientBean');
		String viewP = 'CIB_VIEW';
		Boolean hideMetaP = false;
		Account acc = new Account();
		ADAPT360_Resp_IB_v1 clientProfilesBean = new ADAPT360_Resp_IB_v1();
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		String searchValueCIF = cases[0].CIF_Custom__c;
		String searchValueID = cases[0].Customer_ID__c;
		String idType = cases[0].ID_Type__c;
		try {
			//  System.debug('>>>>>>>' + searchValueCIF);
			//  System.debug('>>>>>>>' + idType);
			if (searchValueCIF != null) {
				clientProfilesBean = ADAPT360_IH_v1.retrieveClientDetails('cif', searchValueCIF, viewP, hideMetaP);
			} else if (searchValueCIF == null && idType == 'SA ID') {
				clientProfilesBean = ADAPT360_IH_v1.retrieveClientDetails('identityDocument', searchValueID, viewP, hideMetaP);
			} else if (searchValueCIF == null && idType == 'Passport') {
				clientProfilesBean = ADAPT360_IH_v1.retrieveClientDetails('passport', searchValueID, viewP, hideMetaP);
			}
			// System.debug('>>>>>>>' + clientProfilesBean.ClientDetails);
			if (clientProfilesBean.ClientDetails != null) {
				acc = generateBeanClientAccountInfo(JSON.serialize(clientProfilesBean))[0];
				return acc;
			} else {
				return null;
			}
		} catch (Exception ex) {
			// System.debug(LoggingLevel.Finest, 'Exception : ClientFinderBase : getAdapt360ClientBean - ' + ex.getMessage());
			throw new AuraHandledException(ex.getMessage());
		}
	}

	/** Adapt360MDM search
	 * @param  caseID
	 * @description getAdapt360MDMBean
	 * @return Account
	 */
	@AuraEnabled
	public static Account getAdapt360MDMBean(String caseID) {
		//  System.debug('Inside getAdapt360MDMBean');
		String viewP = 'CIB_VIEW';
		Boolean hideMetaP = false;
		Account acc = new Account();
		ADAPT360_Resp_IB_v1 clientProfilesBean = new ADAPT360_Resp_IB_v1();
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		String searchValueCIF = cases[0].CIF_Custom__c;
		String searchValueID = cases[0].Customer_ID__c;
		String idType = cases[0].ID_Type__c;
		// system.debug('searchValueID---' + searchValueID);
		RegSer_InvolvedParties_Resp_IB_v1 involvedParties;
		try {
			// involvedParties = RegSer_InvolvedParties_IH_v1.getInvolvedParties('SAID', searchValueID, false);
			involvedParties = RegSer_InvolvedParties_IH_v1.getInvolvedParties('SAID', searchValueID, true);
			// System.debug('>>>>>>>' + involvedParties);
			// System.debug('>>>>>>>' + involvedParties.statusCode);
			if (involvedParties.statusCode == 200 && involvedParties.content.identifications != null) {
				// System.debug('here involvedParties' + involvedParties);
				acc = generateInvolvedPartyClientBean(JSON.serialize(involvedParties));
				acc.ID_Number__pc = null;
				//System.debug('???????' + acc);
				//acc.CIF__c = null;
				if (String.isNotBlank(acc.CIF__c)) {
					upsert acc CIF__c;

					Case objCase = new Case();
					objCase.Id = caseId;
					objCase.AccountId = acc.Id;
					update objCase;
				}

				return acc;
			} else {
				return null;
			}
		} catch (Exception ex) {
			//System.debug(LoggingLevel.Finest, 'Exception : ClientFinderBase : getInvolvedPartyClientBean - ' + ex.getMessage());
			throw new AuraHandledException(ex.getMessage());
		}
	}
	/**
	 * @param  caseID
	 * @description searchInSalesforce
	 * @return null
	 */
	@AuraEnabled
	public static String searchInSalesforce(String caseID) {
		// System.debug('Inside SFsearch');
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		List<Account> acc = new List<Account>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		String searchValueCIF = cases[0].CIF_Custom__c;
		String searchValueID = cases[0].Customer_ID__c;
		// List<Account>  acc = [Select id from Account where (CIF__c = : searchValueCIF ) AND (ID_Number__pc=: searchValueID) ];
		acc = new AccountsSelector().selectAccountByCIFAndID(searchValueCIF, searchValueID);
		if (acc != null && !acc.isEmpty()) {
			String accId = acc[0].id;
			return accId;
		} else {
			return null;
		}
	}
	/**
	 * @param  acc
	 * @description createClientFromCIF
	 * @return String
	 */
	@AuraEnabled
	public static String createClientFromCIF(Account acc) {
		//  System.debug('cif test acc=' + acc);
		String accCreationResult;
		accCreationResult = AccountWizardController.createAccount(null, acc);
		if (accCreationResult.contains('Success')) {
			String accId = accCreationResult.substringAfter(':');
			// System.debug('cif test accId=' + accId);
			return accId;
		} else {
			return null;
		}
	}
	/**
	 * @param  accId
	 * @param caseID
	 * @description updateClientFromCIF
	 */
	@AuraEnabled
	public static void updateClientFromCIF(String accId, String caseID) {
		//System.debug('Ciftest' + accId + 'caseid' + caseID);
		account tst = [SELECT id, Work_Phone__pc, PersonEmail FROM account WHERE id = :accId LIMIT 1];
		// System.debug('tst------' + tst.PersonEmail);
		Account accPhoneUpdate;
		Set<String> idSet = new Set<String>();
		List<Case> cases = new List<Case>();
		idSet.add(caseID);
		cases = new CasesSelector().selectByIdWithCustomerInfo(idSet);
		accPhoneUpdate = new AccountsSelector().selectAccountPhoneDetailsByID(accId);
		accPhoneUpdate.Work_Phone__pc = cases[0].Work_Phone__c;
		accPhoneUpdate.Alternate_Phone1__pc = cases[0].Alternate_Phone1__c;
		accPhoneUpdate.Alternate_Phone2__pc = cases[0].Alternate_Phone2__c;
		accPhoneUpdate.Alternate_Phone3__pc = cases[0].Alternate_Phone3__c;
		accPhoneUpdate.Alternate_Phone4__pc = cases[0].Alternate_Phone4__c;
		accPhoneUpdate.Alternate_Phone5__pc = cases[0].Alternate_Phone5__c;
		accPhoneUpdate.Alternate_Phone6__pc = cases[0].Alternate_Phone6__c;
		accPhoneUpdate.Alternate_Phone7__pc = cases[0].Alternate_Phone7__c;
		cases[0].AccountId = accId;
		try {
			update accPhoneUpdate;
			// System.debug('Ciftest' + accPhoneUpdate.Alternate_Phone1__pc);
			// System.debug('Ciftest' + accPhoneUpdate.PersonEmail);
			update Cases[0];
		} catch (Exception ex) {
			// System.debug(LoggingLevel.Finest, 'Exception : BrokerNoteProcessController : getAdapt360ClientBean - ' + ex.getMessage());
			throw new AuraHandledException(ex.getMessage());
		}
	}
	/**
	 * @param  clientProfilesBeanText
	 * @description generateBeanClientAccountInfo
	 * @return null
	 */
	public static List<Account> generateBeanClientAccountInfo(String clientProfilesBeanText) {
		List<Account> accountListReturned = new List<Account>();
		accountListReturned = generateAdapt360ClientBean(clientProfilesBeanText);
		// System.debug(LoggingLevel.Finest, '###accountListReturned : ' + accountListReturned);
		return accountListReturned;
	}
	/****
	 * Author - vj
	 * Method is created to get document id from Document Object.
	 * @description SendEmailToCustomer
	 * @param CaseId
	 * @return string
	 ****/

	@AuraEnabled
	public static String SendEmailToCustomer(String CaseId) {
		DocumentsSelector dSelect = new DocumentsSelector();
		list<document__c> doc = dSelect.selectDocumentListBycaseId(CaseId);
		if (doc == null || doc.size() <= 0) {
			return 'Broker note not generated';
		} else {
			BrokerNoteProcessController.EmailToCusForCaseComp(null, CaseId);
		}
		return 'success';
	}

	/**
	 * Author - vj
	 * Method is created to get document from ECM and send mail to advisor.
	 * @description EmailToCusForCaseComp
	 * @param  documentId
	 * @param  caseID
	 ****/
	@AuraEnabled
	public static void EmailToCusForCaseComp(string documentId, string caseID) {
		user Usr = getVirtualAdviserDetails(caseID);
		CasesSelector cSelector = new CasesSelector();
		list<case> cObj = cSelector.selectByCaseId(caseId);
		list<String> EmailIds = new List<String>();
		//Added By Himan as Part of VA Email Issue
		for (case cs : cObj) {
			EmailIds.add(cs.Email__c); //adviser email
		}
		// system.debug('EmailIds---->' + EmailIds);
		list<EmailTemplate> em = new List<EmailTemplate>();
		EmailTemplatesSelector EmailTempSelector = new EmailTemplatesSelector();
		em = EmailTempSelector.selectByName('CaseCompleteEmail');
		OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :system.label.EmailAddLabel];
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setTargetObjectId(cObj[0].Account.PersonContactId);
		email.setToAddresses(EmailIds);
		email.setWhatId(caseId);
		email.setSaveAsActivity(true);
		email.setOrgWideEmailAddressId(owd.Id);
		email.setTreatTargetObjectAsRecipient(false);
		email.setTemplateId(em.get(0).id);
		if (!Test.isRunningTest()) {
			Messaging.SendEmailResult[] r = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
		}
	}
	/**
	 * @param -  empty
	 * @description ECMLogin
	 * @return null
	 */
	public static ECM_LoginResult_IB_V1 ECMLogin() {
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		return login;
	}
	// ***** VK methods Starts *********

	/****
	 * Author - venkatesh K
	 * Method is to update status of case as completed when BrokerNoteProcess is finished!
	 * @description finishButton
	 * @param CaseId the current case Id
	 * @return string
	 ****/
	@AuraEnabled
	public static String finishButton(
		String CaseId //VK
	) {
		CasesSelector cSelector = new CasesSelector();
		list<case> cObj = cSelector.selectCaseDetailsForBrokerNote(CaseId);
		cObj[0].Status = 'Completed';
		cObj[0].Outcome__c = 'Broker Note Completed';
		update cObj[0];
		return cObj[0].Status + '';
	}

	/**
	 * Author - venkatesh K
	 * Method is to store or remove selected policies(IDs) inside current case (field name:SelectedPoliciesID__c) record
	 * @description addRemoveSelectedPolicyId
	 * @param  caseid  the current case Id
	 * @param  policyIds  ID of selected policy;
	 * @param  check specifies which operation is being performed
	 * @return String
	 */
	@AuraEnabled
	public static String addRemoveSelectedPolicyId(String caseid, String policyIds, String check) {
		/* System.debug('caseid' + caseid);
        System.debug('policyIds' + policyIds);
        System.debug('check' + check); */
		//VK
		//Case currentCase = [select id,SelectedPoliciesID__c from Case where Id = :caseid][0];
		CasesSelector cSelector = new CasesSelector();
		list<case> cObj = cSelector.selectCaseDetailsForBrokerNote(caseid);
		Case currentCase = cobj[0];
		// Case_Support__c currentPolicy = [select id,IsSelected__c from Case_Support__c where Id = :policyIds][0];
		if (check == 'Add') {
			String existingIds = currentCase.SelectedPoliciesID__c;
			List<String> ListofIds;
			if (existingIds != null)
				ListofIds = existingIds.split(';');
			else
				ListofIds = new List<String>();
			Set<String> SetofIds = new Set<String>(ListofIds);
			SetofIds.add(policyIds);
			List<String> newList = new List<String>(SetofIds);
			String updatedIds = string.join(newList, ';');
			currentCase.SelectedPoliciesID__c = updatedIds;
		} else if (check == 'Remove') {
			//currentPolicy.IsSelected__c = false;
			//update currentPolicy; system.debug('updated');
			String existingIds = currentCase.SelectedPoliciesID__c;
			List<String> ListofIds;
			if (existingIds != null)
				ListofIds = existingIds.split(';');
			else
				ListofIds = new List<String>();
			Set<String> SetofIds = new Set<String>(ListofIds);
			SetofIds.remove(policyIds);
			List<String> newList = new List<String>(SetofIds);
			String updatedIds = string.join(newList, ';');
			currentCase.SelectedPoliciesID__c = updatedIds;
		} else if (check == 'SelectAllMain') {
			Case currentCasewithPolicy = [
				SELECT id, SelectedPoliciesID__c, (SELECT id FROM Case_Support__r WHERE Other_Policy__c = FALSE)
				FROM Case
				WHERE Id = :caseid
			][0];
			String existingIds = currentCase.SelectedPoliciesID__c;
			List<String> ListofIds;
			if (existingIds != null)
				ListofIds = existingIds.split(';');
			else
				ListofIds = new List<String>();
			Set<String> SetofIds = new Set<String>(ListofIds);
			for (Case_Support__c cs : currentCasewithPolicy.Case_Support__r)
				SetofIds.add(cs.id);
			List<String> newList = new List<String>(SetofIds);
			String updatedIds = string.join(newList, ';');
			currentCase.SelectedPoliciesID__c = updatedIds;
		} else if (check == 'RemoveAllMain') {
			Case currentCasewithPolicy = [
				SELECT id, SelectedPoliciesID__c, (SELECT id FROM Case_Support__r WHERE Other_Policy__c = FALSE)
				FROM Case
				WHERE Id = :caseid
			][0];
			String existingIds = currentCase.SelectedPoliciesID__c;
			List<String> ListofIds;
			if (existingIds != null)
				ListofIds = existingIds.split(';');
			else
				ListofIds = new List<String>();
			Set<String> SetofIds = new Set<String>(ListofIds);
			for (Case_Support__c cs : currentCasewithPolicy.Case_Support__r)
				SetofIds.remove(cs.id);
			List<String> newList = new List<String>(SetofIds);
			String updatedIds = string.join(newList, ';');
			currentCase.SelectedPoliciesID__c = updatedIds;
		} else if (check == 'SelectAllOther') {
			Case currentCasewithPolicy = [
				SELECT id, SelectedPoliciesID__c, (SELECT id FROM Case_Support__r WHERE Other_Policy__c = TRUE)
				FROM Case
				WHERE Id = :caseid
			][0];
			String existingIds = currentCase.SelectedPoliciesID__c;
			List<String> ListofIds;
			if (existingIds != null)
				ListofIds = existingIds.split(';');
			else
				ListofIds = new List<String>();
			Set<String> SetofIds = new Set<String>(ListofIds);
			for (Case_Support__c cs : currentCasewithPolicy.Case_Support__r)
				SetofIds.add(cs.id);
			List<String> newList = new List<String>(SetofIds);
			String updatedIds = string.join(newList, ';');
			currentCase.SelectedPoliciesID__c = updatedIds;
		} else if (check == 'RemoveAllOther') {
			Case currentCasewithPolicy = [
				SELECT id, SelectedPoliciesID__c, (SELECT id FROM Case_Support__r WHERE Other_Policy__c = TRUE)
				FROM Case
				WHERE Id = :caseid
			][0];
			String existingIds = currentCase.SelectedPoliciesID__c;
			List<String> ListofIds;
			if (existingIds != null)
				ListofIds = existingIds.split(';');
			else
				ListofIds = new List<String>();
			Set<String> SetofIds = new Set<String>(ListofIds);
			for (Case_Support__c cs : currentCasewithPolicy.Case_Support__r)
				SetofIds.remove(cs.id);
			List<String> newList = new List<String>(SetofIds);
			String updatedIds = string.join(newList, ';');
			currentCase.SelectedPoliciesID__c = updatedIds;
		}
		update currentCase;
		return currentCase.SelectedPoliciesID__c;
		//return currentPolicy.IsSelected__c+'';
	}

	/**
	 * Author - venkatesh K
	 * Method is use to send email at the end of F2F advisor selection and to update case status to completed
	 * @description sendEmailf2f
	 * @param  emailId emailid of recevier
	 * @param  content description: entered
	 * @param  caseid the current case Id
	 * @param  advisor name of the selected advisor
	 */
	@AuraEnabled
	public static void sendEmailf2f(String emailId, String content, String caseid, String advisor) {
		//VK
		CasesSelector cSelector = new CasesSelector();
		list<case> cObj = cSelector.selectCaseDetailsForBrokerNote(caseid);
		Case currentCase1 = cobj[0];
		currentCase1.Description = content;
		update currentCase1;
		EmailTemplatesSelector EmailTempSelector = new EmailTemplatesSelector();
		list<EmailTemplate> em = new List<EmailTemplate>();
		em = EmailTempSelector.selectByName('Absa Insurance and Financial Advisers – Lead confirmation');
		/*Start Added By Himan For VA Email Issue*/
		list<String> EmailIds = new List<String>();
		/* for(case cs : cObj) {
EmailIds.add(cs.Email__c);  
}*/
		// system.debug('EmailIds---->' + EmailIds);
		/*End Added By Himan For VA Email Issue*/
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :system.label.EmailAddLabel];
		mail.setOrgWideEmailAddressId(owd.Id);
		List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
		String defaulttargetObjectId = null;
		/*if (mdt.size()>0 ) {
defaulttargetObjectId = mdt[0].Value__c;
}*/ //changed by pranav for prduction issue on 01-07-2021
		List<Contact> contacts = new List<Contact>([SELECT Id FROM Contact WHERE Email != NULL AND Birthdate != NULL LIMIT 1]); // added by pranav for prod issue for setting up the targetEmailID on 01-07-2021

		if (contacts.size() > 0) {
			defaulttargetObjectId = contacts[0].Id;
		}

		String[] toAddress = new List<String>{ emailId };
		mail.setToAddresses(toAddress);
		mail.setSaveAsActivity(true);
		mail.setWhatId(caseid);
		mail.setTemplateId(em.get(0).id);
		mail.setTreatTargetObjectAsRecipient(false);

		if (string.isBlank(cObj[0].Account.PersonContactId))
			mail.setTargetObjectId(defaulttargetObjectId);
		else {
			mail.setTargetObjectId(cObj[0].account.PersonContactId);
		}

		if (!Test.isRunningTest()) {
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
		}

		if (caseid != null) {
			list<case> cObj1 = cSelector.selectCaseDetailsForBrokerNote(caseid);
			Case currentCase = cobj1[0];
			currentCase.Status = 'Completed';
			currentCase.Outcome__c = 'Referred to F2F Advisor';
			//System.debug('caseid: ' + currentCase.id);
			update currentCase;
			//System.debug('caseid: ' + currentCase.Status);
		}
	}

	/** 
* Author - venkatesh K
* Method is use to update case status to In Progress when user is in between the process 
and to return the user site record associated with the current case
* @param  caseid the current case Id
* @description currentUsersiteRec
* @return User_Site__c
*/
	@AuraEnabled
	public static User_Site__c currentUsersiteRec(string caseid) {
		//VK
		// System.debug('caseid==>' + caseid);
		//Case currentCase = [select id,Status,Outcome__c,SelectedAdvisorIdF2F__c from Case where Id = :caseid][0]; //mod by VK
		CasesSelector cSelector = new CasesSelector();
		list<case> cObj = cSelector.selectCaseDetailsForBrokerNote(caseid);
		Case currentCase = cobj[0];
		if (currentCase.Status != 'Completed') {
			currentCase.Status = 'In Progress';
			currentCase.Outcome__c = 'In Progress';
		}

		try {
			update currentCase;
		} catch (Exception e) {
			String msg = '';
			//  System.debug('exception caught: ' + e.getMessage());
		}
		// System.debug('caseid: ' + currentCase.Status);
		UserSitesSelector uSelector = new UserSitesSelector();
		list<User_Site__c> uObj = uSelector.selectByUserId(currentCase.SelectedAdvisorIdF2F__c);
		User_Site__c userSiteRec = uObj[0];
		/*User_Site__c userSiteRec=[select id,BSiteName__c,userEmail__c,User__c,User__r.Name from User_Site__c where User__c =: currentCase.SelectedAdvisorIdF2F__c][0];
		 system.debug('userSiteRec===>'+userSiteRec);*/
		return userSiteRec;
	}

	/**
	 * Author - venkatesh K
	 * Method is  to return City Information from Use for city selection.
	 * @description fetchLookUpValues
	 * @param searchKeyWord
	 * @param ObjectName
	 * @return List <sObject>
	 */

	@AuraEnabled
	public static List<sObject> fetchLookUpValues(String searchKeyWord, String ObjectName) {
		//VK
		// System.debug('ObjectName-->' + ObjectName + ' searched key is:' + searchKeyWord);
		String searchKey = searchKeyWord + '%';
		List<sObject> returnList = new List<sObject>();
		//  Dynamic SOQL Query For Fetch Record List with LIMIT 5
		//string qry = '\'' +searchKey +'\'';
		/*	String sQuery =
'select Id, Name,BSiteName__c,SiteCity__c,Site__r.branch_Site_Name__c,Site__r.Cities_PickList__c,User__c  from User_Site__c where Site__r.Cities_PickList__c LIKE ' +
'%' +
searchKey +
'%' +
' Limit 3';
// sQuery+= '\'' +searchKey +'\''+ ' Limit 3';        
system.debug('SOQL-->' + sQuery);
List<sObject> lstOfRecords = Database.query(sQuery); */
		List<sObject> lstOfRecords = [
			SELECT Id, Name, BSiteName__c, SiteCity__c, Site__r.branch_Site_Name__c, Site__r.Cities_PickList__c, User__c
			FROM User_Site__c
			WHERE Site__r.Cities_PickList__c LIKE :searchKey
		];
		//List <User_Site__c> uslist = [select Id, Name,BSiteName__c,Site__r.branch_Site_Name__c,Site__r.Cities_PickList__c,User__c  from User_Site__c where Site__r.Cities_PickList__c LIKE  :searchKey ];
		UserSitesSelector uSelector = new UserSitesSelector();
		list<User_Site__c> uslist = uSelector.selectBySiteCity(searchKey);
		Map<String, sObject> mapStrByCity = new Map<String, sObject>();
		for (User_Site__c US : uslist) {
			for (sObject rec : lstOfRecords) {
				if (rec.id == US.id)
					mapStrByCity.put(US.SiteCity__c, rec);
			}
		}
		return mapStrByCity.values(); //Adding comment
	}
    /**
     * Author - Vikas B
     * Method is  to return Users
     * @description fetchLookUpValuesuser
     * @param  searchKeyWord
     * @param  ObjectName
     * @return List<sObject>
     */
    @AuraEnabled
    public static List<sObject> fetchLookUpValuesuser(String searchKeyWord, String ObjectName) {
        String searchKey = '%' + searchKeyWord + '%';
        List<sObject> returnList = new List<sObject>();
        /*List<sObject> lstOfRecords = [SELECT Id, UserName__c, Name, BSiteName__c, SiteCity__c, Site__r.branch_Site_Name__c, Site__r.Cities_PickList__c, User__c
         FROM User_Site__c WHERE UserName__c LIKE :searchKey];*/
        List<sObject> lstOfRecords = [SELECT Id, Name, Skills_Products__c, LanguageLocaleKey FROM user WHERE isActive = TRUE AND Name LIKE :searchKey LIMIT 5];
        return lstOfRecords;
    }
	/**
	 * Author - venkatesh K
	 * Method is  to return Face2Face Advisor Information from User based on the City Chosen.
	 * @description getF2FAdvInfo
	 * @param  searchKeyWord
	 * @return null
	 */

	@AuraEnabled
	public static LtngWrap getF2FAdvInfo(string searchKeyWord) {
		//VK
		LtngWrap wrap = new LtngWrap();
		// wrap.lstUsers;
		set<Id> setIds = new Set<Id>();
        List<User_Site__c> lstUserSiteRecs = new List<User_Site__c>();
		// System.debug('searchKeyWord==>' + searchKeyWord);
		wrap.mapUserSites = new Map<String, list<String>>();
		//List<User_Site__c> lstUserSiteRecs=  [select Id, Name,BSiteName__c,SiteCity__c,UserName__c, Site__c, Site__r.branch_Site_Name__c,Site__r.Cities_PickList__c from User_Site__c    where Site__r.Cities_PickList__c=:searchKeyWord ];
		UserSitesSelector uSelector = new UserSitesSelector();
		//List<User_Site__c> lstUserSiteRecs = uSelector.selectBySiteCity(searchKeyWord);
        if (searchKeyWord.startsWith('005'))
            lstUserSiteRecs = uSelector.selectByUserId(searchKeyWord);
        else
            lstUserSiteRecs = uSelector.selectBySiteCity(searchKeyWord);
            for (User_Site__c a : lstUserSiteRecs) {
			setIds.add(a.User__c);
			if (wrap.mapUserSites.containsKey(a.BSiteName__c)) {
				wrap.mapUserSites.get(a.BSiteName__c).add(a.User__c);
			} else {
				List<string> lstCon1 = new List<string>();
				lstCon1.add(a.User__c);
				wrap.mapUserSites.put(a.BSiteName__c, lstCon1);
			}
		}
		// System.debug('setIds==>' + setIds);
		UsersSelector selUsers = new UsersSelector();
		List<User> lstUsers = selUsers.selectByIdWithRole(setIds);
		//List<User> lstUsers=[select id,LastName,Name from user where Id IN :setIds];
		wrap.lstUserRecs = lstUsers;
		//System.debug('wrap.lstUser==>'+lstUsers);
		return wrap;
	}
	/**
	 * Author - venkatesh K
	 * Method is to return newly added policy details on the current opened case
	 * @param caseID
	 * @description showOtherPolicies
	 * @return null
	 */
	@AuraEnabled
	public static List<Id> showOtherPolicies(String caseID) {
		//VK
		id cuurentUserId = userinfo.getUserId();
		/*
List<Case_Support__c>  SelPol=[SELECT Id,Product_Name__c,Policy_Number__c,Policy_Type__c,
Product_Provider__c,Risk_Sum_Assured__c,
Inception_Date__c,CreatedById FROM case_support__c where Case__r.Id =: caseID AND Other_Policy__c=true]; //where createddate=today 
//AND  CreatedById=:cuurentUserId];
*/
		//////
		List<Case_Support__c> listOfPolicies = new List<Case_Support__c>();
		CaseSupportSelector cSupportSelector = new CaseSupportSelector();
		List<Id> CaseSupportIdList = new List<Id>();
		listOfPolicies = cSupportSelector.selectByCaseID(caseID);
		for (case_support__c c : listOfPolicies) {
			if (c.Other_Policy__c == true) {
				CaseSupportIdList.add(c.Id);
			}
		} /////
		/*List<Id> CaseSupportIdList=new List<Id>();
for(case_support__c c:SelPol){
CaseSupportIdList.add(c.Id);
} */
		return CaseSupportIdList;
	}
	/**
	 *  Author - venkatesh K
	 * Method is to return policies associated with case Object
	 * @param caseId
	 * @description showPolicies
	 * @return null
	 */
	@AuraEnabled
	//Public Static List<Id> showPolicies(String caseId){
	public static policyConsentWrapper showPolicies(String caseId) {
		//VK
		List<Case_Support__c> listOfPolicies = new List<Case_Support__c>();
		CaseSupportSelector cSupportSelector = new CaseSupportSelector();
		List<Id> CaseSupportIdList = new List<Id>();
		listOfPolicies = cSupportSelector.selectByCaseID(caseId);
		for (case_support__c c : listOfPolicies) {
			if (c.Other_Policy__c == false) {
				CaseSupportIdList.add(c.Id);
			}
		}
		Case mycase = new CasesSelector().selectByIdWithCustomerInfo(new Set<String>{ caseId })[0];
		mycase.SelectedPoliciesID__c = '';
		update mycase;
		policyConsentWrapper pcw = new policyConsentWrapper();
		pcw.CaseSupportIdList = CaseSupportIdList;
		//pcw.Consent = mycase.isConsentConfirmed__c;
		pcw.Consent = mycase.Consent_Choice__c;
		return pcw;
		//return CaseSupportIdList;
	}

	/**
	 *  Author - Omkar Narkar
	 *Method is to return policies associated with case Object
	 * @param caseId
	 * @return result
	 * @description getPolicies
	 */
	@AuraEnabled
	public static Object getPolicyInfo(String caseId) {
		Map<String, Object> result = new Map<String, Object>();

		CasesSelector cSelector = new CasesSelector();
		Case currentCase = cSelector.selectByIdWithCustomerInfo(new Set<String>{ caseId })[0];
		Set<String> selectedPolicyIds = String.isBlank(currentCase.SelectedPoliciesID__c)
			? new Set<String>()
			: new Set<String>(currentCase.SelectedPoliciesID__c.split(';'));

		List<PolicyWrapper> clientPolicies = new List<PolicyWrapper>();
		List<PolicyWrapper> otherPolicies = new List<PolicyWrapper>();

		CaseSupportSelector cSupportSelector = new CaseSupportSelector();
		for (case_support__c c : cSupportSelector.selectByCaseID(caseId)) {
			if (c.Other_Policy__c == false) {
				clientPolicies.add(new PolicyWrapper(c.Id, selectedPolicyIds.contains(c.Id)));
			} else {
				otherPolicies.add(new PolicyWrapper(c.Id, selectedPolicyIds.contains(c.Id)));
			}
		}

		result.put('ClientPolicies', clientPolicies);
		result.put('OtherPolicies', otherPolicies);
		result.put('Consent', currentCase.Consent_Choice__c);

		return result;
	}
	/**
	 * Author - Omkar Narkar
	 * PolicyWrapper Class
	 * @description PolicyWrapper
	 */
	public class PolicyWrapper {
		@AuraEnabled
		public String recordId;
		@AuraEnabled
		public Boolean selected;
		/**
		 * Author - Omkar Narkar
		 * @param recordId
		 * @param selected
		 * @description PolicyWrapper
		 */
		public PolicyWrapper(String recordId, Boolean selected) {
			this.recordId = recordId;
			this.selected = selected;
		}
	}

	/**
	 * Author - venkatesh K
	 * Method is to update case status and add user to current case
	 * @description addAdvisorIdtoCase
	 * @param  userId Id of user
	 * @param caseid  case id of current case record
	 * @param agentNotes
	 * @return String
	 */
	@AuraEnabled
	public static String addAdvisorIdtoCase(string userId, string caseid, String agentNotes) {
		/* System.debug('userId :' + userId);
        System.debug('caseid :' + caseid);
        System.debug('agentNotes :' + agentNotes); */
		String returnString;
		List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
		String defaulttargetObjectId = null;
		/*if (mdt.size()>0 ) {
defaulttargetObjectId = mdt[0].Value__c;
}*/ // commented by pranav for Production issue on 01-07-2021 and changed to below
		List<Contact> contacts = new List<Contact>([SELECT Id FROM Contact WHERE Email != NULL AND Birthdate != NULL LIMIT 1]); // added by pranav for prod issue for setting up the targetEmailID on 01-07-2021
		if (contacts.size() > 0) {
			defaulttargetObjectId = contacts[0].Id;
		} // added by pranav for Production issue on 01-07-2021 a
		if (caseid != null) {
			CasesSelector cSelector = new CasesSelector();
			List<case> cObj = cSelector.selectCaseDetailsForBrokerNote(caseid);
			Case currentCase = cobj[0];
			currentCase.SelectedAdvisorIdF2F__c = userId;
			//Updated for Virtual Advisor Client Review and Maturity
			if (
				currentCase.RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_CLIENT_REVIEW ||
				currentCase.RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_MATURITY
			) {
				//currentCase.VA_Client_Referral_Type__c = StringConstants.CASE_REFERRAL_TYPE_F2F;
				//currentCase.OwnerId = userId;
				currentCase.Comments__c = agentNotes;
				currentCase.Advisor__c = userId;
				currentCase.Client_Review_Sub_Status__c = StringConstants.CASE_SUB_STATUS_REFERRED;
				currentCase.Status = StringConstants.CASE_STATUS_CLOSED;
				currentCase.Bypass_Validation_Rules__c = true;
				returnString = 'Success';
				update currentCase;
				OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :StringConstants.VIRTUAL_ADVISOR_OWD_EMAIL];
				User usrAdvisor = [SELECT id, name, email FROM user WHERE id = :userId LIMIT 1];
				List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
				List<EmailTemplate> emailTemplates = new List<EmailTemplate>();
				Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
				List<String> sendTo = new List<String>();
				List<String> sendCc = new List<String>();

				if (currentCase.RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_CLIENT_REVIEW)
					emailTemplates = [
						SELECT Id, Subject, Body, HtmlValue
						FROM EmailTemplate
						WHERE DeveloperName = 'VA_Face_To_Face_Advisor_Referral_Email'
						LIMIT 1
					];
				else if (currentCase.RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_MATURITY)
					emailTemplates = [
						SELECT Id, Subject, Body, HtmlValue
						FROM EmailTemplate
						WHERE DeveloperName = 'VA_Face_To_Face_Advisor_Referral_Email_Maturity'
						LIMIT 1
					];

				/* if(isSandbox())
{
sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
}
else
{
sendTo.add(usrAdvisor.email);                    
sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
} */

				//sendCc.add(currentCase.Owner.Email);
				sendTo.add(usrAdvisor.email);
				email.setToAddresses(sendTo);
				//email.setCcAddresses(sendCc);
				email.setOrgWideEmailAddressId(owd.Id);
				/*if(currentCase.ContactId != null)
email.setTargetObjectId(currentCase.ContactId);
else
email.setTargetObjectId(defaulttargetObjectId);*/

				if (string.isBlank(currentCase.Account.PersonContactId))
					email.setTargetObjectId(defaulttargetObjectId);
				else {
					email.setTargetObjectId(currentCase.account.PersonContactId);
				}

				email.setWhatId(currentCase.Id);
				email.setTreatTargetObjectAsRecipient(false);
				email.setSaveAsActivity(true);
				email.setTemplateId(emailTemplates[0].id);
				emails.add(email);

				Messaging.sendEmail(emails);
			} else if (currentCase.Status != 'Completed' || currentCase.Status != 'Closed') {
				currentCase.Status = 'In Progress';
				currentCase.Outcome__c = 'In Progress';
				update currentCase;
			}
		}

		return returnString;
	}

	/**
	 * Author - venkatesh K
	 * @description isSandbox
	 * @return Boolean
	 */

	public static Boolean isSandbox() {
		return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
	}
	/**
*  Author - venkatesh K
* Method is used update the case status to new dynamically, when customer lands on first screen
* @param caseid
* @description updateStatustoNew

*/
	@AuraEnabled
	public static void updateStatustoNew(string caseid) {
		//vk
		if (caseid != null) {
			//Case currentCase = [select id,SelectedAdvisorIdF2F__c,Outcome__c,Status from Case where Id = :caseid][0];
			CasesSelector cSelector = new CasesSelector();
			list<case> cObj = cSelector.selectCaseDetailsForBrokerNote(caseid);
			Case currentCase = cobj[0];
			if (currentCase.Status != 'Completed') {
				currentCase.Status = 'New';
				currentCase.Outcome__c = 'New Case';
			}
			update currentCase;
		}
	}
	// ********Methods created by VK ends**********

	/**
	 * Author - Omkar Narkar
	 * Method is used provide sObjectType based on provided recordId
	 * @param recordId
	 * @return string
	 * @description getObjectName
	 */
	@AuraEnabled
	public static String getObjectName(Id recordId) {
		return recordId.getSobjectType().getDescribe().getName();
	}

	/**
	 * Author - Divya
	 * Method is used provide sObjectType based on provided recordId
	 * @param userId
	 * @param oppId
	 * @param agentNotes
	 * @return string
	 * @description send SMS & Email to Agent&Customer
	 */
    @AuraEnabled
    public static String referOpportunityToF2F(string userId, string oppId, String agentNotes)
    {
        string returnString = '';
        List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
        String defaulttargetObjectId = null;
        if (mdt.size()>0 ) {
            defaulttargetObjectId = mdt[0].Value__c;
        }
        if(oppId != null){
        Opportunity opp = new Opportunity();
        OpportunitiesSelector oppSelector = new OpportunitiesSelector();
        opp = oppSelector.selectByOppId(oppId);
        // adding record type check for investment opportunity
        if(opp.RecordType.Name == 'Investment Opportunity'){
            opp.StageName = 'Closed';
            opp.Sub_Status__c = 'Referred to F2F';
            opp.Sys_BypassValidation__c = true;
            opp.Comments__c  = agentNotes;
            opp.OwnerId = userId;
            update opp;
            // now send an email to new Advisor that Opportunity is referred
            UsersSelector usrSelector = new UsersSelector();
            User u = new User();
            u = usrSelector.selectById(userId);
            List<Messaging.SingleEmailMessage> emails =  new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            List<String> sendCc = new List<String>();
            OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address =: StringConstants.VIRTUAL_ADVISOR_ABSA_EMAIL];
            //sendCc.add(currentCase.Owner.Email);
            sendTo.add(u.email); // uncomment when testing complete
            email.setToAddresses(sendTo);
            //email.setCcAddresses(sendCc);
            email.setOrgWideEmailAddressId(owd.Id);
            if(string.isNotBlank(defaulttargetObjectId) )
                email.setTargetObjectId(defaulttargetObjectId);
            email.setWhatId(opp.Id);
            email.setTreatTargetObjectAsRecipient(false);
            email.setSaveAsActivity(true);
            email.setTemplateId(EmailOutboundService.getEmailTemplate('INV_VA_Advisor_Referral_Email').Id);
            emails.add(email);
            //Send Email to Customer
            Messaging.SingleEmailMessage customeremail = getCustomerEmailTemplate(opp,defaulttargetObjectId,u,owd,'INV_Refer_Email_to_Customer',true);
            Messaging.SingleEmailMessage customeremail1 = getCustomerEmailTemplate(opp,defaulttargetObjectId,u,owd,'Investment_Opportunity_Notify_Adviser',false);
            emails.add(customeremail);
            emails.add(customeremail1);
            Messaging.sendEmail(emails);
            // send an sms to the customer
           if(!Test.isRunningTest()){
               dispatchSMS(null,opp.Id,opp.Mobile__c,'',StringConstants.INV_F2F_QUICK_TEXT, StringConstants.VA_ITOUCH_SMS_INTEGRATION_SERVICE, true);
           }
               returnString = 'Success';
        }
    }
        return returnString;
    }
	/**
	 * @description dispatchSMS
	 * @param  whoId
	 * @param  whatId
	 * @param  phoneNumberOverride
	 * @param  recipientNameOverride
	 * @param  quickTextName
	 * @param  integrationService
	 * @param  saveAsActivity
	 **/
	@Future(Callout=true)
	public static void dispatchSMS(
		Id whoId,
		Id whatId,
		String phoneNumberOverride,
		String recipientNameOverride,
		String quickTextName,
		String integrationService,
		boolean saveAsActivity
	) {
		SMSHandler.sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
	}
	/**
	 * //Added By divya
	 * @description getCustomerEmailTemplate
	 * @param  opp
	 * @param  targetId
	 * @param  user
	 * @param  owd
	 * @param  tempname
	 * @param  isChangeTemp
	 * @return SingleEmailMessage
	 **/
    public static Messaging.SingleEmailMessage getCustomerEmailTemplate(Opportunity opp,Id targetId, User user,OrgWideEmailAddress owd, String tempname, boolean isChangeTemp)
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        List<String> sendCc = new List<String>();
        EmailTemplate emailTemplate = EmailOutboundService.getEmailTemplate(tempname);
        Messaging.SingleEmailMessage message = EmailOutboundService.processEmailTemplate(emailTemplate.Id,opp.Id);
        //sendCc.add(currentCase.Owner.Email);
        if(isChangeTemp){
            sendTo.add(opp.Email__c);
        }
        else{
            sendTo.add(user.email);
        }
        email.setToAddresses(sendTo);
        //email.setCcAddresses(sendCc);
        email.setOrgWideEmailAddressId(owd.Id);
        email.setTargetObjectId(targetId);
        email.setWhatId(opp.Id);
        email.setTreatTargetObjectAsRecipient(false);
        email.setSaveAsActivity(true);
        //Append Owner Details
        if(user != null && isChangeTemp)
        {
			emailTemplate.HtmlValue=emailTemplate.HtmlValue.replace('{!Opportunity.OwnerFullName}',user.Name !=null?user.Name:'');
			emailTemplate.HtmlValue=emailTemplate.HtmlValue.replace('{!Opportunity.OwnerPhone}',user.Phone !=null?user.Phone:'');
            emailTemplate.HtmlValue=emailTemplate.HtmlValue.replace('{!Opportunity.Owner_Cell_Phone__c}',user.MobilePhone !=null?user.MobilePhone:'');
			emailTemplate.HtmlValue=emailTemplate.HtmlValue.replace('{!Opportunity.OwnerEmail}',user.Email !=null?user.Email:'');
            String address = '';
            if(user.Address!= null){
                if(user.Address.getStreet() != null){
                    address += user.Address.getStreet() + ', ';
                }
                if(user.Address.getCity() != null){
                    address += user.Address.getCity() + ', ';
                }
                if(user.Address.getState() != null){
                    address += user.Address.getState() +', ';
                }
                if(user.Address.getCountry() != null){
                    address += user.Address.getCountry()+ ', ';
                }
                if(user.Address.getPostalCode() != null){
                    address += user.Address.getPostalCode();
                }
            }
			emailTemplate.HtmlValue=emailTemplate.HtmlValue.replace('{!Opportunity.Owner_Address__c}',address);           
        }
        if(isChangeTemp){
            email.setHtmlBody(emailTemplate.HtmlValue);
        }
        else{
            email.setHtmlBody(message.getHtmlBody());
        }
        email.setSubject(emailTemplate.Subject);
        return email;
    }
}