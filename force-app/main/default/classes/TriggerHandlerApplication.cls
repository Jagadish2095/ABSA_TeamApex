/**
* Handler for the Application trigger
* @author  Prashant Jain
* @created 2020-06-04
*/

public with sharing class TriggerHandlerApplication extends TriggerHandler{

    public virtual override void afterUpdate(Map<Id, sObject> triggerNew, Map<Id, sObject> triggerOld) {
        //Cast sObject maps to Application maps
        Map<Id, Application__c> appTriggerNew = (Map<Id, Application__c>)triggerNew;
        Map<Id, Application__c> appTriggerOld = (Map<Id, Application__c>)triggerOld;

        List<Application__c> listNewApplications = convertMapToList(appTriggerNew);

        for(Application__c application : listNewApplications){
            //Check if QA Status has changed and is Approved
            if(appTriggerOld.get(application.Id).QA_Status__c != application.QA_Status__c && application.QA_Status__c == StringConstants.MERCHANT_APPLICATION_QA_STATUS_APPROVED) {
                //D Booysen: 20200701
                //Instantiate a new instance of the Queueable class
                MerchantManagement createMASSAccountQueueable = new MerchantManagement(application.Opportunity__c);
                //Enqueue the job for processing
                Id jobId = System.enqueueJob(createMASSAccountQueueable);
                System.debug('TriggerHandlerApplication.afterUpdate.createMASSAccountQueueable jobId: ' + jobId);
            }
        }
    }

    /**
     * Method that converts Map of values into a List
     *
     * @param triggerMap Map of values
     *
     * @return List of applications from map values
     */
    private static List<Application__c> convertMapToList(Map<Id, Application__c> triggerMap){
        List<Application__c> applications = new List<Application__c>();
        for(Application__c application : triggerMap.values()){
            applications.add(application);
        }
        return applications;
    }
}