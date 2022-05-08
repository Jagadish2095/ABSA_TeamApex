/**
 * @description       : Selector Layer for Payment_Plan__c objects
 * @author            : Vladimir Panajic|2019-01-17
**/
public class PaymentPlansSelector extends fflib_SObjectSelector {

    /**
    * @description MANDATORY ABSTRACT METHODS
    * @return Schema.SObjectType
    **/
    public Schema.SObjectType getSObjectType() {
        return Payment_Plan__c.sObjectType;
    }
    /**
    * @description getSObjectFieldList
    * @return List<Schema.SObjectField>
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Payment_Plan__c.Id,
                Payment_Plan__c.Account_Number__c,
                Payment_Plan__c.Account_Type__c,
                Payment_Plan__c.Amount__c,
                Payment_Plan__c.Bank_Name__c,
                Payment_Plan__c.Branch_Code__c,
                Payment_Plan__c.Branch_Name__c,
                Payment_Plan__c.CreatedById,
                Payment_Plan__c.CurrencyIsoCode,
                Payment_Plan__c.Debit_Order_Commencement_Date__c,
                Payment_Plan__c.Debit_Order_Debit_Day__c,
                Payment_Plan__c.Debit_Order_Salary_Day__c,
	            Payment_Plan__c.Frequency__c,
                Payment_Plan__c.Application__c,
                Payment_Plan__c.LastModifiedById,
                Payment_Plan__c.OwnerId,
                Payment_Plan__c.Method__c,
                Payment_Plan__c.Name,
                Payment_Plan__c.Reference__c,
                Payment_Plan__c.Status__c,
                Payment_Plan__c.Third_Party__c,
                Payment_Plan__c.Type__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END
    //CUSTOM SELECTORS - START
   /**
   * @description selectById
   * @param searchValue1 OpportunityId
   * @param recordLimit max records to return
   * @return List<Payment_Plan__c>
   **/
   public List<Payment_Plan__c> selectById (Id searchValue1, Integer recordLimit) {
       return (List<Payment_Plan__c>) Database.query (
           	newQueryFactory().
            selectField('Id').
            selectField('Account_Number__c').
            selectField('Account_Type__c').
            selectField('Bank_Name__c').
            selectField('Branch_Code__c').
            selectField('Branch_Name__c').
            selectField('Debit_Order_Debit_Day__c').
            selectField('Debit_Order_Commencement_Date__c').
            selectField('Frequency__c').
            selectField('Method__c').
            selectField('Status__c').
            selectField('Third_Party__c').
           	selectField('Application__c').
           	selectField('Type__c').
           	selectField('Fee_Code__c').
            selectField('Once_Off_Payment_Required__c').//Added By Himani Joshi
            selectField('Target_Account__c').//Added By Himani Joshi
            selectField('Target_Account_Type__c').//Added By Himani Joshi
            selectField('Target_Clearance_Code__c').//Added By Himani Joshi
            selectField('Statement_Reference__c').//Added By Himani Joshi
            selectField('Amount_Fullfillment__c').//Added By Himani Joshi
            selectField('Journal_Required__c').
            setCondition('Id=:searchValue1').
           	setLimit(recordLimit).
        	toSOQL()
       );
	}
    /**
    * @description Return Payment_Plan__c by Type, Application Id
    * @param searchValue1 (Application Id)
    * @param searchValue2 (Payment Plan Type)
    * @param recordLimit max records to return
    * @return List<Payment_Plan__c>
    **/
    public List<Payment_Plan__c> selectByTypeByApplicationId (Id searchValue1, String searchValue2, Integer recordLimit) {
        return (List<Payment_Plan__c>) Database.query (
            newQueryFactory().
            selectField('Id').
            selectField('Account_Number__c').
            selectField('Account_Type__c').
            selectField('Bank_Name__c').
            selectField('Branch_Code__c').
            selectField('Branch_Name__c').
            selectField('Debit_Order_Debit_Day__c').
            selectField('Debit_Order_Commencement_Date__c').
            selectField('Frequency__c').
            selectField('Method__c').
            selectField('Status__c').
            selectField('Third_Party__c').
            selectField('Application__c').
            selectField('Type__c').
            selectField('Fee_Code__c').
            selectField('Type_of_Details__c').
            setCondition('Application__c=:searchValue1 AND Type__c=:searchValue2').
            setLimit(recordLimit).
            toSOQL()
        );
    }
   /**
   * @description Return Payment_Plan__c by Type, Application Id
   * @param searchValue1 (Application Id)
   * @param searchValue2 (Payment Plan Type)
   * @param recordLimit max records to return
   * @param method (Payment Plan Method)
   * @return List<Payment_Plan__c>
   **/
   public List<Payment_Plan__c> selectByTypeByMethodByApplicationId (Id searchValue1, String searchValue2, Integer recordLimit, String method) {
       return (List<Payment_Plan__c>) Database.query (
           	newQueryFactory().
            selectField('Id').
            selectField('Account_Number__c').
            selectField('Account_Type__c').
            selectField('Bank_Name__c').
            selectField('Branch_Code__c').
            selectField('Branch_Name__c').
            selectField('Debit_Order_Debit_Day__c').
            selectField('Debit_Order_Commencement_Date__c').
            selectField('Frequency__c').
            selectField('Method__c').
            selectField('Status__c').
            selectField('Third_Party__c').
           	selectField('Application__c').
           	selectField('Type__c').
           	selectField('Fee_Code__c').
            setCondition('Application__c=:searchValue1 AND Type__c=:searchValue2 AND Method__c =:method' ).
           	setLimit(recordLimit).
        	toSOQL()
       );
   }
    /**
    * @description Payment_Plan__c by Type, Name, Application Id
    * @author Manish.battu@absa.africa | 2021-06-11
    * @param searchValue1 (Application Id)
    * @param searchValue2 (Payment Plan Type)
    * @param searchValue3 (Payment Plan Name)
    * @param recordLimit max records to return
    * @return List<Payment_Plan__c>
    **/
    public List<Payment_Plan__c> selectByApplicationIdByTypeByName (Id searchValue1, String searchValue2, String searchValue3, Integer recordLimit) {
        return (List<Payment_Plan__c>) Database.query (
            newQueryFactory().
            selectField('Id').
            selectField('Account_Number__c').
            selectField('Account_Type__c').
            selectField('Bank_Name__c').
            selectField('Branch_Code__c').
            selectField('Branch_Name__c').
            selectField('Method__c').
            selectField('Status__c').
            selectField('Application__c').
            selectField('Type__c').
            selectField('Type_of_Details__c').
            selectField('Name').
            setCondition('Application__c=:searchValue1 AND Type__c=:searchValue2 AND Name=:searchValue3').
            setLimit(recordLimit).
            toSOQL()
        );
    }
    /**
    * @description Return Payment_Plan__c by Type, Name, Application Id
    * @param searchValue1 (Application Id)
    * @param searchValue2
    * @param recordLimit max records to return
    * @return List<Payment_Plan__c>
    **/
    public List<Payment_Plan__c> selectByApplicationIdByTypeDetails (Id searchValue1, String searchValue2, Integer recordLimit) {
        return (List<Payment_Plan__c>) Database.query (
            newQueryFactory().
            selectField('Id').
            selectField('Account_Number__c').
            selectField('Account_Name__c').
            selectField('Account_Type__c').
            selectField('Bank_Name__c').
            selectField('Branch_Code__c').
            selectField('Branch_Name__c').
            selectField('Method__c').
            selectField('Status__c').
            selectField('Application__c').
            selectField('Type__c').
            selectField('Type_of_Details__c').
            selectField('Name').
            setCondition('Application__c=:searchValue1 AND Type_of_Details__c=:searchValue2').
            addOrdering('LastModifiedDate',fflib_QueryFactory.SortOrder.DESCENDING, true).
            setLimit(recordLimit).
            toSOQL()
        );
    }
    /**
    * @description Return Payment_Plan__c by Application Product Id
    * @param appProductId (Application Product Id)
    * @return List<Payment_Plan__c>
    **/
    public List<Payment_Plan__c> selectByApplicationProductId (Id appProductId){
        return (List<Payment_Plan__c>) Database.query (
            newQueryFactory()
            .selectField('Amount_Fullfillment__c')
            .selectField('Application_Product__c')
            .selectField('Once_Off_Payment_Required__c')
            .selectField('Statement_Reference__c')
            .selectField('Target_Account__c')
            .selectField('Target_Account_Type__c')
            .selectField('Target_Clearance_Code__c')
            .setCondition('Application_Product__c =: appProductId')
            .toSOQL()
        );
    }
    /**
    * @description Return Payment_Plan__c by Application Product Id and case Id
    * @author Himani Joshi
    * @param appProductId (Application Product Id)
    * @param caseNumber caseId
    * @return List<Payment_Plan__c>
    **/
    public List<Payment_Plan__c> selectByAppProductAndCaseId (Id appProductId,string caseNumber){
        return (List<Payment_Plan__c>) Database.query (
            newQueryFactory()
            .selectField('Id')
            .selectField('Amount_Fullfillment__c')
            .selectField('Application_Product__c')
            .selectField('Once_Off_Payment_Required__c')
            .selectField('Statement_Reference__c')
            .selectField('Target_Account__c')
            .selectField('Target_Account_Type__c')
            .selectField('Target_Clearance_Code__c')
            .setCondition('Application_Product__c =: appProductId AND Name=:caseNumber and amount_fullfillment__c !=null and Once_Off_Payment_Required__c!=null and Statement_Reference__c!=null and Target_Account__c!=null and Target_Account_Type__c!=null and Target_Clearance_Code__c!=null')
            .toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}