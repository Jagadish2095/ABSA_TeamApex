/**
* Apex Enterprise Design Patterns
* Selector Layer for Document Standard object
*
* @author  Robert McLean
* @since   2020-06-09
*/
public class DocumentSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Document.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Document.Id,
                Document.Name,
                Document.Url,
                Document.Body,
                Document.LastModifiedById
                };
                    }
    //MANDATORY ABSTRACT METHODS - END
    //INHERIT FROM BASE CLASS - START
    //get records by id's
    public List<Document> selectById(Set<Id> idSet) {
        return (List<Document>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END
    //CUSTOM SELECTORS - START
    /*
    * Return Document
    * Custom selector USING the Base class queryFactory
    *
    * @return List<Document>
    */
    public List<Document> selectAll() {
        return (List<Document>) Database.query(
            newQueryFactory().
            toSOQL()
        );
    }

    /*
    * Return OrgWideEmailAddresses based on Name
    *
    */
    public List<Document> selectByName(Set<String> name) {
        return  Database.query(
            newQueryFactory().
            selectField('Name').
            selectField('LastModifiedById').
            selectField('Body').
            setCondition('Name IN :name').
            toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}