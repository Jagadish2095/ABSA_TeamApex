/**
 * @description       : Absa_Listed_Beneficiaries__c Selector
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-28
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public with sharing class AbsaBeneficiarySelector extends fflib_SObjectSelector {
    
	
	/**
	* @description Default constructor
	* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28
	**/
	public AbsaBeneficiarySelector() {

    }

    /**
    * @description Gets object type
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28
    * @return Schema.SObjectType
    **/
    public Schema.SObjectType getSObjectType() {
		return Absa_Listed_Beneficiaries__c.sObjectType;
	}

    /**
    * @description Get field list
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28
    * @return List<Schema.SObjectField>
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField>{
			Absa_Listed_Beneficiaries__c.Id,
			Absa_Listed_Beneficiaries__c.AccountId__c,
			Absa_Listed_Beneficiaries__c.Beneficiary_Account_Number__c,
			Absa_Listed_Beneficiaries__c.Beneficiary_Cellphone_Number__c,
			Absa_Listed_Beneficiaries__c.Name,
			Absa_Listed_Beneficiaries__c.Beneficiary_Service_Provider__c,
			Absa_Listed_Beneficiaries__c.BranchCode__c,
			Absa_Listed_Beneficiaries__c.CreatedById,
			Absa_Listed_Beneficiaries__c.CurrencyIsoCode,
			Absa_Listed_Beneficiaries__c.LastModifiedById,
			Absa_Listed_Beneficiaries__c.Own_Reference__c,
			Absa_Listed_Beneficiaries__c.OwnerId,
			Absa_Listed_Beneficiaries__c.Recipient_Reference__c,
			Absa_Listed_Beneficiaries__c.Sequence_Number__c,
			Absa_Listed_Beneficiaries__c.Status__c,
			Absa_Listed_Beneficiaries__c.Beneficiary_Account_Type__c,
			Absa_Listed_Beneficiaries__c.Beneficiary_Bank_Name__c


        };
    }

	/**
	 * @description Return AccountsBeneficiaried by Account ID
	 *
	 * @param accountId String
	 * @param recordLimit String max records to return
	 * @return List<Account>
	 */
	public List<Absa_Listed_Beneficiaries__c> selectByAccountID(String accountId, Integer recordLimit) {
		return (List<Absa_Listed_Beneficiaries__c>) Database.query(
			newQueryFactory()
				.selectField('Id')
				.selectField('AccountId__c')
				.selectField('Beneficiary_Account_Number__c')
				.selectField('Beneficiary_Cellphone_Number__c')
				.selectField('Name')
				.selectField('Beneficiary_Service_Provider__c')
				.selectField('BranchCode__c')
				.selectField('CreatedById')
				.selectField('CurrencyIsoCode')
				.selectField('LastModifiedById')
				.selectField('Own_Reference__c')
				.selectField('OwnerId')
				.selectField('Recipient_Reference__c')
				.selectField('Sequence_Number__c')
				.selectField('Status__c')
				// .selectField('Sequence_Number__c')
				// .selectField('Sequence_Number__c')
				.setCondition('AccountId__c =: accountId')
				.setLimit(recordLimit)
				.toSOQL()
		);
	}
}