/**
 * @description
 *
 * @author  Anka Ganta : Absa 
 * @version v1.0
 * @since   2020-08-08
 *
 */

public without sharing class OnboardingMainUtil {
     /**
	 * @description Call to get ParticipantsData from ubo structure
	 * @param accountHierarchy
	 * @return Set<Id>
	 */
    public static Set<Id> getParticipantsData(String accountHierarchy){  
        
        List<Id> participantIds = new List<Id>();
        Set<Id> participantIdsSet = new Set<Id>();
        
        List<ParentAccountWrapper> accountHierarchyWrapper = new List<ParentAccountWrapper>();
        
        if(accountHierarchy != null && accountHierarchy != ''){
            accountHierarchyWrapper = (List<ParentAccountWrapper>)JSON.deserialize(accountHierarchy, List<ParentAccountWrapper>.class);
            
            for(ParentAccountWrapper accWrapper : accountHierarchyWrapper){
                participantIds.add(accWrapper.recordId);            
                if(accWrapper.Accwrplist != null && accWrapper.Accwrplist.size() > 0){
                    participantIds = getParticipantData(accWrapper.Accwrplist,participantIds,null);
                }            
            }
            
            if(participantIds.size() > 0){
                participantIdsSet.addAll(participantIds); 
            } 
            
        }
        return participantIdsSet;
    }
    /**
    * @description getParticipantData
    * @param entityWrapperList 
    * @param participantIds 
    * @param relationshipType 
    * @return List<Id> 
    **/
    public static List<Id> getParticipantData(List<AccountWrapper> entityWrapperList, List<Id> participantIds,String relationshipType){
        
        for(AccountWrapper eachWrapper : entityWrapperList) {            
            String relationshipTypeEntity = eachWrapper.accType;               
            if(relationshipTypeEntity == 'AccountContact') {                
                if(eachWrapper.UBO == 'Yes') {
                    participantIds.add(eachWrapper.recordId);
                }                
            } else if (relationshipTypeEntity == 'AccountAccount') {
                participantIds.add(eachWrapper.recordId);
            }
            if(eachWrapper.childwrplist != null && eachWrapper.childwrplist.size() > 0) {
                participantIds = getParticipantData(eachWrapper.childwrplist,participantIds,relationshipType);
            }            
        }        
        return participantIds;
    }
    /**
    * @description AccountWrapper
    */
    public Class AccountWrapper{
        /**
         * @description 
         */
        @AuraEnabled
        public String Shareholder {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String Type {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String idType {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public Integer ShareholderCount {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public Decimal ParentShareholding {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public Decimal Controllinginterest {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String accType {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String roles {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String UBO {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String recordId {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String relatedAccountId {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String parentAccountId {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String primaryEntityId {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public List<AccountWrapper> childwrplist {get;set;}
    } 
    
    /**
    * @description ParentAccountWrapper
    */
    public Class ParentAccountWrapper{
        /**
         * @description 
         */
        @AuraEnabled				
        public String Shareholder {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String Type {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public Integer ShareholderCount {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public Decimal ParentShareholding {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public Decimal Controllinginterest {get;set;}            
        /**
         * @description 
         */
        @AuraEnabled
        public String accType {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public String recordId {get;set;}
        /**
         * @description 
         */
        @AuraEnabled
        public List<AccountWrapper> Accwrplist {get;set;}
        
    }
}