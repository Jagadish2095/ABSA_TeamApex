/**
 * @description       : Controller class for CreditCard aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * @last modified on  : 07-21-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   ephetehe.mokgopanyane@tetrad.co.za   Initial Version
 **/

public class CreditCardCtrl {
    /**
     * @description getExistingAccounts
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-11
     * @param opportunityId
     * @return List<Map<String, String>>
     **/
    @AuraEnabled(Cacheable = true)
    public static List<Map<String, String>> getExistingAccounts(Id opportunityId) {
        List<Map<String, String>> creditCards = new List<Map<String, String>>();
        Application__c app = new ApplicationsSelector().selectByOpportunityId(opportunityId)[0];

        if (app.Accounts_Orchestration_JSON__c != null) {
            ChequeServicesOrchestration_Resp_IB_v1 respOrches = (ChequeServicesOrchestration_Resp_IB_v1) JSON.deserialize(
                app.Accounts_Orchestration_JSON__c,
                ChequeServicesOrchestration_Resp_IB_v1.class
            );

            //this code hasn't merged in sit,adding again
            if (respOrches != null && respOrches.CAgetCassACSBEnqV1Responses != null) {
                for (ChequeServicesOrchestration_Resp_IB_v1.CAgetCassACSBEnqV1Responses output: respOrches.CAgetCassACSBEnqV1Responses) {
                    if ((output.CAgetCassACSBEnqV1Response.cap918o.accType == 'SLB'
                        || output.CAgetCassACSBEnqV1Response.cap918o.accType == 'GLB') && output.CAgetCassACSBEnqV1Response.cap918o.acctStatCd == 'AAA') {
                        Map<String, String> creditCard = new Map<String, String>();
                        creditCard.put(
                            'encrytepAccountNumber',
                            ChequeAndOverdraftController.encryptDecryptString(output.CAgetCassACSBEnqV1Response.cap918o.kbAcctNbr, true)
                        );
                        creditCard.put('accountNumber', output.CAgetCassACSBEnqV1Response.cap918o.kbAcctNbr);
                        creditCard.put('creditCardLimit', output.CAgetCassACSBEnqV1Response.cap918o.creditLimit);
                        creditCard.put('allocatedLimit', output.CAgetCassACSBEnqV1Response.cap918o.allocatedLimit);
                        creditCard.put('accBalance', output.CAgetCassACSBEnqV1Response.cap918o.accountBalance);
                        creditCard.put('accStatus', output.CAgetCassACSBEnqV1Response.cap918o.acctStatCd);
                        creditCard.put('accStatusDesc', output.CAgetCassACSBEnqV1Response.cap918o.statCdDescr);
                        creditCard.put('instalment', output.CAgetCassACSBEnqV1Response.cap918o.instalment);
                        creditCard.put('serviceFeeAmnt', output.CAgetCassACSBEnqV1Response.cap918o.serviceFee);
                        creditCard.put('interestRate', output.CAgetCassACSBEnqV1Response.cap918o.intRate);
                        creditCard.put('interestType', output.CAgetCassACSBEnqV1Response.cap918o.intRateType);
                        creditCard.put('expiryDate', output.CAgetCassACSBEnqV1Response.cap918o.expiryDate);
                        creditCard.put('product', output.CAgetCassACSBEnqV1Response.cap918o.subProd);
                        creditCard.put('subProduct', output.CAgetCassACSBEnqV1Response.cap918o.accType);
                        creditCard.put('requestedCreditCardLimit', '');
                        creditCard.put('campaignCode', '');
                        creditCard.put('isSelected', 'false');
                        creditCards.add(creditCard);
                    }
                }
            }

            return creditCards;
        }

        return null;
    }

    /**
     * @description getManagedAccounts
     * @author ephetehe.mokgopanyane@tetrad.co.za  | 2021-06-11
     * @param opportunityId
     * @return List<Map<String, String>>
     **/
    @AuraEnabled(Cacheable = true)
    public static List<Map<String, String>> getManagedAccounts(Id opportunityId) {
        List<Application_Product__c> appProducts = new ApplicationProductSelector().selectByOpportunityId(opportunityId);
        List<Map<String, String>> mngdAccs = new List<Map<String, String>>();

        if (appProducts != null && appProducts.size() > 0) {
            for (Application_Product__c appProd: appProducts) {
                if (appProd.Product_Name__c == 'Credit Card' && appProd.Product_State__c == 'Existing') {
                    Map<String, String> mngdAcc = new Map<String, String>();
                    mngdAcc.put('recordId', appProd.Id);
                    mngdAcc.put('accountNumber', String.valueOf(appProd.Account_Number__c));
                    mngdAcc.put('creditCardLimit', String.valueOf(appProd.Credit_Card_Limit__c));
                    mngdAcc.put('allocatedLimit', String.valueOf(appProd.Allocated_Limit__c));
                    mngdAcc.put('accBalance', String.valueOf(appProd.Account_Balance__c));
                    mngdAcc.put('accStatus', appProd.Account_Status__c);
                    mngdAcc.put('accStatusDesc', appProd.Account_Status_Description__c);
                    mngdAcc.put('instalment', String.valueOf(appProd.Instalment__c));
                    mngdAcc.put('serviceFeeAmnt', String.valueOf(appProd.Service_Fee_Amount__c));
                    mngdAcc.put('interestRate', String.valueOf(appProd.Interest_Rate__c));
                    mngdAcc.put('interestType', appProd.Credit_Card_Interest_Type__c);
                    mngdAcc.put('expiryDate', String.valueOf(appProd.Expiry_Date__c));
                    mngdAcc.put('requestedCreditCardLimit', appProd.Requested_facility_limit__c);
                    mngdAcc.put('campaignCode', appProd.Campaign_Code__c);
                    mngdAcc.put('opportunityId', opportunityId);
                    mngdAccs.add(mngdAcc);
                }
            }
        }

        return mngdAccs;
    }

    /**
     * @description getNewAccounts
     * @author ephetehe.mokgopanyane@tetrad.co.za  | 2021-06-11
     * @param opportunityId
     * @return List<Application_Product__c>
     **/
    @AuraEnabled(Cacheable = true)
    public static List<Application_Product__c> getNewAccounts(Id opportunityId) {
        List<Application_Product__c> appProducts = new ApplicationProductSelector().selectByOpportunityId(opportunityId);
        List<Application_Product__c> newAccounts = new List<Application_Product__c>();

        if (appProducts != null && appProducts.size() > 0) {
            for (Application_Product__c appProd: appProducts) {
                if (appProd.Product_Name__c == 'Credit Card' && appProd.Product_State__c == 'New') {
                    newAccounts.add(appProd);
                }
            }
        }

        return newAccounts;
    }

    /**
     * @description createNewCreditCard
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-11
     * @param opportunityId
     * @return Application_Product__c
     **/
    @AuraEnabled(Cacheable = false)
    public static Application_Product__c createNewCreditCard(Id opportunityId) {
        Application_Product__c appProduct = new Application_Product__c();
        appProduct.Opportunity__c = opportunityId;
        appProduct.Opportunity_Product_Id__c = opportunityId;
        appProduct.Product_State__c = 'New';
        appProduct.Product_Name__c = 'Credit Card';

        try {
            insert appProduct;
        } catch (Exception exc) {
            throw new AuraHandledException(String.valueOf(exc));
        }

        ApplicationProductSelector appProductSelector = new ApplicationProductSelector();
        appProduct = appProductSelector.selectById(new Set<Id>{ appProduct.Id })[0];

        return appProduct;
    }

    /**
     * @description saveAndValidateData
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-11
     * @param managedAccounts
     * @param newAccounts
     * @return Boolean
     **/
    @AuraEnabled(Cacheable = false)
    public static Boolean saveAndValidateData(String managedAccounts, List<Application_Product__c> newAccounts) {
        List<cls_ManagedAccount> mngdAccs = (List<cls_ManagedAccount>) JSON.deserialize(managedAccounts, List<cls_ManagedAccount>.class);
        List<Application_Product__c> appProducts = new List<Application_Product__c>();
        List<Application_Product__c> existingAppProds = new List<Application_Product__c>();
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        Id opportunityId = mngdAccs != null && mngdAccs.size() > 0 ? mngdAccs[0].opportunityId : newAccounts[0].Opportunity__c;
        Id product2Id;
        Boolean dmlSuccess = false;
        Product2 creditCardProduct = new ProductsSelector().selectByName('Credit Card');
        Application__c app = new ApplicationsSelector().selectByOpportunityId(opportunityId)[0];

        if(app != null && isConductDataRequired(app)){
        	List<Application_Financial_Conduct__c> appFinConList = new ApplicationFinancialConductSelector().selectByApplicationId(app.Id);

            if(appFinConList == null && appFinConList.size() == 0) {
                throw new AuraHandledException('Please select Primary/Additional Conduct accounts on Cheque and Overdraft section');
            }
        }

        if (creditCardProduct != null) {
            product2Id = Sys_Utilities_General.getPriceBookEntryId(creditCardProduct.Id);
        }

        if (mngdAccs != null && mngdAccs.size() > 0 && creditCardProduct != null) {
            Map<String, String> existingAccNums = getExistingAccNums(new ApplicationProductSelector().selectByOpportunityId(mngdAccs[0].opportunityId));

            for (cls_ManagedAccount mngdAcc: mngdAccs) {
                Application_Product__c appProd = new Application_Product__c();
                appProd.Product_State__c = 'Existing';
                appProd.Product_Name__c = 'Credit Card';
                appProd.Account_Balance__c = Decimal.valueOf(mngdAcc.accBalance);
                appProd.Account_Number__c = Decimal.valueOf(mngdAcc.accountNumber);
                appProd.Credit_Card_Limit__c = Decimal.valueOf(mngdAcc.creditCardLimit);
                //appProd.Expiry_Date__c = Date.valueOf(mngdAcc.expiryDate);
                appProd.Allocated_Limit__c = Decimal.valueOf(mngdAcc.allocatedLimit);
                appProd.Requested_facility_limit__c = mngdAcc.requestedCreditCardLimit;
                appProd.Campaign_Code__c = mngdAcc.campaignCode;
                appProd.Account_Status__c = mngdAcc.accStatus;
                appProd.Account_Status_Description__c = mngdAcc.accStatusDesc;
                appProd.Instalment__c = Decimal.valueOf(mngdAcc.instalment);
                appProd.Service_Fee_Amount__c = Decimal.valueOf(mngdAcc.serviceFeeAmnt);
                appProd.Interest_Rate__c = Decimal.valueOf(mngdAcc.interestRate);
                appProd.Credit_Card_Interest_Type__c = mngdAcc.interestType;
                appProd.Opportunity_Product_Id__c = product2Id;
                appProd.Opportunity__c = mngdAcc.opportunityId;
                appProd.Business_Credit_Card_Product_Type__c = mngdAcc.product;
                appProd.Business_Credit_Card_Sub_Product_Type__c = mngdAcc.subProduct;

                if (existingAccNums.get(mngdAcc.accountNumber) != null) {
                    appProd.Id = existingAccNums.get(mngdAcc.accountNumber);
                    existingAppProds.add(appProd);
                } else {
                    appProducts.add(appProd);

                    OpportunityLineItem oppLineItem = new OpportunityLineItem();
                    oppLineItem.OpportunityId = mngdAcc.opportunityId;
                    oppLineItem.PricebookEntryId = product2Id;
                    oppLineItem.Account_Number__c = mngdAcc.accountNumber;
                    oppLineItem.Product2Id = creditCardProduct.Id;
                    oppLineItem.UnitPrice = 0.00;
                    oppLineItem.Quantity = 1;
                    oppLineItem.Policy_Cover__c = 0.00;
                    oppLineItem.Premium__c = 0.00;
                    oppLineItems.add(oppLineItem);
                }
            }
        }

        if (newAccounts != null && newAccounts.size() > 0) {
            for (Application_Product__c appProduct: newAccounts) {
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                oppLineItem.OpportunityId = appProduct.Opportunity__c;
                oppLineItem.PricebookEntryId = product2Id;
                oppLineItem.Account_Number__c = String.valueOf(appProduct.Account_Number__c);
                oppLineItem.Product2Id = creditCardProduct.Id;
                oppLineItem.UnitPrice = 0.00;
                oppLineItem.Quantity = 1;
                oppLineItem.Policy_Cover__c = 0.00;
                oppLineItem.Premium__c = 0.00;
                oppLineItems.add(oppLineItem);
            }
        }

        try {
            if (appProducts != null && appProducts.size() > 0) {
                insert appProducts;
            }

            if (oppLineItems != null && oppLineItems.size() > 0) {
                insert oppLineItems;
            }

            if (existingAppProds != null && existingAppProds.size() > 0) {
                update existingAppProds;
            }

            if (newAccounts != null && newAccounts.size() > 0) {
                upsert newAccounts;
            }

            dmlSuccess = true;
            //added by Manish for W-012191 to show other when saving a cheque account only
            Id oppId = mngdAccs.size() > 0 ? mngdAccs[0].opportunityId : newAccounts[0].Opportunity__c;
            PowerCurveController.setValidationFields(oppId, 'Credit_Card_Validated', true);
            getTriadExposureData(oppId);
        } catch (Exception exc) {
            throw new AuraHandledException(String.valueOf(exc));
        }

        return dmlSuccess;
    }

    /**
     * @description deleteManagedAccount
     * @author ephetehe.mokgopanyane@tetrad.co.za| 2021-06-11
     * @param appProdId
     * @return Boolean
     **/
    @AuraEnabled(Cacheable = false)
    public static Boolean deleteManagedAccount(Id appProdId) {
        Boolean deleteResult = false;
        Application_Product__c appProd = new Application_Product__c(Id = appProdId);

        try {
            delete appProd;
        } catch (Exception exc) {
            throw new AuraHandledException(String.valueOf(exc));
        }

        return deleteResult;
    }


    /**
     * @description Check for Conduct accounts
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-24
     * @param app
     * @return Boolean
     **/
    public static Boolean isConductDataRequired(Application__c app){
        try{
            if(app.Accounts_Orchestration_JSON__c != null) {
                ChequeServicesOrchestration_Resp_IB_v1 respOrches = (ChequeServicesOrchestration_Resp_IB_v1) JSON.deserialize(app.Accounts_Orchestration_JSON__c, ChequeServicesOrchestration_Resp_IB_v1.class);
                if(respOrches != null && respOrches.CQgetBasicAcctDetailsV7Responses != null) {
                    for (ChequeServicesOrchestration_Resp_IB_v1.CQgetBasicAcctDetailsV7Responses output : respOrches.CQgetBasicAcctDetailsV7Responses) {
                        //excludes Inactive, Cancelled, Revolving, CIB Mid Corp and Islamic accounts
                        if(!(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountStatus == '99' || output.CQgetBasicAcctDetailsV7Response.cqh455o.accountStatus == '0')
                            && ChequeAndOverdraftController.isInProductCode(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountType)) {
                            return true;
                        }
                    }
                }
            }
        } catch(Exception exc){
            throw new AuraHandledException('isConductDataRequired: ' + exc.getMessage() + ' ' + exc.getStackTraceString());
        }

        return false;
    }

    /**
     * @description getExistingAccNums
     * @author ephetehe.mokgopanyane@tetrad.co.za| 2021-06-11
     * @param appProducts
     * @return Map<String, String>
     **/
    private static Map<String, String> getExistingAccNums(List<Application_Product__c> appProducts) {
        Map<String, String> accNums = new Map<String, String>();
        for (Application_Product__c appProd: appProducts) {
            if (appProd.Product_Name__c == 'Credit Card' && appProd.Product_State__c == 'Existing') {
                accNums.put(String.valueOf(appProd.Account_Number__c), appProd.Id);
            }
        }

        return accNums;
    }

    /**
     * @description mehtod to run Triad and Exposures services
     * @author ephetehe.mokgopanyane@absa.africa | 2020-07-03
     * @param oppID
    **/
    public static void getTriadExposureData(String oppID) {
        TriadController.getApplicationTriad(oppID);
        ApplicationExposuresRiskController.getApplicationRiskExposuresfromService(oppID);
        ExposureRiskIdentifierController.getApplicationRiskIdentifiersfromService(oppID);
    }

    /**
     * @description cls_ManagedAccount
     * @author ephetehe.mokgopanyane@tetrad.co.za| 2021-06-11
     *
     **/
    public class cls_ManagedAccount {
        public String recordId;
        public String accountNumber;
        public String allocatedLimit;
        public String creditCardLimit;
        public String requestedCreditCardLimit;
        public String accBalance;
        public String campaignCode;
        public String accStatus;
        public String accStatusDesc;
        public String instalment;
        public String serviceFeeAmnt;
        public String interestRate;
        public String interestType;
        public String expiryDate;
        public String product;
        public String subProduct;
        public String opportunityId;
    }
}