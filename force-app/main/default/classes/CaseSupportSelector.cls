/**
* Apex Enterprise Design Patterns
* @description Selector Layer for Case_Support__c objects
* @author  Vitthal Jivrag
* @since   2020/11/20
*/
public class CaseSupportSelector extends fflib_SObjectSelector{
    
    /**
    * @description Mandatory abstract method
    * @return List of object fields
    **/ 
        public Schema.SObjectType getSObjectType() {
            return Case_Support__c.sObjectType;
        }
        
    /**
    * @description Mandatory abstract method
    * @return List<Schema.SObjectField>
    */
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField>{
                Case_Support__c.Id,
                    Case_Support__c.Product_Name__c,
                    Case_Support__c.Policy_Number__c,
                    Case_Support__c.Policy_Type__c,
                    //Case_Support__c.Product_Provider__c,
                    Case_Support__c.Risk_Sum_Assured__c,
                    Case_Support__c.Inception_Date__c,
                    Case_Support__c.Case__c
                    };
           }
        
    /**
    * @description select Case_Support__c records by case Record Id
    * @param caseId current case id   
    * @return List of Case_Support__c
    */  
        public List<Case_Support__c> selectByCaseID(String caseId) {
            
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Product_Name__c').
                selectField('Policy_Number__c').
                selectField('Policy_Type__c').
                //selectField('Product_Provider__c').
                selectField('Inception_Date__c').
                selectField('Case__c').
                selectField('Maturity_Date__c').
                selectField('Maturity_Value__c').            
                selectField('Case__r.isConsentConfirmed__c').
                selectField('Case__r.RecordType.Name').
                selectField('Case__r.ID_V_Completed__c').
                selectField('Other_Policy__c').
                setCondition('Case__c = : caseId').
                toSOQL()
            );
        }
        
    /**
    * @description select Case_Support__c records by case Record Id
    * @return List of Case_Support__c
    **/  
          public List<Case_Support__c> showPoliciesWise(){
            
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Product_Name__c').
                selectField('Policy_Number__c').
                selectField('Policy_Type__c').
                //selectField('Product_Provider__c').
                selectField('Inception_Date__c').
                setCondition('CREATEDDATE=Today').
                toSOQL()
            );
        }
         
      /**
    * @description select Case_Support__c records by case Record Id
    * @param CaseID current case id   
    * @return List of Case_Support__c
    **/ 
        public List<Case_Support__c> showPoliciesWise(ID CaseID){
            
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Product_Name__c').
                selectField('Policy_Number__c').
                selectField('Policy_Type__c').
                //selectField('Product_Provider__c').
                selectField('Inception_Date__c').
                setCondition('Case__c=:CaseID').
                toSOQL()
            );
        }
        
        /**
    * @description select Case_Support__c records by case Record Id
    * @param PolicyID current case id   
    * @return List of Case_Support__c
    **/ 
         public List<Case_Support__c> showPoliciesWise(list<string> PolicyID){
            
            return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Product_Name__c').
                selectField('Policy_Number__c').
                selectField('Policy_Type__c').
                selectField('Product_Provider__c').
                selectField('Inception_Date__c').
                setCondition('id IN :PolicyID').
                toSOQL()
            );
        }
        
    }