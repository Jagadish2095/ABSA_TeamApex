/**
 * @description       : Selector class for application security object
 * @author            : Gulafsha
 * @last modified on  : 2021-06-12
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-06-10   Gulafsha   Initial Version
**/


public class ApplicationSecuritySelector extends fflib_SObjectSelector {
    /**
    * @description 
    * @author Gulafsha | 2021-06-10 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType() {
        return Application_Security__c.sObjectType;
    }

    /**
    * @description getSObjectFieldSetList
    * @author Gulafsha | 2021-06-10 
    * @return List<Schema.FieldSet> 
    **/
    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>
        {
           null //SObjectType.Application_Security__c.FieldSets.Application_Security_Compact_View
        };
    }

    /**
    * @description getSObjectFieldList
    * @author Gulafsha | 2021-06-10 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Security__c.Id,
            Application_Security__c.ASV_MASV__c,
            Application_Security__c.ASV__c,
            Application_Security__c.Account_Balance__c,
            Application_Security__c.Account_Number__c,
            Application_Security__c.Amount__c,
            Application_Security__c.Application_Id_Text__c,
            Application_Security__c.Application__c,
            Application_Security__c.Bond_Type__c,
            Application_Security__c.Client_Code__c,
            Application_Security__c.Client_Name__c,
            Application_Security__c.Current_Net_Number_Debtors__c,
            Application_Security__c.Date_Analysis__c,
            Application_Security__c.Date_Signed__c,
            Application_Security__c.Description__c,
            Application_Security__c.Free_Surrender_Value__c,
            Application_Security__c.Hold_Indication__c,
            Application_Security__c.Holder_Code__c,
            Application_Security__c.Insurance_Company_Code__c,
            Application_Security__c.IsDeleted,
            Application_Security__c.LastModifiedDate,
            Application_Security__c.Limited_Surety__c,
            Application_Security__c.Limited_pledge__c,
            Application_Security__c.MASV__c,
            Application_Security__c.Name,
            Application_Security__c.Nominal_Value__c,
            Application_Security__c.Number_of_Shares__c,
            Application_Security__c.Pledger_Client_code__c,
            Application_Security__c.Pledgor_Client_Name__c,
            Application_Security__c.Policy_Number__c,
            Application_Security__c.Ranking_Number__c,
            Application_Security__c.Realistic_Market_Value__c,
            Application_Security__c.Reference_Account_Number__c,
            Application_Security__c.Registration_Number__c,
            Application_Security__c.Sec_Information_Code__c,
            Application_Security__c.Security_Type__c,
            Application_Security__c.Security_Value__c,
            Application_Security__c.Share_Name__c,
            Application_Security__c.Specific__c,
            Application_Security__c.Security_Offered__c,
            Application_Security__c.Status__c,
            Application_Security__c.Surety_Client_Code__c,
            Application_Security__c.Surety_Client_Name__c,
            Application_Security__c.SystemModstamp,
            Application_Security__c.Title_Deed_Number__c,
            Application_Security__c.X120_Days_Amount__c,
            Application_Security__c.X120_Days_Number_Debtors__c,
            Application_Security__c.X30_Days_Amount__c,
            Application_Security__c.X30_Days_Number_Debtors__c,
            Application_Security__c.X60_Days_Amount__c,
            Application_Security__c.X60_Days_Number_Debtors__c,
            Application_Security__c.X90_Days_Amount__c,
            Application_Security__c.X90_Days_Number_Debtors__c
        };
    }

    /**
    * @description 
    * @author Gulafsha | 2021-06-10 
    * @param idSet 
    * @return List<Application_Security__c> 
    **/
    public List<Application_Security__c> selectById(Set<ID> idSet) {
        return (List<Application_Security__c>) selectSObjectsById(idSet);
    }

    /**
    * @description 
    * @author Gulafsha | 2021-06-10 
    * @return String 
    **/
    public override String getOrderBy() {
        return 'CreatedDate ASC';
    }

    
    /**
    * @description selectByApplicationId
    * @author Gulafsha | 2021-06-10 
    * @param appId 
    * @return List<Application_Security__c> 
    **/
    public List<Application_Security__c> selectByApplicationId(String appId) {
        return (List<Application_Security__c>) Database.query(
            newQueryFactory().
            setCondition('Application_id_text__c = :appId').
            toSOQL()
        );
    }

    
    /**
    * @description selectByApplicationId And Security Type
    * @author Gulafsha | 2021-06-10 
    * @param appId 
    * @param securityType 
    * @return List<Application_Security__c> 
    **/
    public List<Application_Security__c> selectByApplicationIdAndSecType(String appId, String securityType) {
        return (List<Application_Security__c>) Database.query(
            newQueryFactory().
            setCondition('Application_id_text__c = :appId AND Security_Type__c =:securityType').
            toSOQL()
        );
    }
    
    /**
    * @description selectByApplicationIdAndSecTypefields
    * @author Gulafsha | 2021-06-10 
    * @param appId 
    * @param securityType 
    * @return List<Application_Security__c> 
    **/
    public List<Application_Security__c> selectByApplicationIdAndSecTypefields(String appId, String securityType) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
            selectField('Current_Net_Number_Debtors__c').
            selectField('Description__c').
            selectField('Date_Signed__c').
            selectField('Date_Analysis__c').
            selectField('Free_Surrender_Value__c').
            selectField('Holder_Code__c').
            selectField('Insurance_Company_Code__c').
            selectField('Limited_Surety__c').
            selectField('Limited_pledge__c').
            selectField('Number_of_Shares__c').
            selectField('Nominal_Value__c').
            selectField('Policy_Number__c').
            selectField('Pledger_Client_code__c').
            selectField('Ranking_Number__c').
            selectField('Realistic_Market_Value__c').
            selectField('Reference_Account_Number__c').
            selectField('Registration_Number__c').
            selectField('Title_Deed_Number__c').
            selectField('Security_Type__c').
            selectField('Specific__c').
            selectField('Status__c').
            selectField('Security_Value__c').
            selectField('Share_Name__c').
            selectField('Surety_Client_Name__c').
            selectField('Surety_Client_Code__c').
            selectField('Sec_Information_Code__c').
            selectField('X30_Days_Amount__c').
            selectField('X90_Days_Number_Debtors__c').
            selectField('X30_Days_Number_Debtors__c').
            selectField('X60_Days_Number_Debtors__c').
            selectField('X120_Days_Number_Debtors__c').
            selectField('X60_Days_Amount__c').
            selectField('X90_Days_Amount__c').
            selectField('X120_Days_Amount__c').
            selectField('Application_Id_Text__c').
            selectField('Security_Type__c').
            setCondition('Application_id_text__c = :appId AND Security_Type__c =:securityType').
            toSOQL()
        );
    }
    
    
    /**
    * @description selectByApplicationIdTextAndBondType
    * @author Gulafsha | 2021-06-10 
    * @param idSet 
    * @param bondType 
    * @return List<Application_Security__c> 
    **/
    public List<Application_Security__c> selectByApplicationIdTextAndBondType(Set<ID> idSet, String bondType){
		return Database.query(
            newQueryFactory().
            selectField('Application__c').
			selectField('Security_Type__c').
			selectField('Specific__c').
			selectField('Amount__c').
			selectField('ASV_MASV__c').
			selectField('Description__c').
			selectField('Status__c').
			selectField('Client_Code__c').
			selectField('Client_Name__c').
			selectField('Ranking_Number__c').
			selectField('Title_Deed_Number__c').
			selectField('Bond_Type__c').
			selectField('Realistic_Market_Value__c').
			selectField('Reference_Account_Number__c').
			selectField('Holder_Code__c').
			selectField('Registration_Number__c').
			selectField('Date_Signed__c').
			selectField('Security_Value__c').
            setCondition('Application__c IN:idSet AND Security_Type__c =: bondType').
            toSOQL()
        );
	}
    /**
    * @description selectByApplicationIdTextSet
    * @author Gulafsha | 2021-06-10 
    * @param idSet 
    * @return List<Application_Security__c> 
    **/
    public List<Application_Security__c> selectByApplicationIdTextSet(Set<ID> idSet){
		return Database.query(
            newQueryFactory().
            selectField('Application__c').
			selectField('Security_Type__c').
			selectField('Specific__c').
			selectField('Amount__c').
			selectField('ASV_MASV__c').
            selectField('MASV__c').
            selectField('ASV__c').
            selectField('Application_id_text__c').
			selectField('Description__c').
			selectField('Status__c').
			selectField('Client_Code__c').
			selectField('Client_Name__c').
			selectField('Ranking_Number__c').
			selectField('Title_Deed_Number__c').
			selectField('Bond_Type__c').
			selectField('Realistic_Market_Value__c').
			selectField('Reference_Account_Number__c').
			selectField('Holder_Code__c').
			selectField('Registration_Number__c').
			selectField('Date_Signed__c').
			selectField('Security_Value__c').
            setCondition('Application_id_text__c IN:idSet').
            toSOQL()
        );
	}
    	/**
    	* @description selectByApplicationIdTextSetReffAcc
    	* @author Gulafsha | 2021-06-10 
    	* @param idSet 
    	* @param refAcc 
    	* @return List<Application_Security__c> 
    	**/
    	public List<Application_Security__c> selectByApplicationIdTextSetReffAcc(Set<ID> idSet,String refAcc){
		return Database.query(
            newQueryFactory().
            selectField('Application__c').
			selectField('Security_Type__c').
			selectField('Specific__c').
			selectField('Amount__c').
			selectField('ASV_MASV__c').
            selectField('MASV__c').
            selectField('ASV__c').
            selectField('Application_id_text__c').
			selectField('Description__c').
			selectField('Status__c').
			selectField('Client_Code__c').
			selectField('Client_Name__c').
			selectField('Ranking_Number__c').
			selectField('Title_Deed_Number__c').
			selectField('Bond_Type__c').
			selectField('Realistic_Market_Value__c').
			selectField('Reference_Account_Number__c').
			selectField('Holder_Code__c').
			selectField('Registration_Number__c').
			selectField('Date_Signed__c').
			selectField('Security_Value__c').
            setCondition('Application_id_text__c IN:idSet AND Reference_Account_Number__c=:refAcc').
            toSOQL()
        );
	}
    
        /**
        * @description selectBySecurityOfferedId
        * @author Gulafsha | 2021-06-10 
        * @param secId 
        * @return List<Application_Security__c> 
        **/
        public List<Application_Security__c> selectBySecurityOfferedId(Id secId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
            selectField('Current_Net_Number_Debtors__c').
            selectField('Description__c').
            selectField('Date_Signed__c').
            selectField('Date_Analysis__c').
            selectField('Free_Surrender_Value__c').
            selectField('Holder_Code__c').
            selectField('Insurance_Company_Code__c').
            selectField('Limited_Surety__c').
            selectField('Limited_pledge__c').
            selectField('Number_of_Shares__c').
            selectField('Nominal_Value__c').
            selectField('Policy_Number__c').
            selectField('Pledger_Client_code__c').
            selectField('Ranking_Number__c').
            selectField('Realistic_Market_Value__c').
            selectField('Reference_Account_Number__c').
            selectField('Registration_Number__c').
            selectField('Title_Deed_Number__c').
            selectField('Security_Type__c').
            selectField('Specific__c').
            selectField('Status__c').
            selectField('Security_Value__c').
            selectField('Share_Name__c').
            selectField('Surety_Client_Name__c').
            selectField('Surety_Client_Code__c').
            selectField('Sec_Information_Code__c').
            selectField('X30_Days_Amount__c').
            selectField('X90_Days_Number_Debtors__c').
            selectField('X30_Days_Number_Debtors__c').
            selectField('X60_Days_Number_Debtors__c').
            selectField('X120_Days_Number_Debtors__c').
            selectField('X60_Days_Amount__c').
            selectField('X90_Days_Amount__c').
            selectField('X120_Days_Amount__c').
            selectField('Application_Id_Text__c').
            selectField('Security_Type__c').
            setCondition('Security_Offered__c = :secId').
            toSOQL()
        );
    }
}