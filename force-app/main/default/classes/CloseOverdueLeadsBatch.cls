/**
 * Batch class for closing expired leads
 * @author  Koketso Mpshane
 * @date    09/03/2020
 */
global class CloseOverdueLeadsBatch implements Database.Batchable<Lead> {
    global Iterable<Lead> start(Database.BatchableContext BC) {
        List<Lead> expiredLeadList = [
            SELECT Id, Status, Hot_Deal__c, SubStatus__c, SLA_Start_Date__c, Retail_Lead_SLA_End_Date__c
            FROM Lead
            WHERE
                RecordType.DeveloperName IN ('Retail_Sales_Lead', 'Retail_Service_Lead')
                AND Status != 'Closed'
                AND Retail_Lead_SLA_End_Date__c < :System.today()
        ];

        return expiredLeadList;
    }

    global void execute(Database.BatchableContext BC, List<Lead> leadScope) {
        List<Lead> leadRecords = new List<Lead>();

        try {
            if (leadScope.size() > 0) {
                for (Lead leadRec : leadScope) {
                    if (leadRec.Status == 'Working') {
                        leadRec.SubStatus__c = 'Expired Working';
                    } else {
                        leadRec.SubStatus__c = 'Expired Not Actioned';
                    }
                    leadRec.Status = 'Closed';
                    leadRec.Bypass_Validation_Rules__c = true;
                    leadRecords.add(leadRec);
                }
            }

            if (leadRecords.size() > 0) {
                Integer successLeadsNum = 0;
                Integer failedLeadsNum = 0;
                Set<String> errorList = new Set<String>();

                Database.SaveResult[] expiredLeads = Database.update(leadRecords, false);

                for (Database.SaveResult sr : expiredLeads) {
                    if (sr.isSuccess()) {
                        successLeadsNum = successLeadsNum + 1;
                    } else {
                        failedLeadsNum = failedLeadsNum + sr.getErrors().size();
                        for (Database.Error err : sr.getErrors()) {
                            errorList.add(err.getMessage());
                        }
                    }
                }

                if (failedLeadsNum > 0) {
                    String emailBody = 'Good day, <br/><br/>Please note that the CloseOverdueLeadsBatch class returned the following errors:<br/><br/>';
                    for (String error : errorList) {
                        emailBody += error + '<br/>';
                    }
                    emailBody += '<br/>Successful updates:' + successLeadsNum + ', failded records:' + failedLeadsNum;
                    emailBody += '.<br/><br/>Regards,<br/>Salesforce';

                    sendEmailWithErrors(emailBody);
                }
            }

            if (Test.isRunningTest()) {
                throw new system.DmlException();
            }
        } catch (DmlException ex) {
            system.debug(LoggingLevel.FINE, '***CloseOverdueLeadsBatch Error***:' + ex.getMessage());

            String emailBody = 'Good day, <br/><br/>Please note that the CloseOverdueLeadsBatch class returned the following errors:<br/>' + ex.getMessage();
            emailBody += '<br/><br/>Regards,<br/>Salesforce';

            sendEmailWithErrors(emailBody);
        }
    }

    global void finish(Database.BatchableContext BC) {
        system.debug('CloseOverdueLeadsBatch finished processing!');
    }

    public static void sendEmailWithErrors(String emailBody) {
        List<String> recipientEmails = new List<String>();
        //Send email to administrators if any errors
        List<Exception_Email_Recipient__mdt> mdtEmailRecipients = [SELECT Email_Address__c FROM Exception_Email_Recipient__mdt];
        if (mdtEmailRecipients.size() > 0) {
            for (Exception_Email_Recipient__mdt mdt : mdtEmailRecipients) {
                recipientEmails.add(mdt.Email_Address__c);
            }
        }

        if (recipientEmails.size() > 0) {
            List<Messaging.SingleEmailMessage> singleMessageList = new List<Messaging.SingleEmailMessage>();

            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setToAddresses(recipientEmails);
            msg.setSubject('CloseOverdueLeadsBatch Error');
            msg.setHtmlBody(emailBody);
            msg.setSaveAsActivity(false);
            singleMessageList.add(msg);

            //Send the emails
            Messaging.sendEmail(singleMessageList);
        }
    }
}