/**
* Apex Enterprise Design Patterns
* Selector Layer for custom metadata type General_Rules__mdt
*
* @author  Rob McLean
* @since   2020-04-23
*/
public class GeneralRulesCustomMdtSelector extends fflib_SObjectSelector  {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return General_Rules__mdt.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                General_Rules__mdt.Maximum_Age__c,
                General_Rules__mdt.Minimum_Age__c,
               	General_Rules__mdt.Product__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<General_Rules__mdt> selectById(Set<Id> idSet) {
        return (List<General_Rules__mdt>) selectSObjectsById(idSet);
    }    
    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START    
    /*RM 
    * Return the meta data record General_Rules__mdt
    * based on label and Product__c
    * 
    * @param mdtLabel String
    * @param product String
    * @return List<General_Rules__mdt>
    */
    public List<General_Rules__mdt> selectByLabelandProduct(String mdtLabel, String product) { 
        return (List<General_Rules__mdt>) Database.query(
            newQueryFactory(). 
            setCondition('Label = :mdtLabel AND Product__c = :product').
            toSOQL()
        );
       
    }
    //CUSTOM SELECTORS - END
    
}