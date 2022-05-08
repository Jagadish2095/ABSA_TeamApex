/**
* Apex Enterprise Design Patterns
* Selector Layer for Employee objects
*
* @author  Himanshu Nimje (Mphatek)
* @since   29-03-2019
*/

public class EmployeesSelector extends fflib_SObjectSelector {
    
	 //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Employee__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Employee__c.id,
                Employee__c.name
        };
    }
    //MANDATORY ABSTRACT METHODS - END


    //CUSTOM SELECTORS - START

    /**
     * Returns a single Adviser based on a given Opportunity Adviser field
     *
     * @param   AdviserId   The Adviser Id
     *
     * @return  Employee    The Adviser object record
     */
    public Employee__c selectById(Id adviserId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('AB_Number__c').
            selectField('Active__c').
            selectField('Advisor_Code__c').
            selectField('Email__c').
            selectField('BRID__c').
            selectField('Employee_Number__c').
            selectField('Firstname__c').
            selectField('Surname__c').
            selectField('Initials__c').
            selectField('ID_Number__c').
            selectField('ID_Type__c').
            selectField('Mobile__c').         
            setCondition('Id = :adviserId').
            toSOQL()
        );
    }
    
    
    //CUSTOM SELECTORS - END
}