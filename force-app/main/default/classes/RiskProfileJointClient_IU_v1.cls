public class RiskProfileJointClient_IU_v1 {
    
    public static RiskProfileJointClient_Req_IB_v1 mapRequestFields(Account accountP, List<Account> accountListP, List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRuleListP, List<String> productCodeListP, List<String> subProductCodeListP, List<String> countriesListP, String userIdP, String occupationStatusP, String occupationCategoryP, String incomeSourceP, String sbu){
        
        String errorMessage = '';
        
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(
            generalVirtualAdvisorRuleListP,
            StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        //Product Code
        List<RiskProfileJointClient_Req_IB_v1.cls_productCodeTable> productCodeList = new List<RiskProfileJointClient_Req_IB_v1.cls_productCodeTable>();
        for(String product : productCodeListP){
            RiskProfileJointClient_Req_IB_v1.cls_productCodeTable productCodeObj = new RiskProfileJointClient_Req_IB_v1.cls_productCodeTable();
            productCodeObj.productCode = product;
            productCodeList.add(productCodeObj);
        }
        //Sub-Product Code
        List<RiskProfileJointClient_Req_IB_v1.cls_subProductCodeTable> subProductCodeList = new List<RiskProfileJointClient_Req_IB_v1.cls_subProductCodeTable>();
        for(String subProduct : subProductCodeListP){
            RiskProfileJointClient_Req_IB_v1.cls_subProductCodeTable subProductCodeObj = new RiskProfileJointClient_Req_IB_v1.cls_subProductCodeTable();
            subProductCodeObj.subProductCode = subProduct;
            subProductCodeList.add(subProductCodeObj);
        }
        //Country Trade With & Country Of Operation
        List<RiskProfileJointClient_Req_IB_v1.cls_absaCountryTradedWithTable> absaCountryTradeWithList = new List<RiskProfileJointClient_Req_IB_v1.cls_absaCountryTradedWithTable>();
        List<RiskProfileJointClient_Req_IB_v1.cls_absaCountryOfOperationTable> absaCountryOfOperationList = new List<RiskProfileJointClient_Req_IB_v1.cls_absaCountryOfOperationTable>();
        
        for(String country : countriesListP){
            
            String countryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
            
            errorMessage += countryTranslated == null ? 'Unable to map Country: ' + country + ' for ' + StringConstants.ECASA_STRING : '';
            
            RiskProfileJointClient_Req_IB_v1.cls_absaCountryTradedWithTable absaCountryTradeWithObj = new RiskProfileJointClient_Req_IB_v1.cls_absaCountryTradedWithTable();
            RiskProfileJointClient_Req_IB_v1.cls_absaCountryOfOperationTable absaCountryOfOperationObj = new RiskProfileJointClient_Req_IB_v1.cls_absaCountryOfOperationTable();
            
            absaCountryTradeWithObj.absaCountriesTradedWith = countryTranslated;
            absaCountryOfOperationObj.absaCountryOfOperation = countryTranslated;
            
            absaCountryTradeWithList.add(absaCountryTradeWithObj);
            absaCountryOfOperationList.add(absaCountryOfOperationObj);
        }
        
        RiskProfileJointClient_Req_IB_v1 requestBean = new RiskProfileJointClient_Req_IB_v1();        
        RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest primaryClient = new RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest();
        
        primaryClient.customerTypeCode = generalVirtualAdvisorRulesMap.get(StringConstants.CUSTOMER_TYPE_CODE)[0].EnumerationExpectedValues__c;
        primaryClient.customerStatusCode = generalVirtualAdvisorRulesMap.get(StringConstants.CUSTOMER_STATUS_CODE)[0].EnumerationExpectedValues__c;
        primaryClient.customerSourceUniqueId = accountP.CASA_Reference_Number__c;
        //primaryClient.companyForm = generalVirtualAdvisorRulesMap.get(StringConstants.COMPANY_FORM)[0].EnumerationExpectedValues__c;
        //Robert McLean 10152019 -- interim fix
        String companyForm = '00301';
        String countryOfReg = accountP.Country_of_Registration__c;
        if(countryOfReg == 'Lesotho' || countryOfReg == 'Namibia' || countryOfReg == 'Swaziland'){
            companyForm = '00303';            
        }
        else if(countryOfReg != 'Lesotho' && countryOfReg != 'Namibia' && countryOfReg != 'Swaziland' && countryOfReg != 'South Africa'){
            companyForm = '00304';            
        }
        primaryClient.companyForm = companyForm;
        primaryClient.customerSourceRefID = '';
        primaryClient.primeBranchID = generalVirtualAdvisorRulesMap.get(StringConstants.BRANCH_CODE)[0].EnumerationExpectedValues__c;
        primaryClient.channel = generalVirtualAdvisorRulesMap.get(StringConstants.CHANNEL)[0].EnumerationExpectedValues__c;
        //primaryClient.sbu = generalVirtualAdvisorRulesMap.get(StringConstants.SBU)[0].EnumerationExpectedValues__c;
        primaryClient.sbu = sbu;
        primaryClient.originatingsystem = Sys_Utilities_General.truncateFieldIfNeeded(generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM)[0].EnumerationExpectedValues__c, 8);
        primaryClient.employmentStatus = occupationStatusP;
        primaryClient.occupation = occupationCategoryP;
        primaryClient.businessSegment1 = '';
        if(accountP.CIF__c != null){
            primaryClient.cifKey = accountP.CIF__c;
        }else{
            primaryClient.cifKey = '';
        }
        primaryClient.userId = Sys_Utilities_General.truncateFieldIfNeeded(userIdP, 8);
        primaryClient.IncorporationCountryCode = '';
        
        primaryClient.absaCountryTradedWithTable = absaCountryTradeWithList;
        
        primaryClient.absaCountryOfOperationTable = absaCountryOfOperationList;
        
        RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable absaSourceOfIncomePrimaryClientObj = new RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable();
        absaSourceOfIncomePrimaryClientObj.absaSourceOfIncome = incomeSourceP;
        List<RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable> absaSourceOfIncomePrimaryClientList = new List<RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable>();
        absaSourceOfIncomePrimaryClientList.add(absaSourceOfIncomePrimaryClientObj);
        primaryClient.absaSourceOfIncomeTable = absaSourceOfIncomePrimaryClientList;
        
        primaryClient.productCodeTable = productCodeList;
        
        primaryClient.subProductCodeTable = subProductCodeList;
        
        requestBean.primaryClient = primaryClient;
        
        List<RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest> relatedPartyList = new List<RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest>();
        
        for(Account accountRelatedParty : accountListP){
            
            String occupationStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_OCCUPATION_STATUS_STRING, accountRelatedParty.Occupation_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String occupationCategoryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_OCCUPATION_CATEGORY_STRING, accountRelatedParty.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountRelatedParty.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            
            errorMessage += occupationStatusTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_STATUS + accountRelatedParty.Occupation_Status__pc + ' for Contact: ' + accountRelatedParty.Id + '. ' : '';
            errorMessage += occupationCategoryTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_CATEGORY + accountRelatedParty.Occupation_Category__pc + ' for Contact: ' + accountRelatedParty.Id + '. ' : '';
            errorMessage += incomeSourceTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_INCOME_SOURCE + accountRelatedParty.Income_Source__pc + ' for Contact: ' + accountRelatedParty.Id + '. ' : '';
            
            
            RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest relatedParty = new RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest();
            
            relatedParty.customerTypeCode = generalVirtualAdvisorRulesMap.get(StringConstants.CUSTOMER_TYPE_CODE)[0].EnumerationExpectedValues__c;
            relatedParty.customerStatusCode = generalVirtualAdvisorRulesMap.get(StringConstants.CUSTOMER_STATUS_CODE)[0].EnumerationExpectedValues__c;
            relatedParty.customerSourceUniqueId = accountRelatedParty.CASA_Reference_Number__pc;
            //relatedParty.companyForm = generalVirtualAdvisorRulesMap.get(StringConstants.COMPANY_FORM)[0].EnumerationExpectedValues__c;
            //Robert McLean 10152019 -- interim fix
            String companyFormRelated = '00101';
            String countryOfRes = accountRelatedParty.Country_of_Residence__pc;
            if(countryOfRes == 'Lesotho' || countryOfRes == 'Namibia' || countryOfRes == 'Swaziland'){
                companyFormRelated = '00103';            
            }
            else if(countryOfRes != 'Lesotho' && countryOfRes != 'Namibia' && countryOfRes != 'Swaziland' && countryOfRes != 'South Africa'){
                companyFormRelated = '00104';            
            }
            relatedParty.companyForm = companyFormRelated;
            relatedParty.customerSourceRefID = '';
            relatedParty.primeBranchID = generalVirtualAdvisorRulesMap.get(StringConstants.BRANCH_CODE)[0].EnumerationExpectedValues__c;
            relatedParty.channel = generalVirtualAdvisorRulesMap.get(StringConstants.CHANNEL)[0].EnumerationExpectedValues__c;
            //relatedParty.sbu = generalVirtualAdvisorRulesMap.get(StringConstants.SBU)[0].EnumerationExpectedValues__c;
            relatedParty.sbu = sbu;
            relatedParty.originatingsystem = Sys_Utilities_General.truncateFieldIfNeeded(generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM)[0].EnumerationExpectedValues__c, 8);
            relatedParty.employmentStatus = occupationStatusTranslated;
            relatedParty.occupation = occupationCategoryTranslated;
            relatedParty.businessSegment1 = '';
            relatedParty.cifKey = '';
            relatedParty.userId = Sys_Utilities_General.truncateFieldIfNeeded(userIdP, 8);
            relatedParty.IncorporationCountryCode = '';
            
            relatedParty.absaCountryTradedWithTable = absaCountryTradeWithList;
            
            relatedParty.absaCountryOfOperationTable = absaCountryOfOperationList;
            
            RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable absaSourceOfIncomerelatedPartyObj = new RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable();
            absaSourceOfIncomerelatedPartyObj.absaSourceOfIncome = incomeSourceTranslated;
            List<RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable> absaSourceOfIncomerelatedPartyList = new List<RiskProfileJointClient_Req_IB_v1.cls_absaSourceOfIncomeTable>();
            absaSourceOfIncomerelatedPartyList.add(absaSourceOfIncomerelatedPartyObj);
            relatedParty.absaSourceOfIncomeTable = absaSourceOfIncomerelatedPartyList;
            
            relatedParty.productCodeTable = productCodeList;
            
            relatedParty.subProductCodeTable = subProductCodeList;
            
            relatedPartyList.add(relatedParty);
        }
        requestBean.errorMessage = errorMessage;
        requestBean.relatedParties = relatedPartyList;
        
        System.debug('Risk Joint Client Profile: ' + requestBean);
        return requestBean;
    }
    
    public static RiskProfileJointClient_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        RiskProfileJointClient_Resp_IB_v1 responseBean = (RiskProfileJointClient_Resp_IB_v1)JSON.deserialize( respP.getBody(), RiskProfileJointClient_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        String riskRatingTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_RISK_RATING_STRING, responseBean.riskRating, StringConstants.INBOUND_RECORD_TYPE);
        responseBean.riskRating = riskRatingTranslated;
        
        System.debug('Risk Profile Joint Client Response' + responseBean);
        return responseBean;
    }
    
    public static RiskProfileJointClient_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        RiskProfileJointClient_Resp_IB_v1 responseBean = new RiskProfileJointClient_Resp_IB_v1();
        responseBean.Status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.msg = messageP;
        
        System.debug('Risk Profile Joint Client Failed Response' + responseBean);
        return responseBean;
    }
}