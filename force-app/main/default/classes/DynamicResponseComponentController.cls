/*Thabo K Senkomane
* April 2020
* For bank codes Registrations/Requests
* */
public class DynamicResponseComponentController {
    @AuraEnabled
    public static string getCaseData(Id recordId){
        Set<Id> caseSetId = new Set<Id>();
        caseSetId.add(recordId);
        List<Case> caseList = new CasesSelector().selectById(caseSetId);
        if(caseList != null && caseList.size() > 0) {
            return caseList[0].Response_Body__c;
        } else {
            return null;
        } 
    }
    
    @AuraEnabled
    public static string getAllResponseRecords(Id recordId){
        Set<Id> caseSetId = new Set<Id>();
        caseSetId.add(recordId);
        List<Case> caseList = new CasesSelector().selectById(caseSetId);
        
        if(caseList != null && caseList.size() > 0) {
            return caseList[0].Extended_Request_Data__c;
        } else {
            return null;
        } 
    }
}