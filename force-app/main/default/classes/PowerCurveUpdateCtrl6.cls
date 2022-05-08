/**
 * @description       :
 * @author            : Almas.Aleem@absa.africa
 * @last modified on  : 2021-06-18
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-06-18   Almas.Aleem@absa.africa   Initial Version
**/
public class PowerCurveUpdateCtrl6 {
    /**
     * @description map stage 6 fields to PCO
     * @author Almas.Aleem@absa.africa | 2021-06-18
     * @param requestBean
     * @param oppId
     * @param stage
     * @return PowerCurveUpdateApplication_Req_IB_v1
    **/
    public static PowerCurveUpdateApplication_Req_IB_v1 mapPowerCureveUpdateRequest(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Id oppId, Integer stage){
        if(stage >= 6){
              requestBean.Request.ApplicationDV.AppData.APPAPPWCRM = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPWCRM();
              requestBean.Request.ApplicationDV.AppData.APPAPPMIAE = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPMIAE();
             requestBean = mapStage6Fields(requestBean,oppId);
        }

        return requestBean;
    }

    /**
     * @description method to map stage 6 fields to PCO
     * @author Almas.Aleem@absa.africa | 2021-06-18
     * @param requestBean
     * @param oppId
     * @return PowerCurveUpdateApplication_Req_IB_v1
    **/
    public static PowerCurveUpdateApplication_Req_IB_v1 mapStage6Fields(PowerCurveUpdateApplication_Req_IB_v1 requestBean,Id oppId){

        /*Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestBean, true));
		Map<String, Object> Request = (Map<String, Object>)untypedMap.get('Request');
        Map<String, Object> ApplicationDV = (Map<String, Object>)Request.get('ApplicationDV');*/

        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.AVAILABLE = '0';// send blank to pco
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.TIMSNCECAPTURE = '0';// send blank to pco
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.PITPD = '0';// send blank to pco
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.PITDG = '0';// send blank to pco
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.TTCPD = '0';// send blank to pco
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.TTCDG = '0';// send blank to pco
        requestBean.Request.ApplicationDV.APPAPPSTAGEID ='06';

        //check if MIAE is true from power curve 4 response...
        //MIAE
        Boolean MIAE = false;
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId); //select by opp
        List<Application_Income_and_Expense__c> expenses = new ApplicationIncomeExpensesSelector().selectByAppType(app.Id); //check if income and expense already exist to map

        if(!expenses.isEmpty()){
            for(Application_Income_and_Expense__c expense:expenses){
                if(expense.Category__c.equalsIgnoreCase('Monthly Income')){
                    if(expense.Expense_Value__c.equalsIgnoreCase('Business Income/Gross Salary') ){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSAPL = ''+expense.Applicant_Value__c;
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSSPSE = ''+expense.Spouse_Value__c;
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSHH ='' +(expense.Applicant_Value__c + expense.Spouse_Value__c );  //net total house hold income;


                    }if(expense.Expense_Value__c.equalsIgnoreCase('Net Monthly Income')  && expense.Operation_Type__c !=null && expense.Operation_Type__c.equalsIgnoreCase('Aggregation')){
                       // requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSHH = ''+expense.Total_Monthly_Household_Income__c;  //net total house hold income
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETAPL = ''+ expense.Applicant_Value__c; //net total applicant income
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETSPSE = ''+expense.Spouse_Value__c; //net total spouse income
                       requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETHH ='' +expense.Total_Monthly_Household_Income__c;  //net total house hold income;
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Statutory Deductions - Maintenance')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDMAINTAPL = ''+expense.Applicant_Value__c; //Statutory Deductions - Maintenance applicant
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDMAINTSPSE = ''+expense.Spouse_Value__c; // Statutory Deductions - Maintenance

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Statutory Deductions - Other')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDOTHERAPL = ''+expense.Applicant_Value__c; //Statutory Deductions - other applicant
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDOTHERSPSE = ''+expense.Spouse_Value__c; // Statutory Deductions - other spouse

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Maintenance Income')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCMAINTAPL = ''+expense.Applicant_Value__c; //Maintenance Income applicant
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCMAINTSPSE = ''+expense.Spouse_Value__c; // Maintenance Income spouse

                    }
                }if(expense.Category__c.equalsIgnoreCase('Living Expenses')){
                    if(expense.Expense_Value__c.equalsIgnoreCase('Maintenance Payments - Applicant')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMAINTAPL = ''+expense.Maximum_Value__c; // Maintenance Payments - Applicant
                    } if(expense.Expense_Value__c.equalsIgnoreCase('Maintenance Payments - Spouse')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMAINTSPSE = ''+expense.Maximum_Value__c; //Maintenance Payments - Spouse
                    }
                    if(expense.Expense_Value__c.equalsIgnoreCase('Rent')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPACCOMMODATION = ''+expense.Maximum_Value__c;  //living expense tab rent
                    }
                    if(expense.Expense_Value__c.equalsIgnoreCase('Groceries')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPFOOD = ''+expense.Maximum_Value__c; //living expense tab Groceries = ''+expense.Maximum_Value__c;  //living expense tab rent
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Transport/Petrol Cost (excluding vehicle finance)')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTRANSPORT = ''+expense.Maximum_Value__c; //Transport/Petrol Cost (excluding vehicle finance)
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Educational Fees')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPEDUCATION = ''+expense.Maximum_Value__c; //Educational Fees
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Medical Expenses')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMEDICAL = ''+expense.Maximum_Value__c; //Medical Expenses
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Municipal/Levies')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPWATERELECTRICITY = ''+expense.Maximum_Value__c; //Municipal/Levies
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Insurance & Funeral Policies')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPINSURANCE = ''+expense.Maximum_Value__c; //Insurance & Funeral Policies
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Other Expenses')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPOTHER = ''+expense.Maximum_Value__c; //Other Expenses
                    }if(expense.Expense_Value__c.equalsIgnoreCase('Total Living/Business Expenses')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTOTALDECL =  ''+expense.Maximum_Value__c; //''+expense.Business_Value__c; //Total Living/Business Expenses
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTOTALDECLADJ = ''+expense.Maximum_Value__c; //Total Living/Business Expenses

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Domestic & Gardener Wages')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPDOMESTICWAGES = ''+expense.Maximum_Value__c; //Domestic & Gardener Wages

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Telecommunication')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTELECOMMS = ''+expense.Maximum_Value__c; //Telecommunication

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Entertainment')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPENTERTAINMENT = ''+expense.Maximum_Value__c; //Entertainment

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Multi Choice')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMULTICHOICE = ''+expense.Maximum_Value__c; //Multi Choice

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Security')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPSECURITY = ''+expense.Maximum_Value__c; //Security

                    }if(expense.Expense_Value__c.equalsIgnoreCase('Tax')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTAX = ''+expense.Maximum_Value__c; //Tax

                    }

                }if(expense.Category__c.equalsIgnoreCase('External Installment')){
                    if(expense.Expense_Value__c.equalsIgnoreCase('Total External Instalments')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTDECLAPL = ''+expense.Applicant_Value__c; //total external instalment declared applicant
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTDECLSPSE = ''+expense.Spouse_Value__c; //total external instalment declared spouse

                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTCBURNONABSAAPL = ''+expense.Applicant_Bureau_Value__c; //external installment bureau applicant
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTCBURNONABSASPSE = ''+expense.Spouse_Bureau_Value__c; //external installment bureau spouse
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTADJAPL = ''+expense.Total_Maximum_Applicant__c; //maximum external instalment applicant
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTADJSPSE = ''+expense.Total_Maximum_Spouse_Value__c ; //maximum external instalment spouse

                    }
                }if(expense.Category__c.equalsIgnoreCase('Fixed Debt')){
                    if(expense.Expense_Value__c.equalsIgnoreCase('Total Absa Instalments')){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTABSAAPL = ''+expense.Applicant_Value__c; //total absa instalment applicant
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTABSASPSE = ''+expense.Spouse_Value__c; //total absa instalment spouse
                    }
                }if(expense.Category__c.equalsIgnoreCase('Disposable Income')){
                    if(expense.Total_Monthly_Disposable_Income__c != null){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCDISCRETDECL = ''+expense.Total_Monthly_Disposable_Income__c; //Total Monthly Disposable Income (MDI) Declared
                    }if(expense.Total_MDI_Adjusted__c !=null ){
                        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCDISCRETDECLADJ = ''+expense.Total_MDI_Adjusted__c; //Total Monthly Disposable Income (MDI) Adjusted
                    }
                }
            }
        }

        else{
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSAPL = '0'; //total gross monthly income applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSSPSE = '0'; //total gross monthly income spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSHH = '0';  //net total house hold income
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETAPL = '0'; //net total applicant income
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETSPSE = '0'; //net total spouse income
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETHH = '0';//net total house hold income
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDMAINTAPL = '0'; //Statutory Deductions - Maintenance applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDMAINTSPSE = '0'; // Statutory Deductions - Maintenance spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDOTHERAPL = '0'; //Statutory Deductions - Other applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDOTHERSPSE = '0';//Statutory Deductions - Other spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCMAINTAPL = '0'; // Maintenance Income applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCMAINTSPSE = '0'; // Maintenance Income spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMAINTAPL = '0'; // Living Expenses Maintenance applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMAINTSPSE = '0'; //Living Expenses Maintenance spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTDECLAPL = '0';  //total external instalment declared applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTDECLSPSE = '0'; //total external instalment declared spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTABSAAPL = '0'; //total absa instalment applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTABSASPSE = '0'; //total absa instalment spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTCBURNONABSAAPL = '0'; //external installment bureau applicant
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTCBURNONABSASPSE = '0'; //external installment bureau spouse
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPACCOMMODATION = '0';  //living expense tab rent
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPFOOD = '0'; //living expense tab Groceries
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTRANSPORT = '0'; // Transport/Petrol Cost (excluding vehicle finance)
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPEDUCATION = '0';// education fees
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMEDICAL = '0';//Medical Expenses
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPWATERELECTRICITY = '0';//Municipal/Levies
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPINSURANCE = '0';//Insurance & Funeral Policies
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPOTHER = '0';//Other expense
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTOTALDECL = '0'; //Total Living/Business Expenses
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCDISCRETDECL = '0'; // total mdi
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTADJAPL = '0'; // external total applicant maximum
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTADJSPSE = '0'; // external total spouse maximum
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTOTALDECLADJ = '0'; // Total Living/Business Expenses - Max:Bureau/Declared
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCDISCRETDECLADJ = '0'; //total mdi adjusted
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPDOMESTICWAGES = '0';  // Domestic & Gardener Wages
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTELECOMMS = '0'; //Telecommunication
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPENTERTAINMENT = '0'; //Entertainment
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMULTICHOICE = '0'; //Multichoice
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPSECURITY = '0'; //Security
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTAX = '0';  //tax
        }

        //map values from conduct accounts
      /*  requestBean.Request.ApplicationDV.Entity01 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01 ();
        requestBean.Request.ApplicationDV.Entity02 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity03 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity04 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity05 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity06 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();*/
        List<Application_Financial_Conduct__c> applConducts = new ApplicationFinancialConductSelector().selectByApplicationId(app.Id);
        for(Application_Financial_Conduct__c acctConduct : applConducts){
            if(acctConduct.Conduct_Type__c.EqualsIgnoreCase('Primary Conduct')){
                requestBean.Request.ApplicationDV.Entity01.INTENTCDUCTDAYSSNCELASTCREDIT = acctConduct.Days_Since_Last_Credit_Date__c == null ?'-6' : ''+acctConduct.Days_Since_Last_Credit_Date__c   ;
            }
        }

       // requestBean.Request.ApplicationDV.Entity01.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';
       /* requestBean.Request.ApplicationDV.Entity02.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';
        requestBean.Request.ApplicationDV.Entity03.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';
        requestBean.Request.ApplicationDV.Entity04.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';
        requestBean.Request.ApplicationDV.Entity05.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';
        requestBean.Request.ApplicationDV.Entity06.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';*/
        return requestBean;
    }
}