/**
* Class to manage financial needs ananlysis
*
* @author Kyle Alexander
* @created 2018-10-03
* @Updated Robert McLean
* @Updated on 2019-11-21
*/
public class LiquidityCalculatorController {

    /**
    * Get Opportunity Record Type String Map
    */  
    public static Map <String, Schema.RecordTypeInfo> opportunityRecordTypesMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    /**
    * Get Opportunity Record Type Id Map
    */
    public static Map <Id, Schema.RecordTypeInfo > opportunityRecordTypesIdMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById();
    
    /**
    * Save FNA
    * 
    * @param Financial_Needs_Analysis__c - fna object
    * @oppId - opportunity Id 
    */
    @AuraEnabled
    public static Financial_Needs_Analysis__c saveFinancialNeedsAnalysis (Financial_Needs_Analysis__c newFna, Id oppId) {
		//Get account from opportunity ID and set it to FNA
		Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        Account account = new AccountsSelector().selectByOpportunityId(opportunity.AccountId, 1);
		Financial_Needs_Analysis__c fna = new Financial_Needs_Analysis__c();
        fna = newFna;
        if(newFna.Cash__c == null){
            fna.Cash_Action__c = null;
        }
        if(newFna.Investment__c == null){
            fna.Investment_Action__c = null;
        }
        if(newFna.Fixed_Properties__c == null){
            fna.Fixed_Properties_Action__c = null;
        }
        if(newFna.Life_Policies__c == null){
            fna.Life_Policies_Action__c = null;
        }
        if(newFna.Other_Assets__c == null){
            fna.Other_Assets_Action__c = null;
        }        
 		fna = newFna;
        fna.id = null;
        fna.Account__c = account.id;
        fna.Full_Liquidity__c = true;
        System.debug('Debug start');
        System.debug('fna :'+fna);
        System.debug('Debug finish');
        //insert the fna
        insert fna;
        //update opportunity fna lookup
        opportunity.Financial_Needs_Analysis__c = fna.id;
        //Update opportunity stage if opportunity record type is not Wills
        if (opportunity.RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
            opportunity.StageName = 'Needs Analysis';
        }
        update opportunity;        
        //return fna
        return fna;
    }
    
    /**
    * Save short FNA
    * 
    * @param Financial_Needs_Analysis__c - fna object
    * @oppId - opportunity Id 
    */    
    @AuraEnabled
    public static Financial_Needs_Analysis__c saveShortFinancialNeedsAnalysis (Financial_Needs_Analysis__c newFna, Id oppId) {
		//Get account from opportunity ID and set it to FNA
		Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        Account account = new AccountsSelector().selectByOpportunityId(opportunity.AccountId, 1);
		Financial_Needs_Analysis__c fna = new Financial_Needs_Analysis__c();
 		fna.lump_sum_Assets_Capture__c = newFna.lump_sum_Assets_Capture__c;
        fna.Comment__c = newFna.Comment__c;
        fna.id = null;
        fna.Account__c = account.id;
        fna.Full_Liquidity__c = false;       
        //insert the fna
        insert fna;
        //update opportunity fna lookup
        opportunity.Financial_Needs_Analysis__c = fna.id;
        //Update opportunity stage if opportunity record type is not Wills
        if (opportunity.RecordTypeId != opportunityRecordTypesMap.get('Wills').getRecordTypeId()) {
            opportunity.StageName = 'Needs Analysis';
        }
        update opportunity;        
        //return fna
        return fna;
    }
    
    /**
    * Get latest FNA
    * 
    * @oppId - opportunity Id 
    */    
    @AuraEnabled
    public static Financial_Needs_Analysis__c getLatestFinancialNeedsAnalysis(Id oppId) {
		Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        if(opportunity.Financial_Needs_Analysis__c == null){
            throw new AuraHandledException('No FNA Exists, new FNA required');
        }
        else{
            List<Financial_Needs_Analysis__c> fna = new FinancialNeedsAnalysisSelector().selectLatestById(opportunity.Financial_Needs_Analysis__c, 1);    
            System.debug(fna.get(0));
            return fna.get(0);
        }
    }

    /**
    * Get pick list values
    * 
    * @objObject - the object the field is related 
    * @fld- the field the pick list is related to 
    */ 
	@AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
    /**
    * Method that returns opportunity record type
    *
    * @param oppId - opportunity Id 
    */    
    @AuraEnabled
    public static String getOpportunityRecordType(Id oppId) {
        String oppRecType;
        List<Opportunity> listOpp = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if(listOpp != null || !listOpp.isEMpty()){
            Id recTypeId = listOpp.get(0).RecordTypeId;
            oppRecType = opportunityRecordTypesIdMap.get(recTypeId).getName();       
        }        
        return oppRecType;
    }
}