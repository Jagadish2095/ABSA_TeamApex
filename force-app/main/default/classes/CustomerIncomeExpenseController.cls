/**
* @description Customer income and expenses controller
* @author  Aaron Castelyn: Absa
* @version v1.0
* @since   2020-10-06
* @last modified on  : 2021-09-07
* @last modified by  : PaulJohn.duRand@absa.africa
*/
public without sharing class CustomerIncomeExpenseController {

    /**
    * @description getApplication
    * @param accountId
    * @param opportunityId
    * @return Application__c
    */
    @AuraEnabled
    public static Application__c getApplication(Id accountId, Id opportunityId)
    {
    	Application__c result;

        try {
            result = [SELECT Id
                      FROM Application__c
                      WHERE Account__c = :accountId
                     	AND Opportunity__c = :opportunityId WITH SECURITY_ENFORCED];
        }
        catch (System.QueryException ex) {
            result = new Application__c();

            result.Account__c = accountId;
            result.Opportunity__c = opportunityId;

            try {
                if (Application__c.SObjectType.getDescribe().isCreateable())
                {
                    insert result;
                }
            } catch (DmlException e) {
                //System.debug(e.getMessage());
                throw e;
            }
        }

        return result;
    }

    /**
    * @description getApplicationSOF
    * @param applicationId
    * @return String
    */
    @AuraEnabled
    public static string getApplicationSOF(Id applicationId)
    {
        Application__c app = [SELECT Source_of_Funds_Savings__c
            FROM Application__c
            WHERE Id = :applicationId WITH SECURITY_ENFORCED];

        return app.Source_of_Funds_Savings__c;
    }

    /**
    * @description getIncome
    * @param applicationId
    * @return String
    */
    @AuraEnabled
    public static String getIncome(Id applicationId)
    {
        CCApplicationServiceHelper.MonthlyIncome result = new CCApplicationServiceHelper.MonthlyIncome();

        result.ApplicationId = applicationId;

        result.otherIncome = CustomerIncomeExpenseController.GetRecord(applicationId, 'Monthly Income', 'Other Income');
        result.grossIncome = CustomerIncomeExpenseController.GetRecord(applicationId, 'Monthly Income', 'Gross Income');
        result.netIncome = CustomerIncomeExpenseController.GetRecord(applicationId, 'Monthly Income', 'Net Income');
        result.rentalIncome = CustomerIncomeExpenseController.GetRecord(applicationId, 'Monthly Income', 'Rental Income');

        Application_Income_and_Expense__c other = CustomerIncomeExpenseController.GetRecord(applicationId, 'Monthly Income', 'Other');
        Application_Income_and_Expense__c consent = CustomerIncomeExpenseController.GetRecord(applicationId, 'Monthly Income', 'Bank Statements Consent');

        result.other = (other.Applicant_Value__c > 0);
        result.bankStatementsConsent = (consent.Applicant_Value__c > 0);
        result.sourceOfFunds = CustomerIncomeExpenseController.getApplicationSOF(applicationId);

        return JSON.serialize(result);
    }

    /**
    * @description getDebtExpenses
    * @param applicationId
    * @return String
    */
    @AuraEnabled
    public static String getDebtExpenses(Id applicationId)
    {
        //Id applicationId = 'a0u5E00000CM9lCQAT';

    	CCApplicationServiceHelper.MonthlyDebtExpenses result = new CCApplicationServiceHelper.MonthlyDebtExpenses();

        result.ApplicationId = applicationId;

        result.assetPayment = CustomerIncomeExpenseController.GetRecord(applicationId, 'Fixed Debt', 'Asset Payment');
        result.creditPayment = CustomerIncomeExpenseController.GetRecord(applicationId, 'Fixed Debt', 'Credit Payment');
        result.loanPayment = CustomerIncomeExpenseController.GetRecord(applicationId, 'Fixed Debt', 'Loan Payment');
        result.homeloanPayment = CustomerIncomeExpenseController.GetRecord(applicationId, 'Fixed Debt', 'Homeloan Payment');
        result.retailPayment = CustomerIncomeExpenseController.GetRecord(applicationId, 'Fixed Debt', 'Retail Payment');

        Application_Income_and_Expense__c joint = CustomerIncomeExpenseController.GetRecord(applicationId, 'Fixed Debt', 'Joint Responsible');

        result.jointResponsible = (joint.Applicant_Value__c > 0);

        //system.debug(result);

        return JSON.serialize(result);
    }

    /**
    * @description getLivingExpenses
    * @param applicationId
    * @return String
    */
    @AuraEnabled
    public static String getLivingExpenses(Id applicationId)
    {
    	CCApplicationServiceHelper.MonthlyLivingExpenses result = new CCApplicationServiceHelper.MonthlyLivingExpenses();

        result.ApplicationId = applicationId;

        result.householdExpense = CustomerIncomeExpenseController.GetRecord(applicationId, 'Living Expenses', 'Household Expense');
        result.fuelExpense = CustomerIncomeExpenseController.GetRecord(applicationId, 'Living Expenses', 'Fuel Expense');
        result.educationFee = CustomerIncomeExpenseController.GetRecord(applicationId, 'Living Expenses', 'Education Fee');
        result.insurancePolicies = CustomerIncomeExpenseController.GetRecord(applicationId, 'Living Expenses', 'Insurance Polices');
        result.maintenanceExpense = CustomerIncomeExpenseController.GetRecord(applicationId, 'Living Expenses', 'Maintenance Expense');
        result.rent = CustomerIncomeExpenseController.GetRecord(applicationId, 'Living Expenses', 'Rent');
        result.otherAmount = CustomerIncomeExpenseController.GetRecord(applicationId, 'Living Expenses', 'Other Amount');

        result.otherExpenses = (result.otherAmount.Applicant_Value__c > 0.00);

        return JSON.serialize(result);
    }

    /**
    * @description getIncomeLeft
    * @param applicationId
    * @return String
    */
    @AuraEnabled
    public static Double getIncomeLeft(Id applicationId)
    {
        Double incomeLeft = 0;

        AggregateResult a  = [SELECT SUM(Applicant_Value__c)TotalIncome
                                                    FROM Application_Income_and_Expense__c
                                                    WHERE Application__c = :applicationId
                                                    AND Category__c = 'Monthly Income'
                                                    AND Expense_Value__c IN ('Net Income', 'Rental Income', 'Other Income')];

        AggregateResult b = [SELECT SUM(Applicant_Value__c)TotalExpenses
                            FROM Application_Income_and_Expense__c
                            WHERE Application__c = :applicationId
                            AND Category__c IN ('Fixed Debt', 'Living Expenses')
                            AND Expense_Value__c IN ('Asset Payment','Credit Payment', 'Loan Payment', 'Homeloan Payment', 'Retail Payment', 'Household Expense', 'Fuel Expense', 'Education Fee', 'Insurance Polices', 'Maintenance Expense', 'Rent', 'Other Amount')];

        Double income = Double.valueOf(a.get('TotalIncome'));
        Double expenses = Double.valueOf(b.get('TotalExpenses'));

        incomeLeft = income - expenses;

        return incomeLeft;
    }

    /**
    * @description updateApplicationSOF
    * @param applicationId
    * @param sof
    */
    @AuraEnabled
    public static void updateApplicationSOF(Id applicationId, string sof)
    {
        Application__c app = [SELECT Id, Source_of_Funds_Savings__c
            FROM Application__c
            WHERE Id = :applicationId WITH SECURITY_ENFORCED];

        app.Source_of_Funds_Savings__c = sof;

        try {
            if ((Application__c.SObjectType.getDescribe().isCreateable()) && (Application__c.SObjectType.getDescribe().isUpdateable()))
            {
                upsert app;
            }
        } catch (DmlException e) {
            //System.debug(e.getMessage());
            throw e;
        }
    }

    /**
    * @description saveIncome
    * @param data
    */
    @AuraEnabled
    public static void saveIncome(String data)
    {
        CCApplicationServiceHelper.MonthlyIncome d = (CCApplicationServiceHelper.MonthlyIncome)JSON.deserialize(data, CCApplicationServiceHelper.MonthlyIncome.class);

        //system.debug(d);

        CustomerIncomeExpenseController.updateApplicationSOF(d.ApplicationId, d.sourceOfFunds);

        List<Application_Income_and_Expense__c> l = new List<Application_Income_and_Expense__c>();

        l.Add(d.grossIncome);
        l.Add(d.netIncome);
        l.Add(d.rentalIncome);
        l.Add(d.otherIncome);

        Application_Income_and_Expense__c other = CustomerIncomeExpenseController.GetRecord(d.ApplicationId, 'Monthly Income', 'Other');

        other.Applicant_Value__c =  (d.other == true) ? 1 : 0;

        l.Add(other);

        Application_Income_and_Expense__c consent = CustomerIncomeExpenseController.GetRecord(d.ApplicationId, 'Monthly Income', 'Bank Statements Consent');

        consent.Applicant_Value__c = (d.bankStatementsConsent == true) ? 1 : 0;

        l.Add(consent);

        try {
            if ((Application_Income_and_Expense__c.SObjectType.getDescribe().isCreateable()) &&
                (Application_Income_and_Expense__c.SObjectType.getDescribe().isUpdateable()))
            {
                upsert l;
            }
        } catch (DmlException e) {
            //System.debug(e.getMessage());
            throw e;
        }
    }

    /**
    * @description saveDebtExpenses
    * @param data
    */
    @AuraEnabled
    public static void saveDebtExpenses(String data)
    {
        CCApplicationServiceHelper.MonthlyDebtExpenses d = (CCApplicationServiceHelper.MonthlyDebtExpenses)JSON.deserialize(data, CCApplicationServiceHelper.MonthlyDebtExpenses.class);

    	List<Application_Income_and_Expense__c> l = new List<Application_Income_and_Expense__c>();

        l.Add(d.assetPayment);
        l.Add(d.creditPayment);
        l.Add(d.loanPayment);
        l.Add(d.homeloanPayment);
        l.Add(d.retailPayment);

        Application_Income_and_Expense__c joint = CustomerIncomeExpenseController.GetRecord(d.ApplicationId, 'Fixed Debt', 'Joint Responsible');

        joint.Applicant_Value__c = (d.jointResponsible == true) ? 1 : 0;

        l.Add(joint);

        try {
            if ((Application_Income_and_Expense__c.SObjectType.getDescribe().isCreateable()) && (Application__c.SObjectType.getDescribe().isUpdateable()))
            {
                upsert l;
            }
        } catch (DmlException e) {
            //System.debug(e.getMessage());
             throw e;
        }
    }

    /**
    * @description saveLivingExpenses
    * @param data
    */
    @AuraEnabled
    public static void saveLivingExpenses(String data)
    {
        CCApplicationServiceHelper.MonthlyLivingExpenses d = (CCApplicationServiceHelper.MonthlyLivingExpenses)JSON.deserialize(data, CCApplicationServiceHelper.MonthlyLivingExpenses.class);

        List<Application_Income_and_Expense__c> l = new List<Application_Income_and_Expense__c>();

        l.Add(d.householdExpense);
        l.Add(d.fuelExpense);
        l.Add(d.educationFee);
        l.Add(d.insurancePolicies);
        l.Add(d.maintenanceExpense);
        l.Add(d.rent);
        l.Add(d.otherAmount);

        try {
            if ((Application_Income_and_Expense__c.SObjectType.getDescribe().isCreateable()) && (Application__c.SObjectType.getDescribe().isUpdateable()))
            {
                upsert l;
            }
        } catch (DmlException e) {
            //System.debug(e.getMessage());
             throw e;
        }
    }

    /**
    * @description getApplicationInformation
    * @param applicationNumber
    * @return String
    */
    @AuraEnabled
    public static String getApplicationInformation(String applicationNumber)
    {
        String errorMessage = '';

        CCApplicationService_get_Resp_IB_v1 response = new CCApplicationService_get_Resp_IB_v1();

        try
        {
            response = CCApplicationServiceHelper.GetApplicationInformation(applicationNumber);
        }
        catch(Exception ex)
        {
            errorMessage = 'An error occured while getting the application information: ' + ex.getMessage();

            //System.debug(ex);

            throw new AuraHandledException(errorMessage);
        }

        return JSON.serialize(response);
    }

    /**
    * @description applyClientUpdate
    * @param applicationId
    * @param applicationNumber
    * @return String
    */
    @AuraEnabled
    public static String applyClientUpdate(Id applicationId, String applicationNumber)
    {
        String errorMessage = '';

        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

        try
        {
            // Id applicationId = 'a0u9E00000GfD2vQAF';
            // String applicationNumber = '102107161119086203';
            // CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

            response = CCApplicationServiceHelper.ApplyClientUpdate(null, applicationId, applicationNumber);

            CustomerIncomeExpenseController.storeApplicationNumber(applicationId, applicationNumber);

            if ((response.applyResponse.z_return.application != null) &&
                (response.applyResponse.z_return.application.primaryApplicant != null) &&
                (response.applyResponse.z_return.application.primaryApplicant.preAssessed != null))
            {
                Application_Income_and_Expense__c grossIncome = CustomerIncomeExpenseController.getRecord(applicationId, 'Monthly Income', 'Gross Income');

                grossIncome.Applicant_Value__c = (response.applyResponse.z_return.application.primaryApplicant.preAssessed.preAssessedGrossIncome != null) ?
                    decimal.valueOf(response.applyResponse.z_return.application.primaryApplicant.preAssessed.preAssessedGrossIncome) : grossIncome.Applicant_Value__c;

                update grossIncome;

                Application_Income_and_Expense__c netIncome = CustomerIncomeExpenseController.getRecord(applicationId, 'Monthly Income', 'Net Income');

                netIncome.Applicant_Value__c = (response.applyResponse.z_return.application.primaryApplicant.preAssessed.preTmrNettIncome != null) ?
                    decimal.valueOf(response.applyResponse.z_return.application.primaryApplicant.preAssessed.preTmrNettIncome) : netIncome.Applicant_Value__c;

                update netIncome;
            }

            // System.debug('The service responded with: ' + response);

            //system.debug(JSON.serialize(result));
        }
        catch(Exception ex)
        {
            errorMessage = 'The service returned the following error: ' + ex.getMessage();
            //System.debug(ex);

            throw new AuraHandledException(errorMessage);
        }

        return JSON.serialize(response);
    }

    /**
    * @description applyFinalScoring
    * @param applicationId
    * @param applicationNumber
    * @param preAssessedCreditLimit
    * @param lockVersionId
    * @param mayCheckCreditWorthiness
    * @return String
    */
    @AuraEnabled
    public static String applyFinalScoring(Id applicationId, String applicationNumber, String preAssessedCreditLimit, String lockVersionId, String mayCheckCreditWorthiness)
    {
        String errorMessage = '';

        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

        try
        {
            // Id applicationId = 'a0u9E00000GVw8eQAD';
            // String applicationNumber = '102103171105451688';
            // String lockVersionId = '50578';
            // String preAssessedCreditLimit = '';
            // String mayCheckCreditWorthiness = 'Y';
            // CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

            mayCheckCreditWorthiness = (string.IsNotBlank(mayCheckCreditWorthiness)) ? mayCheckCreditWorthiness : 'Y';

            response = CCApplicationServiceHelper.ApplyFinalScoring(applicationId, applicationNumber, lockVersionId, preAssessedCreditLimit, mayCheckCreditWorthiness);

            if ((response.applyResponse.z_return.application != null) &&
                (response.applyResponse.z_return.application.primaryApplicant != null) &&
                (response.applyResponse.z_return.application.primaryApplicant.preAssessed != null))
            {
                Application_Income_and_Expense__c poiIndicator = CustomerIncomeExpenseController.getRecord(applicationId, 'Monthly Income', 'POI');

                poiIndicator.Applicant_Value__c = (response.applyResponse.z_return.application.primaryApplicant.preAssessed.preAssessedGrossIncomeAccepted != null) ?
                    (response.applyResponse.z_return.application.primaryApplicant.preAssessed.preAssessedGrossIncomeAccepted == 'true') ? 0 : 1 
                    : 1;

                update poiIndicator;
            }
        }
        catch(Exception ex)
        {
            errorMessage = 'The service returned the following error: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);
        }

        return JSON.serialize(response);
    }

    /**
    * @description applyQuoteAccept
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @param decision
    * @param quoteNumber
    * @return String
    */
    @AuraEnabled
    public static String applyQuoteAccept(Id applicationId, string applicationNumber, string lockVersionId, string decision, string quoteNumber)
    {
        String errorMessage = '';

        CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

        try
        {
            // Id applicationId = 'a0u5E00000CM9lCQAT';
            // String applicationNumber = '102012021434238803';
            // String lockVersionId = '46830';
            // String preAssessedCreditLimit = '';
            // CCApplicationService_apply_Resp_IB_v1 response = new CCApplicationService_apply_Resp_IB_v1();

            response = CCApplicationServiceHelper.ApplyQuoteAccept(applicationId, applicationNumber, lockVersionId, decision, quoteNumber);

            //System.debug('The service responded with: ' + response);
        }
        catch(Exception ex)
        {
            errorMessage = 'The service returned the following error: ' + ex.getMessage();

            throw new AuraHandledException(errorMessage);
        }

        return JSON.serialize(response);
    }

    /**
    * @description storeApplicationNumber
    * @param applicationId
    * @param applicationNumber
    */
    public static void storeApplicationNumber(Id applicationId, string applicationNumber)
    {
        try {
            Application__c app = [SELECT Id, Account_Number__c FROM Application__c WHERE Id = :applicationId WITH SECURITY_ENFORCED];

            app.Account_Number__c = applicationNumber;

            if (Application__c.SObjectType.getDescribe().isUpdateable())
            {
                update app;
            }
        } catch (Exception ex) {
            //System.debug(ex);

            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
    * @description getRecord
    * @param applicationId
    * @param category
    * @param expenseValue
    * @return Application_Income_and_Expense__c
    */
    public static Application_Income_and_Expense__c getRecord(Id applicationId, string category, string expenseValue)
    {
        Application_Income_and_Expense__c result;

        try {
            result = [SELECT Id, Application__c, Name, Category__c, Expense_Value__c, Applicant_Value__c
                      FROM Application_Income_and_Expense__c
                      WHERE Application__c = :applicationId
                      AND Category__c = :category
                      AND Expense_Value__c = :expenseValue WITH SECURITY_ENFORCED LIMIT 1];
        }
        catch (System.QueryException ex) {
            result = new Application_Income_and_Expense__c();

            result.Application__c = applicationId;
            result.Category__c = category;
            result.Expense_Value__c = expenseValue;
            result.Applicant_Value__c = 0;

            try {
                if (Application_Income_and_Expense__c.SObjectType.getDescribe().isCreateable())
                {
                    insert result;
                }
            } catch (DmlException e) {
                //System.debug(e.getMessage());
                throw e;
            }
        }

        return result;
    }

    /**
    * @description getTranslationValues
    * @param systemName
    * @param valueType
    * @param direction
    * @param objObject
    * @param objField
    * @return Map<String,String>
    */
    @AuraEnabled
    public static Map<String,String> getTranslationValues(String systemName, String valueType, String direction, sObject objObject, string objField)
    {
        return BranchFunctions.getValidTranslations(systemName, valueType, direction, objObject, objField);
    }

    /**
    * @description ClientUpdateResponse
    */
    public class ClientUpdateResponse
    {
        @auraEnabled public String preAssessedCreditLimit;
        @auraEnabled public String lockVersionId;
        @auraEnabled public CCApplicationService_apply_Resp_IB_v1.income income;
        @auraEnabled public CCApplicationService_apply_Resp_IB_v1.expense expense;
        @auraEnabled public List<CCApplicationService_apply_Resp_IB_v1.responseMessages> responseMessages;
    }
}