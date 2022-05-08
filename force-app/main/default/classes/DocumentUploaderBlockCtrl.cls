/**
 * @description       : For the component to display and upload  documents and details for Covid-19
 * @author            : Almas Aleem
 * @last modified on  : 2021-06-14
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12    Aleem   Initial Version
 **/

public class DocumentUploaderBlockCtrl {
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param oppId
	 * @param docType
	 * @return Document__c
	 **/
	@AuraEnabled
	public static Document__c getExistDocument(Id oppId, String docType) {
		Id documentId;
		Document__c doc;
		List<Document__c> docList;
		List<Document__c> docCaseList;

		String sObjName = oppId.getSObjectType().getDescribe().getName();
		if (sObjName.equalsIgnoreCase('Opportunity')) {
			docList = [SELECT Id, File_Id__c FROM Document__c WHERE opportunity__c = :oppId AND Type__c = :docType ORDER BY createddate DESC];
			system.debug('docList' + docList);
		} else {
			docCaseList = [SELECT Id, File_Id__c FROM Document__c WHERE case__c = :oppId AND Type__c = :docType ORDER BY createddate DESC];
			system.debug('docCaseList' + docCaseList);
		}

		if (docList != null) {
			doc = docList[0];
			documentId = docList[0].Id;
		}
		if (docCaseList != null) {
			doc = docCaseList[0];
			documentId = docCaseList[0].Id;
		}
		return doc;
	}

	/**
	 * @description commented this code as the try should be empty error was coming in PMD
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param oppId
	 * @param docType
	 * @param docId
	 **/
	@AuraEnabled
	public static void deleteExistDocument(Id oppId, String docType, Id docId) {
		Document__c doc = [SELECT Id FROM Document__c WHERE Id = :docId];
		try {
			//delete doc;
			system.debug('###');
		} catch (Exception e) {
			system.debug('exception--' + e.getLineNumber() + '----' + e.getCause());
		}
	}

	/**
	 * @description Method that gets a list of all documents metadata
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @return List<Document_Template__c>
	 **/
	@AuraEnabled
	public static List<Document_Template__c> getDocumentMetadata() {
		List<Document_Template__c> documentTemplates = new DocumentTemplateSelector().getAllDocumentTemplates();
		return documentTemplates;
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
	 * @param signedManually
	 * @param relatedPartyId
	 * @return fileId Id of file updated or saved.
	 *
	 * @modified 2019-06-14 by Robert McLean.
	 * @Change description Added document type to parameters to be used with the completeUpload method.
	 **/
	@AuraEnabled
	public static Id saveChunk(
		Id parentId,
		String fileName,
		String base64Data,
		String contentType,
		String fileId,
		Boolean done,
		String documentType,
		Boolean signedManually,
		String relatedPartyId
	) {
		return DocumentController.saveChunk(parentId, fileName, base64Data, contentType, fileId, done, documentType, signedManually, relatedPartyId);
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param oppId
	 * @return List<Opportunity>
	 **/
	@AuraEnabled
	public static List<Opportunity> getWebsiteURL(Id oppId) {
		return new OpportunitiesSelector().selectByOpportunityId(oppId);
	}

	/**
	 * @description Update the respective URL field
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param oppId
	 * @param objectApiName
	 * @param editedRecords
	 * @param urlField
	 * @return boolean
	 **/
	@AuraEnabled
	public static boolean updateURLs(id oppId, String objectApiName, Map<String, String> editedRecords, string urlField) {
		Boolean rtnVal = false;
		if (objectApiName == 'Opportunity') {
			String urlValue = editedRecords.get(urlField);
			if (urlValue == '' || urlValue == null)
				return false;
			Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
			opp.put(urlField, urlValue);
			try {
				update opp;
				rtnVal = true;
			} catch (DMLException ex) {
				System.debug(ex.getMessage());
				throw new AuraHandledException(ex.getMessage());
			} catch (Exception ex) {
				//throw all other exception message
				System.debug('There was an error updating the URL on the Opportunity - ' + ex.getMessage());
				throw new AuraHandledException(ex.getMessage());
			}
		}
		return rtnVal;
	}
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param documentId
	 * @return String
	 **/
	@AuraEnabled
	public static String getDocumentContent(Id documentId) {
		System.debug('***DOCUMENT ID: ' + documentId);
		//Document__c doc = [SELECT Id, Reference__c From Document__c WHERE Id =: documentId];
		List<Document__c> docContentList = new DocumentsSelector().selectByDocId(documentId);

		ECM_LoginResult_IB_V1 login = ECMLogin();
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, docContentList[0].Reference__c);

		if (getResult.Content != null) {
			return getResult.Content.data;
		} else {
			return 'ECM returned no results.';
		}
	}
	/**
	 * @description ECMLogin
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @return ECM_LoginResult_IB_V1
	 **/
	public static ECM_LoginResult_IB_V1 ECMLogin() {
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		return login;
	}
}