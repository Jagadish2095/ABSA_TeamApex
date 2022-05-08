/**
 * @description       : EmailActivityTracker
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public class EmailActivityTracker {
    /**
	 * @description send Email
	 * @param  FlowInputs
	 */
    @InvocableMethod(label='email sending' description='Email audit purpose')
    public static void sendEmail(List<FlowInputs> FlowInputs){
        if(String.isNotBlank(FlowInputs[0].templateName)){
            OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName='SVC-Virtualadviser' LIMIT 1];
            Id contactId = [SELECT Id FROM Contact WHERE AccountId =: FlowInputs[0].AccountId LIMIT 1].Id;
            EmailTemplate template = EmailOutboundService.getEmailTemplate(FlowInputs[0].templateName);
            Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(template.Id, UserInfo.getUserId(), FlowInputs[0].OpportunityId);
            Messaging.SingleEmailMessage mail = new EmailOutboundService()
                .setSubject(template.Subject)
                .setemailHtmlBody(message.getHtmlBody())
                .setemailPlainTextBody(message.getPlainTextBody())
                .setTargetId(contactId)
                .setwhatId(FlowInputs[0].OpportunityId)
                .setorgWideAddressId(owa.Id)
                .setReplyTo('noreplay@salesforce.com')
                .build();
            Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
        }
    }
    /**
     * @description       : EmailActivityTracker
     * @author            : Vinod.Thupakula@absa.africa
     * @last modified on  : 2021-11-09
     * @last modified by  : Vinod.Thupakula@absa.africa
    **/
    public class FlowInputs{

        @InvocableVariable
        public Id OpportunityId;

        @InvocableVariable
        public Id AccountId;

        @InvocableVariable
        public String templateName;

    }
}