/**
 * 
 * Class for Asset Details lookup
 *
 * @author  Sandile Mathe
 * 
*/

public class LookUpAssetDetails {

    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = '%'+ searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
//Get application Id using Opportunity to store vehicle details     
@AuraEnabled
public static String ApplicationId(String oppId) {
      list<OpportunityLineItem> ApplicationId = [SELECT Id,Application_Product_CAF__c  FROM OpportunityLineItem where OpportunityId =: oppId LIMIT 1];
        return ApplicationId[0].Application_Product_CAF__c;
    } 
    
   @auraEnabled
    public static Application_Product_CAF__c  saveVehicleDetails(string ApplicationId,String selectedVehicle){
        Application_Product_CAF__c  asst = new Application_Product_CAF__c ();
        asst.Vehicle_Make_Model__c = selectedVehicle;
        asst.Id=ApplicationId;
        update asst;
        return asst;
         
    }
    
    //Method to show products after refresh
    @AuraEnabled
    public static String getSelectedVehicleDetails (string ApplicationId){
     Application_Product_CAF__c ApplicationDetails = [SELECT Id,Vehicle_Make_Model__c  FROM Application_Product_CAF__c WHERE Id =: ApplicationId LIMIT 1];
       
        return ApplicationDetails.Vehicle_Make_Model__c;
    }
    

}