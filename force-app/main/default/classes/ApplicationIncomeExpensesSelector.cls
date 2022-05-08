/**
* @description Apex Enterprise Design Patterns
* Selector Layer for Application & Income expense object
*
* @author  Almas Aleem :Absa 
* @since   2020-09-26
*/
public class ApplicationIncomeExpensesSelector extends fflib_SObjectSelector {
   /**
   * @description 
   * @author almas.aleem@absa.africa | 2021-07-12 
   * @return Schema.SObjectType 
   **/
   public Schema.SObjectType getSObjectType(){
      return Application_Income_and_Expense__c.sObjectType;
   }
    
  /**
  * @description 
  * @author almas.aleem@absa.africa | 2021-07-12 
  * @return List<Schema.SObjectField> 
  **/
  public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            
               Application_Income_and_Expense__c.Id
                
                };
      }
     //MANDATORY ABSTRACT METHODS - END 
    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-07-12 
    * @param ApplicationId 
    * @return List<Application_Income_and_Expense__c> 
    **/
    public List<Application_Income_and_Expense__c> selectByAppType(Id ApplicationId){
       		return Database.query(
            newQueryFactory().selectField('Id'). 
            selectField('Applicant_Type__c').
            selectField('Applicant_Bureau_Value__c'). 
            selectField('Applicant_Maximum_Value__c'). 
            selectField('Applicant_Value__c'). 
            selectField('Spouse_Value__c'). 
            selectField('Spouse_Maximum_Value__c'). 
            selectField('Spouse_Bureau_Value__c'). 
            selectField('Bureau_Value__c').  
            selectField('Maximum_Value__c').
            selectField('Business_Value__c'). 
            selectField('Operation_Type__c').    
            selectField('Category__c').  
            selectField('Expense_Value__c').  
            selectField('Household_Value__c').   
            selectField('Total_Monthly_Household_Income__c'). 
            selectField('Total_Absa_Instalments__c'). 
            selectField('Total_External_Instalments__c'). 
            selectField('Total_Living_Expense__c'). 
            selectField('Total_MDI_Adjusted__c').
           	selectField('Total_MDI_Available__c'). 
            selectField('Total_External_Instalments__c'). 
            selectField('Total_MDI_Expenses__c'). 
            selectField('Total_Monthly_Disposable_Income__c').  
            selectField('Total_Maximum_Applicant__c').  
            selectField('Total_Maximum_Spouse_Value__c').      
            selectField('Surplus_Shortage__c').
           	selectField('Stress_Allowance__c'). 
            selectField('Necessary_Expenses_Shortfall__c'). 
            selectField('Cost_of_Current_Faclity_Settlements__c'). 
            selectField('Cost_of_New_Facility__c').      
            setCondition('Application__c =\''+ ApplicationId+'\'').
            toSOQL()
        ); 
    }
     /**
     * @description 
     * @author almas.aleem@absa.africa | 2021-07-12 
     * @param ApplicationId 
     * @param expenseType 
     * @return List<Application_Income_and_Expense__c> 
     **/
     public List<Application_Income_and_Expense__c> selectByExpenseType(Id ApplicationId,String expenseType){
       		return Database.query(
            newQueryFactory().selectField('Id'). 
            selectField('Applicant_Type__c').
            selectField('Applicant_Bureau_Value__c'). 
            selectField('Applicant_Maximum_Value__c'). 
            selectField('Applicant_Value__c'). 
            selectField('Spouse_Value__c'). 
            selectField('Spouse_Maximum_Value__c'). 
            selectField('Spouse_Bureau_Value__c'). 
            selectField('Bureau_Value__c').  
            selectField('Maximum_Value__c').
            selectField('Business_Value__c'). 
            selectField('Operation_Type__c').    
            selectField('Category__c').  
            selectField('Expense_Value__c').  
            selectField('Household_Value__c').   
            selectField('Total_Monthly_Household_Income__c'). 
            selectField('Total_Absa_Instalments__c'). 
            selectField('Total_External_Instalments__c'). 
            selectField('Total_Living_Expense__c'). 
            selectField('Total_MDI_Adjusted__c').
           	selectField('Total_MDI_Available__c'). 
            selectField('Total_External_Instalments__c'). 
            selectField('Total_MDI_Expenses__c'). 
            selectField('Total_Monthly_Disposable_Income__c').  
            selectField('Total_Maximum_Applicant__c').  
            selectField('Total_Maximum_Spouse_Value__c').   
            selectField('Surplus_Shortage__c').
           	selectField('Stress_Allowance__c'). 
            selectField('Necessary_Expenses_Shortfall__c'). 
            selectField('Cost_of_Current_Faclity_Settlements__c'). 
            selectField('Cost_of_New_Facility__c').      
            setCondition('Application__c =\''+ ApplicationId+'\' AND Category__c=\''+expenseType+'\'').
            toSOQL()
        ); 
    }
}