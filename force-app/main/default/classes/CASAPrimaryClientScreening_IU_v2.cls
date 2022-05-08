public class CASAPrimaryClientScreening_IU_v2 {
    
    public static CASAPrimaryClientScreening_Req_IB_v2 mapRequestFields(Account accountP, User userP, String countryOfResP, String countryOfBirthP, String iDTypeP, String nationalityP, String countryPassportP, 
                                                                        List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRuleListP, String channelP, String sbuP, String branchP, String clientTypeGrpP){
        
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(
            generalVirtualAdvisorRuleListP,
            StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        CASAPrimaryClientScreening_Req_IB_v2 requestBean = new CASAPrimaryClientScreening_Req_IB_v2();
        requestBean.channel = channelP;//generalVirtualAdvisorRulesMap.get(StringConstants.CHANNEL)[0].EnumerationExpectedValues__c;//'AFS'
        requestBean.application = 'SALESFORCE';//generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM_CASA)[0].EnumerationExpectedValues__c;//'SIEBEL'
        requestBean.trace = 'N';//hard-coded
        requestBean.firstName = accountP.FirstName;
        requestBean.surnameComp = accountP.LastName;
        requestBean.idType = iDTypeP;
        requestBean.idRegNo = accountP.ID_Number__pc;
        requestBean.clientTypeGrp = clientTypeGrpP;//'I';//generalVirtualAdvisorRulesMap.get(StringConstants.CLIENT_TYPE_GROUP)[0].EnumerationExpectedValues__c;//'I'
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
        requestBean.sbu = sbuP;//generalVirtualAdvisorRulesMap.get(StringConstants.SBU)[0].EnumerationExpectedValues__c;//'61'
        requestBean.originatingSys = 'SALESFORCE';//generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM_CASA)[0].EnumerationExpectedValues__c;//'SIEBEL'
        requestBean.branch = branchP;//generalVirtualAdvisorRulesMap.get(StringConstants.BRANCH_CODE)[0].EnumerationExpectedValues__c;//'3456'
        requestBean.teller = userP.AB_Number__c;
        
        System.debug('casaPrimaryClientScreening Request' + requestBean);
        return requestBean;
    }
    
    public static CASAPrimaryClientScreening_Req_IB_v2 mapJointAccRequestFields(Account accountP, User userP, String countryOfRegP, String nationalityAccTranslated, Account relatedAccountP, 
                                                                                List<General_Virtual_Advisor_Rules__mdt> generalVirtualAdvisorRuleListP, String channelP, String sbuP, String branchP, String clientTypeGrpP){
        
        Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap = Sys_Utilities_General.convertListToMapWithStringKey(
            generalVirtualAdvisorRuleListP,
            StringConstants.FIELD_DEVELOPERNAME_STRING);
        
        CASAPrimaryClientScreening_Req_IB_v2 jointAccRequestBean = new CASAPrimaryClientScreening_Req_IB_v2();
        jointAccRequestBean.channel = channelP;//generalVirtualAdvisorRulesMap.get(StringConstants.CHANNEL)[0].EnumerationExpectedValues__c;//'AFS'
        jointAccRequestBean.application = generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM_CASA)[0].EnumerationExpectedValues__c;//'SIEBEL'
        jointAccRequestBean.trace = 'N';//hard-coded
        jointAccRequestBean.firstName = '';
        jointAccRequestBean.surnameComp = accountP.Name;
        jointAccRequestBean.idType = '';
        jointAccRequestBean.idRegNo = '';
        jointAccRequestBean.clientTypeGrp = clientTypeGrpP;//'J';
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
        jointAccRequestBean.sbu = sbuP;//'50';//'61'
        jointAccRequestBean.originatingSys = 'SALESFORCE';//'SIEBEL'
        jointAccRequestBean.branch = branchP;//generalVirtualAdvisorRulesMap.get(StringConstants.BRANCH_CODE)[0].EnumerationExpectedValues__c;//'3456'
        jointAccRequestBean.teller = userP.AB_Number__c;
        
        System.debug('casaPrimaryClientScreening Joint Account Request: ' + jointAccRequestBean);
        return jointAccRequestBean;
    }
    
    
    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: CASAPrimaryClientScreening_Resp_IB_v2 bean object
    */
    public static CASAPrimaryClientScreening_Resp_IB_v2 mapResponseFields(HttpResponse responseP)
    {              
        CASAPrimaryClientScreening_Resp_IB_v2 bean = new CASAPrimaryClientScreening_Resp_IB_v2();
        CASAPrimaryClientScreening_Resp_IB_v2 responseBean = (CASAPrimaryClientScreening_Resp_IB_v2)bean.deserialize(responseP.getBody(), CASAPrimaryClientScreening_Resp_IB_v2.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        System.debug('Create Casa Primary client Screening Request Bean: ' + responseBean);
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: CASAPrimaryClientScreening_Resp_IB_v2 bean object
    * */    
    public static CASAPrimaryClientScreening_Resp_IB_v2 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        CASAPrimaryClientScreening_Resp_IB_v2 responseBean = new CASAPrimaryClientScreening_Resp_IB_v2();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }    
}