/**
 * @description Controller class for TriadAggregatedValues aura component
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date October 2020
 */
public class TriadAggregatedValuesCTRL {
    /**
     * @description method to get Triad Aggregated Values from service
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-10
     * @param applicationId 
     * @return List<Map<String, Object>> 
    **/
	@AuraEnabled(Cacheable=false)
    public static List<Map<String,Object>> getTriadAggregatedValues(Id applicationId){
        List<Map<String,Object>> triadAggregatedValues = new List<Map<String,Object>>();
    	String condition = ' AND (ECTO_Monthly_Avg_Last_12_Mth__c <> null OR Total_Credit_Last_6_Mth__c <> null OR Total_Debit_Last_6_Mth__c <> null ';
        condition += 'OR ECTO_Cheque_Monthly_Avg_Last_12_Mth__c <> null OR Average_Credit_TurnOver_Last_3_6_Mth__c <> null OR Average_Credit_TurnOver_Last_6_12_Mth__c <> null ';
        condition += 'OR Value_Cheque_RD_Last_6_Mth__c <> null OR Value_Savings_RD_Last_6_Mth__c <> null)';
        
    	List<Application_Triad__c> appTriads = new ApplicationTriadsSelector().selectByApplicationIdWithCondition(new Set<Id>{applicationId}, condition);
        
        for(Application_Triad__c appTriad : appTriads){
            Map<String,String> mapObj = new Map<String,String>();
            mapObj.put('clientName',appTriad.Client_Name__c);
            mapObj.put('clientCode',appTriad.Client_Code__c);
            mapObj.put('ectoMonthlyAvgLast12Mth', appTriad.ECTO_Monthly_Avg_Last_12_Mth__c==null?'0.00': String.valueOf(appTriad.ECTO_Monthly_Avg_Last_12_Mth__c));
            mapObj.put('ectoTotalForPeriod', appTriad.ECTO_Total_For_Period__c==null?'0.00': String.valueOf(appTriad.ECTO_Total_For_Period__c));
            mapObj.put('totalCreditLast6Mth', appTriad.Total_Credit_Last_6_Mth__c==null?'0.00': String.valueOf(appTriad.Total_Credit_Last_6_Mth__c));
            mapObj.put('totalDebitLast6Mth', appTriad.Total_Debit_Last_6_Mth__c==null?'0.00': String.valueOf(appTriad.Total_Debit_Last_6_Mth__c));
            mapObj.put('ectoChqMonthlyAvgLast12Mth', appTriad.ECTO_Cheque_Monthly_Avg_Last_12_Mth__c==null?'0.00': String.valueOf(appTriad.ECTO_Cheque_Monthly_Avg_Last_12_Mth__c));
            mapObj.put('avgCTOLast3To6Mth', appTriad.Average_Credit_TurnOver_Last_3_6_Mth__c==null?'0.00': String.valueOf(appTriad.Average_Credit_TurnOver_Last_3_6_Mth__c));
            mapObj.put('avgCTOLast6To12Mth', appTriad.Average_Credit_TurnOver_Last_6_12_Mth__c==null?'0.00': String.valueOf(appTriad.Average_Credit_TurnOver_Last_6_12_Mth__c));
            mapObj.put('valueChqRDLast6Mth', appTriad.Value_Cheque_RD_Last_6_Mth__c==null?'0.00': String.valueOf(appTriad.Value_Cheque_RD_Last_6_Mth__c));
            mapObj.put('valueSavRDLast6Mth', appTriad.Value_Savings_RD_Last_6_Mth__c==null?'0.00': String.valueOf(appTriad.Value_Savings_RD_Last_6_Mth__c));
            mapObj.put('lastUpdatedDate', String.valueOf(appTriad.LastModifiedDate));
            triadAggregatedValues.add(mapObj);
        }
        
        return triadAggregatedValues;
    }
}