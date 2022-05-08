/**
* Controller class for the MerchantBankingDetails & MultiBankingDetails components
* @author Danie Booysen
* @created 04/2020
*/
public with sharing class MerchantBankingDetailsController {

    /**
    * Retrieves the payment plan of specific type for the opportunity
    *
    * @param opportunityId
    * @param type
    * @return paymentPlansList
    */
    @AuraEnabled
    public static Map<String, Payment_Plan__c> getBankAccountDetails(String opportunityId, String type){
        Map<String, Payment_Plan__c> paymentPlanMap = new Map<String, Payment_Plan__c>();
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        List<Payment_Plan__c> paymentPlansList = new PaymentPlansSelector().selectByTypeByApplicationId(applicationsList.get(0).Id, type, 2);
        Payment_Plan__c currentPayPlan = new Payment_Plan__c();
        if (paymentPlansList != null && !paymentPlansList.isEmpty()) {
            for(Payment_Plan__c paymentPlan  : paymentPlansList){
                paymentPlanMap.put(paymentPlan.Type_of_Details__c, paymentPlan);
            }
        }
        System.debug('paymentPlanMap key: ' + paymentPlanMap.keySet());
        return paymentPlanMap ;
    }

    /**
    * Validates bank account details via simple check digit validation
    *
    * @ param accountNumber
    * @ param branchCode
    * @ param accountType
    * @ return result
    */
    @AuraEnabled
    public static Boolean checkBankAccount(String accountNumber, String branchCode, String accountType){
        boolean result = false;
        CheckDigitVerification_Resp_IB_v1 accountResponse = CheckDigitVerification_IH_v1.checkDigitVerification( accountNumber, branchCode, accountType, 'DR', '', '', 'Sales', 'Salesforce',  'E', 'STD', 'N');

        if(accountResponse != null){
            System.debug('CheckDigitVerification_Resp: ' + accountResponse.rc);
            if(accountResponse.rc == '0') {
                result = true;
            }
        }
        return result;
    }

    /**
    * Saves bank account details on a Payment Plan record
    *
    * @ param opportunityId
    * @ param accNumber
    * @ param accType
    * @ param bankName
    * @ param branchCode
    * @ param branchName
    * @ param name
    * @ param status
    * @ param typeOfDetails
    */
    @AuraEnabled
    public static void submitPaymentPlanDetail(Id opportunityId, String accNumber, String accType, String bankName, String branchCode, String branchName, String name, String type, String status, String typeOfDetails){

        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);

        System.debug('applicationsList: ' + applicationsList.size());
        if (!applicationsList.isEmpty() && applicationsList != null) {
            List<Payment_Plan__c> paymentPlansList = new PaymentPlansSelector().selectByApplicationIdByTypeDetails(applicationsList.get(0).Id, typeOfDetails, 1);
            if (paymentPlansList == null || paymentPlansList.isEmpty()) {
                //Insert New Banking Details
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
                paymentPlan.Method__c = 'Debit Order';
                paymentPlan.Status__c = status;
                paymentPlan.Type__c = type;
                paymentPlan.Type_of_Details__c = typeOfDetails;

                insert paymentPlan;
            } else {
                //Update Existing Banking Details
                Payment_Plan__c paymentPlanToUpdate;
                paymentPlanToUpdate = paymentPlansList.get(0);
                paymentPlanToUpdate.Account_Number__c = accNumber;
                paymentPlanToUpdate.Account_Type__c = accType;
                paymentPlanToUpdate.Bank_Name__c = bankName;
                if (String.isNotBlank(branchCode)) {
                    paymentPlanToUpdate.Branch_Code__c = Integer.valueOf(branchCode);
                }
                paymentPlanToUpdate.Branch_Name__c = branchName;
                paymentPlanToUpdate.Name = name;
                paymentPlanToUpdate.Method__c = 'Debit Order';
                paymentPlanToUpdate.Status__c = status;
                paymentPlanToUpdate.Type__c = type;

                update paymentPlanToUpdate;
            }
        } else {
            system.debug('Applications list is empty');
        }
    }

    /**
    * Method that gets all picklist data
    *
    * @param objObject - Id of the specific opportunity party being removed
    * @param fld - field name i.e. Account_Type__c
    */
    @AuraEnabled
    public static List <String> getSelectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();

        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        return allOpts;
    }

	/**
    * Method that returns the Application__c object for the Opportunity
    *
    * @param opportunityIdP - Id of the opportunity
    */
   @AuraEnabled
    public static Application__c getApplication(Id opportunityIdP) {

        Application__c application;

        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityIdP);
        if(applicationsList != null && applicationsList.size() > 0){
            application = applicationsList[0];
        }
        return application;
    }

}