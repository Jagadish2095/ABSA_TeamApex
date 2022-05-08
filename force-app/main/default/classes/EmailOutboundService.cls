/**
 * @description       : EmailOutboundService
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-24
 * @last modified by  : Vinod.Thupakula@absa.africa
**/

public class EmailOutboundService {
    public List<String> toAddress;
    public List<String> bccAddresses;
    public List<String> ccAddresses;
    public String subject;
    public String emailPlainTextBody;
    public String emailHtmlBody;
    public String replyTo;
    public String orgWideAddressId;
    public String targetId;
    public String whatId;
    public List<Id> contentVersionIds;
    /** @description setToAddress
     * @param toAddress
     * @return EmailOutboundService
     **/
    public EmailOutboundService setToAddress(String toAddress) {
        if (this.toAddress == null) {
            this.toAddress = new List<String>();
        }
        if(String.isNotBlank(toAddress))this.toAddress.add(toAddress);
        return this;
    }
    /** @description setTargetId
     * @param targetId
     * @return EmailOutboundService
     **/
    public EmailOutboundService setTargetId(Id targetId) {
        this.targetId = targetId;
        return this;
    }
    /** @description setWhatId
     * @param whatId
     * @return EmailOutboundService
     **/
    public EmailOutboundService setWhatId(Id whatId){
        this.whatId = whatId;
        return this;
    }
    /** @description setToAddress
     * @param toAddress
     * @return EmailOutboundService
     **/
    public EmailOutboundService setToAddress(List<String> toAddress) {
        this.toAddress = toAddress;
        return this;
    }
    /** @description setEmailHtmlBody
     * @param emailHtmlBody
     * @return EmailOutboundService
     **/
    public EmailOutboundService setEmailHtmlBody(String emailHtmlBody) {
        this.emailHtmlBody = emailHtmlBody;
        return this;
    }
    /** @description setEmailPlainTextBody
     * @param emailPlainTextBody
     * @return EmailOutboundService
     **/
    public EmailOutboundService setEmailPlainTextBody(String emailPlainTextBody) {
        this.emailPlainTextBody = emailPlainTextBody;
        return this;
    }
    /** @description setSubject
     * @param subject
     * @return EmailOutboundService
     **/
    public EmailOutboundService setSubject(String subject) {
        this.subject = subject;
        return this;
    }
    /** @description setorgWideAddressId
     * @param orgWideAddressId
     * @return EmailOutboundService
     **/
    public EmailOutboundService setorgWideAddressId(String orgWideAddressId) {
        this.orgWideAddressId = orgWideAddressId;
        return this;
    }
    /** @description getRelatedFileAttachments
     * @param contentDocumentids
     * @return EmailOutboundService
     **/
    public EmailOutboundService getRelatedFileAttachments(Set<Id> contentDocumentids) {
        if (contentDocumentids!= null && contentDocumentids.isEmpty()) {
            return this;
        }
        if (this.contentVersionIds == null) {
            this.contentVersionIds = new List<Id>();
        }
        for (ContentVersion cversion : [SELECT Id FROM contentversion
                                        WHERE ContentDocumentId IN :contentDocumentids AND FileType != 'SNOTE' AND IsLatest=true])
        {
            this.contentVersionIds.add(cversion.Id);
        }
        return this;
    }
    /** @description setReplyTo
     * @param replyTo
     * @return EmailOutboundService
     **/
    public EmailOutboundService setReplyTo(String replyTo) {
        this.replyTo = replyTo;
        return this;
    }
    /** @description build
     * @return Messaging.SingleEmailMessage
     **/
    public Messaging.SingleEmailMessage build() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if (this.toAddress == null && this.targetId ==null) {
            throw new SupportException('Not able to build a SingleEmailMessage object without a sendTo field');
        }
        if (this.subject == null) {
            throw new SupportException('Not able to build a SingleEmailMessage object without a subject field');
        }
        if (this.replyTo == null) {
            throw new SupportException('Not able to build a SingleEmailMessage object without a replyTo field');
        }
        if (this.emailPlainTextBody == null) {
            throw new SupportException('Not able to build a SingleEmailMessage object without an emailBody field');
        }
        mail.setUseSignature(false);
        if(this.toAddress != null && !this.toAddress.isEmpty()){
            mail.setToAddresses(this.toAddress);
        }
        mail.setSubject(this.subject);
        mail.setReplyTo(this.replyTo);
        mail.setPlainTextBody(this.emailPlainTextBody);

        if(String.isNotBlank(this.emailHtmlBody)) {
            mail.setHtmlBody(this.emailHtmlBody);
        }
        if(this.bccAddresses != null) {
            mail.setBccAddresses(this.bccAddresses);
        }
        if(this.contentVersionIds != null) {
            mail.setEntityAttachments(this.contentVersionIds);
        }
        if(this.targetId != null){
            mail.setTargetObjectId(this.targetId);
            mail.setSaveAsActivity(true);
        }
        if(this.whatId != null){
            mail.setWhatId(this.whatId);
        }
        if(this.orgWideAddressId != null){
            mail.setOrgWideEmailAddressId(this.orgWideAddressId);
        }
        return mail;
    }

    /** @description setToAddress
     * @param template
     * @return EmailTemplate
     **/
    public static EmailTemplate getEmailTemplate(String template) {
        return [SELECT Id,Subject, HtmlValue, Markup FROM EmailTemplate WHERE developername = :template LIMIT 1];
    }
    /** @description setToAddress
     * @param templateId
     * @param OppId
     * @return Messaging.SingleEmailMessage
     **/
    public static Messaging.SingleEmailMessage processEmailTemplate(Id templateId,Id OppId){
        return Messaging.renderStoredEmailTemplate(templateId, UserInfo.getUserId(), OppId);
    }
    /** @description SupportException
     **/
    public class SupportException extends Exception{}
}