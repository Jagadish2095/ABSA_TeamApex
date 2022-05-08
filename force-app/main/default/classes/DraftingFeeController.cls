/**
* Controller class for the Drafting Fee lightning component
* @author Vladimir Panajic
* @created 2018-12-14
* @modified 2019/05/17 (Nelson Chisoko)
* @modified 2019/10/21 (Lulu Rankwe)
* @modified 2019/11/15 (Rob McLean)
*/

public with sharing class DraftingFeeController {

    static Map <String, Schema.RecordTypeInfo> applicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    static Map <String, Schema.RecordTypeInfo> accountRecordTypesMap = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    /**
    * Checks whether a payment preference has been set on application
    *
    * @param opportunityId
    * @return paymentPreferenceSet
    */
    @AuraEnabled
    public static boolean checkPaymentPreferenceSetonApplication(Id opportunityId) {
        Boolean paymentPreferenceSet = false;
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {            
            //Check if Fees Waived or Fee Paid flags 
            if (applicationsList.get(0).Fees_Waived__c || applicationsList.get(0).Fee_For_Estate_Provider_Plan__c || applicationsList.get(0).Fee_For_Staff__c || !new PaymentPlansSelector().selectByTypeByApplicationId(applicationsList.get(0).Id, 'Will Drafting Fee', 1).isEmpty()) {               	
                paymentPreferenceSet = true;   
           } 
        }
        return paymentPreferenceSet;
    }   

    /**
	* Returns the payment method type that has been set on application
	*
	* @param opportunityId
	* @return paymentPreferenceSetType
	*/
    @AuraEnabled
    public static String checkPaymentPreferenceSetTypeonApplication(Id opportunityId) {
        String paymentPreferenceSetType;
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);        
        if (!applicationsList.isEmpty()) {
            if (applicationsList.get(0).Fees_Waived__c) {                                
                paymentPreferenceSetType = 'Fees Waived';
            } else if(applicationsList.get(0).Fee_For_Estate_Provider_Plan__c){
                paymentPreferenceSetType = 'Fees for Estate Provider Plan';
            } else if(applicationsList.get(0).Fee_For_Staff__c){
                paymentPreferenceSetType = 'Fees for Staff';
           } else {
                paymentPreferenceSetType = 'Fees Paid';
            }
        }
        return paymentPreferenceSetType;
    }

    /**
    * Checks whether drafting banking details have been validated
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
            if (applicationsList.get(0).Drafting_Banking_Details_Validated__c) {
                bankingDetailsValidated = true;
            }
        }
        return bankingDetailsValidated;
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
                applicationsList.get(0).Drafting_Banking_Details_Validated__c = true;
            } 
            else {
                applicationsList.get(0).Drafting_Banking_Details_Validated__c = false;
            }
            try {
                update applicationsList.get(0);
            } 
            catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
    }
    
    /**
    * Creates opportunity item
    *
    * @param opportunityId
    * @param product
    * @return  opportunityLineItem
    */    
    @AuraEnabled
    public static OpportunityLineItem createPricebookEntry(Id opportunityId, Product2 product){        
        OpportunityLineItem opportunityLineItem;
        Pricebook2 standardPriceBook = [SELECT Id, Name, IsActive FROM PriceBook2 WHERE IsStandard = true LIMIT 1];
        if (standardPriceBook != null) {
            if (product != null) {
                PricebookEntry pricebookEntry = new PriceBookEntriesSelector().selectByProduct2Id(product.Id);
                System.debug('pricebookEntry: ' + pricebookEntry);
                if (pricebookEntry != null) {
                    opportunityLineItem = new OpportunityLineItem (
                        PricebookEntryId = pricebookEntry.Id,
                        OpportunityId = opportunityId,
                        Quantity = 1,
                        TotalPrice = (1 * new PriceBookEntriesSelector().selectById(pricebookEntry.Id).UnitPrice)
                    );
                }
            }
        }
        return opportunityLineItem;
    }

    /**
    * delete opportunity item
    *
    * @param opportunityId
    */ 
    @AuraEnabled
    public static void deleteOpportunityLineItems(Id opportunityId){        
        try{            
            List<OpportunityLineItem> oldOpportunityLineItems = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
            delete oldOpportunityLineItems;            
        } catch (DmlException e) {            
            System.debug('An unexpected error has occurred: ' + e.getMessage());            
        }        
    }    

    /**
    * Updates the application record related to the opportunity
    *
    * @param opportunityId
    * @param paymentPreferenceType
    */    
    @AuraEnabled
    public static void updateApplication(Id opportunityId, String paymentPreferenceType) {   
        List<Application__c> applicationToUpdate = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        OpportunityLineItem opportunityLineItem;
        Product2 product ;        
        if (!applicationToUpdate.isEmpty()) {            
            switch on paymentPreferenceType {           
                // create product fee code 4: R0.0 - WAIVED(ABSA EXECUTER)
                when 'Fees Waived'{                    
                    applicationToUpdate.get(0).Fee_For_Estate_Provider_Plan__c = false;
                    applicationToUpdate.get(0).Fee_For_Staff__c = false;                    
                    applicationToUpdate.get(0).Fees_Waived__c = true;
                    applicationToUpdate.get(0).Drafting_Fee_Status__c = 'Valid';
                    applicationToUpdate.get(0).Drafting_Banking_Details_Validated__c = true;                                       
                    product = new ProductsSelector().selectByName('R0.00 - WAIVED (ABSA EXECUTOR)');
                    system.debug('product: after ' + product.Name);
                    opportunityLineItem = createPricebookEntry(opportunityId, product);
                    try {                        
                        insert opportunityLineItem;                        
                    } 
                    catch (DmlException e) {                        
                        System.debug('An unexpected error has occurred: ' + e.getMessage());
                    }                    
                } 
                	when 'Fees for Estate Provider Plan'{                    
                    applicationToUpdate.get(0).Fees_Waived__c = false;
                    applicationToUpdate.get(0).Fee_For_Staff__c = false;                    
                    applicationToUpdate.get(0).Fee_For_Estate_Provider_Plan__c = true;
                    applicationToUpdate.get(0).Drafting_Fee_Status__c = 'Valid';
                    applicationToUpdate.get(0).Drafting_Banking_Details_Validated__c = true;                     
                    // create product fee code 4: R0.0 - ESTATE PROVIDER PLAN
                    product = new ProductsSelector().selectByName('R0.00 - ESTATE PROVIDER PLAN'); 
                    opportunityLineItem = createPricebookEntry(opportunityId,product); 
                    try {                        
                        insert opportunityLineItem;
                    } 
                    catch (DmlException e) {                        
                        System.debug('An unexpected error has occurred: ' + e.getMessage());
                    }                    
                } 
                when 'Fees for Staff' {                    
                    applicationToUpdate.get(0).Fees_Waived__c = false;
                    applicationToUpdate.get(0).Fee_For_Estate_Provider_Plan__c = false;                    
                    applicationToUpdate.get(0).Fee_For_Staff__c = true;
                    applicationToUpdate.get(0).Drafting_Fee_Status__c = 'Valid';
                    applicationToUpdate.get(0).Drafting_Banking_Details_Validated__c = true;                    
                    // create product fee code 4: R0.0 - EXEMPTED - STAFF
                    product = new ProductsSelector().selectByName('R0.00 - EXEMPTED - STAFF'); 
                    opportunityLineItem = createPricebookEntry(opportunityId, product);
                    try {                        
                        insert opportunityLineItem;                        
                    } 
                    catch (DmlException e) {                        
                        System.debug('An unexpected error has occurred: ' + e.getMessage());
                    }       
                } 
                when 'Fees Paid' {
                    applicationToUpdate.get(0).Fees_Waived__c = false;
                    applicationToUpdate.get(0).Fee_For_Estate_Provider_Plan__c = false;
                    applicationToUpdate.get(0).Fee_For_Staff__c = false;                    
                    applicationToUpdate.get(0).Drafting_Fee_Status__c = 'Valid';
                    applicationToUpdate.get(0).Drafting_Banking_Details_Validated__c = false;
                }
            }            
            try {                
                update applicationToUpdate.get(0);                
            } 
            catch(DmlException e) {                
                System.debug('An unexpected error has occurred: ' + e.getMessage());                
            }
        }
    }

    /**
    * Retrieves the application record for the opportunity
    *
    * @param opportunityId
    * @return application
    */
    @AuraEnabled
    public static Application__c getApplicationByOpportunityId(Id opportunityId) {
        Application__c application = new Application__c();
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {
            application = applicationsList.get(0);
        }
        return application;
    }

    /**
    * Creates an application record related to the opportunity
    *
    * @param opportunityId              The opportunity Id
    * @param paymentPreferenceType      The payment preference that has been selected
    */
    @AuraEnabled
    public static void submitApplication(Id opportunityId, String paymentPreferenceType) {        
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        OpportunityLineItem opportunityLineItem;
        Product2 product;
        Application__c application = new Application__c();        
        if (applicationsList.isEmpty()) {          
            application.RecordTypeId = applicationRecordTypeMap.get('Wills').getRecordTypeId();
            application.Opportunity__c = opportunityId;
            switch on paymentPreferenceType {                
                when 'Fees Waived' {                    
                    application.Fee_For_Estate_Provider_Plan__c = false;
                    application.Fee_For_Staff__c = false;                    
                    application.Fees_Waived__c = true;
                    application.Drafting_Fee_Status__c = 'Valid';
                    application.Drafting_Banking_Details_Validated__c = true;                    
                    product = new ProductsSelector().selectByName('R0.00 - WAIVED (ABSA EXECUTOR)');                   
                    opportunityLineItem = createPricebookEntry(opportunityId, product); 
                }
                when 'Fees for Estate Provider Plan'{                    
                    application.Fees_Waived__c = false;
                    application.Fee_For_Staff__c = false;                    
                    application.Fee_For_Estate_Provider_Plan__c = true;
                    application.Drafting_Fee_Status__c = 'Valid';
                    application.Drafting_Banking_Details_Validated__c = true;                     
                    product = new ProductsSelector().selectByName('R0.00 - ESTATE PROVIDER PLAN'); 
                    opportunityLineItem = createPricebookEntry(opportunityId, product);
                } 
                when 'Fees for Staff' {                   	
                    application.Fees_Waived__c = false;
                    application.Fee_For_Estate_Provider_Plan__c = false; 
                    application.Fee_For_Staff__c = true;                    
                    application.Drafting_Fee_Status__c = 'Valid';
                    application.Drafting_Banking_Details_Validated__c = true;                    
                    product = new ProductsSelector().selectByName ('R0.00 - EXEMPTED - STAFF'); 
                    opportunityLineItem = createPricebookEntry(opportunityId, product); 
                } 
                when 'Fees Paid' {					
                    application.Fees_Waived__c = false;
                    application.Fee_For_Estate_Provider_Plan__c = false;
                    application.Fee_For_Staff__c = false;                    
                    application.Drafting_Fee_Status__c = 'Valid';
                    application.Drafting_Banking_Details_Validated__c = false;
                }
            }
            try {
                insert application;
                if (application != null && opportunityLineItem != null) {
                    opportunityLineItem.Application__c = application.Id;
                    insert opportunityLineItem;
                }
            } 
            catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        } 
        else {    //Update the Application
            deleteOpportunityLineItems(opportunityId);
            updateApplication(opportunityId, paymentPreferenceType); 
        }        
    }
   
    /**
    * Updates the drafting fee status on the application record related to the opportunity
    *
    * @param opportunityId
    * @param draftingFeeStatus
    */
    @AuraEnabled
    public static void submitDraftingFeeStatus(Id opportunityId, String draftingFeeStatus) {
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        System.debug('applicationsList: ' + applicationsList);
        if (applicationsList.isEmpty()) {
            submitApplication(opportunityId, 'Fees Paid');
            applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        }
        if (draftingFeeStatus != null) {
            applicationsList.get(0).Drafting_Fee_Status__c = 'Valid';
            try {
                update applicationsList.get(0);
            } catch (DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
    }

    /**
    * Creates a product line item record related to the opportunity
    *
    * @param opportunityId
    * @param productName
    * @param quantity
    * @param totalPrice
    */
    @AuraEnabled
    public static void submitProductItem(Id opportunityId, String productName, Integer quantity, Decimal totalPrice) {
        if(quantity == null){
            quantity = 1;
        }
        if(totalPrice == null){
            totalPrice = 1.00;
        }
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (!applicationsList.isEmpty()) {
            Product2 product = [SELECT Id FROM Product2 WHERE Name =: productName];
            PricebookEntry pricebookEntry = [SELECT Product2Id, Pricebook2Id, UnitPrice, IsActive FROM PricebookEntry WHERE Product2Id =: product.Id AND IsActive = true];
            if (pricebookEntry != null) {
                List<OpportunityLineItem> opportunityLineItems = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
                if (!opportunityLineItems.isEmpty()) {
                    try {
                        delete opportunityLineItems.get(0);
                    } 
                    catch(DmlException e) {
                        System.debug('An unexpected error has occurred: ' + e.getMessage());
                    }
                }
                OpportunityLineItem opportunityLineItem = new OpportunityLineItem (PricebookEntryId = pricebookEntry.Id, OpportunityId = opportunityId, Quantity = quantity, TotalPrice = (totalPrice * pricebookEntry.UnitPrice), Application__c = applicationsList.get(0).Id);
                try {
                    insert opportunityLineItem;
                } 
                catch(DmlException e) {
                    System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
            }
        }
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
        Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }

    /**
    * Retrieves all Will related products
    *
    * @return draftingFeeList
    */
    @AuraEnabled
    public static List<String> getDraftingFeesList() {
        List<String> draftingFeeList = new List<String>();
        Id financialProductId;
        List<Financial_Product__c> financialProductsList = [SELECT Id FROM Financial_Product__c WHERE Name = 'Will'];
        System.debug('financialProductsList: ' + financialProductsList);
        if (!financialProductsList.isEmpty()) {
            financialProductId = financialProductsList.get(0).Id;
        }
        //not sure how to order by using selector
        List<Product2> productsList = [SELECT Name FROM Product2 WHERE Financial_Product__c =: financialProductId AND IsActive =: true 
                                       AND Name <> 'R0.00 - ESTATE PROVIDER PLAN' AND Name <> 'R0.00 - EXEMPTED - STAFF'  AND Name <> 'R0.00 - WAIVED (ABSA EXECUTOR)' ORDER BY Description];
        System.debug('productsList: ' + productsList);
        if (!productsList.isEmpty()) {
            Integer i = 0;
            for (Product2 product: productsList) {
                draftingFeeList.add(productsList.get(i).Name);
                i += 1;
            }
        }
        return draftingFeeList;
    }

    /**
    * Retrieves Will related products for Direct Debit (without 'AS PAID IN - AN AMOUNT (NOT LISTED)' product)
    *
    * @return draftingFeeList (without 'AS PAID IN - AN AMOUNT (NOT LISTED)' product)
    */
    @AuraEnabled
    public static List<String> getDraftingFeesDirectDebitList() {
        List<String> draftingFeeList = new List<String>();
        Id financialProductId;
        List<Financial_Product__c> financialProductsList = [SELECT Id FROM Financial_Product__c WHERE Name = 'Will'];
        if (!financialProductsList.isEmpty()) {
            financialProductId = financialProductsList.get(0).Id;
        }
        //not sure how to order by using selector
        List<Product2> productsList = [SELECT Name FROM Product2 WHERE Financial_Product__c =: financialProductId AND IsActive =: true AND Name <> 'AS PAID IN - AN AMOUNT (NOT LISTED)' 
                                       AND Name <> 'R0.00 - ESTATE PROVIDER PLAN' AND Name <> 'R0.00 - EXEMPTED - STAFF'  AND Name <> 'R0.00 - WAIVED (ABSA EXECUTOR)' ORDER BY Description];
        if (!productsList.isEmpty()) {
            Integer i = 0;
            for (Product2 product: productsList) {
                draftingFeeList.add(productsList.get(i).Name);
                i += 1;
            }
        }
        return draftingFeeList;
    }

    /**
    * Retrieves person account identification number
    *
    * @param opportunityId
    * @return personAccountIDNumber
    */
    @AuraEnabled
    public static String getPersonAccountIDNumber(Id opportunityId) {
        List<Opportunity> opportunitiesList = new OpportunitiesSelector().selectByOpportunityId(opportunityId, 1);
        String personAccountIDNumber;
        if (!opportunitiesList.isEmpty()) {
            AccountsSelector acs = new AccountsSelector();
            Set<Id> idsSet = new Set<Id>();
            idsSet.add(opportunitiesList.get(0).AccountId);
            List<Account> accountsList = acs.selectById(idsSet);
            if (!accountsList.isEmpty()) {
                personAccountIDNumber = accountsList.get(0).ID_Number__pc;
            }
        }
        return personAccountIDNumber;
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
    * @param reference
    * @param method
    * @param status
    * @param type
    * @param productName
    */
    @AuraEnabled
    public static void submitPaymentPlanDetail(Id opportunityId, string accNumber, string accType, string bankName, string branchCode, string branchName, string name, string frequency, decimal amount, string reference, string method, string status, string type, string productName) {
        String feeCode = '';
        if (type == 'Will Drafting Fee') {
            Product2 product = new ProductsSelector().selectByName(productName, 1);
            feeCode = product.ProductCode;
        }
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        if (applicationsList.isEmpty()) {
            submitApplication(opportunityId, 'Fees Paid');
        }
        applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
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
                paymentPlan.Reference__c = reference;
                paymentPlan.Method__c = method;
                paymentPlan.Status__c = status;
                paymentPlan.Type__c = type;
                if (type == 'Will Drafting Fee') {
                    paymentPlan.Fee_Code__c = feeCode;
                }
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
                paymentPlanToUpdate.Reference__c = reference;
                paymentPlanToUpdate.Method__c = method;
                paymentPlanToUpdate.Status__c = status;
                paymentPlanToUpdate.Type__c = type;
                if (type == 'Will Drafting Fee') {
                    paymentPlanToUpdate.Fee_Code__c = feeCode;
                }
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
    * Checks if the payment plan of specific type exists for the opportunity
    *
    * @param opportunityId
    * @param type
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
    * Checks if the product line item exists for the opportunity
    *
    * @param opportunityId
    * @return opportunityLineItem
    */
    @AuraEnabled
    public static boolean existsOpportunityLineItem(Id opportunityId) {
        boolean opportunityLineItem = false;
        List<OpportunityLineItem> opportunityLineItems = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId =: opportunityId];
        if (!opportunityLineItems.isEmpty()) {
            opportunityLineItem = true;
        }
        return opportunityLineItem;
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
        Payment_Plan__c currentPayPlan = new Payment_Plan__c();
        if (!paymentPlansList.isEmpty()) {
                currentPayPlan = paymentPlansList.get(0);
            }
        return currentPayPlan ;
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
                            LIMIT 1];
                } when 'UAT' {
                    wimiBankingDetails = [
                            SELECT
                                    Id, DeveloperName, Environment__c, Target_Account__c, Target_Site__c
                            FROM
                                    WIMI_Banking_Details__mdt
                            WHERE
                                    DeveloperName = 'Wills_EPS_Development' AND
                                    Environment__c = 'Development'
                            LIMIT 1];
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
                            LIMIT 1];
                }
            }
            System.debug('wimiBankingDetails: ' + wimiBankingDetails);
            CreateInstruction_Resp_IB_v1 accountValidationResponse = CreateInstruction_IH_v1.createInstruction(accountNumber, accountType, branchCode, amount, user, wimiBankingDetails.Target_Site__c, wimiBankingDetails.Target_Account__c);
            if (accountValidationResponse.respDesc == 'SUCCESSFUL PROCESS') {
                result = true;
            } 
            else {
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
                        LIMIT 1];
            } when 'UAT' {
                avsUserCode = [
                        SELECT
                                Id, DeveloperName, Environment__c, Business_Unit__c, User_Code__c
                        FROM
                                AVS_User_Code__mdt
                        WHERE
                                DeveloperName = 'WIMI_Wills_AVS_Development' AND
                                Environment__c = 'Development'
                        LIMIT 1];
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
                        LIMIT 1];
            }
        }
        System.debug('avsUserCode: ' + avsUserCode);
        if (!avsUserCode.isEmpty() ) {
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
                } 
                else if (accountVerificationResponse.respDesc == 'PROCESSED') {
                    System.debug('respDesc: ' + accountVerificationResponse.respDesc);
                    GetAccountDetailsViaRef_Resp_IB_v1 accountDetailsViaReference = GetAccountDetailsViaRef_IH_v1.getAccountDetailsViaRef(channel,application, trace, AVSRUserCode, reference, reqDate, reqTime, respCount);
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
                        } 
                        else {
                            result = 'Fail-ValidationUnsuccessful';
                        }
                    } 
                    else {
                        result = 'Fail-ServiceOffline';
                    }
                } 
                else if (accountVerificationResponse.respDesc.toUpperCase().contains('ERROR')) {
                    result = 'Fail-ValidationUnsuccessful';
                }
            }
        }
        System.debug('result: ' + result);
        return result;
    }

    /**
    * Checks if the bank name is on the AVS list for validation
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

    /**
    * Gets the product name for the opportunity
    *
    * @param opportunityId
    * @return productName
    */
    @AuraEnabled
    public static String getProductName(Id opportunityId) {
        System.debug('getProductName');
        String productName;
        List<OpportunityLineItem> opportunityLineItems = [SELECT Product2Id FROM OpportunityLineItem WHERE OpportunityId =: opportunityId];
        System.debug('opportunityLineItems: ' + opportunityLineItems);
        if (!opportunityLineItems.isEmpty()) {
            Set<Id> idSet = new Set<Id>();
            idSet.add(opportunityLineItems.get(0).Product2Id);
            System.debug('idSet: ' + idSet);
            List<Product2> productsList = new ProductsSelector().selectById(idSet);
            System.debug('productsList: ' + productsList);
            if (!productsList.isEmpty()) {
                productName = productsList.get(0).Name;
            }
        }
        return productName;
    }

    /**
     * Checks if the casa screening has been done
     *
     * @param opportunityId
     * @return String - casa status i.e. valid, invalid etc...
     */
    @AuraEnabled
    public static String checkCASAValidity(Id opportunityId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
        return opportunities.get(0).CASA_Status__c;
    }
}