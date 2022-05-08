public class CaseMilestoneCtrl {
    
    @AuraEnabled	  
    public static List<Case> fetchCaseSLADate(String recId){
        List<String> topJobList = new List<String>();
        for(Top_Jobs__mdt jobmdt: [SELECT Job__c FROM Top_Jobs__mdt]){
            topJobList.add(jobmdt.Job__c);
        }
          
        return 
            [
            Select 
                Id,
                Internal_SLA_End_Date__c,
                CreatedDate
            From 
            	Case 
            Where
            	id =: recId
            And
                Type__c IN :topJobList
           ];
    }
}