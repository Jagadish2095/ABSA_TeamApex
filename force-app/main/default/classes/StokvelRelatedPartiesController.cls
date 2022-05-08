/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-10-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-12-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/

/**
 * @description createStokvelRelationship
 * @return String
 * @param relatedAccountId
 * @param primaryEntityId
 */

public without sharing class StokvelRelatedPartiesController 
{
	@AuraEnabled
	/**
	 * @description createStokvelRelationship
	 * @return String
	 * @param relatedAccountId
	 * @param primaryEntityId
	 */
	public static String createStokvelRelationship(string relatedAccountId, string primaryEntityId) {
		List<Account> accnList = new AccountsSelector().selectCasaFieldsById(relatedAccountId, 1);

		if (!accnList.isEmpty()) {
			List<AccountContactRelation> acrList = [
				SELECT Id, AccountId, ContactId, Primary_Entity_Id__c
				FROM AccountContactRelation
				WHERE AccountId = :primaryEntityId AND ContactId = :accnList.get(0).PersonContactId AND Primary_Entity_Id__c = :primaryEntityId
				WITH SECURITY_ENFORCED
				LIMIT 1
			];

			if (acrList != null && acrList.size() != 0) {
				//ACR Already Exists
				return 'ERROR This Related Party is already linked to the Stokvel Entity, AccountContactRelation Exists. ';
			} else {
				AccountContactRelation acr = new AccountContactRelation();
				if (
					AccountContactRelation.SObjectType.getDescribe().isCreateable() &&
					Schema.SObjectType.AccountContactRelation.fields.AccountId.isCreateable() &&
					Schema.SObjectType.AccountContactRelation.fields.ContactId.isCreateable() &&
					Schema.SObjectType.AccountContactRelation.fields.Primary_Entity_Id__c.isCreateable()
				) {
					acr.AccountId = primaryEntityId;
					acr.ContactId = accnList.get(0).PersonContactId;
					acr.Primary_Entity_Id__c = primaryEntityId;
					try {
						insert acr;
						return 'SUCCESS';
					} catch (DmlException e) {
						//System.debug('An unexpected error has occurred createStokvelRelationship: ' + e.getMessage());
						return 'ERROR ' + e.getMessage() + ' .' + +e.getStackTraceString();
					}
					//  return 'SUCCESS';
				}
				return 'SUCCESS';
			}
		} else {
			return 'ERROR Unable to find account by Id: ' + relatedAccountId;
		}
	}

	/**
	 * @description createStokvelRelationship
	 *  @param selectedAccount
	 * @return string
	 * */
	@AuraEnabled
	public static string updateAccountInfo(Account selectedAccount) {
		String gender = BranchCIFSalesforceSyncHelper.getGenderfromId(selectedAccount.ID_Number__pc);

		Account newaccount = new Account();
		newaccount.ID_Type__pc = 'SA Identity Document';
		newaccount.Client_Type__c = selectedAccount.Client_Type__c;
		newaccount.Gender__pc = gender;
		newaccount.Client_Type__c = 'INDIVIDUAL';
		newaccount.FirstName = selectedAccount.FirstName;
		newaccount.LastName = selectedAccount.LastName;
		newaccount.ID_Number__pc = selectedAccount.ID_Number__pc;
		newaccount.PersonEmail = selectedAccount.PersonEmail;
		newaccount.PersonHomePhone = selectedAccount.PersonHomePhone;
		newaccount.PersonMobilePhone = selectedAccount.PersonMobilePhone;

		newaccount.PersonBirthdate = BranchCIFSalesforceSyncHelper.getBirthdayDateFromId(selectedAccount.ID_Number__pc);
		newaccount.Phone = selectedAccount.Phone;
		newaccount.CIF__c = selectedAccount.CIF__c;
		newaccount.Communication_Method__c = selectedAccount.Communication_Method__c;
		newaccount.Salutation = selectedAccount.Salutation;
		insert newaccount;

		return newaccount.ID;
	}

	/**
	 * @description createStokvelRelationship
	 *  @param accountId
	 * @param IdNumber
	 * */
	@AuraEnabled
	public static Void updateAccountDetails(Id accountId, string IdNumber) {
		String Acounttid = BranchCIFSalesforceSyncHelper.UpdateAccountwithCIF(accountId, '', IdNumber);
		
	
		Account accountrelatedParty = [SELECT Id, Gender__pc, ID_Number__pc FROM Account WHERE Id = :Acounttid WITH SECURITY_ENFORCED];
		accountrelatedParty.PersonBirthdate = BranchCIFSalesforceSyncHelper.getBirthdayDateFromId(accountrelatedParty.ID_Number__pc);
		accountrelatedParty.ID_Type__pc = 'SA Identity Document';	
		accountrelatedParty.Gender__pc = BranchCIFSalesforceSyncHelper.getGenderfromId(accountrelatedParty.ID_Number__pc);	
		accountrelatedParty.Valid_Update_Bypass__c = true;
		update accountrelatedParty;
		
	}
	/**
	 * @description createStokvelRelationship
	 *  @param accId
	 *  @param IdNumber
	 *
	@AuraEnabled
	public static Void updateCIFDetails(Id accId, string IdNumber) {
		
		BranchCIFSalesforceSyncHelper.UpdateAccountwithCIF(accId, '', IdNumber);
	} */
}