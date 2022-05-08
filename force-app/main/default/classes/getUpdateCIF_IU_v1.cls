/**
* @description Integration Utility for Update CIF Service
* @author Sharath / Mohammed
* @created 2021-04-26
*/
/**
     * @description getUpdateCIF_IU_v1
*/
public class getUpdateCIF_IU_v1 {
    

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-29 
    * @param address1 
    * @param address2 
    * @param suburbName 
    * @param cityName 
    * @param countryName 
    * @param postalCode 
    * @param indicatorIdInd 
    * @param indicatorAddressInd 
    * @param sourceIncome 
    * @param occupationStatus 
    * @param occupationCategory 
    * @param cif 
    * @param clientType 
    * @param idNumber 
    * @param jointsParentCode 
    * @return String 
    **/
    public static String mapRequestFields(string address1, string address2, string suburbName, string cityName, string countryName, string postalCode, string indicatorIdInd,string indicatorAddressInd, string sourceIncome, string occupationStatus, string occupationCategory, string cif , string clientType , string idNumber , string jointsParentCode){
        List<Integration_Translation__c> occupationCodelist = getUpdateCIF_IU_v1.getintegrationTranslation(occupationCategory,'Occupation Category');
        List<Integration_Translation__c> occupationStatusCodelist = getUpdateCIF_IU_v1.getintegrationTranslation(occupationStatus,'Occupation Status');
        List<Integration_Translation__c> incomeCodelist = getUpdateCIF_IU_v1.getintegrationTranslation(sourceIncome,'Source of Income');
        decimal incomeCode, occupationCode , occupationStatusCode;
        if(occupationCodelist.size() > 0 && occupationCodelist[0].External_Value__c != Null){
            occupationCode = integer.valueof(occupationCodelist[0].External_Value__c);
        }
        if(incomeCodelist.size() > 0 && incomeCodelist[0].External_Value__c != Null){
            incomeCode = integer.valueof(incomeCodelist[0].External_Value__c);
        } 
        
        if(occupationStatusCodelist.size() > 0 && occupationStatusCodelist[0].External_Value__c != Null){
            occupationStatusCode = integer.valueof(occupationStatusCodelist[0].External_Value__c);
        } 
        //system.debug('The occupation Code is :'+occupationCode[0]);
        //system.debug('The Income code is :'+incomeCode[0]);
        integration_translation__c countryCode;
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('inputHeaders');
        gen.writeStartObject();
        gen.writeFieldName('inputHeader');
        gen.writeStartObject();
        gen.writeStringField('consumerChannel', 'SALESFORCE');
        gen.writeStringField('providerApplication', 'FICREM');
        gen.writeStringField('traceIndicator', 'Y');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeFieldName('inputErrorMessage');
        gen.writeStartObject();
        gen.writeFieldName('errorMessageParameters');
        gen.writeStartObject();
        gen.writeStringField('messageLanguage', 'E');
        gen.writeStringField('messageTarget', 'STD');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeFieldName('CIupdClientAttestationV20Request');
        gen.writeStartObject();
        gen.writeFieldName('clientAttestationInputArea');
        gen.writeStartObject();
        String clientCode = jointsParentCode != '' ? jointsParentCode : cif;
        gen.writeStringField('clientCode', clientCode); //CIF  'STUURT+002'
        gen.writeStringField('confirmIdInd', indicatorIdInd);
        if(indicatorAddressInd == 'Y'){
            gen.writeStringField('confirmAddressInd', 'Y');    
        }else if(indicatorAddressInd == 'U'){
            gen.writeStringField('confirmAddressInd', 'U');    
        }else{
            gen.writeStringField('confirmAddressInd', 'N');
        }        
        gen.writeStringField('physicalAddressLine1', string.isNotEmpty(address1) ? address1 : '');
        gen.writeStringField('physicalAddressLine2',  string.isNotEmpty(address2) ? address2 : '');
        gen.writeStringField('physicalSuburb',  string.isNotEmpty(suburbName) ? suburbName : '');
        gen.writeStringField('physicalTown',  string.isNotEmpty(cityName) ? cityName : '');
        gen.writeNumberField('physicalRsaPostalCode',  string.isNotEmpty(postalCode) ? integer.valueof(postalCode) : 0);
        if(string.isNotEmpty(countryName)){
            countryCode = [select id, internal_value__c, external_value__c 
                           from integration_translation__c 
                           where direction__c = 'Outbound' 
                           and value_type__c = 'Country' 
                           and system_name__c = 'CIF' 
                           and internal_value__c =:countryName ];    
        }
        //this methosd added to get related codes from integration traslation object 
        map<string,map<string,string>> getTranslationvalues=getTranslationvalues();
        map<string,string>getcodevalues=new map<string,string>();
        
        gen.writeStringField('physicalCountryCode',  countryCode !=null ? countryCode.external_value__c : '');
        //removing the below fields are we are going to correct only address level details in this service
        gen.writeStringField('confirmContactDetailsInd', 'N');
        gen.writeNumberField('cellphoneNumber', 0);
        gen.writeNumberField('homeTelephoneDialCode', 0);
        gen.writeNumberField('homeTelephoneNumber', 0);
        gen.writeNumberField('workTelephoneDialCode', 0);
        gen.writeNumberField('workTelephoneNumber', 0);
        gen.writeStringField('emailAddress', '');
        gen.writeStringField('confirmRbaOtherRefreshInd', 'U');
        if(!getTranslationvalues.isEmpty() && getTranslationvalues.ContainsKey('Source of Income')){
            getcodevalues=getTranslationvalues.get('Source of Income');
        }
        gen.writeNumberField('sourceOfIncomeCode', incomeCode != null ? incomeCode : 0);
        gen.writeNumberField('occupationCode', occupationCode != null ? occupationCode : 0);
        /*
        if(!getTranslationvalues.isEmpty() && getTranslationvalues.ContainsKey('Occucode')){
            getcodevalues=getTranslationvalues.get('Occucode');
        }
        gen.writeNumberField('occupationCode',!getcodevalues.IsEmpty() && getcodevalues.ContainsKey('Occucode')?integer.valueof(getcodevalues.get('Occucode')): 0);
        if(!getTranslationvalues.isEmpty() && getTranslationvalues.ContainsKey('Occupation Status')){
            getcodevalues=getTranslationvalues.get('Occupation Status');
        }*/
       // occupationCode
        gen.writeNumberField('occupationStatusCode', occupationStatusCode != null ? occupationStatusCode : 0); 
        //Joint & Several
        //gen.writeStringField('occupationLevelCode', ''); Removed as suggested by Nagesh
        //if(clientType != null && (clientType == 'Joint & Several' || clientType == 'Joint and Several')){
           gen.writeStringField('participantIdType', '01');
           gen.writeStringField('participantIdNumber', idNumber);
 
       // }
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
    
/**
     * @description  Creates a bean from the response 
    * @param responseP
    * @return getUpdateCIFParser 
    */
    public static getUpdateCIFParser mapResponseFields(HttpResponse responseP)
    {            
        string response = responseP.getBody();
        getUpdateCIFParser responseBean;
        try{
            responseBean = getUpdateCIFParser.parse(response);
            responseBean.status = responseP.getStatus();
            responseBean.statusCode = responseP.getStatusCode();
            responseBean.message = '';    
            
        }catch(exception ex){
            //Exception Handling
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + ex.getMessage() + '. ' + ex.getStackTraceString();
            responseBean = new getUpdateCIFParser();
            responseBean.status = responseP.getStatus();
            responseBean.statusCode = responseP.getStatusCode();
            responseBean.message = message; 
        }
        return responseBean;
        
    }
    
/**
     * @description  Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param statusCodeP
    * @param statusP
    * @param messageP
    * @return getUpdateCIFParser  
    * */    
    public static getUpdateCIFParser mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        getUpdateCIFParser responseBean = new getUpdateCIFParser();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    /**
     * @method getTranslationvalues
     * @description This method returns integration translation values
    * @return codesMap 
    * */    
    
    public static map<string,map<string,string>> getTranslationvalues(){
        map<string,map<string,string>> codesMap=new map<string,map<string,string>>();
        //Query Occucode for Occupation_Category (Professional/Administration/Clerical/Sales Person)
        //Query occupationStatusCode for Occupation_Status
        
        for(Integration_Translation__c it: [SELECT id,Name,External_Value__c,Internal_Value__c,Value_Type__c        
                                            from Integration_Translation__c
                                            Where (Direction__c='Outbound' AND System_Name__c='CIFCodesList' AND Value_Type__c!=NULL)
                                            OR (Value_Type__c='Occucode' OR Value_Type__c='Occupation Status')
                                            OR (Value_Type__c='Source of Funds' OR Value_Type__c='Source of Income')
                                           ]){
                                               if(!codesMap.containsKey(it.Value_Type__c)){
                                                   map<string,string> innerMap=new map<string,string>();
                                                   innerMap.put(it.Internal_Value__c,it.External_Value__c);
                                                   codesMap.put(it.Value_Type__c,innerMap);
                                               }
                                               else if(codesMap.containsKey(it.Value_Type__c)){       
                                                   codesMap.get(it.Value_Type__c).put(it.Internal_Value__c,it.External_Value__c);
                                               }
                                           }
        return codesMap;
    }

    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-08-17 
    * @param translationName 
    * @param valueType 
    * @return List<Integration_Translation__c> 
    **/
    public static List<Integration_Translation__c> getintegrationTranslation(string translationName, String valueType){
        List<Integration_Translation__c> translationlist = new List<Integration_Translation__c>();
        translationlist = [SELECT id,Name,External_Value__c,Internal_Value__c,Value_Type__c        
                           from Integration_Translation__c where Name =: translationName AND Direction__c='Outbound' AND System_Name__c='CIFCodesList' AND Value_Type__c =: valueType];
        return translationlist;
        
    }
}