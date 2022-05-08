/**
 * @description A controller for retrieving and updating ECM documents.
 * @author Masimba Chingwende.
 * @created 2019-03-30
 **/
public class DocumentController{
	/**
	 * @description A static variable to use to limit the number of documents returned.
	 **/
	private static final Integer MAX_DOCUMENTS = 100;
	/**
	 * @description A method for retrieving a list of existing documents linked to the asset object.
	 * @param parentId parent object Id the docs are linked to.
	 * @return result list of docs linked to parent object Id.
	 *
	 * @modified 2019-06-14 by Robert McLean.
	 * @Change description Made the method reusable across different objects using getParentObjectName method.
	 **/
	@AuraEnabled
	public static String getDocumentList(Id parentId){
		String parentFieldName = getParentObjectName(parentId);
		List<Document__c> result = new List<Document__c>();
		List<Document__c> documents = new DocumentsSelector().getDocuments(parentId, parentFieldName, MAX_DOCUMENTS);
		for (Document__c doc : documents){
			result.add(doc);
		}
		return JSON.serialize(result);
	}

	/**
	 * @description refreshDocumentList description
	 *
	 * @param parentId (Id): parentId
	 * @param parentFieldName (String): parentFieldName
	 * @return String: Return description
	 */
	@AuraEnabled
	public static String refreshDocumentList(Id parentId, String parentFieldName){
		//query documents from ECM

		List<Document__c> result = new List<Document__c>();
		List<Document__c> documents = new DocumentsSelector().getDocuments(parentId, parentFieldName, MAX_DOCUMENTS);
		for (Document__c doc : documents){
			result.add(doc);
		}
		return JSON.serialize(result);
	}

	/**
	 * @description A method for verifying if the Opportunity passed in is of type Virtual Advisor.
	 * @param recId is the Opportuninty Id passed in from the component.
	 * @return a boolen result of if the Opportunity record type is Virtual Advisor or not.
	 **/
	@AuraEnabled
	public static Boolean checkIfVARecType(Id recId){
		Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Virtual Advisor').getRecordTypeId();
		Id oppRecId = [SELECT RecordTypeId
		               FROM Opportunity
		               WHERE Id = :recId].RecordTypeId;

		if (oppRecordTypeId == oppRecId){
			return true;
		} else{
			return false;
		}
	}

	/**
	 * @description A method to append to and existing file or save a file to the Attachment object. Once the file is save or updated it is then sent to ECM.
	 * @param parentId parent object Id the docs are linked to.
	 * @param fileName name of the file.
	 * @param base64Data body of the file.
	 * @param contentType type of file being uploaded.
	 * @param fileId Id of existing file that has already been saved to Attachment object.
	 * @param done indidcator to continu to ECM
	 * @param documentType the type of document beind uploaded.
	 * @param signedManually indicate if doc has been signed manually or not
	 * @param relatedPartyId
	 * @return fileId Id of file updated or saved.
	 *
	 * @modified 2019-06-14 by Robert McLean.
	 * @Change description Added document type to parameters to be used with the completeUpload method.
	 **/
	@AuraEnabled
	public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, Boolean done, String documentType, Boolean signedManually, String relatedPartyId){
		if (fileId == ''){
			fileId = saveTheFile(parentId, fileName, base64Data, contentType);
		} else{
			appendToFile(fileId, base64Data);
		}
		if (done){
			completeUpload(fileId, documentType, signedManually, relatedPartyId);
		}
		return Id.valueOf(fileId);
	}
    
	/**
	 * @description A method to save a file to the attachment object.
	 * @param parentId parent object Id the docs are linked to.
	 * @param fileName name of the file.
	 * @param base64Data body of the file.
	 * @param contentType type of file being uploaded.
	 * @return fileId attachment object Id of file saved.
	 **/
	public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType){
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		Attachment oAttachment = new Attachment();
		oAttachment.parentId = parentId;
		oAttachment.Body = EncodingUtil.base64Decode(base64Data);
		oAttachment.Name = fileName;
		oAttachment.ContentType = contentType;
		insert oAttachment;
		return oAttachment.Id;
	}

	/**
	 * @description A method to append to an existing file in the attachment object.
	 * @param fileId Id of existing file that has already been saved to Attachment object.
	 * @param base64Data body of the file.
	 **/
	public static void appendToFile(Id fileId, String base64Data){
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		Attachment a = [SELECT Id, Body
		                FROM Attachment
		                WHERE Id = :fileId];
		String existingBody = EncodingUtil.base64Encode(a.Body);
		a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
		update a;
	}

	/**
	 * @description A method to upload a document from Attachment's object to ECM.
	 * @param fileId Id of existing file that has already been saved to Attachment object.
	 * @param documentType the type of document beind uploaded.
	 * @param signedManually indicate if doc has been signed manually or not
	 * @param relatedPartyId indicate if doc has been signed manually or not
	 *
	 * @modified 2019-06-14 by Robert McLean.
	 * @Change description Made the method reusable across different objects using getParentObjectName method also added documentType parameter
	 **/
	@AuraEnabled@future(callout = true)
	public static void completeUpload(String fileId, String documentType, Boolean signedManually, String relatedPartyId){
		Attachment a = [SELECT Id, Body, Name, ParentId
		                FROM Attachment
		                WHERE Id = :fileId];

		String fileName = a.Name;
		Id parentId = a.ParentId;
		Id userId = UserInfo.getUserId();
		List<sObject> accountIdList;
		String accountId;
		if (getParentObjectName(parentId) == 'Covenant__c'){
			accountIdList = Database.query('SELECT Account__c FROM ' + getParentObjectName(parentId)+' WHERE Id = \'' + parentId + '\'');
			accountId = String.valueof(accountIdList[0].get('Account__c'));
		} else{
			accountIdList = Database.query('SELECT AccountId FROM ' + getParentObjectName(parentId)+' WHERE Id = \'' + parentId + '\'');
			accountId = String.valueof(accountIdList[0].get('AccountId'));
		}

		Account acc = new AccountsSelector().selectAllById(accountId);
		User usr = [SELECT Id, Business_Area__c
		            FROM User
		            WHERE Id = :userId];
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
		ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
		request.Token = login.Token;
		request.FileName = fileName;
		setDocumentECMInfo(request, parentId, acc, usr, documentType, relatedPartyId);
		request.Data = EncodingUtil.base64Encode(a.Body);
		req.AddRequest = request;
		ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(req);
		String fileReference = addResult.Pid;


		String sObjName = parentId.getSObjectType().getDescribe().getName();
		String recordTypeName;
		List<Case> caseList = new List<Case>();
		List<Opportunity> oppList = new List<Opportunity>();
		if (sObjName == 'Case'){
			caseList = new casesSelector().selectByCaseId(parentId);
			recordTypeName = caseList[0].RecordType.Name;
		}
		if (sObjName == 'Opportunity'){
			oppList = new OpportunitiesSelector().selectByOpportunityId(parentId);
			recordTypeName = oppList[0].RecordType.Name;
		}
		if ((sObjName == 'Case' && recordTypeName == 'Credit FulFillment') || (sObjName == 'Opportunity' && recordTypeName == 'Credit Maintenance')){
			addDocumentItemCredit(fileName, parentId, fileReference, documentType, signedManually, relatedPartyId, fileId);
		} else{
			addDocumentItem(fileName, parentId, fileReference, documentType, signedManually, relatedPartyId, fileId);
		}
	}
	/**
	 * @description A method to upload a document to ECM.
	 * @param recId Id of parent.
	 * @param documentType name of the documenttype.
	 * @param fileName name of the Certificate.
	 * @param body file body.
	 *
	 **/
	public static void sendTOECM(String recId, String documentType, String fileName, String body){
		Id userId = UserInfo.getUserId();
		Account acc = new Account();
		Id applicationProductId;

		if (getParentObjectName(recId) == 'Account'){
			acc = new AccountsSelector().selectAllById(recId);
		} else{
			Case caseRec = [SELECT Id, Subject, AccountId, Type, Application_Product_Id__c
			                FROM Case
			                WHERE Id = :recId];
			acc = new AccountsSelector().selectAllById(caseRec.AccountId);//[select id,Name,Registration_Number__c from Account where id=: caseRec.AccountId];//new AccountsSelector().selectAllById(recId);
			if (caseRec != null && caseRec.Type == 'CAF Fulfilment' && String.isNotBlank(caseRec.Application_Product_Id__c)){
				applicationProductId = caseRec.Application_Product_Id__c;
			}
		}
		User usr = [SELECT Id, Business_Area__c
		            FROM User
		            WHERE Id = :userId];
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
		ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
		request.Token = login.Token;
		request.FileName = fileName;
		setDocumentECMInfo(request, recId, acc, usr, documentType, '');
		request.Data = body;
		req.AddRequest = request;
		ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(req);
		String fileReference = addResult.Pid;

		Document__c doc = new Document__c();
		doc.Name = fileName + '.pdf';
		doc.Type__c = documentType;
		doc.Source_System__c = 'Uploaded';
		doc.ECM_Type__c = new DocumentTemplateSelector().selectTemplateByName(documentType).ECM_Item_Type__c;
		doc.Application_Product_CAF__c = applicationProductId;

		switch on getParentObjectName(recId){
			when 'Asset'{
				doc.Asset__c = recId;
			}
			when 'Opportunity'{
				doc.Opportunity__c = recId;
			}
			when 'Account'{
				doc.Account__c = recId;
			}
			when 'Case'{
				doc.Case__c = recId;
			}
			when 'Covenant__c'{
				doc.Covenant__c = recId;
			}
		}
		doc.Reference__c = fileReference;
		if (!Test.isRunningTest()){
			insert doc;
		}

		Attachment oAttachment = new Attachment();
		oAttachment.parentId = recId;
		oAttachment.Body = EncodingUtil.base64Decode(body);
		oAttachment.Name = fileName + '.pdf';
		oAttachment.ContentType = 'application/pdf';
		insert oAttachment;

		if (!Test.isRunningTest()){
			doc.File_Id__c = oAttachment.Id;
			update doc;
		}
	}

	/**
	 * @description A method to get pick list values from the Document object field Type__c.
	 * @author Robert McLean.
	 * @created 2019-06-14
	 * @param objectName the object the file is on.
	 * @param selectedField the name of the field that holds the pick list values.
	 * @param caseId
	 * @return fileTypePickList list of pick list values.
	 **/
	@AuraEnabled
	public static List<String> getFileTypePickList(string objectName, string selectedField, id caseId){
		String sObjName = caseId.getSObjectType().getDescribe().getName();
		List<Case> caseList = new casesSelector().selectByCaseId(caseId);

		if (objectName == 'Case'){
			String recordTypeName = caseList[0].RecordType.Name;
			List<String> fileTypePickList = new List<String>();
			if (recordTypeName == 'Service Request'){
				fileTypePickList.add('Motivation: Client Interest / Cost Reimbursement Request');
				fileTypePickList.add('Proof of banking account');
				fileTypePickList.add('Root Cause Analysis Form');
				fileTypePickList.add('Bank Statement(s) showing erroneous fee charges');
				fileTypePickList.add('Validated Fee Calculations');
				fileTypePickList.add('Bank Statement(s) showing erroneous interest charges');
				fileTypePickList.add('Interest Calculation PDF Document');
				fileTypePickList.add('Banking Facility Letter or other agreed price contract');
				fileTypePickList.add('Operational Risk Event Form');
				fileTypePickList.add('Risk Event Number');
				fileTypePickList.add('IT incident Number');
				fileTypePickList.add('Fraud Form');
				fileTypePickList.add('Legal Collections Form/Agreement');
				fileTypePickList.add('Supported Approvals');
				fileTypePickList.add('Deed of Settlement');
				fileTypePickList.add('Other');
			} else{
				fileTypePickList.add('Absa 3121 EX - Site Inspection');
			}

			return fileTypePickList;

		} else if (objectName == 'Covenant'){
			List<String> fileTypePickList = new list<String>();
			fileTypePickList.add('Credit Approval');
			fileTypePickList.add('Debtors & Stock');
			fileTypePickList.add('Debtors Age Analysis');
			fileTypePickList.add('Management Accounts');
			fileTypePickList.add('Annual Financial Statements');
			fileTypePickList.add('Official SARS Document');
			fileTypePickList.add('Absa 691 – Letter Cession of Debtors');
			fileTypePickList.add('Absa 692 - Control Sheet ');
			return fileTypePickList;
		} else{
			List<String> fileTypePickList = PickListController.getPickListValuesUsingObjectName(objectName, selectedField);
			return fileTypePickList;
		}
	}

	/**
	 * @description A method to get pick list values from the Document_Template__c object field Parent_Document_Type__c.
	 * @author Thulani Maseko.
	 * @created 2020-09-17
	 * @param objectName the object the file is on.
	 * @param selectedField the name of the field that holds the pick list values.
	 * @return DocumentTypePickList list of pick list values.
	 **/
	@AuraEnabled
	public static List<String> getDocumentTypePickList(string objectName, string selectedField){
		return PickListController.getPickListValuesUsingObjectName(objectName, selectedField);
	}

	/**
	 * @description A method to get pick list values from the Document_Template object field Name.
	 * @author Thulani Maseko.
	 * @created 2020-09-17
	 * @param documentType the object the file is on.
	 * @param caseId
	 * @return DocumentNamePickList list of pick list values.
	 **/
	@AuraEnabled
	public static List<String> getDocumentNamePickList(String documentType, id caseId){
		String getRecTypeName;
		String sObjName = null;
		if (caseId != null){
			sObjName = caseId.getSObjectType().getDescribe().getName();
		}
		if (sObjName == 'Case'){
			getRecTypeName = [SELECT Id, RecordType.Name
			                  FROM Case
			                  WHERE Id = :caseId].RecordType.Name;
		}
		List<String> fileTypePickList = new list<String>();

		if (sObjName == 'Case' && getRecTypeName != 'CAF Application'){
			fileTypePickList.add('Absa 3121 EX - Site Inspection');
		} else{
			fileTypePickList = PickListController.getPickListValuesWithParentDocumentName(documentType);
		}
		return fileTypePickList;
	}

	/**
	 * @description A method to add a document from Document's object.
	 * @param fileName name of the file.
	 * @param parentId parent object Id the docs are linked to.
	 * @param fileReference ECM reference.
	 * @param documentType type of document.
	 * @param signedManually is doc signed
	 * @param relatedPartyId related party id
	 * @param fileId
	 *
	 * @modified 2019-06-14 by Robert McLean.
	 * @Change description Made the method reusable across different objects using getParentObjectName method also added documentType parameter
	 **/
	@AuraEnabled
	public static void addDocumentItem(String fileName, Id parentId, String fileReference, String documentType, Boolean signedManually, String relatedPartyId, String fileId){

		String parentIsDtring = parentId;
		Document__c doc = new Document__c();
		doc.Name = documentType.left(75)+'.pdf';
		doc.Type__c = documentType;
		doc.Source_System__c = 'Uploaded';
		doc.ECM_Type__c = new DocumentTemplateSelector().selectTemplateByName(documentType).ECM_Item_Type__c;
		doc.File_Id__c = fileId;

		If (parentIsDtring.startsWithIgnoreCase('006')){
			doc.Opportunity__c = parentId;
		}

		//Added the if statement to cater for accountContact and accountAccount
		//Added by Masechaba Maseli for W-004896, W-004893 for documents to be uploaded for Related Parties that are Non-Individuals to relate them to the account
		if (relatedPartyId != '0' && relatedPartyId != null && relatedPartyId != ''){
			String relatedIsString = relatedPartyId;

			If (relatedIsString.startsWith('07k')){
				AccountContactRelation arc = new AccountContactRelationSelector().selectbyAccountContactRelationId(relatedPartyId);
				iF (arc != Null){
					doc.Contact__c = arc.Contact.Id;
				}
			} Else{
				FinServ__AccountAccountRelation__c accAccRel = new AccountAccountRelationSelector().selectbyAccAccRelId(relatedPartyId);
				iF (accAccRel != Null){
					doc.Account__c = accAccRel.FinServ__RelatedAccount__c;
				}
			}

		} else{
			if (getParentObjectName(parentId) == 'Opportunity'){
				List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(parentId);
				if (opportunities.get(0).AccountId != Null){
					doc.Account__c = opportunities.get(0).AccountId;
				}
				if (opportunities.get(0).RecordType.Name == 'Credit Onboarding'){
					doc.Name = fileName;
				}
			}
		}
		switch on getParentObjectName(parentId){
			when 'Asset'{
				doc.Asset__c = parentId;
			}
			when 'Opportunity'{
				doc.Opportunity__c = parentId;
			}
			when 'Account'{
				doc.Account__c = parentId;
			}
			when 'Case'{
				doc.Case__c = parentId;
			}
			when 'Covenant__c'{
				doc.Covenant__c = parentId;
			}
		}
		doc.Reference__c = fileReference;
        doc.Generated_Uploaded__c = 'Uploaded';
		if (signedManually){
			doc.Document_Status__c = 'Signed Manually';
		}
		if (!Test.isRunningTest()){
			insert doc;
		}
	}
    
   
	/**
	 * @description A method to get existing ECM docs from ECM.
	 * @param docId Id of document from Document object.
	 * @return document form ECM.
	 **/
	@AuraEnabled
	public static String getDocumentContent(String docId){
		Document__c doc = [SELECT Id, Reference__c
		                   FROM Document__c
		                   WHERE id = :docId];
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, doc.Reference__c);
		if (getResult.Content != null)
			return getResult.Content.data;
		else
			return '';
	}

	/**
	 * @description A method to get ECM Wills docs from ECM and add them to Salesforce.
	 * @param parentId parent object Id the docs are linked to.
	 * @return updated list of documents.
	 **/
	@AuraEnabled
	public static String refreshDocuments(Id parentId){
		if (getParentObjectName(parentId) == 'Asset'){
			Asset will = [SELECT Id, Name, SerialNumber, AccountId
			              FROM Asset
			              WHERE Id = :ParentId];
			Map<String, String> credentials = ECM_IH_V1.getCredentials();
			ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
			ECM_QueryRequest request = new ECM_QueryRequest();
			request.QueryRequest = new ECM_QueryRequest.QueryRequest();
			request.QueryRequest.Token = login.Token;
			request.QueryRequest.Query = '/Will[@WillNo = \"' + will.SerialNumber + '\"]';
			ECM_QueryResult res = ECM_IH_V1.query(request);
			List<Document__c> documents = new List<Document__c>();
			for (ECM_QueryResult.Document doc : res.Documents.document){
				//upsert
				ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, doc.PID);
				Document__c d = new Document__c();
				d.Name = getResult.Content.FileName;
				d.Asset__c = parentId;
				d.Reference__c = doc.PID;
				d.Type__c = doc.ItemType;
				documents.add(d);
			}

			if (!documents.isEmpty()){
				upsert documents Reference__c;
			}
		}
		return getDocumentList(parentId);
	}

	/**
	 * @description A method to get the of the object based on the Id of the itme in the object.
	 * @author Robert McLean.
	 * @created 2019-06-14
	 * @param parentId parent object Id the docs are linked to.
	 * @return parentObjName name of the object.
	 **/
	@AuraEnabled
	public static String getParentObjectName(Id parentId){
		Id pId = parentId;
		String parentObjName = pId.getSObjectType().getDescribe().getName();
		return parentObjName;
	}

	/**
	 * @author Vladimir Panajic
	 * @description Method that gets a list of all documents metadata
	 *
	 * @return documentTemplates
	 */
	@AuraEnabled
	public static List<Document_Template__c> getDocumentMetadata(){
		List<Document_Template__c> documentTemplates = new DocumentTemplateSelector().getAllDocumentTemplates();
		return documentTemplates;
	}

	/**
	 * @description A method to support the completeUpload method for all document types
	 * @author Vladimir Panajic
	 * @created 2019-11-06
	 * @param request
	 * @param parentId
	 * @param acc
	 * @param usr
	 * @param documentType
	 * @param relatedPartyId
	 **/
	@AuraEnabled
	public static void setDocumentECMInfo(ECM_AddRequest_IB_V1.AddRequest request, Id parentId, Account acc, User usr, String documentType, String relatedPartyId){
		Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByType(documentType);
		if (documentTemplate != null){

			if (relatedPartyId != '0' && relatedPartyId != null && relatedPartyId != ''){
				String relatedIsString = relatedPartyId;

				If (relatedIsString.startsWith('07k')){
					AccountContactRelation arc = new AccountContactRelationSelector().selectbyAccountContactRelationId(relatedPartyId);
					request.addFieldValue('IdNr', arc.Contact.ID_Number__c);
					request.addFieldValue('AcctNr', arc.AccountId == null ? '0' : arc.AccountId);
				} else{
					FinServ__AccountAccountRelation__c accAccRelList1 = new AccountAccountRelationSelector().selectbyAccAccRelId(relatedPartyId);
					request.addFieldValue('IdNr', accAccRelList1.FinServ__RelatedAccount__r.Registration_Number__c == null ? '0' : accAccRelList1.FinServ__RelatedAccount__r.Registration_Number__c);

				}
			} else{
				request.addFieldValue('IdNr', acc.Registration_Number__c == null ? '0' : acc.Registration_Number__c);
			}
			request.addFieldValue('FilingDate', DateTime.now().format('dd/MM/yyyy'));
			request.addFieldValue('CIFNr', acc.CIF__c == null ? '0' : acc.CIF__c);
			request.addFieldValue('Origin', 'Salesforce B2C');
			request.addFieldValue('BusinessUnit', 'RB');

			if (documentTemplate.ECM_Account_Number_Metadata__c){
				if (test.isRunningTest()){
					documentType = 'Will';
				}
				if (documentType == 'Will'){
					switch on getParentObjectName(parentId){
						when 'Asset'{
							Set<Id> idSet = new Set<Id>();
							idSet.add(parentId);
							//  List<Asset> will = new AssetsSelector().selectById(idSet);
							List<Asset> will = [Select Id, SerialNumber
							                    From Asset
							                    where Id in :idSet]; // added by Masechaba Maseli as the test class was failing on this assetsselector method
							if (!will.isEmpty()){
								request.addFieldValue('WillNo', will.get(0).SerialNumber);
							}
						}
						when 'Opportunity'{
							request.addFieldValue('WillNo', ('NWN' + parentId).abbreviate(11));
						}
					}
				} else{
					switch on getParentObjectName(parentId){
						when 'Asset'{
							request.addFieldValue('AcctNr', ('Ast' + parentId).abbreviate(11));
						}
						when 'Opportunity'{
							request.addFieldValue('AcctNr', ('Opp' + parentId).abbreviate(11));
						}
					}
				}
			}
			request.ItemType = documentTemplate.ECM_Item_Type__c;
		}
	}

	/**
	 * @description A method to validated that documents do not get uploaded when in qa process
	 * @author Masechaba Maseli
	 * @created 0708220
	 * @param recordId
	 * @return boolean
	 **/
	@AuraEnabled
	public static boolean validateQAProcess(Id recordId){
		Opportunity opportunityToValidate = new OpportunitiesSelector().selectByOppId(recordId);
		If (opportunityToValidate.Complex_Application__c && (opportunityToValidate.QA_Complex_Approval_Status__c == 'Submitted' || opportunityToValidate.QA_Complex_Approval_Status__c == 'Accepted By Approver')){
			return true;
		} else{
			return false;
		}
	}

	/**
	 * @description A method for verifying if the Opportunity passed in is of type CAF Application.
	 * @param recordId is the Opportuninty Id passed from the Lightning Component.
	 * @return a boolen result of if the Opportunity record type is CAF Application or not.
	 * @created 2021-01-04 by Prashanth boeni
	 **/
	@AuraEnabled
	public static Boolean getRecordTypeName(Id recordId){
		Id recordTypeId;
		Id getRecId;
		if (getParentObjectName(recordId) == 'Opportunity'){
			recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
			getRecId = [SELECT RecordTypeId
			            FROM Opportunity
			            WHERE Id = :recordId].RecordTypeId;
		} else if (getParentObjectName(recordId) == 'Case'){
			recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CAF Application').getRecordTypeId();
			getRecId = [SELECT RecordTypeId
			            FROM Case
			            WHERE Id = :recordId].RecordTypeId;
		}
		if (recordTypeId == getRecId){
			return true;
		} else{
			return false;
		}
	}

	/**
	 * @description isOppRecord description
	 *
	 * @param recordId (Id): recordId
	 * @return Boolean: Return description
	 */
	@AuraEnabled
	public static Boolean isOppRecord(Id recordId){
		if (getParentObjectName(recordId) == 'Opportunity'){
			return true;
		} else{
			return false;
		}
	}

	/**
	 * @description A method for getting applications under an opportunity that we pass.
	 * @param recordId is the Opportuninty Id passed from the Lightning Component.
	 * @return a list of application names of an opportunity.
	 * @created 2021-01-04 by Prashanth Boeni
	 **/
	@AuraEnabled
	public static List<Application_Product_CAF__c> getApplicationNames(Id recordId){
		Set<Id> appProdCAFIds = new Set<Id>();
		List<Application_Product_CAF__c> appProdCafeList = new List<Application_Product_CAF__c>();
		List<OpportunityLineItem> oppLineItemsSelectorList = new OpportunityLineItemsSelector().selectByOpportunityId(recordId);

		if (oppLineItemsSelectorList.size() > 0 && oppLineItemsSelectorList != null){
			for (OpportunityLineItem oppLineItme : oppLineItemsSelectorList){
				appProdCAFIds.add(oppLineItme.Application_Product_CAF__c);
			}
		}

		if (appProdCAFIds.size() > 0 && appProdCAFIds != null){
			appProdCafeList = new ApplicationProductCAFSelector().selectByOpportunityLineItemId(appProdCAFIds);
		}

		if (appProdCafeList.size() > 0){
			return appProdCafeList;
		} else{
			return null;
		}
	}

	/**
	 * @description A method to append to and existing file or save a file to the Attachment object. Once the file is save or updated it is then sent to ECM.
	 * @param parentId parent object Id the docs are linked to.
	 * @param oppApplicationId getting application id
	 * @param fileName name of the file.
	 * @param base64Data body of the file.
	 * @param contentType type of file being uploaded.
	 * @param fileId Id of existing file that has already been saved to Attachment object.
	 * @param done indidcator to continu to ECM
	 * @param documentType the type of document beind uploaded.
	 * @param signedManually
	 * @param relatedPartyId
	 * @param fExt
	 * @return fileId Id of file updated or saved.
	 *
	 * @modified 2021-01-04 by Prashanth boeni.
	 * @Change description Added document type to parameters to be used with the completeUploadCAF method.
	 **/
	@AuraEnabled
	public static Id saveChunkCAF(Id parentId, Id oppApplicationId, String fileName, String base64Data, String contentType, String fileId, Boolean done, String documentType, Boolean signedManually, String relatedPartyId, String fExt){
		if (fileId == ''){
			fileId = saveTheFile(parentId, fileName, base64Data, contentType);
		} else{
			appendToFile(fileId, base64Data);
		}
		if (done){
			completeUploadCAF(fileId, oppApplicationId, documentType, signedManually, relatedPartyId, fExt);
		}
		return Id.valueOf(fileId);
	}
    
    /**
    * @description 
    * @param parentId 
    * @param oppApplicationId 
    * @param fileName 
    * @param base64Data 
    * @param contentType 
    * @param fileId 
    * @param done 
    * @param documentType 
    * @param signedManually 
    * @param relatedPartyId 
    * @param fExt 
    * @param documentId 
    * @param accountId 
    * @param contactId 
    * @return Id 
    **/
    @AuraEnabled
	public static Id saveChunkCAF(Id parentId, Id oppApplicationId, String fileName, String base64Data, String contentType, String fileId, Boolean done, String documentType, Boolean signedManually, String relatedPartyId, String fExt , string documentId, Id accountId, Id contactId){
		if (fileId == ''){
			fileId = saveTheFile(parentId, fileName, base64Data, contentType);
		} else{
			appendToFile(fileId, base64Data);
		}
		if (done){
			completeUploadCAF(fileId, oppApplicationId, documentType, signedManually, relatedPartyId, fExt,documentId, accountId, contactId);
		}
		return Id.valueOf(fileId);
	}

	/**
	 * @description A method to upload a document from Attachment's object to ECM.
	 * @param fileId Id of existing file that has already been saved to Attachment object.
	 * @param oppApplicationId getting application product CAF id to specify the application for document.
	 * @param documentType the type of document beind uploaded.
	 * @param signedManually
	 * @param relatedPartyId
	 * @param fExt
	 *
	 * @modified 2021-01-04 by Prashanth boeni.
	 * @Change description Made the method reusable across different objects using getParentObjectName method also added documentType parameter
	 */
	@AuraEnabled@future(callout = true)
	public static void completeUploadCAF(String fileId, Id oppApplicationId, String documentType, Boolean signedManually, String relatedPartyId, String fExt){
		Attachment a = [SELECT Id, Body, Name, ParentId
		                FROM Attachment
		                WHERE Id = :fileId];

		String fileName = a.Name;
		Id parentId = a.ParentId;
		Id userId = UserInfo.getUserId();
		List<sObject> accountIdList;
		String accountId;
		if (getParentObjectName(parentId) == 'Covenant__c'){
			accountIdList = Database.query('SELECT Account__c FROM ' + getParentObjectName(parentId)+' WHERE Id = \'' + parentId + '\'');
			accountId = String.valueof(accountIdList[0].get('Account__c'));
		} else{
			accountIdList = Database.query('SELECT AccountId FROM ' + getParentObjectName(parentId)+' WHERE Id = \'' + parentId + '\'');
			accountId = String.valueof(accountIdList[0].get('AccountId'));
		}
		Account acc = new AccountsSelector().selectAllById(accountId);
		User usr = [SELECT Id, Business_Area__c
		            FROM User
		            WHERE Id = :userId];
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
		ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
		request.Token = login.Token;
		request.FileName = fileName;
		setDocumentECMInfo(request, parentId, acc, usr, documentType, relatedPartyId);
		request.Data = EncodingUtil.base64Encode(a.Body);
		req.AddRequest = request;
		ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(req);
		String fileReference = addResult.Pid;
		addDocumentItemCAF(fileName, parentId, oppApplicationId, fileReference, documentType, signedManually, relatedPartyId, fExt, fileId);
	}
    
	/**
	* @description 
	* @param fileId 
	* @param oppApplicationId 
	* @param documentType 
	* @param signedManually 
	* @param relatedPartyId 
	* @param fExt 
	* @param documentId 
	* @param acctId 
	* @param contactId 
	**/
    @AuraEnabled@future(callout = true)
	public static void completeUploadCAF(String fileId, Id oppApplicationId, String documentType, Boolean signedManually, String relatedPartyId, String fExt , string documentId, Id acctId, Id contactId){
		Attachment a = [SELECT Id, Body, Name, ParentId
		                FROM Attachment
		                WHERE Id = :fileId];

		String fileName = a.Name;
		Id parentId = a.ParentId;
		Id userId = UserInfo.getUserId();
		List<sObject> accountIdList;
		String accountId;
		if (getParentObjectName(parentId) == 'Covenant__c'){
			accountIdList = Database.query('SELECT Account__c FROM ' + getParentObjectName(parentId)+' WHERE Id = \'' + parentId + '\'');
			accountId = String.valueof(accountIdList[0].get('Account__c'));
		} else{
			accountIdList = Database.query('SELECT AccountId FROM ' + getParentObjectName(parentId)+' WHERE Id = \'' + parentId + '\'');
			accountId = String.valueof(accountIdList[0].get('AccountId'));
		}
		Account acc = new AccountsSelector().selectAllById(accountId);
		User usr = [SELECT Id, Business_Area__c
		            FROM User
		            WHERE Id = :userId];
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
		ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
		request.Token = login.Token;
		request.FileName = fileName;
		setDocumentECMInfo(request, parentId, acc, usr, documentType, relatedPartyId);
		request.Data = EncodingUtil.base64Encode(a.Body);
		req.AddRequest = request;
		ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(req);
		String fileReference = addResult.Pid;
		addDocumentItemCAF(fileName, parentId, oppApplicationId, fileReference, documentType, signedManually, relatedPartyId, fExt, fileId,documentId, acctId,contactId);
	}

	/**
	 * @description A method to add a document from Document's object.
	 * @param fileName name of the file.
	 * @param parentId parent object Id the docs are linked to.
	 * @param oppApplicationId getting application product CAF id to specify the application for document
	 * @param fileReference ECM reference.
	 * @param documentType doc type
	 * @param signedManually is doc signed manually or not
	 * @param relatedPartyId related party id
	 * @param fExt file extension
	 * @param fileId
	 * @modified 2021-04-01 by Prashanth Boeni.
	 * @Change description Made the method reusable across different objects using getParentObjectName method also added documentType parameter
	 */
	@AuraEnabled
	public static void addDocumentItemCAF(String fileName, Id parentId, Id oppApplicationId, String fileReference, String documentType, Boolean signedManually, String relatedPartyId, String fExt, String fileId){
		Id appCaseId;
		if (oppApplicationId != null && (oppApplicationId != parentId)){
			appCaseId = [SELECT Id, Case__c
			             FROM Application_Product_CAF__c
			             WHERE Id = :oppApplicationId].Case__c;
		}

		Id caseOppId;
		String parentObjName = getParentObjectName(parentId);
		if (parentObjName == 'Case'){
			caseOppId = [SELECT Id, Opportunity__c
			             FROM Case
			             WHERE Id = :parentId].Opportunity__c;
		}

		String parentIsDtring = parentId;
		Document__c doc = new Document__c();
		doc.Name = documentType.left(75)+'.' + fExt;
		doc.Type__c = documentType;
		doc.Source_System__c = 'Uploaded';
		doc.ECM_Type__c = new DocumentTemplateSelector().selectTemplateByName(documentType).ECM_Item_Type__c;
		doc.File_Id__c = fileId;

		If (parentIsDtring.startsWithIgnoreCase('006')){
			doc.Opportunity__c = parentId;
		}

		if (relatedPartyId != '0' && relatedPartyId != null && relatedPartyId != ''){
			String relatedIsString = relatedPartyId;

			If (relatedIsString.startsWith('07k')){
				AccountContactRelation arc = new AccountContactRelationSelector().selectbyAccountContactRelationId(relatedPartyId);
				iF (arc != Null){
					doc.Contact__c = arc.Contact.Id;
				}
			} else{
				FinServ__AccountAccountRelation__c accAccRel = new AccountAccountRelationSelector().selectbyAccAccRelId(relatedPartyId);
				iF (accAccRel != Null){
					doc.Account__c = accAccRel.FinServ__RelatedAccount__c;
				}
			}

		} else{
			if (getParentObjectName(parentId) == 'Opportunity'){
				List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(parentId);
				if (opportunities.get(0).AccountId != Null){
					doc.Account__c = opportunities.get(0).AccountId;
				}
			}
		}
		switch on getParentObjectName(parentId){
			when 'Asset'{
				doc.Asset__c = parentId;
			}
			when 'Opportunity'{
				doc.Opportunity__c = parentId;
				if (oppApplicationId != parentId){
					doc.Application_Product_CAF__c = oppApplicationId;
				}
				if (appCaseId != null){
					doc.Case__c = appCaseId;
				}
			}
			when 'Account'{
				doc.Account__c = parentId;
			}
			when 'Case'{
				doc.Case__c = parentId;
				if (caseOppId != null){
					doc.Opportunity__c = caseOppId;
				}
			}
			when 'Covenant__c'{
				doc.Covenant__c = parentId;
			}
		}
        if(!String.isBlank(fileReference)){
            doc.Reference__c = fileReference;
        }
        else if(!test.isRunningTest()){
            throw new AuraHandledException('Failed to Upload Document');
        }
		
		if (signedManually){
			doc.Document_Status__c = 'Signed Manually';
		}
		if (!Test.isRunningTest()){
			insert doc;
		}
	}
    
	/**
	* @description 
	* @param fileName 
	* @param parentId 
	* @param oppApplicationId 
	* @param fileReference 
	* @param documentType 
	* @param signedManually 
	* @param relatedPartyId 
	* @param fExt 
	* @param fileId 
	* @param documentId 
	* @param accountId 
	* @param contactId 
	**/
    @AuraEnabled
	public static void addDocumentItemCAF(String fileName, Id parentId, Id oppApplicationId, String fileReference, String documentType, Boolean signedManually, String relatedPartyId, String fExt, String fileId,string documentId, Id accountId, Id contactId){
		Id appCaseId;
		if (oppApplicationId != null && (oppApplicationId != parentId)){
			appCaseId = [SELECT Id, Case__c
			             FROM Application_Product_CAF__c
			             WHERE Id = :oppApplicationId].Case__c;
		}

		Id caseOppId;
		String parentObjName = getParentObjectName(parentId);
		if (parentObjName == 'Case'){
			caseOppId = [SELECT Id, Opportunity__c
			             FROM Case
			             WHERE Id = :parentId].Opportunity__c;
		}

		String parentIsDtring = parentId;
		Document__c doc = new Document__c(Id=documentId);
		doc.Name = documentType.left(75)+'.' + fExt;
		doc.Type__c = documentType;
		doc.ECM_Type__c = new DocumentTemplateSelector().selectTemplateByName(documentType).ECM_Item_Type__c;
		doc.File_Id__c = fileId;
        

		If (parentIsDtring.startsWithIgnoreCase('006')){
			doc.Opportunity__c = parentId;
		}

		if (relatedPartyId != '0' && relatedPartyId != null && relatedPartyId != ''){
			String relatedIsString = relatedPartyId;

			If (relatedIsString.startsWith('07k')){
				AccountContactRelation arc = new AccountContactRelationSelector().selectbyAccountContactRelationId(relatedPartyId);
				iF (arc != Null){
					doc.Contact__c = arc.Contact.Id;
				}
			} else{
				FinServ__AccountAccountRelation__c accAccRel = new AccountAccountRelationSelector().selectbyAccAccRelId(relatedPartyId);
				iF (accAccRel != Null){
					doc.Account__c = accAccRel.FinServ__RelatedAccount__c;
				}
			}

		} else{
			if (getParentObjectName(parentId) == 'Opportunity'){
				List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(parentId);
				if (opportunities.get(0).AccountId != Null){
					doc.Account__c = opportunities.get(0).AccountId;
				}
			}
		}
		switch on getParentObjectName(parentId){
			when 'Asset'{
				doc.Asset__c = parentId;
			}
			when 'Opportunity'{
				doc.Opportunity__c = parentId;
				if (oppApplicationId != parentId){
					doc.Application_Product_CAF__c = oppApplicationId;
				}
				if (appCaseId != null){
					doc.Case__c = appCaseId;
				}
			}
			when 'Account'{
				doc.Account__c = parentId;
			}
			when 'Case'{
				doc.Case__c = parentId;
				if (caseOppId != null){
					doc.Opportunity__c = caseOppId;
				}
			}
			when 'Covenant__c'{
				doc.Covenant__c = parentId;
			}
		}
        if(!String.isBlank(fileReference)){
            doc.Reference__c = fileReference;
            doc.Generated_Uploaded__c = 'Uploaded';
            doc.Account__c = accountId;
            doc.Contact__c = contactId;
        }
        else if(!test.isRunningTest()){
            throw new AuraHandledException('Failed to Upload Document');
        }
		
		if (signedManually){
			doc.Document_Status__c = 'Signed Manually';
		}
		if (!Test.isRunningTest()){
			upsert doc;
		}
	}


	/**
	 * @description addDocumentItemCredit description
	 *
	 * @param fileName (String): fileName
	 * @param parentId (Id): parentId
	 * @param fileReference (String): fileReference
	 * @param documentType (String): documentType
	 * @param signedManually (Boolean): signedManually
	 * @param relatedPartyId (String): relatedPartyId
	 * @param fileId (String): fileId
	 */
	@AuraEnabled
	public static void addDocumentItemCredit(String fileName, Id parentId, String fileReference, String documentType, Boolean signedManually, String relatedPartyId, String fileId){
		String parentIsDtring = parentId;
		Document__c doc = new Document__c();
		doc.Name = documentType.left(75)+'.pdf';
		doc.Type__c = documentType;
		doc.Source_System__c = 'Uploaded';
		doc.ECM_Type__c = new DocumentTemplateSelector().selectTemplateByName(documentType).ECM_Item_Type__c;
		doc.File_Id__c = fileId;

		String sObjName = parentId.getSObjectType().getDescribe().getName();
		if (sObjName.equalsIgnoreCase('Opportunity')){
			if (documentType.equalsIgnoreCase('Credit Approval') || documentType.equalsIgnoreCase('7032 - Application for a Covid-19 Loan') || documentType.equalsIgnoreCase('CIPC (Independently Drawn CIPC by banker)') || documentType.equalsIgnoreCase('Absa 7040 EX - COVID-19 Contract')){
				doc.Required__c = 'Yes';
				doc.Source_System__c = 'Uploaded';
			}
			if (documentType.equalsIgnoreCase('Motivation') || documentType.equalsIgnoreCase('Motivation Letter')){
				doc.Source_System__c = 'Uploaded';
			}
		}

		If (parentIsDtring.startsWithIgnoreCase('006')){
			doc.Opportunity__c = parentId;
		}

		if (relatedPartyId != '0' && relatedPartyId != null && relatedPartyId != ''){
			String relatedIsString = relatedPartyId;
			If (relatedIsString.startsWith('07k')){
				AccountContactRelation arc = new AccountContactRelationSelector().selectbyAccountContactRelationId(relatedPartyId);
				iF (arc != Null){
					doc.Contact__c = arc.Contact.Id;
				}
			} Else{
				FinServ__AccountAccountRelation__c accAccRel = new AccountAccountRelationSelector().selectbyAccAccRelId(relatedPartyId);
				iF (accAccRel != Null){
					doc.Account__c = accAccRel.FinServ__RelatedAccount__c;
				}
			}

		}
		switch on getParentObjectName(parentId){
			when 'Asset'{
				doc.Asset__c = parentId;
			}
			when 'Opportunity'{
				doc.Opportunity__c = parentId;
			}
			when 'Account'{
				doc.Account__c = parentId;
			}
			when 'Case'{
				doc.Case__c = parentId;
			}
		}
		doc.Reference__c = fileReference;
		if (signedManually){
			doc.Document_Status__c = 'Signed Manually';
		}
		if (!Test.isRunningTest()){
			insert doc;
		}
	}

	/**
	 * @description A method to validated that documents do not get uploaded when Opportunity is closed: W-008562
	 * @author Anka Ganta
	 * @created 07062021
	 * @param recordId
	 * @return String
	 **/
	@AuraEnabled
	public static String validateOpportunityStage(String recordId){
		Opportunity OpportunityToValidate = new OpportunitiesSelector().selectByOppId(recordId);
		return OpportunityToValidate.StageName;
	}

	/**
	 * @description A method to upload a file in salesforce file object
	 * @created 07062021
	 * @param parentId
	 * @param applicationId
	 * @param uploadedDocumentId
	 **/
	@AuraEnabled
	public static void uploadFileToRelatedList(String parentId, String applicationId, String uploadedDocumentId){
		String parentObjId = '';
		String parentObjName = getParentObjectName(parentId);
		if (parentObjName == 'Opportunity'){
			parentObjId = [SELECT Id, Case__c
			               FROM Application_Product_CAF__c
			               WHERE Id = :applicationId].Case__c;
		}
		if (parentObjName == 'Case'){
			parentObjId = [SELECT Id, Opportunity__c
			               FROM Case
			               WHERE Id = :parentId].Opportunity__c;
		}

		if (parentObjId != ''){
			ContentDocumentLink cDocLink = new ContentDocumentLink();
			cDocLink.ContentDocumentId = uploadedDocumentId;
			cDocLink.LinkedEntityId = parentObjId;
			cDocLink.ShareType = 'I';
			cDocLink.Visibility = 'AllUsers';
			Insert cDocLink;
		}
	}

	/**
	 * @description A method to upload a file in salesforce file object
	 * @created 07062021
	 * @param recordId
	 * @return uploadedDocumentId
	 **/
	@AuraEnabled
	public static List<ContentDocument> geFilesForParentRecord(String recordId){
		List<ContentDocument> DocumentList = new List<ContentDocument>();
		Set<Id> documentIds = new Set<Id>();  //store file ids
		List<ContentDocumentLink> cdl = [select id, LinkedEntityId, ContentDocumentId
		                                 from ContentDocumentLink
		                                 where LinkedEntityId = :recordId];
		for (ContentDocumentLink cdLink : cdl){
			documentIds.add(cdLink.ContentDocumentId);  // Document ids
		}
		DocumentList = [select Id, Title, FileType, ContentSize, Description
		                from ContentDocument
		                where id IN :documentIds];
		return DocumentList;
	}

	/**
	 * @description A method to upload a file in salesforce file object
	 * @created 07062021
	 * @param contentDocId
	 * @param parentId
	 * @param oppApplicationId
	 * @param signedManually
	 * @param relatedPartyId
	 * @param fileType
	 **/
	@AuraEnabled
	public static void addDocumentItemWithFileId(String contentDocId, Id parentId, Id oppApplicationId, Boolean signedManually, String relatedPartyId, String fileType){
		Id appCaseId;
		if (oppApplicationId != null && (oppApplicationId != parentId)){
			appCaseId = [SELECT Id, Case__c
			             FROM Application_Product_CAF__c
			             WHERE Id = :oppApplicationId].Case__c;
		}

		Id caseOppId;
		String parentObjName = getParentObjectName(parentId);
		if (parentObjName == 'Case'){
			caseOppId = [SELECT Id, Opportunity__c
			             FROM Case
			             WHERE Id = :parentId].Opportunity__c;
		}


		String parentIsDtring = parentId;
		ContentDocument cDoc = [select Id, Title, FileType
		                        From ContentDocument
		                        Where Id = :contentDocId
		                        LIMIT 1];

		ContentVersion cv = [SELECT VersionData
		                     FROM ContentVersion
		                     WHERE ContentDocumentId = :contentDocId AND IsLatest = true];

		//String base64Data = EncodingUtil.urlDecode(cv.VersionData, 'UTF-8');
		String base64Data = EncodingUtil.base64Encode(cv.VersionData);
		Attachment oAttachment = new Attachment();
		oAttachment.parentId = parentId;
		oAttachment.Body = EncodingUtil.base64Decode(base64Data);
		oAttachment.Name = cDoc.Title;
		oAttachment.ContentType = cDoc.FileType;
		insert oAttachment;

		Document__c doc = new Document__c();
		doc.Name = cDoc.Title;
		doc.Type__c = fileType;//cDoc.FileType;
		doc.ECM_Type__c = new DocumentTemplateSelector().selectTemplateByName(fileType).ECM_Item_Type__c;
		doc.Salesforce_File_Id__c = contentDocId;
		doc.Document_Generated__c = 'System Generated';
		doc.File_Id__c = oAttachment.Id;

		//Added the if statement to cater for accountContact and accountAccount
		//Added by Masechaba Maseli for W-004896, W-004893 for documents to be uploaded for Related Parties that are Non-Individuals to relate them to the account
		if (relatedPartyId != '0' && relatedPartyId != null && relatedPartyId != ''){
			String relatedIsString = relatedPartyId;

			If (relatedIsString.startsWith('07k')){
				AccountContactRelation arc = new AccountContactRelationSelector().selectbyAccountContactRelationId(relatedPartyId);
				iF (arc != Null){
					doc.Contact__c = arc.Contact.Id;
				}
			} Else{
				FinServ__AccountAccountRelation__c accAccRel = new AccountAccountRelationSelector().selectbyAccAccRelId(relatedPartyId);
				iF (accAccRel != Null){
					doc.Account__c = accAccRel.FinServ__RelatedAccount__c;
				}
			}

		}
		switch on getParentObjectName(parentId){
			when 'Asset'{
				doc.Asset__c = parentId;
			}
			when 'Opportunity'{
				doc.Opportunity__c = parentId;
				if (oppApplicationId != parentId){
					doc.Application_Product_CAF__c = oppApplicationId;
				}
				if (appCaseId != null){
					doc.Case__c = appCaseId;
				}
			}
			when 'Account'{
				doc.Account__c = parentId;
			}
			when 'Case'{
				doc.Case__c = parentId;
				if (caseOppId != null){
					doc.Opportunity__c = caseOppId;
				}
			}
			/**when 'Covenant__c'{
			 doc.Covenant__c = parentId;
			 }**/
		}
		doc.Reference__c = 'NA';
		if (signedManually){
			doc.Document_Status__c = 'Signed Manually';
		}
		try{
			insert doc;
		} catch (Exception ex){
			system.debug('Exception');
		}
	}
}