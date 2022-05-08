/**
 * @description : This is the Class for the ExternalBankingRelationships
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-12
*/
public class ExternalBankingRelationshipsCtrl {

    /**
     * @description : method to getAllExtBankRelations
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
     * @param oppId
     * @return Map<String, Object>
    **/
    @AuraEnabled
    public static Map<String,Object> getAllExtBankRelations(String oppId) {
        Map<String,Object> mapExtBankRel = new Map<String,Object>();
        List<Opportunity> oppDet = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Application__c> appDet = new ApplicationsSelector().selectByOpportunityId(oppDet[0].Id);
        List<Application_Financial_Account__c> appFinList = new ApplicationFinancialAccountSelector().selectByApplicationId(appDet[0].Id);

        if(appFinList != null) {

            List<ExternalRelations> extLndBnkLnList = new List<ExternalRelations>();
            List<ExternalRelations> extCoOpDebtList = new List<ExternalRelations>();
            List<ExternalRelations> extChqRelList = new List<ExternalRelations>();
            List<ExternalRelations> extBusCcRelList = new List<ExternalRelations>();
            List<ExternalRelations> extTmLnRelList = new List<ExternalRelations>();
            List<ExternalRelations> extAsVeFinRelList = new List<ExternalRelations>();
            List<ExternalRelations> extInvtRelList = new List<ExternalRelations>();
            List<ExternalRelations> extSavAccRelList = new List<ExternalRelations>();
            List<ExternalRelations> extMoLnRelList = new List<ExternalRelations>();
            List<ExternalRelations> extRetComRelList = new List<ExternalRelations>();

            for(Application_Financial_Account__c output :appFinList) {

                if(output.External_Banking_Relationship__c == 'Land Bank Loan') {
                    Integer count = extLndBnkLnList.size();
                    count++;

                    extLndBnkLnList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Account_Limit__c,
                        output.Outstanding_Balance__c,
                        output.Arrears_Amount__c,
                        output.Repayment_Amount__c,
                        output.Repayment_Frequency__c,
                        output.Monthly_Repayment__c,
                        output.Term_Of_Finance__c,
                        output.Expiry_Date__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'Co-Operative Debt') {
                    Integer count = extCoOpDebtList.size();
                    count++;

                    extCoOpDebtList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Account_Limit__c,
                        output.Outstanding_Balance__c,
                        output.Arrears_Amount__c,
                        output.Repayment_Amount__c,
                        output.Repayment_Frequency__c,
                        output.Monthly_Repayment__c,
                        output.Expiry_Date__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'External Cheque Account') {
                    Integer count = extChqRelList.size();
                    count++;

                    extChqRelList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Other_Bank_Name__c,
                        output.Overdraft_Limit__c,
                        output.Maximum_Overdraft_Limit__c,
                        output.Balance__c,
                        output.Maximum_Debit_Balance__c,
                        Long.valueOf(String.valueOf(output.Account_Number__c)),
                        output.Reduction_Amount__c,
                        output.Reduction_Frequency__c,
                        output.Monthly_Reduction__c,
                        output.Turnover_For_The_Period__c,
                        output.Period_Of_The_Bank_Statement_s__c,
                        Integer.valueOf(output.Number_Of_Returned_Items__c)
                    ));
                }

                if(output.External_Banking_Relationship__c == 'Business Credit Card') {
                    Integer count = extBusCcRelList.size();
                    count++;
                    extBusCcRelList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Other_Bank_Name__c,
                        output.Credit_Card_Limit__c,
                        output.Current_Balance__c,
                        output.Monthly_Repayment__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'External Term Loan') {
                    Integer count = extTmLnRelList.size();
                    count++;

                    extTmLnRelList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Outstanding_Balance__c,
                        output.Monthly_Repayment__c,
                        output.Instalment__c,
                        output.Repayment_Frequency__c,
                        output.Recalculate__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'External Asset And Vehicle Finance') {
                    Integer count = extAsVeFinRelList.size();
                    count++;
                    extAsVeFinRelList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Other_Bank_Name__c,
                        output.Outstanding_balance__c,
                        output.Instalment__c,
                        output.Repayment_Frequency__c,
                        output.Monthly_Repayment__c,
                        output.Last_Payment_Date__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'External Investment') {
                    Integer count = extInvtRelList.size();
                    count++;
                    extInvtRelList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Balance__c,
                        output.Monthly_Interest_And_Dividends_Earned__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'External Savings Account') {
                    Integer count = extSavAccRelList.size();
                    count++;
                    extSavAccRelList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Other_Bank_Name__c,
                        output.Balance__c,
                        output.Monthly_Interest_Earned__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'External Mortgage Loan') {
                    Integer count = extMoLnRelList.size();
                    count++;
                    extMoLnRelList.add(new ExternalRelations(
                        count,
                        output.Id,
                        output.External_Banking_Relationship__c,
                        output.Institution_Name__c,
                        output.Other_Bank_Name__c,
                        output.Outstanding_Balance__c,
                        output.Instalment__c,
                        output.Repayment_Frequency__c,
                        output.Monthly_Repayment__c
                    ));
                }

                if(output.External_Banking_Relationship__c == 'Retail And Other External Commitment') {
                    Integer count = extRetComRelList.size();
                    count++;
                    extRetComRelList.add(new ExternalRelations(
                        output.Id,
                        count,
                        output.External_Banking_Relationship__c,
                        output.Creditor_Name__c,
                        output.Outstanding_Balance__c,
                        output.Monthly_Repayment__c
                    ));
                }
            }

            mapExtBankRel.put('LandBankLoan', extLndBnkLnList);
            mapExtBankRel.put('CoOperativeDebt', extCoOpDebtList);
            mapExtBankRel.put('ExternalChequeAccount', extChqRelList);
            mapExtBankRel.put('BusinessCreditCard', extBusCcRelList);
            mapExtBankRel.put('ExternalTermLoan', extTmLnRelList);
            mapExtBankRel.put('ExternalAssetAndVehicleFinance', extAsVeFinRelList);
            mapExtBankRel.put('ExternalInvestment', extInvtRelList);
            mapExtBankRel.put('ExternalSavingsAccount', extSavAccRelList);
            mapExtBankRel.put('ExternalMortgageLoans', extMoLnRelList);
            mapExtBankRel.put('RetailAndOtherExternalCommitments', extRetComRelList);

            System.debug('hela bathong mapExtBankRel: ' + JSON.serializePretty(extChqRelList));

            return mapExtBankRel;
        }

        return mapExtBankRel;
    }

    /**
     * @description : method to saveAllExtBankRelations
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
     * @param oppId
     * @param jsonObj
     * @param isDelete
     * @return Map<String, String>
    **/
    @AuraEnabled
    public static Map<String, String> saveAllExtBankRelations(String oppId, String jsonObj, Boolean isDelete) {
        Map<String,String> extBankRel = new Map<String,String>();
        List<Object> relObjList = (List<Object>)JSON.deserializeUntyped(jsonObj);
        List<Opportunity> oppDet = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Application__c> appList  = new ApplicationsSelector().selectByOpportunityId(oppDet[0].Id);

        if(relObjList != null && appList != null) {
            Map<String, Object> mapObj = new Map<String,Object>();

            for(Object item : relObjList) {
                mapObj.putAll((Map<String, Object>)item);
            }

            if(mapObj != null) {
                extBankRel = maintainExtBankRelations(appList, mapObj, isDelete);
            }

            Boolean isValid = (!extBankRel.isEmpty() ? extBankRel.get('Status').contains('Successfully') : false);

            if(isValid) {
                PowerCurveController.setValidationFields(OppId, 'External_Banking_Relationships', True);
            }

            return extBankRel;
        }

        return null;
    }

    /**
     * @description : method for maintainExtBankRelations
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
     * @param appList
     * @param mapObj
     * @param isDelete
     * @return Map<String, String>
    **/
    public static Map<String,String> maintainExtBankRelations(List<Application__c> appList, Map<String, Object> mapObj, Boolean isDelete) {
        Map<String,String> mapResult = new Map<String,String>();

        if(appList != null && appList.size() > 0) {
            Set<Id> pIds = new Set<Id>{appList[0].Id, appList[0].Opportunity__c};
            List<Application_Financial_Account__c> appFinList = new ApplicationFinancialAccountSelector().selectByApplicationId(appList[0].Id);

            if(appFinList != null && appFinList.size() == 0) {
                appFinList = buildDmlOperationList(appFinList, mapObj, pIds);
                mapResult = insertUpdateDelete(appFinList, 'insert');
                return mapResult;
            }
            else if(appFinList.size() > 0) {
                if(isDelete) {
                    List<Application_Financial_Account__c> appFinListDel = new List<Application_Financial_Account__c>();
                    appFinListDel = buildDmlOperationList(appFinListDel, mapObj, pIds);
                    mapResult = insertUpdateDelete(appFinListDel, 'delete');
                }
                else if(!isDelete) {
                    List<Application_Financial_Account__c> appFinListUp = new List<Application_Financial_Account__c>();
                    appFinListUp = buildDmlOperationList(appFinListUp, mapObj, pIds);
                    mapResult = insertUpdateDelete(appFinListUp, 'update');
                }

                return mapResult;
            }
        }

        return null;
    }

    /**
     * @description : mehtod to buildDmlOperationList
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
     * @param appFinList
     * @param mapObj
     * @param parentIds
     * @return List<Application_Financial_Account__c>
    **/
    public static List<Application_Financial_Account__c> buildDmlOperationList(List<Application_Financial_Account__c> appFinList, Map<String, Object> mapObj, Set<Id> parentIds) {

        List<ExternalRelations> extLndBnkLnList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('LandBankLoan')), ExternalRelations[].class);
        List<ExternalRelations> extCoOpDebtList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('CoOperativeDebt')), ExternalRelations[].class);
        List<ExternalRelations> extChqRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('ExternalChequeAccounts')), ExternalRelations[].class);
        List<ExternalRelations> extBusCcRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('BusinessCreditCard')), ExternalRelations[].class);
        List<ExternalRelations> extTmLnRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('ExternalTermLoan')), ExternalRelations[].class);
        List<ExternalRelations> extAsVeFinRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('ExternalAssetAndVehicleFinance')), ExternalRelations[].class);
        List<ExternalRelations> extInvtRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('ExternalInvestment')), ExternalRelations[].class);
        List<ExternalRelations> extSavAccRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('ExternalSavingsAccount')), ExternalRelations[].class);
        List<ExternalRelations> extMoLnRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('ExternalMortgageLoans')), ExternalRelations[].class);
        List<ExternalRelations> extRetComRelList = (List<ExternalRelations>)JSON.deserialize(JSON.serialize(mapObj.get('RetailAndOtherExternalCommitments')), ExternalRelations[].class);

        if(extLndBnkLnList != null && extLndBnkLnList.size() > 0) {
            for(ExternalRelations output :extLndBnkLnList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Account_Limit__c = output.AccountLimit;
                appFin.Outstanding_Balance__c = output.OutstandingBalance;
                appFin.Arrears_Amount__c = output.ArrearsAmount;
                appFin.Repayment_Amount__c = output.RepaymentAmount;
                appFin.Repayment_Frequency__c = output.RepaymentFrequency;
                appFin.Monthly_Repayment__c = output.MonthlyRepayment;
                appFin.Term_Of_Finance__c = output.TermOfFinance;
                appFin.Expiry_Date__c = output.ExpiryDate;
                appFinList.add(appFin);
            }
        }

        if(extCoOpDebtList != null && extCoOpDebtList.size() > 0) {
            for(ExternalRelations output :extCoOpDebtList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Account_Limit__c = output.AccountLimit;
                appFin.Outstanding_Balance__c = output.OutstandingBalance;
                appFin.Arrears_Amount__c = output.ArrearsAmount;
                appFin.Repayment_Amount__c = output.RepaymentAmount;
                appFin.Repayment_Frequency__c = output.RepaymentFrequency;
                appFin.Monthly_Repayment__c = output.MonthlyRepayment;
                appFin.Expiry_Date__c = output.ExpiryDate;

                appFinList.add(appFin);
            }
        }

        if(extChqRelList != null && extChqRelList.size() > 0) {
            for(ExternalRelations output :extChqRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Other_Bank_Name__c = output.OtherBankName;
                appFin.Overdraft_Limit__c = output.OverdraftLimit;
                appFin.Maximum_Overdraft_Limit__c = output.MaximumOverdraftLimit;
                appFin.Balance__c = output.Balance;
                appFin.Maximum_Debit_Balance__c = output.MaximumDebitBalance;
                appFin.Account_Number__c = output.AccountNumber;
                appFin.Reduction_Amount__c = output.ReductionAmount;
                appFin.Reduction_Frequency__c = output.ReductionFrequency;
                appFin.Monthly_Reduction__c = output.MonthlyReduction;
                appFin.Turnover_For_The_Period__c = output.TurnoverForThePeriod;
                appFin.Period_Of_The_Bank_Statement_s__c = output.PeriodOfTheBankStatements;
                appFin.Number_Of_Returned_Items__c = output.NumberOfReturnedItems;

                appFinList.add(appFin);
            }
        }

        if(extBusCcRelList != null && extBusCcRelList.size() > 0) {
            for(ExternalRelations output :extBusCcRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Other_Bank_Name__c = output.OtherBankName;
                appFin.Credit_Card_Limit__c = output.CreditCardLimit;
                appFin.Current_Balance__c = output.CurrentBalance;
                appFin.Monthly_Repayment__c = output.MonthlyRepayment;

                appFinList.add(appFin);
            }
        }

        if(extTmLnRelList != null && extTmLnRelList.size() > 0) {
            for(ExternalRelations output :extTmLnRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Outstanding_Balance__c = output.OutstandingBalance;
                appFin.Monthly_Repayment__c = output.MonthlyRepayment;
                appFin.Instalment__c = output.Instalment;
                appFin.Repayment_Frequency__c = output.RepaymentFrequency;
                appFin.Recalculate__c = output.Recalculate;

                appFinList.add(appFin);
            }
        }

        if(extAsVeFinRelList != null && extAsVeFinRelList.size() > 0) {
            for(ExternalRelations output :extAsVeFinRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Other_Bank_Name__c = output.OtherBankName;
                appFin.Outstanding_Balance__c = output.Outstandingbalance;
                appFin.Instalment__c = output.Instalment;
                appFin.Repayment_Frequency__c = output.RepaymentFrequency;
                appFin.Monthly_Repayment__c = output.MonthlyRepayment;
                appFin.Last_Payment_Date__c = output.LastPaymentDate;

                appFinList.add(appFin);
            }
        }

        if(extInvtRelList != null && extInvtRelList.size() > 0) {
            for(ExternalRelations output :extInvtRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Balance__c = output.Balance;
                appFin.Monthly_Interest_And_Dividends_Earned__c = output.MonthlyInterestAndDividendsEarned;

                appFinList.add(appFin);
            }
        }

        if(extSavAccRelList != null && extSavAccRelList.size() > 0) {
            for(ExternalRelations output :extSavAccRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Other_Bank_Name__c = output.OtherBankName;
                appFin.Balance__c = output.Balance;
                appFin.Monthly_Interest_Earned__c = output.MonthlyInterestEarned;

                appFinList.add(appFin);
            }
        }

        if(extMoLnRelList != null && extMoLnRelList.size() > 0) {
            for(ExternalRelations output :extMoLnRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Institution_Name__c = output.InstitutionName;
                appFin.Other_Bank_Name__c = output.OtherBankName;
                appFin.Outstanding_Balance__c = output.OutstandingBalance;
                appFin.Instalment__c = output.Instalment;
                appFin.Repayment_Frequency__c = output.RepaymentFrequency;
                appFin.Monthly_Repayment__c = output.MonthlyRepayment;

                appFinList.add(appFin);
            }
        }

        if(extRetComRelList != null && extRetComRelList.size() > 0) {
            for(ExternalRelations output :extRetComRelList) {
                Application_Financial_Account__c appFin = new Application_Financial_Account__c();
                appFin.Id = output.Id;
                appFin.Application__C = (new List<Id>(parentIds))[0];
                appFin.External_Banking_Relationship__c = output.Section;
                appFin.Creditor_Name__c = output.CreditorName;
                appFin.Outstanding_Balance__c = output.OutstandingBalance;
                appFin.Monthly_Repayment__c = output.MonthlyRepayment;

                appFinList.add(appFin);
            }
        }

        return appFinList;
    }

    /**
     * @description : method to insertUpdateDelete
     * @author englarmerdge.mongwe@absa.africa | 2021-06-10
     * @param appFinList
     * @param dmlAction
     * @return Map<String, String>
    **/
    public static Map<String,String> insertUpdateDelete(List<Application_Financial_Account__c> appFinList, String dmlAction) {

        Map<String,String> mapResult = new Map<String,String>();

        try{
            if(appFinList != null && appFinList.size() > 0) {

                if(dmlAction == 'insert' || dmlAction == 'update') {
                    upsert appFinList;
                    mapResult.put('Status', 'External Banking Relations Saved Successfully!');
                }
                else if(dmlAction == 'delete') {
                    delete appFinList;
                    mapResult.put('Status', 'External Banking Relations Deleted Successfully!');
                }
            }
        }
        catch(Exception ex) {
            mapResult.put('Status', ex.getMessage());
            return mapResult;
        }

        return mapResult;
    }

    /** @description : ExternalRelations class */
    public class ExternalRelations {
        /** @description : UqId property */
        @AuraEnabled public Integer UqId { get; set; }
        /** @description : Id property */
        @AuraEnabled public Id Id { get; set; }
        /** @description : Section property */
        @AuraEnabled public String Section { get; set; }
        /** @description : InstitutionName property */
        @AuraEnabled public String InstitutionName { get; set; }
        /** @description : OtherBankName property */
        @AuraEnabled public String OtherBankName { get; set; }
        /** @description : OverdraftLimit property */
        @AuraEnabled public Decimal OverdraftLimit { get; set; }
        /** @description : MaximumOverdraftLimit property */
        @AuraEnabled public Decimal MaximumOverdraftLimit { get; set; }
        /** @description : Balance property */
        @AuraEnabled public Decimal Balance { get; set; }
        /** @description : MaximumDebitBalance property */
        @AuraEnabled public Decimal MaximumDebitBalance { get; set; }
        /** @description : AccountNumber property */
        @AuraEnabled public Long AccountNumber { get; set; }
        /** @description : ReductionAmount property */
        @AuraEnabled public Decimal ReductionAmount { get; set; }
        /** @description : ReductionFrequency property */
        @AuraEnabled public String ReductionFrequency { get; set; }
        /** @description : MonthlyReduction property */
        @AuraEnabled public Decimal MonthlyReduction { get; set; }
        /** @description : TurnoverForThePeriod property */
        @AuraEnabled public Decimal TurnoverForThePeriod { get; set; }
        /** @description : PeriodOfTheBankStatements property */
        @AuraEnabled public String PeriodOfTheBankStatements { get; set; }
        /** @description : NumberOfReturnedItems property */
        @AuraEnabled public Integer NumberOfReturnedItems { get; set; }
        /** @description : CreditCardLimit property */
        @AuraEnabled public Decimal CreditCardLimit { get; set; }
        /** @description : CurrentBalance property */
        @AuraEnabled public Decimal CurrentBalance { get; set; }
        /** @description : MonthlyRepayment property */
        @AuraEnabled public Decimal MonthlyRepayment { get; set; }
        /** @description : OutstandingBalance property */
        @AuraEnabled public Decimal OutstandingBalance { get; set; }
        /** @description : Instalment property */
        @AuraEnabled public Decimal Instalment { get; set; }
        /** @description : RepaymentFrequency property */
        @AuraEnabled public String RepaymentFrequency  { get; set; }
        /** @description : Recalculate property */
        @AuraEnabled public String Recalculate  { get; set; }
        /** @description : LastPaymentDate property */
        @AuraEnabled public Date LastPaymentDate { get; set; }
        /** @description : MonthlyInterestAndDividendsEarned property */
        @AuraEnabled public Decimal MonthlyInterestAndDividendsEarned { get; set; }
        /** @description : MonthlyInterestEarned property */
        @AuraEnabled public Decimal MonthlyInterestEarned { get; set;}
        /** @description : CreditorName property */
        @AuraEnabled public String CreditorName { get; set; }
        /** @description : AccountLimit property */
        @AuraEnabled public Decimal AccountLimit { get; set; }
        /** @description : ArrearsAmount property */
        @AuraEnabled public Decimal ArrearsAmount { get; set; }
        /** @description : TermOfFinance property */
        @AuraEnabled public String TermOfFinance { get; set; }
        /** @description : ExpiryDate property */
        @AuraEnabled public Date ExpiryDate { get; set; }
        /** @description : RepaymentAmount property */
        @AuraEnabled public Decimal RepaymentAmount { get; set;}

        /**
         * @description : LandBankLoan constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param accountLimit 
         * @param outstandingBalance 
         * @param arrearsAmount 
         * @param repaymentAmount 
         * @param repaymentFrequency 
         * @param monthlyRepayment 
         * @param termOfFinance 
         * @param expiryDate 
        **/
        public ExternalRelations(Integer uqId, Id id, String section, Decimal accountLimit, Decimal outstandingBalance, Decimal arrearsAmount, Decimal repaymentAmount, String repaymentFrequency, Decimal monthlyRepayment, String termOfFinance, Date expiryDate) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.AccountLimit = accountLimit;
            this.OutstandingBalance = outstandingBalance;
            this.ArrearsAmount = arrearsAmount;
            this.RepaymentAmount = repaymentAmount;
            this.RepaymentFrequency = repaymentFrequency;
            this.MonthlyRepayment = monthlyRepayment;
            this.TermOfFinance = termOfFinance;
            this.ExpiryDate = expiryDate;
        }

        /**
         * @description : CoOperativeDebt constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param accountLimit 
         * @param outstandingBalance 
         * @param arrearsAmount 
         * @param repaymentAmount 
         * @param repaymentFrequency 
         * @param monthlyRepayment 
         * @param expiryDate 
        **/
        public ExternalRelations(Integer uqId, Id id, String section, String institutionName, Decimal accountLimit, Decimal outstandingBalance, Decimal arrearsAmount, Decimal repaymentAmount, String repaymentFrequency, Decimal monthlyRepayment, Date expiryDate) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.AccountLimit = accountLimit;
            this.OutstandingBalance = outstandingBalance;
            this.ArrearsAmount = arrearsAmount;
            this.RepaymentAmount = repaymentAmount;
            this.RepaymentFrequency = repaymentFrequency;
            this.MonthlyRepayment = monthlyRepayment;
            this.ExpiryDate = expiryDate;
        }

        /**
         * @description : ExternalChequeAccounts constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param otherBankName 
         * @param overdraftLimit 
         * @param maximumOverdraftLimit 
         * @param balance 
         * @param maximumDebitBalance 
         * @param accountNumber 
         * @param reductionAmount 
         * @param reductionFrequency 
         * @param monthlyReduction 
         * @param turnoverForThePeriod 
         * @param periodOfTheBankStatements 
         * @param numberOfReturnedItems 
        **/
        public ExternalRelations(Integer uqId, Id id, String section, String institutionName, String otherBankName, Decimal overdraftLimit, Decimal maximumOverdraftLimit, Decimal balance, Decimal maximumDebitBalance, Long accountNumber, Decimal reductionAmount, String reductionFrequency, Decimal monthlyReduction, Decimal turnoverForThePeriod, String periodOfTheBankStatements, Integer numberOfReturnedItems) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.OtherBankName = otherBankName;
            this.OverdraftLimit = overdraftLimit;
            this.MaximumOverdraftLimit = maximumOverdraftLimit;
            this.Balance = balance;
            this.MaximumDebitBalance = maximumDebitBalance;
            this.AccountNumber = accountNumber;
            this.ReductionAmount = ReductionAmount;
            this.ReductionFrequency = reductionFrequency;
            this.MonthlyReduction = monthlyReduction;
            this.TurnoverForThePeriod = turnoverForThePeriod;
            this.PeriodOfTheBankStatements = periodOfTheBankStatements;
            this.NumberOfReturnedItems = numberOfReturnedItems;
        }

        /**
         * @description : BusinessCreditCard constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param otherBankName 
         * @param creditCardLimit 
         * @param currentBalance 
         * @param monthlyRepayment 
        **/
        public ExternalRelations(Integer uqId,Id id, String section, String institutionName, String otherBankName, Decimal creditCardLimit, Decimal currentBalance, Decimal monthlyRepayment) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.OtherBankName = otherBankName;
            this.CreditCardLimit = creditCardLimit;
            this.CurrentBalance = currentBalance;
            this.MonthlyRepayment = monthlyRepayment;
        }

        /**
         * @description : ExternalTermLoan constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param outstandingBalance 
         * @param monthlyRepayment 
         * @param instalment 
         * @param repaymentFrequency 
         * @param recalculate 
        **/
        public ExternalRelations(Integer uqId, Id id, String section, String institutionName, Decimal outstandingBalance, Decimal monthlyRepayment, Decimal instalment, String repaymentFrequency, String recalculate) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.OutstandingBalance = outstandingBalance;
            this.MonthlyRepayment = monthlyRepayment;
            this.Instalment = instalment;
            this.RepaymentFrequency = repaymentFrequency;
            this.Recalculate = recalculate;
        }

        /**
         * @description : ExternalAssetAndVehicleFinance constructor 
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param otherBankName 
         * @param outstandingBalance 
         * @param instalment 
         * @param repaymentFrequency 
         * @param monthlyRepayment 
         * @param lastPaymentDate 
        **/
        public ExternalRelations(Integer uqId,Id id, String section, String institutionName, String otherBankName, Decimal outstandingBalance, Decimal instalment, String repaymentFrequency, Decimal monthlyRepayment, Date lastPaymentDate) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.OtherBankName = otherBankName;
            this.Outstandingbalance = outstandingBalance;
            this.Instalment = instalment;
            this.RepaymentFrequency = repaymentFrequency;
            this.MonthlyRepayment = monthlyRepayment;
            this.LastPaymentDate = lastPaymentDate;
        }

        /**
         * @description : ExternalInvestment constructor 
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param balance 
         * @param monthlyInterestAndDividendsEarned 
        **/
        public ExternalRelations(Integer uqId, Id id, String section, String institutionName, Decimal balance, Decimal monthlyInterestAndDividendsEarned) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.Balance = balance;
            this.MonthlyInterestAndDividendsEarned = monthlyInterestAndDividendsEarned;
        }

        /**
         * @description : ExternalSavingsAccount constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param otherBankName 
         * @param balance 
         * @param monthlyInterestEarned 
        **/
        public ExternalRelations(Integer uqId, Id id, String section, String institutionName, String otherBankName, Decimal balance, Decimal monthlyInterestEarned) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.OtherBankName = otherBankName;
            this.Balance = balance;
            this.MonthlyInterestEarned = monthlyInterestEarned;
        }

        /**
         * @description : ExternalMortgageLoans constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param uqId 
         * @param id 
         * @param section 
         * @param institutionName 
         * @param otherBankName 
         * @param outstandingBalance 
         * @param instalment 
         * @param repaymentFrequency 
         * @param monthlyRepayment 
        **/
        public ExternalRelations(Integer uqId, Id id, String section, String institutionName, String otherBankName, Decimal outstandingBalance, Decimal instalment, String repaymentFrequency, Decimal monthlyRepayment) {
            this.UqId = uqId;
            this.Id = id;
            this.Section = section;
            this.InstitutionName = institutionName;
            this.OtherBankName = otherBankName;
            this.OutstandingBalance = outstandingBalance;
            this.Instalment = instalment;
            this.RepaymentFrequency = repaymentFrequency;
            this.MonthlyRepayment = monthlyRepayment;
        }

        /**
         * @description : RetailAndOtherExternalCommitments constructor
         * @author englarmerdge.mongwe@absa.africa | 2021-06-10 
         * @param id 
         * @param uqId 
         * @param section 
         * @param creditorName 
         * @param outstandingBalance 
         * @param monthlyRepayment 
        **/
        public ExternalRelations(Id id, Integer uqId, String section, String creditorName, Decimal outstandingBalance, Decimal monthlyRepayment) {
            this.Id = id;
            this.UqId = uqId;
            this.Section = section;
            this.CreditorName = creditorName;
            this.OutstandingBalance = outstandingBalance;
            this.MonthlyRepayment = monthlyRepayment;
        }
    }
}