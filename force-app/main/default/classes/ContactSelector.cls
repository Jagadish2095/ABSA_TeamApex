/**
* Apex Enterprise Design Patterns
* Selector Layer for Contact objects
*
* @author  Kyle Alexander
* @version APIv4.3
* @since   2018-07-17
*/

public class ContactSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Contact.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Contact.id,
                Contact.name,
                Contact.email
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    public List<Contact> selectById(Set<Id> idSet) {
        return (List<Contact>) selectSObjectsById(idSet);
    }

    //CUSTOM SELECTORS - START

    /**
     * Method that gets a single contact from an Account's Person ID
     *
     * @return Contact - single contact with ID and email address
     */
    public Contact selectByPersonId(Id personId, Integer recordLimit) {
        return Database.query(
                newQueryFactory().
                        setCondition('id = :personId').
                        setLimit(recordLimit).
                        toSOQL()
        );
    }

    /**
     * Method that takes a set of contact ID's
     *
     * @return List<Contact> - returns a list of contacts
     */
    public List<Contact> selectByListContactIds(Set<Id> contactIds) {
        return Database.query(
                newQueryFactory().
                        setCondition('Id in :contactIds').
                        toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}