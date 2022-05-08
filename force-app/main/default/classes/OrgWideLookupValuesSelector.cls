/**
* Apex Enterprise Design Patterns
* Selector Layer for custom metadata type Org_Wide_Lookup_Value__mdt
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-08-07
*/
public class OrgWideLookupValuesSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Org_Wide_Lookup_Value__mdt.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Org_Wide_Lookup_Value__mdt.Value__c,
                Org_Wide_Lookup_Value__mdt.Integer_Value__c    
        };
    }
    
    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<Org_Wide_Lookup_Value__mdt> selectById(Set<Id> idSet) {
        return (List<Org_Wide_Lookup_Value__mdt>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START
    
    /*RN 
    * Return the meta data record Org_Wide_Lookup_Value__mdt
    * based on label
    * 
    * @param mdtLabel String
    * @return List<Org_Wide_Lookup_Value__mdt>
    */
    public List<Org_Wide_Lookup_Value__mdt> selectByLabel(String mdtLabel) { 
        return (List<Org_Wide_Lookup_Value__mdt>) Database.query(
            newQueryFactory(). 
            setCondition('Label = :mdtLabel').
            toSOQL()
        );
       
    }
    
    /*Kokesto Mpshane 
    * Return the meta data records Org_Wide_Lookup_Value__mdt
    * based on labels
    * 
    * @param Set<String> mdtLabels 
    * @return List<Org_Wide_Lookup_Value__mdt>
    */
    public List<Org_Wide_Lookup_Value__mdt> selectByLabels(Set<String> mdtLabels) { 
        return (List<Org_Wide_Lookup_Value__mdt>) Database.query(
            newQueryFactory().
            selectField('Label').
            selectField('Value__c').
            setCondition('Label in:mdtLabels').
            toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}