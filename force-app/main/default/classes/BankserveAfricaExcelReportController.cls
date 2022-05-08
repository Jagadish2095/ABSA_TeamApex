/**
 * Schedulable class to generate and schedule report daily
 *
 * W-005324
 * @author  Himani Joshi
 * @since   03-09-2020
 */

public class BankserveAfricaExcelReportController implements Schedulable {
    public static void execute(SchedulableContext sc) {
        String merchantId;
        String websiteUrl;
        String accountName;
        String processorId;
        String recordString;
        String finalString = 'Merchant_Id_Ref__r.Merchant_Id__c,Website_URL__c,Account_Name__c,CSP,OpportunityId\n';
        Sys_Log_Integration__c sysLog;
        String logMessage;
        Integer recordCount = 0;

        try {
            List<OpportunityLineItem> opportunityLineItemList = new OpportunityLineItemsSelector().selectParentLinesByOppRecordTypeAndProduct('Merchant Onboarding', 'E-Commerce');
            Set<Id> opportunityIds = Sys_Utilities_General.extractListIds(opportunityLineItemList, 'OpportunityId', true);
            Set<Id> opportunityLineItemIds = Sys_Utilities_General.extractListIds(opportunityLineItemList, 'Id', true);
            List<Application__c> applicationList = new ApplicationsSelector().selectByOpportunityIdList(opportunityIds);
            List<Application_Product_Merchant__c> applicationProductMerchantList = new ApplicationProductMerchantsSelector().selectByOpportunityLineItemIds(opportunityLineItemIds);
            Map<String, List<Application__c>> applicationMap = Sys_Utilities_General.convertListToMapWithStringKey(applicationList, 'Opportunity__c');
            Map<String, List<Application_Product_Merchant__c>> applicationProductMerchantMap = Sys_Utilities_General.convertListToMapWithStringKey(applicationProductMerchantList, 'Opportunity_Product_Id__c');

            for (OpportunityLineItem currentOpportunityLineItem : opportunityLineItemList) {
                merchantId = '';
                websiteUrl = '';
                accountName = '';
                processorId = '';

                if (applicationMap.containsKey(currentOpportunityLineItem.OpportunityId)) {
                    merchantId = applicationMap.get(currentOpportunityLineItem.OpportunityId)[0].Merchant_Id_Ref__r.Merchant_Id__c;
                }

                if (applicationProductMerchantMap.containsKey(currentOpportunityLineItem.Id)) {
                    processorId = applicationProductMerchantMap.get(currentOpportunityLineItem.Id)[0].csp__c;
                }

                websiteUrl = currentOpportunityLineItem.Opportunity.Website_URL__c;
                accountName = currentOpportunityLineItem.Opportunity.Account.Name;

                merchantId = String.isNotBlank(merchantId) ? merchantId : '';
                websiteUrl = String.isNotBlank(websiteUrl) ? websiteUrl : '';
                accountName = String.isNotBlank(accountName) ? accountName : '';
                processorId = String.isNotBlank(processorId) ? processorId : '';

                recordString = merchantId + ',' + websiteUrl + ',' + accountName + ',' + processorId + ',' + currentOpportunityLineItem.OpportunityId + '\n';

                finalString = finalString + recordString;
                recordCount++;
            }

            Messaging.EmailFileAttachment csvAtt = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalString);
            String csvName = Label.BankserveAfricaExcelReportName;
            csvAtt.setFileName(csvName);
            csvAtt.setBody(csvBlob);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<String> toAddresses = Label.BankserveAfricaExcelReportEmailAddresses.split(';');
            String subject = Label.BankserveAfricaExcelReportName;
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
            email.setPlainTextBody(Label.BankserveAfricaExcelReportName);
            email.setFileAttachments(new List<Messaging.EmailFileAttachment>{ csvAtt });

            List<Messaging.SendEmailResult> sendEmailResultList = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });

            for (Messaging.SendEmailResult currentSendEmailResult : sendEmailResultList) {
                if (!currentSendEmailResult.isSuccess()) {
                    logMessage += 'ErrorCode: ' + currentSendEmailResult.getErrors()[0].getStatusCode() + '. ErrorMessage: ' + currentSendEmailResult.getErrors()[0].getMessage() + '... ';
                }
            }

            if (String.isBlank(logMessage)) {
                logMessage = 'Successfully sent report with ' + recordCount + ' record(s)';
                sysLog = SystemLogger.createInternalIntegrationLog('BankserveAfricaExcelReportController.execute', 'Scheduled Email Report', 200, 'Success', logMessage);
            } else {
                sysLog = SystemLogger.createInternalIntegrationLog('BankserveAfricaExcelReportController.execute', 'Scheduled Email Report', 500, 'Send Email Error', logMessage);
            }
        } catch (Exception ex) {
            logMessage = 'Exception: ' + ex.getMessage() + '. StackTrace: ' + ex.getStackTraceString();
            sysLog = SystemLogger.createInternalIntegrationLog('BankserveAfricaExcelReportController.execute', 'Scheduled Email Report', 500, 'Internal Server Error', logMessage);
            System.debug('BankserveAfricaExcelReportController.execute.catch.logMessage: ' + logMessage);
        } finally {
            if (sysLog != null) {
                insert sysLog;
            }
        }
    }
}