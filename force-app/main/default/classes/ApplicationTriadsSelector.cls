/**
 * Apex Enterprise Design Patterns
 * Selector Layer for Application_Triad__c objects
 *
 * @author  Almas Aleem :Absa
 * @since   2020-09-15
 */
public class ApplicationTriadsSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Application_Triad__c.sObjectType;
    }

    public override String getOrderBy(){
        return 'Client_Name__c,Client_Code__c';
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Triad__c.Id,
            Application_Triad__c.Client_Name__c,
            Application_Triad__c.Client_Code__c,
            Application_Triad__c.LastModifiedDate
        };
    }

    //MANDATORY ABSTRACT METHODS - END
    ////Custom Selectors
	/**
     * Method to retrieve an Application_Triad__c based on its application Id
     *
     * @param applicationId The Id of the Application__c record
     * @return List of Application_Triad__c The application record
    **/
    public List<Application_Triad__c> getTriadsByApplicationID(Id applicationId) {
      return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Additional_Overdraft_Limit__c').
            selectField('Additional_Monthly_Loan_Repayment__c').
            selectField('Additional_Monthly_Repayment__c').
            selectField('Additional_Credit_Card_Limit__c').
            selectField('Additional_Asset_Finance_Repayment__c').
            selectField('Additional_Credit_Card_Limit__c').
            selectField('Additional_Monthly_Loan_Repayment__c').
            selectField('Additional_Monthly_Mortgage_Repayment__c').
            selectField('Additional_Monthly_Repayment__c').
            selectField('Additional_Overdraft_Limit__c').
            selectField('Application__c').
            selectField('AVAF_Score__c').
            selectField('Average_Credit_TurnOver_Last_3_6_Mth__c').
            selectField('Average_Credit_TurnOver_Last_6_12_Mth__c').
            selectField('Cheque_Score__c').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
            selectField('Credit_Card_Score__c').
            selectField('Credit_Facility_Exclusion__c').
            selectField('Credit_Facility_Exclusion_Code__c').
            selectField('Credit_Facility_Exclusion_Description__c').
            selectField('Customer_Alignment_Score__c').
            selectField('Date_First_Relationship__c').
            selectField('Date_Oldest_Account_Opened__c').
            selectField('Date_Oldest_Cheque_Account_Opened__c').
            selectField('Date_Oldest_Savings_Account_Opened__c').
            selectField('Days_in_Credit_last_6_mth__c').
            selectField('Days_in_Debit_last_6_mth__c').
            selectField('ECTO_Cheque_Monthly_Avg_Last_12_Mth__c').
            selectField('ECTO_Monthly_Avg_Last_12_Mth__c').
            selectField('ECTO_Total_For_Period__c').
            selectField('Is_Main_Applicant__c').
            selectField('LastModifiedDate').
            selectField('Loan_Score__c').
            selectField('Maximum_Consecutive_Days_in_Excess__c').
            selectField('Maximum_Ordinary_Credit_Exposure_Capped__c').
            selectField('Months_in_Excess_last_6_mth__c').
            selectField('Months_Since_Oldest_Account__c').
            selectField('Months_Since_Oldest_Cheque_Account__c').
            selectField('Months_Since_Oldest_Relationship__c').
            selectField('Months_Since_Oldest_Savings_Account__c').
            selectField('Mortgage_Score__c').
            selectField('Number_of_Debits_Cheques_value__c').
            selectField('Returned_Items_Value_Cheques_value__c').
            selectField('Returned_Items_Value_Savings_value__c').
            selectField('Total_Cheque_RD_last_3_mth__c').
            selectField('Total_Cheque_RD_last_6_mth__c').
            selectField('Total_Credit_Last_6_Mth__c').
            selectField('Total_Debit_Last_6_Mth__c').
            selectField('Total_Savings_RD_last_3_mth__c').
            selectField('Total_Savings_RD_last_6_mth__c').
            selectField('Triad_Exclusion_Reason__c').
            selectField('Triad_Exclusion_Reason_Description__c').
            selectField('Triad_Exclusion_Type__c').
            selectField('Triad_Type__c').
          	selectField('Is_Main_Applicant__c').
            selectField('Application__c').
            selectField('LastModifiedDate').
            selectField('Value_Cheque_RD_Last_6_Mth__c').
            selectField('Value_Savings_RD_Last_6_Mth__c').
            setCondition('Application__c =:applicationId').
            toSOQL()
        );
    }

    /**
     * Select Application_Triad__c by Opportunity Id
     * @param idSet - Set of opportunity Ids
     * @return list of Application_Triad__c records
     */
    public List<Application_Triad__c> selectByOpportunityId(Set<Id> idSet){
        return Database.query(
            newQueryFactory().selectField('Id')
            .selectField('Months_Since_Oldest_Relationship__c')
            .selectField('Months_Since_Oldest_Account__c')
            .selectField('Months_Since_Oldest_Cheque_Account__c')
            .selectField('Months_Since_Oldest_Savings_Account__c')
            .selectField('Date_First_Relationship__c')
            .selectField('Date_Oldest_Account_Opened__c')
            .selectField('Date_Oldest_Cheque_Account_Opened__c')
            .selectField('Date_Oldest_Savings_Account_Opened__c')
            .selectField('ECTO_Monthly_Avg_Last_12_Mth__c')
            .selectField('ECTO_Total_For_Period__c')
            .selectField('Total_Credit_Last_6_Mth__c')
            .selectField('Total_Debit_Last_6_Mth__c')
            .selectField('ECTO_Cheque_Monthly_Avg_Last_12_Mth__c')
            .selectField('Average_Credit_TurnOver_Last_3_6_Mth__c')
            .selectField('Average_Credit_TurnOver_Last_6_12_Mth__c')
            .selectField('Value_Cheque_RD_Last_6_Mth__c')
            .selectField('Value_Savings_RD_Last_6_Mth__c')
            .selectField('Customer_Alignment_Score__c')
            .selectField('Cheque_Score__c')
            .selectField('Credit_Card_Score__c')
            .selectField('Mortgage_Score__c')
            .selectField('AVAF_Score__c')
            .selectField('Loan_Score__c')
            .setCondition('Application__r.Opportunity__c IN: idSet')
            .toSOQL()
        );
    }

    /**
     * Select Application_Triad__c by Application Id
     * @param idSet - Set of Application Ids
     * @param condition - String of conditions (start condition with and)
     * @return list of Application_Triad__c records
     */
    public List<Application_Triad__c> selectByApplicationIdWithCondition(Set<Id> idSet, String condition){
        return Database.query(
            newQueryFactory().selectField('Id')
            .selectField('Months_Since_Oldest_Relationship__c')
            .selectField('Months_Since_Oldest_Account__c')
            .selectField('Months_Since_Oldest_Cheque_Account__c')
            .selectField('Months_Since_Oldest_Savings_Account__c')
            .selectField('Date_First_Relationship__c')
            .selectField('Date_Oldest_Account_Opened__c')
            .selectField('Date_Oldest_Cheque_Account_Opened__c')
            .selectField('Date_Oldest_Savings_Account_Opened__c')
            .selectField('ECTO_Monthly_Avg_Last_12_Mth__c')
            .selectField('ECTO_Total_For_Period__c')
            .selectField('Total_Credit_Last_6_Mth__c')
            .selectField('Total_Debit_Last_6_Mth__c')
            .selectField('ECTO_Cheque_Monthly_Avg_Last_12_Mth__c')
            .selectField('Average_Credit_TurnOver_Last_3_6_Mth__c')
            .selectField('Average_Credit_TurnOver_Last_6_12_Mth__c')
            .selectField('Value_Cheque_RD_Last_6_Mth__c')
            .selectField('Value_Savings_RD_Last_6_Mth__c')
            .selectField('Customer_Alignment_Score__c')
            .selectField('Cheque_Score__c')
            .selectField('Credit_Card_Score__c')
            .selectField('Mortgage_Score__c')
            .selectField('AVAF_Score__c')
            .selectField('Loan_Score__c')
            .setCondition('Application__c IN: idSet ' + condition)
            .toSOQL()
        );
    }

    /**
     * Method to retrieve an Application_Triad__c based on its application Id for main applicant
     *
     * @param applicationId The Id of the Application__c record
     * @return List of Application_Triad__c The application record
    **/
    public Application_Triad__c getTriadsForMainApplicant(Id applicationId) {
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
          	selectField('Is_Main_Applicant__c').
            setCondition('Application__c =:applicationId AND Is_Main_Applicant__c='+true).
          	setLimit(1).
            toSOQL()
        );
	}

    public Application_Triad__c getTriadCredit(String clientCode){
        return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
          	selectField('Expected_Credit_Turnover__c').
            setCondition('Client_Code__c =:clientCode').
          	setLimit(1).
            toSOQL()
        );
    }

    //Added By Himani Joshi
    public List<Application_Triad__c> getTriadsByApplicationAndClientCode(Id applicationId,string clientCode) {
      return Database.query(
            newQueryFactory().selectField('Id').
            selectField('Additional_Overdraft_Limit__c').
            selectField('Additional_Monthly_Loan_Repayment__c').
            selectField('Additional_Monthly_Repayment__c').
            selectField('Additional_Credit_Card_Limit__c').
            selectField('Additional_Asset_Finance_Repayment__c').
            selectField('Additional_Monthly_Mortgage_Repayment__c').
            selectField('Client_Code__c').
            selectField('Client_Name__c').
            selectField('Credit_Facility_Exclusion__c').
            selectField('Credit_Facility_Exclusion_Code__c').
            selectField('Credit_Facility_Exclusion_Description__c').
            selectField('Days_in_Credit_last_6_mth__c').
            selectField('Days_in_Debit_last_6_mth__c').
            selectField('Maximum_Consecutive_Days_in_Excess__c').
            selectField('Maximum_Ordinary_Credit_Exposure_Capped__c').
            selectField('Months_in_Excess_last_6_mth__c').
            selectField('Total_Cheque_RD_last_3_mth__c').
            selectField('Total_Cheque_RD_last_6_mth__c').
            selectField('Total_Savings_RD_last_3_mth__c').
            selectField('Total_Savings_RD_last_6_mth__c').
            selectField('Triad_Exclusion_Reason__c').
            selectField('Triad_Exclusion_Reason_Description__c').
            selectField('Triad_Exclusion_Type__c').
            selectField('Triad_Type__c').
          	selectField('Is_Main_Applicant__c').
            selectField('Application__c').
            selectField('LastModifiedDate').
            selectField('Months_Since_Oldest_Relationship__c').
            selectField('Months_Since_Oldest_Account__c').
            selectField('Months_Since_Oldest_Cheque_Account__c').
            selectField('Months_Since_Oldest_Savings_Account__c').
            selectField('Date_First_Relationship__c').
            selectField('Date_Oldest_Account_Opened__c').
            selectField('Date_Oldest_Cheque_Account_Opened__c').
            selectField('Date_Oldest_Savings_Account_Opened__c').
            selectField('ECTO_Monthly_Avg_Last_12_Mth__c').
            selectField('ECTO_Total_For_Period__c').
            selectField('Total_Credit_Last_6_Mth__c').
            selectField('Total_Debit_Last_6_Mth__c').
            selectField('ECTO_Cheque_Monthly_Avg_Last_12_Mth__c').
            selectField('Average_Credit_TurnOver_Last_3_6_Mth__c').
            selectField('Average_Credit_TurnOver_Last_6_12_Mth__c').
            selectField('Value_Cheque_RD_Last_6_Mth__c').
            selectField('Value_Savings_RD_Last_6_Mth__c').
            selectField('Customer_Alignment_Score__c').
            selectField('Cheque_Score__c').
            selectField('Credit_Card_Score__c').
            selectField('Mortgage_Score__c').
            selectField('AVAF_Score__c').
            selectField('Loan_Score__c').
            selectField('Number_of_Debits_Cheques_value__c').
            selectField('Returned_Items_Value_Savings_value__c').
            selectField('Returned_Items_Value_Cheques_value__c').
            setCondition('Client_Code__c =: clientCode AND Application__c =:applicationId').
            toSOQL()
        );
    }
}