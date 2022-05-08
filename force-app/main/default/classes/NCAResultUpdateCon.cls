/**
* @description :Apex class for NCA Status Retrive Service to get the result
* and update Result and juristic field in App Product -Credit
* @author Diksha Wasekar:Absa
* @created 2020-01-30
* @updated W-011629 || Saurabh : 20210503
**/
public class NCAResultUpdateCon {
    /**
    * @description  : Method to Call NCA service to get results
    * @author Diksha/Almas | 06-07-2021
    * @param oppId
    **/
    @Future(callout=true)
    public static void getNCAResultsFromService(Id oppId){
        Map<string, Boolean> getMapforNCAResults =PowerCurveController.getValidationMap(oppId);
        if(getMapforNCAResults.get('NCAResultUpdate') != true){

            Opportunity opp= new OpportunitiesSelector().selectByOppId(oppId);
            String clienttypestring ;
            Integer clientType,assetValue ,annualTrunOver, currentOverdraftLimit,trustees;
            Boolean SecuredByMortgageBond,anyJuristicTrustee;
            List<Application_Product__c> appProdList = new List<Application_Product__c>(); // List to update with NCA response
            //Translations for ClientType
            string clienttypetrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Client Type', opp.Client_type__c, 'Outbound');
            if(clienttypetrans.length()>=3 ){
                clienttypestring=clienttypetrans.substring(1,3);
                clientType=Integer.valueOf(clienttypestring);
            }else{
                clientType= Integer.valueOf(clienttypetrans);
            }
            Map<String,Application_Product__c> childWithParentProductMap = new Map<String,Application_Product__c>();
            List<Application_Product__c> ProductList = [Select id, Name ,Product_Name__c,Account_Number__c,Product_State__c,Product_Status__c,Product_Amount__c,Current_Overdraft_Limit__c,Application_Product_Parent__c,Secured_By_Mortgage_Bond__c,Asset_Value__c,Annual_Turnover__c,
                                                        NCA_Appplicable__c,NCA_juristic__c,Number_or_Trustees__c,Any_Juristic_Trustees__c from Application_Product__c Where Opportunity__c=:oppId AND Application_Product_Parent__c = null ];
            List<Application_Product__c> childappProdList = [select id,name,Product_Amount__c,Application_Product_Parent__c,Secured_By_Mortgage_Bond__c,Asset_Value__c,Annual_Turnover__c From Application_Product__c Where Opportunity__c=:oppId AND Application_Product_Parent__c != null ];
            if(childappProdList != null || !childappProdList.isEmpty()){
                for (Application_Product__c apc : childappProdList){
                 childWithParentProductMap.put(apc.Application_Product_Parent__c,apc);
                }
            }
            // W-011629 || Saurabh : 20210503  Added logic to read NCA fields from Application, Not modifying the storing part as results are specific to each product
            Application__c appCredit = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
                     assetValue = appCredit.Asset_Value__c != null ? Integer.valueOf(appCredit.Asset_Value__c) : 0;
                    annualTrunOver = appCredit.Annual_Turnover__c != null ? Integer.valueOf(appCredit.Annual_Turnover__c) : 0;
                    trustees=  appCredit.Number_of_Trustees__c != null ? Integer.valueOf(appCredit.Number_of_Trustees__c) : 0;
                    anyJuristicTrustee = appCredit.Any_Juristic_Trustees__c == 'Yes' ? True : False;

            if(!ProductList.isEmpty() && ProductList!=null){
                for(Application_Product__c appProd:ProductList){
                    Application_Product__c childappProd = childWithParentProductMap.get(appProd.id);
                    //W-012774 - NCA for rest products
                    if(childappProd!=null ){
                    currentOverdraftLimit= Integer.valueOf(childappProd.Product_Amount__c);
                    SecuredByMortgageBond= childappProd.Secured_By_Mortgage_Bond__c;
                    }else {
                        currentOverdraftLimit= Integer.valueOf(appProd.Product_Amount__c);
                    SecuredByMortgageBond= appProd.Secured_By_Mortgage_Bond__c;
                    }

                    //call nca decision service
                    GetNCARetrieve_Resp_IB_v1 responseBean = GetNCARetrieve_IH_v1.GetNCAStatus2(assetValue, annualTrunOver,clientType, currentOverdraftLimit, 'CR',trustees,anyJuristicTrustee,SecuredByMortgageBond );
                    system.debug('NCA response bean--'+json.serializePretty(responseBean));
                    if(responseBean.result !=null){
                        appProd.NCA_Appplicable__c = responseBean.result.Execution_results.results[0].value.za_co_absa_brms_nca_NcaDecision.result;
                        if(opp.Client_Type__c.equalsIgnoreCase('Sole Trader') || opp.Client_Type__c.equalsIgnoreCase('Sole Proprietor')){
                            appProd.NCA_juristic__c = 'Individual';
                        }else{
                            appProd.NCA_juristic__c = responseBean.result.Execution_results.results[0].value.za_co_absa_brms_nca_NcaDecision.juristic;
                        }
                        appProdList.add(appProd);
                    }

                }
            }
            try{
                if(appProdList.size()>0 && appProdList!= null && !appProdList.isEmpty() ){
                    update appProdList;
                    PowerCurveController.setValidationFields(oppId, 'NCAResultUpdate', true);
                }

            }catch(DMLException e){
                system.debug('exception---'+e.getLineNumber());
            }

        }
    }

}