/**
* @description       : EmailSenderController
* @author            : Vinod.Thupakula@absa.africa
* @group             :
* @last modified on  : 2021-11-23
* @last modified by  : Vinod.Thupakula@absa.africa
**/
public without sharing class EmailSenderController {
    /** @description updateAccount
     * @param recordId
     * @param emailAddress
     **/
    @AuraEnabled public static void updateAccount(String recordId,String emailAddress){
        try{
            update new Account(Id=recordId,PersonEmail=emailAddress);
        }
        catch(Exception ex){
            AuditTrailLog.logException(ex, 'New', 'Info', 'EmailServEmailSenderControllericeForOpportunity', 'updateAccount', ex.getMessage());
        }
    }
    /** @description getOppLineItems
     * @param oppId
     * @return wrapperOppLineItem
     **/
    @AuraEnabled public static wrapperOppLineItem getOppLineItems(String oppId){
        wrapperOppLineItem lineItem = new wrapperOppLineItem();
        String error = '';
        try{
            Map<Id,ContentDocument> contentDocumentsData = new Map<Id,ContentDocument>();
            contentDocumentsData = InvestmentOppUtility.getRelatedDocuments(oppId);
            List<String> fileTypes = InvestmentOppUtility.getRequiredDocs(oppId);
            if(fileTypes.isEmpty()){
                error = 'You have not selected any required document types. Please select required Document types before sending the email!';
                lineItem.errorType = 'warning';
            }
            else{
                error = InvestmentOppUtility.checkAllvalidDocuments(contentDocumentsData.values(),fileTypes);
                lineItem.errorType = 'error';
            }
            if(String.isNotBlank(error)) {
                lineItem.errorMessage = error;
            }
            else{
                Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
                List<Application_Product__c> appProducts = new ApplicationProductSelector().selectByOpportunityId(oppId);
                List<Regulatory_Financial_Account__c> financialAcc = new RegulatoryFinancialAccountsSelector().selectByAccountId(opportunity.AccountId);
                OpportunitylineItem oppLineItem = new OpportunityLineItemsSelector().selectByOppId(oppId, 1);
                lineItem.contentDocuments = contentDocumentsData;
                lineItem.appProduct = appProducts[0];
                lineItem.financialProduct = financialAcc[0];
                lineItem.oppLineItem = oppLineItem;
                EmailTemplate template = EmailOutboundService.getEmailTemplate('Investment_Opportunity_Recommendation');
                Messaging.SingleEmailMessage message = EmailOutboundService.processEmailTemplate(template.Id,oppLineItem.Id);
                String replaceMessage = message.getHtmlBody();
                if(appProducts[0].Reduction_Amount__c !=null){
                    replaceMessage = replaceMessage.replace('#Recurring_Premium#',String.valueOf(appProducts[0].Reduction_Amount__c.setscale(2)));
                }
                else{
                    replaceMessage = replaceMessage.replace('#Recurring_Premium#', '0.0');
                }
                replaceMessage = replaceMessage.replace('#Premium#',String.valueOf(appProducts[0].Product_Amount__c.setscale(2)));
                replaceMessage = replaceMessage.replace('#Product_House#',oppLineItem.Product2.Primary_Service_Provider__r.Name);
                replaceMessage = replaceMessage.replace('#Comments',processComments(contentDocumentsData.KeySet()));
                lineItem.textBody = replaceMessage;
            }
        }
        catch(Exception ex){
            lineItem.errorMessage =ex.getMessage();
        }
        return lineItem;
    }
    /** @description sendEmailtoCustomer
     * @param lineItems
     * @param emailAddress
     **/
    @AuraEnabled public static void sendEmailtoCustomer(String lineItems, String emailAddress){
        wrapperOppLineItem oppLineItems = (wrapperOppLineItem)system.JSON.deserializeStrict(lineItems, wrapperOppLineItem.class);
        senEmail(oppLineItems,emailAddress);
        update new Opportunity(Id=oppLineItems.oppLineItem.OpportunityId,Sub_Status__c='Await customer feedback', Email_Status__c='Submitted',Sys_BypassValidation__c=true);
    }
    
    private static void senEmail(wrapperOppLineItem lineItems, String emailAddress){
        OrgWideEmailAddress owa = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName='SVC-Virtualadviser' LIMIT 1];
        EmailTemplate template = EmailOutboundService.getEmailTemplate('Investment_Opportunity_Recommendation_Branding');
        Messaging.SingleEmailMessage message = EmailOutboundService.processEmailTemplate(template.Id,lineItems.oppLineItem.Id);
        String replaceMessage = message.getHtmlBody();
        if(lineItems.appProduct.Reduction_Amount__c !=null){
            replaceMessage = replaceMessage.replace('#Recurring_Premium#',String.valueOf(lineItems.appProduct.Reduction_Amount__c.setscale(2)));
        }
        else{
            replaceMessage = replaceMessage.replace('#Recurring_Premium#', '0.0');
        }
        replaceMessage = replaceMessage.replace('#Premium#',String.valueOf(lineItems.appProduct.Product_Amount__c.setscale(2)));
        replaceMessage = replaceMessage.replace('#Product_House#',lineItems.oppLineItem.Product2.Primary_Service_Provider__r.Name);
        replaceMessage = replaceMessage.replace('#Comments',processComments(lineItems.contentDocuments.KeySet()));
        Messaging.SingleEmailMessage mail = new EmailOutboundService()
            .setSubject(template.Subject +' : '+lineItems.oppLineItem.Opportunity.Sys_ThreadId__c)
            .setToAddress(emailAddress)
            .setemailHtmlBody(replaceMessage)
            .setemailPlainTextBody(message.getPlainTextBody())
            .getRelatedFileAttachments(lineItems.contentDocuments.KeySet())
            .setTargetId(getContact(lineItems.oppLineItem.Opportunity.AccountId).Id)
            .setwhatId(lineItems.oppLineItem.OpportunityId)
            .setorgWideAddressId(owa.Id)
            .setReplyTo(System.label.Investment_EmailService)
            .build();
        Messaging.sendEmail(new List<messaging.SingleEmailMessage> {mail});
    }
    private static Contact getContact(String accId){
        return [SELECT ID FROM Contact WHERE AccountId =: accId LIMIT 1];
    }
    private static String processComments(Set<Id> conIds){
        String comments = '';
        for(ContentVersion version : [SELECT ID,TextPreview FROM ContentVersion WHERE ContentDocumentId IN: conIds AND FileType = 'SNOTE' AND IsLatest=true]){
            comments += version.TextPreview+'<br/>';
        }
        return comments;
    }
     /**
     * @description       : wrapperOppLineItem
     * @author            : Vinod.Thupakula@absa.africa
     * @last modified on  : 2021-11-23
     * @last modified by  : Vinod.Thupakula@absa.africa
    **/
    public class wrapperOppLineItem{
        /** @description errorMessage */
        @AuraEnabled public String errorMessage{set;get;}
        /** @description  errorType */
        @AuraEnabled public String errorType{set;get;}
        /** @description  appProduct */
        @AuraEnabled public Application_Product__c appProduct{set;get;}
        /** @description  @param financialProduct */
        @AuraEnabled public Regulatory_Financial_Account__c financialProduct{set;get;}
        /** @description  oppLineItem */
        @AuraEnabled public OpportunityLineItem oppLineItem{set;get;}
        /** @description  contentDocuments */
        @AuraEnabled public Map<Id,ContentDocument> contentDocuments{set;get;}
        /** @description  textBody */
        @AuraEnabled public String textBody{set;get;}
    }
}