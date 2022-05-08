/**
 * @description       : Controller class for Bank Guarantee component
 * @author            : Himani Joshi
 * @last modified on  : 2021-12-06
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-21   Himani Joshi   Initial Version
**/

public class BankGuaranteeController {
    /**
    * @description : Method to get existing LDP accounts
    * @author Himani Joshi | 2021-06-21 
    * @param opportunityId 
    * @return Map<String, List<sobject>> 
    **/
    @AuraEnabled
    public static Map<String,List<sobject>> getExistingAccounts(Id opportunityId){
        List<Application_Financial_Account__c>appFinAccounts=new List<Application_Financial_Account__c>();
        List<Contract__c>conList=new List<Contract__c>();
        List<Contract__c>contractList=new List<Contract__c>();
        Map<String,List<sobject>> responseMap=new Map<String,List<sobject>>();
        List<Opportunity>oppList=[select accountId from opportunity where Id=:opportunityId];
        Account acc=[select accountNumber,cif__c from account where Id=:oppList[0].accountId];
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
        List<Application_Financial_Account__c>appFinAccounts1=[select Id,Facility_account_number__c,Facility_limit__c,Review_date__c,isSelected__c,Total_Contract_Balance__c,Requested_facility_limit__c from Application_Financial_Account__c where application__c=:application.Id and product__c='Bank Guarantee'];
        if(appFinAccounts1.size()>0){
        contractList=[select Id,Application_Financial_Account__c,Contract_number__c,Contract_sub_product_code__c,Contract_type__c,Contract_balance__c,Expiry_Date__c,isSelected__c,Contract_amount__c from Contract__c where Application__c=:application.Id];

        }
         List<Application_product__c>appProd=[select Id,Facility_account_number__c,Requested_facility_limit__c,Requested_review_date__c from application_product__c where opportunity__c=:opportunityId and product_state__c='Existing'];
        if(appFinAccounts1.size()>0){
            if(appProd.size()>0){
            for(Application_product__c appProd1:appProd){
            for(Application_Financial_Account__c fin:appFinAccounts1){
                if(appProd1.Facility_account_number__c==fin.Facility_account_number__c){
                    fin.isSelected__c=true;
                }
                else{
                   fin.isSelected__c=false; 
                }
                }
            }
            }
            else{
                for(Application_Financial_Account__c fin:appFinAccounts1){
                   fin.isSelected__c=false; 
                }
            }
        }
        update appFinAccounts1;
        
        
        
        if(application.Accounts_Orchestration_JSON__c != null){
            ChequeServicesOrchestration_Resp_IB_v1 respOrches = (ChequeServicesOrchestration_Resp_IB_v1) JSON.deserialize(application.Accounts_Orchestration_JSON__c, ChequeServicesOrchestration_Resp_IB_v1.class);
            
            if(respOrches != null && respOrches.LDPgetAccountInfoV2Responses != null){
                for (ChequeServicesOrchestration_Resp_IB_v1.LDPgetAccountInfoV2Responses output : respOrches.LDPgetAccountInfoV2Responses) {
                  if(output.LDPgetAccountInfoV2Response.ld300a3o.accountNumber!='NaN'){
                  Application_Financial_Account__c aff=new Application_Financial_Account__c();
                  
                  aff.Application__c=application.Id;
                  aff.Product__c='Bank Guarantee';
                  aff.ClientCode__c=output.LDPgetAccountInfoV2Response.ld300a3o.clientCode;
                  aff.Facility_account_number__c=output.LDPgetAccountInfoV2Response.ld300a3o.accountNumber;
                  aff.Facility_limit__c=output.LDPgetAccountInfoV2Response.ld300a3o.accountTotLimit;
                  aff.Total_contract_balance__c=output.LDPgetAccountInfoV2Response.ld300a3o.accountTotBalance;
                  aff.Review_date__c=output.LDPgetAccountInfoV2Response.ld300a3o.accountTotReviewDate;
                  appFinAccounts.add(aff); 
                      
                      for(ChequeServicesOrchestration_Resp_IB_v1.ContractData var:output.LDPgetAccountInfoV2Response.ld300a3o.contractData){
                          Contract__c con=new Contract__c();
                          
                          con.AccountNo__c=output.LDPgetAccountInfoV2Response.ld300a3o.accountNumber;
                          con.Contract_amount__c=var.contractAmount;
                          con.Contract_balance__c=var.contractBalance;
                          con.Contract_number__c=var.contractNumber;
                          con.Contract_sub_product_code__c=var.contractSubProduct;
                          con.Contract_type__c=var.contractProdType;
                          con.Expiry_Date__c=var.contractExpiryDate;

                          conList.add(con); 
                          
                      }

                      /*
                   Contract__c con=new Contract__c();
                   con.AccountNo__c=output.LDPgetAccountInfoV2Response.ld300a3o.accountNumber;
                   con.Contract_amount__c=output.LDPgetAccountInfoV2Response?.ld300a3o?.contractData?.contractAmount;
                   con.Contract_balance__c=output.LDPgetAccountInfoV2Response?.ld300a3o?.contractData?.contractBalance;
                   con.Contract_number__c=output.LDPgetAccountInfoV2Response?.ld300a3o?.contractData?.contractNumber;
                   con.Contract_sub_product_code__c=output.LDPgetAccountInfoV2Response?.ld300a3o?.contractData?.contractSubProduct;
                   con.Contract_type__c=output.LDPgetAccountInfoV2Response?.ld300a3o?.contractData?.contractProdType;
                   con.Expiry_Date__c=output.LDPgetAccountInfoV2Response?.ld300a3o?.contractData?.contractExpiryDate;
                   conList.add(con); 
*/
                  
                }
                }
            }
        }
                List<Contract__c>updatedContractList=new List<Contract__c>();
                 if(appFinAccounts1.size()==0){
                  insert appFinAccounts;
                  insert conList;
                     for(Application_financial_account__c aff:appFinAccounts){
                         for(Contract__c var:conList){
                             if(aff.Facility_account_number__c==var.AccountNo__c){
                                 Contract__c con1=new contract__c();
                                 con1.Id=var.Id;
                                 con1.AccountNo__c=var.AccountNo__c;
                                 con1.Application__c=application.Id;
                                 con1.Application_Financial_Account__c=aff.ID;
                                 con1.Contract_amount__c=var.Contract_amount__c;
                                 con1.Contract_balance__c=var.Contract_balance__c;
                                 con1.Contract_number__c=var.Contract_number__c;
                                 con1.Contract_sub_product_code__c=var.Contract_sub_product_code__c;
                                 con1.Contract_type__c=var.Contract_type__c;
                                 con1.Expiry_Date__c=var.Expiry_Date__c;
                                 con1.isSelected__c=var.isSelected__c;
                                 updatedContractList.add(con1);
                                 
                             }
                         }
                     }
                  }
            
        
        if(appFinAccounts1.size()==0){
        update updatedContractList;
        responseMap.put('AppFinancials',appFinAccounts);
        responseMap.put('Contracts',updatedContractList);
        return responseMap;
        }
        else{
            responseMap.put('AppFinancials',appFinAccounts1);
            responseMap.put('Contracts',contractList);
            return responseMap;
        }
         
    }
     /**
     * @description : Method to get managed LDP accounts
     * @author Himani Joshi | 2021-06-21 
     * @param opportunityId 
     * @return List<Map<String, String>> 
     **/
    @AuraEnabled
     public static List<Map<String, String>> getManagedLDPAccounts(Id opportunityId){
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
        //List<Application_profile__c>appProfileList=new ApplicationProfileSelector().getApplicationProfilesByType(application.Id,'Main Applicant');
        //List<Application_Financial_Account__c>appFinAccounts1=[select Id,Facility_account_number__c,Facility_limit__c,Review_date__c,Total_Contract_Balance__c from Application_Financial_Account__c where ClientCode__c=:appProfileList[0].Client_CIF_Code__c];
        List<Application_Financial_Account__c>appFinAccounts1=[select Id,Facility_account_number__c,Facility_limit__c,Review_date__c,Total_Contract_Balance__c,isSelected__c from Application_Financial_Account__c where application__c=:application.Id and product__c='Bank Guarantee'];
        //List<Application_Product__c> appProducts = new ApplicationProductSelector().selectByOpportunityId(opportunityId);
        List<Application_Product__c> appProducts = [select Id,Facility_account_number__c,Facility_limit__c,Total_Contract_Balance__c,Facility_review_date__c,Requested_facility_limit__c,Requested_review_date__c,Product_Name__c,Product_State__c from application_product__c where Opportunity_Product_Id__c=:opportunityId];
        
        List<Map<String, String>> mngdAccs = new List<Map<String, String>>();
        
        if(appProducts != null && appProducts.size() > 0){
            for(Application_Financial_Account__c fin:appFinAccounts1){
            for(Application_Product__c appProd : appProducts){
                if(appProd.Product_Name__c == 'Bank Guarantee' && appProd.Product_State__c == 'Existing' && appProd.Facility_account_number__c==fin.Facility_account_number__c){
                     Map<String, String> mngdAcc = new Map<String, String>();
                     mngdAcc.put('Id',fin.Id);
                     mngdAcc.put('Facility_account_number__c',appProd.Facility_account_number__c);
                     mngdAcc.put('Facility_limit__c',appProd.Facility_limit__c);
                     mngdAcc.put('Total_Contract_Balance__c',appProd.Total_Contract_Balance__c);
                     mngdAcc.put('Review_date__c',string.valueof(appProd.Facility_review_date__c));
                     mngdAcc.put('Requested_facility_limit__c',appProd.Requested_facility_limit__c);
                     mngdAcc.put('Requested_review_date__c',string.valueof(appProd.Requested_review_date__c));
                     //mngdAcc.put('recordId',appProd.Id);
                     mngdAcc.put('isSelected__c',string.valueof(fin.isSelected__c));
                     mngdAccs.add(mngdAcc);
                }
            }
        }
        }
        return mngdAccs;
     }
    
    
    /**
    * @description : Method to get application products
    * @author Himani Joshi | 2021-06-21 
    * @param opportunityId 
    * @return Application_Product__c 
    **/
    @AuraEnabled
    public static Application_Product__c getApplicationProducts(Id opportunityId){
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
        Application_Product__c app=new Application_Product__c();
        app.Opportunity__c=opportunityId;
        app.product_name__c='Bank Guarantee';
        app.Contract_sub_product_code__c='GAR';
        app.Opportunity_Product_Id__c=opportunityId;
        app.product_state__c='New';
        insert app;
        
        ApplicationProductSelector appProductSelector = new ApplicationProductSelector();
        app = appProductSelector.selectById(new Set<Id>{app.Id})[0];
        return app;
        
        
    }
    
    /**
    * @description : Method which gets called on save
    * @author Himani Joshi | 2021-06-21 
    * @param managedAccounts 
    * @param newAccounts 
    * @param conList 
    * @param opportunityId 
    * @return boolean 
    **/
    @AuraEnabled
    public static boolean saveClass(List<Application_Financial_Account__c> managedAccounts, List<Application_Product__c> newAccounts,List<Contract__c>conList,Id opportunityId){
        
        Application__c application = new ApplicationsSelector().selectByOpportunityId(opportunityId)[0];
        
        if(application != null && creditcardctrl.isConductDataRequired(application)){
        	List<Application_Financial_Conduct__c> appFinConList = new ApplicationFinancialConductSelector().selectByApplicationId(application.Id);
            
            if(appFinConList == null || appFinConList.size() == 0) {
                throw new AuraHandledException('Please select Primary/Additional Conduct accounts on Cheque and Overdraft section');
            }
        }

        Boolean deletion = false;
         List<Application_product__c>appProd=[select Id,Facility_account_number__c from application_product__c where opportunity__c=:opportunityId and product_state__c='Existing'];
        List<Application_product__c>existingProds=new List<Application_product__c>();
            for(Application_product__c appProd1:appProd){
            for(Application_Financial_Account__c fin:managedAccounts){
                if(appProd1.Facility_account_number__c==fin.Facility_account_number__c){
                    appProd1.Opportunity__c = opportunityId;
                    appProd1.Facility_account_number__c=fin.Facility_account_number__c;
                    appProd1.Opportunity_Product_Id__c = opportunityId;
                    appProd1.Product_State__c = 'Existing';
                    appProd1.Product_Name__c = 'Bank Guarantee';
                    appProd1.Facility_limit__c=fin.Facility_limit__c;
                    appProd1.Facility_review_date__c=fin.Review_date__c;
                    appProd1.Total_Contract_Balance__c=fin.Total_Contract_Balance__c;
                    appProd1.Requested_facility_limit__c=fin.Requested_facility_limit__c;
                    appProd1.Requested_review_date__c=fin.Requested_review_date__c;
                    existingProds.add(appProd1);
                }
                }
            }
        
       
        List<Application_Product__c>updatedProducts=new List<Application_Product__c>();
        List<Application_Product__c>insertList=new List<Application_Product__c>();
        List<Application_Product__c>appProds=[select Id,Facility_limit__c,Facility_review_date__c,Temp_Account_Number__c from Application_Product__c where opportunity__c=:opportunityId];
        for(Application_Product__c fin:newAccounts)
        {
            for(Application_Product__c app:appProds){
            //Application_Product__c app=[select Id,Facility_limit__c,Facility_review_date__c from Application_Product__c where Temp_Account_Number__c=:fin.Temp_Account_Number__c];
            if(app.Temp_Account_Number__c==fin.Temp_Account_Number__c){
            app.Facility_limit__c=fin.Facility_limit__c;
            app.Facility_review_date__c=fin.Facility_review_date__c;
            app.Product_State__c = 'New';
            app.Opportunity__c = opportunityId;
            updatedProducts.add(app);
                }
            }
        }
        Set<Id>managedIds=new Set<Id>();
        for(Application_Financial_Account__c var:managedAccounts){
            managedIds.add(var.Id);
        }
        List<AggregateResult> result =[select min(contract_amount__c)crm from contract__c where isselected__c=false and Application_Financial_Account__c IN:managedIds];
        for(Application_Financial_Account__c var:managedAccounts)
        {
            
            //string scr;
            //List<AggregateResult> result =[select min(contract_amount__c)crm from contract__c where Application_Financial_Account__c=:var.Id and isselected__c=false];
            Integer minValue=Integer.valueof(result[0].get('crm'));
            
            
            if(Integer.valueof(var.Requested_facility_limit__c)<minValue){
               
               throw new AuraHandledException('Requested Facility Limit for account with account number '+var.Facility_Account_number__c+ 'cannot be less than '+minValue); 
            }
        

            else{
            Application_Product__c din=new Application_Product__c();
            din.RecordId__c=var.Id;
            din.Opportunity__c = opportunityId;
            din.Facility_account_number__c=var.Facility_account_number__c;
            din.Opportunity_Product_Id__c = opportunityId;
            din.Product_State__c = 'Existing';
            din.Product_Name__c = 'Bank Guarantee';
            din.Facility_limit__c=var.Facility_limit__c;
            din.Facility_review_date__c=var.Review_date__c;
            din.Total_Contract_Balance__c=var.Total_Contract_Balance__c;
            din.Requested_facility_limit__c=var.Requested_facility_limit__c;
            din.Requested_review_date__c=var.Requested_review_date__c;
            insertList.add(din);
            }
            
        }
        
        
        try{
            if(existingProds.size()==0 && insertList.size()>0){
            insert insertList;
            }
            if(existingProds.size()>0){
                update existingProds;
            }
            
            /*
if(updatedProducts!=null)
{deletion=true;}
*/
            update updatedProducts;
            PowerCurveController.setValidationFields(opportunityId, 'Bank_Guarantee_Validated', true);
            creditcardctrl.getTriadExposureData(opportunityId);
            
        }    
        catch(Exception exc){
            exc.getMessage();
        }
        return deletion;
        
    }
    /**
    * @description : Method to delete managed account
    * @author Himani Joshi | 2021-06-21 
    * @param chText 
    * @return Boolean 
    **/
    @AuraEnabled(Cacheable=false)
    public static Boolean deleteManagedAccount(Id chText){
    	Boolean deleteResult = false;
        Application_Product__c appProd=[select Id from Application_Product__c where RecordId__c=:chText];
        //Application_Product__c appProd = new Application_Product__c(RecordId__c = chText);

        try{
            delete appProd;
        } catch(Exception exc){
            throw new AuraHandledException(String.valueOf(exc));
        }

        return deleteResult;
    }
    /**
    * @description : Method to get new accounts
    * @author Himani Joshi | 2021-06-21 
    * @param opportunityId 
    * @return List<Application_Product__c> 
    **/
     @AuraEnabled(Cacheable=true)
    public static List<Application_Product__c> getNewAccounts(Id opportunityId){
        List<Application_Product__c> appProducts = new ApplicationProductSelector().selectByOpportunityId(opportunityId);
        List<Application_Product__c> newAccounts = new List<Application_Product__c>();

        if(appProducts != null && appProducts.size() > 0){
            for(Application_Product__c appProd : appProducts){
                if(appProd.Product_Name__c == 'Bank Guarantee' && appProd.Product_State__c == 'New'){
                    newAccounts.add(appProd);
                }
            }
        }

        return newAccounts;
    }
    
    /**
    * @description : Method to get the updated contract list
    * @author Himani Joshi | 2021-06-21 
    * @param chText 
    * @param chValue 
    * @param opportunityId 
    * @return List<Contract__c> 
    **/
    @AuraEnabled
    public static List<Contract__c> getUpdatedCon(Id chText,Boolean chValue,Id opportunityId){
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
        
        List<Contract__c>updatedContracts=new List<Contract__c>();
        List<Contract__c>conList=[select Id,isSelected__c,Contract_balance__c,Contract_number__c,Contract_sub_product_code__c,Contract_type__c,Expiry_Date__c,application_Financial_account__c,Contract_amount__c from contract__c where Id=:chText];
        Id appFinId=conList[0].application_Financial_account__c;
        
        for(Contract__c con:conList)
        {
            Contract__c var=new contract__c();
            var.Id=con.Id;
            
            var.isSelected__c=chValue;
            var.Contract_amount__c=con.Contract_amount__c;
            var.Contract_balance__c=con.Contract_balance__c;
            var.Contract_number__c=con.Contract_number__c;
            var.Contract_sub_product_code__c=con.Contract_sub_product_code__c;
            var.Contract_type__c=con.Contract_type__c;
            var.Expiry_Date__c=con.Expiry_Date__c;
            updatedContracts.add(var);
        }
        
        update updatedContracts;
        List<Contract__c>updatedConList=[select Id,isSelected__c,Contract_balance__c,Contract_number__c,Contract_sub_product_code__c,Contract_type__c,Expiry_Date__c,application_Financial_account__c,Contract_amount__c from contract__c where application__c=:application.Id];
        return updatedConList;
    }
    
}