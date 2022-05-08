/**
* LiveChatTranscript Trigger logic class
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-11-13
*
*
* @Modified  muvhuso nekhubvu : Absa
* @since   2019-07-17
*
**/
public class LiveChatTranscriptTriggerFunctions {
    
    public static void mailTranscript( Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords ) {
        
        //List<Case> newLiveChatCases = new List<Case>();
        
        List<Messaging.SingleEmailMessage> outboundEmails = new List<Messaging.SingleEmailMessage>();
        List<Org_Wide_Lookup_Value__mdt> chatFrom = new OrgWideLookupValuesSelector().selectByLabel('LiveChatTranscript Email From Address');
        List<Org_Wide_Lookup_Value__mdt> chatHeader = new OrgWideLookupValuesSelector().selectByLabel('LiveChatTranscript Email Header');
        List<Org_Wide_Lookup_Value__mdt> chatFooter = new OrgWideLookupValuesSelector().selectByLabel('LiveChatTranscript Email Footer');
        
        Map<Id, LiveChatTranscript> liveChatUpdateMap = new Map<Id, LiveChatTranscript>();
		Map<Id, String> buttonNames = new Map<Id, String>();
        
        Set<Id> caseIDs = new Set<Id>();
        Map<Id, String> chatCaseNumbers = new Map<Id, String>();
        
        for(LiveChatButton buttonName :[Select MasterLabel From LiveChatButton]){
            buttonNames.put(buttonName.Id, buttonName.MasterLabel);
        }
        
        Id orgWideEmailId;
        
        if(!chatFrom.isEmpty()) {
        	orgWideEmailId = [Select Id From OrgWideEmailAddress Where Address = :chatFrom[0].value__c].Id;
        }else{
			orgWideEmailId = [Select Id From OrgWideEmailAddress limit 1].Id;
        }

        for( SObject obj :newRecords.values()) {
                       
            LiveChatTranscript livechatNew = (LiveChatTranscript)obj;
                        
            SObject oldObj = oldRecords.get(livechatNew.Id); 
            
            LiveChatTranscript livechatOld = (LiveChatTranscript)oldObj;
            
            if( ((livechatNew.Status != livechatOld.Status ) && livechatNew.Status == 'Completed' ) || Test.isRunningTest()) { 
                
                list<String> toAddress = new list<String> { livechatNew.Email__c };
                    
                Messaging.SingleEmailMessage outboundEmail = new Messaging.SingleEmailMessage();
                outboundEmail.setOrgWideEmailAddressId( orgWideEmailId );
                outboundEmail.setSubject('Live Chat Transcript - Reference number: ' + livechatNew.Name);
                outboundEmail.setTreatTargetObjectAsRecipient(false);
                outboundEmail.setToAddresses(toAddress);
                outboundEmail.setWhatId(livechatNew.Id);
                outboundEmail.setSaveAsActivity(false);

                //outboundEmail.setTemplateId(emailTemps[0].Id);
                
                //TEST
                String formattedTranscript = livechatNew.Body;
                formattedTranscript = formattedTranscript.replaceAll('<br>', '<br><br>');
                formattedTranscript = formattedTranscript + '<br><br>Warm Regards,<br>' + buttonNames.get(livechatNew.LiveChatButtonId);
                
                outboundEmail.setHtmlBody('<html>' + 
                                          '<img src="' + chatHeader[0].value__c + '" ' + 
                                          'alt="Company Logo" height="100" width="100"/><br>' +
                                          + formattedTranscript +
                                          '<br><br><img src="' + chatFooter[0].value__c + '" ' +
                                          'alt="Company Logo" height="100" width="800"/>' +
                                          '</html>'
                                         );
                
                outboundEmails.add(outboundEmail);
                
                liveChatUpdateMap.put(livechatNew.Id, livechatNew);
            }
        }
        
        if(!outboundEmails.isEmpty()){
            
            try{
                 Messaging.sendEmail( outboundEmails );
            }catch(Exception ex){
                System.debug('There was an error while sending out a live chat transcript to the client');
                AuditTrailLog.logException(ex, 'New', 'Error', 'LiveChatTranscriptTriggerFunctions', 'mailTranscript', 'Outbound Email Exception for Live Chat Transcript');
            }
           
            //Flag transcript object with succesful sending check
            for(Messaging.SingleEmailMessage eachEmail :outboundEmails) {
                
                if(liveChatUpdateMap.containsKey(eachEmail.whatId) ) {
                    
                    liveChatUpdateMap.get(eachEmail.whatId).Transcript_Emailed__c = true;  
                }
            }
        }
    }
    
    public static void createTask(Map<Id,sObject> newRecords , Map<Id, sObject> oldRecords){
        
        Set<String> chatKeys = new Set<String>();
        
        for( SObject obj :newRecords.values()) {
             
           LiveChatTranscript livechatNew = (LiveChatTranscript)obj;
           
           SObject oldObj = oldRecords.get(livechatNew.Id);
            
           LiveChatTranscript livechatOld = (LiveChatTranscript)oldObj;
            
           chatKeys.add(livechatNew.Email__c);
           
           System.debug('Email' + livechatNew.Email__c); 
           System.debug('Contact Id Email' + livechatNew);
           System.debug('Contact Id Email' + livechatOld);
            
            if(livechatNew == livechatOld){
                
                List<Contact> contactsRecords = new ContactsSelector().selectByEmail(chatKeys, 1); 
                
                List<Task> taskListTobeInserted = new List<Task>();
                
            	System.debug('Contacts' + contactsRecords.Size());
                
                if(!contactsRecords.isEmpty()){
                    
                    Contact contact = contactsRecords.get(0);
                    String userId = UserInfo.getUserId();
           			Task chatTask = new Task();
           			chatTask.OwnerId = userId;
           			chatTask.Subject = 'Live Web Chats';
           			chatTask.Status = 'Completed';
           			chatTask.Priority = 'Normal';
           			chatTask.ActivityDate = Date.today();
           			chatTask.WhoId = contact.Id;
                	chatTask.WhatId = livechatNew.Id;
           			taskListTobeInserted.add(chatTask);
                }
                
            	if(!taskListTobeInserted.isEmpty()){
                	insert taskListTobeInserted;
            	}
            } 
           
         }
    }
}