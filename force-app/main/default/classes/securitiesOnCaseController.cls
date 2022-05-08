/**
 * @description       : 
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-10-20
 * @last modified by  : almas.aleem@absa.africa
**/
public class securitiesOnCaseController {
	/**
	* @description  
	* @author almas.aleem@absa.africa | 2021-10-20 
	* @param caseId 
	* @return Case 
	**/
@auraEnabled
	public static Case updateSecurities(Id caseId){
        Case secCase=[select SecurityId__c from case where Id=:caseId];
        //Security_Offered__c security=[select Id,Security_Type__c,Bond_Ranking__c,Bond_type__c,Bond_holder__c,Bond_registration_number__c,Bond_amount_registered_offered__c,Property_description__c,Title_deed_number__c,Date_registered__c,Property_type__c,Valued_by__c,Realistic_market_value__c,Valuation_date__c,Nominal_Value__c,Approved_Security_Value_Percentage_ASV__c,ASV_approved_by_Credit__c,Date_ASV_was_approved_by_Credit__c,Approved_security_value__c,Specific_Security__c from Security_Offered__c where Id=:secCase.SecurityId__c];
        return secCase;
    }
    
}