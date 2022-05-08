/**
 * Apex Enterprise Design Patterns
 * Selector Layer for Lookup__c objects
 *
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2018-09-26
 */
public class LookupsSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Lookup__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Lookup__c.Id,
            Lookup__c.Name,
            Lookup__c.Bank__c,
            Lookup__c.Branch_Code__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    //get Lookup__c by id's
    public List<Lookup__c> selectById(Set<Id> idSet) {
        return (List<Lookup__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END

    /**
     * Returns a single Lookup based on a given Bank Id field
     * @param   bankId   The site Id
     * @return  Lookup__c
     */
    public List<Lookup__c> selectByBankId(Set<Id> bankId) {
        return Database.query(
            newQueryFactory()
                .setCondition('Bank__c IN :bankId')
                .toSOQL()
        );
    }

    /**
     * Returns a single Lookup based on a given BranchCode field
     * @param   branchCodes
     * @return  Lookup__c
     */
    public List<Lookup__c> selectByBranchCode(Set<String> branchCodes) {
        return Database.query(
            newQueryFactory()
                .selectField('Bank__r.Name')
                .setCondition('Branch_Code__c IN :branchCodes')
                .toSOQL()
        );
    }

    /**
     * Returns a single Lookup based on a given BranchCode field
     * @param   branchCodes
     * @return  Lookup__c
     */
    public List<Lookup__c> selectByName(String lookupName) {
        String lookupNameSearch = '%' + lookupName + '%';

        return Database.query(
            newQueryFactory()
                .setCondition('Bank__r.Name LIKE :lookupNameSearch')
                .toSOQL()
        );
    }
}