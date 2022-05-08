/**
 * @description getRelatedPartyDetails
 * @author Happy Baloyi
 * */

public with sharing class RelatedPartyAuthorityController {
	public static Account acc;
	public static Opportunity opp;
	public static OpportunityLineItem opportunityLineItem;
	/**
	 * @description getRelatedPartyDetails
	 * @author Happy Baloyi
	 * @param oppId
	 *  @return List<SObject>
	 **/

	@AuraEnabled
	public static List<ACRWrapper> getRelatedPartiesDetails(String oppId) {
		acc = new AccountsSelector().selectByOpportunityId(oppId);

		List<AccountContactRelation> aclist = AccountContactController.getRelatedAccounts(acc.ID);

		List<ACRWrapper> wrapperList = new List<ACRWrapper>();

		for (AccountContactRelation acr : aclist) {
			ACRWrapper wrapper = new ACRWrapper();
			wrapper.accountId = acr.Id;
			wrapper.contactName = acr.Contact.FirstName + ' ' + acr.Contact.LastName;
			wrapper.contactIdNumber = acr.Contact.ID_Number__c;
			wrapper.accountMandatorySignatory = acr.Control_of_Passive_Non_Financial_Entity__c;
			wrapper.contactController = acr.Controlling_Person_is_Taxed_Outside__c;
			wrapper.accountCIF = acr.Contact.CIF__c; //acr.Contact.CIF__c;
			wrapper.accountCASA = acr.Contact.CASA_Reference_Number__c;

			wrapperList.add(wrapper);
		}

		return wrapperList;
	}

	/**
	 * @description createStokvelRelationship
	 *
	 * @return ProductContactSignatoryRelationship__c
	 * @param acr
	 * @param primaryAccountId
	 * @param opportunityLineItemID
	 *  @param specialInstruction
	 * @param count
	 * @param prodname
	 *
	 */
	@AuraEnabled
	public static ProductContactSignatoryRelationship__c insertIntoProductContactRelationship(
		ACRWrapper acr,
		string primaryAccountId,
		string opportunityLineItemID,
		string specialInstruction,
		string count,
		string prodname
	) {
		if (count.toLowerCase() == 'vari') {
			count = 'Special Instruction';
		}
     
		ProductContactSignatoryRelationship__c productsignatoory = new ProductContactSignatoryRelationship__c();
		productsignatoory.PrimaryAccountId__c = acc.ID;
		productsignatoory.AccountContactRelationshipId__c = acr.accountId;
		productsignatoory.OpportunityProductId__c = opportunityLineItemID;
		productsignatoory.Special_Instruction__c = specialInstruction;
		productsignatoory.SigningAuthorityFromDate__c = Date.today();
		productsignatoory.Number_of_Signatories_for_account__c = count;
		productsignatoory.Product_Name__c = prodname;
		productsignatoory.Signing_Purpose__c = 'AccountMaintenance';
		productsignatoory.Signing_Instructions__c = 'Any "A" and one "B" to sign together';
		if (acr.accountMandatorySignatory == true) {
			productsignatoory.Compulsory_Signature__c = 'Yes';
		} else {
			productsignatoory.Compulsory_Signature__c = 'No';
		}
		return productsignatoory;
	}
	/**
	 * @description createStokvelRelationship
	 *
	 * @return String
	 * @param relatedParties
	 * @param opportunityID
	 * @param specialInstruction
	 * @param signatoryCount
	 *
	 */
	@AuraEnabled
	public static string createProductContactRelation(String relatedParties, String opportunityID, string specialInstruction, string signatoryCount) {
		List<ProductContactSignatoryRelationship__c> updateProductContactSinatory = new List<ProductContactSignatoryRelationship__c>();
		List<ProductContactSignatoryRelationship__c> insertProductContactSinatory = new List<ProductContactSignatoryRelationship__c>();
		//	acc = new AccountsSelector().selectByOpportunityId(opportunityID);
		Opportunity opportuty = [SELECT AccountId FROM OPPORTUNITY WHERE id = :opportunityID LIMIT 1];
		acc = [SELECT Id FROM Account WHERE id = :opportuty.AccountId LIMIT 1];

		opportunityLineItem = [
			SELECT ID, ProductCode, Product2Id, Product_Name__c, Policy_Number__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityID AND Product_Family__c = 'Savings'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		if (
			ProductContactSignatoryRelationship__c.SObjectType.getDescribe().isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.PrimaryAccountId__c.isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.AccountContactRelationshipId__c.isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.OpportunityProductId__c.isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.Signing_Instructions__c.isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.Number_of_Signatories_for_account__c.isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.Product_Name__c.isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.Name.isCreateable() &&
			Schema.SObjectType.ProductContactSignatoryRelationship__c.fields.Compulsory_Signature__c.isCreateable()
		) {
			List<ACRWrapper> relatedauthdetails = (List<ACRWrapper>) JSON.deserialize(relatedParties, List<ACRWrapper>.class);

			for (ACRWrapper acr : relatedauthdetails) {
				if (checkifProductContactRelationshipExist(acr.accountId, acc.ID, opportunityLineItem.Id) == '0') {
					insertProductContactSinatory.add(
						insertIntoProductContactRelationship(
							acr,
							acc.ID,
							opportunityLineItem.Id,
							specialInstruction,
							signatoryCount,
							opportunityLineItem.Product_Name__c
						)
					);
				}
				else {					
					updateProductContactSinatory.add(
						updateProductContactRelationship(
							acr.accountId, acc.ID, opportunityLineItem.Id, specialInstruction,signatoryCount)
						)	;
				}
			}
			if(insertProductContactSinatory.size() > 0)
			{			
		    	insert insertProductContactSinatory;
			}

			if(updateProductContactSinatory.size() > 0)
			{			
		    	update updateProductContactSinatory;
			}
			//createRelatedPartiesAuth(relatedauthdetails,opportunityID,  specialInstruction, opportunityLineItem.Policy_Number__c);
			return 'Success';
		} else {
			return 'ERROR';
		}
	}

	/**
	 * @description createRelatedPartiesAuth
	 *
	 * @return CIupdAuthV20API_Resp_IB_v1
	 * @param relatedParties
	 * @param opportunityID
	 * @param specialInstruction
	 * @param signatoryCount
	 */
	@AuraEnabled
	public static string createRelatedPartiesAuth(string relatedParties, String opportunityID, string specialInstruction, string signatoryCount) {
		List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		List<ACRWrapper> relatedauthdetails = (List<ACRWrapper>) JSON.deserialize(relatedParties, List<ACRWrapper>.class);
		acc = new AccountsSelector().selectByOpportunityId(opportunityID);

		opportunityLineItem = [
			SELECT ID, Policy_Number__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityID AND Product_Family__c = 'Savings'
			WITH SECURITY_ENFORCED
			LIMIT 1
		];

		String relatedpartcnt = String.valueOf(signatoryCount).leftPad(4, '0');

		Account accnt = [SELECT ID, CIF__c FROM ACCOUNT WHERE Id = :acc.ID WITH SECURITY_ENFORCED LIMIT 1];

		CIupdtAuthV20API_Req_IB_v1 requestBean = new CIupdtAuthV20API_Req_IB_v1();
		requestBean.inputHeaders = new CIupdtAuthV20API_Req_IB_v1.InputHeaders();
		requestBean.inputHeaders.NBSAPLI = new CIupdtAuthV20API_Req_IB_v1.NBSAPLI();

		requestBean.inputMessageHeader = new CIupdtAuthV20API_Req_IB_v1.InputMessageHeader();
		requestBean.inputMessageHeader.inputMessage = new CIupdtAuthV20API_Req_IB_v1.InputMessage();
		requestBean.CIupdAuthV20Request = new CIupdtAuthV20API_Req_IB_v1.CIupdAuthV20Request();
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData = new CIupdtAuthV20API_Req_IB_v1.CIupdAuthV20RequestInputData();
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.primaryCifKey = accnt.CIF__c;

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.accountNumber = long.valueOf(opportunityLineItem.Policy_Number__c);

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.siteCode = integer.valueOf(userRec[0].SiteCode__c);

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.tellerNumber = integer.valueOf(userRec[0].Teller_Operator_Code__c);
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.supervisorOverride = 0;

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.authType = 'M';

		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.numberOfSignatories = relatedpartcnt;
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.specialConditions = specialInstruction;
		requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.inputTableData = new List<CIupdtAuthV20API_Req_IB_v1.InputTableData>();

		requestBean.inputHeaders.NBSAPLI.consumerChannel = 'BRANCH';
		requestBean.inputHeaders.NBSAPLI.providerApplication = 'ASP';
		requestBean.inputHeaders.NBSAPLI.trace = 'N';

		requestBean.inputMessageHeader.inputMessage.messageLanguage = 'E';
		requestBean.inputMessageHeader.inputMessage.messageTarget = 'STD';
		for (ACRWrapper acr : relatedauthdetails) {
			CIupdtAuthV20API_Req_IB_v1.InputTableData inputData = new CIupdtAuthV20API_Req_IB_v1.InputTableData();
			if (acr.accountMandatorySignatory == true) {
				inputData.compulsorySignatory = 'Y';
			} else {
				inputData.compulsorySignatory = 'N';
			}
			if (acr.contactController == true) {
				inputData.designation = 21;
			} else {
				inputData.designation = 16;
			}

			inputData.updateOption = 'N';

			inputData.signatoryCifKey = acr.accountCIF;
			inputData.updateOption = 'N';
			inputData.signatoryCasaNumber = integer.valueOf(acr.accountCASA);
			requestBean.CIupdAuthV20Request.CIupdAuthV20RequestInputData.inputTableData.add(inputData);
		}

		String requestBeanBeanobj = JSON.serializePretty(requestBean);
		//	System.debug('requestBeanBeanobj ' + requestBeanBeanobj);
		string returnmessage = 'sucess';
		string authexist = checkifAuthExist(opportunityLineItem.Policy_Number__c, userRec[0].SiteCode__c, '5');
		if (String.isBlank(authexist)) {
			CIupdAuthV20API_Resp_IB_v1 responseBean = CIupdAuthV20API_IH_v1.ciauthRelateParties(requestBean);
			String responseBeanobj = JSON.serializePretty(responseBean);
			//System.debug('responseBeanobj ' + responseBeanobj);

			if (
				responseBean != null &&
				(responseBean.outputMessageHeader != null) &&
				(responseBean.outputMessageHeader.outputErrorMessage != null) &&
				(responseBean.outputMessageHeader.outputErrorMessage.numberUserErrors > 0)
			) {
				returnmessage = 'Error' + ' ';
				//	for (var i : responseBean.outputMessageHeader.outputErrorMessage.numberUserErrors) {
				if (responseBean.outputMessageHeader.outputErrorMessage.messageEntry[0].messageText != '') {
					returnmessage += responseBean.outputMessageHeader.outputErrorMessage.messageEntry[0].messageText + ' ';
				}
				//	}
			}
		}

		return returnmessage; //responseBean;
	}
	/**
	 * @description checkifAuthExist
	 *
	 * @return checkifAuthExist
	 * @param accountNumber
	 * @param siteCode
	 * @param maxRetrieve
	 *
	 */
	@AuraEnabled
	public static string checkifAuthExist(String accountNumber, String siteCode, String maxRetrieve) {
		CIgetSigningInstructionsV4_Resp_IB_v2 ciAuthResponseBean = CIgetSigningInstructionsV4_IH_v1.CIgetAllSigningInstructionsV4(
			accountNumber,
			siteCode,
			maxRetrieve
		);
		string responsemsg = '';

		//CIgetSigningInstructionsV4_Resp_IB_v1 ciAuthResponseBean = ciAuthDetails[0];
		//System.debug('AWWr ' + json.serializePretty(ciAuthResponseBean));
		if (ciAuthResponseBean != null) {
			if (
				(ciAuthResponseBean != null) &&
				(ciAuthResponseBean.CIgetSigningInstructionsV4Response != null) &&
				(ciAuthResponseBean.CIgetSigningInstructionsV4Response.nbsmsgo3 != null) &&
				(ciAuthResponseBean.CIgetSigningInstructionsV4Response.cip082do.nbrSignReqOperAcc != null)
			) {
				responsemsg = ciAuthResponseBean.CIgetSigningInstructionsV4Response.cip082do.nbrSignReqOperAcc;
			}
		}
		return responsemsg;
	}

	/**
	 * @description createStokvelRelationship
	 *
	 * @return ProductContactSignatoryRelationship__c
	 * @param relatedpartyId
	 * @param primaryAccountId
	 * @param opportunityLineItemID
	 *
	 */
	@AuraEnabled
	public static string checkifProductContactRelationshipExist(string relatedpartyId, string primaryAccountId, string opportunityLineItemID) {
		string productcontactrelation = '';
		List<ProductContactSignatoryRelationship__c> productsignatoryList = [
			SELECT Id, PrimaryAccountId__c, AccountContactRelationshipId__c, OpportunityProductId__c
			FROM ProductContactSignatoryRelationship__c
			WHERE
				PrimaryAccountId__c = :primaryAccountId
				AND AccountContactRelationshipId__c = :relatedpartyId
				AND OpportunityProductId__c = :opportunityLineItemID
			WITH SECURITY_ENFORCED
		];
		if (productsignatoryList != null && productsignatoryList.size() != 0) {
			productcontactrelation = string.valueOf(productsignatoryList.size());
		} else {
			productcontactrelation = '0';
		}
		return productcontactrelation;
	}

	/**
	 * @description UPDATEStokvelRelationship
	 *
	 * @return ProductContactSignatoryRelationship__c
	 * @param relatedpartyId
	 * @param primaryAccountId
	 * @param opportunityLineItemID
	 * @param  specialInstruction
	 * @param  count
	 */
	@AuraEnabled
	public static ProductContactSignatoryRelationship__c updateProductContactRelationship(string relatedpartyId, string primaryAccountId, string opportunityLineItemID, string specialInstruction,string count) {
		string productcontactrelation = '';
		ProductContactSignatoryRelationship__c productsignatory = [
			SELECT Id, PrimaryAccountId__c, AccountContactRelationshipId__c, OpportunityProductId__c
			,Special_Instruction__c,Number_of_Signatories_for_account__c
			FROM ProductContactSignatoryRelationship__c
			WHERE
				PrimaryAccountId__c = :primaryAccountId
				AND AccountContactRelationshipId__c = :relatedpartyId
				AND OpportunityProductId__c = :opportunityLineItemID
			WITH SECURITY_ENFORCED
		];
		productsignatory.Special_Instruction__c = specialInstruction;
        if (count.toLowerCase() == 'vari') {
			count = 'Special Instruction';
		}
        productsignatory.Number_of_Signatories_for_account__c = count;
		
		return productsignatory;
	}
	/**
	 * @description ACRWrapper Description
	 */
	@TestVisible
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
}