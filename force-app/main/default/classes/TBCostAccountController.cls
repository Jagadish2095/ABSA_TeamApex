/**
 * @description       : TB Cost Account Controller. W-12427 (View current cost account) & W-015612 (Update cost account & email customer)
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-29
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public class TBCostAccountController {


    /**
     * @description   : base class for any result.
     **/
    public abstract class TBCostAccountControllerBase
    {
        @AuraEnabled
        public Boolean isValid;

        @AuraEnabled
        public String ErrorMessage;

    }

    /**
     * @description   : Result for CloseCaseAndEmailResult
     **/
    public class CloseCaseAndEmailResult extends TBCostAccountControllerBase
    {
        @AuraEnabled
        public Boolean emailChangeSaved;

    }
    
    /**
     * @description   : Result for TBCostAccountResult
     **/
    public class TBCostAccountResult
    {
        @AuraEnabled
        public String AccountNumber;

        @AuraEnabled
        public String Status;

        @AuraEnabled
        public String ProductType;

        @AuraEnabled
        public String Balance;
    }

    /**
     * @description   : Result for getAccountChargesById
     **/
    public class GetAccountChargesByIdResult
    {
        /**
         * @description Charge Date
         */
        @AuraEnabled
        public String ChargeDate{get;set;}

        /**
         * @description Charge Time
         */
        @AuraEnabled
        public String ChargeTime{get;set;}

        /**
         * @description Charge Indicator
         */
        @AuraEnabled
        public String ChargeIndicator{get;set;}

        /**
         * @description From Account Number
         */
        @AuraEnabled
        public String FromAccountNumber{get;set;}

        /**
         * @description Target Account Number
         */
        @AuraEnabled
        public String TargetccountNumber{get;set;}

        /**
         * @description Amount
         */
        @AuraEnabled
        public String Amount{get;set;}

        /**
         * @description Reference
         */
        @AuraEnabled
        public String Reference{get;set;}

        /**
         * @description Transaction Type
         */
        @AuraEnabled
        public String TransactionType{get;set;}

        /**
         * @description Charge
         */
        @AuraEnabled
        public String Charge{get;set;}

        /**
        * @description Generates result list from charge logs
        * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-18
        * @param logs
        * @return List<Charge_Log__c>
        **/
        Public List<GetAccountChargesByIdResult> GetFromLogs(List<Charge_Log__c> logs){
            List<GetAccountChargesByIdResult> result = new List<GetAccountChargesByIdResult>();
            GetAccountChargesByIdResult temp;
            for (Charge_Log__c log : logs) {
                if(log != null){
                    temp = new GetAccountChargesByIdResult();
                    temp.ChargeDate = String.valueOf(log.Transaction_Date__c).substring(0,10);
                    temp.ChargeTime = String.valueOf(log.Transaction_Date__c).substring(10,19);
                    //temp.Amount = log.Charge_Control__c;
                    temp.TransactionType = log.Transaction_Code__c;
                    temp.FromAccountNumber = log.Charge_Control__r.Charge_Account_Number__c;
                    if(log.Charge_Amounts__r != NULL && log.Charge_Amounts__r.size() > 0){
                        temp.Amount = String.valueOf(log.Charge_Amounts__r[0].Charge_Amount__c);
                    }
                }
                result.add(temp);
            }
          
            return result;
        }
    }

    /**
     * @description   : Result for GetAllAccountsResult
     **/
    public class GetAllAccountsResult extends TBCostAccountControllerBase
    {
        @AuraEnabled
        public List<TBCostAccountResult> Accounts;

        @AuraEnabled
        public List<String> AccountTypes;
    }

    /**
     * @description   : Result for getAccountEmailFromCaseResult
     **/
    public class getAccountEmailFromCaseResult extends TBCostAccountControllerBase
    {
        @AuraEnabled
        public String email;

        @AuraEnabled
        public String accountId;

        @AuraEnabled
        public String accountName;
    }

    static  Account CurrentAccount;

    /**
     * @description account Id
     */
    public Id accountId {get;set;}


    /**
     * @description   : Constructor
     **/
    public TBCostAccountController() {

    }

    /**
    * @description VF Component property used in the TB Charges email.
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-26
    * @return List<TBChargesForEmailResult>
    **/
    public List<GetAccountChargesByIdResult> getCharges(){
        List<GetAccountChargesByIdResult> result = getAccountChargesById(this.accountId);

        return result;
    }

    /**
    * @description gets Account Email From Case
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-29 
    * @param recordId 
    * @return getAccountEmailFromCaseResult 
    **/
    @AuraEnabled
    public static getAccountEmailFromCaseResult getAccountEmailFromCase(String recordId){
        List<Account> accountList = getAccountsFor(recordId);
        Account acc = accountList[0];
        getAccountEmailFromCaseResult result = new getAccountEmailFromCaseResult();
        result.email = acc.personemail;
        result.accountId = acc.Id;

        return result;
    }

    /**
    * @description Gets Account Email
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-29 
    * @param recordId 
    * @return getAccountEmailFromCaseResult 
    **/
    @AuraEnabled
    public static getAccountEmailFromCaseResult getAccountEmail(String recordId){
        Account acc = getAccountById(recordId);
        getAccountEmailFromCaseResult result = new getAccountEmailFromCaseResult();
        result.email = acc.personemail;
        result.accountId = acc.Id;
        result.AccountName = acc.Name;
        return result;
    }

    /**
    * @description : Returns a list of accounts for case. List is always contains 1 row
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param caseId
    * @return List<Account>
    **/
    public static List<Account> getAccountsFor(String caseId){
        List<TBCostAccountResult> result = new List<TBCostAccountResult>();
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(caseId);
        List<Case> caseList = new CasesSelector().selectById(accIdSet);
        accIdSet.clear();
        accIdSet.add(caseList[0].AccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);

        return accountList;
    }

    /**
    * @description : Gets the account on the case
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-
    * @param caseId
    * @return Account
    **/
    public static Account getAccountOnCase(String caseId){
        if(CurrentAccount == null){
            List<Account> accountList = getAccountsFor(caseId);
            CurrentAccount = accountList[0];
        }
        return CurrentAccount;
    }

    /**
    * @description Gets accounts linked to case
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param caseId
    * @return GetAllAccountsResult
    **/
    @AuraEnabled
    public static GetAllAccountsResult getAllAccounts(String caseId){
        GetAllAccountsResult result = new GetAllAccountsResult();
        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = getAllAccountsNow(caseId);
        result.Accounts = extractResultsFromResponse(response);
        result.AccountTypes = getAllAccountTypes(result.Accounts);
        return result;
    }

    /**
    * @description Creates a list of account types based on the customers linked accounts
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param accounts
    * @return List<String>
    **/
    static List<String> getAllAccountTypes(List<TBCostAccountResult> accounts){
        Set<String> result = new Set<String>();
        for (TBCostAccountResult acc : accounts) {
            if(!result.contains(acc.ProductType)){
                result.add(acc.ProductType);
            }
        }
        return new List<String>(result);
    }

    /**
    * @description Gets account linked to aaccount linked to case
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param caseId
    * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
    **/
    public static CIgetAcctLinkedToClientCode_Resp_IB_v1 getAllAccountsNow(String caseId){
        List<TBCostAccountResult> result = new List<TBCostAccountResult>();
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(caseId);
        List<Case> caseList = new CasesSelector().selectById(accIdSet);
        accIdSet.clear();
        accIdSet.add(caseList[0].AccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);

        Account currentAccount = accountList[0];
        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING, currentAccount.CIF__c);
        return response;
    }


    /**
    * @description Extract accounts inlist of TBCostAccountResult
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param response
    * @return List<TBCostAccountResult>
    **/
    public static List<TBCostAccountResult> extractResultsFromResponse(CIgetAcctLinkedToClientCode_Resp_IB_v1 response){
		List<TBCostAccountResult> result = new List<TBCostAccountResult>();
        TBCostAccountResult temp = new TBCostAccountResult();
        temp.AccountNumber = 'Please Select An Option';
        temp.ProductType = 'Please Select An Option';

        result.add(temp);
        for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_OutputTable acc : response.cip047o.outputTable) {
            temp = new TBCostAccountResult();
            temp.AccountNumber = acc.oaccntnbr;
            temp.Balance = acc.availableBalance;
            temp.ProductType = acc.productType;
            temp.Status = acc.status;
            result.add(temp);
        }
        return result;
    }



    /**
    * @description Gets cost account. Its a list because its been displayed in a datalist
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param accountId
    * @return List<TBCostAccountResult>
    **/
    @AuraEnabled
    public static List<TBCostAccountResult> getCostAccounts(String accountId){
        List<TBCostAccountResult> result = new List<TBCostAccountResult>();
        Account currentAccount = getAccountById(accountId);
        CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING, currentAccount.CIF__c);
        result.add(getCostAccount(response, currentAccount));
        return result;
    }

    /**
    * @description Gets SF accounts by id
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-18
    * @param accountId
    * @return List<Account>
    **/
    @AuraEnabled
    public static Account getAccountById(Id accountId){
       List<Account> result = new List<Account>();
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(accountId);
        result = new AccountsSelector().selectById(accIdSet, 1);
        return result[0];
    }

    /**
    * @description Gets the accounts Telephone Banking charges
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param accountId
    * @return List<GetAccountChargesByIdResult>
    **/
    @AuraEnabled
    public static List<GetAccountChargesByIdResult> getAccountChargesById(Id accountId){
        List<GetAccountChargesByIdResult> result = new List<GetAccountChargesByIdResult>();
        List<Charge_Log__c> logs = new ChargeLogsSelector().selectChargesByAccountId(accountId);
        result = new GetAccountChargesByIdResult().GetFromLogs(logs);
        return result;
    }


    /**
    * @description Gets the current cost account
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param response
    * @param currentAccount
    * @return TBCostAccountResult
    **/
    private static TBCostAccountResult getCostAccount(CIgetAcctLinkedToClientCode_Resp_IB_v1 response, Account currentAccount){
       // Integer position = 0;
        String copiedAccountNumber;
        TBCostAccountResult result = new TBCostAccountResult();
   
		for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_OutputTable acc : response.cip047o.outputTable) {
            copiedAccountNumber = extractAcconutNumber(acc.oaccntnbr);
             if(copiedAccountNumber == currentAccount.Telebanking_Charge_Account_Number__c){
                result.AccountNumber = currentAccount.Telebanking_Charge_Account_Number__c;
                result.Balance = acc.availableBalance;
                result.Status = acc.status;
                result.ProductType = acc.productType;

            }else {
                //system.debug('No Match');

            }
        }

        return result;
    }

    /**
    * @description Extract account number from string with leading zeros
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param accountString
    * @return String
    **/
    static String extractAcconutNumber(String accountString){
        String result;
        Integer position = 0;
        String character = '';

        do{
            if(position < accountString.length()){
                character = accountString.substring(position, position + 1);
                if(character != '0'){
                    break;
                }
            }
            position = position + 1;
        }while(position < accountString.length());

        result = accountString.substring(position);
        return result;
    }

    /**
    * @description Update cost account
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param caseId
    * @param newAccount
    * @return Boolean
    **/
    @AuraEnabled
    public static Boolean updateClientCostAccount(String caseId, String newAccount){
        Boolean results = false;
        Account acc;
        List<Account> accounts = getAccountsFor(caseId);
        if(accounts != null && accounts.size() > 0){
            acc = accounts[0];
            acc.Telebanking_Charge_Account_Number__c = extractAcconutNumber(newAccount);
            update accounts;
            results = true;
        }

        return results;
    }


    /**
    * @description Updated client. End email. Close case.
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param caseId
    * @param email
    * @return CloseCaseAndEmailResult
    **/
    @AuraEnabled
    public static CloseCaseAndEmailResult closeCaseAndEmailClient(String caseId, String email){
        Boolean hasEmailChanged = false;
        CloseCaseAndEmailResult result = new CloseCaseAndEmailResult();

        //send email
        hasEmailChanged = sendEmail(caseId, email);

        //Update account if agent supplied a new email
        if(hasEmailChanged){
            List<Account> accounts = getAccountsFor(caseId);
            accounts[0].personemail = email;
            update accounts;
        }

        //Close case
        closeCase(caseId);

        result.isValid = true;
        result.emailChangeSaved = hasEmailChanged;

        return result;
    }

	/**
	* @description  Close case
	* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
	* @param caseId
	**/
	@AuraEnabled
	public static void closeCase(Id caseId) {
		try {
			if (caseId != null) {
				Case caseObj = new Case(Id = caseId);
				caseObj.Status = 'Closed';
				update caseObj;
			}
		} catch (DmlException ex) {
			throw ex;
		}
	}


	/**
	* @description Build And Send Tb Charges Email
	* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-29
	* @param email
	* @param name
	* @param charges
	* @return Boolean
	**/
    @AuraEnabled
	public static Boolean buildAndSendTbChargesEmail(String email,String name, List<GetAccountChargesByIdResult> charges) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> toAddresses = new List<String>();
        toAddresses.add(email);
		mail.setToAddresses(toAddresses);
		mail.setSubject('TelephoneB Charges');
		String body = '<h2><span style="color: #ff0000;">Transactional Fee Breakdown</span></h2>';
        body +='<p><span >' + name + '</span></p><br/>';
		body += '<table style="border-collapse: collapse; width: 100%; height: 52px;" border="1"><tbody>';
        body += '<tr style="height: 35px;">';
        body += '<td style="width: 16.6667%; height: 35px;"><div><div><strong>Charge Date</strong></div></div></td>';
        body += '<td style="width: 16.6667%; height: 35px;"><div><div><strong>Charge Time</strong></div></div></td>';
        body += '<td style="width: 16.6667%; height: 35px;"><div><div><strong>Charge Indicator</strong></div></div></td>';
        body += '<td style="width: 16.6667%; height: 35px;"><div><div><strong>From Account</strong></div></div></td>';
        body += '<td style="width: 16.6667%; height: 35px;"><strong>Amount</strong></td>';
        body += '<td style="width: 16.6667%; height: 35px;"><div><div><strong>TransactionType</strong></div></div></td>';
        body += '</tr>';
        for (GetAccountChargesByIdResult charge : charges) {
            body += '<tr style="height: 17px;">';
            body += '<td style="width: 16.6667%; height: 17px;">' + charge.ChargeDate + '</td>';
            body += '<td style="width: 16.6667%; height: 17px;">' + charge.ChargeTime + '</td>';
            body += '<td style="width: 16.6667%; height: 17px;">' + charge.ChargeIndicator + '</td>';
            body += '<td style="width: 16.6667%; height: 17px;">' + charge.FromAccountNumber + '</td>';
            body += '<td style="width: 16.6667%; height: 17px;">' + charge.Amount + '</td>';
            body += '<td style="width: 16.6667%; height: 17px;">' + charge.TransactionType + '</td>';
            body += '</tr>';
        }
        body += '</tbody></table>';
        body += '<p>&nbsp;</p>';
        body += '<p>We trust that you will find the above in order.</p>';
        body += '<p>&nbsp;</p>';
        body += '<p>Kind regards</p>';
        body += '<p>&nbsp;</p>';
		body += 'The Absa Telephone Banking team</br>';
		mail.setHtmlBody(body);
		List<Messaging.SendEmailResult> result = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
		if (result[0].isSuccess()) {
			return true;
		} else {
			return false;
		}
	}

    /**
    * @description Send email
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param caseId
    * @param email
    * @return Boolean
    **/
    @AuraEnabled
    public static Boolean sendEmail(String caseId, String email){
        Messaging.SingleEmailMessage emailMessage;
        Boolean hasEmailChaned = false;

        List<Account> accountList = getAccountsFor(caseId);
        Account acc = accountList[0];
        if(acc.personemail != email){
            hasEmailChaned = true;
        }

        emailMessage = ComposeEmail(caseId, acc.Id, email, 'Cost_Account_Updated');

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ emailMessage });

        return hasEmailChaned;
    }


    /**
    * @description Compose email
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-11
    * @param whatId
    * @param targetObjectId
    * @param emailAddress
    * @param templateName
    * @return Messaging.SingleEmailMessage
    **/
    public static Messaging.SingleEmailMessage ComposeEmail(Id whatId, Id targetObjectId, String emailAddress, String templateName){
        Contact c = [SELECT Id FROM Contact WHERE AccountId =: targetObjectId][0];
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setTemplateId([SELECT Id FROM EmailTemplate WHERE DeveloperName =: templateName][0].Id);
        msg.setWhatId(whatId);
        msg.setTargetObjectId(c.Id);
        msg.setToAddresses(new List<String>{emailAddress});
        return msg;

    }
}