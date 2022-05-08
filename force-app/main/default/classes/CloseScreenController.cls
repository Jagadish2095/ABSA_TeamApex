/**
* Controller for Close Screen Lightning component
* @author  Kyle Alexander
* @created 2018-09-26
*/
public class CloseScreenController {
    
    /**
     * Method that gets a list of all declarations
     *
     * @param oppId - opportunity Id
     */
	@AuraEnabled
    public static List<Clause__c> getDeclarationData(Id oppId) {
        List<Opportunity> opportunities = [SELECT Product__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
        List<Financial_Product__c> financialProducts = [SELECT Id, Name FROM Financial_Product__c WHERE Name = :opportunities.get(0).Product__c];
        if(!financialProducts.isEmpty() && financialProducts.size() <= 1){
            List<Clause__c> declarations = [SELECT Id, Name, Text_Content__c FROM Clause__c WHERE Financial_Product__c = :financialProducts.get(0).id AND Clause_Type__c = 'Declaration' ORDER BY Order__c ASC];
			
            if(!declarations.isEmpty()){
                return declarations; 
            }
        }
        
        return null;
    }
    
    /**
     * Method that checks if declaration were already done on load
     *
     * @param oppId - opportunity Id
     * Modified by Kalyani to exclude Direct Delivery Sales Opportunity Record types
     */
    @AuraEnabled
    public static List<String> checkInitValidity(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<String> validityMessages = new List<String>();
        
        String invalidComponents = 'The following have not yet been completed: \r\n';
        String validity = 'Valid';
        
        if(opportunities.get(0).Application_Status__c != 'Valid' && opportunities.get(0).RecordType.Name != 'Direct Delivery Sales Opportunity'){
            validity = 'Invalid';
            invalidComponents += '- Application Parties \r\n';
        }
        if(opportunities.get(0).CASA_Status__c != 'Valid'){
            validity = 'Invalid';
            invalidComponents += '- CASA \r\n';
        }
        if(opportunities.get(0).Material_Disclosure_Status__c != 'Valid' && opportunities.get(0).RecordType.Name != 'Direct Delivery Sales Opportunity'){
            validity = 'Invalid';
            invalidComponents += '- Material Disclosures \r\n';
        }
        if(opportunities.get(0).Risk_Status__c != 'Valid'){
            validity = 'Invalid';
            invalidComponents += '- Risk Rating \r\n';
        }
        if(opportunities.get(0).Declaration_Status__c != 'Valid'){
            validity = 'Invalid - Not Done';
        }
        
        validityMessages.add(validity);
        validityMessages.add(invalidComponents);
        
        return validityMessages;
    }
    
    /**
     * Method that checks if all required emails have been sent otherwise a warning message is sent
     *
     * @param oppId - opportunity Id
     * @return Boolean - if valid or not
     */
    @AuraEnabled
    public static Boolean checkIfShowWrningMessage(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        if(opportunities.get(0).Email_Status__c == 'Valid'){
        	return true;
        }
        
        return false;
    }
    
    /**
     * Method that checks whether declaration are valid and saves them
     *
     * @param oppId - opportunity Id
     * @param oppId - list of all clauses added
     * Modified by Kalyani to return quote for opportunity record type Direct Delivery Sales Opportunity
     */
    @AuraEnabled
    public static List<quote> saveDeclarationData(Id oppId, List<Clause__c> clauses) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
         
        opportunities.get(0).Declaration_Status__c = 'Valid';
        update opportunities;
        
        List<quote> quotes = new QuotesSelector().filterByOpportunityId(oppId);
        
        return quotes;
        //return [select id, name, description, Product_Name__c, Status from quote where OpportunityId=:oppId and Opportunity.RecordType.Name = 'Direct Delivery Sales Opportunity'];
    }
}