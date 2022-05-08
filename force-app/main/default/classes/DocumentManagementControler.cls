/**
 * @description Controller for Documents used by Lightning components
 * (DocumentShareHistoryEmail)
 * @author Danie Booysen
 *
 * @created 2020-01-08
 */
public without sharing class DocumentManagementControler{
	private static final Map<String, String> DOCUMENT_TYPES = new Map<String, String>{'ABSA 5665 - Business Client Agreement' => 'Business Client Agreement', 'ABSA 3741 - Client Engagement' => 'Client Engagement', 'ABSA 3741 - Annexure A - Cheque' => 'Annexure A - Cheque', 'ABSA 5247 - Client Needs Analysis' => 'Client Needs Analysis', 'ABSA 4801 - GENERAL RESOLUTION' => 'ABSA 4801 - GENERAL RESOLUTION', 'ABSA 4060 - Opening of an Account' => 'ABSA 4060 - Opening of an Account', 'Absa 5679 - Personal Client Agreement' => 'Absa 5679 - Personal Client Agreement', 'Absa 4644 - Marriage Declaration' => 'Absa 4644 - Marriage Declaration', 'ABSA 3141 - Global Application to open/close savings/investment' => 'ABSA 3141 - Global Application to open/close savings/investment', 'ABSA 2814 - Absa Electronic Banking Services Application Form - Business' => 'ABSA 2814 - Absa Electronic Banking Services Application Form - Business'};
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
	 * @description invokeApprovalProcess description
	 *
	 * @param covanentId (String): covanentId
	 * @param covonentStatus (String): covonentStatus
	 * @param reason (String): reason
	 * @param approverId (String): approverId
	 */
	@AuraEnabled
	public static void invokeApprovalProcess(String covanentId, String covonentStatus, String reason, String approverId){

		List<Id> apprIds = new List<Id>();
		apprIds.add(approverId);

		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
		req1.setComments(reason);
		req1.setObjectId(covanentId);

		req1.setSubmitterId(userInfo.getUserId());

		req1.setProcessDefinitionNameOrId('Covenant_Approval_Process');
		req1.setSkipEntryCriteria(true);
		req1.setNextApproverIds(apprIds);

		Approval.ProcessResult result = Approval.process(req1);

		updateCovenant(covanentId, covonentStatus, reason);
	}

	/**
	 * @description updateCovenant description
	 *
	 * @param covanentId (String): covanentId
	 * @param covonentStatus (String): covonentStatus
	 * @param reason (String): reason
	 */
	public static void updateCovenant(String covanentId, String covonentStatus, String reason){
		Covenant__c covenant = new Covenant__c(Id = covanentId);
		covenant.Covenant_Status__c = covonentStatus;
		covenant.Reason__c = reason;
		covenant.Status__c = 'ACTIVE';
		covenant.Covenant_Approved__c = false;
		update covenant;
	}

	/**
	 * @author Muvhuso Nekhubvi
	 *
	 * @description Method that update a document and flag a document record as deleted
	 *
	 * @param documentId
	 * @return String
	 */
	@AuraEnabled
	public static String updateDocumentContent(Id documentId){
		List<Document__c> docContentList = new DocumentsSelector().selectByDocId(documentId);
		if (docContentList != null && docContentList.size() > 0){
			docContentList[0].Deleted__c = true;
			update docContentList[0];
			return 'Success';
		}
		return null;
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
		return docList;
	}

	private static void updateCAFDocs(id parentId){
		List<Document__c> docListbyCase = new List<Document__c>();
		List<Document__c> docListbyOpp = new List<Document__c>();
		Id oppId;
		Id caseId;
		if (DocumentController.getParentObjectName(parentId) == 'Case'){
			Set<id> caseids = new Set<Id>();
			caseids.add(parentId);
			Case docCase = new CasesSelector().selectcasebyAccountId(caseids) ?.get(0);
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
	 * @description ECM_LoginResult_IB_V1 - Method that logs to ECM
	 * @author Vladimir Panajic
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
	 * @return templatesPickList list of pick list values.
	 * @modified by Tinashe to filetr by Generate_Document__c parametermade change
	 */
	@SuppressWarnings('PMD.AvoidDebugStatements')
	@AuraEnabled
	public static List<String> getDocumentTemplatesNamePickList(Id opportunityId){
		List<String> templatesPickList = new List<String>();
		try{
			List<Document_Template__c> templatesList = new DocumentTemplateSelector().selectTemplateNames();
			if (!templatesList.isEmpty() && templatesList.size() > 0 && templatesList != null){
				for (Document_Template__c template : templatesList){
					if (template.Generate_Document__c == true){
						templatesPickList.add(template.Name);
					}
				}
			}
			return templatesPickList;
		} catch (Exception ex){
			System.debug('Error generating document : Error: ' + ex.getMessage());
		}
		return templatesPickList = null;
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
		return GenerateDocument.generateTheDocument(opportunityId, templateName, signatureRequests);
	}

	/**
	 * @description generateNewDocument Tinashe - New Document Generation Method
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
	 * @description getApplicationId description Added by Diksha for W-4255
	 *
	 * @param oppId (Id): oppId
	 * @return Id: Return description
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
	 * @description isItAnOpportunity description
	 *
	 * @param OppId (string): OppId
	 * @return boolean: Return description
	 */
	@AuraEnabled
	public static boolean isItAnOpportunity(string OppId){
		Boolean rtnVal = false;
		if (DocumentController.getParentObjectName(OppId) == 'Opportunity')
			rtnVal = true;
		return rtnVal;
	}
	/**
	 * @description caseId description
	 *
	 * @param caseId (string): OppId
	 * @return boolean: Return description
	 */
	@AuraEnabled
    public static String fetchCaseStage(String caseId){
        if(DocumentController.getParentObjectName(caseId) != 'Opportunity'){
            Case cs = [Select Id,Status From Case Where Id =: caseId LIMIT 1];
            return cs.Status;
        }else{
            return null;
        }
    }

	/**
	 * @description fetchPersonAccList description
	 *
	 * @param oppid (String): oppid
	 * @return List<AccountContactRelation>: Return description
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
	 * @description getApplicationrecordtypeId description
	 *
	 * @return string: Return description
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
	@SuppressWarnings('PMD.AvoidDebugStatements')
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
			System.debug('LINE NUMBER :' + e.getLineNumber()+', MESSAGE :' + e.getMessage());
		}
		return 'Saved Successfully!';
	}

	/**
	 * @description saveAppDetails description
	 *
	 * @param Signedat (String): Signedat
	 * @param Signedon (Date): Signedon
	 * @param globalapplicationform (String): globalapplicationform
	 * @param StandardAbsaresolutionforyou (String): StandardAbsaresolutionforyou
	 * @param Absamandateandindemnity (String): Absamandateandindemnity
	 * @param StandardAbsasitevisitforyou (String): StandardAbsasitevisitforyou
	 * @param StandardAbsapowerofattorneyforyou (String): StandardAbsapowerofattorneyforyou
	 * @param Recordoftelephonicengagement (String): Recordoftelephonicengagement
	 * @param Arealltherelatedparties (String): Arealltherelatedparties
	 * @param Istheremorethanonenaturalperson (String): Istheremorethanonenaturalperson
	 * @param ForeignExchangeAuthorityFormforyou (String): ForeignExchangeAuthorityFormforyou
	 * @param applicationId (Id): applicationId
	 * @param forWhom (Id): forWhom
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveAppDetails(String Signedat, Date Signedon, String globalapplicationform, String StandardAbsaresolutionforyou, String Absamandateandindemnity, String StandardAbsasitevisitforyou, String StandardAbsapowerofattorneyforyou, String Recordoftelephonicengagement, String Arealltherelatedparties, String Istheremorethanonenaturalperson, String ForeignExchangeAuthorityFormforyou, Id applicationId, Id forWhom){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.Signed_at__c = Signedat;
		app.Signed_on__c = Signedon;
		app.global_application_form__c = globalapplicationform;
		app.Standard_Absa_resolution_for_you__c = StandardAbsaresolutionforyou;
		app.Absa_mandate_and_indemnity__c = Absamandateandindemnity;
		app.Standard_Absa_site_visit_for_you__c = StandardAbsasitevisitforyou;
		app.Standard_Absa_power_of_attorney_for_you__c = StandardAbsapowerofattorneyforyou;
		app.Record_of_telephonic_engagement__c = Recordoftelephonicengagement;
		app.Are_all_the_related_parties__c = Arealltherelatedparties;
		app.Is_there_more_than_one_natural_person__c = Istheremorethanonenaturalperson;
		app.Foreign_Exchange_Authority_Form_for_you__c = ForeignExchangeAuthorityFormforyou;
		app.For_whom_are_you_generating_the_document__c = forWhom;
		try{
			update app;
		} catch (Exception e){
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
			throw new AuraHandledException('Something went wrong: ' + e.getMessage());
		}
		return app;
	}

	/**
	 * @description saveResolutionDetails description
	 *
	 * @param individualsisareauthorisedtoact (String): individualsisareauthorisedtoact
	 * @param applicationId (Id): applicationId
	 * @return Application__c: Return description
	 */
	@AuraEnabled
	public static Application__c saveResolutionDetails(String individualsisareauthorisedtoact, Id applicationId){
		Application__c app = new ApplicationsSelector().selectById(applicationId);
		app.individual_s_is_are_authorised_to_act__c = individualsisareauthorisedtoact;
		try{
			update app;
		} catch (Exception e){
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
	 * @description getDocs Method that gets a list of documents uploaded
	 * @author Himani Joshi
	 * Updated by Thulani W-005273
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
	 * @description getAllMandatoryDocuments Method that gets a list of mandatory documents
	 *    // @author Himani Joshi
	 * Updated by Thulani W-005273
	 * @param Entitytype (String): Entitytype
	 * @return List<Mandatory_Doc__mdt>: Return description
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
	 * @description getAllRelMandatoryDocuments Validates that all mandatory documents for related parties are upload
	 * @author Masechaba Maseli
	 * Updated: W-005550: Anka Ganta : remove validation of ProofOfId document if related party has only Role as 'Contact Person'
	 * @param Entitytype (String): Entitytype
	 * @param OppId (String): OppId
	 * @param UploadedDocs (List<Document__c>): UploadedDocs
	 * @return List<String>: Return description
	 */
	@AuraEnabled
	public static List<String> getAllRelMandatoryDocuments(String Entitytype, String OppId, List<Document__c> UploadedDocs){
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(OppId);
		List<Mandatory_Doc__mdt> MandatoryDocs = new List<Mandatory_Doc__mdt>();
		String primaryKey = opportunities[0].AccountId;
		//TdB - Get primary Account details
        Account primaryAccount = new AccountsSelector().selectById(primaryKey);
		String accountHierarchy = '';
        accountHierarchy = primaryAccount.UBO_ParentAccountWrapper__c;
		Map<String, String> entityTypesDocMap = new Map<String, String>();
		Map<String, String> uploadedDocMap = new Map<String, String>();
		Map<String, String> relatedIdMap = new Map<String, String>();
		Map<String, Boolean> hasDocumentMap = new Map<String, Boolean>();
		List<Id> relatedIds = new List<Id>();
		List<String> errorList = new List<String>();
		String ContactPersonOnly = 'Contact Person';
		Set<Id> relPartyPrimaryEntityIdSet = new Set<Id>();
		Map<String, String> accConUboMap = new Map<String, String>();
		List<Controlling_Interest__c> controllingInstr = new ControllingInterestsSelector().getByPrimaryAndUBO(primaryKey, 'Yes');  
        for (Controlling_Interest__c contrInt : controllingInstr){
            relPartyPrimaryEntityIdSet.add(contrInt.Other_Primary_Entity_Id__c);
            if(contrInt.Contact__c != null) {
                accConUboMap.put(contrInt.Contact__c, contrInt.UBO__c); 
            }
        }

		//TdB - Get Account Account Relationships
		List<FinServ__AccountAccountRelation__c> accAccRelList = new AccountAccountRelationSelector().selectByPrimaryForDocuments(primaryKey);
		//TdB - Get Get Account Contact Relationship
		Set<id> accContactsIdSet = new Set<id>(); 
        if(accountHierarchy != null){
            accContactsIdSet=getRelatedAccConIds(accountHierarchy);
        }
        List<AccountContactRelation> UBOList = new AccountContactRelationSelector().selectbyIdSet(accContactsIdSet);
		
		String relatedEntityTypeUBO = 'UBO';
		Boolean hasDocument = False;
		For (Document__c createDocEntityMap : UploadedDocs){
			if (createDocEntityMap.Reference__c != null) {
				If (createDocEntityMap.Contact__c != Null){
					uploadedDocMap.put(createDocEntityMap.Contact__c + createDocEntityMap.ECM_Type__c, createDocEntityMap.Contact__c);
				} Else If (createDocEntityMap.Account__c != Null){
					uploadedDocMap.put(createDocEntityMap.Account__c + createDocEntityMap.ECM_Type__c, createDocEntityMap.Account__c);
				}
			}
		}

		List<Mandatory_Doc__mdt> RelatedUBODocs = new MandatoryDocumentSelector().getMandatoryDocumentsWithEntitytype(relatedEntityTypeUBO);
        For (Mandatory_Doc__mdt allMandsUBO : RelatedUBODocs){
            For (AccountContactRelation UBO : UBOList){
                If (uploadedDocMap.get(UBO.ContactId + allMandsUBO.ECM_Type__c) != UBO.ContactId){
                    if('UBO' == allMandsUBO.Entity_Type__c) {
                        if (UBO.Roles != null && UBO.Roles != ContactPersonOnly){
                            if(allMandsUBO.ECM_Type__c != 'Ent_ProofOfAddress') {
                                errorList.add('Please upload a ' + ' ' + allMandsUBO.ECM_Type__c + ' ' + 'type document for' + ' ' + UBO.Contact.Name + ',');
                            } else if(allMandsUBO.ECM_Type__c == 'Ent_ProofOfAddress' && UBO.Roles.contains('Individual with Authority to Act') && accConUboMap.containsKey(UBO.ContactId) == false) {
                                if(primaryAccount.Client_Type__c == 'Individual' || primaryAccount.Client_Type__c == 'Private Individual' || primaryAccount.Client_Type__c == 'Individual - Minor') {
                                    errorList.add('Please upload a ' + ' ' + allMandsUBO.ECM_Type__c + ' ' + 'type document for' + ' ' + UBO.Contact.Name + ',');
                                }
                            }
                        }
                    }
                }
            }
        }

		Set<String> entityTypes = new Set<String>();
        For (FinServ__AccountAccountRelation__c relatedParties : accAccRelList){
            entityTypes.add('Related Party ' + relatedParties.FinServ__RelatedAccount__r.Client_Type__c);
        }
        
        MandatoryDocs = new MandatoryDocumentSelector().getMandatoryDocumentsByEntityTypes(entityTypes);
        
        For (Mandatory_Doc__mdt allMandsRel : MandatoryDocs){
            For (FinServ__AccountAccountRelation__c relPart : accAccRelList){
                If (uploadedDocMap.get(relPart.FinServ__RelatedAccount__c + allMandsRel.ECM_Type__c) != relPart.FinServ__RelatedAccount__c){
                    if('Related Party ' + relPart.FinServ__RelatedAccount__r.Client_Type__c == allMandsRel.Entity_Type__c) {
                        if (relPart.Roles__c != null && relPart.Roles__c != ContactPersonOnly){
                            //Shareholder % more than 0 - Ent_OwnershipStructure is required
                            if(allMandsRel.ECM_Type__c == 'Ent_OwnershipStructure' && relPart.Shareholding_Percentage__c > 0){
                                errorList.add('Please upload a ' + ' ' + allMandsRel.ECM_Type__c + ' ' + 'type document for' + ' ' + relPart.FinServ__RelatedAccount__r.Name + ',');
                            } 
                            //Add to map to check for additional Address Placeholders to create - Not applicable for shared%
                            else if(allMandsRel.ECM_Type__c == 'Ent_ProofOfAddress' && relPart.Shareholding_Percentage__c == 0){
                                errorList.add('Please upload a ' + ' ' + allMandsRel.ECM_Type__c + ' ' + 'type document for' + ' ' + relPart.FinServ__RelatedAccount__r.Name + ',');
                            }
                            else if(allMandsRel.ECM_Type__c != 'Ent_OwnershipStructure' && relPart.Shareholding_Percentage__c == 0) {
                                errorList.add('Please upload a ' + ' ' + allMandsRel.ECM_Type__c + ' ' + 'type document for' + ' ' + relPart.FinServ__RelatedAccount__r.Name + ',');
                            }  
                        }
                    }
                }
            }
        }
		//W-013343 - Tawanda K Madavo
		//exclude validation errors for credit onboarding and complex credit onboarding
		if(opportunities[0].RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId()){
			errorList = new List<String>();
		}
		if(opportunities[0].RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SIC_Code_Change').getRecordTypeId()){
			errorList = new List<String>();
		}

		return errorList;
	}

	/**
	 * @author Himani Joshi
	 * Updated Thulani W-005273
	 * @description updateOpportunity
	 * @param recordId
	 * @param docFlag
	 * @return List<String>
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
	 * @description checkRelatedPartyDocState description
	 *
	 * @param relatedParties (List<Map<StringObject>>): relatedParties
	 * @return Boolean: Return description
	 */
	@TestVisible
	private static Boolean checkRelatedPartyDocState(List<Map<String, Object>> relatedParties){
		Boolean relatedPartyDocState = true;
		for (Map<String, Object> relatedParty : relatedParties){
			List<Document__c> docList = new DocumentsSelector().selectByContactId((Id)relatedParty.get('ContactId'));
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
	 * @description getSelectedDocumentTemplate TdB - Get Document Type selected Additional information
	 *
	 * @param documentTemplateName (String): documentTemplateName
	 * @return Document_Template__c: Return description
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
	 * @description getPrimaryClientMandatoryDocuments /W-005661 - Anka Ganta - 2020-09-18
	 *
	 * @param Entitytype (String): Entitytype
	 * @param OppId (String): OppId
	 * @return List<String>: Return description
	 */
	@AuraEnabled
	public static List<String> getPrimaryClientMandatoryDocuments(String Entitytype, String OppId){
		List<String> errorList = new List<String>();
		if (DocumentController.getParentObjectName(OppId) != 'Opportunity'){
			return errorList;
		}
		List<Document__c> UploadedDocs = new DocumentsSelector().selectDocumentsByOppId(OppId);
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(OppId);
		List<Mandatory_Doc__mdt> MandatoryDocs = new List<Mandatory_Doc__mdt>();
		String primaryKey = opportunities[0].AccountId;
		Map<String, String> uploadedDocMap = new Map<String, String>();
		Set<String> errorSet = new Set<String>();
		List<AccountContactRelation> relatedPartiesList = new AccountContactRelationSelector().selectbyAccount(primaryKey);
		Boolean isWealthBU = opportunities[0].Business_Unit__c == 'WIMI' ? true : false;
		//W-011493
        List<OpportunityLineItem> oli = new OpportunityLineItemsSelector().selectByOpportunityId(OppId);
        Boolean isSnIproduct = false;
        if(oli.size() >0){
            isSnIproduct = oli[0].Product_Family__c == 'Savings' ? true : false;
        }
        
		String private_Company = 'Private Company';
		String close_Corporation = 'Close Corporation';
		String Trust = 'Trusts';
		String SoleTrader = 'Sole Trader';
		String CoOperative = 'Co-operative';
		String Foreign_Company = 'Foreign Company';
		String Foreign_Listed_Company = 'Foreign Listed Company';
		String Public_Listed_Company = 'Public Listed Company';
		String Foreign_Trust = 'Foreign Trust';
		String incorporated_Company = 'Incorporated Company';
		String Not_for_Profit_Companies = 'Not for Profit Companies';
		String Not_for_Profit_Organizations_NGO = 'Not for Profit Organizations (NGO)';
		String Clubs_Societies_Associations_Other_Informal_Bodies = 'Clubs/Societies/Associations/Other Informal Bodies';
		String IndWitAuthAct = 'Individual with Authority to Act';
		String Director = 'Director';
		String Trustees = 'Trustees';
		Integer directorRolesCount = 0;
		Integer IndWitAuthActCount = 0;
		Integer trusteeRolesCount = 0;
		For (AccountContactRelation relatedParties : relatedPartiesList){
			if (Entitytype == private_Company || Entitytype == close_Corporation || Entitytype == Trust || Entitytype == SoleTrader || Entitytype == Clubs_Societies_Associations_Other_Informal_Bodies || Entitytype == CoOperative || Entitytype == Foreign_Company || Entitytype == Foreign_Listed_Company || Entitytype == Public_Listed_Company || Entitytype == Foreign_Trust || Entitytype == incorporated_Company || Entitytype == Not_for_Profit_Companies || Entitytype == Not_for_Profit_Organizations_NGO){
				if (relatedParties.Roles != null){
					if (relatedParties.Roles.contains(Director)){
						directorRolesCount = directorRolesCount + 1;
					}
					if (relatedParties.Roles.contains(IndWitAuthAct)){
						IndWitAuthActCount = IndWitAuthActCount + 1;
					}
					if (relatedParties.Roles.contains(Trustees)){
						trusteeRolesCount = trusteeRolesCount + 1;
					}
				}
			}
		}

		Boolean IsResolutionDocMandatory = true;
		if (Entitytype == private_Company || Entitytype == close_Corporation || Entitytype == CoOperative || Entitytype == Foreign_Company || Entitytype == Foreign_Listed_Company || Entitytype == Public_Listed_Company || Entitytype == incorporated_Company || Entitytype == Not_for_Profit_Organizations_NGO){
			if (directorRolesCount <= 1 && IndWitAuthActCount <= 1){
				IsResolutionDocMandatory = false;
			}
		} else if (Entitytype == Trust || Entitytype == Foreign_Trust){
			if (trusteeRolesCount <= 1 && IndWitAuthActCount <= 1){
				IsResolutionDocMandatory = false;
			}
		} else if (Entitytype == SoleTrader){
			if (IndWitAuthActCount >= 1){
				IsResolutionDocMandatory = true;
			} else{
				IsResolutionDocMandatory = false;
			}
		}

		For (Document__c createDocEntityMap : UploadedDocs){
			If (createDocEntityMap.Opportunity__c != Null  && createDocEntityMap.Reference__c != null){
				uploadedDocMap.put(createDocEntityMap.ECM_Type__c, createDocEntityMap.Opportunity__r.Name);
			}
		}

		List<Mandatory_Doc__mdt> PrimaryClientDocs = new MandatoryDocumentSelector().getMandatoryDocumentsWithEntitytype(Entitytype);
		if (!uploadedDocMap.isEmpty()){
			For (Mandatory_Doc__mdt allMandsDoc : PrimaryClientDocs){
				If (!uploadedDocMap.containsKey(allMandsDoc.ECM_Type__c)){
					if (IsResolutionDocMandatory){
						if (isWealthBU){
							if (allMandsDoc.ECM_Type__c != 'Ent_ClientCommunication'){
								errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
							}
						} else {
                            if (isSnIproduct && (allMandsDoc.ECM_Type__c == 'Ent_AccountApplication')){
                                errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
                            }else if (isSnIproduct && (allMandsDoc.ECM_Type__c != 'Ent_AccountApplication')){
                                errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
                            }else if (!isSnIproduct && (allMandsDoc.ECM_Type__c != 'Ent_AccountApplication')){
                                errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
                            }
                        }
					} else{
						if (allMandsDoc.ECM_Type__c != 'Ent_Resolution'){
							if (isWealthBU){
								if (allMandsDoc.ECM_Type__c != 'Ent_ClientCommunication'){
									errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
								}
							} else {
                                if (isSnIproduct && (allMandsDoc.ECM_Type__c == 'Ent_AccountApplication')){
                                    errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
                                }else if (isSnIproduct && (allMandsDoc.ECM_Type__c != 'Ent_AccountApplication')){
                                    errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
                                }else if (!isSnIproduct && (allMandsDoc.ECM_Type__c != 'Ent_AccountApplication')){
                                    errorSet.add('Please upload a ' + ' ' + allMandsDoc.ECM_Type__c + ' ' + 'type document for' + ' ' + uploadedDocMap.get(allMandsDoc.ECM_Type__c)+',');
                                }
                            }
						}
					}
				}
			}
		} else{
			errorSet.add('Please upload primary client mandatory documents');
		}
		errorList = new List<String>(errorSet);
		//W-013343 - Tawanda K Madavo
		//exclude validation errors for credit onboarding and complex credit onboarding
		if(opportunities[0].RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Onboarding').getRecordTypeId() ||
		opportunities[0].RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId()){
		errorList = new List<String>();
	}
		if ((!errorList.isEmpty() && errorList.size() > 0) || uploadedDocMap.isEmpty()){
			opportunities[0].CheckMandatoryDocuments__c = true;
		} else{
			opportunities[0].CheckMandatoryDocuments__c = false;
		}
		update opportunities[0];
		return errorList;
	}

	/**
	 * @description getAccountContactRelation description
	 *
	 * @param oppId (id): oppId
	 * @return List<AccountContactRelation>: Return description
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
	 * @description findOppData description
	 *
	 * @return List<OpportunityLineItem>: Return description
	 */
	@AuraEnabled
	public static List<OpportunityLineItem> findOppData(){
		List<OpportunityLineItem> oppLn = [SELECT Id, Policy_Number__c
		                                   FROM OpportunityLineItem];
		return oppLn;
	}

	/**
	 * @description getRelatedParties description
	 *
	 * @param oppId (Id): oppId
	 * @return List<Map<String,Object>>: Return description
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
	 * @description A method for verifying if the Opportunity passed in is of type CAF Application.
	 * @param docId is the Opportuninty Id passed from the Lightning Component.
	 * @return a boolen result of if the Opportunity record type is CAF Application or not.
	 **/
	@AuraEnabled
    public static String deleteDocument(Id docId) {
        String strToreturn = '';
        Document__c doc = [SELECT Id, Reference__c
                           FROM Document__c
                           WHERE id = :docId];
        try {
            delete doc;
        } 
        catch (DmlException e) {            
            strToreturn = e.getMessage();
        } 
        return strToreturn;
    } 
	/**
	 * @description A method for verifying if the Opportunity passed in is of type CAF Application.
	 * @param docId is the Opportuninty Id passed from the Lightning Component.
	 * @return a boolen result of if the Opportunity record type is CAF Application or not.
	 **/
    @AuraEnabled
    public static String restrictSystemDocs(Id docId) {
        String generatedDoc = '';
        generatedDoc = [SELECT Id, Reference__c,Document_Generated__c
                           FROM Document__c
                           WHERE id = :docId].Document_Generated__c;
        return generatedDoc;
    } 

	/**
	 * @description A method to update opportunity status
	 * @param opportunityId
	 * @return String
	 **/
    @AuraEnabled
    public static String opportunityStatusUpdate(String opportunityId){
        Opportunity opportunityObj = new Opportunity(Id=opportunityId, StageName = 'Closed');
        try{
            Update opportunityObj;
            return 'success';
        }catch(exception e){
            return e.getMessage();
        }
    }
    
    /**
	 * @description A method to sendEmail
	 * @param opportunityId
	 * @param emailTemplate
	 * @param emailAddress
	 * @param fileName
	 * @param pdfData
	 **/
    @AuraEnabled
    public static void sendEmail(Id opportunityId, String emailTemplate, String emailAddress, String fileName,  String pdfData){
        Id targetObjectId = [Select id from Contact where Email != '' limit 1].Id;
        List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(opportunityId, targetObjectId, emailAddress,emailTemplate);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'businessbanking@absa.africa']; //need to change
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(constructEmail.get(0).getSubject()+ ' - ' + fileName);
        mail.setSaveAsActivity(true);
        mail.setToAddresses(new List<String>{emailAddress});
        mail.setHtmlBody(constructEmail.get(0).getHtmlBody());
        mail.setOrgWideEmailAddressId(owea[0].Id);
        
        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(fileName + '.pdf');
        efa.setBody(EncodingUtil.base64Decode(pdfData));
        fileAttachments.add(efa);
        mail.setFileAttachments(fileAttachments);
        mails.add(mail);
        
        Messaging.sendEmail(mails);
        try {
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'businessbanking@absa.africa';
            email.Subject = mail.getSubject();
            email.HtmlBody = mail.getHtmlBody();
            email.RelatedToId = opportunityId;
            insert email;
        } catch (DmlException ex) {
            throw ex;
        }
    }
	 /**
	 * @description A method to get getRelatedAccConIds
	 * @author Anka Ganta.
	 * @param accountHierarchy
	 * @return Set<Id>
	 */
    public Static Set<Id> getRelatedAccConIds(String accountHierarchy){
        String relationshipType='AccountContact';        
        List<OnboardingUBOListViewController.ParentAccountWrapper> accountHierarchyWrapper = new List<OnboardingUBOListViewController.ParentAccountWrapper>();           
            accountHierarchyWrapper = (List<OnboardingUBOListViewController.ParentAccountWrapper>)JSON.deserialize(accountHierarchy, List<OnboardingUBOListViewController.ParentAccountWrapper>.class);
            List<Id> participantIds = new List<Id>(); 
            List<Account> rpAccounts = new List<Account>();
            for(OnboardingUBOListViewController.ParentAccountWrapper accWrapper : accountHierarchyWrapper){
                 participantIds.add(accWrapper.recordId);
                
                if(accWrapper.Accwrplist != null && accWrapper.Accwrplist.size() > 0){
                    participantIds = OnboardingCASAScreeningController.getParticipantsData(accWrapper.Accwrplist,participantIds,relationshipType);
                }
                
            }
            Set<Id> participantIdsSet = new Set<Id>();
            participantIdsSet.addAll(participantIds);
            return participantIdsSet;
    }
    
}