/*
 * Response Integration Bean for ExperianGetXML2Report Service
 * @author Danie Booysen
 * @created 2020-09-30
 */

public class ExperianGetXML2Report_Resp_IB_v2 extends Base_IB {

    @AuraEnabled  public String status;
    @AuraEnabled  public Integer statusCode;
    @AuraEnabled  public String message;

    public GetXML2ReportResult[] GetXML2ReportResult;

      public class GetXML2ReportResult {
        public Session Session;
        public InputData InputData;
        public SubscriberInfo SubscriberInfo;
        public ReturnData ReturnData;
        public Detect Detect;
        public ScoreBlock ScoreBlock;
        public Enquiry Enquiry;
        public Accounts Accounts;
        public JudgementsJudgement Judgements;
        public NoticesNotice Notices;
        public Defaults Defaults;
    }

    public class JudgementsJudgement{
        public Judgement[] Judgement;
    }
    public class Judgement{
        public String CourtName;
        public String CourtID;
        public String CaseNumber;
        public String JudgementDate;
        public String JudgementAmount;
        public String TypeOfCourt;
        public String Plaintiff;
        public String Reason;
        public String PublicDataCatCode;
        public String PublicDataCatCodeDesc;
    }

    public class NoticesNotice{
        public Notice[] Notice;
    }
    public class Notice{
        public String CourtName;
        public String CourtID;
        public String CaseNumber;
        public String NoticeDate;
        public String NoticeAmount;
        public String TypeOfCourt;
        public String Plaintiff;
        public String Reason;
        public String PublicDataCatCode;
        public String PublicDataCatCodeDesc;
    }

    public class Defaults{
        public CPA_Other CPA;
        public Summary Summary;
        public Telephones Telephones;
        public Employers Employers;
        public Addresses Addresses;
    }
    public class CPA_Other{
        public Other[] Other;
    }

    public class All {
        public String Total_Number_of_All_Enquiries_Ever;
        public String Number_of_All_Enquiries_in_the_Last_7_days;
        public String Number_of_All_Enquiries_in_the_Last_30_days;
        public String Number_of_All_Enquiries_in_the_Last_90_days;
        public String Number_of_All_Enquiries_in_the_Last_180_days;
        public String Number_of_All_Enquiries_in_the_Last_year;
    }

      public class Address {
          public String Relation;
          public String ReportDate;
          public String Address_Line1;
          public String Address_Line2;
          public String CityArea;
          public String City;
          public String ZipCode;
      }

      public class PaymentCycle {
          public List<Payment> Payment;
      }

      public class Detect {
          public String Flag;
          public String Fraud_Alert_Code;
          //public Object Detail;
          public IDverification IDverification;
          public String DisputeIndicator;
          //public Object DebtRestructure;
      }

      public class NLR_Past_12_Months {
          public String Positive_loans;
      }

      public class Addresses {
          public List<Address> Address;
      }

      public class Enquiry {
          public CPA CPA;
      }

      public class CPA_Past_24_Months {
          public String Positive_loans;
          public String Highest_months_in_arrears;
      }

      public class CPA_X {
          public Own_Z Own;
          public Other_Z Other;
          public All All;
      }

      public class CPA_W {
          public Own_Y Own;
          public Other_Y Other;
          public All_Z All;
          public High_Risk_Accounts High_Risk_Accounts;
      }

      public class CPA_Z {
          public List<Other> Other;
      }

      public class CPA_Y {
          @AuraEnabled public String Total_Number_of_Adverses_Ever;
          public String Number_of_Adverses_in_the_Last_30_days;
          public String Number_of_Adverses_in_the_Last_90_days;
          public String Number_of_Adverses_in_the_Last_180_days;
          public String Number_of_Adverses_in_the_Last_year;
          public String Number_of_Adverses_in_the_Last_2_years;
          public String Number_of_Adverses_in_the_Last_3_years;
          public String Number_of_Adverses_in_the_Last_4_years;
          public String Number_of_Adverses_in_the_Last_5_years;
          public String Total_Value_of_all_Adverses;
          public String Highest_Adverse_Value;
          public String Value_of_Most_Recent_Adverse;
          public String Number_of_Adverses_in_the_Previous_6_Months;
          public String Number_of_Adverses_in_the_Last_19_to_36_Months;
          public String Number_of_CPA_adverses_ever;
          public String Total_value_of_all_CPA_adverses;
      }

      public class Collections {
          public String Total_Number_of_Collections_Ever;
          public String Number_of_Collections_in_the_Last_30_days;
          public String Number_of_Collections_in_the_Last_90_days;
          public String Number_of_Collections_in_the_Last_180_days;
          public String Number_of_Collections_in_the_Last_year;
          public String Number_of_Collections_in_the_Last_2_years;
          public String Number_of_Collections_in_the_Last_3_years;
          public String Number_of_Collections_in_the_Last_4_years;
          public String Number_of_Collections_in_the_Last_5_years;
          public String Total_Collection_Capital_Value;
          public String Total_Collections_Amount_Collected_Ever;
          public String Total_amount_Collected_on_Collections_opened_in_the_Last_3_Months;
          public String Total_amount_Collected_on_Collections_opened_in_the_Last_6_Months;
          public String Total_amount_Collected_on_Collections_opened_in_the_Last_12_Months;
          public String Number_of_Payments_in_the_Last_3_Months;
          public String Number_of_Payments_in_the_Last_6_Months;
          public String Number_of_Payments_in_the_Last_12_Months;
          public String Highest_Collection_Value;
          public String Value_of_Most_Recent_Collection;
      }

      public class Judgements {
          @AuraEnabled public String Total_Number_of_Judgments_Ever;
          public String Number_of_Judgments_in_the_Last_30_days;
          public String Number_of_Judgments_in_the_Last_90_days;
          public String Number_of_Judgments_in_the_Last_180_days;
          public String Number_of_Judgments_in_the_Last_year;
          public String Number_of_Judgments_in_the_Last_2_years;
          public String Number_of_Judgments_in_the_Last_3_years;
          public String Number_of_Judgments_in_the_Last_4_years;
          public String Number_of_Judgments_in_the_Last_5_years;
          public String Total_Judgment_Value;
          public String Highest_Judgment_Value;
          public String Value_of_Most_Recent_Judgment;
          public String Months_Since_Most_Recent_Judgment;
          public String Months_Since_Highest_Judgment;
          public String Total_Number_of_Medical_Judgments;
          public String Total_Value_of_Medical_Judgments;
          public String Total_Number_of_Other_Judgments;
          public String Total_Value_of_Other_Judgments;
          public String Number_of_Judgments_in_the_Previous_6_Months;
          public String Number_of_Judgments_in_the_Last_7_to_18_Months;
          public String Number_of_Judgments_in_the_Last_19_to_36_Months;
          public String Number_of_Judgments_Older_than_37_Months;
      }

      public class IDverification {
          public String IDverified;
          public String SurnameVerified;
          public String InitialsVerified;
          public String ExperianIDnumber;
          public String ExperianSurname;
          public String ExperianInitials;
      }

      public class ScoreBlock {
          public List<Delphi> Delphi;
      }

      public class Employer {
          public String Name;
          public String Occupation;
          public String Employer_Address;
          public String Date_Supplied;
          public String Income_Frequency;
      }

      public class Other_Z {
          public String Total_Number_of_Other_Enquiries_Ever;
          public String Number_of_Other_Enquiries_in_the_Last_7_days;
          public String Number_of_Other_Enquiries_in_the_Last_30_days;
          public String Number_of_Other_Enquiries_in_the_Last_90_days;
          public String Number_of_Other_Enquiries_in_the_Last_180_days;
          public String Number_of_Other_Enquiries_in_the_Last_year;
      }

      public class Other_Y {
          public String Number_of_Other_PPs_Ever;
          public String Number_of_Other_Revolving_PPs_Ever;
          public String Number_of_Other_Fixed_Installment_PPs_Ever;
          public String Total_number_of_other_Delinquent_Accounts;
          public String Total_number_of_other_Active_accounts;
          public String Number_of_other_accounts_opened_4to12_months_ago;
          public String Number_of_other_accounts_opened_for_at_least_12_months;
          //public String Total_number_of__active_non_delinquent_CPA_accounts_opened_L6m;
          public String Number_of_Other_PPs_in_the_Last_30_Days;
          public String Number_of_Other_PPs_in_the_Last_90_Days;
          public String Number_of_Other_PPs_in_the_Last_180_Days;
          public String Number_of_Other_PPs_in_the_Last_Year;
          public String Number_of_Other_PPs_in_the_Last_2_Years;
          public String Number_of_Other_PPs_in_the_Last_3_Years;
          public String Number_of_Other_PPs_in_the_Last_4_Years;
          public String Number_of_Other_PPs_in_the_Last_5_Years;
          public String Number_of_Currently_Open_Other_PPs;
          public String Months_Since_Most_Recent_opened_Other_PP;
          public String Months_Since_Oldest_Opened_Other_PPs;
          public String Capital_Amount_of_Other_PPs_Opened_in_the_Last_30_Days;
          public String Capital_Amount_of_Other_PPs_Opened_in_the_Last_90_Days;
          public String Capital_Amount_of_Other_PPs_Opened_in_Last_180_Days;
          public String Capital_Amount_of_Other_PPs_Opened_in_the_Last_Year;
          public String Capital_Amount_of_Other_PPs_Opened_in_the_Last_2_Years;
          public String Number_of_Closed_Other_PPs;
          public String Number_of_Open_Revolving_Other_PPs;
          public String Number_of_Closed_Revolving_Other_PPs;
          public String Number_of_Open_Fixed_Installment_Other_PPs;
          public String Number_of_Closed_Fixed_Installment_Other_PPs;
          public String Worst_Arrears_on_Other_PPs_ever;
          public String Worst_Arrears_on_Closed_Other_PPs;
          public String Worst_Arrears_on_Open_Other_PPs;
          public String Worst_Arrears_Level_of_Most_Recent_Other_Opened_PP;
          public String Number_of_Times_0_Arrears_of_Last_3_Other_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_3_Other_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_3_Other_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_3_Other_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_6_Other_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_6_Other_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_6_Other_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_6_Other_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_12_Other_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_12_Other_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_12_Other_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_12_Other_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_24_Other_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_24_Other_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_24_Other_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_24_Other_Available_Histories;
          public String Percent_0_Arrears_of_Last_3_Other_Available_Histories;
          public String Percent_1_Arrears_of_Last_3_Other_Available_Histories;
          public String Percent_2_Arrears_of_Last_3_Other_Available_Histories;
          public String Percent_3_Arrears_of_Last_3_Other_Available_Histories;
          public String Percent_0_Arrears_of_Last_6_Other_Available_Histories;
          public String Percent_1_Arrears_of_Last_6_Other_Available_Histories;
          public String Percent_2_Arrears_of_Last_6_Other_Available_Histories;
          public String Percent_3_Arrears_of_Last_6_Other_Available_Histories;
          public String Percent_0_Arrears_of_Last_12_Other_Available_Histories;
          public String Percent_1_Arrears_of_Last_12_Other_Available_Histories;
          public String Percent_2_Arrears_of_Last_12_Other_Available_Histories;
          public String Percent_3_Arrears_of_Last_12_Other_Available_Histories;
          public String Percent_0_Arrears_of_Last_24_Other_Available_Histories;
          public String Percent_1_Arrears_of_Last_24_Other_Available_Histories;
          public String Percent_2_Arrears_of_Last_24_Other_Available_Histories;
          public String Percent_3_Arrears_of_Last_24_Other_Available_Histories;
          public String Number_of_Written_Off_Other_PPs;
          public String Number_of_Absconded_Other_PPs;
          public String Number_of_Habitually_Slow_Other_PPs;
          public String Number_of_Disputed_Other_PPs;
      }

      public class Payment {
          public String StatusDate;
          public String Months;
          public AccountType Status;
          public String OpenBalance;
          public String CurrentBalance;
          public String OverdueAmount;
          public String Installment;
      }

      public class Payment_Profiles {
          public CPA_W CPA;
      }

      public class Telephone {
          public String PhonePrefix;
          public String PhoneNumber;
          public String LastReportedDate;
          public String PhoneType;
      }

      public class NLR_Past_24_Months {
          public String Positive_loans;
          public String Highest_months_in_arrears;
      }

      public class Own_Z {
          public String Total_Number_of_Own_Enquiries_Ever;
          public String Number_of_Own_Enquiries_in_the_Last_7_days;
          public String Number_of_Own_Enquiries_in_the_Last_28_days;
          public String Number_of_Own_Enquiries_in_the_Last_30_days;
          public String Number_of_Own_Enquiries_in_the_Last_90_days;
          public String Number_of_Own_Enquiries_in_the_Last_180_days;
          public String Number_of_Own_Enquiries_in_the_Last_year;
          public String Number_of_Own_Enquiries_in_the_Last_2_years;
          public String Number_of_Own_Enquiries_in_the_Last_3_years;
          public String Number_of_Own_Enquiries_in_the_Last_4_years;
          public String Number_of_Own_Enquiries_in_the_Last_5_years;
          public String Months_Since_Recent_Own_Enquiry;
          public String Months_Since_Oldest_Own_Enquiry;
          public String Days_Since_Recent_Own_Enquiry;
      }

      public class Own_Y {
          public String Number_of_Own_PPs_Ever;
          public String Number_of_Own_Revolving_PPs_Ever;
          public String Number_of_Own_Installment_PPs_Ever;
          public String Total_number_of_Own_Delinquent_Accounts;
          public String Total_no_of_Own_Active_accounts;
          public String Number_of_Own_accounts_opened_4to12_months_ago;
          public String Number_of_own_accounts_opened_for_at_least_12_months;
          //public String Total_number_of__active_non_delinquent_CPA_accounts_opened_L6m;
          public String Number_of_Own_PPs_in_the_Last_30_Days;
          public String Number_of_Own_PPs_in_the_Last_90_Days;
          public String Number_of_Own_PPs_in_the_Last_180_Days;
          public String Number_of_Own_PPs_in_the_Last_Year;
          public String Number_of_Own_PPs_in_the_Last_2_Years;
          public String Number_of_Own_PPs_in_the_Last_3_Years;
          public String Number_of_Own_PPs_in_the_Last_4_Years;
          public String Number_of_Own_PPs_in_the_Last_5_Years;
          public String Number_of_Currently_Open_Own_PPs;
          public String Months_Since_Most_Recent_Opened_Own_PP;
          public String Capital_Amount_of_Own_PPs_Opened_in_the_Last_30_Days;
          public String Capital_Amount_of_Own_PPs_Opened_in_the_Last_90_Days;
          public String Capital_Amount_of_Own_PPs_Opened_in_the_Last_180_Days;
          public String Capital_Amount_of_Own_PPs_Opened_in_the_Last_Year;
          public String Capital_Amount_of_Own_PPs_Opened_in_the_Last_2_Years;
          public String Monthly_Installment_Value_of_Currently_Open_Own_PPs;
          public String Monthly_CPA_Installment_Own;
          public String Outstanding_CPA_Balance_Own;
          public String Total_value_of_Own_Delinquent_accounts;
          public String Total_outstanding_balance_on_Own_active_accounts;
          public String Outstanding_Balance_on_non_delinquent_revolving_CPA_opened_L6m;
          public String Outstanding_Balance_on_delinquent_revolving_CPA_accounts;
          public String Number_of_Closed_Own_PPs;
          public String Number_of_Open_Revolving_Own_PPs;
          public String Number_of_Closed_Revolving_Own_PPs;
          public String Number_of_Open_Fixed_Installment_Own_PPs;
          public String Number_of_Closed_Fixed_Installment_Own_PPs;
          public String Number_of_Times_0_Arrears_of_Last_3_Own_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_3_Own_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_3_Own_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_3_Own_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_6_Own_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_6_Own_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_6_Own_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_6_Own_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_12_Own_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_12_Own_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_12_Own_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_12_Own_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_24_Own_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_24_Own_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_24_Own_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_24_Own_Available_Histories;
          public String Percentage_0_Arrears_of_Last_3_Own_Available_Histories;
          public String Percentage_1_Arrears_of_Last_3_Own_Available_Histories;
          public String Percentage_2_Arrears_of_Last_3_Own_Available_Histories;
          public String Percentage_3_Arrears_of_Last_3_Own_Available_Histories;
          public String Percentage_0_Arrears_of_Last_6_Own_Available_Histories;
          public String Percentage_1_Arrears_of_Last_6_Own_Available_Histories;
          public String Percentage_2_Arrears_of_Last_6_Own_Available_Histories;
          public String Percentage_3_Arrears_of_Last_6_Own_Available_Histories;
          public String Percentage_0_Arrears_of_Last_12_Own_Available_Histories;
          public String Percentage_1_Arrears_of_Last_12_Own_Available_Histories;
          public String Percentage_2_Arrears_of_Last_12_Own_Available_Histories;
          public String Percentage_3_Arrears_of_Last_12_Own_Available_Histories;
          public String Percentage_0_Arrears_of_Last_24_Own_Available_Histories;
          public String Percentage_1_Arrears_of_Last_24_Own_Available_Histories;
          public String Percentage_2_Arrears_of_Last_24_Own_Available_Histories;
          public String Percentage_3_Arrears_of_Last_24_Own_Available_Histories;
          public String Number_of_Written_Off_Own_PPs;
          public String Number_of_Absconded_Own_PPs;
          public String Number_of_Habitually_Slow_Own_PPs;
          public String Number_of_Disputed_Own_PPs;
          public String Current_Balance_of_Own_PPs;
          public String Total_Credit_Limit_of_Revolving_Own_PPs;
          public String Total_Balance_of_Revolving_Own_PPs;
          public String Total_Installment_of_Revolving_Own_PPs;
          public String Total_Credit_Limit_of_Fixed_Installment_Own_PPS;
          public String Total_Balance_of_Fixed_Installment_Own_PPs;
          public String Total_Installment_of_Fixed_Installment_Own_PPs;
          public String Total_Credit_Limit_of_Own_Open_Account_PPs;
          public String Total_Balance_of_Own_Open_Account_PPs;
          public String Total_Installment_of_Own_Open_Account_PPs;
      }

      public class Negatives {
          public String Total_Number_of_Negatives_Ever;
          public String Number_of_Negatives_in_the_Last_30_days;
          public String Number_of_Negatives_in_the_Last_90_days;
          public String Number_of_Negatives_in_the_Last_180_days;
          public String Number_of_Negatives_in_the_Last_year;
          public String Number_of_Negatives_in_the_Last_2_years;
          public String Number_of_Negatives_in_the_Last_3_years;
          public String Number_of_Negatives_in_the_Last_4_years;
          public String Number_of_Negatives_in_the_Last_5_years;
          public String Highest_Negative_Value;
          public String Months_Since_Highest_Negative;
          public String Value_of_Most_Recent_Negative;
      }

      public class Employers {
          public List<Employer> Employer;
      }

      public class Notices {
          public String Total_Number_of_Notices_Ever;
          public String Number_of_Notices_in_the_Last_30_days;
          public String Number_of_Notices_in_the_Last_90_days;
          public String Number_of_Notices_in_the_Last_180_days;
          public String Number_of_Notices_in_the_Last_year;
          public String Number_of_Notices_in_the_Last_2_years;
          public String Number_of_Notices_in_the_Last_3_years;
          public String Number_of_Notices_in_the_Last_4_years;
          public String Number_of_Notices_in_the_Last_5_years;
          public String Number_of_Notices_in_the_Previous_6_Months;
          public String Number_of_Notices_in_the_Last_7_to_18_Months;
          public String Number_of_Notices_in_the_Last_19_to_36_Months;
          public String Number_of_Notices_Older_than_37_Months;
      }

      public class All_Z {
          public String Number_of_All_PPs_Ever;
          public String Number_of_All_Revolving_PPs_Ever;
          public String Number_of_All_Fixed_Installment_PPs_Ever;
          public String Total_number_of_all_Delinquent_Accounts;
          public String Total_number_of_all_Active_accounts_Z; // in json: Total_number_of_all_Active_accounts_
          public String Number_of_all_accounts_opened_4to12_months_ago;
          public String Number_of_all_accounts_opened_for_at_least_12_months;
          //public String Total_number_of__active_non_delinquent_CPA_accounts_opened_L6m;
          public String Number_of_All_PPs_in_the_Last_30_Days;
          public String Number_of_All_PPs_in_the_Last_90_Days;
          public String Number_of_All_PPs_in_the_Last_180_Days;
          public String Number_of_All_PPs_in_the_Last_Year;
          public String Number_of_All_PPs_in_the_Last_2_Years;
          public String Number_of_All_PPs_in_the_Last_3_Years;
          public String Number_of_All_PPs_in_the_Last_4_Years;
          public String Number_of_All_PPs_in_the_Last_5_Years;
          public String Number_of_Currently_Open_All_PPs;
          public String Months_Since_Most_Recent_Opened_PP;
          public String Months_Since_Oldest_Opened_PPs_ever_all;
          public String Capital_Amount_of_All_PPs_Opened_in_the_Last_30_Days;
          public String Capital_Amount_of_All_PPs_Opened_in_the_Last_90_Days;
          public String Capital_Amount_of_All_PPs_Opened_in_the_Last_180_Days;
          public String Capital_Amount_of_All_PPs_Opened_in_the_Last_Year;
          public String Capital_Amount_of_All_PPs_Opened_in_the_Last_2_Years;
          public String Cumulative_Installment_Value;
          public String Cumulative_Outstanding_Balance;
          public String Monthly_Installment_Value_of_Currently_Open_All_PPs;
          public String Total_Monthly_CPA_Installment_All;
          public String Total_Outstanding_CPA_Balance_All;
          public String Total_outstanding_CPA_balance_excluding_home_loans;
          public String Total_outstanding_CPA_balance_on_active_CPA_accounts_excluding_home_loans;
          public String Total_outstanding_CPA_balance_on_CPA_home_loan_accounts;
          public String Total_outstanding_CPA_balance_on_CPA_nondelinquent_home_loan_accounts_opened_in_the_last_12_months;
          public String Total_value_of_All_Delinquent_accounts;
          public String Total_outstanding_balance_on_All_active_accounts;
          public String Outstanding_Balance_on_non_delinquent_revolving_CPA_opened_L6m;
          public String Outstanding_Balance_on_delinquent_revolving_CPA_accounts;
          public String Total_outstanding_CPA_balance_on_accounts_opened_4to12_months_ago_excluding_home_loans;
          public String Total_outstanding_CPA_balance_on_accounts_opened_for_at_least_12_months_excluding_home_loans;
          public String Number_of_Closed_All_PPs;
          public String Number_of_Open_Revolving_All_PPs;
          public String Number_of_Closed_Revolving_All_PPs;
          public String Number_of_Open_Fixed_Installment_All_PPs;
          public String Number_of_Closed_Fixed_Installment_All_PPs;
          public String Worst_Arrears_on_Any_All_PPs_ever;
          public String Worst_Arrears_on_Closed_All_PPs;
          public String Worst_Arrears_on_Open_All_PPs;
          public String Number_of_Times_0_Arrears_of_Last_3_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_3_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_3_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_3_All_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_24_All_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_24_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_24_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_24_All_Available_Histories;
          public String Number_of_Written_Off_All_PPs;
          public String Number_of_Absconded_All_PPs;
          public String Number_of_Habitually_Slow_All_PPs;
          public String Number_of_Disputed_All_PPs;
          public String Current_Balance_of_All_PPs;
          public String Total_Credit_Limit_of_Revolving_All_PPs;
          public String Total_Balance_of_Revolving_All_PPs;
          public String Total_Installment_of_Revolving_All_PPs;
          public String Total_Credit_Limit_of_Fixed_Installment_All_PPS;
          public String Total_Balance_of_Fixed_Installment_All_PPs;
          public String Total_Installment_of_Fixed_Installment_All_PPs;
          public String Total_Credit_Limit_of_All_Open_Account_PPs;
          public String Total_Balance_of_All_Open_Account_PPs;
          public String Total_Installment_of_All_Open_Account_PPs;
          public String Total_Monthly_One_Month_Installment_Z; // in json: Total_Monthly_One_Month_Installment_
      }

      public class InputData {
          public String First_Name_1;
          public String Surname;
          public String National_ID;
          public String RSA_ID;
          public String Birthday;
      }

      public class Adverses {
          public CPA_Y CPA;
      }

      public class All_Negatives {
          public String All_Total_Number_of_Negatives_Ever;
          public String All_Number_of_Negatives_in_the_Last_30_days;
          public String All_Number_of_Negatives_in_the_Last_90_days;
          public String All_Number_of_Negatives_in_the_Last_180_days;
          public String All_Number_of_Negatives_in_the_Last_year;
          public String All_Number_of_Negatives_in_the_Last_2_years;
          public String All_Number_of_Negatives_in_the_Last_3_years;
          public String All_Number_of_Negatives_in_the_Last_4_years;
          public String All_Number_of_Negatives_in_the_Last_5_years;
          public String All_Highest_Negative_Value;
          public String All_Months_Since_Highest_Negative;
          public String All_Value_of_Most_Recent_Negative;
      }

      public class ReturnData {
          public String Match;
          public String Name;
          public String Title;
          public String Surname;
          public String FirstName1;
          public String ID;
          public String Birthday;
          public Address Address;
          public String ReferenceNo;
          public String Date_Z; // in json: Date
          public String Time_Z; // in json: Time
          public String ExecTime;
          public String SessionID;
      }

      public class Own {
          public String EnquiryDate;
          public String SubscriberName;
          public String Subscriber_Operator;
          public String SubscriberTel;
      }

      public class High_Risk_Accounts {
          public String Number_of_All_PPs_Ever;
          public String Number_of_Revolving_Unsecured_Credit_Transactions_under_R8_000_ever;
          public String Number_of_Unsecured_Credit_Transactions_under_R8_000_ever;
          public String Total_number_of_all_Delinquent_Accounts;
          public String Total_number_of_all_Active_accounts_Z; // in json: Total_number_of_all_Active_accounts_
          public String Number_of_all_accounts_opened_4to12_months_ago;
          public String Number_of_all_accounts_opened_for_at_least_12_months;
          //public String Total_number_of__active_non_delinquent_CPA_accounts_opened_L6m;
          public String Number_of_All_PPs_in_the_Last_30_Days;
          public String Number_of_All_PPs_in_the_Last_90_Days;
          public String Number_of_All_PPs_in_the_Last_180_Days;
          public String Number_of_All_PPs_in_the_Last_Year;
          public String Number_of_All_PPs_in_the_Last_2_Years;
          public String Number_of_All_PPs_in_the_Last_3_Years;
          public String Number_of_All_PPs_in_the_Last_4_Years;
          public String Number_of_All_PPs_in_the_Last_5_Years;
          public String Number_of_Currently_Open_All_PPs;
          public String Months_Since_Most_Recent_Opened_PP;
          public String Months_Since_Oldest_Opened_PPs_ever_all;
          public String Cumulative_Installment_Value;
          public String Cumulative_Outstanding_Balance;
          public String Total_Monthly_CPA_Installment_All;
          public String Total_Outstanding_CPA_Balance_All;
          public String Total_value_of_All_Delinquent_accounts;
          public String Total_outstanding_balance_on_All_active_accounts;
          public String Outstanding_Balance_on_non_delinquent_revolving_CPA_opened_L6m;
          public String Outstanding_Balance_on_delinquent_revolving_CPA_accounts;
          public String Number_of_Closed_All_PPs;
          public String Worst_Arrears_on_Any_All_PPs_ever;
          public String Worst_Arrears_on_Closed_All_PPs;
          public String Worst_Arrears_on_Open_All_PPs;
          public String Number_of_Times_0_Arrears_of_Last_3_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_3_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_3_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_3_All_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_6_All_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_12_All_Available_Histories;
          public String Number_of_Times_0_Arrears_of_Last_24_All_Available_Histories;
          public String Number_of_Times_1_Arrears_of_Last_24_All_Available_Histories;
          public String Number_of_Times_2_Arrears_of_Last_24_All_Available_Histories;
          public String Number_of_Times_3_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_3_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_6_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_12_All_Available_Histories;
          public String Percent_0_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_1_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_2_Arrears_of_Last_24_All_Available_Histories;
          public String Percent_3_Arrears_of_Last_24_All_Available_Histories;
      }

      public class Delphi {
          public String Score;
          public String Scorecard_Identifier;
          public String ReasonCode;
          public String ScoreName;
          public String RequestID;
      }

      public class AccountType {
          public String Z_code_Z; // in json: _code
          public String Z_text_Z; // in json: __text
      }

      public class Trace {
          public String Total_Number_of_Traces_Ever;
          public String Number_of_Traces_in_the_Last_30_days;
          public String Number_of_Traces_in_the_Last_60_days;
          public String Number_of_Traces_in_the_Last_90_days;
          public String Number_of_Traces_in_the_Last_180_days;
          public String Number_of_Traces_in_the_Last_year;
          public String Number_of_Traces_in_the_Last_2_years;
          public String Number_of_Traces_in_the_Last_3_years;
          public String Number_of_Traces_in_the_Last_4_years;
          public String Number_of_Traces_in_the_Last_5_years;
      }

      public class CPA {
          public List<Own> Own;
      }

      public class Telephones {
          public List<Telephone> Telephone;
      }

      public class Enquiries {
          public CPA_X CPA;
      }

      public class Summary {
          public String NLR_CumulativeArrears;
          public String TotalCreditLimitOpenCreditCardAccounts;
          public NLR_Past_12_Months NLR_Past_12_Months;
          public NLR_Past_24_Months NLR_Past_24_Months;
          public NLR_Past_24_Months NLR_Past_36_Months;
          public String CPA_CumulativeArrears;
          public NLR_Past_12_Months CPA_Past_12_Months;
          public CPA_Past_24_Months CPA_Past_24_Months;
          public CPA_Past_24_Months CPA_Past_36_Months;
          public Judgements Judgements;
          public Adverses Adverses;
          public Trace Trace;
          public Notices Notices;
          public Collections Collections;
          public Negatives Negatives;
          public All_Negatives All_Negatives;
          public Enquiries Enquiries;
          public Payment_Profiles Payment_Profiles;
      }

      public class SubscriberInfo {
          public String Name;
          public String BusinessType;
          public String LegalName;
          public String Phone;
          public String ParentSubscriber;
          public String SAFPSMemberRegNbr;
          public String LastUpdateDate;
      }

      public class Accounts {
          public CPA_Z CPA;
      }

      public class Session {
          public String User_ID;
          public String FullName;
          public String GroupName;
          public String Subscriber_ID;
          public String Group_ID;
          public String RequestType;
          public String Environment;
          public String Version;
      }

      public class Other {
          public String Subscriber;
          public String Subscriber_Code;
          public String AccountNo;
          public AccountType AccountType;
          public String OpenDate;
          public String OpenBalance;
          public String CreditLimit;
          public String CurrentBalance;
          public String BalanceDate;
          public String LastPayment;
          public String LastPaymentDate;
          public AccountType Status;
          public String StatusDate;
          public String Industry_Code;
          public String Installment;
          public String PaymentStatus;
          public String OverdueAmount;
          public String Ownership_Type_Code;
          public String Ownership_Type_Description;
          public String Payment_Type_Code;
          public String Payment_Type_Description;
          public String Deferred_Payment_Date;
          public String Repayment_Frequency_Code;
          public String Repayment_Frequency_Desc;
          public String Account_Sold_Third_Party_Indicator;
          public String Third_Party_Name;
          public String No_of_Participants_Joint_Loan;
          public String EndUseCode;
          public String RepaymentPeriod;
          public String Worst_Payment_History;
          public String History_of_most_recent_12_months;
          public String History_of_most_recent_24_months;
          public PaymentCycle PaymentCycle;
      }

      public override void setFieldNameSubstitutions() {
          fieldNameSubstitutionMap = new Map<String, String>();
          fieldNameSubstitutionMap.put('"_code":', '"Z_code_Z":');
          fieldNameSubstitutionMap.put('"__text":', '"Z_text_Z":');
          fieldNameSubstitutionMap.put('"Date":', '"Date_Z":');
          fieldNameSubstitutionMap.put('"Time":', '"Time_Z":');
          fieldNameSubstitutionMap.put('"Total_Monthly_One_Month_Installment_":', '"Total_Monthly_One_Month_Installment_Z":');
          fieldNameSubstitutionMap.put('"Total_number_of_all_Active_accounts_":', '"Total_number_of_all_Active_accounts_Z":');
      }
  }