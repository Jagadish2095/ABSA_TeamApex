/**
* @description Apex invocable class for the Email Sending
*
* @author   Anu
* @since   2021-09-20
* Modification log :
**/
public with sharing class AIC_Case_SendEmailOfProcessBuilder {
    /**
     * @description sendEmailTOCase description
     *@param caseId List<Id>
     *
     */
    @InvocableMethod
    public static void sendEmailTOCase(List<Id> caseId){
        
        if(caseId.size() != 0){
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>(); 
            Map<String,Id> emailTemplateMap = new Map<String,Id>();
            for(EmailTemplate emailTemplateObj : [Select Id,name from EmailTemplate where name IN ('US_Email: Outbound Outcome: Uncontactable Individuals','US_Email: Outbound Outcome: Uncontactable Complex Entities','US_Email: Outbound Outcome: Escalated Individuals','US_Email: Outbound Outcome: Escalated Complex Entities'
                                                                                                  ,'US_Email: AIC Standard Individual Template','US_Email: AIC Standard Complex Entity Template','AIC:Outbound Outcome: Call Back Individuals','AIC:Outbound Outcome: Call Back Complex Entities',
                                                                                                  'US_Email: Outbound Outcome: Invalid Number Individuals','US_Email: Outbound Outcome: Invalid Number Complex Entities',
                                                                                                  'US_Email: Outbound Outcome: Referred Individuals','US_Email: Outbound Outcome: Referred Complex Entities')]){
                emailTemplateMap.put(emailTemplateObj.name,emailTemplateObj.Id);
            }
            List<Contact> conList=[select id,email from Contact where email!=null limit 1];
            OrgWideEmailAddress[] orgEmailAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'ficahelp@absa.co.za'];
            for(Case caseObj : [Select id,status,accountID, Account.PersonEmail,Account.Active_Email__c, ContactId,Account.IsPersonAccount,DD_Case_Outcome__c From Case where Id IN :caseId]){
                if(caseObj.accountId != null && (caseObj.Account.PersonEmail != null || caseObj.Account.Active_Email__c !=null)){
                    Id emailTemplateId;
                    List<String> toAddress = new List<String>();
                    if(caseObj.Account.IsPersonAccount == true){
                        toAddress.add(caseObj.Account.PersonEmail); 
                        if(caseObj.DD_Case_Outcome__c == 'Invalid Number'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Invalid Number Individuals');
                        }
                        else if(caseObj.status=='Awaiting Documents'){
                           emailTemplateId = emailTemplateMap.get('US_Email: AIC Standard Individual Template'); 
                        }
                        else if(caseObj.status=='New'){
                            emailTemplateId = emailTemplateMap.get('US_Email: AIC Standard Individual Template'); 
                        }
                        else if(caseObj.status == 'Unable to Reach Customer' || caseObj.DD_Case_Outcome__c =='Uncontactable'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Uncontactable Individuals');
                        }else if(caseObj.status == 'Escalated'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Escalated Individuals');
                        }else if(caseObj.status == 'Pending Call' || caseObj.DD_Case_Outcome__c == 'Call Back' || caseObj.DD_Case_Outcome__c == 'Call Successful'){
                            emailTemplateId = emailTemplateMap.get('AIC:Outbound Outcome: Call Back Individuals');  
                        }else if(caseObj.status=='Referred'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Referred Individuals'); 
                        }
                    }else{
                     toAddress.add(caseObj.Account.Active_Email__c); 
                        if(caseObj.DD_Case_Outcome__c == 'Invalid Number'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Invalid Number Complex Entities');
                        }
                        else if(caseObj.status=='Awaiting Documents'){
                            emailTemplateId = emailTemplateMap.get('US_Email: AIC Standard Complex Entity Template'); 
                        }
                        else if(caseObj.status=='New'){
                            emailTemplateId = emailTemplateMap.get('US_Email: AIC Standard Complex Entity Template'); 
                        }
                        else if(caseObj.status == 'Unable to Reach Customer' || caseObj.DD_Case_Outcome__c =='Uncontactable'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Uncontactable Complex Entities');
                        }else if(caseObj.status == 'Escalated'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Escalated Complex Entities');
                        }else if(caseObj.status == 'Pending Call' || caseObj.DD_Case_Outcome__c == 'Call Back' || caseObj.DD_Case_Outcome__c == 'Call Successful'){
                            emailTemplateId = emailTemplateMap.get('AIC:Outbound Outcome: Call Back Complex Entities');
                        }else if(caseObj.status=='Referred'){
                            emailTemplateId = emailTemplateMap.get('US_Email: Outbound Outcome: Referred Complex Entities'); 
                        }
                    }
                    if(emailTemplateId != null && conList.size()>0){
                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                        message.setToAddresses(toAddress);
                        message.setReplyTo(System.Label.AIC_Email_to_Case_Id);
                        message.setTargetObjectId(conList[0].id); 
                        message.setTemplateId(emailTemplateId); 
                        message.setTreatTargetObjectAsRecipient(false); 
                        if(orgEmailAddress.size() > 0){
                          message.setOrgWideEmailAddressId(orgEmailAddress.get(0).Id);  
                        }
                        message.setWhatId(caseObj.Id); 
                        message.setBccSender(false); 
                        message.setUseSignature(false); 
                        message.setSaveAsActivity(true);
                        messages.add(message);
                    }  
                }
            }
            if(messages.size() > 0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if(results.size()>0){
            if (results[0].success){
                list<EmailMessage> emailMsgList = new list<EmailMessage>();
                if(messages.size() > 0){
                    for(Messaging.SingleEmailMessage eachEmail : messages){
                        //Create Email Message - to store on Case
                        EmailMessage emailMsg = new EmailMessage();
                        emailMsg.ToAddress=(eachEmail.getToAddresses()[0]);
                        emailMsg.Subject=eachEmail.getSubject();
                        emailMsg.HtmlBody=eachEmail.getHtmlBody();
                        emailMsg.ParentId = eachEmail.getWhatId();
                        emailMsg.MessageDate = system.now();
                        emailMsg.Status = '0';
                        emailMsg.Is_Auto_Response__c = true;
                        emailMsgList.add(emailMsg);
                    }
                    /*try {
                        if (emailMsgList.size() > 0) {
                           // insert emailMsgList;
                        }
                    } catch (DMLException e) {
                        AuditTrailLog.logException(e,'New','Warning','Case_Trigger_Functions','emailResponse','There was an error while inserting the Case email message Task');
                    }*/
            } else {               
            }  
            }
        }
            }
    }
}
}