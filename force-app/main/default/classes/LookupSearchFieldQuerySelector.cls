/**
* Apex Enterprise Design Patterns
* Selector Layer for custom metadata type Lookup_Search_Field_Query__mdt
*
* @author  Koketso Mpshane
* @since   2020-07-15
*/
public class LookupSearchFieldQuerySelector extends fflib_SObjectSelector{
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Lookup_Search_Field_Query__mdt.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Lookup_Search_Field_Query__mdt.Query_String__c
        };
    }
    
    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<Lookup_Search_Field_Query__mdt> selectById(Set<Id> idSet) {
        return (List<Lookup_Search_Field_Query__mdt>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START
    
    /* 
    * Koketso - Return the meta data record Lookup_Search_Field_Query__mdt
    * based on label
    * 
    * @param mdtLabel String
    * @return List<Lookup_Search_Field_Query__mdt>
    */
    public List<Lookup_Search_Field_Query__mdt> selectByLabel(String mdtLabel) { 
        return (List<Lookup_Search_Field_Query__mdt>) Database.query(
            newQueryFactory(). 
            setCondition('Label = :mdtLabel').
            toSOQL()
        );
       
    }
   //CUSTOM SELECTORS - END

}