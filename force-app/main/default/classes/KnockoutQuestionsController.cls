/**
* Controller for Knockout Questions component
* @author  Celliers Inggs
* @created 2020-09-22
*/
public class KnockoutQuestionsController {
    /**
     * Method that gets all Knockout Question Records and returns them as an un-ordered HTML list
     */
	@AuraEnabled
    public static string fetchKnockoutQuestions(string listType) {
        string result = '<ul>';

        List < Knockout_Question__c > lstOfRecords = [SELECT Name, Description__c FROM Knockout_Question__c WHERE ListType__c = :listType order by Order__c];
       
        for (Knockout_Question__c kq: lstOfRecords) {
            result = result + '<li>' + kq.Description__c + '</li>';
        }
        
        result = result + '</ul>';
        
        return result;
    }

  
}