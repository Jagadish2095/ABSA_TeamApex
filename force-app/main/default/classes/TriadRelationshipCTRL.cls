/**
 * @description Controller class for TriadRelationship aura component
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date October 2020
 */
public class TriadRelationshipCTRL {
    /**
    * @description method to get Triad Relationship Data
    * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-10-01
    * @param applicationId
    * @return List<Map<String, Object>>
    **/
	@AuraEnabled(Cacheable=false)
    public static List<Map<String,Object>> getTriadRelationshipData(Id applicationId){
        List<Map<String,Object>> triadRelationship = new List<Map<String,Object>>();
    	String condition = 'AND (Months_Since_Oldest_Relationship__c <> null OR Months_Since_Oldest_Account__c <> null OR Months_Since_Oldest_Cheque_Account__c <> null ';
        condition += 'OR Months_Since_Oldest_Savings_Account__c <> null OR Date_First_Relationship__c <> null OR Date_Oldest_Account_Opened__c <> null ';
        condition += 'OR Date_Oldest_Cheque_Account_Opened__c <> null OR Date_Oldest_Savings_Account_Opened__c <> null)';

    	List<Application_Triad__c> appTriads = new ApplicationTriadsSelector().selectByApplicationIdWithCondition(new Set<Id>{applicationId}, condition);

        for(Application_Triad__c appTriad : appTriads){
            Map<String,String> mapObj = new Map<String,String>();
            mapObj.put('clientName',appTriad.Client_Name__c);
            mapObj.put('clientCode',appTriad.Client_Code__c);
            mapObj.put('monthsSinceOldestRel', appTriad.Months_Since_Oldest_Relationship__c==null?'0': String.valueOf(appTriad.Months_Since_Oldest_Relationship__c));
            mapObj.put('monthsSinceOldestAcc', appTriad.Months_Since_Oldest_Account__c==null?'0': String.valueOf(appTriad.Months_Since_Oldest_Account__c));
            mapObj.put('monthsSinceOldestChqAcc', appTriad.Months_Since_Oldest_Cheque_Account__c==null?'0': String.valueOf(appTriad.Months_Since_Oldest_Cheque_Account__c));
            mapObj.put('monthsSinceOldestSavAcc', appTriad.Months_Since_Oldest_Savings_Account__c==null?'0': String.valueOf(appTriad.Months_Since_Oldest_Savings_Account__c));
            mapObj.put('dateFirstRel', String.valueOf(appTriad.Date_First_Relationship__c));
            mapObj.put('dateOldestAccOpened', String.valueOf(appTriad.Date_Oldest_Account_Opened__c));
            mapObj.put('dateOldestChqAccOpened', String.valueOf(appTriad.Date_Oldest_Cheque_Account_Opened__c));
            mapObj.put('dateOldestSavAccOpened', String.valueOf(appTriad.Date_Oldest_Savings_Account_Opened__c));
            mapObj.put('lastUpdatedDate', String.valueOf(appTriad.LastModifiedDate));
            triadRelationship.add(mapObj);
        }

        return triadRelationship;
    }
}