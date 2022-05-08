/**
 * @description       : Integration Utility for Compliance Pack Service
 * @author            : Sharath
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-02-24   Sharath         Initial Version
**/

public class GetCompliancePackInfo_IU_v1 {

    /**
    * @description Creates the request JSON using JSON Generator
    * @param accountRec
    * @return String
    **/
    public static String mapRequestFields(account accountRec){
        string idType = '';
        string idNumber = '';
        string clientType = '';
        string riskRating = '';
        string pType = '';
        system.debug('%$ The acccount client group is :' +accountRec.Client_group__c);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('content');

        gen.writeStartObject();
        if((accountRec.Client_group__c !=null && accountRec.Client_group__c == 'Individual') ||  accountRec.Client_type__c == 'Individual'){
            if(accountRec.Business_Start_Date__c != null ){
                gen.writeStringField('dateOfBirthOrIncorporationDate',accountRec.Business_Start_Date__c != null ? string.valueOf(accountRec.Business_Start_Date__c) : '');
            }else if(accountRec.PersonBirthdate != null ){
                gen.writeStringField('dateOfBirthOrIncorporationDate',accountRec.PersonBirthdate != null ? string.valueOf(accountRec.PersonBirthdate) : '');
            }
            gen.writeFieldName('party');
            gen.writeStartObject();
            gen.writeFieldName('individual');
            gen.writeStartObject();
            gen.writeFieldName('residentialStatus');
            gen.writeStartObject();
            gen.writeStringField('code', 'SA RESIDENT');
            gen.writeStringField('description', 'SA RESIDENT');
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
            // gen.writeStringField('partyType', accountRec.Client_Type__c != null ? accountRec.Client_Type__c : '');

        }else if(accountRec.Client_group__c !=null && accountRec.Client_group__c == 'SOLE TRADER CLIENT' ){
            gen.writeFieldName('party');
            gen.writeStartObject();
            if(accountRec.Registration_Number__c != Null ){
                gen.writeFieldName('formalOrganisation');
            }else{
                gen.writeFieldName('informalOrganisation');
            }
            gen.writeStartObject();
            gen.writeFieldName('type');
            gen.writeStartObject();
            gen.writeStringField('code', 'SOLE TRADER CLIENT');
            gen.writeStringField('description', 'SOLE TRADER CLIENT');
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
            //  gen.writeStringField('partyType', accountRec.Client_Type__c != null ? accountRec.Client_Type__c : '');

        }else if(accountRec.Client_group__c !=null && accountRec.Client_group__c == 'Non Individual'){
            gen.writeFieldName('party');
            gen.writeStartObject();
            if(accountRec.Registration_Number__c != Null ){
                gen.writeFieldName('formalOrganisation');
            }else{
                gen.writeFieldName('informalOrganisation');
            }
            gen.writeStartObject();
            gen.writeFieldName('type');
            gen.writeStartObject();
            if( accountRec.Client_Type__c != null){
                if( accountRec.Client_Type__c == 'Private Company'){
                    clientType = 'Private company';
                }
            }
            gen.writeStringField('code', clientType);
            gen.writeStringField('description', clientType);
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
            //  gen.writeStringField('partyType', 'Organisation');
        }
        else if(accountRec.Client_group__c !=null && accountRec.Client_group__c == 'PARTNERSHIP CLIENT'){
            gen.writeFieldName('party');
            gen.writeStartObject();
            gen.writeFieldName('formalOrganisation');
            gen.writeStartObject();
            gen.writeFieldName('type');
            gen.writeStartObject();
            gen.writeStringField('code', 'Partnership');
            gen.writeStringField('description', 'Partnership');
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
        }
        else if(accountRec.Client_group__c !=null && accountRec.Client_group__c == 'JOINT AND SEVERAL CLIENT'){
            gen.writeFieldName('party');
            gen.writeStartObject();
            gen.writeFieldName('formalOrganisation');
            gen.writeStartObject();
            gen.writeFieldName('type');
            gen.writeStartObject();
            gen.writeStringField('code', 'Joint & several');
            gen.writeStringField('description', 'Joint & several');
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
        }
        else if(accountRec.Client_group__c !=null && accountRec.Client_group__c == 'Estate Client'){
            gen.writeFieldName('party');
            gen.writeStartObject();
            gen.writeFieldName('formalOrganisation');
            gen.writeStartObject();
            gen.writeFieldName('type');
            gen.writeStartObject();
            gen.writeStringField('code', 'Estate late client');
            gen.writeStringField('description', 'Estate late client');
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
        }
        // Changes made by Mohammed as per discussion
        if(accountRec.Client_Type__c == 'Sole Trader' || accountRec.Client_Type__c == 'Sole Proprietor' || accountRec.Client_Type__c == 'Private Company'){
            pType = 'SoleTrader';
        }
        else if(accountRec.Client_Type__c == 'Individual' || accountRec.Client_Type__c =='Individual - Minor' || accountRec.Client_Type__c == 'Non - Resident Entity' || accountRec.Client_Type__c == 'Private Individual' || accountRec.Client_Type__c == 'Staff' || accountRec.Client_Type__c == 'Staff Joint and Several'){
            pType = 'Individual';
        }
        else{
            pType = 'Organisation';
        }
        /*  if(accountRec.ID_Type__c != null || accountRec.ID_Type__pc != null ){
if(accountRec.ID_Type__c == 'CIF' || accountRec.ID_Type__pc == 'CIF'){
idType = 'CIF Code';
if(accountRec.CIF__c != null ){
idNumber = accountRec.CIF__c;
}else if(accountRec.CIF__pc != null ){
idNumber = accountRec.CIF__pc;
}else if(accountRec.CIF__c == null && accountRec.CIF__pc == null){
idNumber = accountRec.ID_Number__pc;
}
}else if(accountRec.ID_Type__c == 'SA Identity Document' || accountRec.ID_Type__pc == 'SA Identity Document'){
idType = 'ID Number';
idNumber =  accountRec.ID_Number__pc;
}else if(accountRec.ID_Type__c == 'Passport' || accountRec.ID_Type__pc == 'Passport'){
idType = 'Passport';
idnumber =  accountRec.ID_Number__pc;
}else if(accountRec.ID_Type__c == 'Registration Number' || accountRec.ID_Type__pc == 'Registration Number'){
idType = 'Registration Number';
idnumber = accountRec.Registration_Number__c;
}else if(accountRec.ID_Type__c == 'Temporary ID Document' || accountRec.ID_Type__pc == 'Temporary ID Document'){
idType = 'SUIN';
idnumber =  accountRec.ID_Number__pc;
}
} */
        if(accountRec.SUIN__c != null){
            idType = 'SUIN';
            idnumber =  accountRec.SUIN__c;
        }
        else if(accountRec.CIF__c != null ){
            idType = 'CIF Code';
            idnumber =  accountRec.CIF__c;
        }
        else if( pType == 'SoleTrader' || pType == 'Organisation'){
            if(accountRec.Registration_Number__c != null){
                idnumber =  accountRec.Registration_Number__c;
                idType = 'Registration Number';
            }
            else if(accountRec.ID_Number__pc != null){
                idnumber =  accountRec.ID_Number__pc;
                idType = 'ID Number';
            }
        }
        else if(pType == 'Individual'){
           if(accountRec.ID_Number__pc != null){
                idnumber =  accountRec.ID_Number__pc;
                idType = 'ID Number';
            }
        }

        gen.writeStringField('partyType', pType); // Changes Ends here
        gen.writeFieldName('primaryId');
        gen.writeStartObject();
        gen.writeStringField('number', idnumber);
        gen.writeFieldName('type');
        gen.writeStartObject();
        gen.writeStringField('code', idType);
        gen.writeStringField('description', idType);
        gen.writeEndObject();
        gen.writeEndObject();
        if(accountRec.Risk_Rating__c != null){
            riskRating = accountRec.Risk_Rating__c;
        }else if(accountRec.Risk_Rating__pc != null){
            riskRating = accountRec.Risk_Rating__pc;
        }
        gen.writeStringField('riskRating', riskRating);
        gen.writeEndObject();
        system.debug('the json string --> '+gen.getAsString());
        gen.close();
        return gen.getAsString();
    }

    /**
    * @description Creates a bean from the response
    * @param responseP
    * @return GetCompliancePackInfo_Resp_Parse
    **/
    public static GetCompliancePackInfo_Resp_Parse mapResponseFields(HttpResponse responseP)
    {
        string response = responseP.getBody();
        GetCompliancePackInfo_Resp_Parse responseBean = new GetCompliancePackInfo_Resp_Parse();
        try{
            responseBean = GetCompliancePackInfo_Resp_Parse.parse(response);
            responseBean.status = responseP.getStatus();
            responseBean.statusCode = responseP.getStatusCode();
            responseBean.message = '';

        }catch(exception ex){
            //Exception Handling
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + ex.getMessage() + '. ' + ex.getStackTraceString();
            System.debug(ex.getMessage());
            System.debug(message);
        }
        return responseBean;

    }

    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param statusCodeP
    * @param statusP
    * @param messageP
    * @return GetCompliancePackInfo_Resp_Parse
    **/
    public static  GetCompliancePackInfo_Resp_Parse mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {
        GetCompliancePackInfo_Resp_Parse responseBean = new GetCompliancePackInfo_Resp_Parse();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        return responseBean;
    }
}