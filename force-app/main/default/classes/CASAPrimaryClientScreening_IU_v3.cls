/**
* Apex Integration Utility Bean class for CASAPrimaryClientScreening
* Test Class Name: CASAPrimaryClientScreening_IH_v3_Test
* @author  Anka Ganta : Absa
* @since    2019-11-24
*
**/

public class CASAPrimaryClientScreening_IU_v3 {
    
    public static CASAPrimaryClientScreening_Req_IB_v3 mapRequestFields(Account accountP,String countryOfIncorporation, String clientTypeGrpTranslated, String iDTypeP){
    
        List<User> userP = [Select id,Teller_Operator_Code__c,SiteCode__c from User where id=:UserInfo.getUserId()];
        CASAPrimaryClientScreening_Req_IB_v3 requestBean = new CASAPrimaryClientScreening_Req_IB_v3();
        
      
        requestBean.idType = iDTypeP;
        
        if(accountP.ID_Type__c == 'Registration Number' || accountP.ID_Type__c == 'Non-Registered Entity') {
            if(accountP.Registration_Number__c != null){
            requestBean.idRegNo = accountP.Registration_Number__c;
            }else{//
               requestBean.idRegNo = 'NOTAVAILABLE1'; 
            }  
            requestBean.dob = '';
            requestBean.firstName = '';
            requestBean.surnameComp = accountP.Name;//'Smith';
        } else {
            requestBean.idRegNo = accountP.ID_Number__pc;
            requestBean.firstName = accountP.FirstName;
            requestBean.surnameComp = accountP.LastName;//'Smith';
            if(accountP.PersonBirthdate != null){
            DateTime birthDate = accountP.PersonBirthdate;
            String birthDateValue = DateTime.newInstance(birthDate.year(),birthDate.month(),birthDate.day()).format('yyyyMMdd');
            requestBean.dob = String.valueOf(birthDateValue);
            }    
        }         
        requestBean.clientTypeGrp = clientTypeGrpTranslated;//'N';
        
        requestBean.nationality = countryOfIncorporation;// 'SA';//nationalityP;
        
        requestBean.town = '';
        
        requestBean.territory = '500';//accountP.Territory__c;
        requestBean.cntryOfRes = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);
        requestBean.cntryOfBirth = countryOfIncorporation;//'PHN';
        requestBean.registerCity = '';//not available field is for companies
        requestBean.countryPassport = countryOfIncorporation;//'20191009';
        requestBean.headofficeTown = '';//not available field is for companies
        requestBean.headofficeCntry = '';//not available field is for companies
        requestBean.headofficeOtherCntry1 = '';//not available field is for companies
        requestBean.headofficeOtherCntry2 = '';//not available field is for companies
        requestBean.headofficeOtherCntry3 = '';//not available field is for companies
        requestBean.headofficeOtherCntry4 = '';//not available field is for companies
        requestBean.headofficeOtherCntry5 = '';//not available field is for companies
        requestBean.sbu = 'H';//sbuP;//generalVirtualAdvisorRulesMap.get(StringConstants.SBU)[0].EnumerationExpectedValues__c;
        requestBean.originatingSys = 'ESP'; //generalVirtualAdvisorRulesMap.get(StringConstants.ORIGINATING_SYSTEM_CASA)[0].EnumerationExpectedValues__c;//'SIEBEL'
        requestBean.branch = userP[0].SiteCode__c;//'0';
        requestBean.teller = userP[0].Teller_Operator_Code__c;//'0'
        
        System.debug('casaPrimaryClientScreening Request v3' + requestBean);
        return requestBean;
    }
    

    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: CASAPrimaryClientScreening_Resp_IB_v3 bean object
    */
    public static CASAPrimaryClientScreening_Resp_IB_v3 mapResponseFields(HttpResponse responseP)
    {              
        CASAPrimaryClientScreening_Resp_IB_v3 bean = new CASAPrimaryClientScreening_Resp_IB_v3();
        CASAPrimaryClientScreening_Resp_IB_v3 responseBean = (CASAPrimaryClientScreening_Resp_IB_v3)bean.deserialize(responseP.getBody(), CASAPrimaryClientScreening_Resp_IB_v3.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        System.debug('Create Casa Primary client Screening Request Bean v3: ' + responseBean);
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: CASAPrimaryClientScreening_Resp_IB_v3 bean object
    * */    
    public static CASAPrimaryClientScreening_Resp_IB_v3 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        CASAPrimaryClientScreening_Resp_IB_v3 responseBean = new CASAPrimaryClientScreening_Resp_IB_v3();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }    
}