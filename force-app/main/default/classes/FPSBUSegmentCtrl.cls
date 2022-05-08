/** 
 * @description Apex contoller for FPSBUSegment Lightning Component
 * @author Jagadish Thummala
 * @created 16/03/2022
 */
public with sharing class FPSBUSegmentCtrl {
 //Method to get details for FPSBUSegmentManagerDetails

    @AuraEnabled
    public static List<user> getManagerDetails(string managerName) {
        
           List<user> managerDetails= [SELECT Name,MobilePhone,Email,AB_Number__c FROM User WHERE Name =:managerName];
           return managerDetails;
    }
    
    @AuraEnabled
    public static List<Account> getRelationshipBanker(id accountId){
        
         List<Account> accountDetails = [SELECT Relationship_Banker_Manager__c,Relationship_Banker_Name__r.AB_Number__c,
                                        Relationship_Banker_Name__r.BRID__c,Relationship_Banker_Name__r.Email,Relationship_Banker_Name__r.Name,
                                        Relationship_Banker_Manager_AB__c,Relationship_Banker_Name__r.MobilePhone,
                                        Relationship_Banker_Name__r.SiteCode__c,Relationship_Banker_Name__r.lastlogindate,
                                        Relationship_Banker_Name__r.Title,Relationship_Banker_Name__r.phone
                                        FROM Account Where ID =:accountId];
        
    return accountDetails;
    }

}