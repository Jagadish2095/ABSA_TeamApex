public class CASAPrimaryClientScreening_IU_v1 {
    
    public static CASAPrimaryClientScreening_Req_IB_v1 mapRequestFields(Account accountP, User userP, String countryOfResP, String countryOfBirthP, String iDTypeP, String nationalityP, String countryPassportP, List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRuleListP){
        
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(
            generalVirtualAdvisorRuleListP,
            StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        CASAPrimaryClientScreening_Req_IB_v1 requestBean = new CASAPrimaryClientScreening_Req_IB_v1();
        requestBean.channel = generalVirtualAdvisorRulesMap.get(StringConstants.CHANNEL)[0].EnumerationExpectedValues__c;//'AFS'
        requestBean.application = generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM_CASA)[0].EnumerationExpectedValues__c;//'SIEBEL'
        requestBean.trace = 'N';//hard-coded
        requestBean.firstName = accountP.FirstName;
        requestBean.surnameComp = accountP.LastName;
        requestBean.idType = iDTypeP;
        requestBean.idRegNo = accountP.ID_Number__pc;
        requestBean.clientTypeGrp = generalVirtualAdvisorRulesMap.get('Client_Type_Group')[0].EnumerationExpectedValues__c;
        //requestBean.clientTypeGrp = generalVirtualAdvisorRulesMap.get(StringConstants.CLIENT_TYPE_GROUP)[0].EnumerationExpectedValues__c;//'I'
        if(accountP.PersonBirthdate != null){
            requestBean.dob = String.valueOf(accountP.PersonBirthdate).replace('-', '');
        }
        requestBean.nationality = nationalityP;
        if(accountP.ShippingCity != null){
            requestBean.town = String.valueOf(accountP.ShippingCity);
        }else{
            requestBean.town = '';
        }
        //requestBean.territory = accountP.Territory__c;
        requestBean.cntryOfRes = countryOfResP;
        requestBean.cntryOfBirth = countryOfBirthP;
        requestBean.registerCity = '';//not available field is for companies
        requestBean.countryPassport = countryPassportP; //accountP.CountryPassport__pc;
        requestBean.headofficeTown = '';//not available field is for companies
        requestBean.headofficeCntry = '';//not available field is for companies
        requestBean.headofficeOtherCntry1 = '';//not available field is for companies
        requestBean.headofficeOtherCntry2 = '';//not available field is for companies
        requestBean.headofficeOtherCntry3 = '';//not available field is for companies
        requestBean.headofficeOtherCntry4 = '';//not available field is for companies
        requestBean.headofficeOtherCntry5 = '';//not available field is for companies
        requestBean.sbu = generalVirtualAdvisorRulesMap.get(StringConstants.SBU)[0].EnumerationExpectedValues__c;//'61'
        requestBean.originatingSys = generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM_CASA)[0].EnumerationExpectedValues__c;//'SIEBEL'
        requestBean.branch = generalVirtualAdvisorRulesMap.get(StringConstants.BRANCH_CODE)[0].EnumerationExpectedValues__c;//'3456'
        requestBean.teller = userP.AB_Number__c;
        
        System.debug('casaPrimaryClientScreening Request' + requestBean);
        return requestBean;
    }
    
    public static CASAPrimaryClientScreening_Req_IB_v1 mapJointAccRequestFields(Account accountP, User userP, String countryOfRegP, String nationalityAccTranslated, Account relatedAccountP, List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRuleListP){
        
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(
            generalVirtualAdvisorRuleListP,
            StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        CASAPrimaryClientScreening_Req_IB_v1 jointAccRequestBean = new CASAPrimaryClientScreening_Req_IB_v1();
        jointAccRequestBean.channel = generalVirtualAdvisorRulesMap.get(StringConstants.CHANNEL)[0].EnumerationExpectedValues__c;//'AFS'
        jointAccRequestBean.application = generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM_CASA)[0].EnumerationExpectedValues__c;//'SIEBEL'
        jointAccRequestBean.trace = 'N';//hard-coded
        jointAccRequestBean.firstName = '';
        jointAccRequestBean.surnameComp = accountP.Name;
        jointAccRequestBean.idType = '0';
        jointAccRequestBean.idRegNo = '';
        jointAccRequestBean.clientTypeGrp = 'J';
        if(relatedAccountP.PersonBirthdate != null){
            jointAccRequestBean.dob = String.valueOf(relatedAccountP.PersonBirthdate).replace('-','');
        }
        jointAccRequestBean.nationality = nationalityAccTranslated;
        jointAccRequestBean.town = '';
        //jointAccRequestBean.territory = '';
        jointAccRequestBean.cntryOfRes = countryOfRegP;
        jointAccRequestBean.cntryOfBirth = countryOfRegP;
        jointAccRequestBean.registerCity = '';//n/a - Conditional Mandatory
        //jointAccRequestBean.countryPassport = '';
        jointAccRequestBean.headofficeTown = '';//n/a
        jointAccRequestBean.headofficeCntry = '';//n/a
        jointAccRequestBean.headofficeOtherCntry1 = '';//n/a
        jointAccRequestBean.headofficeOtherCntry2 = '';//n/a
        jointAccRequestBean.headofficeOtherCntry3 = '';//n/a
        jointAccRequestBean.headofficeOtherCntry4 = '';//n/a
        jointAccRequestBean.headofficeOtherCntry5 = '';//n/a
        jointAccRequestBean.sbu = '50';//'61'
        jointAccRequestBean.originatingSys = 'SIEBEL';//'SALESFORCE'
        jointAccRequestBean.branch = generalVirtualAdvisorRulesMap.get(StringConstants.BRANCH_CODE)[0].EnumerationExpectedValues__c;//'3456'
        jointAccRequestBean.teller = userP.AB_Number__c;
        
        System.debug('casaPrimaryClientScreening Joint Account Request: ' + jointAccRequestBean);
        return jointAccRequestBean;
    }
    
    public static CASAPrimaryClientScreening_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        CASAPrimaryClientScreening_Resp_IB_v1 responseBean = (CASAPrimaryClientScreening_Resp_IB_v1)JSON.deserialize( respP.getBody(), CASAPrimaryClientScreening_Resp_IB_v1.class);
        responseBean.httpStatus = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('casaPrimaryClientScreening Response' + responseBean);
        return responseBean;
    }
    
    public static CASAPrimaryClientScreening_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        CASAPrimaryClientScreening_Resp_IB_v1 responseBean = new CASAPrimaryClientScreening_Resp_IB_v1();
        responseBean.httpStatus = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.msg = messageP;
        
        System.debug('casaPrimaryClientScreening Failed Response' + responseBean);
        return responseBean;
    }
}