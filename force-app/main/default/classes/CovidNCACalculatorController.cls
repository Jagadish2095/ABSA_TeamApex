public class CovidNCACalculatorController {
    
 @AuraEnabled
    public static Application_Product__c getApplicationProduct(Id opportunityId) {
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        List<Application_Product__c> appProdCredList = new ApplicationProductSelector().selectByOpportunityId(opportunityId);

        if(appProdCredList.size() > 0 && appProdCredList != null) {
            return appProdCredList[0];
        }
        else {
            return null;
        }
    }
 
    @AuraEnabled
    public static Map<String, String> updateClient(Id oppId, String accountObj) {
        Map<String, Object> mapObj = (Map<String, Object>)JSON.deserializeUntyped(accountObj);
        Map<String, String> updateResult = new Map<String, String>();

        List<Opportunity> opprunityList = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectIndvByOpportunityIdUpdate(oppId);
       	List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectbyAccount(opprunityList[0].AccountId);

		if(!isEmptyOrNull(account)) {
            /** add fund only **/
            //account.Date_Established__c = Date.parse(getFormatedDate((String)mapObj.get('BusinessStartDate')));
            //account.Standard_Industry_SIC_Code__c = (String)mapObj.get('StandardIndustryCode');
           
            try {
                update account;
                updateResult.put('accountUpdate', 'Updated');
            }
            catch(Exception ex) {
                updateResult.put('accountUpdate', 'Error Updating: ' + ex.getDmlMessage(0));
            }
        }

		if(!isNullOrEmpty(acrList)) {
            AccountContactRelation acr = acrList[0];
            //acr.StartDate = businessStartDate;

            try {
                update acr;
                updateResult.put('acrUpdate', 'Updated');
            }
            catch(Exception ex) {
                updateResult.put('acrUpdate', 'Error Updating');
            }
        }
        return updateResult;
    }
    private static Boolean isEmptyOrNull(sObject obj) {
        return obj == null;
    }

    private static Boolean isNullOrEmpty(List<sObject> objList) {
        return objList == null || objList.size() == 0;
    }
 
    @AuraEnabled
    public static String updateOpportunityStage(Id oppId) {
        String returnMessage = 'SUCCESS';
        try {
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
            if(opportunities != null && opportunities.size() > 0) {
                opportunities[0].StageName = StringConstants.OPPORTUNITY_STAGE_COMPLETE_PRODUCT_DETAILS;
                update opportunities;
            }
        }
        catch (Exception e) {
            throw new AuraHandledException('Something went wrong: ' +  e.getMessage());
        }
        return returnMessage;
    }
    
    @auraEnabled
    public static Application_Product__c calculateNCAFromService(Id appProdId){
        
        Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(appProdId);
        
        if(appProd != null){
            //call nca decision service
            GetNCARetrieve_Resp_IB_v1 responseBean = GetNCARetrieve_IH_v1.GetNCAStatus(Integer.valueOf(appProd.Asset_Value__c), Integer.valueOf(appProd.Annual_Turnover__c));
            system.debug('NCA response bean--'+responseBean);
            system.debug('result---'+responseBean.result.Execution_results.results[0].value.za_co_absa_brms_nca_NcaDecision.result);
            if(responseBean.result !=null){
                appProd.NCA_Result__c = responseBean.result.Execution_results.results[0].value.za_co_absa_brms_nca_NcaDecision.result;
                try{
                  update appProd;  
                }catch(DMLException e){
                    system.debug('exception---'+e.getLineNumber());
                }
            }
        }
        
        return appProd;
    }
}