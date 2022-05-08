/** 
    * @description get cafApplication
    * @author: Masechaba Maseli
    * @return getContractExtras
    
    */
public class cafApplicationController {

    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return getContractExtras
    * @param oppId
    * @param recordId
    * @param typeExtra
    * @param otherExtraDescription
    * @param additionalFeeAmount
    
    */

    @AuraEnabled
    public static String addContractExtras(String oppId,String recordId,String typeExtra,String otherExtraDescription,String additionalFeeAmount){
        String msg = '';
        Integer err = 0;
        Product2 cafProduct = new ProductsSelector().selectByName('CAF');
        PricebookEntry cafPBEntry = new PriceBookEntriesSelector().selectByProduct2Id(cafProduct.Id);

            OpportunityLineItem oppProduct = new OpportunityLineItem();
            oppProduct.OpportunityId 						= oppId;
            oppProduct.Parent_Opportunity_Line_Item_Id__c 	= recordId;
            oppProduct.Type_Extra__c 						= typeExtra;
            oppProduct.Other_Extra_Description__c 			= otherExtraDescription;
            oppProduct.Additional_Fee_Amount__c 			= additionalFeeAmount;
            oppProduct.Quantity 							= 1;
            oppProduct.TotalPrice 							= 1;
            oppProduct.PricebookEntryId 					= cafPBEntry.Id;
            oppProduct.Type__c 								= 'Extras';

        try{
            insert oppProduct;
            msg = 'Extras Added';
        }catch(exception e){
            msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);
            err++;
        }
        return msg;
    }

    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return getContractExtras
    * @param recId
    
    */

    @AuraEnabled
    public static String deteleOpplineItem(Id recId){
        String msg = '';

        if (recId!=null){
            String query = 'SELECT Id FROM OpportunityLineItem WHERE Id =:'+ recId;
            List<OpportunityLineItem> oppProduct = new OpportunityLineItemsSelector().selectById(recId);
            try{
                String productCode = oppProduct[0].Product_name_Product_code__c.split('-')[1];
                System.debug('oppProduct'+productCode);
                Product2 product = [Select Id,ProductCode,(Select Id,Account__c From AccountProductRelationships__r) From Product2 Where ProductCode =: productCode.trim() LIMIT 1];
                
                if(product.AccountProductRelationships__r != null){
                 Delete product.AccountProductRelationships__r;   
                }
            }catch(Exception e){
                msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
                System.debug('msg:'+ msg); 
            }
            	if(oppProduct != NULL){
                	DELETE oppProduct;
                	msg = 'Extras Deleted';
            	}
        }    
        return msg;
    }

    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return getContractExtras
    * @param recordId
    * @param typeExtra
    * @param additionalFeeAmount
    
    */
    @AuraEnabled
    public static String updateContractExtras(Id recordId,String typeExtra,String additionalFeeAmount){
        String msg = '';
        
        OpportunityLineItem oppproduct = new OpportunityLineItemsSelector().selectByIdAndType(recordId, 'Extras')[0];
        if(oppproduct != NULL){
            oppproduct.Type_Extra__c 			= typeExtra;
            oppproduct.Additional_Fee_Amount__c = additionalFeeAmount;

            update oppproduct;
            msg = 'Extras Updated';
        }
        return msg;
    }

    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return getContractExtras
    * @param oppId
    * @param recordId
    * @param vendorCode
    * @param productNameCode
    * @param insuranceCompany
    * @param numberOfweeksCoverSelected
    * @param randValuePerWeek 
    * @param VAPpremium
    * @param selectedAccount
    */
    @AuraEnabled
    public static String updateVAP(String oppId, String recordId,String vendorCode,String productNameCode,String insuranceCompany,String numberOfweeksCoverSelected,String randValuePerWeek, String VAPpremium,String selectedAccount){
        String msg = '';

         OpportunityLineItem oppProduct = new OpportunityLineItemsSelector().selectByIdAndType(recordId, 'VAPs')[0];
        if(oppProduct != NULL){

            oppProduct.Scheme_Code__c						= vendorCode;
            oppProduct.Vendor_Code__c 						= vendorCode;
            oppProduct.Product_name_Product_code__c			= productNameCode;
            oppProduct.Insurance_Company__c 				= productNameCode.contains('Dealer Split Payment Warranty') ? [Select Name From Account Where Id=:selectedAccount LIMIT 1].Name :  insuranceCompany;
            oppProduct.Number_of_weeks_cover_selected__c 	= decimal.valueOf(numberOfweeksCoverSelected);
            oppProduct.Rand_value_per_week__c 				= decimal.valueOf(randValuePerWeek);
            oppProduct.VAP_Premium__c 						= decimal.valueOf(VAPpremium);

            update oppProduct;
            msg = 'VAP Updated';
        }        
        return msg;
    }

    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return getContractExtras
    * @param oppId
    * @param recordId
    
    */
    @AuraEnabled
    public static List<OpportunityLineItem> getContractExtras(String oppId, String recordId){
        List<OpportunityLineItem> oppProduct = new List<OpportunityLineItem>();
        oppProduct = new OpportunityLineItemsSelector().selectByParentOppIdAndType(recordId, 'Extras');
        return oppProduct;
    }

    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return getMultipleSelectOptions
    * @param fieldList
    
    */
    @AuraEnabled
    public static Map<string, List<CustomSelectOptions>> getMultipleSelectOptions(List<String> fieldList) {
        return Sys_Utilities_General.getMultipleSelectOptions(fieldList);
    }

    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return getVAPs Details
    * @param oppId
    * @param recordId
    
    */

    @AuraEnabled
    public static List<OpportunityLineItem> getVAPs(String oppId, String recordId){
       List<OpportunityLineItem> oppProduct = new List<OpportunityLineItem>(); 
       oppProduct = new OpportunityLineItemsSelector().selectByParentOppIdAndType(recordId, 'VAPs');
       return oppProduct;
    }
    
	/** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @return contract Details
    
    */
    @AuraEnabled
    public static List<Product2> getVAPsProduct2() {
        return [SELECT Id, Name, ProductCode, Scheme_Code__c, Description  FROM Product2 WHERE IsActive = true AND Family = 'CAF' AND Product_Classification__c INCLUDES('Value Added Service')];
    }
	/** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @param recordId
    * @param vendorCode
    * @param productNameCode
    * @param insuranceCompany
    * @param numberOfweeksCoverSelected
    * @param randValuePerWeek
    * @param VAPpremium
    * @param selectedAccount
    * @return addVAPProducts
    
    */
    @AuraEnabled
    public static String addVAP(String oppId,String recordId,String vendorCode,String productNameCode,String insuranceCompany,String numberOfweeksCoverSelected,String randValuePerWeek, String VAPpremium,String selectedAccount ){
        System.debug('selectedAccount '+selectedAccount);
        System.debug('productNameCode '+productNameCode);
        String msg = '';
        Product2 cafProduct = new ProductsSelector().selectByName('CAF');
        PricebookEntry cafPBEntry = new PriceBookEntriesSelector().selectByProduct2Id(cafProduct.Id);
        
        OpportunityLineItem oppProduct = new OpportunityLineItem();
        oppProduct.Product_name_Product_code__c			= productNameCode;
        oppProduct.Scheme_Code__c						= vendorCode;
        oppProduct.OpportunityId 						= oppId;
        oppProduct.Parent_Opportunity_Line_Item_Id__c 	= recordId;
        oppProduct.Vendor_Code__c 						= vendorCode;
        oppProduct.Insurance_Company__c 				= productNameCode.contains('Dealer Split Payment Warranty') ? [Select Name From Account Where Id=:selectedAccount LIMIT 1].Name :  insuranceCompany;
        oppProduct.Number_of_weeks_cover_selected__c 	= decimal.valueOf(numberOfweeksCoverSelected);
        oppProduct.Rand_value_per_week__c 				= decimal.valueOf(randValuePerWeek);
        oppProduct.VAP_Premium__c 						= decimal.valueOf(VAPpremium);
        oppProduct.Quantity 							= 1;
        oppProduct.TotalPrice 							= 1;
        oppProduct.Type__c 								= 'VAPs';
        oppProduct.PricebookEntryId 					= cafPBEntry.Id;

         try{

            insert oppProduct;

            msg = 'VAP added';

        }catch(exception e){

            msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);

        }
        return msg;
    }


   /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param recId
    * @return getContractExtraToEdit
    
    */
    @AuraEnabled
    public static OpportunityLineItem getContractExtraToEdit(String recId){
        OpportunityLineItem oppProduct = new OpportunityLineItem();     
        oppProduct = new OpportunityLineItemsSelector().selectByIdAndType(recId, 'Extras')[0];
        return oppProduct;
    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param recId
    * @return getContractExtraToEdit
    
    */
    @AuraEnabled
    public static MAP<Object,Object> getVAP2Edit(String recId){
        MAP<Object,Object> dataMap = new MAP<Object,Object>();
        try{
            OpportunityLineItem oppProduct = new OpportunityLineItem();
            oppProduct = new OpportunityLineItemsSelector().selectByIdAndType(recId, 'VAPs')[0];
            dataMap.put('OpportunityLineItem', oppProduct);
            System.debug('oppProduct '+oppProduct.ProductCode);
            String[] splitedArray = oppProduct.Product_name_Product_code__c.split('-'); 
            String productCode = oppProduct.Product_name_Product_code__c.split('-')[splitedArray.size() - 1];
            System.debug('productCode'+productCode);
            dataMap.put('PRODUCTCODE', productCode);
            Product2 product = [Select Id,ProductCode,(Select Id,Account__c From AccountProductRelationships__r) From Product2 Where ProductCode =: productCode.trim() LIMIT 1];
            System.debug('product '+product+' == '+product.AccountProductRelationships__r);
            if(product.AccountProductRelationships__r != null){ 
                dataMap.put('ACCOUNTPRODRELATIONID', product.AccountProductRelationships__r[0].Id);
            }else{
                dataMap.put('ACCOUNTPRODRELATIONID', '');
            }
        }catch(Exception e){
            System.debug('Exception '+e.getMessage()+' LINE NUMBER '+e.getLineNumber());
        }
        return dataMap;
    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param 
    * @return getContractExtraToEdit
    
    */
    @AuraEnabled
    public static List<Account> getDealers(){
       List<Account> acc = new List<Account>();    
       acc = new AccountsSelector().selectAllByType('Dealer',100);
       return acc;
    }
     /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param selectedDealerId
    * @return getDealer
    
    */
    @AuraEnabled
    public static Account getDealer(String selectedDealerId){
        Account acc = new Account();
        try{

            //acc = [SELECT Id, Name,Dealer_Code__c, Phone,PersonAssistantName,PersonMobilePhone, PersonEmail FROM Account WHERE Id =: selectedDealerId LIMIT 10];
            acc = new AccountsSelector().selectAllById(selectedDealerId);

        }catch(exception e){

            String msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);

        }
        return acc;
    }
     /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @return getDealer
    
    */
    
    @AuraEnabled
    public static String createNewApplication(String oppId){

        //Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity WHERE Id =: oppId];
        Opportunity opportunity = new OpportunitiesSelector().selectByOpportunityId(oppId)[0];
        Product2 cafProduct = new ProductsSelector().selectByName('CAF', 1);
        PricebookEntry cafPBEntry = new PriceBookEntriesSelector().selectByProduct2Id(cafProduct.Id);
        
        String msg 	= '';
        Integer err = 0;
        Application_Product_CAF__c cafApp 	= new Application_Product_CAF__c();
        cafApp.Client_Details__c 			= opportunity.AccountId;
        cafApp.Insurance_Policy_Number__c 	= '0';
        cafApp.Insurance_Company_Name__c 	= 'ABSA';


        try{

            insert cafApp;


        }catch(exception e){

            msg += 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);
            err++;
        }
        if(err == 0){
        OpportunityLineItem oppProduct 			= new OpportunityLineItem();
        oppProduct.OpportunityId 				= oppId;
        oppProduct.Application_Product_CAF__c 	= cafApp.Id;
        oppProduct.Quantity 					= 1;
        oppProduct.TotalPrice 					= 1;
        oppProduct.Type__c 						= 'CAF';
        oppProduct.PricebookEntryId 			= cafPBEntry.Id;


        try{

            insert oppProduct;
            msg = 'CAF Application created successful';

        }catch(exception e){

            msg += 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);

        }
        }else{
            msg+= '<br/>Cannot create Application';
        }


        return msg;
    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @return getDealer
    
    */
    @AuraEnabled
      public static List<OpportunityLineItem> getApplications(String oppId){
         system.debug('oppId '+oppId);     
        List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>();
        String msg = '';
               
        if(oppId.startsWith('006')){
            system.debug('In Opp If');
        oppLineItem = [SELECT Id, Name,Article_Description__c, Financed_Amount__c,Extras_Quantity__c, VAPs_Quantity__c, Application_number__c, Application_Product_CAF__c, 
                       Case_Number__c, Application_Product_CAF__r.Case__r.OwnerId, Opportunity.OwnerId,Opportunity.QA_Approver__r.Id, Application_Product_CAF__r.Case__c, Opportunity.QA_Approver__c
                       FROM OpportunityLineItem WHERE OpportunityId =: oppId AND Type__c ='CAF' order by createddate desc ];
        }else{
            system.debug('In Opp else');
        Application_Product_CAF__c application = new ApplicationProductCAFSelector().selectByCaseId(oppId);
        OpportunityLineItem oppLine = new OpportunityLineItemsSelector().byApplicationProductCAF(application.Id);   
            system.debug('oppLine '+oppLine);
        if(oppLine != NULL){
            oppLineItem.add(oppLine);
        }
           /* oppLineItem = [SELECT Id, Name,Article_Description__c, Financed_Amount__c,Extras_Quantity__c, VAPs_Quantity__c, Application_number__c, Application_Product_CAF__c, 
                       Case_Number__c, Application_Product_CAF__r.Case__r.OwnerId, Opportunity.OwnerId,Opportunity.QA_Approver__r.Id, Application_Product_CAF__r.Case__c, Opportunity.QA_Approver__c
                       FROM OpportunityLineItem WHERE OpportunityId =: oppId AND Type__c ='CAF' order by createddate desc ]; */
        }
            if(oppLineItem != NULL){
                //Newly added by Rajesh to avoid 101 SOQL START
                Set<String> appProdCPFIdSet = new Set<String>();
                Set<String> oppIdSet = new Set<String>();
                Set<String> accIdSet = new Set<String>();
                Map<Id,Application_Product_CAF__c> idVSAppProdCPFMap = new Map<Id,Application_Product_CAF__c>();
                //Map<Id,List<OpportunityLineItem>> idVSOppLineItemListExtras = new Map<Id,List<OpportunityLineItem>>();
                //Map<Id,List<OpportunityLineItem>> idVSOppLineItemListVaps = new Map<Id,List<OpportunityLineItem>>();
                List<OpportunityLineItem> extrasLineItemList = new List<OpportunityLineItem>();
                List<OpportunityLineItem> vapsLineItemList = new List<OpportunityLineItem>();
                Map<Id,Opportunity> idVSOppMap = new Map<Id,Opportunity>();
                Map<Id,Account> idVSAccMap = new Map<Id,Account>();
                
                for(OpportunityLineItem oli : oppLineItem) {
                    appProdCPFIdSet.add(oli.Application_Product_CAF__c);
                    oppIdSet.add(oppId.startsWith('006')?oppId:oli.OpportunityId);
                }
                for(Application_Product_CAF__c app : [SELECT Id, Financed_amount__c,Vehicle_Make_Model__c,All_Extras_and_VAPs_amount__c,Business_status__c FROM Application_Product_CAF__c WHERE Id IN :appProdCPFIdSet ]){
                    idVSAppProdCPFMap.put(app.Id,app);
                }
                for(OpportunityLineItem oli : [Select Id,Additional_Fee_Amount__c,Type__c From OpportunityLineItem Where Parent_Opportunity_Line_Item_Id__c IN : appProdCPFIdSet AND (Type__c ='Extras' OR Type__c ='VAPs') ]){
                    if(oli.Type__c == 'Extras'){
                        extrasLineItemList.add(oli);
                        /*if(!idVSOppLineItemListExtras.containsKey(oli.Id)){
                            idVSOppLineItemListExtras.put(oli.Id,new List<OpportunityLineItem>{oli});
                        }else{
                            idVSOppLineItemListExtras.get(oli.Id).add(oli);
                        }*/
                    }
                    if(oli.Type__c == 'VAPs'){
                        vapsLineItemList.add(oli);
                        /*if(!idVSOppLineItemListVaps.containsKey(oli.Id)){
                            idVSOppLineItemListVaps.put(oli.Id,new List<OpportunityLineItem>{oli});
                        }else{
                            idVSOppLineItemListVaps.get(oli.Id).add(oli);
                        }*/
                    }
                }
                for(Opportunity opp : [Select Id,AccountId,Annual_turnover__c From Opportunity Where Id IN : oppIdSet]){
                    idVSOppMap.put(opp.Id,opp);
                    accIdSet.add(opp.AccountId);
                }
                for(Account acc : [Select Id,FinServ__Status__c,CIF__c From Account Where Id IN : accIdSet]){
                    idVSAccMap.put(acc.Id,acc);
                }
                //Newly added by Rajesh to avoid 101 SOQL END
                /*for(OpportunityLineItem oli : oppLineItem) {
                    //updateVAPsandExtras (oppId.startsWith('006')?oppId:oli.OpportunityId, oli.Id, oli.Application_Product_CAF__c);
                    //updateCompanyTurnover (oppId.startsWith('006')?oppId:oli.OpportunityId, oli.Application_Product_CAF__c);
                    // (oli.Id, oli.Application_Product_CAF__c);
                }*/
                updateVAPsandExtras (oppId, oppLineItem,extrasLineItemList,vapsLineItemList,idVSAppProdCPFMap);
                updateCompanyTurnover2 (oppId, oppLineItem,idVSOppMap,idVSAccMap,idVSAppProdCPFMap);
                updateFinancedAmount2 (oppLineItem,idVSAppProdCPFMap);
            }
        system.debug('oppLineItem '+oppLineItem);
        return oppLineItem;
    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param recId
    * @return getDealer
    
    */
    @AuraEnabled
    public static OpportunityLineItem getApplicationToEdit(Id recId){
        System.debug('recId:'+ recId);
       OpportunityLineItem oppProduct = new OpportunityLineItem();
        try{

            oppProduct = new OpportunityLineItemsSelector().selectById(recId)[0];

        }catch(exception e){

            String msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();

        }
        return oppProduct;
    }
	/** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param appId
    * @return getDealer
    
    */
    @AuraEnabled
    public static Application_Product_CAF__c getApplicationToView(Id appId){
        return [SELECT Id,Account_NCA_Status__c,Dealer_Trading_name_or_code__c,Indicator_Insolvent__c,Indicator_ITC_Consent__c,Contract_Email__c,Name,Case__r.Status,Case__r.CaseNumber,Business_status__c,Term_less_than_72_months__c,Application_amount_less_than_15_of_turn__c,Total_potential_exposure_less_than_1_5__c,Business_clear_bureau_data__c,Do_you_have_short_term_insurance__c,Case__c,Asset_Type__c,Bank_name__c ,Article_Type__c ,Year_First_Registered__c ,Mileage__c ,Registration_Number__c ,VIN_Chassis_Number__c ,Serial_Number__c ,Description__c ,Contract_Type__c ,Purchase_price_amount_excl_VAT__c ,VAT_amount__c ,Commercial_document_fee__c ,Service_fee_incl_VAT__c ,Initiation_fee__c ,Deposit_amount__c ,Dealer_Trade_in_amount__c ,Dealer_Cash_deposit_amount__c ,Residual_Value__c ,Payment_frequency__c ,Term_in_months__c ,Interest_rate__c ,Fixed_or_linked__c ,Commencement_Date__c ,X1st_payment_date__c ,Joint_venture_alliance_code__c ,Pay_DIC_to_dealer__c ,Statement_delivery_method__c ,Landlord_Waiver__c ,VAT_Pay_Back__c ,Skip_payments__c ,Debit_order__c ,Is_sanctioning_required__c ,Credit_Line__c     ,Type_of_request__c ,CAF_site_code__c ,Region__c ,Absa_site_code__c ,Sanctioner_work_queue_regions__c ,Sales_branch__c ,Mandate_holder__c ,Marketer_BDO__c ,Additional_comments__c ,Vehicle_Make_Model__c ,Article_secure__c ,Is_this_an_enterprise_customer__c ,principals_clear_bureau__c ,customer_business_favourable__c ,principals_favourable__c ,Loan_value_less_than_110__c, Age_of_article_less_than_10_years_at_the__c, Company_turnover__c,Agree_Term_and_Condition__c FROM Application_Product_CAF__c WHERE Id =: appId];
    }

   /* public static void updateVAPsandExtras (String oppId, String recId, String appId){
        Integer totalExtrasAmount 		= 0;
        Integer totalVAPsAmount 		= 0;
        Integer totalExtrasVAPsAmount 	= 0;
        
        List<OpportunityLineItem> oppLineItemExtras  = new OpportunityLineItemsSelector().selectByParentOppIdAndType(recId, 'Extras');//idVSOppLineItemListExtras.get(recId) != null ? idVSOppLineItemListExtras.get(recId) : new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLineItemVAPs  = new OpportunityLineItemsSelector().selectByParentOppIdAndType(recId, 'VAPs');//idVSOppLineItemListVaps.get(recId) != null ? idVSOppLineItemListVaps.get(recId) : new List<OpportunityLineItem>();
        OpportunityLineItem oppLI		= new OpportunityLineItemsSelector().selectById(recId)[0];//oli;
        
        oppLI.Extras_Quantity__c 	= oppLineItemExtras.size();
        oppLI.VAPs_Quantity__c 		= oppLineItemVAPs.size();
        System.debug('size1:'+ oppLineItemExtras.size()+'size2:'+oppLineItemVAPs.size());
        for(Integer i = 0; i <= oppLineItemExtras.size()-1; i++ ){
            totalExtrasAmount = totalExtrasAmount + integer.valueof(oppLineItemExtras[i].Additional_Fee_Amount__c);
        }
        
        totalExtrasVAPsAmount = totalExtrasAmount != null ? totalExtrasAmount : 0 + totalVAPsAmount;
        
        try{
            
            update oppLI;
            
        }catch(exception e){
            
            String msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);
            
        }
        //System.debug('appId '+appId);
        //System.debug('idVSAppProdCPFMap.get(appId) '+idVSAppProdCPFMap.get(appId));
        Application_Product_CAF__c appCAF = [SELECT Id, All_Extras_and_VAPs_amount__c FROM Application_Product_CAF__c WHERE Id =: appId];//idVSAppProdCPFMap.get(appId);
        if(appCAF != null){ 
            System.debug('appCAF '+appCAF);
            System.debug('totalExtrasVAPsAmount '+totalExtrasVAPsAmount);
            appCAF.All_Extras_and_VAPs_amount__c 	= totalExtrasVAPsAmount != null ? totalExtrasVAPsAmount : 0;
            
            update appCAF;
        }
    }*/
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @param oppLineItem
    * @param extrasLineItemList
    * @param vapsLineItemList
    * @param idVSAppProdCPFMap
    
    */
    @AuraEnabled
	public static void updateVAPsandExtras (String oppId,List<OpportunityLineItem> oppLineItem, List<OpportunityLineItem> extrasLineItemList,List<OpportunityLineItem> vapsLineItemList,Map<Id,Application_Product_CAF__c> idVSAppProdCPFMap){
        Integer totalExtrasAmount 		= 0;
        Integer totalVAPsAmount 		= 0;
        Integer totalExtrasVAPsAmount 	= 0;
        
        List<OpportunityLineItem> oppLineItemExtras  = extrasLineItemList;//new OpportunityLineItemsSelector().selectByParentOppIdAndType(recId, 'Extras');//idVSOppLineItemListExtras.get(recId) != null ? idVSOppLineItemListExtras.get(recId) : new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLineItemVAPs  = vapsLineItemList;//new OpportunityLineItemsSelector().selectByParentOppIdAndType(recId, 'VAPs');//idVSOppLineItemListVaps.get(recId) != null ? idVSOppLineItemListVaps.get(recId) : new List<OpportunityLineItem>();
        List<Application_Product_CAF__c> appProdCAFList = new List<Application_Product_CAF__c>();
        for(OpportunityLineItem oppLi : oppLineItem){
            //OpportunityLineItem oppLI		= new OpportunityLineItemsSelector().selectById(recId)[0];//oli;
            oppLI.Extras_Quantity__c 	= oppLineItemExtras.size();
            oppLI.VAPs_Quantity__c 		= oppLineItemVAPs.size();
            System.debug('size1:'+ oppLineItemExtras.size()+'size2:'+oppLineItemVAPs.size());
            for(Integer i = 0; i <= oppLineItemExtras.size()-1; i++ ){
                totalExtrasAmount = totalExtrasAmount + integer.valueof(oppLineItemExtras[i].Additional_Fee_Amount__c);
            }
            totalExtrasVAPsAmount = totalExtrasAmount != null ? totalExtrasAmount : 0 + totalVAPsAmount;
            /*try{
                update oppLI;
            }catch(exception e){
                String msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
                System.debug('msg:'+ msg);
            }*/
            //System.debug('appId '+appId);
            //System.debug('idVSAppProdCPFMap.get(appId) '+idVSAppProdCPFMap.get(appId));
            Application_Product_CAF__c appCAF = idVSAppProdCPFMap.get(oppLi.Application_Product_CAF__c);
            if(appCAF != null){
                appProdCAFList.add(appCAF);
                appCAF.All_Extras_and_VAPs_amount__c 	= totalExtrasVAPsAmount != null ? totalExtrasVAPsAmount : 0;
                appProdCAFList.add(appCAF);
            }
        }
        try{
            update oppLineItem;
            if(appProdCAFList != null){
                update appProdCAFList;
            }
        }catch(exception e){
            String msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);
        }
       
    }
   /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @return getDealer
    */
    @AuraEnabled
    public static String getAccAndOpp(Id oppId){

        Opportunity opp 	= new OpportunitiesSelector().selectByOpportunityId(oppId)[0];
        Account acc 		= new AccountsSelector().selectById(opp.AccountId);

        return '{"companyStatus":"'+acc.FinServ__Status__c+'","annualTurnover":"'+opp.Annual_turnover__c+'"}';
    }

    /*public static void updateCompanyTurnover (Id oppId, String appId){


        String CompanyTurnoverInteval 	= '';
        Integer expected_turnover 		= 0;
        String status					= '';

        Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(oppId)[0];//idVSOppMap.get(oppId);
        Account acc = new AccountsSelector().selectById(opp.AccountId);//idVSAccMap.get(opp.AccountId);
        Application_Product_CAF__c appCAF1  = getApplicationToView(appId);//idVSAppProdCPFMap.get(appId);;
		System.debug('appCAF1 '+appCAF1);
        expected_turnover = Integer.valueOf(opp.Annual_turnover__c);
        if(appCAF1 != null){
            if(appCAF1.Business_status__c == 'Active' || appCAF1.Business_status__c == 'Not Active' || acc.FinServ__Status__c != ''){
                status 				= (acc.FinServ__Status__c == 'Active')? 'Active':'Not Active';
            }else{
                status = appCAF1.Business_status__c;
            }
        }
        String existing_customer	= (acc.CIF__c !='')? 'No':'Yes';

        if (expected_turnover >= 0 && expected_turnover <= 10000000) {
            CompanyTurnoverInteval = '0 - 10 000 000';
        } else if (expected_turnover >= 10000001 && expected_turnover <= 40000000) {
            CompanyTurnoverInteval = '10 000 000 - 40 000 000';
        } else if (expected_turnover >= 40000001 && expected_turnover <= 100000000) {
            CompanyTurnoverInteval = '40 000 001 - 100 000 000';
        } else {
            CompanyTurnoverInteval = '100 000 000';
        }
	
        Application_Product_CAF__c appCAF = [SELECT Id, Company_turnover__c,Business_status__c FROM Application_Product_CAF__c WHERE Id =: appId];//idVSAppProdCPFMap.get(appId);
        if(appCAF != null){
            appCAF.Company_turnover__c	= CompanyTurnoverInteval;
            appCAF.Business_status__c = status;
            
            update appCAF;
        }
    }*/
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @param oppLineItemList
    * @param idVSOppMap
    * @param idVSAccMap
    * @param idVSAppProdCPFMap

    */
	public static void updateCompanyTurnover2 (String oppId, List<OpportunityLineItem> oppLineItemList,Map<Id,Opportunity> idVSOppMap,Map<Id,Account> idVSAccMap, Map<Id,Application_Product_CAF__c> idVSAppProdCPFMap){
		
        List<Application_Product_CAF__c> listToUpdate = new List<Application_Product_CAF__c>();
        for(OpportunityLineItem oli : oppLineItemList){
            String CompanyTurnoverInteval 	= '';
            Integer expected_turnover 		= 0;
            String status					= '';
            
            Opportunity opp = idVSOppMap.get(oppId.startsWith('006') ? oppId : oli.OpportunityId);//new OpportunitiesSelector().selectByOpportunityId(oppId)[0];
            Account acc = idVSAccMap.get(opp.AccountId);
            Application_Product_CAF__c appCAF1  = idVSAppProdCPFMap.get(oli.Application_Product_CAF__c);
            expected_turnover = Integer.valueOf(opp.Annual_turnover__c);
            if(appCAF1 != null){
                if(appCAF1.Business_status__c == 'Active' || appCAF1.Business_status__c == 'Not Active' || acc.FinServ__Status__c != ''){
                    status 				= (acc.FinServ__Status__c == 'Active')? 'Active':'Not Active';
                }else{
                    status = appCAF1.Business_status__c;
                }
            }
            String existing_customer	= (acc.CIF__c !='')? 'No':'Yes';
            
            if (expected_turnover >= 0 && expected_turnover <= 10000000) {
                CompanyTurnoverInteval = '0 - 10 000 000';
            } else if (expected_turnover >= 10000001 && expected_turnover <= 40000000) {
                CompanyTurnoverInteval = '10 000 000 - 40 000 000';
            } else if (expected_turnover >= 40000001 && expected_turnover <= 100000000) {
                CompanyTurnoverInteval = '40 000 001 - 100 000 000';
            } else {
                CompanyTurnoverInteval = '100 000 000';
            }
            
            //Application_Product_CAF__c appCAF = [SELECT Id, Company_turnover__c,Business_status__c FROM Application_Product_CAF__c WHERE Id =: appId];//idVSAppProdCPFMap.get(appId);
            if(appCAF1 != null){
                appCAF1.Company_turnover__c	= CompanyTurnoverInteval;
                appCAF1.Business_status__c = status;
                listToUpdate.add(appCAF1);
                //update appCAF;
            }
        }
        if(listToUpdate != null){
            update listToUpdate;
        }
    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param recId
    * @param appId

    */
    public static void updateFinancedAmount (String recId, String appId) { //Newly added parameter to avoid  SOQL issue

        Application_Product_CAF__c appCAF 	= [SELECT Id, Financed_amount__c,Vehicle_Make_Model__c FROM Application_Product_CAF__c WHERE Id =: appId];//idVSAppProdCPFMap.get(appId);
        OpportunityLineItem oppProduct 		= new OpportunityLineItemsSelector().selectById(recId)[0];//oli;
        if(appCAF != null){
            oppProduct.Financed_Amount__c	= double.valueOf(appCAF.Financed_amount__c);
            oppProduct.Article_Description__c	= appCAF.Vehicle_Make_Model__c;
        }
        try{

            update oppProduct;

        }catch(exception e){

            String msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);

        }



    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppLineItemList
    * @param idVSAppProdCPFMap

    */
    public static void updateFinancedAmount2 (List<OpportunityLineItem> oppLineItemList,Map<Id,Application_Product_CAF__c> idVSAppProdCPFMap) { //Newly added parameter to avoid  SOQL issue

        for(OpportunityLineItem oli : oppLineItemList){
            Application_Product_CAF__c appCAF 	= idVSAppProdCPFMap.get(oli.Application_Product_CAF__c);
            //OpportunityLineItem oppProduct 		= new OpportunityLineItemsSelector().selectById(recId)[0];//oli;
            if(appCAF != null){
                oli.Financed_Amount__c	= double.valueOf(appCAF.Financed_amount__c);
                oli.Article_Description__c	= appCAF.Vehicle_Make_Model__c;
            }
        }
        try{
            update oppLineItemList;
        }catch(exception e){
            String msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
            System.debug('msg:'+ msg);
        }
    }
     /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @param SWQR
    * @param comments
    * @return submitForApproval

    */
    @AuraEnabled
    public static String submitForApproval(Id oppId, String SWQR, String comments)
    {
        String msg 	= '';
        boolean pass = false;
        String approvalComments;
        //Opportunity opp = [SELECT Id, Sanctioner_work_queue_regions__c FROM Opportunity WHERE Id =: oppId];
        Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(oppId)[0];

        if(opp != NULL){
            opp.Sanctioner_work_queue_regions__c = SWQR;
            opp.stageName = 'Sanctioning';
            pass = true;
        }else{
            msg 	= 'Empty field!!';
        }
  
        if(comments == null || comments == ''){
        approvalComments = 'Submitted for Sanctioning';}
        else{approvalComments = comments;}

        if(pass){
            // Create an approval request for the Opportunity
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments(approvalComments);
            req1.setObjectId(opp.id);

            // Submit the approval request for the Opportunity
            Approval.ProcessResult result;

            try{

                // submit the approval request for processing
                result = Approval.process(req1);
                update opp;

                pass =true;
                msg = 'Record Submitted for Sanctioning';


            }catch(Exception e){
                // display if the reqeust was successful
                String msgErr = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
                msg = 'No approval process has been setup yet.';
                pass =false;
                System.debug('msgError>>'+msgErr);
            }

        }

        return '{"pass":"'+pass+'","msg":"'+msg+'"}';

    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param oppId
    * @param stage
    * @return updateOpportunityStage

    */
    @AuraEnabled
    public static String updateOpportunityStage(Id oppId, String stage)
    {
        opportunity opp = new opportunity();
        opp =  new OpportunitiesSelector().selectByOpportunityId(oppId)[0];
        String msg = '';
        if(opp != NULL){
            try{
                update opp;
                msg = 'Stage updated successfully!';
            }catch(Exception e){

                msg = 'Errors:\n'+e.getLineNumber()+'\n'+e.getMessage();
                System.debug('Error from updateOpportunityStage :'+msg);

            }
        }

        return msg;
    }

/** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param caseId
    * @return updateOpportunityStage
    */
    @AuraEnabled
    public static OpportunityLineItem getApplicationId(String caseId){
        Application_Product_CAF__c application = [Select Id, Case__c from Application_Product_CAF__c where Case__c =:caseId ];
        OpportunityLineItem oppLine = new OpportunityLineItemsSelector().byApplicationProductCAF(application.Id);

        system.debug('oppLine '+oppLine);
        return oppLine;
    }
    /** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param accId
    * @return updateOpportunityStage
    */
    @AuraEnabled
    public static Account queryAccountData(String accId){
        system.debug(' accId '+accId);
       return [Select Id,Vendor_Code__c From Account Where Id =:accId LIMIT 1];
    }
    /**
     @description getVAPPremiumData
	 @param productCode
	 @param oppLineId
	 @return
     */
    @AuraEnabled
    public static Map<String,Object> getVAPPremiumData(String productCode,String oppLineId){
        Map<String,Object> dataMap = new Map<String,Object>();
        Decimal vapPremium = 0;
        Decimal purchaseAmount = 0;
        Decimal vatAmount = 0;
        Decimal initiationFee = 0;
        Decimal depositeAmount = 0;
        Decimal dealerCash = 0;
        Decimal sumInsured = 0;
        Decimal extrasAdditionalFee = 0;
        Decimal vapPremiumSum = 0;
        
        Product2 product = [Select Id,Name,ProductCode,(Select Id,Fee_Type__c,Fee_Amount_Fixed__c,Fee_Amount_Percent__c,Ad_Valorum_Unit__c From Price_Scheme_Product_Entries__r) From Product2 Where ProductCode =: productCode LIMIT 1]; 
        System.debug('product '+product);
        System.debug('oppId '+oppLineId);
        if(product != null){
            OpportunityLineItem oppLineItem = [Select Id,Application_Product_CAF__r.Purchase_price_amount_excl_VAT__c,Application_Product_CAF__r.VAT_amount__c,Application_Product_CAF__r.Initiation_fee__c,Application_Product_CAF__r.Deposit_amount__c,Application_Product_CAF__r.Dealer_Cash_deposit_amount__c From OpportunityLineItem Where Id =: oppLineId LIMIT 1 ];
            purchaseAmount = oppLineItem.Application_Product_CAF__r.Purchase_price_amount_excl_VAT__c;
            vatAmount = oppLineItem.Application_Product_CAF__r.VAT_amount__c;
            initiationFee = oppLineItem.Application_Product_CAF__r.Initiation_fee__c;
            depositeAmount = oppLineItem.Application_Product_CAF__r.Deposit_amount__c;
            dealerCash = oppLineItem.Application_Product_CAF__r.Dealer_Cash_deposit_amount__c;
            System.debug('oppLineItemList '+oppLineItem);
            List<OpportunityLineItem> oppProduct = new List<OpportunityLineItem>();
            oppProduct = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oppLineId, 'Extras');
            if(oppProduct != null){
                for(OpportunityLineItem OppExtras : oppProduct){
                    if(OppExtras.Additional_Fee_Amount__c!=null){
                        extrasAdditionalFee = extrasAdditionalFee + Decimal.valueof(OppExtras.Additional_Fee_Amount__c);
                    }
                }
            }
            system.debug('extrasAdditionalFee' +extrasAdditionalFee);
            oppProduct = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oppLineId, 'VAPs');
            if(oppProduct != null){
                for(OpportunityLineItem OppVAP : oppProduct){
                    if(OppVAP.Product_name_Product_code__c!=null){
                        if(OppVAP.Product_name_Product_code__c.Contains('Warranty') || OppVAP.Product_name_Product_code__c.Contains('MBW'))
                        vapPremiumSum = vapPremiumSum + OppVAP.VAP_Premium__c;
                    }
                }
            }
            System.debug('product.Price_Scheme_Product_Entries__r '+product.Price_Scheme_Product_Entries__r);
            sumInsured = 
                ((purchaseAmount != null ? purchaseAmount : 0) + 
                    (vatAmount != null ? vatAmount : 0) + 
                        (extrasAdditionalFee != null ? extrasAdditionalFee : 0) + 
                            (vapPremiumSum != null ? vapPremiumSum : 0) + 
                                (initiationFee != null ? initiationFee : 0) -
                                    ((depositeAmount != null ? depositeAmount : 0) + (dealerCash != null ? dealerCash : 0 )));
                        system.debug('sumInsured' + sumInsured);
            if(product.Price_Scheme_Product_Entries__r != null && product.Price_Scheme_Product_Entries__r.size() > 0){
                Price_Scheme_Product_Entry__c pscpEntry = product.Price_Scheme_Product_Entries__r[0];
                
                List<Pricing_Tier__c> pricingTierList = [Select Id,Fee_Amount_Fixed__c,To__c,From__c From Pricing_Tier__c Where Price_Scheme_Product_Entry__c =: pscpEntry.Id ];
                System.debug('pricingTierList '+pricingTierList);
                if(pscpEntry.Fee_Type__c == 'Fixed'){
                    vapPremium = pscpEntry.Fee_Amount_Fixed__c;
                }
                if(pscpEntry.Fee_Type__c == 'Percentage'){
                    if(pscpEntry.Ad_Valorum_Unit__c != null && pscpEntry.Ad_Valorum_Unit__c > 0){
                        vapPremium = (pscpEntry.Fee_Amount_Percent__c/pscpEntry.Ad_Valorum_Unit__c) * sumInsured;//oppLineItem.Application_Product_CAF__r.Purchase_price_amount_excl_VAT__c;
                    }else{
                        vapPremium = pscpEntry.Fee_Amount_Percent__c * sumInsured;//oppLineItem.Application_Product_CAF__r.Purchase_price_amount_excl_VAT__c;
                    }
                }
                if(pscpEntry.Fee_Type__c == 'Tiered'){
                    for(Pricing_Tier__c priceTier : pricingTierList){
                        /*if(oppLineItem.Application_Product_CAF__r.Purchase_price_amount_excl_VAT__c >= priceTier.From__c && 
                           oppLineItem.Application_Product_CAF__r.Purchase_price_amount_excl_VAT__c <= priceTier.To__c){
                               vapPremium = priceTier.Fee_Amount_Fixed__c;
                           }*/
                        if(sumInsured >= priceTier.From__c && 
                           sumInsured <= priceTier.To__c){
                               vapPremium = priceTier.Fee_Amount_Fixed__c;
                           }
                    }
                }
            }
        }
        dataMap.put('VAPPREMIUM',vapPremium);
        dataMap.put('SUMINSURED',sumInsured);
        return dataMap;//vapPremium;
        //Purchase_price_amount_excl_VAT__c = Purchase_price_amount_excl_VAT__c + VAT_amount__c  + Sum of extras + sum of VAP (if product name contains(Warranties) && product name contains(MBW)) + Initiation_fee__c-(Deposit_amount__c + Dealer_Cash_deposit_amount__c)
    }

/** 
    * @description Method to format date for the approval history
    * @author: Masechaba Maseli
    * @Date: 08/01/2021
    * @param applicationId
    */
    @AuraEnabled
    public static void updateCaseStatus(String applicationId){

        Application_Product_CAF__c aPC = new ApplicationProductCAFSelector().selectByAppProdCAFId(applicationId);

        Case fulfilmentcase = new Case();
        fulfilmentcase.Status ='Complete Contract';
        fulfilmentCase.Id = aPC.Case__c;
        try{

            upsert fulfilmentcase;
            aPC.Case__c = fulfilmentcase.Id;
            update aPC;
        }catch (Exception exp){
            system.debug('Exception---'+exp.getMessage());
        }
    }
    /** 
    * @description Method to create duplicate selected application with chosen sections
    * @author: Jaco de Lange
    * @date: 2021-03-02
    * @return
    * @param appProdCAFId
    * @param oppId
    * @param assetArt
    * @param shortTerm
    * @param contrDet
    * @param contrExt
    * @param valueAddProd
    * @param landDetVal
    * @param dealerDet
    * @param structure
    * @param credAppDet
    * @param prodInfo
    * @param documents
    * @param NoOfDup
    */
	@AuraEnabled
    public static String duplicateApplication(string appProdCAFId, string oppId, boolean assetArt, boolean shortTerm, boolean contrDet, boolean contrExt, boolean valueAddProd, boolean landDetVal, boolean dealerDet, boolean structure, boolean credAppDet, boolean prodInfo, boolean documents, String NoOfDup){       
        System.debug('landDetVal '+landDetVal);
        String returnmsg = '';
            if (appProdCAFId!=null && appProdCAFId!=''){
                Application_Product_CAF__c aPC = new ApplicationProductCAFSelector().selectByAppProdCAFId(appProdCAFId);

                if (NoOfDup!=null){
                    Integer dupNoInt = Integer.ValueOf(NoOfDup); 
						List<Application_Product_CAF__c> dupProdCAFAppList = new List<Application_Product_CAF__c>();
                        for (Integer i = 0; i < dupNoInt ; i++) {
                            Application_Product_CAF__c dupProdCAFApp = new Application_Product_CAF__c();
                            
                                if (aPC!=null){

                                    if (assetArt || shortTerm || contrDet || landDetVal || dealerDet || structure || credAppDet || prodInfo || contrExt || valueAddProd || documents){
                                        dupProdCAFApp.Client_Details__c = aPC.Client_Details__c!=null ? aPC.Client_Details__c : '';
                                    }
                
                                    //Asset/Article Details
                                    if (assetArt){ 
                                        dupProdCAFApp.Asset_Type__c = aPC.Asset_Type__c!=null ? aPC.Asset_Type__c : '';
                                        dupProdCAFApp.Article_Type__c = aPC.Article_Type__c!=null ? aPC.Article_Type__c : '';
                                        dupProdCAFApp.Year_First_Registered__c = aPC.Year_First_Registered__c!=null ? aPC.Year_First_Registered__c : 0;
                                        dupProdCAFApp.Mileage__c = aPC.Mileage__c!=null ? aPC.Mileage__c : 0;
                                        dupProdCAFApp.Registration_Number__c = aPC.Registration_Number__c!=null ? aPC.Registration_Number__c : '';
                                        dupProdCAFApp.VIN_Chassis_Number__c = aPC.VIN_Chassis_Number__c!=null ? aPC.VIN_Chassis_Number__c : '';
                                        dupProdCAFApp.Engine_Number__c = aPC.Engine_Number__c!=null ? aPC.Engine_Number__c : '';
                                        dupProdCAFApp.Serial_Number__c = aPC.Serial_Number__c!=null ? aPC.Serial_Number__c : '';
                                        dupProdCAFApp.Vehicle_Make_Model__c = aPC.Vehicle_Make_Model__c!=null ? aPC.Vehicle_Make_Model__c : '';
                                    }
                                    
                                    //Short Term Insurance
                                    if (shortTerm){
                                        dupProdCAFApp.Do_you_have_short_term_insurance__c = aPC.Do_you_have_short_term_insurance__c;
                                        dupProdCAFApp.Insurance_Policy_Number__c = aPC.Insurance_Policy_Number__c!=null ? aPC.Insurance_Policy_Number__c : '';
                                        dupProdCAFApp.Insurance_Company_Name__c = aPC.Insurance_Company_Name__c!=null ? aPC.Insurance_Company_Name__c : '';
                                    }

                                    //Contract Details
                                    if (contrDet){
                                        dupProdCAFApp.Contract_Type__c = aPC.Contract_Type__c!=null ? aPC.Contract_Type__c : '';
                                        dupProdCAFApp.Purchase_price_amount_excl_VAT__c = aPC.Purchase_price_amount_excl_VAT__c!=null ? aPC.Purchase_price_amount_excl_VAT__c : null;
                                        dupProdCAFApp.VAT_amount__c = aPC.VAT_amount__c!=null ? aPC.VAT_amount__c : 0;
                                        dupProdCAFApp.VAT_Indicator__c = aPC.VAT_Indicator__c!=null ? aPC.VAT_Indicator__c : '';
                                        dupProdCAFApp.Commercial_document_fee__c = aPC.Commercial_document_fee__c!=null ? aPC.Commercial_document_fee__c : null;
                                        dupProdCAFApp.Service_fee_incl_VAT__c = aPC.Service_fee_incl_VAT__c !=null ? aPC.Service_fee_incl_VAT__c : 0;
                                        dupProdCAFApp.Initiation_fee__c = aPC.Initiation_fee__c!=null ? aPC.Initiation_fee__c : null;
                                        dupProdCAFApp.Deposit_amount__c = aPC.Deposit_amount__c!=null ? aPC.Deposit_amount__c : null;   
                                        dupProdCAFApp.Dealer_Trade_in_amount__c = aPC.Dealer_Trade_in_amount__c!=null ? aPC.Dealer_Trade_in_amount__c : 0;
                                        dupProdCAFApp.Dealer_Cash_deposit_amount__c = aPC.Dealer_Cash_deposit_amount__c!=null ? aPC.Dealer_Cash_deposit_amount__c : 0;
                                        dupProdCAFApp.Residual_Value__c = aPC.Residual_Value__c!=null ? aPC.Residual_Value__c : null; 
                                        dupProdCAFApp.Payment_frequency__c = aPC.Payment_frequency__c!=null ? aPC.Payment_frequency__c : '';
                                        dupProdCAFApp.Term_in_months__c = aPC.Term_in_months__c!=null ? aPC.Term_in_months__c : null;
                                        dupProdCAFApp.Interest_rate__c = aPC.Interest_rate__c!=null ? aPC.Interest_rate__c : null;
                                        dupProdCAFApp.Fixed_or_linked__c = aPC.Fixed_or_linked__c!=null ? aPC.Fixed_or_linked__c : '';
                                        dupProdCAFApp.Commencement_Date__c = aPC.Commencement_Date__c!=null ? aPC.Commencement_Date__c : null;
                                        dupProdCAFApp.X1st_payment_date__c = aPC.X1st_payment_date__c!=null ? aPC.X1st_payment_date__c : null;
                                        dupProdCAFApp.Joint_venture_alliance_code__c = aPC.Joint_venture_alliance_code__c!=null ? aPC.Joint_venture_alliance_code__c : '';
                                        dupProdCAFApp.Statement_delivery_method__c = aPC.Statement_delivery_method__c!=null ? aPC.Statement_delivery_method__c : '';
                                        dupProdCAFApp.Contract_Email__c = aPC.Contract_Email__c!=null ? aPC.Contract_Email__c : '';
                                        dupProdCAFApp.Pay_DIC_to_dealer__c = aPC.Pay_DIC_to_dealer__c;
                                    }

                                    //Landlord Waiver Details
                                    if (landDetVal){
                                        dupProdCAFApp.Landlord_Full_Name__c = aPC.Landlord_Full_Name__c!=null ? aPC.Landlord_Full_Name__c : '';
                                        dupProdCAFApp.Landlord_Address__c = aPC.Landlord_Address__c!=null ? aPC.Landlord_Address__c : '';
                                        dupProdCAFApp.Landlord_Waiver__c = aPC.Landlord_Waiver__c!=null ? aPC.Landlord_Waiver__c : '';
                                    }

                                    //Dealer Details
                                    if (dealerDet){
                                        dupProdCAFApp.Dealer_Trading_name_or_code__c = aPC.Dealer_Trading_name_or_code__c!=null ? aPC.Dealer_Trading_name_or_code__c : '';
                                        dupProdCAFApp.Dealer_Code__c = aPC.Dealer_Code__c!=null ? aPC.Dealer_Code__c : '';
                                        dupProdCAFApp.Sales_person_full_name__c = aPC.Sales_person_full_name__c!=null ? aPC.Sales_person_full_name__c : '';
                                        dupProdCAFApp.Contact_number__c = aPC.Contact_number__c!=null ? aPC.Contact_number__c : '';
                                        dupProdCAFApp.Email_address__c = aPC.Email_address__c!=null ? aPC.Email_address__c : '';
                                    }

                                    //Structure
                                    if (structure){
                                        dupProdCAFApp.VAT_Pay_Back__c = aPC.VAT_Pay_Back__c!=null ? aPC.VAT_Pay_Back__c : '';
                                        dupProdCAFApp.Skip_payments__c = aPC.Skip_payments__c!=null ? aPC.Skip_payments__c : '';
                                        dupProdCAFApp.Skip_months__c = aPC.Skip_months__c!=null ? aPC.Skip_months__c : '';
                                        dupProdCAFApp.Skip_months_from__c = aPC.Skip_months_from__c!=null ? aPC.Skip_months_from__c : '';
                                        dupProdCAFApp.Skip_months_to__c = aPC.Skip_months_to__c!=null ? aPC.Skip_months_to__c : '';
                                        dupProdCAFApp.Debit_order__c = aPC.Debit_order__c!=null ? aPC.Debit_order__c : '';    
                                        dupProdCAFApp.Bank_name__c = aPC.Bank_name__c!=null ? aPC.Bank_name__c : '';
                                        dupProdCAFApp.Account_holder__c = aPC.Account_holder__c!=null ? aPC.Account_holder__c : '';
                                        dupProdCAFApp.Account_number__c = aPC.Account_number__c!=null ? aPC.Account_number__c : null;
                                        dupProdCAFApp.Account_type__c = aPC.Account_type__c!=null ? aPC.Account_type__c : '';
                                        dupProdCAFApp.Branch_clearing_code__c = aPC.Branch_clearing_code__c!=null ? aPC.Branch_clearing_code__c : null;
                                    }

                                    //Credit Application Details
                                    if (credAppDet){
                                        dupProdCAFApp.Credit_Line__c = aPC.Credit_Line__c!=null ? aPC.Credit_Line__c : '';
                                        dupProdCAFApp.Is_sanctioning_required__c = aPC.Is_sanctioning_required__c!=null ? aPC.Is_sanctioning_required__c : '';
                                        dupProdCAFApp.Select_cheque_account__c = aPC.Select_cheque_account__c!=null ? aPC.Select_cheque_account__c : '';
                                        dupProdCAFApp.Profit_margin__c = aPC.Profit_margin__c!=null ? aPC.Profit_margin__c : '';
                                        dupProdCAFApp.Debt_levels__c = aPC.Debt_levels__c!=null ? aPC.Debt_levels__c : '';
                                        dupProdCAFApp.Number_of_company_shareholders__c = aPC.Number_of_company_shareholders__c!=null ? aPC.Number_of_company_shareholders__c : null;
                                        dupProdCAFApp.Article_secure__c = aPC.Article_secure__c!=null ? aPC.Article_secure__c : '';
                                        dupProdCAFApp.Indicator_Insolvent__c = aPC.Indicator_Insolvent__c!=null ? aPC.Indicator_Insolvent__c : '';
                                        dupProdCAFApp.Indicator_ITC_Consent__c = aPC.Indicator_ITC_Consent__c!=null ? aPC.Indicator_ITC_Consent__c : '';
                                        dupProdCAFApp.Is_this_an_enterprise_customer__c = aPC.Is_this_an_enterprise_customer__c!=null ? aPC.Is_this_an_enterprise_customer__c : '';
                                        dupProdCAFApp.Existing_Absa_finance_to_be_settled__c = aPC.Existing_Absa_finance_to_be_settled__c!=null ? aPC.Existing_Absa_finance_to_be_settled__c : '';
                                        dupProdCAFApp.Customer_TFL__c = aPC.Customer_TFL__c!=null ? aPC.Customer_TFL__c : null;
                                        dupProdCAFApp.Business_status__c = aPC.Business_status__c!=null ? aPC.Business_status__c : '';
                                        dupProdCAFApp.Loan_value_less_than_110__c = aPC.Loan_value_less_than_110__c!=null ? aPC.Loan_value_less_than_110__c : '';
                                        dupProdCAFApp.Age_of_article_less_than_10_years_at_the__c = aPC.Age_of_article_less_than_10_years_at_the__c!=null ? aPC.Age_of_article_less_than_10_years_at_the__c : '';
                                        dupProdCAFApp.Total_potential_exposure_less_than_1_5__c = aPC.Total_potential_exposure_less_than_1_5__c!=null ? aPC.Total_potential_exposure_less_than_1_5__c : '';
                                        dupProdCAFApp.Application_amount_less_than_15_of_turn__c = aPC.Application_amount_less_than_15_of_turn__c!=null ? aPC.Application_amount_less_than_15_of_turn__c : '';   
                                        dupProdCAFApp.Agree_Term_and_Condition__c = aPC.Agree_Term_and_Condition__c!=null ? aPC.Agree_Term_and_Condition__c : '';
                                        dupProdCAFApp.principals_clear_bureau__c = aPC.principals_clear_bureau__c!=null ? aPC.principals_clear_bureau__c : '';
                                        dupProdCAFApp.Business_clear_bureau_data__c = aPC.Business_clear_bureau_data__c!=null ? aPC.Business_clear_bureau_data__c : '';
                                        dupProdCAFApp.principals_favourable__c = aPC.principals_favourable__c!=null ? aPC.principals_favourable__c : '';
                                        dupProdCAFApp.customer_business_favourable__c = aPC.customer_business_favourable__c!=null ? aPC.customer_business_favourable__c : '';
                                    }

                                    //Product Information
                                    if (prodInfo){
                                        system.debug ('CAF Site Code :: ' + aPC.CAF_sitecode__c);
                                        dupProdCAFApp.Type_of_request__c = aPC.Type_of_request__c!=null ? aPC.Type_of_request__c : '';
                                        dupProdCAFApp.CAF_sitecode__c = aPC.CAF_sitecode__c!=null  ? aPC.CAF_sitecode__c : null;
                                        dupProdCAFApp.Absa_site_code__c = aPC.Absa_site_code__c!=null ? aPC.Absa_site_code__c : '';
                                        dupProdCAFApp.Package_name__c = aPC.Package_name__c!=null ? aPC.Package_name__c : '';
                                        dupProdCAFApp.Segment__c = aPC.Segment__c!=null ? aPC.Segment__c : '';
                                        dupProdCAFApp.Sales_branch__c = aPC.Sales_branch__c!=null ? aPC.Sales_branch__c : '';
                                        dupProdCAFApp.Campaign_name__c = aPC.Campaign_name__c!=null ? aPC.Campaign_name__c : '';
                                        dupProdCAFApp.Approved_Dealer__c = aPC.Approved_Dealer__c!=null ? aPC.Approved_Dealer__c : '';
                                        dupProdCAFApp.Mandate_holder__c = aPC.Mandate_holder__c!=null ? aPC.Mandate_holder__c : '';
                                        dupProdCAFApp.Marketer_BDO_User__c = aPC.Marketer_BDO_User__c!=null ? aPC.Marketer_BDO_User__c: null;
                                    }
									dupProdCAFAppList.add(dupProdCAFApp);
                                }                          
                        }
                    
                    try {
                        insert dupProdCAFAppList;
                        
                        Product2 cafProduct = new ProductsSelector().selectByName('CAF', 1);
                        PricebookEntry cafPBEntry = new PriceBookEntriesSelector().selectByProduct2Id(cafProduct.Id);
                        
                        List<OpportunityLineItem> oppProductList = new List<OpportunityLineItem>();
                        
                        for(Application_Product_CAF__c appProdCAF : dupProdCAFAppList){
                            OpportunityLineItem oppProduct 	= new OpportunityLineItem(
                                OpportunityId = oppId,
                                Application_Product_CAF__c = appProdCAF.Id,
                                Quantity = 1,
                                TotalPrice = 1,
                                Type__c = 'CAF',
                                PricebookEntryId= cafPBEntry.Id );
                            oppProductList.add(oppProduct);
                        }
                        
                        insert oppProductList;
                        
                        
                        //Contract Extras
                        if (contrExt){
                            
                            //get the line item Id for application product caf
                            OpportunityLineItem oliRecEx = new OpportunityLineItemsSelector().byApplicationProductCAF(appProdCAFId);
                            List<OpportunityLineItem> oppExtrasLineItem = new List<OpportunityLineItem>();
                            List<OpportunityLineItem> addExtrasOppLineItem_ALL = new List<OpportunityLineItem>();
                            
                            oppExtrasLineItem = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oliRecEx.Id, 'Extras');
                            
                            for(OpportunityLineItem oppProd : oppProductList){
                                List<OpportunityLineItem> addExtrasOppLineItem = new List<OpportunityLineItem>();
                                if (!oppExtrasLineItem.isEmpty() && oppExtrasLineItem.size() > 0){
                                    
                                    for (OpportunityLineItem oliEx : oppExtrasLineItem){
                                        OpportunityLineItem oppLineProduct = new OpportunityLineItem(
                                            OpportunityId = oliEx.OpportunityId,
                                            Parent_Opportunity_Line_Item_Id__c = oppProd.Id,
                                            Additional_Fee_Amount__c = oliEx.Additional_Fee_Amount__c,
                                            Type_Extra__c = oliEx.Type_Extra__c,
                                            Other_Extra_Description__c = oliEx.Other_Extra_Description__c,    
                                            Quantity = 1,
                                            TotalPrice = 1,
                                            Type__c = 'Extras',
                                            PricebookEntryId = oliEx.PricebookEntryId );
                                        addExtrasOppLineItem.add (oppLineProduct);
                                    }
                                }
                                addExtrasOppLineItem_ALL.addAll(addExtrasOppLineItem);
                            }
                            if (!addExtrasOppLineItem_ALL.IsEmpty() && addExtrasOppLineItem_ALL.size() > 0){
                                insert addExtrasOppLineItem_ALL;
                            } 
                        }
                        
                        //Value Added Products
                        if (valueAddProd){
                            
                            //get the line item Id for application product caf
                            OpportunityLineItem oliRecVAP = new OpportunityLineItemsSelector().byApplicationProductCAF(appProdCAFId);
                            
                            List<OpportunityLineItem> oppVAPsLineItem = new List<OpportunityLineItem>();
                            List<OpportunityLineItem> addVAPsOppLineItem_ALL = new List<OpportunityLineItem>();
                            oppVAPsLineItem = new OpportunityLineItemsSelector().selectByParentOppIdAndType(oliRecVAP.Id, 'VAPs');
                            
                            for(OpportunityLineItem oppProd : oppProductList){
                                List<OpportunityLineItem> addVAPsOppLineItem = new List<OpportunityLineItem>();
                                
                                if (!oppVAPsLineItem.isEmpty() && oppVAPsLineItem.size() > 0){
                                    
                                    for (OpportunityLineItem oliVap : oppVAPsLineItem){
                                        OpportunityLineItem oppLineProduct = new OpportunityLineItem(
                                            OpportunityId = oliVap.OpportunityId,
                                            Parent_Opportunity_Line_Item_Id__c = oppProd.Id,
                                            Product_name_Product_code__c = oliVap.Product_name_Product_code__c,
                                            Scheme_Code__c = oliVap.Scheme_Code__c,
                                            Vendor_Code__c = oliVap.Vendor_Code__c,
                                            Insurance_Company__c = oliVap.Insurance_Company__c,  
                                            Number_of_weeks_cover_selected__c = oliVap.Number_of_weeks_cover_selected__c,  
                                            Rand_value_per_week__c = oliVap.Rand_value_per_week__c,
                                            VAP_Premium__c = oliVap.VAP_Premium__c, 
                                            Quantity = 1,
                                            TotalPrice = 1,
                                            Type__c = 'VAPs',
                                            PricebookEntryId = oliVap.PricebookEntryId );
                                        addVAPsOppLineItem.add (oppLineProduct);
                                    }
                                }
                                addVAPsOppLineItem_ALL.addAll(addVAPsOppLineItem);
                            }
                            if (!addVAPsOppLineItem_ALL.IsEmpty() && addVAPsOppLineItem_ALL.size() > 0){
                                insert addVAPsOppLineItem_ALL;
                            }	
                        }	
                        //Documents	
                        if(documents == true ){	
                        System.debug(' INN');	
                        List<Document__c> docListToInsert_ALL = new List<Document__c>();	
                        List<Document__c> docList = new List<Document__c>();	
                        System.debug('appProdCAFId '+appProdCAFId);	
                        docList = [Select Id,Name,Type__c,ECM_Type__c,Document_Status__c,File_Id__c,Opportunity__c,Application_Product_CAF__c,Reference__c,Application_Product__c From Document__c Where Application_Product_CAF__c =: appProdCAFId];	
                        System.debug('docList '+docList);	
                        if(docList != null && docList.size() > 0){	
                        for(Application_Product_CAF__c oppProd : dupProdCAFAppList){	
                        List<Document__c> docListToInsert = new List<Document__c>();	
                        for(Document__c doc : docList){	
                        Document__c docNew =  new Document__c();	
                        docNew.Application_Product_CAF__c = oppProd.Id;	
                        //doc.Id = null;	
                        docNew.Name = doc.Name;	
                        docNew.Type__c = doc.Type__c;	
                        docNew.ECM_Type__c = doc.ECM_Type__c;	
                        docNew.Document_Status__c = doc.Document_Status__c;	
                        docNew.File_Id__c = doc.File_Id__c;	
                        //docNew.Information__c = doc.Information__c;	
                        docNew.Opportunity__c = doc.Opportunity__c;	
                        docNew.Reference__c = doc.Reference__c;	
                        docNew.Application_Product__c = doc.Application_Product__c;	
                        docListToInsert.add(docNew);	
                        }	
                        if(docListToInsert != null && docListToInsert.size() > 0){	
                        docListToInsert_ALL.addAll(docListToInsert);	
                        }	
                        }	
                        System.debug('docListToInsert_ALL' +docListToInsert_ALL);	
                        if(docListToInsert_ALL != null && docListToInsert_ALL.size() > 0){	
                        insert docListToInsert_ALL;	
                        }
                            }
                            
                        }
                        returnmsg = 'Successfully duplicated applications.';     
                    }
                    catch (Exception ex){
                        returnmsg = 'Errors while duplicating applications :\n'+ex.getLineNumber()+'\n'+ex.getMessage();
                    }
                }
            }
        return returnmsg;
    }  
}