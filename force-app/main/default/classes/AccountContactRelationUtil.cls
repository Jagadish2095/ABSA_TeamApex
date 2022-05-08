/**
 * @description AccountContactRelation Utility class
 *
 * @author  Anka Ganta : Absa
 * @version v1.0
 * @since   2020-08-08 
 *
 */
public without sharing class AccountContactRelationUtil {
     /**
	 * @description Call to get ParticipantsData from ubo structure
	 * @param participantIdsSet
	 * @return List<AccountContactRelation>
	 */
    public static List<AccountContactRelation> getAccountContactRelation(Set<Id> participantIdsSet){
        List<AccountContactRelation> accContList;        
        if(participantIdsSet !=null ){
            accContList = new AccountContactRelationSelector().selectbyIdSet(participantIdsSet);                
        }            
        return accContList;
    }      
}