/**
 *
 * @author  Anu Dhaka
 * @since   2021-09
 * @description : AIC_Case_transferController
**/
public with sharing class AIC_Case_transferController {

    /**
     * @comment : getSelectListData
     * @description get the Department and Queue List
     *
     * @return mapOfData
     * */
    @AuraEnabled
    public static String getSelectListData() {

        Map<String,List<Map<String,String>>> mapOfData = new   Map<String,List<Map<String,String>>>();
        for(Group gp : [Select Id,Name,Type From Group where Type ='Queue' AND  Name LIKE '%AIC' ]){
            If(mapOfData.get('Queue') == null ){
                mapOfData.put('Queue', new List<Map<String,String>>());
            }
            Map<String,String> mapObj = new Map<String,String>();
            mapObj.put('Key',gp.Name);
            mapObj.put('value',gp.id);
            mapOfData.get('Queue').add(mapObj);
        }
        return JSON.serialize(mapOfData);
    }

        /**
     * @comment : transferCase
     * @description method used to transfer cases
     * @param transfertype
     * @param commentmsg
     * @param caseId
     * @return result
     * */
        @AuraEnabled
        public static String transferCase(String transfertype, String commentmsg , String caseId) {
            Case caseObj = [Select id,status,accountID, Account.PersonEmail,Account.Active_Email__c, ContactId,Account.IsPersonAccount From Case where Id = :caseId];
            Group QueueObj = [Select Id, Name, DeveloperName From Group where Type = 'Queue' and id =:transfertype];
            
            caseObj.OwnerId = QueueObj.Id;
            update caseObj;
    
            CaseComment casecmt = new CaseComment();
            casecmt.CommentBody = commentmsg;
            casecmt.ParentId = caseObj.Id;
            insert casecmt;
    
            
            If(caseObj.Account.PersonEmail != null || caseObj.Account.Active_Email__c!=null){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.setSaveAsActivity(false);   
                message.setTargetObjectId(caseObj.ContactId);
                EmailTemplate emailTemplate;
                If(QueueObj.DeveloperName == 'Awaiting_Documents_AIC' && caseObj.Account.PersonEmail != null){
                    emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'US_Email: Outbound Outcome: Uncontactable Individuals']; 
                    message.setToAddresses(new String[] {caseObj.Account.PersonEmail});  
                }
                else if(QueueObj.DeveloperName == 'Awaiting_Documents_AIC' && caseObj.Account.Active_Email__c != null){
                    emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'US_Email: Outbound Outcome: Uncontactable Complex Entities'];
                    message.setToAddresses(new String[] {caseObj.Account.Active_Email__c});   
                }
                if(emailTemplate.id != null){
                    message.setTemplateID(emailTemplate.Id); 
                    message.setWhatId(caseObj.Id); 
                    Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message}; 
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                    if (results[0].success){
                        EmailMessage emailMessage = new EmailMessage(); 
                        emailMessage.ToAddress = caseObj.Account.PersonEmail!=null ? caseObj.Account.PersonEmail : caseObj.Account.Active_Email__c;
                        emailMessage.Subject = message.getSubject();
                        emailMessage.HtmlBody = message.getHtmlBody();
                        emailMessage.ParentId = caseObj.Id;
                        emailMessage.MessageDate = System.now();
                        emailMessage.Status = '0';
                        emailMessage.Is_Auto_Response__c = true;
                        insert emailMessage;
                    } else {
                    }  
                }      
            }
            
            return 'SUCCESS';
        }

            /**
     * @comment : transferCase
     * @description method used to departmentCase
     * @param departmentName string 
     * @param emailId string 
     * @param commentDepartment string
     * @param emailContent string 
     * @param caseId string
     * @return result
     * */
    @AuraEnabled
    public static String departmentCase(String departmentName, String emailId, String commentDepartment, String emailContent, String caseId) {
        Case caseObj = [Select Id, OwnerId,accountID,status,Account.PersonEmail,ContactId from Case where Id =: caseId];
        
        CaseComment casecmt = new CaseComment();
        casecmt.CommentBody = commentDepartment;
        casecmt.ParentId = caseObj.Id;
        insert casecmt;
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new String[] {emailId}); 
        message.setSaveAsActivity(false);   
        message.setWhatId(caseObj.Id); 
        message.setSubject('Department Information');
        message.setHTMLBody(emailContent);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message}; 
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success){

            EmailMessage emailMessage = new EmailMessage(); 
            emailMessage.ToAddress = emailId;
            emailMessage.Subject = message.getSubject();
            emailMessage.HtmlBody = message.getHtmlBody();
            emailMessage.ParentId = caseObj.Id;
            emailMessage.MessageDate = System.now();
            emailMessage.Status = '0';
            emailMessage.Is_Auto_Response__c = true;

            insert emailMessage;
        } else {
        }  
        
        return 'SUCCESS';
    }
    
}