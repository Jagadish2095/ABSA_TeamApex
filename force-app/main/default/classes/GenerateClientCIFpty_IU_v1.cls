/*
* Utility class for generating client CIF 
*
* @author  Haritha Police : Absa
* @version v1.0
* @since   2019-11-28
*
*/
public class GenerateClientCIFpty_IU_v1 {

     //mapping request fields for Business prospect (Pty.Ltd company)
    public static GenerateClientCIFpty_Req_IB_v1 mapBusinessClientRequestFieldsforpty(Account accountP, User userP, Map<String, String> tanslationValueMapP){
        
        GenerateClientCIFpty_Req_IB_v1 requestBean = new GenerateClientCIFpty_Req_IB_v1();
        
        requestBean.application = 'BDP';
        requestBean.channel = StringConstants.SALESFORCE_STRING.toUpperCase();
        requestBean.trace = 'N';
        requestBean.titleCode = '0';
        requestBean.language = 'E';
        if(accountP.Name != null){
         requestBean.surname = accountP.Name.toUpperCase();
        }
        requestBean.idType = '0';
        requestBean.idNumber = accountP.ID_Number__pc;
        requestBean.birthDate = '0';
        requestBean.maritalStatus = '0';
        requestBean.gender = '0';
        requestBean.occupationCode = '0';
        requestBean.branchClientOpen ='8604' ;
        requestBean.noOfJointPartcpnt='0';
        if(userP.BRID__c != null){
            requestBean.tellerLastChanged = userP.BRID__c.subString(2);//'09999996'
        }
        requestBean.mariageCntrctType = '0';
        requestBean.NonCRInd = 'Y';//Translation
        requestBean.clientType = tanslationValueMapP.get('clientTypeTranslated');//Translation//'002301';
        requestBean.militaryComtmntInd = '';
        requestBean.occupancyType = '0';//Translation = TBC
        requestBean.homeTelCode = '0';
        requestBean.homeTelephone = '';
        requestBean.workTelCode = '0';
        requestBean.workTelephone = accountP.Phone;
        requestBean.occupationStatus = '0';
        requestBean.emailAddress = accountP.PersonEmail;
        requestBean.incomeGroup = '0';
        requestBean.prefrdCommtionMthd = '04';
        requestBean.clientNationality = '';
        requestBean.countryOfOrigin = '';
        requestBean.SAtaxNumber = '0';
        requestBean.companyYearEnd = '01';
        requestBean.dateExempted = '0';//Zero until is business rule is provided
        requestBean.corporateDivision = '?';
        requestBean.haveQualification = '';
        requestBean.socialGrant = '';
        requestBean.secondaryCard = '';
        requestBean.postlCodeRsa='2001';
        requestBean.dateIssued = '0';//Zero until is business rule is provided
        requestBean.employerAddrType = '0';
        requestBean.physicalAddrType = '0';
        requestBean.thrdPartyInd = 'N';       //Default
        requestBean.updAddressInd = 'N';//Default
        requestBean.updTelephoneInd = 'N';//Default
        requestBean.updEmailInd = 'N';//Default
        requestBean.updDateInd = '0';//Default
        requestBean.casaRefNum = accountP.CASA_Reference_Number__c;
        requestBean.countryOfBirth = '';//Translation
        requestBean.ClientAgrmntIssued = '';
        System.debug('CIF Create Client Request' + requestBean);
        return requestBean;
    }
    
    public static GenerateClientCIFpty_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        GenerateClientCIFpty_Resp_IB_v1 responseBean = (GenerateClientCIFpty_Resp_IB_v1)JSON.deserialize( respP.getBody(), GenerateClientCIFpty_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('CIF Create Client Response' + responseBean);
        return responseBean;
    }
    
    public static GenerateClientCIFpty_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        GenerateClientCIFpty_Resp_IB_v1 responseBean = new GenerateClientCIFpty_Resp_IB_v1();
        responseBean.Status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        System.debug('CIF Create Client Failed Response' + responseBean);
        return responseBean;
    }
}