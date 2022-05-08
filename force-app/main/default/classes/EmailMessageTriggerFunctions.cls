/**
* Functions class for EmailMessageTrigger
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2018-11-23
*
**/
public class EmailMessageTriggerFunctions {
    
    public static void blockEmailDeleteOnCases (List<EmailMessage> oldRecords) {
        
        for(EmailMessage eachEmailMessage : oldRecords) {
            //Get ParentId object Name
            String parentIdObjectName = String.ValueOf(eachEmailMessage.ParentId.getsobjecttype());
            //Throw exception to block Email Message deletion if parentId is a Case
            if(parentIdObjectName == 'Case') {
                eachEmailMessage.AddError('You are not allowed to delete Emails linked to Cases, please contact your System Administrator');
            }
        }      
    }
    
    public static void ReassignCase (List<EmailMessage> newRecords) {
        
        list<case> updateCases = new list<case>();
        
        for(EmailMessage eachEmailMessage : newRecords) {
            
            if(String.isNotBlank(eachEmailMessage.ThreadIdentifier) && String.isNotBlank(eachEmailMessage.ParentId)){
                
            	if( eachEmailMessage.Incoming == true && eachEmailMessage.ParentId != null  && eachEmailMessage.ParentId.getsobjecttype() == Case.getsobjecttype()){
                   
                   Map<String,id>QueueIds = new  Map<String,id>();
                   
                   for(OmniChannelQue__mdt Que :[Select MasterLabel, sd_Original_Service_QueueId__c from OmniChannelQue__mdt]){
                       QueueIds.put(Que.MasterLabel, Que.sd_Original_Service_QueueId__c);
                   } 
                   
                   list<Case> listcases = [Select id, OwnerId, sd_Original_Service_Queue__c From Case Where id =: eachEmailMessage.ParentId 
                                           And Status = 'In Progress' And sd_Original_Service_Queue__c=:QueueIds.keySet() And HasLogin__c = false LIMIT 1];
                   
                   if(!listcases.IsEmpty()){
                       for(Case cse :listcases){
                           if(cse.OwnerId.getsobjecttype()== User.sobjecttype){
                               cse.OwnerId =  QueueIds.get(cse.sd_Original_Service_Queue__c);
                               updateCases.add(cse);
                           }
                       }
                   } 
                   if(!updateCases.IsEmpty())
                        update updateCases;
                      
               }else{
                continue;   
               }   
            }
        }
    } 
    public static void CloseCase (List<EmailMessage> emailRecords) {
        try{
            
            List<case> casesListToBeUpdated = new List<Case>();
            Map<String,String> emailMessageMapToCase = new Map<String,String>();
            set<String> caseIdsToEmailSet = new set<String>();
            for(EmailMessage em: emailRecords){
                if(em.ParentId != null && em.Incoming==false && em.Is_Auto_Response__c==false ){
                   caseIdsToEmailSet.add(em.parentId);
                }         
             }
           
            If(!caseIdsToEmailSet.isEmpty()){
                 List<case> casesList =new CasesSelector().casesListForEmailsSend(caseIdsToEmailSet);
                 for(case c : casesList){
                 if(Schema.SObjectType.Case.getRecordTypeInfosById().get(c.recordtypeId).getDevelopername() =='Service_Request'){
                    if(c.Status!='On Hold'){
                        if((c.accountId == null || c.Type__c  == null) && c.parentId ==null){
                               emailMessageMapToCase.put(c.id,'Classify/FindClient');
                               //c.addError('Test Error');
                        }else if(c.ParentId ==null && c.External_SLA_Status__c =='Overdue' && (c.Out_Of_SLA_Reason__c== null || c.Out_Of_SLA_Comments__c ==null)){
                            system.debug('enteredddd');
                            emailMessageMapToCase.put(c.id,'SLAOverdue');
                        }
                        else{
                            c.status='Closed';
                            casesListToBeUpdated.add(c); 
                        }
                      }
                    } 
                }  
            }
          
            if(emailMessageMapToCase !=null){
                for(EmailMessage emilMsg : emailRecords){
                      if(emailMessageMapToCase.containsKey(emilMsg.parentId) && emailMessageMapToCase.get(emilMsg.parentId) =='Classify/FindClient'){
                        emilMsg.addError(StringConstants.ERROR_MSG_CLASSIFY_FINDCLIENT ); 
                    }
                    if(emailMessageMapToCase.containsKey(emilMsg.parentId) && emailMessageMapToCase.get(emilMsg.parentId) =='SLAOverdue'){
                         emilMsg.addError(StringConstants.ERROR_MSG_SLAOVERDUE );  
                    }
                    emilMsg.Is_Auto_Response__c=true;
                    
                }
            }
            if(!casesListToBeUpdated.isEmpty()){
                update casesListToBeUpdated;
                }
         
          }catch(exception e){
            system.debug('****Exception *********'+e);
            system.debug('****Exception lineNumber*********'+e.getLineNumber());
        }
    }
}