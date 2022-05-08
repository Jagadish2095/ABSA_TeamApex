/**
* Document trigger handle functions - separate logic e.g. data updates 
* @author  Tinashe M Shoko
* @created 2020-19-07
*/
public class DocumentTriggerFunctions {
    // update the Quote Status for each Opportunity when the document has been e-signed
    public static void updateOpportunityQuoteStatus(Set<Id> opportunityIds) {
        /*List<Opportunity> oppList = new OpportunitiesSelector().selectByListOpportunityIds(opportunityIds);
        for (Opportunity opp : oppList) {
            if (opp.Quote_Status__c == 'Pending') {
                opp.Quote_Status__c = 'Accepted';
            }
        }
        
        if (oppList != null && !oppList.isEmpty() &&  oppList.size() > 0) {
            try{
                update oppList;
            } catch(DMLException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'DocumentTriggerFunctions', 'updateOpportunityQuoteStatus', 'There was an error updating thr Quote_Status__c field on Opportunity when Quote was e-signed' );
            }
        } */
    }
    
    // update the Quote Status for each Opportunity when the document has been e-signed
    public static void updateApplicationStatus(Set<Id> opportunityIds) {
        /* List<Application__c> appList = new ApplicationsSelector().selectByOpportunityIdList(opportunityIds);
        for (Application__c app : appList) {
            if (app.Application_Status__c == 'Pending') {
                app.Application_Status__c = 'Accepted';
            }
        }
        
        if (appList != null && !appList.isEmpty() &&  appList.size() > 0) {
            try{
                update appList;
            } catch(DMLException ex){
                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'DocumentTriggerFunctions', 'updateApplicationStatus', 'There was an error updating thr Application_Status__c field on Application when Application was e-signed' );
            }
        } */
    }
   
}