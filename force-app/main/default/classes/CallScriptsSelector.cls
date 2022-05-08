/**
* Apex Enterprise Design Patterns
* Selector Layer for Accepted_Card__c objects
*
* @author  Minal Rama - BlueSky
* @since   2020/10/20
*/
public class CallScriptsSelector extends fflib_SObjectSelector {

    public Schema.SObjectType getSObjectType() {
        return Call_Script__c.sObjectType;
    }

    /**
     * @description Mandatory abstract method
     * @return List<Schema.SObjectField>
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Call_Script__c.Id,
                Call_Script__c.Name,
                Call_Script__c.Financial_Product__c,
                Call_Script__c.Script__c,
                Call_Script__c.Step__c
        };
    }

    /**
     * @description get Call_Script__c by Id
     * @param idSet Set<Id>
     *
     * @return List of Call_Script__c records
     */
    public List<Call_Script__c> selectById(Set<Id> idSet) {
        return (List<Call_Script__c>) selectSObjectsById(idSet);
    }

    /**
     * @description select records by step and product name
     * @param step step__c number
     * @param productName the financial product name
     *
     * @return List of Call_Script__c
     */
    public List<Call_Script__c> selectByStepAndProductName(Integer step, String productName) {

        return Database.query(
                newQueryFactory().
                        selectField('Id').
                        selectField('Name').
                        selectField('Financial_Product__c').
                        selectField('Financial_Product__r.Name').
                        selectField('Script__c').
                        selectField('Step__c').
                        selectField('Section__c').
                        setCondition('Step__c = :step AND Financial_Product__r.Name = :productName').
                        toSOQL()
        );
    }

    /**
     * @description select Call Script records by steps and product name
     * @param steps string of numbers with comma (i.e 1,2,3)
     * @param productName the financial product name
     *
     * @return List of Call_Script__c
     */
    public List<Call_Script__c> selectByStepsAndProductName(List<Integer> steps, String productName) {

        return Database.query(
                newQueryFactory().
                        selectField('Id').
                        selectField('Name').
                        selectField('Financial_Product__c').
                        selectField('Financial_Product__r.Name').
                        selectField('Script__c').
                        selectField('Step__c').
                        selectField('Section__c').
                        setCondition('Step__c IN :steps AND Financial_Product__r.Name = :productName').
                        addOrdering('Step__c',fflib_QueryFactory.SortOrder.ASCENDING, true).
                        toSOQL()
        );
    }

    /**
     * @description select Call Script records by steps and product name
     * @param steps string of numbers with comma (i.e 1,2,3)
     * @param productName the financial product name
     * @param campaignId the ID of campaign
     *
     * @return List of Call_Script__c
     */
    public List<Call_Script__c> selectByStepsAndProductNameAndCampaign(List<Integer> steps, String productName, String campaignId) {

        return Database.query(
                newQueryFactory().
                        selectField('Id').
                        selectField('Name').
                        selectField('Financial_Product__c').
                        selectField('Financial_Product__r.Name').
                        selectField('Script__c').
                        selectField('Step__c').
                        selectField('Section__c').
                        selectField('Campaign__c').
                        setCondition('Step__c IN :steps AND Financial_Product__r.Name = :productName AND Campaign__c = :campaignId').
                        addOrdering('Step__c',fflib_QueryFactory.SortOrder.ASCENDING, true).
                        toSOQL()
        );
    }
    
   /*
    * Return list of callscripts by sections
    * Custom selector USING the Base class queryFactory
    * Author : Poornima Aduru :absa
    * Date : 2020-11-24
    * 
    * @param List of String with section values
    * @return list of CallScripts 
    */
    public List<Call_Script__c> selectBySection(List<String> Section) {

        return Database.query(
                newQueryFactory().
                        selectField('Id').
                        selectField('Name').
                        selectField('Script__c').
                        selectField('Section__c').
                        setCondition('Section__c IN :Section').
                        toSOQL()
        );
    }

}