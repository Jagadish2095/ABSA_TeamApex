/**
 * @description AccountAccountRelation Utility class
 *
 * @author  Anka Ganta : Absa
 * @version v1.0
 * @since   2020-08-08
 *
 */
public without sharing class AccountAccountRelationUtil {
     /**
    * @description getAccountAccountRelation
    * @param participantIdsSet
    * @return List<FinServ__AccountAccountRelation__c>
    */
    public static List<FinServ__AccountAccountRelation__c> getAccountAccountRelation(Set<Id> participantIdsSet){
            List<FinServ__AccountAccountRelation__c> accAccList;        
            if(participantIdsSet !=null ){
                accAccList = new AccountAccountRelationSelector().selectbyIdSet(participantIdsSet);                
            }            
            return accAccList;
        }
}