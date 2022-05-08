/*T Senkomane June 2020
 * NCA Section for Credit onboarding opportunity
 * 
 * */
public class ncaCTRL 
{
    @AuraEnabled
    public static Application_Product_Credit__c getApplicationProductCredit(Id opportunityId) {
         ApplicationsSelector appSelector = new ApplicationsSelector();
        List<Application__c> appList = appSelector.selectByOpportunityId(opportunityId); 
        ApplicationProductCreditSelector apcSelector = new ApplicationProductCreditSelector();
        Application_Product_Credit__c appProdCred;
         
        List<Application_Product_Credit__c> appProdCredList = apcSelector.selectByOpportunityId(opportunityId);
        if(appProdCredList.size() > 0 && appProdCredList != null){
            return appProdCredList[0]; 
        }
        else
        {
            return null;
        }
       // return appProdCred;
    }
    @AuraEnabled
    public static string updateNCAsection(Boolean creditAgreement,Double numberOfTrustees,String anyJuristicTrustee,
                                          Double annualTurnover,Double assetValue,String clientState,Boolean underExistingFranchise,
                                          Boolean partOfEnterpriseDevFund, id opportunityId)
    {
        String returnReponse = null;
        ApplicationProductCreditSelector apcSelector = new ApplicationProductCreditSelector();
        Application_Product_Credit__c appProdCred;
        List<Application_Product_Credit__c> appProdCredList = apcSelector.selectByOpportunityId(opportunityId);
        List<Application_Product_Credit__c> appCredit = new List<Application_Product_Credit__c>();
        if(appProdCredList.size() > 0){
            for(Application_Product_Credit__c apc : [ SELECT Credit_Agreement_at_Arms_Length__c,Number_or_Trustees__c,Any_Juristic_Trustees__c,
                                                     Annual_Turnover__c,Asset_Value__c,Client_State__c,Client_Operates_Under_Existing_Franchise__c, Part_of_Enterprise_Development_Fund__c,Opportunity_Product_Id__c
                                                     FROM Application_Product_Credit__c where Opportunity__c =: opportunityId])
            {
                apc.Credit_Agreement_at_Arms_Length__c = creditAgreement;
                apc.Number_or_Trustees__c = numberOfTrustees;
                apc.Any_Juristic_Trustees__c = anyJuristicTrustee;
                apc.Annual_Turnover__c = annualTurnover;
                apc.Asset_Value__c = assetValue;
                apc.Client_State__c = clientState;
                apc.Client_Operates_Under_Existing_Franchise__c = underExistingFranchise;
                apc.Part_of_Enterprise_Development_Fund__c = partOfEnterpriseDevFund;
                apc.Opportunity__c = opportunityId;
                appCredit.add(apc);
            }
            try{
                upsert appCredit;                                          
                returnReponse = 'SUCCESS';
            }catch(exception e){
                returnReponse = 'ERROR';
            }
        }
      return returnReponse;
    }
    /*
    @AuraEnabled
    public static Application__c getApplication(Id opportunityId) {
        
        Application__c app;
        ApplicationsSelector appSelector = new ApplicationsSelector();
        
        List<Application__c> appList = appSelector.selectByOpportunityId(opportunityId); 
        
        if(appList.size() > 0){
            app = appList[0];
        }
        return app;
    }*/
}