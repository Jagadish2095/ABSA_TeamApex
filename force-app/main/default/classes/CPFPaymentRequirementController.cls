/**
 * Controller class for CPFPaymentRequirement and CPFFinalDateForDrawDown aura components
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 */

public class CPFPaymentRequirementController {
    /** Method to retrieve Application Product CPF record Id
     *
     * @param opportunityId Id
     * @return Id
     **/
    @AuraEnabled(Cacheable=true)
    public static Id getApplicationProductCPFId(Id opportunityId) {
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);

        if (application != null) {
            Application_Product_CPF__c appProductCPF = new ApplicationProductCPFSelector().selectByAppId(application.Id);

            if (appProductCPF != null) {
                return appProductCPF.Id;
            }
        }

        return null;
    }
}