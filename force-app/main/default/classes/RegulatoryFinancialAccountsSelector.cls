/**
 * @description       : Selector Layer for Regulatory_Financial_Account__c objects
 * @author            : Tracy de Bruin - CloudSmiths
 * @last modified on  : 2021-11-09
 * @last modified by  : Tracy de Bruin - CloudSmiths
**/
public class RegulatoryFinancialAccountsSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    /**
	 * @description MANDATORY ABSTRACT METHODS - START
	 * @return Schema.SObjectType
	 */
    public Schema.SObjectType getSObjectType(){
        return Regulatory_Financial_Account__c.sObjectType;
    }
    /**
	 * @description getSObjectFieldList
	 * @return List<Schema.SObjectField>
	 */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Regulatory_Financial_Account__c.Id,
                Regulatory_Financial_Account__c.Name,
                Regulatory_Financial_Account__c.Account__c,
                Regulatory_Financial_Account__c.Product__c,
                Regulatory_Financial_Account__c.Product_Type__c,
                Regulatory_Financial_Account__c.Account_Number__c,
                Regulatory_Financial_Account__c.Branch__c,
                Regulatory_Financial_Account__c.Status__c,
                Regulatory_Financial_Account__c.Account_Activity_Calculator__c,
                Regulatory_Financial_Account__c.Purpose_of_Account__c,
                Regulatory_Financial_Account__c.Source_of_Funds__c,
                Regulatory_Financial_Account__c.Credits_Received_via_EFT_Cash_etc__c,
                Regulatory_Financial_Account__c.Expected_Number_of_Credits_per_Month__c,
                Regulatory_Financial_Account__c.Number_of_Staff_Members__c,
                Regulatory_Financial_Account__c.Payment_Date_of_Staff__c,
                Regulatory_Financial_Account__c.Rand_Value_of_Credits_per_Month__c,
                Regulatory_Financial_Account__c.Reason_for_Debit_Orders__c,
                Regulatory_Financial_Account__c.Where_are_the_Suppliers_Located__c,
                Regulatory_Financial_Account__c.Where_will_the_Credits_be_Coming_from__c,
                Regulatory_Financial_Account__c.Purpose_of_Account_Text__c
                };
                    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //get Regulatory_Financial_Account__c by id's 
    /**
	 * @description Return Financial Accounts by Id Number
	 *
	 * @param idSet 
	 * @return List<Regulatory_Financial_Account__c>
	 */
    public List<Regulatory_Financial_Account__c> selectById(Set<Id> idSet) {
        return (List<Regulatory_Financial_Account__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END
    
    /**
* PJAIN: 20200422
*/
    /**
	 * @description Return Financial Accounts by Id Number
	 *
	 * @param accountId 
	 * @return List<Regulatory_Financial_Account__c>
	 */
    public List<Regulatory_Financial_Account__c> selectByAccountId(Id accountId) {
        
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Account_Activity_Calculator__c'). //By Mohammed Junaid U
            selectField('Purpose_of_Account__c'). //By Mohammed Junaid U
            selectField('Source_of_Funds__c'). //By Mohammed Junaid U
            selectField('Account_Number__c'). //By Mohammed Junaid U
            selectField('Product_Type__c'). //By Mohammed Junaid U
            setCondition('Account__c =: accountId').
            addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
            toSOQL()
        );
    }
    
}