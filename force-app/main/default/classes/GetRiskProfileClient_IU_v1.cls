public class GetRiskProfileClient_IU_v1 {
	
    public static GetRiskProfileClient_Req_IB_v1 mapRequestFields(Account accountP, String userIdP, String occupationStatusP, String occupationCategoryP, String incomeSourceP, List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRuleListP, List<String> productCodeListP, List<String> subProductCodeListP, List<String> countriesListP, String sbu){
        
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(
            generalVirtualAdvisorRuleListP,
            StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        List<GetRiskProfileClient_Req_IB_v1.cls_absaCountryTradedWithTable> absaCountryTradeWithList = new List<GetRiskProfileClient_Req_IB_v1.cls_absaCountryTradedWithTable>();
        List<GetRiskProfileClient_Req_IB_v1.cls_absaCountryOfOperationTable> absaCountryOfOperationList = new List<GetRiskProfileClient_Req_IB_v1.cls_absaCountryOfOperationTable>();
        String errorMessage = '';
        
        for(String country : countriesListP){
            
            String countryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, country, StringConstants.OUTBOUND_RECORD_TYPE);
            
            errorMessage += countryTranslated == null ? 'Unable to map country to external value: ' + country + '. ' : '';
            
            GetRiskProfileClient_Req_IB_v1.cls_absaCountryTradedWithTable absaCountryTradeWithObj = new GetRiskProfileClient_Req_IB_v1.cls_absaCountryTradedWithTable();
            GetRiskProfileClient_Req_IB_v1.cls_absaCountryOfOperationTable absaCountryOfOperationObj = new GetRiskProfileClient_Req_IB_v1.cls_absaCountryOfOperationTable();
            
            absaCountryTradeWithObj.absaCountriesTradedWith = countryTranslated;
            absaCountryOfOperationObj.absaCountryOfOperation = countryTranslated;
            
            absaCountryTradeWithList.add(absaCountryTradeWithObj);
            absaCountryOfOperationList.add(absaCountryOfOperationObj);
        }
        
        GetRiskProfileClient_Req_IB_v1 requestBean = new GetRiskProfileClient_Req_IB_v1();
        GetRiskProfileClient_Req_IB_v1.cls_WQriskProfileClientV7Request requestRiskProfile = new GetRiskProfileClient_Req_IB_v1.cls_WQriskProfileClientV7Request();
        
        requestRiskProfile.customerTypeCode = generalVirtualAdvisorRulesMap.get(StringConstants.CUSTOMER_TYPE_CODE)[0].EnumerationExpectedValues__c;
        requestRiskProfile.customerStatusCode = generalVirtualAdvisorRulesMap.get(StringConstants.CUSTOMER_STATUS_CODE)[0].EnumerationExpectedValues__c;
        requestRiskProfile.customerSourceUniqueId = accountP.CASA_Reference_Number__pc;
        //requestRiskProfile.companyForm = generalVirtualAdvisorRulesMap.get(StringConstants.COMPANY_FORM)[0].EnumerationExpectedValues__c;
        //Robert McLean 10152019 -- interim fix
            String companyForm = '00101';
            String countryOfRes = accountP.Country_of_Residence__pc;
            if(countryOfRes == 'Lesotho' || countryOfRes == 'Namibia' || countryOfRes == 'Swaziland'){
                companyForm = '00103';            
            }
            else if(countryOfRes != 'Lesotho' && countryOfRes != 'Namibia' && countryOfRes != 'Swaziland' && countryOfRes != 'South Africa'){
                companyForm = '00104';            
            }
        requestRiskProfile.companyForm = companyForm;
        requestRiskProfile.customerSourceRefID = '';
        requestRiskProfile.primeBranchID = generalVirtualAdvisorRulesMap.get(StringConstants.BRANCH_CODE)[0].EnumerationExpectedValues__c;
        requestRiskProfile.channel = generalVirtualAdvisorRulesMap.get(StringConstants.CHANNEL)[0].EnumerationExpectedValues__c;
        //requestRiskProfile.sbu = generalVirtualAdvisorRulesMap.get(StringConstants.SBU)[0].EnumerationExpectedValues__c;
        requestRiskProfile.sbu = sbu;
        requestRiskProfile.originatingsystem = Sys_Utilities_General.truncateFieldIfNeeded(generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM)[0].EnumerationExpectedValues__c, 8);
        requestRiskProfile.employmentStatus = occupationStatusP;
        requestRiskProfile.occupation = occupationCategoryP;
        requestRiskProfile.businessSegment1 = '';
        if(accountP.CIF__c != null){
            requestRiskProfile.cifKey = accountP.CIF__c;
        }else{
            requestRiskProfile.cifKey = '';
        }
        requestRiskProfile.userId = Sys_Utilities_General.truncateFieldIfNeeded(userIdP, 8);
        
        requestRiskProfile.absaCountryTradedWithTable = absaCountryTradeWithList;
        
        requestRiskProfile.absaCountryOfOperationTable = absaCountryOfOperationList;
        
        GetRiskProfileClient_Req_IB_v1.cls_absaSourceOfIncomeTable absaSourceOfIncomeCls = new GetRiskProfileClient_Req_IB_v1.cls_absaSourceOfIncomeTable();
        absaSourceOfIncomeCls.absaSourceOfIncome = incomeSourceP;
        List<GetRiskProfileClient_Req_IB_v1.cls_absaSourceOfIncomeTable> absaSourceOfIncomeList = new List<GetRiskProfileClient_Req_IB_v1.cls_absaSourceOfIncomeTable>();
        absaSourceOfIncomeList.add(absaSourceOfIncomeCls);
        requestRiskProfile.absaSourceOfIncomeTable = absaSourceOfIncomeList;
        
        List<GetRiskProfileClient_Req_IB_v1.cls_productCodeTable> productCodeClsList = new List<GetRiskProfileClient_Req_IB_v1.cls_productCodeTable>();
        for(String product : productCodeListP){
            GetRiskProfileClient_Req_IB_v1.cls_productCodeTable productCodeCls = new GetRiskProfileClient_Req_IB_v1.cls_productCodeTable();
            productCodeCls.productCode = product;
            productCodeClsList.add(productCodeCls);
        }
        requestRiskProfile.productCodeTable = productCodeClsList;
        
        List<GetRiskProfileClient_Req_IB_v1.cls_subProductCodeTable> subProductCodeList = new List<GetRiskProfileClient_Req_IB_v1.cls_subProductCodeTable>();
        for(String subProduct : subProductCodeListP){
            GetRiskProfileClient_Req_IB_v1.cls_subProductCodeTable subProductCodeCls = new GetRiskProfileClient_Req_IB_v1.cls_subProductCodeTable();
            subProductCodeCls.subProductCode = subProduct;
            subProductCodeList.add(subProductCodeCls);
        }
        requestRiskProfile.subProductCodeTable = subProductCodeList;
        
        requestBean.WQriskProfileClientV7Request = requestRiskProfile;
        requestBean.errorMessage = errorMessage;
        
        System.debug('Get Risk Profile: ' + requestBean);
        return requestBean;
    }
    
    public static GetRiskProfileClient_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        System.debug('Risk Profile Response: ' + respP.getBody());
        GetRiskProfileClient_Resp_IB_v1 responseBean = (GetRiskProfileClient_Resp_IB_v1)JSON.deserialize( respP.getBody(), GetRiskProfileClient_Resp_IB_v1.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        String riskRatingTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_RISK_RATING_STRING, responseBean.WQriskProfileClientV7Response.riskRating, StringConstants.INBOUND_RECORD_TYPE);
        responseBean.WQriskProfileClientV7Response.riskRating = riskRatingTranslated;
        
        System.debug('responseBean: ' + responseBean);
        return responseBean;
    }
    
    public static GetRiskProfileClient_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        GetRiskProfileClient_Resp_IB_v1.cls_WQriskProfileClientV7Response riskProfileResponse = new GetRiskProfileClient_Resp_IB_v1.cls_WQriskProfileClientV7Response();
        riskProfileResponse.msg = messageP;
        
        GetRiskProfileClient_Resp_IB_v1 responseBean = new GetRiskProfileClient_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.WQriskProfileClientV7Response = riskProfileResponse;
        
        System.debug('responseBean: ' + responseBean);
        return responseBean;
    }
    
}