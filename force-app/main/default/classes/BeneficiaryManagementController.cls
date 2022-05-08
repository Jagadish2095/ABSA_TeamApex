/**
* Controller for Beneficiary Management Lightning component
* @author  Kyle Alexander
* @created 2018-09-26
*/
public class BeneficiaryManagementController {
    /**
     * Method that gets a list of all specific opportunity pareties 
     *
     * @param oppId - opportunity Id
     */
	@AuraEnabled
    public static List<Opportunity_Party__c> getPartyData(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');
        
        return opportunityParties;
    }
    /**
     * Method that gets a list of all specific opportunity pareties 
     * @author  Divya
     * @param oppId - opportunity Id
     */
	@AuraEnabled
    public static List<Opportunity_Party__c> getAllPartyData(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityId(oppId);
        return opportunityParties;
    }
    /**
     * Method that gets a single specific opportunity party
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Opportunity_Party__c getSingleParty(Id oppPartyId) {
        List<Opportunity_Party__c> opportunityParty = new OpportunityPartiesSelector().selectByOpportunityPartyId(oppPartyId);
        if(opportunityParty.get(0).Benefit_Split__c != null){
            opportunityParty.get(0).Benefit_Split__c = (opportunityParty.get(0).Benefit_Split__c) * 100;
        }
        return opportunityParty.get(0);
    }
    
    /**
     * Method that checnks how many opportunity parties have been added
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Integer checkNumberOpportunityParty(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');
		return opportunityParties.size();
    }
    
    /**
     * Method that gets the total benefit split 
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Double checkTotalBenefitSplit(Id oppId) {
        Double totalSplit = 0;
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');

        for(Opportunity_Party__c oppParty : opportunityParties){
            if(oppParty.Benefit_Split__c != NULL){	//Added by Divya
                totalSplit += oppParty.Benefit_Split__c;
            }
        }
        return totalSplit;
    }
    
    /**
     * Method that checks if a duplicate record has been added
     *
     * @param oppId - opportunity Id
     * @param opParty - specific opportunity party being checked against
     */
    @AuraEnabled
    public static Boolean checkDuplicateRecord(Id oppId, Opportunity_Party__c opParty) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityId(oppId);
        for(Opportunity_Party__c oppParty : opportunityParties){
            if(oppParty.Id != opParty.Id){
                if(oppParty.RSA_ID_Number__c != null && opParty.RSA_ID_Number__c != null){
                    if(oppParty.First_Name__c.equals(opParty.First_Name__c) && oppParty.Last_Name__c.equals(opParty.Last_Name__c) && oppParty.RSA_ID_Number__c.equals(opParty.RSA_ID_Number__c) && opParty.Date_of_Birth__c == oppParty.Date_of_Birth__c){
                        return true;
                    }
                }
                else{
                    if(oppParty.First_Name__c.equals(opParty.First_Name__c) && oppParty.Last_Name__c.equals(opParty.Last_Name__c) && opParty.Date_of_Birth__c == oppParty.Date_of_Birth__c){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    
    /**
     * Method that creates the specific opportunity party
     *
     * @param oppId - opportunity Id
     * @param oppParty - specific opportunity party being added
     * @param isAlsoDependant - check to see if the record added must also be added as a dependant
     */
    @AuraEnabled
    public static Opportunity_Party__c createOpportunityParty(Opportunity_Party__c oppParty, Id oppId, Boolean isAlsoDependant) {
        Opportunity_Party__c opportunityParty = new Opportunity_Party__c();
        opportunityParty = oppParty;
        opportunityParty.Opportunity__c = oppId;
        system.debug('@@@'+oppParty.Benefit_Split__c);
        if(oppParty.Benefit_Split__c != NULL){ //Added by Divya
          opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;  
        }
        
        if(isAlsoDependant){
            opportunityParty.Party_Type__c = 'Beneficiary;Dependant';
        }
        else{
            opportunityParty.Party_Type__c = 'Beneficiary';
        }
        opportunityParty.Id = null;
        insert opportunityParty;
        
        //Update Stage 
        List<Opportunity> opportunities = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId LIMIT 1];
        opportunities.get(0).StageName = 'Proposal';
        update opportunities;
        
        return new Opportunity_Party__c();
    }
    
    /**
     * Method that updates the specific opportunity party
     *
     * @param oppId - opportunity Id
     * @param oppParty - specific opportunity party being updated
     * @param isAlsoDependantUpdate - check to see if the record added must also be added as a dependant
     */
    @AuraEnabled
    public static Opportunity_Party__c updateOpportunityParty(Opportunity_Party__c oppParty, Id oppPartyId, Boolean isAlsoDependantUpdate) {
        
        Opportunity_Party__c opportunityParty = [SELECT Id, Party_Type__c FROM Opportunity_Party__c WHERE Id = :oppPartyId];
        opportunityParty = oppParty;
        if(oppParty.Benefit_Split__c != NULL){ //Added by Divya
            opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;
        }
        if(isAlsoDependantUpdate){
            if(opportunityParty.Party_Type__c.contains('Spouse')){
                opportunityParty.Party_Type__c = 'Beneficiary;Dependant;Spouse';
            }
            else{
                opportunityParty.Party_Type__c = 'Beneficiary;Dependant';
            }
        }
        else{
            if(opportunityParty.Party_Type__c.contains('Spouse')){
                opportunityParty.Party_Type__c = 'Beneficiary;Spouse';
            }
            else{
                opportunityParty.Party_Type__c = 'Beneficiary';
            }
        }
        
        update opportunityParty;
        
        return new Opportunity_Party__c();
    }
    
    /**
     * Method that removes a specific opportunity party
     *
     * @param oppPartyId - Id of the specific opportunity party being removed
     */
    @AuraEnabled
    public static Boolean removeOpportunityParty(Id oppPartyId) {
        try{
            Opportunity_Party__c opportunityParty = [SELECT Id, Opportunity__c FROM Opportunity_Party__c WHERE Id = :oppPartyId];
            Opportunity opp = [SELECT Id, Application_Status__c FROM Opportunity WHERE Id = :opportunityParty.Opportunity__c LIMIT 1];

        	delete opportunityParty;
            
            opp.Application_Status__c = 'Incomplete';
            update opp;
            
            return true;
        }
        catch(Exception ex){
            System.debug('Error removing Opportunity Party: ' + ex);
            return false;
        }
    }
    
    /**
     * Method that gets all picklist data
     *
     * @param objObject - Id of the specific opportunity party being removed
     * @param fld - field name i.e. Clause_Name__c
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
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
      /**
	 * Added for Flexi Funneral Functionality  
	 * 
     * Method that Insert and delete a list of all specific opportunity pareties 
     *
     * @param oppId - opportunity Party list for insert and delete
     */
	@AuraEnabled
    public static List<Opportunity_Party__c> insertOppPartyData(List<Opportunity_Party__c> oppPartyListInsert,list<sobject> oppPartyListInsertdelete) {
 
        if(oppPartyListInsertdelete.isempty()==false){
            database.delete(oppPartyListInsertdelete);
        }
        set<id> oppPartyIsset = new set<id> ();
        if(oppPartyListInsert.isempty()==false){
            List<Database.upsertResult> upsertResult = database.upsert(oppPartyListInsert,true) ; 
            system.debug('upsertResult '+upsertResult);
            for(Database.upsertResult result: upsertResult) {
                if(result.isSuccess() && result.getId()!=null){
                    oppPartyIsset.add(result.getId());
                }else{
                    system.debug('error'+result.getErrors());
                }
            }
        }
        return null;
    }
    
    /**
     * Method that gets RecordType of opportunity 
     * @author  Divya
     * @param oppId - opportunity Id
     */
	@AuraEnabled
    public static Opportunity getOppRec(Id oppId) {
        Opportunity opp =new OpportunitiesSelector().selectByOppId(oppId);
        
        return opp;
    }
    
    
    @AuraEnabled
    public static Boolean removeBeneficiaryParty(Id oppPartyId, String productName) {
        
        List<Opportunity_Party__c> opportunityParty = new OpportunityPartiesSelector().selectByOpportunityPartyId(oppPartyId);
        //[SELECT Id, Party_Type__c,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Id = :oppPartyId]
        
        /*if(opportunityParty[0].Party_Type__c == 'Beneficiary;Dependant'){
            opportunityParty[0].Party_Type__c = 'Dependant';
        }
        else if (opportunityParty[0].Party_Type__c == 'Beneficiary'){
            opportunityParty[0].Party_Type__c = '';
        }
        else if(opportunityParty[0].Party_Type__c == 'Beneficiary;Dependant;Spouse'){
            opportunityParty[0].Party_Type__c = 'Dependant;Spouse';
        }
        else if(opportunityParty[0].Party_Type__c == 'Beneficiary;Spouse'){
            opportunityParty[0].Party_Type__c = 'Spouse';
        }*/
        if(opportunityParty[0].Beneficiary_Product__c != null)
        	if(opportunityParty[0].Beneficiary_Product__c.contains(productName)){
            	opportunityParty[0].Beneficiary_Product__c = opportunityParty[0].Beneficiary_Product__c.replace(productName,'');
        		if(opportunityParty[0].Beneficiary_Product__c == ''){
                	opportunityParty[0].Party_Type__c = opportunityParty[0].Party_Type__c.replace('Beneficiary','');
            }
        }
        update opportunityParty;
        if(opportunityParty[0].Party_Type__c == '' && opportunityParty[0].DD_Cross_Sell_Product_Member_Type__c == '')
              delete opportunityParty[0];
        
        return true;
    }
}