/**
 * @description       : Utilities class for GetRiskProfileClient service
 * @author            : Srikanth N : Absa
 * @last modified on  : 2021-11-16
 * @last modified by  : mohammedjunaid.usman@absa.africa
**/

  public class GetRiskProfileClient_IU_v2 {
    
    /**
    * @description 
    * @author Srikanth N : Absa 
    * @param accountP 
    * @param userIdP 
    * @param oli 
    * @return GetRiskProfileClient_Req_IB_v2 
    **/
    public static GetRiskProfileClient_Req_IB_v2 mapRequestFields(Account accountP,String userIdP,List<OpportunityLineItem> oli){
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        String clientTypeGrpTranslated;
        if(accountP.Client_Group__c == 'Non Individual'){
            clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountP.Client_Group__c.replace('Non Individual', 'Non-Individual'), StringConstants.OUTBOUND_RECORD_TYPE);
            //System.debug('====>'+clientTypeGrpTranslated);
        }
        else {
            clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountP.Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
        }
        String SourceOfIncomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Source_of_Income__c, StringConstants.OUTBOUND_RECORD_TYPE);
        String sbuTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Source_of_Income__c, StringConstants.OUTBOUND_RECORD_TYPE);
         String sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', (accountP.Standard_Industry_SIC_Code__c), StringConstants.OUTBOUND_RECORD_TYPE);
        
        List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable> absaCountryTradeWithList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable>();
        String[] countries = new List<String>();
        if(accountP.Countries_Traded_With__c != null && accountP.Countries_Traded_With__c != ''){
            countries = accountP.Countries_Traded_With__c.split(';');}
  
        List<String> countriesTradedWith = new List<String>();
        for(String country:countries){
            String countryOfTradeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
            GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable absaCountryTradedWithInstance = new GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable();
            absaCountryTradedWithInstance.absaCountriesTradedWith = countryOfTradeTranslated;
            absaCountryTradeWithList.add(absaCountryTradedWithInstance);
            countriesTradedWith.add(countryOfTradeTranslated);
        }
        //System.debug('absaCountryTradeWithList++'+absaCountryTradeWithList); 
        
        List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable> absaCountryOfOperationList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable>();

        String errorMessage = '';
        String oppCreatedBy;
        if(oli.size()>0){
        	oppCreatedBy = oli[0].Opportunity.CreatedBy.Name; } // Added by Masechaba Maseli INC2457268
        GetRiskProfileClient_Req_IB_v2 requestBean = new GetRiskProfileClient_Req_IB_v2();
        GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request requestRiskProfile = new GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request();
        requestRiskProfile.customerTypeCode = '';
        requestRiskProfile.customerStatusCode = '';
        requestRiskProfile.companyForm = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        requestRiskProfile.customerSourceRefID = '0';//'';
        requestRiskProfile.primeBranchID = userP[0].SiteCode__c;
       //requestRiskProfile.channel = 'F2F1';
        requestRiskProfile.channel = oppCreatedBy != null && oppCreatedBy.contains('Virtual Channels Instant Business')?'F2F2': 'F2F1';// Added by Masechaba Maseli INC2457268
        requestRiskProfile.sbu = 'H';
        requestRiskProfile.originatingsystem = 'ESP';
        
        if(accountP.CIF__c != null){
            requestRiskProfile.cifKey = accountP.CIF__c;
        }else{
            requestRiskProfile.cifKey = '';
        }
        requestRiskProfile.userId = userP[0].AB_Number__c;//'EXVP124'
        
        if(accountP.Client_Group__c == 'Non Individual' || accountP.Client_Group__c == 'PARTNERSHIP CLIENT' || accountP.Client_Group__c == 'JOINT AND SEVERAL CLIENT' || accountP.Client_Group__c == 'SOLE TRADER CLIENT'){
            //System.debug('In If'); 
            requestRiskProfile.IncorporationCountryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
            requestRiskProfile.absaCountryTradedWithTable = absaCountryTradeWithList;
            String[] countriesOperation = accountP.Country_of_Operation__c.split(';');
            if(accountP.Country_of_Operation__c != null) {
                for(String country:countriesOperation){
                    String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
                    GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable absaCountryOperation = new GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable();
                    absaCountryOperation.absaCountryOfOperation = countryOfOperationTranslated;
                    absaCountryOfOperationList.add(absaCountryOperation);
                }
                //System.debug('absaCountryOfOperationList++'+absaCountryOfOperationList); 
                requestRiskProfile.absaCountryOfOperationTable = absaCountryOfOperationList;
            }
            
            requestRiskProfile.employmentStatus = '';
            requestRiskProfile.occupation = '';
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__c == null || accountP.CASA_Reference_Number__c == ''? 
                accountP.CASA_Reference_Number__pc : accountP.CASA_Reference_Number__c;
            
            
            if(sicCodeTranslated != null) {
                requestRiskProfile.businessSegment1 = sicCodeTranslated;  
            } else {
                requestRiskProfile.businessSegment1 = '0';
            }
            
        } else if (accountP.Client_Group__c == 'Individual' || accountP.Client_Group__c == 'Estate Client') {
            requestRiskProfile.employmentStatus = '1';
            requestRiskProfile.occupation = '2';
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__pc; 
        } else {
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__pc == null || accountP.CASA_Reference_Number__pc == ''? 
                accountP.CASA_Reference_Number__pc : accountP.CASA_Reference_Number__c; 
            //System.debug('customerSourceUniqueId '+ requestRiskProfile.customerSourceUniqueId); 
            if(sicCodeTranslated != null) {
                requestRiskProfile.businessSegment1 = sicCodeTranslated;  
            } else {
                requestRiskProfile.businessSegment1 = '0';
            }
        }
        
        requestRiskProfile.absaCountryTradedWithTable = absaCountryTradeWithList;
        
       //Start : multiple source of income : 2020-03-16 - Anka Ganta
        List<GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable> absaSourceOfIncomeList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable>();
        if(accountP.Source_of_Income__c != null) {
            String[] sourceOfincomes = accountP.Source_of_Income__c.split(';');
            
            
            for(String srcOfincome:sourceOfincomes){
                String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, srcOfincome, StringConstants.OUTBOUND_RECORD_TYPE);
                GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable absaSourceOfIncomeCls = new GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable();
                absaSourceOfIncomeCls.absaSourceOfIncome = srcOfincomeTranslated;
                //absaSourceOfIncomeCls.absaSourceOfIncome = '';
                absaSourceOfIncomeList.add(absaSourceOfIncomeCls);
            }
        }else {
            GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable absaSourceOfIncomeCls = new GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable();
            absaSourceOfIncomeCls.absaSourceOfIncome = '0';
            absaSourceOfIncomeList.add(absaSourceOfIncomeCls);
        }
		
		requestRiskProfile.absaSourceOfIncomeTable = absaSourceOfIncomeList;
        //End : multiple source of income
        
        List<GetRiskProfileClient_Req_IB_v2.cls_productCodeTable> productCodeClsList = new List<GetRiskProfileClient_Req_IB_v2.cls_productCodeTable>();
       // GetRiskProfileClient_Req_IB_v2.cls_productCodeTable productCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_productCodeTable();
       // Added by Masechaba Maseli INC2457268
        if(oli != null && oli.size() > 0){
            for(OpportunityLineItem olineItems: oli){
                //system.debug('olineItems.Product_Family__c  '+olineItems.Product_Family__c);
                if(olineItems.Product_Family__c != null && olineItems.Product_Family__c != ''){
                if(!olineItems.Product_Family__c.contains('Package')){
                  GetRiskProfileClient_Req_IB_v2.cls_productCodeTable productCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_productCodeTable();
                 productCodeCls.productCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.Risk_ProductCode_STRING, olineItems.Product_Family__c, 
                                                                 StringConstants.OUTBOUND_RECORD_TYPE);
                //system.debug('productCodeCls  '+productCodeCls);
                 productCodeClsList.add(productCodeCls);
                }     
                } }   
            }
       // productCodeCls.productCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.Risk_ProductCode_STRING, oli.Product_Family__c, 
                                                                // StringConstants.OUTBOUND_RECORD_TYPE);
       //productCodeClsList.add(productCodeCls);
        requestRiskProfile.productCodeTable = productCodeClsList;
        List<GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable> subProductCodeList = new List<GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable>();
       // GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable subProductCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable();
               // Added by Masechaba Maseli INC2457268
        if(oli != null && oli.size() > 0){
            for(OpportunityLineItem olineItems: oli){
                if(olineItems.Product_Family__c != null && olineItems.Product_Family__c != ''){
                if(!olineItems.Product_Family__c.contains('Package')){
                     GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable subProductCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable();
                subProductCodeCls.subProductCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.Risk_SubProductCode_STRING, olineItems.product2.Name, 
                                           						StringConstants.OUTBOUND_RECORD_TYPE);
                subProductCodeList.add(subProductCodeCls);
                }     
                } }   
            }else{
            GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable subProductCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable();
                subProductCodeCls.subProductCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.Risk_SubProductCode_STRING, 'REFRESH', 
                                           						StringConstants.OUTBOUND_RECORD_TYPE);
                subProductCodeList.add(subProductCodeCls);
        }
       // subProductCodeCls.subProductCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.Risk_SubProductCode_STRING, oli.product2.Name, 
                                           					//	StringConstants.OUTBOUND_RECORD_TYPE);
       // subProductCodeList.add(subProductCodeCls);
        requestRiskProfile.subProductCodeTable = subProductCodeList;
        requestBean.WQriskProfileClientV7Request = requestRiskProfile;
        requestBean.errorMessage = errorMessage;
        //System.debug('Get Risk Profile: ' + requestBean);
        return requestBean;
    }
    
     // Mapping requestfields for SPM -Haritha 



    /**
    * @description 
    * @author Srikanth N : Absa 
    * @param accountP 
    * @param userIdP 
    * @param opp 
    * @return GetRiskProfileClient_Req_IB_v2 
    **/
    public static GetRiskProfileClient_Req_IB_v2 mapRequestFieldsforSPM(Account accountP,String userIdP,Opportunity opp){
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        String sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', (accountP.Standard_Industry_SIC_Code__c), StringConstants.OUTBOUND_RECORD_TYPE);
        
        List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable> absaCountryTradeWithList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable>();
        
  
        List<String> countriesTradedWith = new List<String>();
        if(accountP.Countries_Traded_With__c != null && accountP.Countries_Traded_With__c != ''){
            String[] countries = accountP.Countries_Traded_With__c.split(';');
        for(String country:countries){
            String countryOfTradeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
            GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable absaCountryTradedWithInstance = new GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable();
            absaCountryTradedWithInstance.absaCountriesTradedWith = countryOfTradeTranslated;
            absaCountryTradeWithList.add(absaCountryTradedWithInstance);
            countriesTradedWith.add(countryOfTradeTranslated);
        }}
        //System.debug('absaCountryTradeWithList++'+absaCountryTradeWithList); 
        
        List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable> absaCountryOfOperationList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable>();

        String errorMessage = '';
        GetRiskProfileClient_Req_IB_v2 requestBean = new GetRiskProfileClient_Req_IB_v2();
        GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request requestRiskProfile = new GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request();
        requestRiskProfile.customerTypeCode = '';
        requestRiskProfile.customerStatusCode = '';
        requestRiskProfile.companyForm = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        requestRiskProfile.customerSourceRefID = '0';//'';
        requestRiskProfile.channel = 'F2F1';
        requestRiskProfile.sbu = '106';
         requestRiskProfile.primeBranchID = '003221';
            
        requestRiskProfile.originatingsystem = 'ESP';
        
        if(accountP.CIF__c != null){
            requestRiskProfile.cifKey = accountP.CIF__c;
        }else{
            requestRiskProfile.cifKey = '';
        }
        requestRiskProfile.userId = userP[0].AB_Number__c;//'EXVP124'
        
        if(accountP.Client_Group__c == 'Non Individual'){
            requestRiskProfile.IncorporationCountryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
            requestRiskProfile.absaCountryTradedWithTable = absaCountryTradeWithList;
            String[] countriesOperation = accountP.Country_of_Operation__c.split(';');
  
        for(String country:countriesOperation){
            String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
            GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable absaCountryOperation = new GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable();
            absaCountryOperation.absaCountryOfOperation = countryOfOperationTranslated;
            absaCountryOfOperationList.add(absaCountryOperation);
        }
        //System.debug('absaCountryOfOperationList++'+absaCountryOfOperationList); 
            requestRiskProfile.absaCountryOfOperationTable = absaCountryOfOperationList;
            requestRiskProfile.employmentStatus = '';
            requestRiskProfile.occupation = '';
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__c;
            
            if(sicCodeTranslated != null) {
                requestRiskProfile.businessSegment1 = sicCodeTranslated;  
            } else {
                requestRiskProfile.businessSegment1 = '0';
            }
            
        } else if (accountP.Client_Group__c == 'Individual') {
            requestRiskProfile.employmentStatus = '1';
            requestRiskProfile.occupation = '2';
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__pc; 
        } else {
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__pc; 
            if(sicCodeTranslated != null) {
                requestRiskProfile.businessSegment1 = sicCodeTranslated;  
            } else {
                requestRiskProfile.businessSegment1 = '0';
            }
        }
        
        requestRiskProfile.absaCountryTradedWithTable = absaCountryTradeWithList;
        
       //Start : multiple source of income : 2020-03-16 - Anka Ganta
        List<GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable> absaSourceOfIncomeList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable>();
		
		
        if(accountP.Source_of_Income__c != null && accountP.Source_of_Income__c != ''){
            String[] sourceOfincomes = accountP.Source_of_Income__c.split(';');
		for(String srcOfincome:sourceOfincomes){
			 String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, srcOfincome, StringConstants.OUTBOUND_RECORD_TYPE);
			GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable absaSourceOfIncomeCls = new GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable();
			absaSourceOfIncomeCls.absaSourceOfIncome = srcOfincomeTranslated;
			//absaSourceOfIncomeCls.absaSourceOfIncome = '';
			absaSourceOfIncomeList.add(absaSourceOfIncomeCls);
        }}
		
		requestRiskProfile.absaSourceOfIncomeTable = absaSourceOfIncomeList;
        //End : multiple source of income
        
        List<GetRiskProfileClient_Req_IB_v2.cls_productCodeTable> productCodeClsList = new List<GetRiskProfileClient_Req_IB_v2.cls_productCodeTable>();
        GetRiskProfileClient_Req_IB_v2.cls_productCodeTable productCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_productCodeTable();
       productCodeCls.productCode = '19';
        productCodeClsList.add(productCodeCls);
        requestRiskProfile.productCodeTable = productCodeClsList;
        List<GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable> subProductCodeList = new List<GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable>();
        GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable subProductCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable();
        subProductCodeCls.subProductCode = 'EQY';
        
        subProductCodeList.add(subProductCodeCls);
        requestRiskProfile.subProductCodeTable = subProductCodeList;
        requestBean.WQriskProfileClientV7Request = requestRiskProfile;
        requestBean.errorMessage = errorMessage;
        //System.debug('Get Risk Profile: ' + requestBean);
        return requestBean;
    }


/**
* @description 
* @author Srikanth N : Absa 
* @param accountP 
* @param userIdP 
* @return GetRiskProfileClient_Req_IB_v2 
**/
public static GetRiskProfileClient_Req_IB_v2 mapCAFRequestFields(Account accountP,String userIdP){
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        String sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', (accountP.Standard_Industry_SIC_Code__c), StringConstants.OUTBOUND_RECORD_TYPE);
        
        List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable> absaCountryTradeWithList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable>();
        String[] countries = accountP.Countries_Traded_With__c.split(';');
  
        List<String> countriesTradedWith = new List<String>();
        for(String country:countries){
            String countryOfTradeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
            GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable absaCountryTradedWithInstance = new GetRiskProfileClient_Req_IB_v2.cls_absaCountryTradedWithTable();
            absaCountryTradedWithInstance.absaCountriesTradedWith = countryOfTradeTranslated;
            absaCountryTradeWithList.add(absaCountryTradedWithInstance);
            countriesTradedWith.add(countryOfTradeTranslated);
        }
        //System.debug('absaCountryTradeWithList++'+absaCountryTradeWithList); 
        
        List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable> absaCountryOfOperationList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable>();

        String errorMessage = '';
        GetRiskProfileClient_Req_IB_v2 requestBean = new GetRiskProfileClient_Req_IB_v2();
        GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request requestRiskProfile = new GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request();
        requestRiskProfile.customerTypeCode = '';
        requestRiskProfile.customerStatusCode = '';
        requestRiskProfile.companyForm = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        requestRiskProfile.customerSourceRefID = '0';//'';
        requestRiskProfile.channel = 'F2F1';
        requestRiskProfile.sbu = 'H';
         requestRiskProfile.primeBranchID = userP[0].SiteCode__c;
            
        requestRiskProfile.originatingsystem = 'ESP';
        
        if(accountP.CIF__c != null){
            requestRiskProfile.cifKey = accountP.CIF__c;
        }else{
            requestRiskProfile.cifKey = '';
        }
        requestRiskProfile.userId = userP[0].AB_Number__c;//'EXVP124'
        
        if(accountP.Client_Group__c == 'Non Individual'){
            requestRiskProfile.IncorporationCountryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
            requestRiskProfile.absaCountryTradedWithTable = absaCountryTradeWithList;
            String[] countriesOperation = accountP.Country_of_Operation__c.split(';');
  
        for(String country:countriesOperation){
            String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
            GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable absaCountryOperation = new GetRiskProfileClient_Req_IB_v2.cls_absaCountryOfOperationTable();
            absaCountryOperation.absaCountryOfOperation = countryOfOperationTranslated;
            absaCountryOfOperationList.add(absaCountryOperation);
        }
        //System.debug('absaCountryOfOperationList++'+absaCountryOfOperationList); 
            requestRiskProfile.absaCountryOfOperationTable = absaCountryOfOperationList;
            requestRiskProfile.employmentStatus = '';
            requestRiskProfile.occupation = '';
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__c;
            
            if(sicCodeTranslated != null) {
                requestRiskProfile.businessSegment1 = sicCodeTranslated;  
            } else {
                requestRiskProfile.businessSegment1 = '0';
            }
            
        } else if (accountP.Client_Group__c == 'Individual') {
            requestRiskProfile.employmentStatus = '1';
            requestRiskProfile.occupation = '2';
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__pc; 
        } else {
            requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__pc; 
            if(sicCodeTranslated != null) {
                requestRiskProfile.businessSegment1 = sicCodeTranslated;  
            } else {
                requestRiskProfile.businessSegment1 = '0';
            }
        }
        
        requestRiskProfile.absaCountryTradedWithTable = absaCountryTradeWithList;
        
        //Start : multiple source of income : 2020-03-16 - Anka Ganta
        if(accountP.Source_of_Income__c != null) {
        List<GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable> absaSourceOfIncomeList = new List<GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable>();
        
            String[] sourceOfincomes = accountP.Source_of_Income__c.split(';');

            for(String srcOfincome:sourceOfincomes){
                String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, srcOfincome, StringConstants.OUTBOUND_RECORD_TYPE);
                GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable absaSourceOfIncomeCls = new GetRiskProfileClient_Req_IB_v2.cls_absaSourceOfIncomeTable();
                absaSourceOfIncomeCls.absaSourceOfIncome = srcOfincomeTranslated;
                //absaSourceOfIncomeCls.absaSourceOfIncome = '';
                absaSourceOfIncomeList.add(absaSourceOfIncomeCls);
            }
            
            requestRiskProfile.absaSourceOfIncomeTable = absaSourceOfIncomeList;
        }
        
        //End : multiple source of income
        
        List<GetRiskProfileClient_Req_IB_v2.cls_productCodeTable> productCodeClsList = new List<GetRiskProfileClient_Req_IB_v2.cls_productCodeTable>();
        GetRiskProfileClient_Req_IB_v2.cls_productCodeTable productCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_productCodeTable();
        productCodeCls.productCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.Risk_ProductCode_STRING,'CAF Product', 
                                                                 StringConstants.OUTBOUND_RECORD_TYPE);
        productCodeClsList.add(productCodeCls);
        requestRiskProfile.productCodeTable = productCodeClsList;
        List<GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable> subProductCodeList = new List<GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable>();
        GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable subProductCodeCls = new GetRiskProfileClient_Req_IB_v2.cls_subProductCodeTable();
        subProductCodeCls.subProductCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.NetReveal_STRING, StringConstants.Risk_SubProductCode_STRING, 'CAF SubProduct', 
                                                                 StringConstants.OUTBOUND_RECORD_TYPE);
        
        subProductCodeList.add(subProductCodeCls);
        requestRiskProfile.subProductCodeTable = subProductCodeList;
        requestBean.WQriskProfileClientV7Request = requestRiskProfile;
        requestBean.errorMessage = errorMessage;
        //System.debug('Get Risk Profile: ' + requestBean);
        return requestBean;
    }

    /**
    * @description 
    * @author Srikanth N : Absa 
    * @param respP 
    * @return GetRiskProfileClient_Resp_IB_v2 
    **/
    public static GetRiskProfileClient_Resp_IB_v2 mapResponseFields(HttpResponse respP){
        
        //System.debug('Risk Profile Response: ' + respP.getBody());
        GetRiskProfileClient_Resp_IB_v2 responseBean = (GetRiskProfileClient_Resp_IB_v2)JSON.deserialize( respP.getBody(), GetRiskProfileClient_Resp_IB_v2.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        //System.debug('===responseBean=====>'+responseBean.WQriskProfileClientV7Response.riskRating);
        String riskRatingTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_RISK_RATING_STRING, responseBean.WQriskProfileClientV7Response.riskRating, StringConstants.INBOUND_RECORD_TYPE);
        //System.debug('===riskRatingTranslated=====>'+riskRatingTranslated);
        responseBean.WQriskProfileClientV7Response.riskRating = riskRatingTranslated;
        //System.debug('responseBean: ' + responseBean);
        return responseBean;
    }
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-11-16 
    * @param statusCodeP 
    * @param statusP 
    * @param messageP 
    * @return GetRiskProfileClient_Resp_IB_v2 
    **/
    public static GetRiskProfileClient_Resp_IB_v2 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        GetRiskProfileClient_Resp_IB_v2.cls_WQriskProfileClientV7Response riskProfileResponse = new GetRiskProfileClient_Resp_IB_v2.cls_WQriskProfileClientV7Response();
        riskProfileResponse.msg = messageP;
        GetRiskProfileClient_Resp_IB_v2 responseBean = new GetRiskProfileClient_Resp_IB_v2();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.WQriskProfileClientV7Response = riskProfileResponse;
        //System.debug('responseBean: ' + responseBean);
        return responseBean;
    }
        
}