public class UpdateJntPartByClientCode_IU_v1 {

    public static UpdateJntPartByClientCode_Req_IB_v1 mapRequestFields(String clientCodeP, String appliactionP, String branchP, String actionCodeP, List<Account>accountListP, User userP, CvsValidationService_Resp_IB_v1 addressBeanP){
        
        String errorMessage = '';
        
        UpdateJntPartByClientCode_Req_IB_v1 requestBean = new UpdateJntPartByClientCode_Req_IB_v1();
        List<UpdateJntPartByClientCode_Req_IB_v1.cls_jntEntry> jointPerticiepntList = new List<UpdateJntPartByClientCode_Req_IB_v1.cls_jntEntry>();
        
        requestBean.channel = StringConstants.SALESFORCE_STRING.toUpperCase();
        requestBean.application = appliactionP;
        requestBean.trace = '';
        requestBean.clientCode = clientCodeP;//OutputKey from CIF
        requestBean.teller = userP.BRID__c.subString(2); //Remove the first 2 digits/characters from the BRID
        requestBean.branch = branchP;
        requestBean.nbrOfRecords = String.valueOf(accountListP.size());
        
        for(Account account : accountListP){
            
            String titleCodeTranslated;
            if(account.PersonTitle != null){
                String personTitle;
                if(account.PersonTitle.contains('.')){
                    personTitle = account.PersonTitle;
                }else{
                    personTitle = account.PersonTitle + '.';
                }
                titleCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Title', personTitle, StringConstants.OUTBOUND_RECORD_TYPE);
            }
            
            String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, account.ID_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, account.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_NATIONALITY_STRING, account.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String countryOfOriginTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_COUNTRY_STRING, account.Country_of_Origin__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_COUNTRY_STRING, account.Country_of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_COUNTRY_STRING, account.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String occupationStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_OCCUPATION_STATUS_STRING, account.Occupation_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            String occupationCategoryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_OCCUPATION_CATEGORY_STRING, account.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
            
            errorMessage += idTypeTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_IDENTITY_TYPE + account.ID_Type__pc + ' for Contact: ' + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += titleCodeTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_TITLE + account.PersonTitle + ' for Contact: ' + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += incomeSourceTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_INCOME_SOURCE + account.Income_Source__pc + ' for Contact: ' + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += nationalityTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_NATIONALITY + account.Nationality__pc + ' for Contact: ' + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += countryOfOriginTranslated == null ? 'Unable to Map Country Of Origin: ' + account.Country_of_Origin__pc + ' for Contact: ' + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += countryOfResTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_RESIDENCE + account.Country_of_Residence__pc + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += countryOfBirthTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_BIRTH + account.Country_of_Birth__pc + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += occupationStatusTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_STATUS + account.Occupation_Status__pc + account.FirstName + ' ' + account.LastName + '. ' : '';
            errorMessage += occupationCategoryTranslated == null ? StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_CATEGORY + account.Occupation_Category__pc + account.FirstName + ' ' + account.LastName + '. ' : '';
            
            UpdateJntPartByClientCode_Req_IB_v1.cls_jntEntry jointPerticiepntObj = new UpdateJntPartByClientCode_Req_IB_v1.cls_jntEntry();
            jointPerticiepntObj.actionCode = actionCodeP;
            jointPerticiepntObj.idDocType = idTypeTranslated;//Translation
            jointPerticiepntObj.idDocNbr = account.ID_Number__pc;
            jointPerticiepntObj.initials = account.Initials__pc;
            jointPerticiepntObj.titleCode = titleCodeTranslated;//Translation
            jointPerticiepntObj.surname = account.LastName;
            
            if(addressBeanP.addressCollection != null && addressBeanP.addressCollection.size() > 0){
                for(CvsValidationService_Resp_IB_v1.cls_addressCollection conAddress : addressBeanP.addressCollection){
                    if(conAddress.accountSFId == account.Id && conAddress.addressTypeSF == 'Billing'){
                        jointPerticiepntObj.addressLine1 = conAddress.addressLine1;
                        jointPerticiepntObj.addressLine2 = conAddress.addressLine2;
                        jointPerticiepntObj.suburbRsa = '';
                        jointPerticiepntObj.town = conAddress.town;
                        jointPerticiepntObj.postalCode = conAddress.postalCode;
                    }
                }
            }
            if(account.FirstName != null && account.MiddleName != null){
                jointPerticiepntObj.firstNames = account.FirstName + account.MiddleName;
            }else{
                jointPerticiepntObj.firstNames = account.FirstName;
            }
            if(account.PersonHomePhone != null){
                jointPerticiepntObj.homeTelephoneCode = account.PersonHomePhone.Substring(0, 3);
                jointPerticiepntObj.homeTelephoneNbr = account.PersonHomePhone.Substring(3, 10);
            }else{
                jointPerticiepntObj.homeTelephoneCode = '0';
            }
            if(account.Phone != null){
                jointPerticiepntObj.workTelephoneCode = account.Phone.Substring(0, 3);
                jointPerticiepntObj.workTelephoneNbr = account.Phone.Substring(3, 10);
            }else{
                jointPerticiepntObj.workTelephoneCode = '0';
            }
            
            if(account.PersonMobilePhone != null){
                String phoneNumber = account.PersonMobilePhone;
                
                if(phoneNumber.length() > 10){
                    //Take last 10 Digits
                    Integer numberLength = phoneNumber.length();
                    jointPerticiepntObj.cellphoneNbr = phoneNumber.Substring(numberLength - 10, numberLength);
                    
                }else if(phoneNumber.length() < 10){
                    //Add 0 infront until number is 10 digits
                    while(phoneNumber.length() < 10){
                        phoneNumber = '0' + phoneNumber;
                    }
                    jointPerticiepntObj.cellphoneNbr = phoneNumber;
                }else{
                    //Number is the correct length
                    jointPerticiepntObj.cellphoneNbr = phoneNumber;
                }
            }else{
                jointPerticiepntObj.cellphoneNbr = '0000000000';
            }
            if(account.PersonBirthdate != null){
                jointPerticiepntObj.birthDate = String.valueOf(account.PersonBirthdate).replace('-','');
            }
            jointPerticiepntObj.sourceOfIncome = incomeSourceTranslated;//Translation
            
            jointPerticiepntObj.dateClientFicaIden = '0';
            jointPerticiepntObj.dateClientFicaVeri = '0';
            jointPerticiepntObj.employeeIdentified = '0';
            jointPerticiepntObj.employeeVerified = '0';
            
            if(account.Income_Tax_Number__pc != null){
                jointPerticiepntObj.taxNumber = String.valueOf(account.Income_Tax_Number__pc);
            }else{
                jointPerticiepntObj.taxNumber = '0';
            }
            jointPerticiepntObj.clientNationality = nationalityTranslated;//Translation
            jointPerticiepntObj.countryOfOrigin = countryOfOriginTranslated;//Translation
            
            jointPerticiepntObj.permitExpiryDate = '0';
            jointPerticiepntObj.controllerOverideNbr = '0';
            jointPerticiepntObj.groupScheme = '0';
            jointPerticiepntObj.dateIssued = '0';
            jointPerticiepntObj.dateExempted = '0';
            
            jointPerticiepntObj.countryOfRes =  countryOfResTranslated;//Translation
            jointPerticiepntObj.countryOfBirth = countryOfBirthTranslated;//Translation
            jointPerticiepntObj.occupationStatus = occupationStatusTranslated;//Translation
            jointPerticiepntObj.occupationCode = occupationCategoryTranslated;//Translation
            
            //Currently Out Of Scope
            List<UpdateJntPartByClientCode_Req_IB_v1.cls_foreignTaxData> taxDataList = new List<UpdateJntPartByClientCode_Req_IB_v1.cls_foreignTaxData>();
            UpdateJntPartByClientCode_Req_IB_v1.cls_foreignTaxData taxDataObj = new UpdateJntPartByClientCode_Req_IB_v1.cls_foreignTaxData();
            taxDataObj.foreignTaxCtry = '';
            taxDataObj.foreignTaxNo = '';
            taxDataObj.rsonFtaxNotGiven = '';
            taxDataList.add(taxDataObj);
            jointPerticiepntObj.foreignTaxData = taxDataList;
            
            jointPerticiepntList.add(jointPerticiepntObj);
        }
        
        requestBean.jntEntry = jointPerticiepntList;
        requestBean.errorMessage = errorMessage;
        return requestBean;
    }
    
    public static UpdateJntPartByClientCode_Resp_IB_v1 mapResponseFields(HttpResponse responseP){
        
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean = new UpdateJntPartByClientCode_Resp_IB_v1();
        
        responseBean = (UpdateJntPartByClientCode_Resp_IB_v1)responseBean.deserialize( responseP.getBody(), UpdateJntPartByClientCode_Resp_IB_v1.class );
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        
        return responseBean;
    }
    
    public static UpdateJntPartByClientCode_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statuscodeP, String messageP){
        
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean = new UpdateJntPartByClientCode_Resp_IB_v1();
        
        responseBean.status = statusP;
        responseBean.statusCode = statuscodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}