/**
 * @description       : Trigger handler to insert application security records 
 * @author            : Gulafsha
 * @last modified on  : 2021-06-12
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-06-10   Gulafsha   Initial Version
**/
public class TriggerHandlerApplicationprofile extends TriggerHandler{
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
        System.debug('TriggerHandler : afterInsert');
        Map<Id, Application_Profile__c> accTriggerNew = (Map<Id, Application_Profile__c>)newRecords;
        Map<Id, Application_Profile__c> newRecords1 = new Map<Id, Application_Profile__c>();
        Set<Id> ApplicationProfileIds = new Set<Id>();

        for(Application_Profile__c aprofile:accTriggerNew.values()) {
            If(aprofile.Client_CIF_Code__c != null) {
               ApplicationProfileIds.add(aprofile.Id);
                
               
            }
        }

        ClientSecuritiesControllerNew ClientSecurities = new ClientSecuritiesControllerNew(ApplicationProfileIds);
        Id JobId = System.enqueueJob(ClientSecurities);

       /* ClientSecuritiesControllerNew.securities(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesSuretyS(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesCLA(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesCessionLLP(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesCessionNoLLP(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesCOD(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesCogP(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesCoiI(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesCOS(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesDematS(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesLoU(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesASVGCV1(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesASVCessionS(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesASVCessionFSTI(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesASVCessionEI(ApplicationProfileIds);
        ClientSecuritiesControllerNew.securitiesASVHoldsVI(ApplicationProfileIds); */
    }
}