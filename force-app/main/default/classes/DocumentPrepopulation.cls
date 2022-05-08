/**
 * @description Controller for Documents used by Lightning components
 * (DocumentShareHistoryEmail)
 * @author Danie Booysen
 * @created 2020-01-08
 */
public class DocumentPrepopulation{
	private static final Map<String, String> DOCUMENT_TYPES = new Map<String, String>{ 'ABSA 5665 - Business Client Agreement' => 'Business Client Agreement', 'ABSA 3741 - Client Engagement' => 'Client Engagement', 'ABSA 3741 - Annexure A - Cheque' => 'Annexure A - Cheque', 'ABSA 5247 - Client Needs Analysis' => 'Client Needs Analysis', 'ABSA 4801 - GENERAL RESOLUTION' => 'ABSA 4801 - GENERAL RESOLUTION', 'ABSA 4060 - Opening of an Account' => 'ABSA 4060 - Opening of an Account', 'Absa 5679 - Personal Client Agreement' => 'Absa 5679 - Personal Client Agreement', 'Absa 4644 - Marriage Declaration' => 'Absa 4644 - Marriage Declaration', 'ABSA 3141 - Global Application to open/close savings/investment' => 'ABSA 3141 - Global Application to open/close savings/investment', 'ABSA 2814 - Absa Electronic Banking Services Application Form - Business' => 'ABSA 2814 - Absa Electronic Banking Services Application Form - Business' };
	/**
	 * @description A method to get pick list values from the Document object field Type__c.
	 * @author Robert McLean.
	 * @created 2019-06-14
	 * @return fileTypePickList list of pick list values.
	 **/
	@AuraEnabled
	public static List<String> getFileTypePickList(){
		List<String> fileTypePickList = new List<String>();
		fileTypePickList.addAll(DOCUMENT_TYPES.keySet());
		return fileTypePickList;
	}

	/**
	 * @author Danie Booysen
	 * @description Method that gets a list of all documents (email) for an Opportunity
	 *
	 * @param opportunityId
	 * @return a list of documents linked to the opportunityId parameter
	 */
	@AuraEnabled
	public static List<Document__c> getDocAuditHistoryEmail(Id opportunityId){
		updateCAFDocs(opportunityId);
		List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(opportunityId);
		List<Document__c> docList1 = new List<Document__c>();
		for (Document__c doc : docList){
			if (doc.Reference__c != '' && doc.Reference__c != null){
				docList1.add(doc);
			}
		}
		return docList1;
	}

	private static void updateCAFDocs(id parentId){
		List<Document__c> docListbyCase = new List<Document__c>();
		List<Document__c> docListbyOpp = new List<Document__c>();
		Id oppId;
		Id caseId;
		if (DocumentController.getParentObjectName(parentId) == 'Case'){
			Set<id> caseids = new Set<Id>();
			caseids.add(parentId);
			Case docCase = new CasesSelector().selectcasebyAccountId(caseids)?.get(0);
			if (docCase != null && docCase.RecordType.DeveloperName == 'CAF_Application'){
				oppId = docCase.Opportunity__c;
				docListbyCase = new DocumentsSelector().selectDocumentsByOppId(docCase.id);
				for (Document__c doc : docListbyCase){
					if (doc.Application_Product_CAF__c != null){
						doc.Opportunity__c = oppId;
					}
				}
				if (!docListbyCase.isEmpty() && docListbyCase.size() > 0 && docListbyCase != null){
					update docListbyCase;
				}
			}
		}
	}

	/**
	 * @author Vladimir Panajic
	 * @modified Danie Booysen
	 * @description Method that downloads a document to the desktop
	 *
	 * @param documentId
	 * @return ECM_GetResult_IB_V1.Content.data
	 */
	@AuraEnabled
	public static String getDocumentContent(Id documentId){
		List<Document__c> docContentList = new DocumentsSelector().selectByDocId(documentId);
		ECM_LoginResult_IB_V1 login = ECMLogin();
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, docContentList[0].Reference__c);

		if (getResult.Content != null){
			return getResult.Content.data;
		} else{
			return 'ECM returned no results.';
		}
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that logs to ECM
	 * @return ECM_LoginResult_IB_V1
	 */
	public static ECM_LoginResult_IB_V1 ECMLogin(){
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		return login;
	}

	/**
	 * @author Thulani Maseko
	 * @description A mothod the return template name based on the client type/ opportunity entity type
	 * @param opportunityId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getDocumentTemplatesNamePickList(Id opportunityId){
		List<String> templatesPickList = new List<String>();
		List<Opportunity> opportunity = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
		DocumentTemplateSelector docTemplateSelector = new DocumentTemplateSelector();
		List<Document_Template__c> templatesList = docTemplateSelector.selectTemplateNames();
		if (templatesList != null && templatesList.size() > 0){
			for (Document_Template__c template : templatesList){
				templatesPickList.add(template.Name);
			}
		}
		return templatesPickList;
	}

	/**
	 * @description generateDocument description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @param templateName (String): templateName
	 * @param signatureRequests (List<SignatureRequest__c>): signatureRequests
	 * @return Map<String,String>: Return description
	 */
	@AuraEnabled
	public static Map<String, String> generateDocument(Id opportunityId, String templateName, List<SignatureRequest__c> signatureRequests){
		//templateName = DOCUMENT_TYPES.get(templateName);
		return GenerateDocument.generateTheDocument(opportunityId, templateName, signatureRequests);
	}

	/**
	 * @description generateNewDocument description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @param templateName (String): templateName
	 * @param signatureRequests (List<SignatureRequest__c>): signatureRequests
	 * @return Map<String,String>: Return description
	 */
	@AuraEnabled
	public static Map<String, String> generateNewDocument(Id opportunityId, String templateName, List<SignatureRequest__c> signatureRequests){
		List<SignatureRequest__c> emptyList = new List<SignatureRequest__c>();
		If (signatureRequests != null){
			return GenerateDocument.generateNewDocument(opportunityId, templateName, signatureRequests);
		} else{
			return GenerateDocument.generateNewDocument(opportunityId, templateName, emptyList);
		}
	}

	/**
	 * @description getApplicationId
	 * @param oppId
	 * @return Id
	 */
	@AuraEnabled
	public static Id getApplicationId(Id oppId){
		List<Application__c> app = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
		if (app != null && app.size() > 0){
			return app[0].id;
		} else{
			return '';
		}
	}

	/**
	 * @description is It an Oportunity description
	 *
	 * @param OppId
	 * @return boolean: Return description indicating we dealing with Opportunity
	 */
	@AuraEnabled
	public static boolean isItAnOpportunity(string OppId){
		Boolean rtnVal = false;
		if (DocumentController.getParentObjectName(OppId) == 'Opportunity')
			rtnVal = true;
		return rtnVal;
	}

	/**
	 * @description fetchPersonAccList
	 * @param oppid
	 * @return List<AccountContactRelation>
	 */
	@AuraEnabled
	public static List<AccountContactRelation> fetchPersonAccList(String oppid){
		Opportunity opp = [Select Id, AccountId
		                   From Opportunity
		                   Where Id = :oppid
		                   LIMIT 1];
		return [SELECT Id, AccountId, ContactId, Contact.Email, Contact.Phone, Contact.FirstName, Contact.LastName, Contact.Title, Contact.ID_Number__c, Roles, Share_Percentage__c
		        FROM AccountContactRelation
		        WHERE AccountId = :opp.AccountId];
	}

	/**
	 * @description getActiveUser description
	 *
	 * @return Id: Return description
	 */
	@AuraEnabled
	public static Id getActiveUser(){
		return UserInfo.getUserId();
	}

	/**
	 * @description getApplicationrecordtypeId
	 * @return string
	 */
	@AuraEnabled
	public static string getApplicationrecordtypeId(){
		String RecordTypeId = '';
		RecordTypeId = RecordTypeIdController.getRecordTypeId('Onboarding', 'Application__c');
		return RecordTypeId;
	}

	/**
	 * @description getCallReport description
	 *
	 * @param oppId (String): oppId
	 * @return list<Task>: Return description
	 */
	@AuraEnabled
	public static list<Task> getCallReport(String oppId){
		List<Task> task = [SELECT WhoId, OwnerId, Number_Dialled__c, Duration_of_Call_in_Minutes__c, Extension_Dailed_From__c, Description
		                   FROM task
		                   WHERE WhatId = :oppId];
		return task;
	}

	/**
	 * @description addCallReport description
	 *
	 * @param oppId (String): oppId
	 * @param personSpokenTo (String): personSpokenTo
	 * @param numberDialled (String): numberDialled
	 * @param callStart (Datetime): callStart
	 * @param callEnd (Datetime): callEnd
	 * @param extensionDailedFrom (String): extensionDailedFrom
	 * @param absaUserID (String): absaUserID
	 * @param briefDescription (String): briefDescription
	 * @return string: Return description
	 */
	@AuraEnabled
	public static string addCallReport(String oppId, String personSpokenTo, String numberDialled, Datetime callStart, Datetime callEnd, String extensionDailedFrom, String absaUserID, String briefDescription){

		try{
			List<Opportunity> opp = new OpportunitiesSelector().selectByOpportunityId(oppId);
			String AccountId = opp[0].AccountId;
			Task task = new Task();
			task.WhatId = oppId;
			task.WhoId = personSpokenTo;
			task.OwnerId = absaUserID;
			task.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Call Report').getRecordTypeId();
			task.Number_Dialled__c = numberDialled;
			task.Call_Start__c = callStart;
			task.Call_End__c = callEnd;
			task.Extension_Dailed_From__c = extensionDailedFrom;
			task.Description = briefDescription;
			insert task;

		} catch (Exception e){
			return 'Save Failed!';
		}
		return 'Saved Successfully!';
	}

	/**
	 * @description saveAppDetails description
	 *
	 * @param Signedat (String): Signedat
	 * @param Signedon (Date): Signedon
	 * @param applicationId (Id): applicationId
	 * @param forWhom (String): forWhom
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveAppDetails(String Signedat, Date Signedon, Id applicationId, String forWhom){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Signed_at__c = Signedat;
		app.Signed_on__c = Signedon;
		app.For_whom_are_you_generating_the_document__c = forWhom;//W-13225

		try{
			update app;
		} catch (Exception e){
			String str = e.getMessage();
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveSiteVisitDetails description
	 *
	 * @param settlementtype (String): settlementtype
	 * @param sitevisitdate (Date): sitevisitdate
	 * @param addresstype (String): addresstype
	 * @param firstname (String): firstname
	 * @param surname (String): surname
	 * @param completedby (String): completedby
	 * @param applicationId (Id): applicationId
	 * @param verifyaddressP (String): verifyaddressP
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveSiteVisitDetails(String settlementtype, Date sitevisitdate, String addresstype, String firstname, String surname, String completedby, Id applicationId, String verifyaddressP){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Settlement_type__c = settlementtype;
		app.Site_visit_date__c = sitevisitdate;
		app.Address_type__c = addresstype;
		app.First_Name__c = firstname;
		app.Surname__c = surname;
		app.Completed_By__c = completedby;
		app.verify_the_address_and_or_Trade_Name__c = verifyaddressP;
		try{
			update app;
		} catch (Exception e){
			String str = e.getMessage();
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveIndemnityDetails description
	 *
	 * @param medium (String): medium
	 * @param instructionType (String): instructionType
	 * @param applicationId (Id): applicationId
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveIndemnityDetails(String medium, String instructionType, Id applicationId){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Instruction_Type__c = instructionType;
		app.Medium__c = medium;

		try{
			update app;
		} catch (Exception e){
			String str = e.getMessage();
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveResolutionDetails
	 * @param individualsisareauthorisedtoact
	 * @param applicationId
	 * @param meetingHeldAt
	 * @param meetingDate
	 * @return Application__c
	 */
	@AuraEnabled
	public static Application__c saveResolutionDetails(String individualsisareauthorisedtoact, Id applicationId, String meetingHeldAt, Date meetingDate){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.individual_s_is_are_authorised_to_act__c = individualsisareauthorisedtoact;
		app.Meeting_Held_At__c = meetingHeldAt; //W-13225
		app.Meeting_Date__c = meetingDate;//W-13225
		try{
			update app;
		} catch (Exception e){
			String str = e.getMessage();
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description savepowerOfAttornyDetails description
	 *
	 * @param applicationId (Id): applicationId
	 * @param powerOfAttorny (String): powerOfAttorny
	 * @param accountApplicablepowerofattorny (String): accountApplicablepowerofattorny
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c savepowerOfAttornyDetails(Id applicationId, String powerOfAttorny, String accountApplicablepowerofattorny){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Power_of_Attorney__c = powerOfAttorny; //W-13225
		app.Account_applicable_to_Special_Power_of_a__c = Decimal.valueOf(accountApplicablepowerofattorny) != 0 ? Decimal.valueOf(accountApplicablepowerofattorny) : null;//W-13225
		try{
			update app;
		} catch (Exception e){
			String str = e.getMessage();
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description getApplicationRecordDetails description
	 *
	 * @param oppId (Id): oppId
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c getApplicationRecordDetails(Id oppId){
		List<Application__c> applist = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
		if (applist.size() > 0){
			return applist[0];
		} else{
			return new Application__c();
		}
	}

	/**
	 * @description fetchPersonAccList description
	 *
	 * @param oppId (Id): oppId
	 * @return List<AccountContactRelation>: Return description
	 */
	@AuraEnabled
	public static List<AccountContactRelation> fetchPersonAccList(Id oppId){
		Account acccount = new AccountsSelector().selectByOpportunityId(oppId);
		List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(acccount.Id);
		if (accnRelList != null && accnRelList.size() > 0){
			return accnRelList;
		} else{
			return new List<AccountContactRelation>();
		}
	}

	/**
	 * @description getDocs description
	 *
	 * @param opportunityId (Id): opportunityId
	 * @return List<string>: Return description
	 */
	@AuraEnabled
	public static List<string> getDocs(Id opportunityId){
		Map<Id, Document_Template__c> docmap1 = new map<Id, Document_Template__c>([select name, ECM_Item_Type__c
		                                                                           from Document_Template__c]);
		Map<string, string> docmap2 = new Map<string, string>();
		for (Id aa : docmap1.keyset()){
			docmap2.put(docmap1.get(aa).name, docmap1.get(aa).ECM_Item_Type__c);
		}

		List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(opportunityId);
		list<string> auditlist = new list<string>();

		for (Document__c d : docList){
			if (docmap2.containsKey(d.Type__c) && d.Account__c == Null && d.Contact__c == Null){
				auditlist.add(docmap2.get(d.Type__c));
			}
		}
		return auditlist;
	}

	/**
	 * @description getAllMandatoryDocuments
	 * @param Entitytype
	 * @return List<Mandatory_Doc__mdt>
	 */
	@AuraEnabled
	public static List<Mandatory_Doc__mdt> getAllMandatoryDocuments(String Entitytype){
		List<Mandatory_Doc__mdt> MandatoryDocs = new MandatoryDocumentSelector().getMandatoryDocumentsWithEntitytype(Entitytype);
		if (MandatoryDocs != null && MandatoryDocs.size() > 0){
			return MandatoryDocs;
		} else{
			return new List<Mandatory_Doc__mdt>();
		}
	}

	/**
	 * @author Himani Joshi
	 * @description Updated Thulani W-005273
	 * @param recordId
	 * @param docFlag
	 * @return List<String>
	 *
	 */
	@AuraEnabled
	public static List<String> updateOpportunity(String recordId, String docFlag){

		List<String> response = new List<String>();
		try{
			Opportunity opp = new Opportunity(Id = recordId, CheckMandatoryDocuments__c = Boolean.valueOf(docFlag));

			update opp;
			response.add('SUCCESS');
			return response;
		} catch (Exception e){
			response.add('ERROR');
			response.add(String.valueOf(e.getMessage()));
			return response;
		}
	}

	/**
	 * @author Thulani Maseko
	 * @description Story W-005273
	 * @param relatedParties
	 * @return Boolean
	 */
	@TestVisible
	private static Boolean checkRelatedPartyDocState(List<Map<String, Object>> relatedParties){
		Boolean relatedPartyDocState = true;
		for (Map<String, Object> relatedParty : relatedParties){
			List<Document__c> docList = new DocumentsSelector().selectByContactId((Id) relatedParty.get('ContactId'));
			if (docList == null && docList.size() <= 0){
				relatedPartyDocState = true;
				break;
			} else{
				for (Document__c doc : docList){
					if (doc.Type__c == 'Ent_ProofOfId'){
						relatedPartyDocState = false;
						break;
					} else{
						relatedPartyDocState = true;
					}
				}
			}
		}
		return relatedPartyDocState;
	}

	/**
	 * @description getSelectedDocumentTemplate
	 * @param documentTemplateName
	 @return Document_Template__c
	 */
	@AuraEnabled
	public static Document_Template__c getSelectedDocumentTemplate(String documentTemplateName){
		if (!String.isEmpty(documentTemplateName)){
			return new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
		} else{
			return null;
		}
	}

	/**
	 * @description / Added by Yongama. This method has been copied from ProductOnboardingAuthSignatoryCtrl
	 * @param oppId
	 * @return List<AccountContactRelation>
	 */
	@AuraEnabled
	public static List<AccountContactRelation> getAccountContactRelation(id oppId){
		AccountContactRelationSelector acrSelector = new AccountContactRelationSelector();
		OpportunitiesSelector oppSelector = new OpportunitiesSelector();
		List<AccountContactRelation> acrList;

		id accId = oppSelector.selectByOppId(oppId).AccountId;
		if (accId != null){
			acrList = acrSelector.selectRelationByAccountId(accId);
			if (acrList.size() <= 0 || acrList == null || acrList.isEmpty()){
				acrList = null;
			}
		}
		return acrList;
	}

	/**
	 * @description findOppData
	 * @return List<OpportunityLineItem>
	 */
	@AuraEnabled
	public static List<OpportunityLineItem> findOppData(){
		List<OpportunityLineItem> oppLn = [SELECT Id, Policy_Number__c
		                                   FROM OpportunityLineItem];
		return oppLn;
	}

	/**
	 * @description getRelatedParties
	 * @param oppId
	 * @return List < Map < String,Object >>
	 */
	@AuraEnabled
	public static List<Map<String, Object>> getRelatedParties(Id oppId){
		AccountsSelector aSelector = new AccountsSelector();
		List<Map<String, Object>> listParties = new List<Map<String, Object>>();
		Account acccount = aSelector.selectByOpportunityId(oppId);
		List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(acccount.Id);

		Map<String, String> partiesInList = new Map<String, String>();

		If (acccount.Client_Group__c == 'SOLE TRADER CLIENT' || acccount.Client_Group__c == 'Individual'){
			Map<String, Object> mapObj = new Map<String, Object>();
			mapObj.put('Id', acccount.Id);
			mapObj.put('AccountId', acccount.Id);
			mapObj.put('ContactId', acccount.PersonContactId);
			mapObj.put('FirstName', acccount.FirstName);
			mapObj.put('LastName', acccount.LastName);
			mapObj.put('IDNumber', acccount.ID_Number__pc);
			mapObj.put('CIF', acccount.CIF__c);
			mapObj.put('Nationality', acccount.Nationality__pc);
			mapObj.put('Birthdate', String.valueOf(acccount.PersonBirthdate));
			mapObj.put('Phone', acccount.Phone);
			partiesInList.put(String.valueOf(acccount.PersonContactId), String.valueOf(acccount.PersonContactId));
			listParties.add(mapObj);
		}
		if (accnRelList != null && accnRelList.size() > 0){
			for (AccountContactRelation accnRel : accnRelList){
				If (!partiesInList.containsKey(accnRel.ContactId)){
					Map<String, Object> mapObj = new Map<String, Object>();
					mapObj.put('Id', accnRel.Contact.AccountId);
					mapObj.put('AccountId', accnRel.AccountId);
					mapObj.put('ContactId', accnRel.ContactId);
					mapObj.put('FirstName', accnRel.Contact.FirstName);
					mapObj.put('LastName', accnRel.Contact.LastName);
					mapObj.put('IDNumber', accnRel.Contact.ID_Number__c);
					mapObj.put('CIF', accnRel.Account.CIF__c);
					mapObj.put('Nationality', accnRel.Contact.Nationality__c);
					mapObj.put('Birthdate', String.valueOf(accnRel.Contact.Birthdate));
					mapObj.put('SharePercentage', string.valueOf(accnRel.Share_Percentage__c));
					mapObj.put('CIF', accnRel.Account.CIF__c);
					mapObj.put('Roles', accnRel.Roles);
					mapObj.put('Phone', accnRel.Account.Phone);
					partiesInList.put(accnRel.ContactId, accnRel.ContactId);
					listParties.add(mapObj);
				}
			}
		}
		return listParties;
	}

	/**
	 * @description A method for verifying if the Opportunity passed in is of type CAF Application.
	 * @param recordId is the Opportuninty Id passed from the Lightning Component.
	 * @return a boolen result of if the Opportunity record type is CAF Application or not.
	 **/
	@AuraEnabled
	public static Boolean getRecordTypeName(Id recordId){
		Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
		Id oppRecId = [SELECT RecordTypeId
		               FROM Opportunity
		               WHERE Id = :recordId].RecordTypeId;
		if (oppRecordTypeId == oppRecId){
			return true;
		} else{
			return false;
		}
	}

	/**
	 * @description saveMandateIndemnityDetails description
	 *
	 * @param applicationId (Id): applicationId
	 * @param instructionMethod (String): instructionMethod
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveMandateIndemnityDetails(Id applicationId, String instructionMethod){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Instruction_Method__c = instructionMethod;
		try{
			update app;
		} catch (Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveForeignNationalDetails
	 * @param applicationId
	 * @param countryOfResidence
	 * @param periodOfVisit
	 * @param purposeOfVisit
	 * @param dateOfArrival
	 * @param tempPermitNo
	 * @param permitExpiryDate
	 * @return Application__c
	 */
	@AuraEnabled
	public static Application__c saveForeignNationalDetails(Id applicationId, String countryOfResidence, String periodOfVisit, String purposeOfVisit, Date dateOfArrival, String tempPermitNo, Date permitExpiryDate){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Country_of_Permanent_Residency__c = countryOfResidence;
		app.Period_of_Visit__c = periodOfVisit;
		app.Purpose_of_Visit__c = purposeOfVisit;
		app.Date_of_Arrival__c = dateOfArrival;
		app.Temporary_Permit_No__c = tempPermitNo;
		app.Permit_Expiry_Date__c = permitExpiryDate;

		try{
			update app;
		} catch (Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveBankingMandateDetails description
	 *
	 * @param applicationId (Id): applicationId
	 * @param accountApplicableToMandate (String): accountApplicableToMandate
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveBankingMandateDetails(Id applicationId, String accountApplicableToMandate){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Account_Applicable_to_Banking_Mandate__c = Decimal.valueOf(accountApplicableToMandate);

		try{
			update app;
		} catch (Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveElectronicBankingDetails description
	 *
	 * @param applicationId (Id): applicationId
	 * @param accTobeDebited (String): accTobeDebited
	 * @param accTobeUsed (String): accTobeUsed
	 * @param noOfmainUsers (String): noOfmainUsers
	 * @param noOfAuthorizations (String): noOfAuthorizations
	 * @param willOppSystemUsed (String): willOppSystemUsed
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveElectronicBankingDetails(Id applicationId, String accTobeDebited, String accTobeUsed, String noOfmainUsers, String noOfAuthorizations, String willOppSystemUsed){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Account_to_be_debited_monthly_with_the_c__c = accTobeDebited;
		app.Account_number_that_will_be_used_as_Acce__c = Decimal.valueOf(accTobeUsed);
		app.Number_of_main_users__c = noOfmainUsers;
		app.Number_of_authorisations_that_will_be_re__c = noOfAuthorizations;
		app.Will_operator_system_be_used__c = willOppSystemUsed;
		try{
			update app;
		} catch (Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveSavingsInvestmentDetails description
	 *
	 * @param applicationId (Id): applicationId
	 * @param noOfSignatories (String): noOfSignatories
	 * @param autoReInvestment (String): autoReInvestment
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveSavingsInvestmentDetails(Id applicationId, String noOfSignatories, String autoReInvestment){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Number_of_signatories_authorized_to_repr__c = noOfSignatories;
		app.Automatic_re_investment_of_on_Expiry_Dat__c = autoReInvestment;

		try{
			update app;
		} catch (Exception e){
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description W-005661 - Anka Ganta - 2020-09-18
	 * @param Entitytype
	 * @param OppId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getPrimaryClientMandatoryDocuments(String Entitytype, String OppId){
		return DocumentManagementControler.getPrimaryClientMandatoryDocuments(Entitytype, OppId);
	}
}