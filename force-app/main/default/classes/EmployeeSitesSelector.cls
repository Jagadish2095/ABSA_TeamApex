/**
 * Apex Enterprise Design Patterns
 * Selector Layer for Employee_Site__c object
 *
 * @author  Himanshu Nimje (Mphatek)
 * @since   29/03/2019
 */
public class EmployeeSitesSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Employee_Site__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Employee_Site__c.Id,
                Employee_Site__c.Name,
                Employee_Site__c.Active__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END


    //CUSTOM SELECTORS - START

/**
* Returns a single Adviser based on a given Opportunity Adviser field
*
* @param   AdviserId   The Adviser Id
*
* @return  Employee  -  The Employee site object record
*/
    public Employee_Site__c selectById(Id adviserId) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Active__c').
            selectField('Employee__c').
            selectField('Site__c').
            setCondition('Id = :adviserId').
            toSOQL()
        );
    }


/**
* Returns a single Adviser based on a given Opportunity Adviser field
*
* @param   employee   employee Id
*
* @return  Employee  -  The Employee site object record
*/
    public Employee_Site__c selectByEmployeeId(Id employee) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Active__c').
            selectField('Site__c').
            setCondition('Employee__c = :employee').
            toSOQL()
        );
    }

/**
* Returns a single Adviser based on a given Opportunity Adviser field
*
* @param   site  -  site Id
*
* @return  Employee  -  The Employee site object record
*/

    public List<Employee_Site__c> selectBySiteId(Id site) {
        return new List<Employee_Site__c>{
            Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Name').
                selectField('Active__c').
                selectField('Employee__c').
                setCondition('Site__c = :site').
                toSOQL()
            )
        };
    }


    //CUSTOM SELECTORS - END


}