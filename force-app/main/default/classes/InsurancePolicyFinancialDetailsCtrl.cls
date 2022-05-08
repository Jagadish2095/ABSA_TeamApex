/*
* InsurancePolicyFinancialDetailsController for getting Insurance Policy Financial Details
*
* @author  Simangaliso Mathenjwa : ABSA
* @version v1.0
* @since   02 Feb 2021
*/
public  class InsurancePolicyFinancialDetailsCtrl{

    @AuraEnabled
    public static List<Insurance_Policy_Financial__c> getFinancialDetails(Id InsurancePolicyId, String objectFields, String searchFilter, Integer pageSize, Integer pageNumber){

        Integer psize                                = pageSize;
        Integer pnumber                              = pageNumber-1;
        Integer offsetSize                           = pageSize*pnumber;               
        String query = 'SELECT ' + objectFields + ' FROM Insurance_Policy_Financial__c WHERE Insurance_Policy__c = :InsurancePolicyId '+ searchFilter + ' LIMIT :psize OFFSET :offsetSize';
        List<Insurance_Policy_Financial__c>  response = Database.query(query);
        
        return response;
    }

}