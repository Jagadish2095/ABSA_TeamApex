/** * @description       : EmailServiceForOpportunity
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-11
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
global class EmailServiceForOpportunity implements Messaging.InboundEmailHandler {
    /**
     * @description       : EmailServiceForOpportunity
     * @param  email
     * @param  envelope
     * @return Messaging.InboundEmailResult
    **/
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String threadId = EmailThreadId.getThreadId(email);
        If(threadId!= null){
            try{
                threadId = 'ref:'+threadId+':ref';
                Opportunity opp = [SELECT Id,Owner.Email,stagename FROM Opportunity WHERE Sys_ThreadId__c=:threadId LIMIT 1];
                if(opp != null && opp.stagename !='Closed' && opp.stagename !='Closed Lost (Customer Not Interested)'){
                    EmailCreateCase.createEmailMessage(email, envelope, opp.Id, 'Opportunity');
                    OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName='ABSA Do Not Reply' LIMIT 1];
                    EmailTemplate template = EmailOutboundService.getEmailTemplate('Investment_Opp_Customer_Template');
                    Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(template.Id, UserInfo.getUserId(), opp.Id);
                    EmailMessage emailMessagedata = [SELECT Id FROM EmailMessage WHERE RelatedToId =: opp.Id Order By Lastmodifieddate DESC LIMIT 1];
                    Messaging.SingleEmailMessage mail = new EmailOutboundService()
                        .setToAddress(opp.Owner.Email)
                        .setSubject(message.subject)
                        .setemailHtmlBody(message.htmlBody.replace('#massageLink',URL.getSalesforceBaseUrl().toExternalForm() + '/' + emailMessagedata.Id))
                        .setemailPlainTextBody(message.plainTextBody)
                        .setwhatId(opp.Id)
                        .setReplyTo('noreplay@salesforce.com')
                        .setorgWideAddressId(owa.Id)
                        .build();
                    Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
                    TriggerDispatcher.skip(TriggerHandlerOpportunity.class.getName());
                    update new Opportunity(Id=opp.Id,Sub_Status__c='Customer Responded',Sys_BypassValidation__c=true);
                }
            }
            catch(Exception ex){
                AuditTrailLog.logException(ex, 'New', 'Info', 'EmailServiceForOpportunity', 'handleInboundEmail', ex.getMessage());
            }
        }
        result.success = true;
        return result;
    }
}