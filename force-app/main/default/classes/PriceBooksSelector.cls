/**
* Apex Enterprise Design Patterns
* Selector Layer for Price Book
*
* @author  Rob McLean
* @since   2020-04-23
*/
public class PriceBooksSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Pricebook2.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Pricebook2.id,
            Pricebook2.Name
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<Pricebook2> selectById(Set<Id> idSet) {
        return (List<Pricebook2>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START
    /*RM 
    * Return a list of price books
    * based on a name
    * 
    * @param pbName String
    * @return List<Pricebook2>
    */
    public List<Pricebook2> selectByName(String pbName) {
        return Database.query(
                newQueryFactory().
                selectField('Id').
                selectField('Name').
                setCondition('Name = :pbName' ).
                toSOQL()
        );
    }    
    //CUSTOM SELECTORS - END
}