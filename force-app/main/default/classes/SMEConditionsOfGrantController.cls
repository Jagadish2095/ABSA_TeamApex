public class SMEConditionsOfGrantController {

    @AuraEnabled
    public static Application__c getApplicationDetails(Id oppId) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        return app;
    }
    @AuraEnabled
    public static List<Application_Condition__c> getApplicationConditions(Id oppId) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Condition__c> appconditionList = new List<Application_Condition__c>([SELECT Id,Type__c FROM Application_Condition__c where application__c =:app.id]);
        return appconditionList;
    }
    @AuraEnabled
    public static void deleteApplicationConditions(Id appCondition) {
        Application_Condition__c appconditionrec = new Application_Condition__c();
        appconditionrec.id=appCondition;
        delete appconditionrec;
    }
    @AuraEnabled
    public static map<String,Id> getApplicationConditionsRecordTypes() {
    map<String,Id>  recordtypemap =  new map<String,Id>(); 
    Schema.DescribeSObjectResult d = Schema.SObjectType.Application_Condition__c;
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    recordtypemap.put('CustomerCondition',rtMapByName.get('Customer Condition').getrecordtypeId());
    recordtypemap.put('InternalCondition',rtMapByName.get('Internal Condition').getrecordtypeId());
     return recordtypemap;   
    }
}