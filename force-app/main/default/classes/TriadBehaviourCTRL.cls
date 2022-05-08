/**
 * @description Controller class for TriadBehaviour aura component
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date October 2020
 */
public class TriadBehaviourCTRL {
    /**
     * @description method to get TriadBehaviourData
     * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-14
     * @param applicationId
     * @return List<Map<String, Object>>
    **/
	@AuraEnabled(Cacheable=false)
    public static List<Map<String,Object>> getTriadBehaviourData(Id applicationId){
        List<Map<String,Object>> triadBehaviour = new List<Map<String,Object>>();
        String condition = ' AND (Customer_Alignment_Score__c <> null OR Cheque_Score__c <> null OR Credit_Card_Score__c <> null OR Mortgage_Score__c <> null ';
        condition += 'OR AVAF_Score__c <> null OR Loan_Score__c <> null)';

    	List<Application_Triad__c> appTriads = new ApplicationTriadsSelector().selectByApplicationIdWithCondition(new Set<Id>{applicationId}, condition);

        for(Application_Triad__c appTriad : appTriads){
            Map<String,String> mapObj = new Map<String,String>();
            mapObj.put('clientName',appTriad.Client_Name__c);
            mapObj.put('clientCode',appTriad.Client_Code__c);
            mapObj.put('custAlignScore', appTriad.Customer_Alignment_Score__c==null?'0.00': String.valueOf(appTriad.Customer_Alignment_Score__c));
            mapObj.put('chequeScore', appTriad.Cheque_Score__c==null?'0.00': String.valueOf(appTriad.Cheque_Score__c));
            mapObj.put('creditCardScore', appTriad.Credit_Card_Score__c==null?'0.00': String.valueOf(appTriad.Credit_Card_Score__c));
            mapObj.put('mortgageScore', appTriad.Mortgage_Score__c==null?'0.00': String.valueOf(appTriad.Mortgage_Score__c));
            mapObj.put('avafScore', appTriad.AVAF_Score__c==null?'0.00': String.valueOf(appTriad.AVAF_Score__c));
            mapObj.put('loanScore', appTriad.Loan_Score__c==null?'0.00': String.valueOf(appTriad.Loan_Score__c));
            mapObj.put('lastUpdatedDate', String.valueOf(appTriad.LastModifiedDate));
            triadBehaviour.add(mapObj);
        }

        return triadBehaviour;
    }
}