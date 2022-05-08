/**
 * @description Branch Address Search Controller
 * @author  Paul John du Randt : ABSA (IQ Business)
 * @created 2020-09-18
 */
public without sharing class BranchAddressSearchController {
    /**
    * @description getPostalCodeDetails
    * @return List<Map<String,Object>>
    * @param area
    */
    @AuraEnabled
    public static List<Map<String,Object>> getPostalCodeDetails(String area)
    {
        return CIgetPostalCodeHelper.getPostalCodeDetails(area);
    }
}