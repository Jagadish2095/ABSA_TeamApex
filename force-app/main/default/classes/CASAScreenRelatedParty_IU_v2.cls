/*
* Integration Utility Bean for CASAScreenRelatedParty Service
* @author Pitso Sekhu
* @created 2019-03-13
*/

public class CASAScreenRelatedParty_IU_v2  
{
    public static CASAScreenRelatedParty_Req_IB_v2 mapRequestFields(String channel, String application, 
    String trace, String firstName, String surnameComp, String idType, String idRegNo, String clientTypeGrp, 
    String dob, String nationality, String town, String cntryOfRes, String cntryOfBirth, String primaryClientRef, 
    String relationship, String branch, String teller, String originatingSys)
    {           
        CASAScreenRelatedParty_Req_IB_v2 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v2();
        screenRelatedParty.channel = channel;
		screenRelatedParty.application = application;
		screenRelatedParty.trace = trace;
		screenRelatedParty.firstName = firstName;
		screenRelatedParty.surnameComp = surnameComp;
		screenRelatedParty.idType = idType;
		screenRelatedParty.idRegNo = idRegNo;
		screenRelatedParty.clientTypeGrp = clientTypeGrp;
		screenRelatedParty.dob = dob;
		screenRelatedParty.nationality = nationality;
		screenRelatedParty.town = town;
		screenRelatedParty.cntryOfRes = cntryOfRes;
		screenRelatedParty.cntryOfBirth = cntryOfBirth;
		screenRelatedParty.primaryClientRef = primaryClientRef;
		screenRelatedParty.relationship = relationship;
		screenRelatedParty.branch = branch;
		screenRelatedParty.teller = teller;
		screenRelatedParty.originatingSys = originatingSys;
        //screenRelatedParty.countryPassport = '';
       
        System.debug('CASAScreen Related Party Request Bean: ' + screenRelatedParty);
        return screenRelatedParty;
    }
    
    public static CASAScreenRelatedParty_Req_IB_v2 mapRequestJntAccountFields(Account accountP, String countryOfResP, String countryOfBirthP, String nationalityP, String iDTypeAccountP, User userP, String primaryClientRefP, String countryPassportP){
        
        CASAScreenRelatedParty_Req_IB_v2 screenRelatedParty = new CASAScreenRelatedParty_Req_IB_v2();
        screenRelatedParty.channel = StringConstants.SALESFORCE_STRING;
		screenRelatedParty.application = 'WILLS';
		screenRelatedParty.trace = 'Y';
		screenRelatedParty.firstName = accountP.FirstName;
		screenRelatedParty.surnameComp = accountP.LastName;
		screenRelatedParty.idType = iDTypeAccountP;
		screenRelatedParty.idRegNo = accountP.ID_Number__pc;
		screenRelatedParty.clientTypeGrp = 'I';
		screenRelatedParty.dob = String.valueOf(accountP.PersonBirthdate).replace('-','');
		screenRelatedParty.nationality = nationalityP;
		screenRelatedParty.town = '';
		screenRelatedParty.cntryOfRes = countryOfResP;
		screenRelatedParty.cntryOfBirth = countryOfBirthP;
		screenRelatedParty.primaryClientRef = primaryClientRefP;
		screenRelatedParty.relationship = '210305';
		screenRelatedParty.branch = '2626';
		screenRelatedParty.teller = userP.AB_Number__c;
		screenRelatedParty.originatingSys = 'WILLS';
        screenRelatedParty.countryPassport = countryPassportP; //contactP.CountryPassport__c
       
        System.debug('CASAScreen Related Party Request Bean: ' + screenRelatedParty);
        return screenRelatedParty;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CASAScreenRelatedParty_Resp_IB_v2 bean object
     */
    public static CASAScreenRelatedParty_Resp_IB_v2 mapResponseFields(HttpResponse responseP)
    {              
        CASAScreenRelatedParty_Resp_IB_v2 bean = new CASAScreenRelatedParty_Resp_IB_v2();
        CASAScreenRelatedParty_Resp_IB_v2 responseBean = (CASAScreenRelatedParty_Resp_IB_v2)bean.deserialize(responseP.getBody(), CASAScreenRelatedParty_Resp_IB_v2.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CASAScreenRelatedParty_Resp_IB_v2 bean object
     * */    
    public static CASAScreenRelatedParty_Resp_IB_v2 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        CASAScreenRelatedParty_Resp_IB_v2 responseBean = new CASAScreenRelatedParty_Resp_IB_v2();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }

}