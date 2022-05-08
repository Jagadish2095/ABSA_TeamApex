public class ContactLookupController {
    
    @AuraEnabled
    public static List < sObject > fetchContactRecords(String searchKeyWord, String ObjectName, String accountId) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Salutation,Name,FirstName,LastName,Initials__c,Phone,MobilePhone,Birthdate,Email,Alternate_Phone1__c,Alternate_Phone2__c,Alternate_Phone3__c,ID_Type__c,ID_Number__c from ' +ObjectName + ' where Name LIKE :searchKey AND AccountId = :accountId order by createdDate DESC limit 5';
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
@InvocableMethod
    public static void sendEmailToQueueMembers(List<string> newLeads){
        //Id leadRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType='Lead' AND RecordType.DeveloperName='STI_Lead'].Id;
        //List<Lead> leadsToMail = [Select Id,RecordTypeId,Owner_Type__c,AIC_Relationship_Consultant_Name__c,Lead_Email__c];
        Set<Id> idset = new set<Id>();
       for(string data:newLeads){
            idset.add(data);
        }
        LeadsSelector lselector = new LeadsSelector();
        List<Lead> finalLeads = lselector.selectLeadById(idset);
        OrgWideEmailAddress owd =[Select Id, Address From OrgWideEmailAddress where Address='virtualshortterm@absa.co.za'];
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('STI_Lead').getRecordTypeId();
        List<EmailTemplate> emailTemps = [Select Id, DeveloperName From EmailTemplate Where DeveloperName = 'MVP2_Queue_Email'];
        List<EmailTemplate> emailTempsAck = [Select Id, DeveloperName From EmailTemplate Where DeveloperName = 'Short_term_Insurance_Lead_acknowledgement_and_assignment'];
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        
        
        for(Lead data:finalLeads){
            if(data.RecordTypeId == leadRecordTypeId && 
               data.Owner_Type__c == 'Queue'){
                //   Group Mg= [SELECT (select userOrGroupId from groupMembers) FROM group WHERE name ='VAQueueEmailMembersGroup'];
                   //List<string> toAddress=getMailAddresses();
                   string CAFBanker_Email = data.Lead_Email__c;//new change
                   string VirtualShorttermMail = system.Label.VA_mail;   

                  
                   String emailTemplateName = '';
                   Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
                   
                   if(emailTemps <> null && emailTemps.size() > 0){
                       emailOut.setOrgWideEmailAddressId(owd.Id);
                       emailOut.setTargetObjectId(data.Id);
                       emailOut.setTreatTargetObjectAsRecipient(false);
                       emailOut.setToAddresses(new List<String>{CAFBanker_Email});
                       emailOut.setCcAddresses(new List<String>{VirtualShorttermMail});//new change
                       emailOut.setSaveAsActivity(true); 
                       emailOut.setTemplateId(emailTemps[0].Id);
                       emailsOutList.add(emailOut);
                   }
               }else if(data.RecordTypeId == leadRecordTypeId && data.Owner_Type__c == 'User' &&
              			 string.isNotEmpty(data.AIC_Relationship_Consultant_Name__c)){
                             
                string AIC_Email = data.AIC_Relationship_Consultant_Name__c.split('\\(')[1].split('\\)')[0];
                string AIC_Name = data.AIC_Relationship_Consultant_Name__c.split('\\(')[0];
                String userEmail = data.Lead_Email__c;
                String emailTemplateName = '';
                Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();
                
                if(emailTempsAck <> null && emailTempsAck.size() > 0){
                    emailOut.setOrgWideEmailAddressId(owd.Id);
                    emailOut.setTargetObjectId(data.Id);
                    emailOut.setTreatTargetObjectAsRecipient(false);
                    emailOut.setToAddresses(new list<String> {userEmail});
                    emailOut.setCcAddresses(new List<String>{AIC_Email,data.Owner.Email});
                    emailOut.setSaveAsActivity(true); 
                    emailOut.setTemplateId(emailTempsAck[0].Id);
                    emailsOutList.add(emailOut);
                }
                   
                   
               }
        }
        if(!emailsOutList.isEmpty()){
            system.debug('emailsOutList'+emailsOutList);
            Messaging.sendEmail(emailsOutList);
        }
    }
    
   public static List<String> getMailAddresses(){   
        List<String> idList = new List<String>();   
        List<String> mailToAddresses = new List<String>();    
        Group gp = [SELECT (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Name = 'VAQueueEmailMembersGroup' limit 1];   
        for (GroupMember gm : gp.GroupMembers) {   
            idList.add(gm.UserOrGroupId); 
        }   
        List<User> userList = [SELECT Email FROM User WHERE Id IN :idList]; 
        for(User u : userList) {  
            mailToAddresses.add(u.email);   
        }    
        return mailToAddresses;
    }
    
   
 
    
}