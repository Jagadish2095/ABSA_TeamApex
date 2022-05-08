/**
 * @description Apex controller class for the Aura bundle LeadOverride.
 *
 * @author Manoj Danthala : Absa
 * @since   2019-09-15
 *
 */
public class CIGetAccountLinkedToClientCodeController {
    /**
	 * @description Method to get Account Details
	 * @param clientAccountId
	 * @return String
	 */
    @AuraEnabled
    public static String getAccountDetails(String clientAccountId) {
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);

        if (accountList?.size() != 1) {
            return 'Error: Account not found with Id: ' + clientAccountId;
        }

        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING, accountList[0].CIF__c);

        if (response == null) {
            return 'Error: Blank response received from service.';
        }
        if (String.isNotBlank(response.nbsmsgo3?.msgEntry?.msgTxt)) {
            return 'Error: ' + response.nbsmsgo3.msgEntry.msgTxt;
        }
        if (response.statusCode != 200) {
            return 'Error: ' + response.message;
        }
        if (response.cip047o?.outputTable == null) {
            return 'Error: Unexpected response received. Service Response: ' + json.serialize(response);
        }

        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = response.cip047o.outputTable;
        for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable currentRecord : accTypes) {
            currentRecord.productTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.CIF, 'Product Type', currentRecord.productType, StringConstants.INBOUND_RECORD_TYPE);
        }
        return JSON.serialize(accTypes);
    }
    /**
	 * @description Method to send email notifications
	 * @param accNumber
	 * @param accBalance
     * @param caseRecordId
     * @param emailAddress
     * @param mobileNumber
     * @param commMethod
	 */
    @AuraEnabled
    public static void sendEmailNotifications(String accNumber, String accBalance, Id caseRecordId, String emailAddress, String mobileNumber, String commMethod) {
        if (caseRecordId != null) {
            Case caseObj = new Case(Id = caseRecordId);
            caseObj.Email__c = emailAddress;
            caseObj.Mobile__c = mobileNumber;
            caseObj.Communication_Method__c = commMethod;
            caseObj.Status = 'Closed';
            caseObj.Bypass_Validation_Rules__c = true;
            update caseObj;
        }
        //Pick the Email template based upon job type
        //if(JobType = Balance Enquiry){
        Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
        List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.composeEmail(caseRecordId, targetObjectId, emailAddress, 'Account_Balance_Enquiry');
        Messaging.SingleEmailMessage email = constructEmail.get(0);
        String htmlBody = email.getHTMLBody();
        String addMaskedAccInEmailBody = htmlBody.replace('[accountNumber]', accNumber);
        String addAccBalanceInEmailBody = addMaskedAccInEmailBody.replace('[balanceDetails]', accBalance);
        sendMailFromFlow(emailAddress, addAccBalanceInEmailBody);
    }
    /**
	 * @description Send email to client using dymanic body and email
	 * @param emailAddress
	 * @param emailBody
	 */
    public static void sendMailFromFlow(string emailAddress, string emailBody) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] to = new List<string>{ emailAddress };
        email.setToAddresses(to);
        email.setSubject('View Balance Mail');
        email.setHtmlBody(emailBody);

        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        } catch (exception e) {
            apexpages.addmessage(new apexpages.message(apexpages.severity.error, e.getMessage()));
        }
    }
    /**
	 * @description Method to get Account Descriptions
	 * @param accountNumbers
	 * @return String
	 */
	@AuraEnabled
    public static String getAccountDescriptions(String accountNumbers) {
        
        List<String> accountNumbersList = (List<String>)JSON.deserialize(accountNumbers, List<String>.class);
        //check if account numbers are provided
        if (accountNumbersList.isEmpty()) {
            return 'Error: Account numbers cannot be blank.';
        }
        
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        //check if user ab number is blank
        if (String.isBlank(currentUser.AB_Number__c)) {
            return 'Error: User AB number not provided.';
        }
        
        String userAbNumber = currentUser.AB_Number__c;
        
        BAPISFAccntDescr_Resp_IB_v1 responseBean = BAPISFAccntDescr_IH_v1.BAPISFAccntDescr(accountNumbersList, userAbNumber);
        //check if response is null
        if (responseBean == null) {
            return 'Error: Blank response received from service.';
        }
        //check the response statusCode
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        if (responseBean.BAPI_SF_ACCNT_DESCR?.ACCOUNT_RESP.isEmpty()) {
            return 'Error: Unable to load account details and vehicle description.';
        }

        return JSON.serialize(responseBean.BAPI_SF_ACCNT_DESCR.ACCOUNT_RESP);
    }
}