/**
 *
 * @description This class is the Apex Controller for Lightning Components: CaseExistingLDP
 * @Test Class: TestCaseExistingLDPController
 * @Created By: Raviteja
 * Story: W-005787
 *
 */
public with sharing class CaseExistingLDPController{
	/**
	 *
	 * @description Method that executes a Service Callout to LDP system for fetching account & contracts information
	 * @param caseId
     * @return CaseExistingLDPWrapper
	 * @Created By: Raviteja
	 * Story: W-005787
	 *
	 */
	@auraEnabled
	public static Map<String,List<sobject>> fetchLDPinfo(String caseId){
		list<Application_Product__c> appproductList = new list<Application_Product__c>();
		Case cs = [Select Id, Opportunity__c, Application_Product_Id__c
		           from Case
		           where Id = :caseId];
        
        
        
        List<Application_Financial_Account__c>appFinAccounts=new List<Application_Financial_Account__c>();
        List<Contract__c>conList=new List<Contract__c>();
        List<Contract__c>contractList=new List<Contract__c>();
        Map<String,List<sobject>> responseMap=new Map<String,List<sobject>>();
        List<Opportunity>oppList=[select accountId from opportunity where Id=:cs.Opportunity__c];
        Account acc=[select accountNumber,cif__c from account where Id=:oppList[0].accountId];
        Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(cs.Opportunity__c);
        List<Application_Financial_Account__c>appFinAccounts1=[select Id,Facility_account_number__c,Facility_limit__c,Review_date__c,isSelected__c,Total_Contract_Balance__c,Requested_facility_limit__c from Application_Financial_Account__c where application__c=:application.Id and product__c='Bank Guarantee'];
        if(appFinAccounts1.size()>0){
        contractList=[select Id,Application_Financial_Account__c,Contract_number__c,Contract_sub_product_code__c,Contract_type__c,Contract_balance__c,Expiry_Date__c,isSelected__c,Contract_amount__c from Contract__c where Application__c=:application.Id];

        }
        List<Application_product__c>appProd=[select Id,Facility_account_number__c,Requested_facility_limit__c,Requested_review_date__c from application_product__c where opportunity__c=:cs.Opportunity__c and product_state__c='Existing'];
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
        
		/*if (String.isNotBlank(cs.Application_Product_Id__c)){
			appproductList = [Select Id, Account_Number__c
			                  from Application_Product__c
			                  where Id = :cs.Application_Product_Id__c];
		}
		if (appproductList.size() > 0 && appproductList[0].Account_Number__c != NULL){
			LDPgetAccountInfoV2_Req_IB_v1 requestnew = new LDPgetAccountInfoV2_Req_IB_v1();
			LDPgetAccountInfoV2_Req_IB_v1.cls_LDPgetAccountInfoV2 req2 = new LDPgetAccountInfoV2_Req_IB_v1.cls_LDPgetAccountInfoV2();
			LDPgetAccountInfoV2_Req_IB_v1.cls_nbsapdpi req = new LDPgetAccountInfoV2_Req_IB_v1.cls_nbsapdpi();
			req.channel = 'Salesforce';
			req.application = 'Salesforce';
			req.trace = 'Y';
			req2.nbsapdpi = req;
			LDPgetAccountInfoV2_Req_IB_v1.cls_ld300a2i req3 = new LDPgetAccountInfoV2_Req_IB_v1.cls_ld300a2i();
			req3.accountNumber = String.valueOf(appproductList[0].Account_Number__c);
			req2.ld300a2i = req3;
			requestnew.LDPgetAccountInfoV2 = req2;
			LDPgetAccountInfoV2_Resp_IB_v1 resp = LDPgetAccountInfoV2_IH_v1.executeService(requestnew);
            if (test.isRunningTest()) {
                resp = (LDPgetAccountInfoV2_Resp_IB_v1) JSON.deserialize('{"LDPgetAccountInfoV2Response":{"nbsapdpo":{"version":null,"serviceVersion":null,"returnCode":"0","reasonCode":"0","echoKey":null},"ld300a3o":{"recordNumber1":"NaN","recordIde":null,"recordId":"D","numberOfContracts":"1","errorNumber":"NaN","errorLine3":null,"errorLine2":null,"errorLine1":null,"contractData":[{"contractSubProduct":"GAR","contractProdType":"2","contractProdCode":"2","contractNumber":"30440109881","contractExpiryDate":"0001-01-01","contractBalance":"22270","contractAmount":"22270"}],"clientCode":"EAEROSP006","accountTotReviewDate":"2002-07-30","accountTotLimit":"0","accountTotExpiryDate":"2002-07-30","accountTotBalance":"22270","accountNumber":"6900028770"}}}',LDPgetAccountInfoV2_Resp_IB_v1.class);
            }
			system.debug('response--> ' + resp.LDPgetAccountInfoV2Response.ld300a3o);
			CaseExistingLDPWrapper wrap = new CaseExistingLDPWrapper();
			wrap.accountnumber = resp.LDPgetAccountInfoV2Response.ld300a3o.accountnumber;
			wrap.accountTotBalance = resp.LDPgetAccountInfoV2Response.ld300a3o.accountTotBalance;
			wrap.accountTotExpiryDate = resp.LDPgetAccountInfoV2Response.ld300a3o.accountTotExpiryDate;
			wrap.accountTotLimit = resp.LDPgetAccountInfoV2Response.ld300a3o.accountTotLimit;
			wrap.accountTotReviewDate = resp.LDPgetAccountInfoV2Response.ld300a3o.accountTotReviewDate;
			list<contractdetails> contractdetailslist = new list<contractdetails>();
			for (LDPgetAccountInfoV2_Resp_IB_v1.cls_contractData data : resp.LDPgetAccountInfoV2Response.ld300a3o.contractData){
				contractdetails detail = new contractdetails();
				detail.contractAmount = data.contractAmount;
				detail.contractBalance = data.contractBalance;
				detail.contractExpiryDate = data.contractExpiryDate;
				detail.contractNumber = data.contractNumber;
				detail.contractSubProduct = data.contractSubProduct;
				contractdetailslist.add(detail);
			}
			wrap.contractlist = contractdetailslist;
			return wrap;
		} else{
			return null;
		}*/
        
        
        
        
	}
    
    /**
     * @description : Method to get managed LDP accounts
     * @author Himani Joshi | 2021-06-21 
     * @param caseId 
     * @return List<Map<String, String>> 
     **/
    @AuraEnabled
     public static List<Map<String, String>> getManagedLDPAccounts(Id caseId){
        List<Case>cases=[select opportunity__c from case where Id=:caseId];
        Id opportunityId=cases[0].opportunity__c;
        
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
	 * @description CaseExistingLDPWrapper Description
	 *
	 */
	public class CaseExistingLDPWrapper{
		@auraEnabled
		public String accountnumber;
		@auraEnabled
		public Decimal accountTotBalance;
		@auraEnabled
		public String accountTotExpiryDate;
		@auraEnabled
		public Decimal accountTotLimit;
		@auraEnabled
		public String accountTotReviewDate;
		@auraEnabled
		public list<contractdetails> contractlist;
	}

	/**
	 * @description contractdetails Description
	 *
	 */
	public class contractdetails{
		@auraEnabled
		public Decimal contractAmount;
		@auraEnabled
		public Decimal contractBalance;
		@auraEnabled
		public String contractExpiryDate;
		@auraEnabled
		public String contractNumber;
		@auraEnabled
		public String contractSubProduct;

	}
    
    
}