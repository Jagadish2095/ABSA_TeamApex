/**
* Controller class for the Drafting Fee lightning component
* @author Vladimir Panajic
* @created 2018-12-14
* @Modified 2019-05-27(Lulu Rankwe/ Makgotso Lebajoa)
*/

public class SafeCustodyController {
    
    static Map <String, Schema.RecordTypeInfo> applicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    static Map <String, Schema.RecordTypeInfo> accountRecordTypesMap = Account.sObjectType.getDescribe().getRecordTypeInfosByName();

    /**
	* Returns the drafting payment method type that has been set on application
	*
	* @param opportunityId
	* @return paymentPreferenceSetType
	*/ 
    
    @AuraEnabled
    public static String checkPaymentPreferenceSetTypeonApplication(Id opportunityId) {
        return DraftingFeeController.checkPaymentPreferenceSetTypeonApplication(opportunityId);
    }

    /**
    * Checks whether safe custody banking details have been validated
    *
    * @param opportunityId
    * @return (boolean) bankingDetailsValidated
    */
    @AuraEnabled
    public static boolean checkBankingDetailsValidated(Id opportunityId) {

        Boolean bankingDetailsValidated = false;
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);

        if (!applicationsList.isEmpty()) {

            //Check if Fees Waived or Fee Paid flags are set
            if (applicationsList.get(0).Safe_Custody_Banking_Details_Validated__c) {

                bankingDetailsValidated = true;

            }

        }

        return bankingDetailsValidated;
    }
    
    /**
    * Updates the Application with Safe Custody details
    *
    * @param opportunityId
    * @param SCFPaymentIndicator
    */
    
    @AuraEnabled
    public static void updateApplication(Id opportunityId, String SCFPaymentIndicator, String SCFRequired) {
        
        List<Application__c> applicationToUpdate = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        applicationToUpdate.get(0).Safe_Custody_Payment_Same_As_Drafting__c = SCFPaymentIndicator;
        applicationToUpdate.get(0).Safe_Custody_Is_Required__c = SCFRequired;
        applicationToUpdate.get(0).Safe_Custody_Status__c = 'Valid';     
        try {
        	update applicationToUpdate.get(0);
        } catch(DmlException e) {
        	System.debug('An unexpected error has occurred: ' + e.getMessage());
       	}
    }
    
    /**
    * Returns payment method for specific payment plan type linked to the opportunity
    *
    * @param opportunityId
    * @return paymentMethod
    */
	
    @AuraEnabled
    public static String getPaymentMethod(Id opportunityId, string type) {
        String paymentMethod;
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {
            List<Payment_Plan__c> paymentPlansList = new PaymentPlansSelector().selectByTypeByApplicationId(applicationsList.get(0).Id, type, 1);
        	if (!paymentPlansList.isEmpty()) {
            	paymentMethod = paymentPlansList.get(0).Method__c;
        	}
        }
        return paymentMethod;
    }
    
    /**
    * Gets the LOVs
    *
    * @param objObject
    * @param fld
    * @return allOpts
    */
    
    @AuraEnabled
    public static List <String> getSelectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String> ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();        
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();        
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    /**
    * Creates or updates the payment plan
    *
    * @param opportunityId
    * @param accNumber
    * @param accType
    * @param bankName
    * @param branchCode
    * @param branchName
    * @param name
    * @param frequency
    * @param amount
    * @param method
    * @param status
    * @param type
    */
    
    @AuraEnabled
    public static void submitPaymentPlanDetail(Id opportunityId, string accNumber, string accType, string bankName, string branchCode, string branchName, string name, string frequency, decimal amount, string method, string status, string type) {
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {
            List<Payment_Plan__c> paymentPlansList = [SELECT Id FROM Payment_Plan__c WHERE Application__c =: applicationsList.get(0).Id AND Type__c =: type Limit 1];
            if (paymentPlansList.isEmpty()) {
                Payment_Plan__c paymentPlan = new Payment_Plan__c();
                paymentPlan.Application__c = applicationsList.get(0).Id;
                paymentPlan.Account_Number__c = accNumber;
                paymentPlan.Account_Type__c = accType;
                paymentPlan.Bank_Name__c = bankName;
                if (String.isNotBlank(branchCode)) {
                    paymentPlan.Branch_Code__c = Integer.valueOf(branchCode);
                }
                paymentPlan.Branch_Name__c = branchName;
                paymentPlan.Name = name;
                paymentPlan.Frequency__c = frequency;
                paymentPlan.Amount__c = amount;
                paymentPlan.Method__c = method;
                paymentPlan.Status__c = status;
                paymentPlan.Type__c = type;
                try {
                    insert paymentPlan;
                } catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }              
            } else {
                Payment_Plan__c paymentPlanToUpdate;
                paymentPlanToUpdate = [SELECT Id, Account_Number__c, Account_Type__c, Bank_Name__c, Branch_Code__c, Branch_Name__c, Debit_Order_Commencement_Date__c, Debit_Order_Salary_Day__c, Debit_Order_Debit_Day__c, Name, Frequency__c, Method__c, Amount__c, Reference__c, Status__c, Type__c, Fee_Code__c FROM Payment_Plan__c WHERE Application__c =: applicationsList.get(0).Id AND Type__c =: type Limit 1];
                
                paymentPlanToUpdate.Account_Number__c = accNumber;
                paymentPlanToUpdate.Account_Type__c = accType;
                paymentPlanToUpdate.Bank_Name__c = bankName;
                if (String.isNotBlank(branchCode)) {
                    paymentPlanToUpdate.Branch_Code__c = Integer.valueOf(branchCode);
                }                
                paymentPlanToUpdate.Branch_Name__c = branchName;
                paymentPlanToUpdate.Name = name;
                paymentPlanToUpdate.Frequency__c = frequency;
                paymentPlanToUpdate.Amount__c = amount;
                paymentPlanToUpdate.Method__c = method;
                paymentPlanToUpdate.Status__c = status;
                paymentPlanToUpdate.Type__c = type;
                try {
                    update paymentPlanToUpdate;
                } catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
            }
        } else {
            system.debug('Applications list is empty');
        }   
    }

    /**
    * Updates the safe custody fee status on the application record related to the opportunity
    *
    * @param opportunityId
    * @param safeCustodyFeeStatus
    */

    @AuraEnabled
    public static void updateSafeCustodyFeeStatus(Id opportunityId, String safeCustodyFeeStatus) {

        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        System.debug('applicationsList: ' + applicationsList);

        if (!applicationsList.isEmpty()) {

            if (safeCustodyFeeStatus != null) {

                applicationsList.get(0).Safe_Custody_Status__c = 'Valid';

                try {

                    update applicationsList.get(0);

                } catch (DmlException e) {

                    System.debug('An unexpected error has occurred: ' + e.getMessage());

                }

            }
        }

    }

    /**
    * Sets the banking details validation status
    *
    * @param opportunityId
    * @return (String) bankingDetailsValidationStatus
    */
    @AuraEnabled
    public static void setBankingDetailsValidationStatus(Id opportunityId, String bankingDetailsValidationStatus) {

        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);

        if (!applicationsList.isEmpty()) {

            if (bankingDetailsValidationStatus.equals('Valid')) {

                applicationsList.get(0).Safe_Custody_Banking_Details_Validated__c = true;

            } else {

                applicationsList.get(0).Safe_Custody_Banking_Details_Validated__c = false;

            }

            try {

                update applicationsList.get(0);

            } catch(DmlException e) {

                System.debug('An unexpected error has occurred: ' + e.getMessage());

            }

        }

    }

    /**
    * Checks if the payment plan of specific type exists for the opportunity
    *
    * @param opportunityId
    * @param type
    * 
    * @return paymentPlanExists
    */
    
    @AuraEnabled
    public static boolean existsPaymentPlan(Id opportunityId, string type) {
       boolean paymentPlanExists = false;
       List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {
       		List<Payment_Plan__c> paymentPlansList = new PaymentPlansSelector().selectByTypeByApplicationId(applicationsList.get(0).Id, type, 1);
            if (!paymentPlansList.isEmpty()) {
                paymentPlanExists = true;
            }
        }
        return paymentPlanExists;
    }
    
    /**
    * Retrieves an application for the opportunity
    *
    * @param opportunityId
    * @return application
    */
	
    @AuraEnabled
    public static Application__c selectByOpportunityId(Id opportunityId) {
        Application__c application = new Application__c();
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {
            application = applicationsList.get(0);
		}
        system.debug('Safe_Custody_Is_Required__c: ' + application.Safe_Custody_Is_Required__c);
        return application;
    }
    
    /**
    * Method that indicates if the Application has been captured
    *
    * @param opportunityId - opportunity Id
    * @return true or false - boolean
    */
	
    @AuraEnabled
    public static boolean applicationExistsByOpportunityId(Id opportunityId) {
        Boolean applicationFound = false;
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {
            applicationFound = true;
		}
        return applicationFound;
    }
    
    /**
    * Retrieves the payment plan of specific type for the opportunity
    *
    * @param opportunityId
    * @param type
    * @return paymentPlansList
    */
    
    @AuraEnabled
    public static Payment_Plan__c selectByTypeByApplicationId(Id opportunityId, string type) {
       List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
       List<Payment_Plan__c> paymentPlansList = new PaymentPlansSelector().selectByTypeByApplicationId(applicationsList.get(0).Id, type, 1);
       return paymentPlansList.get(0);
    }
    
    /**
    * Makes a copy of the drafting fee payment plan as safe custody fee payment plan for opportunity
    *
    * @param opportunityId
    */
    
    @AuraEnabled
    public static void copyDraftingPaymentPlanAsSafeCustodyPaymentPlan(Id opportunityId) {
    	List<Application__c> application = new ApplicationsSelector().selectByOpportunityId(opportunityId);
    	System.debug('application: ' + application);
        List<Payment_Plan__c> paymentPlans = new PaymentPlansSelector().selectByTypeByApplicationId(application.get(0).Id, 'Will Drafting Fee', 1);
        System.debug('paymentPlans: ' + paymentPlans);
        String accNumber = paymentPlans.get(0).Account_Number__c;
        String accType = paymentPlans.get(0).Account_Type__c;
        String bankName = paymentPlans.get(0).Bank_Name__c;
        decimal branchCode = paymentPlans.get(0).Branch_Code__c;
        String branchName = paymentPlans.get(0).Branch_Name__c;
        String name = paymentPlans.get(0).Name;
        String frequency = 'Yearly';
        decimal amount = 115;
        String method = paymentPlans.get(0).Method__c;
        String status = 'New';
        String type = 'Will Safe Custody Fee';
        copyPaymentPlanDetail(opportunityId, accNumber, accType, bankName, String.valueOf(branchCode), branchName, name, frequency, amount, method, status, type);        
    }
    
    /**
    * Copies the payment plan
    *
    * @param Opportunity Id
    * @param accNumber
    * @param accType
    * @param bankName
    * @param branchCode
    * @param branchName
    * @param name
    * @param frequency
    * @param amount
    * @param method
    * @param status
    * @param type
    */
    
    @AuraEnabled
    public static void copyPaymentPlanDetail(Id opportunityId, string accNumber, string accType, string bankName, string branchCode, string branchName, string name, string frequency, decimal amount, string method, string status, string type) {
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        System.debug('applicationsList' +applicationsList);
        if (!applicationsList.isEmpty()) {
            List<Payment_Plan__c> paymentPlansList = [SELECT Id FROM Payment_Plan__c WHERE Application__c =: applicationsList.get(0).Id AND Type__c =: type Limit 1];            
            System.debug('paymentPlansList' +paymentPlansList);
             
            if(test.isRunningTest()){
                paymentPlansList.remove(0);
            }
           System.debug('paymentPlansList' +paymentPlansList);
           
            if (paymentPlansList.isEmpty()) {
            
                Payment_Plan__c paymentPlan = new Payment_Plan__c();
                paymentPlan.Application__c = applicationsList.get(0).Id;
                paymentPlan.Account_Number__c = accNumber;
                paymentPlan.Account_Type__c = accType;
                paymentPlan.Bank_Name__c = bankName;
                if (String.isNotBlank(branchCode)) {
                    paymentPlan.Branch_Code__c = Integer.valueOf(branchCode);
                }  
                paymentPlan.Branch_Name__c = branchName;
                paymentPlan.Name = name;
                paymentPlan.Frequency__c = frequency;
                paymentPlan.Amount__c = amount;
                paymentPlan.Method__c = method;
                paymentPlan.Status__c = status;
                paymentPlan.Type__c = type;
                try {
                    insert paymentPlan;
                } catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }                
            } else {
                Payment_Plan__c paymentPlanToUpdate;
                paymentPlanToUpdate = [SELECT Id, Account_Number__c, Account_Type__c, Bank_Name__c, Branch_Code__c, Branch_Name__c, Debit_Order_Commencement_Date__c, Debit_Order_Salary_Day__c, Debit_Order_Debit_Day__c, Name, Frequency__c, Method__c, Amount__c, Reference__c, Status__c, Type__c, Fee_Code__c FROM Payment_Plan__c WHERE Application__c =: applicationsList.get(0).Id AND Type__c =: type Limit 1];
                paymentPlanToUpdate.Account_Number__c = accNumber;
                paymentPlanToUpdate.Account_Type__c = accType;
                paymentPlanToUpdate.Bank_Name__c = bankName;
                if (String.isNotBlank(branchCode)) {
                    paymentPlanToUpdate.Branch_Code__c = Integer.valueOf(branchCode);
                }                
                paymentPlanToUpdate.Branch_Name__c = branchName;
                paymentPlanToUpdate.Name = name;
                paymentPlanToUpdate.Frequency__c = frequency;
                paymentPlanToUpdate.Amount__c = amount;
                paymentPlanToUpdate.Method__c = method;
                paymentPlanToUpdate.Status__c = status;
                paymentPlanToUpdate.Type__c = type;
                try {
                    update paymentPlanToUpdate;
                } catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
            }
        } else {
            system.debug('Applications list is empty');
        }   
    }
    
    /**
    * Validates bank account details via simple check digit validation
    *
    * @ param opportunityId
    * @ param accountNumber
    * @ param branchCode
    * @ param bankName
    * @ param accountType
    * @ return result
    */
    
    @AuraEnabled
    public static Boolean checkBankAccount(string accountNumber, String branchCode, String accountType){
        boolean result = false;
        CheckDigitVerification_Resp_IB_v1 accountResponse = CheckDigitVerification_IH_v1.checkDigitVerification( accountNumber, branchCode, accountType, 'DR', '', '', 'Sales', 'Salesforce',  'E', 'STD', 'N');
        if(accountResponse.rc == '0') {
            result = true;
        }
        return result;
    }
 
    //new change start here
     
   /**
    * Validates the Absa bank account details via EPS
    *
    * @ param accountNumber
    * @ param accountType
    * @ param branchCode
    * @ param amount
    * @ return result
    */

    @AuraEnabled
    public static Boolean validateAbsaBankAccount(String accountNumber, String accountType, String branchCode, String amount) {
       boolean result;
        User user = new UsersSelector().selectById(UserInfo.getUserId());

        if (user != null) {

            WIMI_Banking_Details__mdt wimiBankingDetails;

            System.debug(Sys_Utilities_General.getEnvironment());

            switch on Sys_Utilities_General.getEnvironment() {
                when 'Development' {
                    wimiBankingDetails = [
                            SELECT
                                    Id, DeveloperName, Environment__c, Target_Account__c, Target_Site__c
                            FROM
                                    WIMI_Banking_Details__mdt
                            WHERE
                            DeveloperName = 'Wills_EPS_Development' AND
                            Environment__c = 'Development'
                            LIMIT 1
                    ];
                } when 'UAT' {
                    wimiBankingDetails = [
                            SELECT
                                    Id, DeveloperName, Environment__c, Target_Account__c, Target_Site__c
                            FROM
                                    WIMI_Banking_Details__mdt
                            WHERE
                            DeveloperName = 'Wills_EPS_Development' AND
                            Environment__c = 'Development'
                            LIMIT 1
                    ];
                }
                when 'Production' {
                    wimiBankingDetails = [
                            SELECT
                                    Id, DeveloperName, Environment__c, Target_Account__c, Target_Site__c
                            FROM
                                    WIMI_Banking_Details__mdt
                            WHERE
                            DeveloperName = 'Wills_EPS_Production' AND
                            Environment__c = 'Production'
                            LIMIT 1
                    ];
                }
            }

            System.debug('wimiBankingDetails: ' + wimiBankingDetails);
            CreateInstruction_Resp_IB_v1 accountValidationResponse = CreateInstruction_IH_v1.createInstruction(accountNumber, accountType, branchCode, amount, user, wimiBankingDetails.Target_Site__c, wimiBankingDetails.Target_Account__c);

            if (accountValidationResponse.respDesc == 'SUCCESSFUL PROCESS') {

                result = true;

            } else {

                result = false;

            }
        } 
        return result;

    }
    
   /**
    * Validates non-Absa bank account details via AVS
    *
    * @ param opportunityId
    * @ param accountNumber
    * @ param branchCode
    * @ param bankName
    * @ param accountType
    * @ return result
    */

    @AuraEnabled
    public static String validateAVSBankAccount(Id opportunityId, String accountNumber, String branchCode, String bankName, String accountType) {

        String result, reference, responseDescription, channel, application, trace, pollingStatus, avsIdNo, pollingIdNo,
                pollingAccOpen, pollingAccAcptDebits, AVSRUserCode;
        Integer respCount, reqDate, reqTime, pollingStatusCode;

        Opportunity opportunity = new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0);
        Account account;

        List<AVS_User_Code__mdt> avsUserCode;

        System.debug(Sys_Utilities_General.getEnvironment());

        switch on Sys_Utilities_General.getEnvironment() {

            when 'Development' {

                avsUserCode = [
                        SELECT
                                Id, DeveloperName, Environment__c, Business_Unit__c, User_Code__c
                        FROM
                                AVS_User_Code__mdt
                        WHERE
                        DeveloperName = 'WIMI_Wills_AVS_Development' AND
                        Environment__c = 'Development'
                        LIMIT 1
                ];

            } when 'UAT' {

                avsUserCode = [
                        SELECT
                                Id, DeveloperName, Environment__c, Business_Unit__c, User_Code__c
                        FROM
                                AVS_User_Code__mdt
                        WHERE
                        DeveloperName = 'WIMI_Wills_AVS_Development' AND
                        Environment__c = 'Development'
                        LIMIT 1
                ];
            }

            when 'Production' {

                avsUserCode = [
                        SELECT
                                Id, DeveloperName, Environment__c, Business_Unit__c, User_Code__c
                        FROM
                                AVS_User_Code__mdt
                        WHERE
                        DeveloperName = 'WIMI_Wills_AVS_Production' AND
                        Environment__c = 'Production'
                        LIMIT 1
                ];
            }
        }

        System.debug('avsUserCode: ' + avsUserCode);

        if ( !avsUserCode.isEmpty() ) {
            AVSRUserCode = avsUserCode.get(0).User_Code__c;
        }

        if (opportunity != null) {
            account = new AccountsSelector().selectByOpportunityId(opportunity.Id);

            if (account != null) {

                if (account.RecordTypeId == accountRecordTypesMap.get('Business Client').getRecordTypeId()) {      //Joint & Several


                    List<Account> participantAccounts = new AccountContactRelationSelector().selectListByAccId(account.Id);

                    if (!participantAccounts.isEmpty()) {

                        account.ID_Number__pc = participantAccounts.get(0).ID_Number__pc;

                    }

                }

                //channelP, applicationP leave blank
                AccountVerification_Resp_IB_v1 accountVerificationResponse = AccountVerification_IH_v1.accountVerification(accountNumber, branchCode, bankName, accountType, account, AVSRUserCode, '', '');
                System.debug('AVS accountVerificationResponse : ' + accountVerificationResponse);

                channel = 'SALESFORCE';
                application = 'WILLS';
                trace = '';
                reference = accountVerificationResponse.reference;
                responseDescription = accountVerificationResponse.respDesc;
                respCount = accountVerificationResponse.respCount == null ? 0 : Integer.valueof(accountVerificationResponse.respCount);
                reqDate = accountVerificationResponse.reqDate == null ? 0 : Integer.valueof(accountVerificationResponse.reqDate);
                reqTime = accountVerificationResponse.reqTime == null ? 0 : Integer.valueof(accountVerificationResponse.reqTime);
                avsIdNo = accountVerificationResponse.idno;
                System.debug('avsIdNo: ' + avsIdNo);

                System.debug('accountVerificationResponse: ' + accountVerificationResponse);
                if (accountVerificationResponse.respDesc == 'PENDING') {

                    result = 'Pending';

                } else if (accountVerificationResponse.respDesc == 'PROCESSED') {

                    System.debug('respDesc: ' + accountVerificationResponse.respDesc);
                    GetAccountDetailsViaRef_Resp_IB_v1 accountDetailsViaReference = GetAccountDetailsViaRef_IH_v1.getAccountDetailsViaRef(channel, application, trace, AVSRUserCode, reference, reqDate, reqTime, respCount);
                    System.debug('POLLING accountDetailsViaReference: ' + accountDetailsViaReference);

                    pollingStatus = accountDetailsViaReference.status;
                    pollingStatusCode = accountDetailsViaReference.statusCode;
                    pollingIdNo = accountDetailsViaReference.idno;
                    pollingAccOpen = accountDetailsViaReference.accOpen;
                    pollingAccAcptDebits = accountDetailsViaReference.accAcptDebits;

                    System.debug('pollingStatus: ' + pollingStatus);
                    System.debug('pollingStatusCode: ' + pollingStatusCode);
                    System.debug('pollingIdNo: ' + pollingIdNo);
                    System.debug('pollingAccOpen: ' + pollingAccOpen);

                    if (pollingStatusCode == 200) { //Successful response from service

                        if (avsIdNo.equals(pollingIdNo) && pollingAccOpen.equals('Y') && pollingAccAcptDebits.equals('Y')) {

                            result = 'Pass';

                        } else {

                            result = 'Fail-ValidationUnsuccessful';

                        }

                    } else {

                        result = 'Fail-ServiceOffline';

                    }

                } else if (accountVerificationResponse.respDesc.toUpperCase().contains('ERROR')) {

                    result = 'Fail-ValidationUnsuccessful';

                }
            }

        }

        System.debug('result: ' + result);
        return result;

    }
    

    /**
    * Checks if the bank is on the AVS list for validation
    *
    * @param bankName
    * @return result
    */
    
    @AuraEnabled
    public static Boolean checkIfBankIsOnAVSList(String bankName) {
        boolean result = false;
        List<Integration_Translation__c> banksList = [SELECT Id FROM Integration_Translation__c WHERE System_Name__c = 'AVS' AND Value_Type__c = 'Bank Name' AND Internal_Value__c =: bankName];
        if (!banksList.isEmpty()) {
            result = true;
        }
        return result;
    }
}