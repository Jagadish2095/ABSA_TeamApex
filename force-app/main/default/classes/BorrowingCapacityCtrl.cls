/**
 * @description       : Controller class for BorrowingCapacity aura component
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-07
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log 
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-07   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)   Initial Version
**/

public class BorrowingCapacityCtrl {
    
    /**
    * @description Method to retrieve Application Scoring CPF record Id
    * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-07 
    * @param opportunityId 
    * @return Id 
    **/
    @AuraEnabled(Cacheable=true)
    public static Id getApplicationScoringRecordId(Id opportunityId){
        List<Application_Scoring__c> appScoringRecords = new ApplicationScoringSelector().selectBorrowingCapacityByOpportunityId(opportunityId);

        if(appScoringRecords != null && appScoringRecords.size() > 0){
            return appScoringRecords[0].Id;
        }

        return null;
    }
}