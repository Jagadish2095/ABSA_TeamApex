public class OmniChannelController {
    
    @AuraEnabled
    public static void RassignCase(){
        
        List<case> casesToRassign = new List<case>();
         Map<String,Id> ServiceQueue = new  Map<String,Id>();
        
          for(OmniChannelQue__mdt Que :[Select MasterLabel, sd_Original_Service_QueueId__c from OmniChannelQue__mdt]){
            ServiceQueue.put(Que.MasterLabel, Que.sd_Original_Service_QueueId__c);
        }
        
       list<Case> caseList = [SELECT id, OwnerId, sd_Original_Service_Queue__c FROM Case WHERE OwnerId  =: userInfo.getUserId() And Status = 'New' 
                                                   And sd_Original_Service_Queue__c =:ServiceQueue.keySet()];
        
       if(!caseList.isEmpty()){
           Set<id> QueueIds = new Set<Id>();
        
           for( Case caseToRassign :caseList){
               
               caseToRassign.OwnerId = ServiceQueue.get(caseToRassign.sd_Original_Service_Queue__c);
               casesToRassign.add(caseToRassign);
           }
           
           Update casesToRassign;
           
        }
        
        User u  = [Select id, Haslogin__c From User where Id =:userInfo.getUserId()];
        u.Haslogin__c = false;
        Update u;
    } 
    
     @AuraEnabled
    public static void LoginOnOmniChannel(String statusId){
        
        User u  = [Select id, Haslogin__c From User where Id =: statusId];
        u.Haslogin__c = true;
        Update u;
        
    } 
}