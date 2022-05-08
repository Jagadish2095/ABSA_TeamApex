/*
* Extension Controller for OnboardingTradingAsName Component
*
* @author  Tracy de Bruin
* @version v1.0
* @since   2020-05-06
*
*/
public class OnboardingTradingAsNameController {
    
    //TdB - Get all existing Trading as Name records based on Account Id
    @AuraEnabled
    public static List<Trading_as_Name__c> getTradingAsNameRecords(Id accRecId){
        
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(accRecId);
        
        //Get all related parties and add Account Id's to set
        for(AccountContactRelation eachParty : new AccountContactRelationSelector().selectRelationByAccountId(accRecId)) { 
            if(eachParty.AccountId != null) {
               accIdSet.add(eachParty.AccountId); 
            }
            if(eachParty.Contact.AccountId != null) {
                accIdSet.add(eachParty.Contact.AccountId); 
            }
        }
        
         List<Trading_as_Name__c> tradingAsNameRecords = new List<Trading_as_Name__c>();
        if(accRecId != null){
            tradingAsNameRecords = new TradingAsNamesSelector().selectByAccountId(accIdSet);
        }
        return tradingAsNameRecords;
    }
    
   //TdB - Get details on selected Trading as Name so that it can be used with Editing
    @AuraEnabled
    public static Trading_as_Name__c getSelectedTradingAsNameRecord(Id tradingAsNameId){
        
        Trading_as_Name__c selectedTradingAsName = new Trading_as_Name__c();

        if(tradingAsNameId != null)  {
            selectedTradingAsName = new TradingAsNamesSelector().selectById(tradingAsNameId);
        } 
        
        return selectedTradingAsName;
        

    }
    
    //TdB - Create a new Trading as Name and link to Account
    @AuraEnabled
    public static List<Trading_as_Name__c> createNewTradingAsName(Id accId, Trading_as_Name__c tradingAsNameUpdate, Trading_as_Name__c tradingAsNameNew ){
        Try{ 
            
            Set<Id> accIdSet = new Set<Id>();
            
            //Get all related parties and validate that the Trading Name is linked to one of them
            for(AccountContactRelation eachParty : new AccountContactRelationSelector().selectRelationByAccountId(accId)) { 
                if(eachParty.AccountId != null) {
                    accIdSet.add(eachParty.AccountId); 
                }
                if(eachParty.Contact.AccountId != null) {
                    accIdSet.add(eachParty.Contact.AccountId); 
                }
            }
            
            if(tradingAsNameUpdate != null) {  
               // if(tradingAsNameUpdate.Account__c != null && accIdSet.contains(tradingAsNameUpdate.Account__c)) {
                    update tradingAsNameUpdate;
                /*} else {
                    AuraHandledException e = new AuraHandledException('You only allowed to add a Trading as Name for the Primary Account and/or Related Parties');
                    e.setMessage('You only allowed to add a Trading as Name for the Primary Account and/or Related Parties');
                    system.debug(e);
                    throw e;
                }*/
                
            } 
            
            if(tradingAsNameNew != null) {
                //if(tradingAsNameNew.Account__c != null && accIdSet.contains(tradingAsNameNew.Account__c)) {
                    insert tradingAsNameNew;
                /* else {
                    AuraHandledException e = new AuraHandledException('You only allowed to add a Trading as Name for the Primary Account and/or Related Parties');
                    e.setMessage('You only allowed to add a Trading as Name for the Primary Account and/or Related Parties');
                    system.debug(e);
                    throw e;
                }*/
            }
            
            //Get alladdresses link
            return getTradingAsNameRecords(accId);
            
        }
        catch (Exception e) {
            throw new AuraHandledException('Exception : '+ e.getMessage());
        }
        
    }
    
    //TdB - Delete a selected Trading as Name
    @AuraEnabled
    public static Boolean deleteTradingAsName(Id tradingAsNameId ){
        
        Boolean recordDeleted = false;
        
        Try{            
            
            if(tradingAsNameId != null) {  
                
                Trading_as_Name__c recordToDelete = new TradingAsNamesSelector().selectById(tradingAsNameId);
                delete recordToDelete;
                
                recordDeleted = true; 
                
            } 
                
        }
        catch (Exception e) {
            throw new AuraHandledException('Exception : '+ e.getMessage());
        }
        
        return recordDeleted;
        
    }
    
}