public with sharing class SBU_Segment_ctrl {
 
    @AuraEnabled
    public static list<user> getManagerDetails(string managerName) {
        
    list<user> managerDetails= [SELECT Name,MobilePhone,Email,BRID__c FROM User WHERE Name =:managerName];
    return managerDetails;
    }
    @AuraEnabled
    public static list<Account> getRelationshipBanker(id accountId){
        
    list<Account> AccountDetails = [SELECT Relationship_Banker_Manager__c,Relationship_Banker_AB_Number__c,Relationship_Banker_BRID__c,
                                    Relationship_Banker_Email__c,Relationship_Banker_Last_Login_Date__c,Relationship_Banker__c,
                                    Relationship_Banker_Manager_AB__c,Relationship_Banker_MobilePhone__c,
                                    Relationship_Banker_site_code__c FROM Account Where ID =:accountId];
        
    return AccountDetails;
    }

}