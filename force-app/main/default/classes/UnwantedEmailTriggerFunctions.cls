/**
* Helper class for the UnwantedEmailTrigger
* Converts all unwanted emails to support cases if flagged by a user
* from the list view
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-10-10
*
**/

public class UnwantedEmailTriggerFunctions {
    
    public static void convertToCase( List<Unwanted_Email__c> convertEmails ){
        
        List<Case> insertCases = new List<Case>();
        
        for(Unwanted_Email__c emailmsg :convertEmails){
            
            if( emailmsg.Convert_To_Case__c && String.isNotBlank( emailmsg.Service_Group_Search__c )  ){
                
                Case newCase = new Case();
                
                newCase.Subject = emailmsg.Subject__c;
                
                String htmlBody = emailmsg.Email_Body__c;
                     
                newCase.Description = htmlBody.stripHtmlTags();
               
                newCase.Email_From_Address__c = emailmsg.From_Address__c;
                newCase.Email_From_Name__c = emailmsg.Sender_Name__c;
                newCase.Status = 'New';

                Set<Id> idSet = new Set<Id>();
                idSet.add(emailmsg.Service_Group_Search__c);
                
                List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(idSet);
                
                if(!serviceGroupTypes.isEmpty()){
                    
                    List<Group> queueIds = new GroupsSelector().selectByNameAndType(serviceGroupTypes[0].Service_Group__r.Queue__c, 'Queue');
               
                    if(!queueIds.isEmpty()){
                        newCase.ownerId = queueIds[0].id;
                    }

                    newCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                    newCase.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
                    newCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
                    newCase.sd_Service_Group_Id__c = emailmsg.Service_Group_Search__c;
                    newCase.sd_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                    newCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
                    newCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
                    newCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
                    newCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
                    newCase.Internal_SLA_Notification_User__c  = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;     
                    newCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                }
 
                insertCases.add(newCase);
            }
        }
        
        try{
            
            insert insertCases;
            
        }catch(DMLException ex){
            
            System.debug(ex.getMessage());
            AuditTrailLog.logException(ex,  'New', 'Error', 'UnwantedEmailTriggerFunctions', 'convertToCase', 'Unable to insert new cases converted form unwanted emails');
        }
    }
}