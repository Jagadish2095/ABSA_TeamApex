/**
* Controller for Beneficiary Management Lightning component
* @author  Kyle Alexander
* @created 2018-09-26
*/
public class AppScreenController {
    /**
     * Method that gets a list of all specific opportunity pareties 
     * 
     * @param oppId - opportunity Id
     */
	@AuraEnabled 
    public static List<Opportunity_Party__c> getPartyData(Id oppId, String partyType) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, partyType);
        
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
    
    @AuraEnabled
    public static Boolean checkIfFuneralBenefitTaken(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        if(!quotes.isEmpty()){
        	List<QuoteLineItem> quoteLineItems = [SELECT Id, Policy_Cover__c, Premium__c, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quotes.get(0).Id AND PricebookEntry.Name LIKE '%Funeral Benefit%'];
            if(quoteLineItems.isEmpty()){
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Method that gets the spouses date of birth that was previously captured in the quote
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Date getSpouseDOB(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if(!opportunities.isEmpty()){
            return opportunities.get(0).Spouse_Date_of_Birth__c;
        }
        return null;
    }
    
    @AuraEnabled
    public static Boolean dependantValidity(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        Boolean funeralAdded = false;
        Boolean spouseAdded = false;
        if(!quotes.isEmpty()){
        	List<QuoteLineItem> quoteLineItems = [SELECT Id, Policy_Cover__c, Premium__c, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quotes.get(0).Id];
            for(QuoteLineItem quoteLineItem : quoteLineItems){
                if(quoteLineItem.PricebookEntry.Name.contains('Funeral Benefit')){
                    funeralAdded = true;
                }
                if(quoteLineItem.PricebookEntry.Name.contains('Spouse')){
                    spouseAdded = true;
                }
            }
        }
        
        if(funeralAdded == true || spouseAdded == true){
            return true;
        }
        
        return false;
    }
    
    @AuraEnabled
    public static Boolean checkSpouseValidity(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        if(!quotes.isEmpty()){
        	List<QuoteLineItem> quoteLineItems = [SELECT Id, Policy_Cover__c, Premium__c, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quotes.get(0).Id AND PricebookEntry.Name LIKE '%Spouse%'];
            if(quoteLineItems.isEmpty()){
                return true;
            }
        }
        
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Dependant');
		Boolean spouseAdded = false;
        for(Opportunity_Party__c opportunityParty : opportunityParties){
            if(opportunityParty.Relationship__c == 'Spouse'){
                spouseAdded = true;
                break;
            }
        }
        
        if(spouseAdded){
            return true;
        }
        
        return false;
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
            totalSplit += oppParty.Benefit_Split__c;
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
    public static Opportunity_Party__c createOpportunityParty(Opportunity_Party__c oppParty, Id oppId) {
        Opportunity_Party__c opportunityParty = new Opportunity_Party__c();
        opportunityParty = oppParty;
        opportunityParty.Opportunity__c = oppId;
        opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;
        
        opportunityParty.Party_Type__c = 'Beneficiary';
        
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
    public static Opportunity_Party__c updateOpportunityParty(Opportunity_Party__c oppParty, Id oppPartyId) {
        Opportunity_Party__c opportunityParty = [SELECT Id, Party_Type__c FROM Opportunity_Party__c WHERE Id = :oppPartyId];
        opportunityParty = oppParty;
        opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;

        opportunityParty.Party_Type__c = 'Beneficiary';
                    
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
     * Method that creates the specific opportunity party
     *
     * @param oppId - opportunity Id
     * @param oppParty - specific opportunity party being added
     */
    @AuraEnabled
    public static Opportunity_Party__c createOpportunityPartyDep(Opportunity_Party__c oppParty, Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');
		
        Opportunity_Party__c opportunityParty = new Opportunity_Party__c();
        opportunityParty = oppParty;
        opportunityParty.Opportunity__c = oppId;
        if(opportunityParty.Benefit_Split__c != null){
            opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;
        }        
        
        if(oppParty.Relationship__c == 'Child'){
            Integer days = oppParty.Date_of_Birth__c.daysBetween(Date.Today());
            Integer age = Integer.valueOf(days/365.2425);
            if(age < 1){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Stillbirths til 11 months'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
            else if(age >= 1 && age < 6){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Children aged 1-5'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
            else if(age >= 6 && age < 14){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Children aged 6-13'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
            else if(age >= 14 && age <= 21){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Children aged 14-21'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
        }
        else{
            List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Spouse'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
        }

        opportunityParty.Party_Type__c = 'Dependant';
        opportunityParty.Id = null;
        insert opportunityParty;
        
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
     * @param isAlsoBeneficiaryUpdate - check to see if the record added must also be added as a beneficiary
     */
    @AuraEnabled
    public static Opportunity_Party__c updateOpportunityPartyDep(Opportunity_Party__c oppParty, Id oppId, Id oppPartyId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');

        Opportunity_Party__c opportunityParty = [SELECT Id FROM Opportunity_Party__c WHERE Id = :oppPartyId];
        opportunityParty = oppParty;

        if(opportunityParty.Benefit_Split__c != null){
            opportunityParty.Benefit_Split__c = (oppParty.Benefit_Split__c) / 100;
        }
        
        opportunityParty.Party_Type__c = 'Dependant';
        opportunityParty.Benefit_Split__c = null;
        
        if(oppParty.Relationship__c == 'Child'){
            Integer days = oppParty.Date_of_Birth__c.daysBetween(Date.Today());
            Integer age = Integer.valueOf(days/365.2425);
            if(age < 1){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Stillbirths til 11 months'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
            else if(age >= 1 && age < 6){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Children aged 1-5'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
            else if(age >= 6 && age < 14){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Children aged 6-13'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
            else if(age >= 14 && age <= 21){
                List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Children aged 14-21'];
                opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
            }
        }
        else{
            List<EPP_Pricing_Matrix__c> pricingMatrix = [SELECT Id, Sum_Insured__c FROM EPP_Pricing_Matrix__c WHERE Funeral_Plan_Member__c = 'Spouse'];
            opportunityParty.Dependant_Cover__c = pricingMatrix.get(0).Sum_Insured__c;
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
    public static Boolean removeOpportunityPartyDep(Id oppPartyId) {
        try{
            Opportunity_Party__c opportunityParty = [SELECT Id, Opportunity__c, Relationship__c FROM Opportunity_Party__c WHERE Id = :oppPartyId LIMIT 1];
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
     * Method that gets the total benefit split 
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static Integer getTotalBenefitSplit(Id oppId) {
        Integer totalSplit = 0;
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Beneficiary');
        for(Opportunity_Party__c oppParty : opportunityParties){
            if(oppParty.Benefit_Split__c != null){
                totalSplit += Integer.valueOf(oppParty.Benefit_Split__c * 100);
            }
        }
        return totalSplit;
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
    
    @AuraEnabled
    public static String checkInitValidity(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        return opportunities.get(0).Application_Status__c;
    }
    
    @AuraEnabled
    public static String checkDependantValidity(Id oppId) {

        Boolean isFamilyFuneralAdded = false;
        List<OpportunityLineItem> oppLineItems = [SELECT Id, Name from OpportunityLineItem WHERE OpportunityId = :oppId];
        for(OpportunityLineItem oLineItem : oppLineItems){
            if(oLineItem.Name.contains('Funeral Benefit')){
              	isFamilyFuneralAdded = true;
            }
        }

        List<Opportunity_Party__c> opportunityDependantParties = [SELECT id, Party_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :oppId AND Relationship__c = 'Child' AND Party_Type__c INCLUDES ('Dependant')];
        if(opportunityDependantParties.size() == 0){
            if(isFamilyFuneralAdded){
            	return 'Invalid Dependant';
        	}
        }
        
        return 'Valid';
    }
    
	@AuraEnabled
    public static String checkValidity(Id oppId) {
        Double totalBenefitSplit = 0;
        List<Opportunity_Party__c> opportunityParties = [SELECT id, Benefit_Split__c FROM Opportunity_Party__c WHERE Opportunity__c = :oppId AND Party_Type__c INCLUDES ('Beneficiary')];
        
        for(Opportunity_Party__c oppParty : opportunityParties){
            totalBenefitSplit += oppParty.Benefit_Split__c;
        }
        
        System.debug(totalBenefitSplit);
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        if(totalBenefitSplit != 1){
            
            return 'Invalid Beneficiaries';
        }
        
        Boolean isSpouseAdded = false;
        List<OpportunityLineItem> oppLineItems = [SELECT Id, Name from OpportunityLineItem WHERE OpportunityId = :oppId];
        for(OpportunityLineItem oLineItem : oppLineItems){
            if(oLineItem.Name.contains('Spouse')){
              	isSpouseAdded = true;
                break;
            }
        }
        List<Opportunity_Party__c> opportunitySpouseParties = [SELECT id, Party_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :oppId AND Relationship__c = 'Spouse' AND Party_Type__c INCLUDES ('Dependant')];
        if(opportunitySpouseParties.size() == 0){
            if(isSpouseAdded){
            	return 'Invalid Spouse';
        	}
        }
                
        //All valid
        opportunities.get(0).Application_Status__c = 'Valid';
        update opportunities;
        
        return 'Valid';
    }
    
    /**
     * Method that saves the selected email to an opp
     *
     * @param oppId - opportunity Id
     * @param emailAddress - email address being sent to
     * @param isAlternative - if the email address being sent to in an alternative one or not
     */
    @AuraEnabled
    public static void saveEmail(Id oppId, String emailAddress) {     
        
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);

        opportunities.get(0).Selected_Email__c = emailAddress;
        
        update opportunities;  
    }
    
    /**
     * Method that saves an alternative email and sets the selected email address used to send emails in future
     *
     * @param oppId - opportunity Id
     * @param altEmailAddress - altermative email address being sent to
     */
    @AuraEnabled
    public static void saveAlternativeEmail(Id oppId, String altEmailAddress) {     
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);

        if(accounts.get(0).Alternative_Email__c == null){
            accounts.get(0).Alternative_Email__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_1__c == null){
            accounts.get(0).Alternative_Email_1__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_2__c == null){
            accounts.get(0).Alternative_Email_2__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_3__c == null){
            accounts.get(0).Alternative_Email_3__c = altEmailAddress;
        }
        else if(accounts.get(0).Alternative_Email_4__c == null){
            accounts.get(0).Alternative_Email_4__c = altEmailAddress;
        }
        
        opportunities.get(0).Selected_Email__c = altEmailAddress;
        
        update accounts;
        update opportunities;  
    }
    
    /**
     * Method that gets all of the clients emails
     *
     * @param oppId - opportunity Id
     * @return List<String> - list of clients emails
     */
    @AuraEnabled
    public static List<String> getEmails(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
        
        List<String> emails = new List<String>();

        if(opportunities.get(0).Selected_Email__c != null){
            emails.add(opportunities.get(0).Selected_Email__c);
        }
        
        if(opportunities.get(0).Selected_Email__c != accounts.get(0).PersonEmail){
        	emails.add(accounts.get(0).PersonEmail);
        }
         
        if(accounts.get(0).Alternative_Email__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email__c){
            emails.add(accounts.get(0).Alternative_Email__c);
        }
        if(accounts.get(0).Alternative_Email_1__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_1__c){
            emails.add(accounts.get(0).Alternative_Email_1__c);
        }
        if(accounts.get(0).Alternative_Email_2__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_2__c){
            emails.add(accounts.get(0).Alternative_Email_2__c);
        }
        if(accounts.get(0).Alternative_Email_3__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_3__c){
            emails.add(accounts.get(0).Alternative_Email_3__c);
        }
        if(accounts.get(0).Alternative_Email_4__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_4__c){
            emails.add(accounts.get(0).Alternative_Email_4__c);
        }

        return emails;
    }
}