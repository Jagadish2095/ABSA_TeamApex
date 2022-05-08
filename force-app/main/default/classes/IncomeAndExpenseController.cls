/**
 * @description       : Controller class for Income and Expense
 * @author            : Almas.Aleem@absa.africa
 * @group             :
 * @last modified on  : 07-07-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2020-09-28   Almas.Aleem@absa.africa   Initial Version
**/
public class IncomeAndExpenseController {

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param appId
     * @param appScoreId
    **/
    @future
    public static void updateDisposalAfterCall7(Id appId, Id appScoreId) {
        Application_Scoring__c appScoring = [SELECT Id, stage__c, Necessary_Expenses_Shortfall__c, Stress_Allowance__c, Surplus__c, Total_Cost_of_New_Facilities__c,
                                                Total_Cost_of_Current_Facilities__c, Application_Number__c from Application_Scoring__c
                                                where Application_Number__c =: appId and Id =: appScoreId
                                            ];

        List<Application_Income_and_Expense__c> disposalList = new ApplicationIncomeExpensesSelector().selectByExpenseType(appId, 'Disposable Income');
        if (!disposalList.isEmpty()) {
            Application_Income_and_Expense__c disposalIncome = new Application_Income_and_Expense__c();
            disposalIncome.id = disposalList[0].id;
            disposalIncome.Stress_Allowance__c = appScoring.Stress_Allowance__c;
            //disposalIncome.Surplus_Shortage__c = appScoring.Surplus__c;
            disposalIncome.Necessary_Expenses_Shortfall__c = appScoring.Necessary_Expenses_Shortfall__c;
            disposalIncome.Cost_of_Current_Faclity_Settlements__c = appScoring.Total_Cost_of_Current_Facilities__c;
            disposalIncome.Cost_of_New_Facility__c = appScoring.Total_Cost_of_New_Facilities__c;

            try {
                update disposalIncome;
            } catch (DMLException e) {
                System.debug('e---' + e.getMessage());
            }
        }
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param appProfileids
    **/
    public static void getCreditOrch(set<Id> appProfileids) {

        List<Application_Profile__c> appProfileList = [select Id, Accounts_Orchestration_JSON__c, Client_CIF_Code__c, Applicant_Type__c, Is_Main_Applicant__c, Total_Credit_Instalment_Amount__c From Application_Profile__c where id IN: appProfileids];
        for (Application_Profile__c aprofile: appProfileList) {
            if (aprofile.Applicant_Type__c == 'Main Applicant' && aprofile.Is_Main_Applicant__c == true) {
                IncomeAndExpenseController.callCreditCardServiceAppProfile(aprofile.Id);
            }
            if (aprofile.Applicant_Type__c == 'Spouse') {
                IncomeAndExpenseController.callCreditCardServiceAppProfile(aprofile.Id);
            }
        }
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param appProfileId
    **/
    @future(callout = true)
    public static void callCreditCardServiceAppProfile(Id appProfileId) {
        User user = new UsersSelector().selectById(UserInfo.getUserId());
        //Application__c app = new ApplicationsSelector().selectByOpportunityId(oppId)[0];
        //ChequeServicesOrchestration_Resp_IB_v1 respOrches = (ChequeServicesOrchestration_Resp_IB_v1) JSON.deserialize(app.Accounts_Orchestration_JSON__c, ChequeServicesOrchestration_Resp_IB_v1.class);
        List<String> creditCardPrefix = new List<String> {
                                                            '424518',
                                                            '455019',
                                                            '457023',
                                                            '547471',
                                                            '547508',
                                                            '425703',
                                                            '5585960',
                                                            '4484651'
                                                        };
        ChequeServicesOrchestration_Resp_IB_v1 respOrches;
        Application_Profile__c appProfile = [select Id, Accounts_Orchestration_JSON__c, Client_CIF_Code__c, Total_Credit_Instalment_Amount__c From Application_Profile__c where id =: appProfileId];
        Decimal totalInstallment = 0;
        if (appProfile.Accounts_Orchestration_JSON__c == null && appProfile.Client_CIF_Code__c != null) {
            String productFamilies = 'Credit Cards';
            respOrches = ChequeServicesOrchestration_IH_v1.chequeServicesOrchestration(appProfile.Client_CIF_Code__c, productFamilies, '0', user.SiteCode__c, '0');
            appProfile.Accounts_Orchestration_JSON__c = JSON.serialize(respOrches);
            // ChequeServicesOrchestration_IH_v1.chequeServicesOrchestration(appProfile.Client_CIF_Code__c,'0',user.SiteCode__c, '0');
        } else {
            respOrches = (ChequeServicesOrchestration_Resp_IB_v1) JSON.deserialize(appProfile.Accounts_Orchestration_JSON__c, ChequeServicesOrchestration_Resp_IB_v1.class);

        }
        /*ChequeServicesOrchestration_Resp_IB_v1 respOrches = ChequeServicesOrchestration_IH_v1.chequeServicesOrchestration(appProfile.Client_CIF_Code__c,'0',user.SiteCode__c, '0');
         */

        if (respOrches != null && respOrches.CAgetCassACSBEnqV1Responses != null) {
            for (ChequeServicesOrchestration_Resp_IB_v1.CAgetCassACSBEnqV1Responses output: respOrches.CAgetCassACSBEnqV1Responses) {
                if (!(output.CAgetCassACSBEnqV1Response.cap918o.acctStatCd == '99' || output.CAgetCassACSBEnqV1Response.cap918o.acctStatCd == '0')) {
                    for (String creditCardNumber: creditCardPrefix) {
                        if (output.CAgetCassACSBEnqV1Response.cap918o.kbAcctNbr.startsWith(creditCardNumber)) {
                            totalInstallment = totalInstallment + Decimal.valueOf(output.CAgetCassACSBEnqV1Response.cap918o.instalment);
                        } else {
                            Decimal instValue = Decimal.valueOf(output.CAgetCassACSBEnqV1Response.cap918o.instalment) == 0 ? 0 : Decimal.valueOf(output.CAgetCassACSBEnqV1Response.cap918o.instalment);
                            if (instValue != 0) {
                                Decimal portion = (Decimal.valueOf(output.CAgetCassACSBEnqV1Response.cap918o.instalment) * 10) / 100;
                                totalInstallment = totalInstallment + portion;
                            } else {
                                totalInstallment = totalInstallment + 0;
                            }
                        }
                        break;
                    }
                }

            }
        }

        appProfile.Total_Credit_Instalment_Amount__c = totalInstallment;
        /*if(responseBeanApplicant != null){
        appProfile.Credit_Card_Response__c = JSON.serialize(responseBeanApplicant);*/
        try {
            update appProfile;
        } catch (Exception e) {
            System.debug('e---' + e.getStackTraceString());
        }
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param oppId
     * @return ExpenseWrapper
    **/
    @auraEnabled(Cacheable = false)
    public static ExpenseWrapper getApplicationExpense(Id oppId) {
        ExpenseWrapper wrappedData = new ExpenseWrapper();

        //get client information
        Opportunity opp = new OpportunitiesSelector().selectByOpptId(oppId);
        Account mainClient = new AccountsSelector().selectByOpportunityId(opp.Id);
        wrappedData.clientCode = mainClient.CIF__c;
        wrappedData.Idnumber = mainClient.ID_Number__pc;

        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId); //select by opp

        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfilesByType(app.Id);
        Application_Profile__c spouseProfile;
        Application_Profile__c mainProfile;
        String spouseclientCode = '';
        if (appProfileList != null && appProfileList.size()> 0) {
            for (Application_Profile__c appProfile: appProfileList) {
                if (appProfile.Applicant_Type__c != null && appProfile.Applicant_Type__c.equalsIgnoreCase('spouse') && appProfile.Client_CIF_Code__c != null) {
                    spouseclientCode = appProfile.Client_CIF_Code__c;
                    spouseProfile = appProfile;
                } else {

                    if (appProfile.Is_Main_Applicant__c) {
                        mainProfile = appProfile;
                    }
                }
            }
        }

        /* callCreditCardServiceAppProfile(mainProfile.Id);
         if(spouseProfile != null){
            // callCreditCardServiceAppProfile(spouseProfile.Id);
         }*/
        //credit turn over expected ,query triad data

        Application_Triad__c triadData = new ApplicationTriadsSelector().getTriadCredit(mainClient.CIF__c);
        if (triadData != null) {
            wrappedData.creditTurnOver = triadData.Expected_Credit_Turnover__c;

        } else {
            wrappedData.creditTurnOver = 0;

        }
        List<Application_Income_and_Expense__c> expenses = new ApplicationIncomeExpensesSelector().selectByAppType(app.Id); //check if income and expense already exist to display
        List<Application_Financial_Account__c> appFinList = new ApplicationFinancialAccountSelector().selectByApplicationId(app.Id); //external instalment

        /** attribute required to hold values on ui**/
        List<Application_Income_and_Expense__c> externalList;
        List<Application_Income_and_Expense__c> fixedList;
        List<Application_Income_and_Expense__c> monthlyList;
        List<Application_Income_and_Expense__c> liveList;
        List<Application_Income_and_Expense__c> disposalList;
        Application_Income_and_Expense__c netIncome = new Application_Income_and_Expense__c();
        Application_Income_and_Expense__c grossIncome = new Application_Income_and_Expense__c();
        Application_Income_and_Expense__c externalinstTotal = new Application_Income_and_Expense__c();
        Application_Income_and_Expense__c fixedinstTotal = new Application_Income_and_Expense__c();
        Application_Income_and_Expense__c LiveExTotal = new Application_Income_and_Expense__c();
        Application_Income_and_Expense__c disposalIncome = new Application_Income_and_Expense__c();

        Map<String, List<Application_Income_and_Expense__c>> categoryExpenseMap = new Map<String, List<Application_Income_and_Expense__c>> ();

        if (expenses.isEmpty()) { //create new data
            //create monthly data
            monthlyList = createMonthData(app.Id);

            //create fixed Data
            fixedList = createfixedData(app.Id, mainProfile, spouseProfile); //,mainClient.CIF__c,spouseclientCode

            //SBSOUTP003

            //create external data
            externalList = createExternalData(app.Id, appFinList, mainProfile, spouseProfile);

            //create liveexpense data
            liveList = createLiveData(app.Id, mainProfile, spouseProfile);

            //update max value

            //create basic disposal record
            disposalIncome.Expense_Value__c = 'Disposal';
            disposalIncome.Category__c = 'Disposable Income';
            disposalIncome.Operation_Type__c = 'Aggregation';
            disposalIncome.Application__c = app.Id;
            try {
                insert disposalIncome;
            } catch (DmlException e) {
                System.debug('dml exception--' + e.getCause());
            }
        } else { //exisiting income and expense
            //seperate each expense type
            externalList = new List<Application_Income_and_Expense__c> ();
            monthlyList = new List<Application_Income_and_Expense__c> ();
            fixedList = new List<Application_Income_and_Expense__c> ();
            liveList = new List<Application_Income_and_Expense__c> ();
            disposalList = new List<Application_Income_and_Expense__c> ();

            for (Application_Income_and_Expense__c expense: expenses) {

                if (expense.Category__c.equalsIgnoreCase('Monthly Income')) {

                    if (expense.Expense_Value__c.equalsIgnoreCase('Total Gross Monthly Income') && expense.Operation_Type__c != null && expense.Operation_Type__c.equalsIgnoreCase('Aggregation')) {
                        grossIncome = expense;
                        wrappedData.grossIncome = grossIncome; //gross income to refelect on ui to edit
                    }
                    if (expense.Expense_Value__c.equalsIgnoreCase('Net Monthly Income') && expense.Operation_Type__c != null && expense.Operation_Type__c.equalsIgnoreCase('Aggregation')) {
                        netIncome = expense;
                        wrappedData.netIncome = netIncome; //net income to refelect on ui to edit

                    } else {
                        monthlyList.add(expense);
                    }

                } else if (expense.Category__c.equalsIgnoreCase('Fixed Debt')) {
                    if (expense.Operation_Type__c != null && expense.Operation_Type__c.equalsIgnoreCase('Aggregation')) {
                        fixedinstTotal = expense;
                    }
                    fixedList.add(expense);

                } else if (expense.Category__c.equalsIgnoreCase('External Installment')) {
                    if (expense.Operation_Type__c != null && expense.Operation_Type__c.equalsIgnoreCase('Aggregation')) {
                        externalinstTotal = expense;
                    }
                    externalList.add(expense);
                } else if (expense.Category__c.equalsIgnoreCase('Living Expenses')) {
                    if (expense.Operation_Type__c != null && expense.Operation_Type__c.equalsIgnoreCase('Aggregation')) {
                        LiveExTotal = expense;
                    }
                    liveList.add(expense);
                } else if (expense.Category__c.equalsIgnoreCase('Disposable Income')) {
                    disposalIncome = expense;
                    disposalIncome.Id = expense.Id;
                }
            }

            externalList = updateExternallist(externalList, appFinList, mainProfile, spouseProfile);

            liveList = updateLiveList(liveList, mainProfile, spouseProfile);
            //update fixed value  to be sync if product exposure has been changed
            //
            //
            //
            // disposal income
            disposalIncome.Expense_Value__c = 'Disposal';
            disposalIncome.Category__c = 'Disposable Income';
            disposalIncome.Operation_Type__c = 'Aggregation';
            disposalIncome.Total_External_Instalments__c = (externalinstTotal.Applicant_Value__c == null ? 0 : externalinstTotal.Applicant_Value__c) + (externalinstTotal.Spouse_Value__c == null ? 0 : externalinstTotal.Spouse_Value__c);
            disposalIncome.Total_Living_Expense__c = (LiveExTotal.Business_Value__c == null ? 0 : LiveExTotal.Business_Value__c) + (LiveExTotal.Household_Value__c == null ? 0 : LiveExTotal.Household_Value__c);
            disposalIncome.Total_Absa_Instalments__c = (fixedinstTotal.Applicant_Value__c == null ? 0 : fixedinstTotal.Applicant_Value__c) + (fixedinstTotal.Spouse_Value__c == null ? 0 : fixedinstTotal.Spouse_Value__c);
            disposalIncome.Total_Monthly_Household_Income__c = netIncome.Total_Monthly_Household_Income__c == null ? 0 : netIncome.Total_Monthly_Household_Income__c;
            disposalIncome.Total_MDI_Adjusted__c = (netIncome.Total_Monthly_Household_Income__c == null ? 0 : netIncome.Total_Monthly_Household_Income__c) - (
                (fixedinstTotal.Applicant_Value__c == null ? 0 : fixedinstTotal.Applicant_Value__c) + (fixedinstTotal.Spouse_Value__c == null ? 0 : fixedinstTotal.Spouse_Value__c) +
                (externalinstTotal.Total_Maximum_Applicant__c == null ? 0 : externalinstTotal.Total_Maximum_Applicant__c) + (externalinstTotal.Total_Maximum_Spouse_Value__c == null ? 0 : externalinstTotal.Total_Maximum_Spouse_Value__c) + (LiveExTotal.Maximum_Value__c == null ? 0 : LiveExTotal.Maximum_Value__c));
            // update disposal
            try {
                update disposalIncome;
            } catch (DmlException e) {
                System.debug('dml exception--' + e.getCause());
            }
            wrappedData.extspouseTotal = externalinstTotal.Spouse_Value__c;
            wrappedData.liveExbusinessholdTotal = LiveExTotal.Business_Value__c;
            wrappedData.liveExhouseholdTotal = LiveExTotal.Household_Value__c;
        }

        wrappedData.applicationId = app.Id; //application Id
        wrappedData.monthlyRecordList = idsLoop(monthlyList); //get ids for monthlyrecord
        wrappedData.fixedRecordList = idsLoop(fixedList); //get ids for fixed record
        wrappedData.externalRecordList = idsLoop(externalList); //get ids for external record
        wrappedData.liveExpRecordList = idsLoop(LiveList); //get ids for liveList record
        wrappedData.disposalIncome = disposalIncome; //to display on ui

        if (wrappedData != null) {
            PowerCurveController.setValidationFields(OppId, 'Income_Expenses', True);
        }
        return wrappedData;
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param expList
     * @return List<Id>
    **/
    public static List<Id> idsLoop(List<Application_Income_and_Expense__c> expList) {
        //ID return loop
        List<Id> idsList = new List<Id> ();
        for (Application_Income_and_Expense__c exp: expList) {
            idsList.add(exp.id);
        }

        return idsList;
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param livelist
     * @param mainProfile
     * @param spouseProfile
     * @return List<Application_Income_and_Expense__c>
    **/
    public static List<Application_Income_and_Expense__c> updateLiveList(List<Application_Income_and_Expense__c> livelist, Application_Profile__c mainProfile, Application_Profile__c spouseProfile) {
        Decimal bureau = 0;

        ConsumerBureauEnquiry_Resp_IB_v1 ApplicantresponseBean;
        ConsumerBureauEnquiry_Resp_IB_v1 spouseresponseBean;
        if (mainProfile != null && mainProfile.Bureau_JSON_Response__c != null) {
            ApplicantresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(mainProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }
        if (spouseProfile != null && spouseProfile.Bureau_JSON_Response__c != null) {
            spouseresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(spouseProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }
        for (Application_Income_and_Expense__c exp: liveList) {

            if (exp.Expense_Value__c == 'Groceries') {
                exp.Bureau_Value__c = 0;
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Municipal/Levies') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Domestic & Gardener Wages') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Telecommunication') {
                exp.Bureau_Value__c = 0; //map with bureau service //default 0;
                Decimal teleappVal = 0;
                Decimal telespouseVal = 0;
                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL != null) {

                    teleappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL != null) {
                    telespouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL);
                }
                exp.Bureau_Value__c = teleappVal + telespouseVal;
                bureau = bureau + exp.Bureau_Value__c;

            }

            if (exp.Expense_Value__c == 'Educational Fees') {
                exp.Bureau_Value__c = 0; //map with bureau service
                Decimal eduappVal = 0;
                Decimal eduspouseVal = 0;
                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL != null) {

                    eduappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL != null) {
                    eduspouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL);
                }
                exp.Bureau_Value__c = eduappVal + eduspouseVal;
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Transport/Petrol Cost (excluding vehicle finance)') {
                exp.Bureau_Value__c = 0; //map with bureau service
            }

            if (exp.Expense_Value__c == 'Insurance & Funeral Policies') {
                exp.Bureau_Value__c = 0; //map with bureau service
                Decimal insappVal = 0;
                Decimal insspouseVal = 0;
                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL != null) {

                    insappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL != null) {
                    insspouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL);
                }
                exp.Bureau_Value__c = insappVal + insspouseVal;
                bureau = bureau + exp.Bureau_Value__c;
            }
            if (exp.Expense_Value__c == 'Entertainment') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Multi Choice') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Rent') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Security') {
                exp.Bureau_Value__c = 0; //map with bureau service
                Decimal secappVal = 0;
                Decimal secspouseVal = 0;
                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL != null) {

                    secappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL != null) {
                    secspouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL);
                }
                exp.Bureau_Value__c = secappVal + secspouseVal;
                bureau = bureau + exp.Bureau_Value__c;

            }

            if (exp.Expense_Value__c == 'Medical Expenses') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Maintenance Payments - Applicant') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;

            }
            if (exp.Expense_Value__c == 'Maintenance Payments - Spouse') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Tax') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Other Expenses') {
                exp.Bureau_Value__c = 0; //map with bureau service
                bureau = bureau + exp.Bureau_Value__c;
            }

            //total live expense

            if (exp.Expense_Value__c == 'Total Living/Business Expenses') {
                exp.Operation_Type__c = 'Aggregation';
                exp.Bureau_Value__c = bureau;
            }
        }
        try {
            update liveList;
        } catch (DmlException e) {
            System.debug('dml exception--' + e.getCause());
        }
        return livelist;
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param externallist
     * @param appFinList
     * @param mainProfile
     * @param spouseProfile
     * @return List<Application_Income_and_Expense__c>
    **/
    public static List<Application_Income_and_Expense__c> updateExternallist(List<Application_Income_and_Expense__c> externallist, List<Application_Financial_Account__c> appFinList, Application_Profile__c mainProfile, Application_Profile__c spouseProfile) {
        ConsumerBureauEnquiry_Resp_IB_v1 ApplicantresponseBean;
        ConsumerBureauEnquiry_Resp_IB_v1 spouseresponseBean;
        if (mainProfile != null && mainProfile.Bureau_JSON_Response__c != null) {
            ApplicantresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(mainProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }
        if (spouseProfile != null && spouseProfile.Bureau_JSON_Response__c != null) {
            spouseresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(spouseProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }
        Decimal applicant = 0;
        Decimal spouse = 0;
        Decimal applicantbureau = 0;
        Decimal spousebureau = 0;
        Decimal maxApplicant = 0;
        Decimal maxSpouse = 0;

        map<String, Decimal> ExtinstValueMap = new map<String, Decimal> ();

        for (Application_Financial_Account__c appfin: appFinList) {
            ExtinstValueMap.put(appfin.External_Banking_Relationship__c, appfin.Monthly_Repayment__c);
        }
        for (Application_Income_and_Expense__c exp: externallist) {

            if (exp.Expense_Value__c == 'Landbank Loans') {
                exp.Applicant_Value__c = ExtinstValueMap.get('Land Bank Loan') == null ? 0 : ExtinstValueMap.get('Land Bank Loan');
                exp.Applicant_Bureau_Value__c = 0; //map with bureau service
                exp.Spouse_Bureau_Value__c = 0; //map with bureau service
                applicant = applicant + exp.Applicant_Value__c;
                maxApplicant = maxApplicant + (exp.Applicant_Value__c> exp.Applicant_Bureau_Value__c ? exp.Applicant_Value__c : exp.Applicant_Bureau_Value__c);
                maxSpouse = maxSpouse + (exp.Spouse_Value__c> exp.Spouse_Bureau_Value__c ? exp.Spouse_Value__c : exp.Spouse_Bureau_Value__c);
                // spouse = spouse + ex.Spouse_Value__c;
                applicantbureau = applicantbureau + exp.Applicant_Bureau_Value__c;
                spousebureau = spousebureau + exp.Spouse_Bureau_Value__c;
            }

            if (exp.Expense_Value__c == 'Co-operative Debt Repayments') {
                exp.Applicant_Value__c = ExtinstValueMap.get('Co-Operative Debt') == null ? 0 : ExtinstValueMap.get('Co-Operative Debt');
                exp.Applicant_Bureau_Value__c = 0; //map with bureau service
                exp.Spouse_Bureau_Value__c = 0; //map with bureau service
                applicant = applicant + exp.Applicant_Value__c;
                // spouse = spouse + ex.Spouse_Value__c;
                applicantbureau = applicantbureau + exp.Applicant_Bureau_Value__c;
                spousebureau = spousebureau + exp.Spouse_Bureau_Value__c;
                maxApplicant = maxApplicant + (exp.Applicant_Value__c> exp.Applicant_Bureau_Value__c ? exp.Applicant_Value__c : exp.Applicant_Bureau_Value__c);
                maxSpouse = maxSpouse + (exp.Spouse_Value__c> exp.Spouse_Bureau_Value__c ? exp.Spouse_Value__c : exp.Spouse_Bureau_Value__c);

            }

            if (exp.Expense_Value__c == 'Overdrafts and Personal/Term Loans') {
                exp.Applicant_Value__c = ExtinstValueMap.get('External Term Loan') == null ? 0 : ExtinstValueMap.get('External Term Loan');
                exp.Applicant_Bureau_Value__c = 0; //map with bureau service
                exp.Spouse_Bureau_Value__c = 0; //map with bureau service
                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL != null) {
                    exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL != null) {
                    exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL);
                }
                applicant = applicant + exp.Applicant_Value__c;
                // spouse = spouse + ex.Spouse_Value__c;
                applicantbureau = applicantbureau + exp.Applicant_Bureau_Value__c;
                spousebureau = spousebureau + exp.Spouse_Bureau_Value__c;
                maxApplicant = maxApplicant + (exp.Applicant_Value__c> exp.Applicant_Bureau_Value__c ? exp.Applicant_Value__c : exp.Applicant_Bureau_Value__c);
                maxSpouse = maxSpouse + (exp.Spouse_Value__c> exp.Spouse_Bureau_Value__c ? exp.Spouse_Value__c : exp.Spouse_Bureau_Value__c);

            }
            if (exp.Expense_Value__c == 'Credit Cards') {
                exp.Applicant_Value__c = ExtinstValueMap.get('Business Credit Card') == null ? 0 : ExtinstValueMap.get('Business Credit Card');
                exp.Applicant_Bureau_Value__c = 0; //map with bureau service
                exp.Spouse_Bureau_Value__c = 0; //map with bureau service
                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL != null) {
                    exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL != null) {
                    exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL);
                }
                applicant = applicant + exp.Applicant_Value__c;
                // spouse = spouse + ex.Spouse_Value__c;
                applicantbureau = applicantbureau + exp.Applicant_Bureau_Value__c;
                spousebureau = spousebureau + exp.Spouse_Bureau_Value__c;
                maxApplicant = maxApplicant + (exp.Applicant_Value__c> exp.Applicant_Bureau_Value__c ? exp.Applicant_Value__c : exp.Applicant_Bureau_Value__c);
                maxSpouse = maxSpouse + (exp.Spouse_Value__c> exp.Spouse_Bureau_Value__c ? exp.Spouse_Value__c : exp.Spouse_Bureau_Value__c);

            }

            if (exp.Expense_Value__c == 'Mortgage Loan Instalments') {
                exp.Applicant_Value__c = ExtinstValueMap.get('External Mortgage Loan') == null ? 0 : ExtinstValueMap.get('External Mortgage Loan');
                exp.Applicant_Bureau_Value__c = 0; //map with bureau service
                exp.Spouse_Bureau_Value__c = 0; //map with bureau service

                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL != null) {
                    exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL != null) {
                    exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL);
                }
                applicant = applicant + exp.Applicant_Value__c;
                // spouse = spouse + ex.Spouse_Value__c;
                applicantbureau = applicantbureau + exp.Applicant_Bureau_Value__c;
                spousebureau = spousebureau + exp.Spouse_Bureau_Value__c;
                maxApplicant = maxApplicant + (exp.Applicant_Value__c> exp.Applicant_Bureau_Value__c ? exp.Applicant_Value__c : exp.Applicant_Bureau_Value__c);
                maxSpouse = maxSpouse + (exp.Spouse_Value__c> exp.Spouse_Bureau_Value__c ? exp.Spouse_Value__c : exp.Spouse_Bureau_Value__c);

            }

            if (exp.Expense_Value__c == 'Retail & Other Debt Repayments') {

                exp.Applicant_Value__c = ExtinstValueMap.get('Retail And Other External Commitment') == null ? 0 : ExtinstValueMap.get('Retail And Other External Commitment');
                exp.Applicant_Bureau_Value__c = 0; //map with bureau service
                exp.Spouse_Bureau_Value__c = 0; //map with bureau service

                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL != null) {
                    exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL) +
                        Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTRETINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL != null) {
                    exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL) + Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTRETINSTL);
                }
                applicant = applicant + exp.Applicant_Value__c;
                // spouse = spouse + ex.Spouse_Value__c;
                applicantbureau = applicantbureau + exp.Applicant_Bureau_Value__c;
                spousebureau = spousebureau + exp.Spouse_Bureau_Value__c;
                maxApplicant = maxApplicant + (exp.Applicant_Value__c> exp.Applicant_Bureau_Value__c ? exp.Applicant_Value__c : exp.Applicant_Bureau_Value__c);
                maxSpouse = maxSpouse + (exp.Spouse_Value__c> exp.Spouse_Bureau_Value__c ? exp.Spouse_Value__c : exp.Spouse_Bureau_Value__c);

            }

            if (exp.Expense_Value__c == 'Asset Finance/Lease Repayments') {

                exp.Applicant_Value__c = ExtinstValueMap.get('External Asset And Vehicle Finance') == null ? 0 : ExtinstValueMap.get('External Asset And Vehicle Finance');
                exp.Applicant_Bureau_Value__c = 0; //map with bureau service
                exp.Spouse_Bureau_Value__c = 0; //map with bureau service
                if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL != null) {
                    exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL);
                }
                if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL != null) {
                    exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL);
                }
                applicant = applicant + exp.Applicant_Value__c;
                // spouse = spouse + ex.Spouse_Value__c;
                applicantbureau = applicantbureau + exp.Applicant_Bureau_Value__c;
                spousebureau = spousebureau + exp.Spouse_Bureau_Value__c;
                maxApplicant = maxApplicant + (exp.Applicant_Value__c> exp.Applicant_Bureau_Value__c ? exp.Applicant_Value__c : exp.Applicant_Bureau_Value__c);
                maxSpouse = maxSpouse + (exp.Spouse_Value__c> exp.Spouse_Bureau_Value__c ? exp.Spouse_Value__c : exp.Spouse_Bureau_Value__c);

            }

            //total external expense

            if (exp.Expense_Value__c == 'Total External Instalments') {
                exp.Operation_Type__c = 'Aggregation';
                exp.Applicant_Value__c = applicant;
                //exp.Spouse_Value__c = spouse;
                exp.Applicant_Bureau_Value__c = applicantbureau;
                exp.Spouse_Bureau_Value__c = spousebureau;
                exp.Total_Maximum_Applicant__c = maxApplicant;
                exp.Total_Maximum_Spouse_Value__c = maxSpouse;
            }
        }

        try {
            update externallist;
        } catch (DmlException e) {
            System.debug('dml exception--' + e.getCause());
        }

        return externallist;
    }

    /**
     * @description create monthly income records
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param appId
     * @return List<Application_Income_and_Expense__c>
    **/
    public static List<Application_Income_and_Expense__c> createMonthData(Id appId) {
        List<Application_Income_and_Expense__c> monthlyList = new List<Application_Income_and_Expense__c> ();
        Application_Income_and_Expense__c exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Monthly Income';
        exp.Expense_Value__c = 'Business Income/Gross Salary';
        monthlyList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Monthly Income';
        exp.Expense_Value__c = 'Rental Income';
        monthlyList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Monthly Income';
        exp.Expense_Value__c = 'Maintenance Income';
        monthlyList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Monthly Income';
        exp.Expense_Value__c = 'Other Income (Investments, Salaried, etc.)';
        monthlyList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Monthly Income';
        exp.Expense_Value__c = 'Statutory Deductions - Maintenance';
        monthlyList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Monthly Income';
        exp.Expense_Value__c = 'Statutory Deductions - Other';
        monthlyList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Monthly Income';
        exp.Expense_Value__c = 'Salary Deductions';
        monthlyList.add(exp);
        try {
            insert monthlyList;
        } catch (DmlException e) {
            System.debug('dml exception--' + e.getCause());
        }
        return monthlyList;
    }

    /**
     * @description create fixed debt records
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param appId
     * @param mainProfile
     * @param spouseProfile
     * @return List<Application_Income_and_Expense__c>
    **/
    public static List<Application_Income_and_Expense__c> createFixedData(Id appId, Application_Profile__c mainProfile, Application_Profile__c spouseProfile) {
        Decimal applicantCreditInstallment = 0;
        Decimal spouseCreditInstallment = 0;
        Boolean isCCNumMatch = false;

        List<Application_Exposure__c> ApplicantproductExList = new ApplicationExposureSelector().getApplicationExposure(mainProfile.Client_CIF_Code__c, appId);
        List<Application_Exposure__c> spouseproductExList = new List<Application_Exposure__c> ();
        List<Application_Exposure__c> prodListSp = new List<Application_Exposure__c> ();
        if (spouseProfile != null) {
            spouseproductExList = new ApplicationExposureSelector().getApplicationExposure(spouseProfile.Client_CIF_Code__c, appId);
            spouseCreditInstallment = spouseProfile.Total_Credit_Instalment_Amount__c == null ? 0 : spouseProfile.Total_Credit_Instalment_Amount__c;
        	prodListSp = new ApplicationExposureSelector().getApplicationExposureByClientName(spouseProfile.Client_Name__c,appId);

        }

        List<Application_Exposure__c> prodListMain = new ApplicationExposureSelector().getApplicationExposureByClientName(mainProfile.Client_Name__c,appId);

        Map<String, Application_Exposure__c> applicantExposureMap = new Map<String, Application_Exposure__c> ();
        Map<String, Application_Exposure__c> spouseExposureMap = new Map<String, Application_Exposure__c> ();
        Map<String, Application_Exposure_Facility__c> applicantFacilityMap = new Map<String, Application_Exposure_Facility__c> ();
        Map<String, Application_Exposure_Facility__c> spouseFacilityMap = new Map<String, Application_Exposure_Facility__c> ();

        for (Application_Exposure__c expProduct: ApplicantproductExList) {
            applicantExposureMap.put('' + expProduct.Exposure_Data_Type__c, expProduct);
        }

        for (Application_Exposure__c expProduct: prodListMain) {
            applicantExposureMap.put('' + expProduct.Exposure_Data_Type__c, expProduct);
        }

        for (Application_Exposure__c expProduct: spouseproductExList) {
            spouseExposureMap.put('' + expProduct.Exposure_Data_Type__c, expProduct);
        }

        for (Application_Exposure__c expProduct: prodListSp) {
            spouseExposureMap.put('' + expProduct.Exposure_Data_Type__c, expProduct);
        }

        List<Application_Exposure_Facility__c> appExpFacList = new NonScoredApprovedFacilitiesSelector().selectByApplicationId(appId);
        for(Application_Exposure_Facility__c outAppFac :appExpFacList) {
            if(outAppFac.Approved_Facility__c =='Approved Facilities Total' && mainProfile?.Client_CIF_Code__c == outAppFac.Client_Code__c) {
                applicantFacilityMap.put('Installments Total', outAppFac);
            }

            if(spouseProfile !=null){
            if(outAppFac.Approved_Facility__c =='Approved Facilities Total' && outAppFac.Client_Name__c.contains(spouseProfile?.Client_Name__c)) {
                spouseFacilityMap.put('Installments Total', outAppFac);
            }
            }     
        }

        //call credit card service data..

        List<Application_Income_and_Expense__c> expList = new List<Application_Income_and_Expense__c> ();
        Application_Income_and_Expense__c exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Credit Cards';
        exp.Applicant_Value__c = mainProfile.Total_Credit_Instalment_Amount__c == null ? 0 : mainProfile.Total_Credit_Instalment_Amount__c; //responseBeanApplicant.CAgetCassACSBEnqV1Response.cap918o.instalment;
        //applicantExposureMap.get('Credit Card')  == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Credit Card').Installment__c); //map with product exposure
        exp.Spouse_Value__c = spouseCreditInstallment; // responseBeanSpouse.CAgetCassACSBEnqV1Response.cap918o.instalment;
        //spouseExposureMap.get('Credit Card') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Credit Card').Installment__c); //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Personal/Term Loans';
        exp.Applicant_Value__c = applicantExposureMap.get('Loans') == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Loans').Installment__c); //map with product exposure
        exp.Spouse_Value__c = spouseExposureMap.get('Loans') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Loans').Installment__c); //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Overdrafts';
        exp.Applicant_Value__c =  applicantExposureMap.get('Cheques') == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Cheques').Installment__c); //map with product exposure
        exp.Spouse_Value__c = spouseExposureMap.get('Cheques') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Cheques').Installment__c); //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Other Ordinary Credit';
        exp.Applicant_Value__c = applicantExposureMap.get('Other Ordinary Credit') == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Other Ordinary Credit').Installment__c); //map with product exposure
        exp.Spouse_Value__c = spouseExposureMap.get('Other Ordinary Credit') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Other Ordinary Credit').Installment__c); //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Asset Finance/Lease Repayments';
        exp.Applicant_Value__c = applicantExposureMap.get('Asset Finance') == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Asset Finance').Installment__c); //map with product exposure
        exp.Spouse_Value__c = spouseExposureMap.get('Asset Finance') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Asset Finance').Installment__c); //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Mortgage Loan Instalments';
        exp.Applicant_Value__c = applicantExposureMap.get('Mortgage Total') == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Mortgage Total').Installment__c); //map with product exposure
        exp.Spouse_Value__c = spouseExposureMap.get('Mortgage Total') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Mortgage Total').Installment__c); //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Approved Facilities';
        exp.Applicant_Value__c = applicantFacilityMap.get('Installments Total') == null ? 0 : applicantFacilityMap.get('Installments Total').Installments_Total__c; //map with product exposure
        exp.Spouse_Value__c = spouseFacilityMap.get('Installments Total') == null ? 0 : spouseFacilityMap.get('Installments Total').Installments_Total__c; //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Total Excesses';
        exp.Applicant_Value__c = applicantExposureMap.get('Product Type Total') == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Product Type Total').Excess__c); //map with product exposure
        exp.Spouse_Value__c = spouseExposureMap.get('Product Type Total') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Product Type Total').Excess__c); //map with product exposure spouse
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Total Arrears';
        exp.Applicant_Value__c = applicantExposureMap.get('Product Type Total') == null ? 0 : Decimal.valueOf(applicantExposureMap.get('Product Type Total').Arrears__c); //map with product exposure
        exp.Spouse_Value__c = spouseExposureMap.get('Product Type Total') == null ? 0 : Decimal.valueOf(spouseExposureMap.get('Product Type Total').Arrears__c); //map with product exposure spouse
        expList.add(exp);

        /*Total column,need to update once product type exposures are calculated*/
        decimal spouse = 0;
        decimal applicant = 0;
        for (Application_Income_and_Expense__c ex: expList) {
            applicant = applicant + ex.Applicant_Value__c;
            spouse = spouse + ex.Spouse_Value__c;
        }

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Fixed Debt';
        exp.Expense_Value__c = 'Total Absa Instalments';
        exp.Operation_Type__c = 'Aggregation';
        exp.Applicant_Value__c = applicant;
        exp.Spouse_Value__c = spouse;
        expList.add(exp);
        try {
            insert expList;
        } catch (DmlException e) {
            System.debug('dml exception--' + e.getCause());
        }

        return expList;
    }

    /**
     * @description create Live and Expense records
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param appId
     * @param mainProfile
     * @param spouseProfile
     * @return List<Application_Income_and_Expense__c>
    **/
    public static List<Application_Income_and_Expense__c> createLiveData(Id appId, Application_Profile__c mainProfile, Application_Profile__c spouseProfile) { // Bureau value from service once come

        ConsumerBureauEnquiry_Resp_IB_v1 ApplicantresponseBean;
        ConsumerBureauEnquiry_Resp_IB_v1 spouseresponseBean;
        if (mainProfile != null && mainProfile.Bureau_JSON_Response__c != null) {
            ApplicantresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(mainProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }
        if (spouseProfile != null && spouseProfile.Bureau_JSON_Response__c != null) {
            spouseresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(spouseProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }
        List<Application_Income_and_Expense__c> expList = new List<Application_Income_and_Expense__c> ();
        Application_Income_and_Expense__c exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Groceries';
        exp.Bureau_Value__c = 0;
        //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Municipal/Levies';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Domestic & Gardener Wages';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Telecommunication';
        exp.Bureau_Value__c = 0; //map with bureau service //default 0;
        Decimal teleappVal = 0;
        Decimal telespouseVal = 0;
        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL != null) {

            teleappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL != null) {
            telespouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTTELINSTL);
        }
        exp.Bureau_Value__c = teleappVal + telespouseVal;

        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Educational Fees';
        exp.Bureau_Value__c = 0; //map with bureau service
        Decimal eduappVal = 0;
        Decimal eduspouseVal = 0;
        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL != null) {

            eduappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL != null) {
            eduspouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTEDUINSTL);
        }
        exp.Bureau_Value__c = eduappVal + eduspouseVal;
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Transport/Petrol Cost (excluding vehicle finance)';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Insurance & Funeral Policies';
        exp.Bureau_Value__c = 0; //map with bureau service
        Decimal insappVal = 0;
        Decimal insspouseVal = 0;
        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL != null) {

            insappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL != null) {
            insspouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTINSINSTL);
        }
        exp.Bureau_Value__c = insappVal + insspouseVal;
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Entertainment';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Multi Choice';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Rent';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Security';
        exp.Bureau_Value__c = 0; //map with bureau service
        Decimal secappVal = 0;
        Decimal secspouseVal = 0;
        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL != null) {

            secappVal = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL != null) {
            secspouseVal = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTSECINSTL);
        }
        exp.Bureau_Value__c = secappVal + secspouseVal;

        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Medical Expenses';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Maintenance Payments - Applicant';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Maintenance Payments - Spouse';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Tax';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Other Expenses';
        exp.Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        //total live expense

        Decimal bureau = 0;
        for (Application_Income_and_Expense__c ex: expList) {
            bureau = bureau + ex.Bureau_Value__c;
        }

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'Living Expenses';
        exp.Expense_Value__c = 'Total Living/Business Expenses';
        exp.Operation_Type__c = 'Aggregation';
        exp.Bureau_Value__c = bureau;
        expList.add(exp);
        try {
            insert expList;
        } catch (DmlException e) {
            System.debug('dml exception--' + e.getCause());
        }
        return expList;
    }

    /**
     * @description create external installment records
     * @author Almas.Aleem@absa.africa | 2020-09-28
     * @param appId
     * @param appFinList
     * @param mainProfile
     * @param spouseProfile
     * @return List<Application_Income_and_Expense__c>
    **/
    public static List<Application_Income_and_Expense__c> createExternalData(Id appId, List<Application_Financial_Account__c> appFinList, Application_Profile__c mainProfile, Application_Profile__c spouseProfile) { // also add value from service also

        ConsumerBureauEnquiry_Resp_IB_v1 ApplicantresponseBean;
        ConsumerBureauEnquiry_Resp_IB_v1 spouseresponseBean;
        if (mainProfile != null && mainProfile.Bureau_JSON_Response__c != null) {
            ApplicantresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(mainProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }
        if (spouseProfile != null && spouseProfile.Bureau_JSON_Response__c != null) {
            spouseresponseBean = (ConsumerBureauEnquiry_Resp_IB_v1) JSON.deserialize(spouseProfile.Bureau_JSON_Response__c, ConsumerBureauEnquiry_Resp_IB_v1.class);

        }

        map<String, Decimal> ExtinstValueMap = new map<String, Decimal> ();

        for (Application_Financial_Account__c appfin: appFinList) {
            ExtinstValueMap.put(appfin.External_Banking_Relationship__c, appfin.Monthly_Repayment__c);
        }
        List<Application_Income_and_Expense__c> expList = new List<Application_Income_and_Expense__c> ();

        Application_Income_and_Expense__c exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Landbank Loans';
        exp.Applicant_Value__c = ExtinstValueMap.get('Land Bank Loan') == null ? 0 : ExtinstValueMap.get('Land Bank Loan');
        exp.Applicant_Bureau_Value__c = 0; //map with bureau service
        exp.Spouse_Bureau_Value__c = 0; //map with bureau service

        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Co-operative Debt Repayments';
        exp.Applicant_Value__c = ExtinstValueMap.get('Co-Operative Debt') == null ? 0 : ExtinstValueMap.get('Co-Operative Debt');
        exp.Applicant_Bureau_Value__c = 0; //map with bureau service
        exp.Spouse_Bureau_Value__c = 0; //map with bureau service
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Overdrafts and Personal/Term Loans';
        exp.Applicant_Value__c = ExtinstValueMap.get('External Term Loan') == null ? 0 : ExtinstValueMap.get('External Term Loan');
        exp.Applicant_Bureau_Value__c = 0; //map with bureau service
        exp.Spouse_Bureau_Value__c = 0; //map with bureau service
        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL != null) {
            exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL != null) {
            exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODLINSTL);
        }

        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Credit Cards';
        exp.Applicant_Value__c = ExtinstValueMap.get('Business Credit Card') == null ? 0 : ExtinstValueMap.get('Business Credit Card');
        exp.Applicant_Bureau_Value__c = 0; //map with bureau service
        exp.Spouse_Bureau_Value__c = 0; //map with bureau service
        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL != null) {
            exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL != null) {
            exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTCCINSTL);
        }

        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Mortgage Loan Instalments';
        exp.Applicant_Value__c = ExtinstValueMap.get('External Mortgage Loan') == null ? 0 : ExtinstValueMap.get('External Mortgage Loan');
        exp.Applicant_Bureau_Value__c = 0; //map with bureau service
        exp.Spouse_Bureau_Value__c = 0; //map with bureau service

        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL != null) {
            exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL != null) {
            exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTBNDINSTL);
        }
        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Retail & Other Debt Repayments';
        exp.Applicant_Value__c = ExtinstValueMap.get('Retail And Other External Commitment') == null ? 0 : ExtinstValueMap.get('Retail And Other External Commitment');
        exp.Applicant_Bureau_Value__c = 0; //map with bureau service
        exp.Spouse_Bureau_Value__c = 0; //map with bureau service

        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL != null) {
            exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL) +
                Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTRETINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL != null) {
            exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTODBTINSTL) + Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTRETINSTL);
        }

        expList.add(exp);

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Asset Finance/Lease Repayments';
        exp.Applicant_Value__c = ExtinstValueMap.get('External Asset And Vehicle Finance') == null ? 0 : ExtinstValueMap.get('External Asset And Vehicle Finance');
        exp.Applicant_Bureau_Value__c = 0; //map with bureau service
        exp.Spouse_Bureau_Value__c = 0; //map with bureau service
        if (ApplicantresponseBean != null && ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL != null) {
            exp.Applicant_Bureau_Value__c = Decimal.valueOf(ApplicantresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL);
        }
        if (spouseresponseBean != null && spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL != null) {
            exp.Spouse_Bureau_Value__c = Decimal.valueOf(spouseresponseBean.Response.ApplicationDV.CONS.TENRSUM.BURTCONENRSUMPPSALLTOTVAFINSTL);
        }

        expList.add(exp);

        //total external expense
        Decimal applicant = 0;
        Decimal spouse = 0;
        Decimal applicantbureau = 0;
        Decimal spousebureau = 0;
        Decimal maxApplicant = 0;
        Decimal maxSpouse = 0;
        for (Application_Income_and_Expense__c ex: expList) {
            applicant = applicant + ex.Applicant_Value__c;
            // spouse = spouse + ex.Spouse_Value__c;
            applicantbureau = applicantbureau + ex.Applicant_Bureau_Value__c;
            spousebureau = spousebureau + ex.Spouse_Bureau_Value__c;

            maxApplicant = maxApplicant + (ex.Applicant_Value__c> ex.Applicant_Bureau_Value__c ? ex.Applicant_Value__c : ex.Applicant_Bureau_Value__c);
            maxSpouse = maxSpouse + (ex.Spouse_Value__c> ex.Spouse_Bureau_Value__c ? ex.Spouse_Value__c : ex.Spouse_Bureau_Value__c);
        }

        exp = new Application_Income_and_Expense__c();
        exp.Application__c = appId;
        exp.Category__c = 'External Installment';
        exp.Expense_Value__c = 'Total External Instalments';
        exp.Operation_Type__c = 'Aggregation';
        exp.Applicant_Value__c = applicant;
        //exp.Spouse_Value__c = spouse;
        exp.Applicant_Bureau_Value__c = applicantbureau;
        exp.Spouse_Bureau_Value__c = spousebureau;
        exp.Total_Maximum_Applicant__c = maxApplicant;
        exp.Total_Maximum_Spouse_Value__c = maxSpouse;
        expList.add(exp);

        try {
            insert expList;
        } catch (DmlException e) {
            System.debug('dml exception--' + e.getCause());
        }
        return expList;
    }

    /**
     *
     * @description wrapper class to show data on ui
     */
    public class ExpenseWrapper {
        @auraEnabled public List<Id> monthlyRecordList;
        @auraEnabled public List<Id> fixedRecordList;
        @auraEnabled public List<Id> externalRecordList;
        @auraEnabled public List<Id> liveExpRecordList;
        @auraEnabled public Decimal creditTurnOver;
        @auraEnabled public String clientCode;
        @auraEnabled public String IDNumber;
        @auraEnabled public Id applicationId;
        @auraEnabled public Decimal extspouseTotal;
        @auraEnabled public Decimal liveExbusinessholdTotal;
        @auraEnabled public Decimal liveExhouseholdTotal;
        @auraEnabled public Application_Income_and_Expense__c grossIncome;
        @auraEnabled public Application_Income_and_Expense__c netIncome;
        @auraEnabled public Application_Income_and_Expense__c disposalIncome;
    }
}