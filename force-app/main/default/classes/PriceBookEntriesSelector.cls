/**
* Apex Enterprise Design Patterns
* Selector Layer for PriceBookEntry objects
*
* @author  Kyle Alexander
* @since   2018-09-04
*/
public class PriceBookEntriesSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return PricebookEntry.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                PricebookEntry.id,
                PricebookEntry.name
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    public List<PricebookEntry> selectById(Set<Id> idSet) {
        return (List<PricebookEntry>) selectSObjectsById(idSet);
    }

    //CUSTOM SELECTORS - START

    /**
     * Method that retrieves a single PricebookEntry by Id
     *
     * @param   priceBookEntryId  The Id of the PricebookEntry
     *
     * @return  PricebookEntry  The PricebookEntry object record
     */
    public PricebookEntry selectById(Id priceBookEntryId) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('IsActive').
            selectField('Pricebook2Id').
            selectField('Product2Id').
            selectField('UnitPrice').
            setCondition('Id =: priceBookEntryId').
            toSOQL()
        );

    }

      /**
     * Returns a PricebookEntry record based on a give Product2 Id
     *
     * @param product2Id        The Product2 object record Id
     *
     * @return  PricebookEntry  The PricebookEntry object record
     */
    public PricebookEntry selectByProduct2Id(Id product2Id) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('IsActive').
            selectField('Pricebook2Id').
            selectField('Product2Id').
            selectField('UnitPrice').
            setCondition('Product2Id =: product2Id').
            toSOQL()
        );

    }
    /**
     * Method that gets a single products by given product name
     *
     * @return product -  products with name
     */
    public PricebookEntry selectByName(String pbEntryName, Integer recordLimit) {
        return Database.query(
                newQueryFactory().
                        setCondition('Name = :pbEntryName').
            			setLimit(recordLimit).
                        toSOQL()
        );
    }

    /**
     * Returns a list of PricebookEntry record based on a give Set of Product2 Ids
     *
     * @param product2Ids        The Set of Product2 record Ids
     * @return  PricebookEntry  The List of PricebookEntry record
     */
    public List<PricebookEntry> selectByProduct2Ids(Set<Id> product2Ids) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('IsActive').
            selectField('Pricebook2Id').
            selectField('Product2Id').
            selectField('UnitPrice').
            setCondition('Product2Id IN: product2Ids').
            toSOQL()
        );

    }
    //CUSTOM SELECTORS - END
}