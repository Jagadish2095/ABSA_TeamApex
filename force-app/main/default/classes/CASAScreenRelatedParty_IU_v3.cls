/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-11-08
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-06-22   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class CASAScreenRelatedParty_IU_v3{
    private static List<User> userP = new List<User>();

    /**
    * @description       : mapRequestJntAccountFieldsBusiness
    * @return CASAScreenRelatedParty_Req_IB_v3
    * @param accountP
    *@param primaryClientRef
    * 1.0   03-29-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
    */
    public static CASAScreenRelatedParty_Req_IB_v3 mapRequestJntAccountFieldsBusiness(Account accountP,String primaryClientRef){
        
        if(userP.size() == 0){
            userP = new Usersselector().userwithSiteCode(UserInfo.getUserId());
       }
        CASAScreenRelatedParty_Req_IB_v3 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v3();
        screenRelatedParty.channel ='SALESFORCE';
        screenRelatedParty.application = 'SALESFORCE';
        screenRelatedParty.trace = '';
        //screenRelatedParty.firstName;
        
        if( accountP.ID_Type__c == 'Registration Number' || accountP.ID_Type__c == 'Non-Registered Entity') {
            
            screenRelatedParty.surnameComp = accountP.Name;
            screenRelatedParty.idRegNo = accountP.Registration_Number__c;
            screenRelatedParty.clientTypeGrp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountP.Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
            screenRelatedParty.cntryOfRes = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
            screenRelatedParty.nationality = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
            screenRelatedParty.idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountP.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
            
        } else {
            
            String firstNameString;//W-010679
            if(accountP.FirstName != null && accountP.MiddleName != null){
                firstNameString = accountP.FirstName + ' ' + accountP.MiddleName;
            }else{
                firstNameString = accountP.FirstName;
            }
            
            screenRelatedParty.firstName = firstNameString;
            screenRelatedParty.surnameComp = accountP.LastName;
            screenRelatedParty.idRegNo = accountP.ID_Number__pc;
            screenRelatedParty.clientTypeGrp = 'I';
            String dobstring = accountP.PersonBirthdate!= null ?String.valueOf(accountP.PersonBirthdate).replace('-',''):'';
            if(dobstring != null){
                screenRelatedParty.dob = dobstring;//'19841026';
            }
            String countryOfBirthValue = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String suburbValue = '';
            
            //Get Related Party Residential address and pass to screening
            List<Address__c> addressLst = new AddressesSelector().addressesRelatedToAcc(accountP.id);
            if(addressLst != null) {
                for(Address__c eachAddress : addressLst) {
                    if(eachAddress.Address_Type__c == 'Residential' && eachAddress.Address2__c != null) {
                        SuburbValue = eachAddress.Address2__c; 
                        break;
                    }
                }
            }
            
            screenRelatedParty.town = suburbValue;
            
            if(countryOfBirthValue != null) {
                screenRelatedParty.cntryOfBirth = countryOfBirthValue;
            } else {
                screenRelatedParty.cntryOfBirth = '';
            }
            
            screenRelatedParty.nationality = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            screenRelatedParty.cntryOfRes = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);//'SO003';//countryOfResP;
            screenRelatedParty.idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountP.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE); 
        }
        
        screenRelatedParty.territory = '';        
        screenRelatedParty.registerCity = '';//countryOfBirthP;
        screenRelatedParty.countryPassport = 'SO003';//countryPassportP;
        screenRelatedParty.headofficeTown = '';
        screenRelatedParty.headofficeCntry = '';//'125346';
        screenRelatedParty.headofficeOtherCntry1 = '';//'3456';
        screenRelatedParty.headofficeOtherCntry2 = '';
        screenRelatedParty.headofficeOtherCntry3 = '';//SIEBEL
        screenRelatedParty.headofficeOtherCntry4 = '';
        screenRelatedParty.headofficeOtherCntry5 = '';
        screenRelatedParty.primaryClientRef =  primaryClientRef;//'1779160';
        screenRelatedParty.relationship = '210305';//relationshipP;//'125346';
        screenRelatedParty.branch = userP.size() > 0 ? userP[0].SiteCode__c : '0';//'8198';
        screenRelatedParty.teller = userP.size() > 0 ? userP[0].Teller_Operator_Code__c : '0';//'2626'
        screenRelatedParty.originatingSys = 'ESP';//SIEBEL
        
        return screenRelatedParty;
    }

    // TdB Screen Trading as Name
    /**
    * @description       : mapRequestTradingAsName
    * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
    * @return CASAScreenRelatedParty_Req_IB_v3
    * @param tradingNameRec
    *@param primaryClientRef
    * 1.0   03-29-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
    */
    public static CASAScreenRelatedParty_Req_IB_v3 mapRequestTradingAsName(Trading_as_Name__c tradingNameRec,String primaryClientRef){
        
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        CASAScreenRelatedParty_Req_IB_v3 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v3();
        screenRelatedParty.channel ='SALESFORCE';
        screenRelatedParty.application = 'SALESFORCE';
        screenRelatedParty.trace = '';
        screenRelatedParty.firstName = '';
        screenRelatedParty.surnameComp = tradingNameRec.Name;
        screenRelatedParty.idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, tradingNameRec.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
        screenRelatedParty.idRegNo = tradingNameRec.Registration_Incorporation_Number__c;
        screenRelatedParty.clientTypeGrp = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, tradingNameRec.Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
                
        screenRelatedParty.town = '';
        //screenRelatedParty.cntryOfBirth = '';

        screenRelatedParty.territory = '';
        screenRelatedParty.cntryOfRes = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, tradingNameRec.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
		screenRelatedParty.nationality = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, tradingNameRec.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
        
        screenRelatedParty.registerCity = '';
        //screenRelatedParty.countryPassport = 'SO003';//countryPassportP;
        screenRelatedParty.headofficeTown = '';
        screenRelatedParty.headofficeCntry = '';
        screenRelatedParty.headofficeOtherCntry1 = '';
        screenRelatedParty.headofficeOtherCntry2 = '';
        screenRelatedParty.headofficeOtherCntry3 = '';
        screenRelatedParty.headofficeOtherCntry4 = '';
        screenRelatedParty.headofficeOtherCntry5 = '';
        screenRelatedParty.primaryClientRef =  primaryClientRef;
        screenRelatedParty.relationship = '210305';
        screenRelatedParty.branch = userP[0].SiteCode__c;
        screenRelatedParty.teller = userP[0].Teller_Operator_Code__c;
        screenRelatedParty.originatingSys = 'ESP';

        return screenRelatedParty;
    }
   
    
/**
* @description       : mapResponseFields
* @return CASAScreenRelatedParty_Resp_IB_v3
* @param responseP
**/
    public static CASAScreenRelatedParty_Resp_IB_v3 mapResponseFields(HttpResponse responseP){
        
        CASAScreenRelatedParty_Resp_IB_v3 bean = new CASAScreenRelatedParty_Resp_IB_v3();
        CASAScreenRelatedParty_Resp_IB_v3 responseBean = (CASAScreenRelatedParty_Resp_IB_v3)bean.deserialize(responseP.getBody(), CASAScreenRelatedParty_Resp_IB_v3.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        return responseBean;
    }
    
    /**
     * @description       : Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param  statusCodeP
     * @param  statusP
     * @param  messageP
     * @return CASAScreenRelatedParty_Resp_IB_v3 bean object
     */    
    public static CASAScreenRelatedParty_Resp_IB_v3 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        CASAScreenRelatedParty_Resp_IB_v3 responseBean = new CASAScreenRelatedParty_Resp_IB_v3();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
/**
* @description       : mapFailedResponseFields
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 2021-11-08
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* @return CASAScreenRelatedParty_Req_IB_v3
* @param accountR
* @param primaryClientRef
* 
* 1.0   03-29-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
*/
    public static CASAScreenRelatedParty_Req_IB_v3 mapRequestStokvelaccountFields(AccountContactRelation accountR, String primaryClientRef ){
        
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        CASAScreenRelatedParty_Req_IB_v3 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v3();
        if(accountR != null && accountR.Contact != null)
        {
        screenRelatedParty.channel ='SALESFORCE';
        
        screenRelatedParty.application = 'SALESFORCE';
        screenRelatedParty.trace = 'Y';
        
            String dobstring = String.valueOf(accountR.Contact.Birthdate).replace('-','');
            
            if(dobstring != null){
                screenRelatedParty.dob = dobstring;//'19841026';
            }
            //for(Account accountR : accountP)
            {
                screenRelatedParty.firstName = accountR.Contact.FirstName;
                screenRelatedParty.surnameComp =  accountR.Contact.LastName;
                screenRelatedParty.idType = '01';//Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountR.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
                screenRelatedParty.idRegNo =  accountR.Contact.ID_Number__c;
                
                screenRelatedParty.clientTypeGrp = 'I';//Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountR.Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
                
                screenRelatedParty.town = '';
                screenRelatedParty.cntryOfBirth =  Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountR.Contact.Country_of_Birth__c, StringConstants.OUTBOUND_RECORD_TYPE);
                
                screenRelatedParty.territory = '';
                screenRelatedParty.cntryOfRes = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountR.Contact.Country_of_Residence__c, StringConstants.OUTBOUND_RECORD_TYPE);
                screenRelatedParty.nationality = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountR.Contact.Nationality__c, StringConstants.OUTBOUND_RECORD_TYPE);
                
                screenRelatedParty.registerCity = '';
                //screenRelatedParty.countryPassport = 'SO003';//countryPassportP;
                screenRelatedParty.headofficeTown = '';
                screenRelatedParty.headofficeCntry = '';
                screenRelatedParty.headofficeOtherCntry1 = '';
                screenRelatedParty.headofficeOtherCntry2 = '';
                screenRelatedParty.headofficeOtherCntry3 = '';
                screenRelatedParty.headofficeOtherCntry4 = '';
                screenRelatedParty.headofficeOtherCntry5 = '';
                screenRelatedParty.primaryClientRef =  primaryClientRef;
                screenRelatedParty.relationship = '210305';
                screenRelatedParty.branch = userP[0].SiteCode__c;
                screenRelatedParty.teller = userP[0].Teller_Operator_Code__c;
                screenRelatedParty.originatingSys = 'BDP';
                //}
               
            }
        }
         return screenRelatedParty;
    }
}