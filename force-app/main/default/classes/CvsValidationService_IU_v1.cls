/**
 * @description       : CvsValidationService_IU_v1
 * @last modified on  : 2021-08-24
 * @last modified by  : Manish.battu@absa.africa
 * Removed the jimmyclass method
**/
public class CvsValidationService_IU_v1{
    /**
    * @description Creates a bean from the response
    * @param responseP HTTP Response
    * @return CvsValidationService_Resp_IB_v1 
    **/
    public static CvsValidationService_Resp_IB_v1 mapResponseFields(HttpResponse responseP){

        CvsValidationService_Resp_IB_v1 bean = new CvsValidationService_Resp_IB_v1();
        CvsValidationService_Resp_IB_v1 responseBean = (CvsValidationService_Resp_IB_v1)bean.deserialize(responseP.getBody(), CvsValidationService_Resp_IB_v1.class);

        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        return responseBean;
    }
    /**
    * @description Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @author Manish.battu@absa.africa | 2021-08-24 
    * @param statusCodeP Status Code
    * @param statusP Status
    * @param messageP message
    * @return CvsValidationService_Resp_IB_v1 
    **/
    public static CvsValidationService_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){

        CvsValidationService_Resp_IB_v1 responseBean = new CvsValidationService_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        return responseBean;
    }

    /**
    * @description mapIndividualRequestFields
    * @param accountP
    * @param addressListP
    * @param clientTypeGroupP
    * @param tanslationValueMapP
    * @return CvsValidationService_Req_IB_v1
    **/
    public static CvsValidationService_Req_IB_v1 mapIndividualRequestFields(Account accountP, List<Address__c> addressListP, String clientTypeGroupP, Map<String, String> tanslationValueMapP){

        //initiate beans
        CvsValidationService_Req_IB_v1 cvsValBean = new CvsValidationService_Req_IB_v1();
        CvsValidationService_Req_IB_v1.cls_Client cvsValClientBean = new CvsValidationService_Req_IB_v1.cls_Client();
        CvsValidationService_Req_IB_v1.cls_ContactInfo cvsValContactInfoBean = new CvsValidationService_Req_IB_v1.cls_ContactInfo();
        CvsValidationService_Req_IB_v1.cls_PostalAddress cvsValPostalAddBean = new CvsValidationService_Req_IB_v1.cls_PostalAddress();
        CvsValidationService_Req_IB_v1.cls_HomeAddress cvsValHomeAddBean = new CvsValidationService_Req_IB_v1.cls_HomeAddress();
        CvsValidationService_Req_IB_v1.cls_WorkAddress cvsValWorkAddBean = new CvsValidationService_Req_IB_v1.cls_WorkAddress();
        CvsValidationService_Req_IB_v1.cls_IdNumber cvsValIdNumberBean = new CvsValidationService_Req_IB_v1.cls_IdNumber();
        CvsValidationService_Req_IB_v1.cls_EmploymentInfo cvsValEmploymentInfoBean = new CvsValidationService_Req_IB_v1.cls_EmploymentInfo();
        CvsValidationService_Req_IB_v1.cls_MarketingInfo cvsValMarketInfoBean = new CvsValidationService_Req_IB_v1.cls_MarketingInfo();
        CvsValidationService_Req_IB_v1.cls_Header cvsValheaderBean = new CvsValidationService_Req_IB_v1.cls_Header();
        CvsValidationService_Req_IB_v1.cls_HomePhone cvsValHomePhoneBean = new CvsValidationService_Req_IB_v1.cls_HomePhone();
        CvsValidationService_Req_IB_v1.cls_WorkPhone cvsValWorkPhoneBean = new CvsValidationService_Req_IB_v1.cls_WorkPhone();
        CvsValidationService_Req_IB_v1.cls_Fica cvsValFicaBean = new CvsValidationService_Req_IB_v1.cls_Fica();
        //map fields
        cvsValClientBean.initials = accountP.Initials__pc;
        cvsValClientBean.homeLanguage = tanslationValueMapP.get('comLanguageTranslated');
        cvsValClientBean.titleCode = tanslationValueMapP.get('personTitleTranslated');
        if(accountP.PersonBirthdate != null){
            DateTime birthDate = accountP.PersonBirthdate;
            cvsValClientBean.dateOfBirth = birthDate.format('ddMMyyyy');
        }
        cvsValClientBean.maritalStatus = tanslationValueMapP.get('maritalStatusTranslated');            
        cvsValClientBean.gender = tanslationValueMapP.get('genderTranslated');
        cvsValClientBean.maritalContractType = tanslationValueMapP.get('maritalContractTranslated');
        cvsValClientBean.firstname = accountP.FirstName;
        cvsValClientBean.surname = accountP.LastName;
        cvsValClientBean.nationalityCode = tanslationValueMapP.get('nationalityTranslated');
        cvsValClientBean.countryOfBirthCode = tanslationValueMapP.get('countryOfBirthTranslated');
        //cvsValClientBean.postMatricQualification = 'N';           //TBC
        cvsValClientBean.postMatricIndicator = 'N';         //TBC
        cvsValClientBean.socialGrant = 'N';
        cvsValClientBean.correspondenceLanguage = tanslationValueMapP.get('comLanguageTranslated');
        cvsValClientBean.clientCode = accountP.CIF__c;
        cvsValIdNumberBean.documentType = tanslationValueMapP.get('idTypeTranslated');
        cvsValIdNumberBean.valNumber = accountP.ID_Number__pc;//'P595959'
        //cvsValIdNumberBean.dateIssued = '0';      //TBC
        cvsValIdNumberBean.countryOfIssueCode = tanslationValueMapP.get('countryIssueTranslated');
        List<String> streetListBilling = accountP.BillingStreet.split('\r\n');
        String line1Billing;
        String line2Billing;
        if(streetListBilling.size() > 0){
            line1Billing = streetListBilling[0];
            if(streetListBilling.size() > 1){
                line2Billing = streetListBilling[1];
            }
        }
        cvsValPostalAddBean.line1 = line1Billing;
        cvsValPostalAddBean.line2 = line2Billing;
        cvsValPostalAddBean.city = accountP.BillingCity;
        cvsValPostalAddBean.postalCode = accountP.BillingPostalCode;
        cvsValPostalAddBean.countryCode = tanslationValueMapP.get('billCountryTranslated');
        List<String> streetListShipping = accountP.ShippingStreet.split('\r\n');
        String line1Shipping;
        String line2Shipping;
        if(streetListShipping.size() > 0){
            line1Shipping = streetListShipping[0];
            if(streetListShipping.size() > 1){
                line2Shipping = streetListShipping[1];
            }
        }
        cvsValHomeAddBean.line1 = line1Shipping;
        cvsValHomeAddBean.line2 = line2Shipping;
        cvsValHomeAddBean.city = accountP.ShippingCity;
        cvsValHomeAddBean.postalCode = accountP.ShippingPostalCode;
        cvsValHomeAddBean.countryCode = tanslationValueMapP.get('shipCountryTranslated');
        for(Address__c add : addressListP){
            if(add.Address_Type__c == 'Employers'){

                List<String> streetListEmployers = add.Shipping_Street__c.split('\r\n');
                String line1Employers;
                String line2Employers;
                if(streetListEmployers.size() > 0){
                    line1Employers = streetListEmployers[0];
                    if(streetListEmployers.size() > 1){
                        line2Employers = streetListEmployers[1];
                    }
                }
                cvsValWorkAddBean.line1 = accountP.Employer_Name__pc; //Line 1 is the Employers Name
                cvsValWorkAddBean.line2 = line1Employers;
                cvsValWorkAddBean.city = add.Shipping_City__c;
                cvsValWorkAddBean.postalCode = String.valueOf(add.Shipping_Zip_Postal_Code__c);
                cvsValWorkAddBean.countryCode = tanslationValueMapP.get('employerCountryTranslated');
            }
            
            //if(add.Address_Type__c == 'Postal'){

                /*cvsValPostalAddBean.line1 = add.Shipping_Street__c;
cvsValPostalAddBean.line2 = add.Shipping_Street__c;
cvsValPostalAddBean.city = add.Shipping_City__c;
cvsValPostalAddBean.postalCode = String.valueOf(add.Shipping_Zip_Postal_Code__c);
cvsValPostalAddBean.countryCode = tanslationValueMapP.get('billCountryTranslated');*/
            //}
            //if(add.Address_Type__c == 'Physical Address'){

                /*cvsValHomeAddBean.line1 = add.Shipping_Street__c;
cvsValHomeAddBean.line2 = add.Shipping_Street__c;
cvsValHomeAddBean.city = add.Shipping_City__c;
cvsValHomeAddBean.postalCode = String.valueOf(add.Shipping_Zip_Postal_Code__c);
cvsValHomeAddBean.countryCode = tanslationValueMapP.get('shipCountryTranslated');*/
            //}
        }

        cvsValEmploymentInfoBean.workAddress = cvsValWorkAddBean;
        cvsValEmploymentInfoBean.occupationCode = tanslationValueMapP.get('occupaionCodeTranslated');
        cvsValEmploymentInfoBean.occupationStatus = tanslationValueMapP.get('occupationStatusTranslated');
        cvsValEmploymentInfoBean.sourceOfFunds = tanslationValueMapP.get('incomeSourceTranslated');
        cvsValEmploymentInfoBean.employerName = accountP.Employer_Name__pc;

        if(accountP.Non_Credit_Marketing_Indicator__pc != null){
            cvsValMarketInfoBean.email = accountP.Non_Credit_Marketing_Indicator__pc.contains('Email') ? 'Y' : 'N';
            cvsValMarketInfoBean.mail = accountP.Non_Credit_Marketing_Indicator__pc.contains('Mail') ? 'Y' : 'N';
            cvsValMarketInfoBean.sms = accountP.Non_Credit_Marketing_Indicator__pc.contains('Phone') ? 'Y' : 'N';
            cvsValMarketInfoBean.telephone = accountP.Non_Credit_Marketing_Indicator__pc.toUpperCase().contains('SMS') ? 'Y' : 'N';
        }
        cvsValMarketInfoBean.preferredCommunicationChannel = tanslationValueMapP.get('comMethodTranslated');

        cvsValheaderBean.clientType = tanslationValueMapP.get('clientTypeTranslated');
        cvsValheaderBean.clientTypeGroup = clientTypeGroupP;
        cvsValheaderBean.applicationId = 'Salesforce';
        cvsValheaderBean.version = CvsValidationService_IH_v1.getCVSVersion();

        if(accountP.PersonHomePhone != null){
            Integer homeNumberSize = accountP.PersonHomePhone.length();
            cvsValHomePhoneBean.dialCode = accountP.PersonHomePhone.Substring(0, 3);
            cvsValHomePhoneBean.valNumber = accountP.PersonHomePhone.Substring(3, homeNumberSize);
            cvsValContactInfoBean.homePhone = cvsValHomePhoneBean;
        }
        if(accountP.Phone != null){
            Integer workNumberSize = accountP.Phone.length();
            cvsValWorkPhoneBean.dialCode = accountP.Phone.Substring(0, 3);
            cvsValWorkPhoneBean.valNumber = accountP.Phone.Substring(3, workNumberSize);
            cvsValContactInfoBean.workPhone = cvsValWorkPhoneBean;
        }

        if(accountP.PersonMobilePhone != null){
            String phoneNumber = accountP.PersonMobilePhone;

            if(phoneNumber.length() > 10){
                //Take last 10 Digits
                Integer numberLength = phoneNumber.length();
                cvsValContactInfoBean.cellPhoneNo = phoneNumber.Substring(numberLength - 10, numberLength);

            }else if(phoneNumber.length() < 10){
                //Add 0 infront until number is 10 digits
                while(phoneNumber.length() < 10){
                    phoneNumber = '0' + phoneNumber;
                }
                cvsValContactInfoBean.cellPhoneNo = phoneNumber;
            }else{
                //Number is the correct length
                cvsValContactInfoBean.cellPhoneNo = phoneNumber;
            }
        }
        cvsValContactInfoBean.emailAddress = accountP.PersonEmail;
        cvsValFicaBean.dateExempted = '0';
        List<String> validatorSetList = new List<String>();
        if(clientTypeGroupP == 'I'){
            for(String valSet : CvsValidationService_IH_v1.getCVSValidatorSet()){
                validatorSetList.add(valSet);
            }
            /*validatorSetList.add('personalData_set');
            validatorSetList.add('contactDetails_set');
            validatorSetList.add('occupationCode_set');
            validatorSetList.add('occupationStatus_set');
            validatorSetList.add('employerAddress_set');*/
        }else{
            //Not applicable for Client Type Group  = 'J'
        }
        cvsValBean.validatorSet = validatorSetList;
        //Assign beans
        cvsValContactInfoBean.postalAddress = cvsValPostalAddBean;
        cvsValContactInfoBean.homeAddress = cvsValHomeAddBean;
        cvsValClientBean.idNumber = cvsValIdNumberBean;
        cvsValBean.contactInfo = cvsValContactInfoBean;
        cvsValBean.client = cvsValClientBean;
        cvsValBean.employmentInfo = cvsValEmploymentInfoBean;
        cvsValBean.marketingInfo = cvsValMarketInfoBean;
        cvsValBean.header = cvsValheaderBean;
        return cvsValBean;
    }

    /**
    * @description mapBusinessRequestFields
    * @param accountP
    * @param accountListP
    * @param primaryAccountIdP
    * @param addressListP
    * @param clientTypeGroupP
    * @param tanslationValueMapP
    * @return CvsValidationService_Req_IB_v1
    **/
    public static CvsValidationService_Req_IB_v1 mapBusinessRequestFields(Account accountP, List<Account> accountListP, String primaryAccountIdP, List<Address__c> addressListP, String clientTypeGroupP, Map<String, String> tanslationValueMapP){
        //initiate beans
        CvsValidationService_Req_IB_v1 cvsValBean = new CvsValidationService_Req_IB_v1();
        CvsValidationService_Req_IB_v1.cls_Client cvsValClientAccBean = new CvsValidationService_Req_IB_v1.cls_Client();
        CvsValidationService_Req_IB_v1.cls_ContactInfo cvsValContactInfoAccBean = new CvsValidationService_Req_IB_v1.cls_ContactInfo();
        CvsValidationService_Req_IB_v1.cls_PostalAddress cvsValPostalAddAccBean = new CvsValidationService_Req_IB_v1.cls_PostalAddress();
        CvsValidationService_Req_IB_v1.cls_HomeAddress cvsValHomeAddAccBean = new CvsValidationService_Req_IB_v1.cls_HomeAddress();
        CvsValidationService_Req_IB_v1.cls_WorkAddress cvsValWorkAddAccBean = new CvsValidationService_Req_IB_v1.cls_WorkAddress();
        CvsValidationService_Req_IB_v1.cls_IdNumber cvsValIdNumberAccBean = new CvsValidationService_Req_IB_v1.cls_IdNumber();
        CvsValidationService_Req_IB_v1.cls_EmploymentInfo cvsValEmploymentInfoAccBean = new CvsValidationService_Req_IB_v1.cls_EmploymentInfo();
        CvsValidationService_Req_IB_v1.cls_MarketingInfo cvsValMarketInfoAccBean = new CvsValidationService_Req_IB_v1.cls_MarketingInfo();
        CvsValidationService_Req_IB_v1.cls_Header cvsValheaderAccBean = new CvsValidationService_Req_IB_v1.cls_Header();
        CvsValidationService_Req_IB_v1.cls_HomePhone cvsValHomePhoneAccBean = new CvsValidationService_Req_IB_v1.cls_HomePhone();
        CvsValidationService_Req_IB_v1.cls_WorkPhone cvsValWorkPhoneAccBean = new CvsValidationService_Req_IB_v1.cls_WorkPhone();
        CvsValidationService_Req_IB_v1.cls_Fica cvsValFicaAccBean = new CvsValidationService_Req_IB_v1.cls_Fica();
        CvsValidationService_Req_IB_v1.cls_IdNumber cvsValIdNumberBean = new CvsValidationService_Req_IB_v1.cls_IdNumber();

        //map fields
        cvsValClientAccBean.initials = accountP.Initials__pc;
        cvsValClientAccBean.homeLanguage = tanslationValueMapP.get('comLanguageTranslated');
        cvsValClientAccBean.titleCode = '0';
        cvsValClientAccBean.dateOfBirth = '0';
        cvsValClientAccBean.maritalStatus = '0';            
        cvsValClientAccBean.gender = '0';
        cvsValClientAccBean.maritalContractType = '0';

        //Account acc = [SELECT Name FROM Account WHERE Id =: accountP.Id LIMIT 1];
        //String businessAccName = acc.Name.toUpperCase();
        if(accountP.Name != null){
            cvsValClientAccBean.surname = accountP.Name.toUpperCase(); // LastName
        }else{
            cvsValClientAccBean.surname = accountP.FirstName != null ? accountP.FirstName.toUpperCase() : ''+ ' ' + accountP.LastName != null ? accountP.LastName.toUpperCase() : ''; // LastName
        }

        cvsValClientAccBean.nationalityCode = tanslationValueMapP.get('nationalityTranslated');
        cvsValClientAccBean.countryOfBirthCode = tanslationValueMapP.get('countryOfBirthTranslated');
        cvsValClientAccBean.clientCode = accountP.CIF__c;
        //cvsValIdNumberAccBean.documentType = tanslationValueMapP.get('idTypeTranslated');
        cvsValIdNumberAccBean.documentType = '0';

        cvsValEmploymentInfoAccBean.workAddress = cvsValWorkAddAccBean;
        cvsValEmploymentInfoAccBean.occupationCode = '0';
        cvsValEmploymentInfoAccBean.occupationStatus = '0';
        cvsValEmploymentInfoAccBean.employerName = '0';

        if(accountP.Non_Credit_Marketing_Indicator__pc != null){
            cvsValMarketInfoAccBean.email = accountP.Non_Credit_Marketing_Indicator__pc.contains('Email') ? 'Y' : 'N'; 
            cvsValMarketInfoAccBean.mail = accountP.Non_Credit_Marketing_Indicator__pc.contains('Mail') ? 'Y' : 'N';
            cvsValMarketInfoAccBean.sms = accountP.Non_Credit_Marketing_Indicator__pc.contains('Phone') ? 'Y' : 'N';
            cvsValMarketInfoAccBean.telephone = accountP.Non_Credit_Marketing_Indicator__pc.toUpperCase().contains('SMS') ? 'Y' : 'N';
        }
        cvsValheaderAccBean.clientType = tanslationValueMapP.get('clientTypeTranslated');
        cvsValheaderAccBean.clientTypeGroup = clientTypeGroupP;
        cvsValheaderAccBean.applicationId = 'Salesforce';
        cvsValheaderAccBean.version = CvsValidationService_IH_v1.getCVSVersion();

        cvsValFicaAccBean.dateExempted = '0';

        List<String> validatorSetList = new List<String>();
        validatorSetList.add('contactDetails_set');
        validatorSetList.add('jointParticipant_set');
        cvsValBean.validatorSet = validatorSetList;

        //Assign beans
        cvsValContactInfoAccBean.postalAddress = cvsValPostalAddAccBean;
        cvsValContactInfoAccBean.homeAddress = cvsValHomeAddAccBean;
        cvsValClientAccBean.idNumber = cvsValIdNumberAccBean;
        cvsValBean.contactInfo = cvsValContactInfoAccBean;
        cvsValBean.client = cvsValClientAccBean;
        cvsValBean.employmentInfo = cvsValEmploymentInfoAccBean;
        cvsValBean.marketingInfo = cvsValMarketInfoAccBean;
        cvsValBean.header = cvsValheaderAccBean;
        cvsValBean.noOfParticipants = String.valueOf(accountListP.size());

        /************************************** Joint Accounts ****************************************************************************/
        List<CvsValidationService_Req_IB_v1.cls_JointParticipants> cvsValJointPartBeanList = new List<CvsValidationService_Req_IB_v1.cls_JointParticipants>();

        for(Account account : accountListP){

            if(account.Id == primaryAccountIdP){

                if(account.PersonMobilePhone != null){
                    String phoneNumber = account.PersonMobilePhone;

                    if(phoneNumber.length() > 10){
                        //Take last 10 Digits
                        Integer numberLength = phoneNumber.length();
                        cvsValContactInfoAccBean.cellPhoneNo = phoneNumber.Substring(numberLength - 10, numberLength);

                    }else if(phoneNumber.length() < 10){
                        //Add 0 infront until number is 10 digits
                        while(phoneNumber.length() < 10){
                            phoneNumber = '0' + phoneNumber;
                        }
                        cvsValContactInfoAccBean.cellPhoneNo = phoneNumber;
                    }else{
                        //Number is the correct length
                        cvsValContactInfoAccBean.cellPhoneNo = phoneNumber;
                    }
                }

                cvsValContactInfoAccBean.emailAddress = account.PersonEmail;
                cvsValBean.contactPerson = account.FirstName + ' ' + account.LastName;
                cvsValMarketInfoAccBean.preferredCommunicationChannel = tanslationValueMapP.get('comMethodTranslated' + account.Id);

                if(account.BillingStreet != null){

                    List<String> streetListConBilling = account.BillingStreet.split('\r\n');
                    String line1Billing;
                    String line2Billing;
                    if(streetListConBilling.size() > 0){
                        line1Billing = streetListConBilling[0];
                        if(streetListConBilling.size() > 1){
                            line2Billing = streetListConBilling[1];
                        }
                    }
                    cvsValPostalAddAccBean.line1 = line1Billing;
                    cvsValPostalAddAccBean.line2 = line2Billing;
                    cvsValPostalAddAccBean.city = account.BillingCity;
                    cvsValPostalAddAccBean.postalCode = account.BillingPostalCode;
                    cvsValPostalAddAccBean.countryCode = tanslationValueMapP.get('billCountryTranslated' + account.Id);
                }
                cvsValClientAccBean.correspondenceLanguage = tanslationValueMapP.get('comLanguageTranslated' + account.Id);
            }

            CvsValidationService_Req_IB_v1.cls_JointParticipants cvsValJointPartBean = new CvsValidationService_Req_IB_v1.cls_JointParticipants();
            cvsValJointPartBean.clientTypeGroup = clientTypeGroupP;

            //Client Bean
            CvsValidationService_Req_IB_v1.cls_Client cvsValClientBean = new CvsValidationService_Req_IB_v1.cls_Client();
            cvsValClientBean.initials = account.Initials__pc;
            cvsValClientBean.homeLanguage = tanslationValueMapP.get('comLanguageTranslated' + account.Id);
            cvsValClientBean.titleCode = tanslationValueMapP.get('personTitleTranslated' + account.Id);
            if(account.PersonBirthdate != null){
                DateTime birthDate = account.PersonBirthdate;
                cvsValClientBean.dateOfBirth = birthDate.format('ddMMyyyy');
            }
            cvsValClientBean.maritalStatus = tanslationValueMapP.get('maritalStatusTranslated' + account.Id);           
            cvsValClientBean.gender = tanslationValueMapP.get('genderTranslated' + account.Id);
            cvsValClientBean.maritalContractType = tanslationValueMapP.get('maritalContractTranslated' + account.Id);
            cvsValClientBean.firstname = account.FirstName;
            cvsValClientBean.surname = account.LastName;
            cvsValClientBean.nationalityCode = tanslationValueMapP.get('nationalityTranslated' + account.Id);
            cvsValClientBean.countryOfBirthCode = tanslationValueMapP.get('countryOfBirthTranslated' + account.Id);
            cvsValClientBean.postMatricIndicator = 'N';
            cvsValClientBean.socialGrant = 'N';
            cvsValClientBean.correspondenceLanguage = tanslationValueMapP.get('comLanguageTranslated' + account.Id);
            cvsValClientBean.clientCode = account.CIF__c;
            cvsValIdNumberBean.documentType = tanslationValueMapP.get('idTypeTranslated' + account.Id);
            cvsValIdNumberBean.valNumber = account.ID_Number__pc;
            //cvsValIdNumberBean.dateIssued = '0';      //TBC
            cvsValIdNumberBean.countryOfIssueCode = tanslationValueMapP.get('countryIssueTranslated' + account.Id);

            //Contact Info Bean
            CvsValidationService_Req_IB_v1.cls_ContactInfo cvsValContactInfoBean = new CvsValidationService_Req_IB_v1.cls_ContactInfo();
            CvsValidationService_Req_IB_v1.cls_HomePhone cvsValHomePhoneBean = new CvsValidationService_Req_IB_v1.cls_HomePhone();
            CvsValidationService_Req_IB_v1.cls_WorkPhone cvsValWorkPhoneBean = new CvsValidationService_Req_IB_v1.cls_WorkPhone();
            CvsValidationService_Req_IB_v1.cls_HomeAddress cvsValHomeAddressBean = new CvsValidationService_Req_IB_v1.cls_HomeAddress();
            CvsValidationService_Req_IB_v1.cls_PostalAddress cvsValPostalAddressBean = new CvsValidationService_Req_IB_v1.cls_PostalAddress();
            CvsValidationService_Req_IB_v1.cls_WorkAddress cvsValWorkAddressBean = new CvsValidationService_Req_IB_v1.cls_WorkAddress();

            if(account.BillingStreet != null){
                List<String> streetListBilling = account.BillingStreet.split('\r\n');
                String line1Billing;
                String line2Billing;
                if(streetListBilling.size() > 0){
                    line1Billing = streetListBilling[0];
                    if(streetListBilling.size() > 1){
                        line2Billing = streetListBilling[1];
                    }
                }
                cvsValPostalAddressBean.line1 = line1Billing;
                cvsValPostalAddressBean.line2 = line2Billing;
                cvsValPostalAddressBean.city = account.BillingCity;
                cvsValPostalAddressBean.postalCode = String.valueOf(account.BillingPostalCode);
                cvsValPostalAddressBean.countryCode = tanslationValueMapP.get('billingCountryTranslated' + account.Id);
            }
            for(Address__c add : addressListP){
                if(add.Account__c == account.Id){
                    if(add.Address_Type__c == 'Employers'){

                        List<String> streetListEmployers = add.Shipping_Street__c.split('\r\n');
                        String line1Employers;
                        String line2Employers;
                        if(streetListEmployers.size() > 0){
                            line1Employers = streetListEmployers[0];
                            if(streetListEmployers.size() > 1){
                                line2Employers = streetListEmployers[1];
                            }
                        }
                        cvsValWorkAddressBean.line1 = line1Employers;
                        cvsValWorkAddressBean.line2 = line2Employers;
                        cvsValWorkAddressBean.city = add.Shipping_City__c;
                        cvsValWorkAddressBean.postalCode = String.valueOf(add.Shipping_Zip_Postal_Code__c);
                        cvsValWorkAddressBean.countryCode = tanslationValueMapP.get('employerCountryTranslated' + account.Id);
                    }
                    /*if(add.Address_Type__c == 'Postal'){

                    }
                    if(add.Address_Type__c == 'Physical Address'){

                    }*/
                }
            }
            cvsValContactInfoBean.homeAddress = cvsValHomeAddressBean;
            cvsValContactInfoBean.postalAddress = cvsValPostalAddressBean;

            if(account.PersonHomePhone != null){
                Integer homeNumberSize = account.PersonHomePhone.length();
                cvsValHomePhoneBean.dialCode = account.PersonHomePhone.Substring(0, 3);
                cvsValHomePhoneBean.valNumber = account.PersonHomePhone.Substring(3, homeNumberSize);
                cvsValContactInfoBean.homePhone = cvsValHomePhoneBean;
            }
            if(account.Phone != null){
                Integer workNumberSize = account.Phone.length();
                cvsValWorkPhoneBean.dialCode = account.Phone.Substring(0, 3);
                cvsValWorkPhoneBean.valNumber = account.Phone.Substring(3, workNumberSize);
                cvsValContactInfoBean.workPhone = cvsValWorkPhoneBean;
            }

            if(account.PersonMobilePhone != null){
                String phoneNumber = account.PersonMobilePhone;

                if(phoneNumber.length() > 10){
                    //Take last 10 Digits
                    Integer numberLength = phoneNumber.length();
                    cvsValContactInfoBean.cellPhoneNo = phoneNumber.Substring(numberLength - 10, numberLength);

                }else if(phoneNumber.length() < 10){
                    //Add 0 infront until number is 10 digits
                    while(phoneNumber.length() < 10){
                        phoneNumber = '0' + phoneNumber;
                    }
                    cvsValContactInfoBean.cellPhoneNo = phoneNumber;
                }else{
                    //Number is the correct length
                    cvsValContactInfoBean.cellPhoneNo = phoneNumber;
                }
            }

            cvsValContactInfoBean.emailAddress = account.PersonEmail;

            //Marketing Info Bean
            CvsValidationService_Req_IB_v1.cls_MarketingInfo cvsValMarketingInfoBean = new CvsValidationService_Req_IB_v1.cls_MarketingInfo();

            if(account.Non_Credit_Marketing_Indicator__pc != null){
                cvsValMarketingInfoBean.email = account.Non_Credit_Marketing_Indicator__pc.contains('Email') ? 'Y' : 'N'; 
                cvsValMarketingInfoBean.mail = account.Non_Credit_Marketing_Indicator__pc.contains('Mail') ? 'Y' : 'N';
                cvsValMarketingInfoBean.sms = account.Non_Credit_Marketing_Indicator__pc.contains('Phone') ? 'Y' : 'N';
                cvsValMarketingInfoBean.telephone = account.Non_Credit_Marketing_Indicator__pc.toUpperCase().contains('SMS') ? 'Y' : 'N';
            }
            cvsValMarketingInfoBean.preferredCommunicationChannel = tanslationValueMapP.get('comMethodTranslated' + account.Id);

            //Employment Info Bean
            CvsValidationService_Req_IB_v1.cls_EmploymentInfo cvsValEmploymentInfoBean = new CvsValidationService_Req_IB_v1.cls_EmploymentInfo();
            cvsValEmploymentInfoBean.occupationCode = tanslationValueMapP.get('occupaionCodeTranslated' + account.Id);
            cvsValEmploymentInfoBean.occupationStatus = tanslationValueMapP.get('occupationStatusTranslated' + account.Id);
            cvsValEmploymentInfoBean.sourceOfFunds = tanslationValueMapP.get('incomeSourceTranslated' + account.Id);
            cvsValEmploymentInfoBean.employerName = account.Employer_Name__pc;
            cvsValEmploymentInfoBean.workAddress = cvsValWorkAddressBean;

            //Holds Bean
            CvsValidationService_Req_IB_v1.cls_Holds cvsValHoldsBean = new CvsValidationService_Req_IB_v1.cls_Holds();

            //Fica Bean
            CvsValidationService_Req_IB_v1.cls_Fica cvsValFicaBean = new CvsValidationService_Req_IB_v1.cls_Fica();
            cvsValFicaBean.dateExempted = '0';

            //Assign Beans
            cvsValClientBean.idNumber = cvsValIdNumberBean;
            cvsValJointPartBean.client = cvsValClientBean;
            cvsValJointPartBean.contactInfo = cvsValContactInfoBean;
            cvsValJointPartBean.employmentInfo = cvsValEmploymentInfoBean;
            cvsValJointPartBean.fica = cvsValFicaBean;
            cvsValJointPartBean.holds = cvsValHoldsBean;
            cvsValJointPartBean.marketingInfo = cvsValMarketingInfoBean;

            cvsValJointPartBeanList.add(cvsValJointPartBean);
        }

        //map fields
        cvsValBean.jointParticipants = cvsValJointPartBeanList;
        return cvsValBean;
    }

    /**
     * @description OnBoarding - CVSVALIDATION SERVICE - Used to valdiate Client and Address information -
     * @author ADDED BY ANKA GATNA : 2020-02-03
     * @param accountP 
     * @param addressListP 
     * @return CvsValidationService_Req_IB_v1 
     **/
     public static CvsValidationService_Req_IB_v1 mapNonIndividualRequestFields(Account accountP,List<Address__c> addressListP){
         //W-005355 : Anka Ganta : 2020-07-09
         String countryOfIncorporation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
         //W-005355 : Anka Ganta : 2020-07-09
         String idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_IDENTITY_TYPE_STRING, accountP.ID_Type__c, StringConstants.OUTBOUND_RECORD_TYPE); 
         String clientTypeGrpTranslated;
         if(accountP.Client_Group__c == 'Non Individual'  && accountP.Registration_Number__c != null){
             clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountP.Client_Group__c.replace('Non Individual', 'Non-Individual'), StringConstants.OUTBOUND_RECORD_TYPE);

         }
         else {
             clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, accountP.Client_Group__c, StringConstants.OUTBOUND_RECORD_TYPE);
         }
         String PreCommMethodTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Preferred Communication Method', accountP.Preferred_Communication_Method__c, StringConstants.OUTBOUND_RECORD_TYPE);
         String languageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_LANGUAGE, accountP.Language__c, StringConstants.OUTBOUND_RECORD_TYPE);
         CvsValidationService_Req_IB_v1 cvsValBean = new CvsValidationService_Req_IB_v1();
         List<String> validatorSetList = new List<String>();
         if(clientTypeGrpTranslated == 'N' || clientTypeGrpTranslated == 'P'){
             for(String valSet : CvsValidationService_IH_v1.getCVSValidatorSetNonIndividual()){
                 validatorSetList.add(valSet);
             }
         }

         //Assign beans
         cvsValBean.validatorSet = validatorSetList;

          //Participant for Joint and Several
         cvsValBean.noOfParticipants = String.valueOf(accountP.Number_of_Participants__c);

         // header //
         CvsValidationService_Req_IB_v1.cls_Header cvsValheaderAccBean = new CvsValidationService_Req_IB_v1.cls_Header();
         cvsValheaderAccBean.clientTypeGroup = accountP.Client_Type__c == 'Trusts' ? 'P' :clientTypeGrpTranslated;//'N';
         if(accountP.Client_Type__c !='Foreign Trust'){
             if((accountP.Client_Type__c == 'Foreign Listed Company')||(accountP.Client_Type__c == 'Foreign Company')||(accountP.Client_Type__c == 'Clubs/Societies/Associations/Other Informal Bodies')
                || accountP.Client_Type__c == 'Organs of State and Institutions of Higher Learning' || accountP.Client_Type__c == 'Central Bank or Regulator' || accountP.Client_Type__c == 'PARTNERSHIP' || accountP.Client_Type__c == 'JOINT & SEVERAL'){
                    cvsValheaderAccBean.clientType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
                }
         }
         cvsValheaderAccBean.applicationId = StringConstants.SALESFORCE_STRING;//'Salesforce';
         cvsValheaderAccBean.version = '';//CvsValidationService_IH_v1.getCVSVersion();
         cvsValheaderAccBean.errorMessagesLanguage = '';

         //Assign beans
         cvsValBean.header = cvsValheaderAccBean;

         // client - idNumber//
         CvsValidationService_Req_IB_v1.cls_Client cvsValClientAccBean = new CvsValidationService_Req_IB_v1.cls_Client();
         CvsValidationService_Req_IB_v1.cls_IdNumber cvsValIdNumberBean = new CvsValidationService_Req_IB_v1.cls_IdNumber();

         if((accountP.Client_Type__c == 'Foreign Listed Company')||(accountP.Client_Type__c == 'Foreign Company')||(accountP.Client_Type__c == 'Clubs/Societies/Associations/Other Informal Bodies') || accountP.Client_Type__c == 'JOINT & SEVERAL' ){
           // || accountP.Client_Type__c == 'Organs of State and Institutions of Higher Learning' || accountP.Client_Type__c == 'Central Bank or Regulator'
             cvsValIdNumberBean.documentType = '0';
         }else if(accountP.ID_Type__c == 'Non-Registered Entity'){
             cvsValIdNumberBean.documentType = ''; 
         }else{
             cvsValIdNumberBean.documentType = idTypeTranslated;//'05';
         }
         cvsValIdNumberBean.valNumber =  '';//'201930633006'
         cvsValClientAccBean.surname = accountP.Name;//'TestP-surname';
         cvsValClientAccBean.homeLanguage = '';
         cvsValClientAccBean.correspondenceLanguage = languageTranslated;//'E';//Hardcoded to English
         cvsValClientAccBean.incomeTaxNo = String.valueOf(accountP.Income_Tax_Number__c)    ;//
         cvsValClientAccBean.creditWorthinessConsent = 'N'; //Hardcoded as No Credits implementation now
         if(accountP.Client_Type__c == 'Trusts'){
             cvsValheaderAccBean.subClassificationCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Sub Classification Code', accountP.Sub_Classification_Code__c, StringConstants.OUTBOUND_RECORD_TYPE);
             cvsValheaderAccBean.clientType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
             cvsValClientAccBean.practiceOrTrustNo = accountP.Trust_Number__c;
             cvsValBean.client = cvsValClientAccBean;
         }else{
             cvsValBean.client = cvsValClientAccBean;
         }
         //Assign beans
         /*if(accountP.Client_Type__c == 'Trusts'){
             cvsValClientAccBean.practiceOrTrustNo = accountP.Trust_Number__c;
             cvsValClientAccBean.idNumber = cvsValIdNumberBean;
         }else{
             cvsValClientAccBean.idNumber = cvsValIdNumberBean;
         }*/

         cvsValClientAccBean.idNumber = cvsValIdNumberBean;


         // contactInfo - homePhone, workPhone,workFax, homeAddress, postalAddress//
         CvsValidationService_Req_IB_v1.cls_ContactInfo cvsValContactInfoAccBean = new CvsValidationService_Req_IB_v1.cls_ContactInfo();
         CvsValidationService_Req_IB_v1.cls_HomePhone cvsValHomePhoneBean = new CvsValidationService_Req_IB_v1.cls_HomePhone();
         CvsValidationService_Req_IB_v1.cls_WorkPhone cvsValWorkPhoneBean = new CvsValidationService_Req_IB_v1.cls_WorkPhone();
         CvsValidationService_Req_IB_v1.cls_WorkFax cvsValWorkFaxBean = new CvsValidationService_Req_IB_v1.cls_WorkFax();
         CvsValidationService_Req_IB_v1.cls_PostalAddress cvsValPostalAddAccBean = new CvsValidationService_Req_IB_v1.cls_PostalAddress();
         cvsValContactInfoAccBean.cellPhoneNo = accountP.Phone;
         cvsValContactInfoAccBean.emailAddress = accountP.Marketing_Consent_Info__c;// 
         cvsValHomePhoneBean.dialCode = '';
         cvsValHomePhoneBean.valNumber = accountP.Phone;//'0115077000';
         cvsValWorkPhoneBean.dialCode = '';
         cvsValWorkPhoneBean.valNumber = '';
         cvsValWorkFaxBean.dialCode = '';
         cvsValWorkFaxBean.valNumber = '';
         cvsValPostalAddAccBean.line1 = '';
         cvsValPostalAddAccBean.line2 = '';
         cvsValPostalAddAccBean.city = '';
         cvsValPostalAddAccBean.postalCode = '';
         cvsValPostalAddAccBean.countryCode = '';

         //Assign beans
         cvsValContactInfoAccBean.homePhone = cvsValHomePhoneBean;
         cvsValContactInfoAccBean.workPhone = cvsValWorkPhoneBean;
         cvsValContactInfoAccBean.workFax = cvsValWorkFaxBean;
         cvsValContactInfoAccBean.postalAddress = cvsValPostalAddAccBean;
         cvsValBean.contactInfo = cvsValContactInfoAccBean;

         // marketingInfo
         CvsValidationService_Req_IB_v1.cls_MarketingInfo cvsValMarketInfoAccBean = new CvsValidationService_Req_IB_v1.cls_MarketingInfo();
         cvsValMarketInfoAccBean.preferredCommunicationChannel= PreCommMethodTranslated;//'3';

         //Assign beans
         cvsValBean.marketingInfo = cvsValMarketInfoAccBean;

         //businessInfo //
         CvsValidationService_Req_IB_v1.cls_BusinessInfo cvsValBusinessInfoAccBean = new CvsValidationService_Req_IB_v1.cls_BusinessInfo();

         String sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', (accountP.Standard_Industry_SIC_Code__c), StringConstants.OUTBOUND_RECORD_TYPE);
         if(accountP.Standard_Industry_SIC_Code__c != null) {
             cvsValBusinessInfoAccBean.sicCode = sicCodeTranslated;
         }  else {
             cvsValBusinessInfoAccBean.sicCode ='';
         }
         if(accountP.Client_Type__c != 'Trusts'){
             if((accountP.Client_Type__c == 'Foreign Listed Company')||(accountP.Client_Type__c == 'Foreign Company')||(accountP.Client_Type__c == 'Clubs/Societies/Associations/Other Informal Bodies') || accountP.Client_Type__c == 'PARTNERSHIP' || accountP.Client_Type__c == 'JOINT & SEVERAL'){
                 cvsValBusinessInfoAccBean.registrationNumber = '';         
             }else{
                 if(accountP.Registration_Number__c!=null){
                     cvsValBusinessInfoAccBean.registrationNumber = (accountP.Registration_Number__c).replace('/','');
                 }
             }
         }
         cvsValBusinessInfoAccBean.countryIncorporated = '';//Country_of_Incorporation__c // need translation
         cvsValBusinessInfoAccBean.vatRegistrationNo = String.valueOf(accountP.VAT_Registration_Number__c);//
         cvsValBusinessInfoAccBean.yearEnd = '';//Financial_Year_End__c //need translation

         String cpaThresholdTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(accountP.Does_the_Client_fall_under_the_CPA__c), StringConstants.OUTBOUND_RECORD_TYPE);  
         if(cpaThresholdTranslated!= null){
             cvsValBusinessInfoAccBean.cpaThreshold = cpaThresholdTranslated;                   
         }

         cvsValBusinessInfoAccBean.ncaThreshold = '';
         cvsValBusinessInfoAccBean.site = '';
         CvsValidationService_Req_IB_v1.cls_Address cvsValAddressAccBean = new CvsValidationService_Req_IB_v1.cls_Address();
         CvsValidationService_Req_IB_v1.cls_CountryEntityOperates cvsValContryOperateAccBean = new CvsValidationService_Req_IB_v1.cls_CountryEntityOperates();
         cvsValContryOperateAccBean.countyCode = '';
         CvsValidationService_Req_IB_v1.cls_RegisteredAddress cvsValRegAddAccBean = new CvsValidationService_Req_IB_v1.cls_RegisteredAddress();
         CvsValidationService_Req_IB_v1.cls_HeadOfficeAddress cvsValHeadOffcAddAccBean = new CvsValidationService_Req_IB_v1.cls_HeadOfficeAddress();
         CvsValidationService_Req_IB_v1.cls_HomeAddress cvsValHomeAddAccBean = new CvsValidationService_Req_IB_v1.cls_HomeAddress();

         for(Address__c add : addressListP){
             if(add.Account__c == accountP.Id){
                 if(add.Address_Type__c == StringConstants.POSTAL_STRING){
                     //W-006881-Anka Ganta-2020-10-30
                     if(add.Shipping_Street__c.containsIgnoreCase('P.O. BOX')){
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c.replace('P.O. BOX','PO BOX');
                     }else if(add.Shipping_Street__c.containsIgnoreCase('P O BOX')){
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c.replace('P O BOX','PO BOX');
                     }else{
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c;
                     }
                     cvsValAddressAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValAddressAccBean.city = add.Shipping_City__c;
                     cvsValAddressAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValAddressAccBean.countryCode = countryOfIncorporation;

                     cvsValPostalAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValPostalAddAccBean.line2 = add.Shipping_Suburb__c;
                     cvsValPostalAddAccBean.city = add.Shipping_City__c;
                     cvsValPostalAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValPostalAddAccBean.countryCode = countryOfIncorporation;
                 }

                 if(add.Address_Type__c == StringConstants.BUSINESS_ADDR_STRING){
                     cvsValHomeAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValHomeAddAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValHomeAddAccBean.city = add.Shipping_City__c;
                     cvsValHomeAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValHomeAddAccBean.countryCode = countryOfIncorporation;
                 }

                 if(add.Address_Type__c == StringConstants.REGISTERED_ADDR_STRING){
                     cvsValRegAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValRegAddAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValRegAddAccBean.city = add.Shipping_City__c;
                     cvsValRegAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValRegAddAccBean.countryCode = countryOfIncorporation;
                 }

                 if(add.Address_Type__c == StringConstants.HEAD_OFFICE_ADDR_STRING){ 
                     cvsValHeadOffcAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValHeadOffcAddAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValHeadOffcAddAccBean.city = add.Shipping_City__c;
                     cvsValHeadOffcAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValHeadOffcAddAccBean.countryCode = countryOfIncorporation;                       
                 }
             }
         }

         //Assign beans
         cvsValBusinessInfoAccBean.address = cvsValAddressAccBean;
         cvsValBusinessInfoAccBean.countryEntityOperates = cvsValContryOperateAccBean;
         cvsValBusinessInfoAccBean.registeredAddress = cvsValRegAddAccBean;
         cvsValBusinessInfoAccBean.headOfficeAddress = cvsValHeadOffcAddAccBean;
         cvsValContactInfoAccBean.homeAddress = cvsValHomeAddAccBean;
         cvsValContactInfoAccBean.postalAddress = cvsValPostalAddAccBean;
         cvsValBean.businessInfo = cvsValBusinessInfoAccBean;

         //TdB - W-004831 : Map Regulatory 3(1)f Shareholder% (Is the Cleint affected)
         if(accountP.Client_Type__c != 'JOINT & SEVERAL') {
             String affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Affected Person', String.valueOf(accountP.Q4a_Client_affected_by_Regulation_3_1_F__c), StringConstants.OUTBOUND_RECORD_TYPE); 
             if(String.IsBlank(affectedPersonTranslated) == false){
                 cvsValBean.affectedPersonReg = affectedPersonTranslated;                   
             }
         }
         return cvsValBean;

     }
   /**
   * @description TdB - RBB Individual Mapping as its diffrent than what WILLS are using
   * @param accountP 
   * @param addressListP 
   * @param clientTypeGroupP 
   * @param tanslationValueMapP 
   * @return CvsValidationService_Req_IB_v1 
   **/
   public static CvsValidationService_Req_IB_v1 mapRBBIndividualRequestFields(Account accountP, List<Address__c> addressListP, String clientTypeGroupP, Map<String, String> tanslationValueMapP){

         //initiate beans
         CvsValidationService_Req_IB_v1 cvsValBean = new CvsValidationService_Req_IB_v1();
         CvsValidationService_Req_IB_v1.cls_Client cvsValClientBean = new CvsValidationService_Req_IB_v1.cls_Client();
         CvsValidationService_Req_IB_v1.cls_ContactInfo cvsValContactInfoBean = new CvsValidationService_Req_IB_v1.cls_ContactInfo();
         CvsValidationService_Req_IB_v1.cls_PostalAddress cvsValPostalAddBean = new CvsValidationService_Req_IB_v1.cls_PostalAddress();
         CvsValidationService_Req_IB_v1.cls_HomeAddress cvsValHomeAddBean = new CvsValidationService_Req_IB_v1.cls_HomeAddress();
         CvsValidationService_Req_IB_v1.cls_WorkAddress cvsValWorkAddBean = new CvsValidationService_Req_IB_v1.cls_WorkAddress();
         CvsValidationService_Req_IB_v1.cls_IdNumber cvsValIdNumberBean = new CvsValidationService_Req_IB_v1.cls_IdNumber();
         CvsValidationService_Req_IB_v1.cls_EmploymentInfo cvsValEmploymentInfoBean = new CvsValidationService_Req_IB_v1.cls_EmploymentInfo();
         CvsValidationService_Req_IB_v1.cls_MarketingInfo cvsValMarketInfoBean = new CvsValidationService_Req_IB_v1.cls_MarketingInfo();
         CvsValidationService_Req_IB_v1.cls_Header cvsValheaderBean = new CvsValidationService_Req_IB_v1.cls_Header();
         CvsValidationService_Req_IB_v1.cls_HomePhone cvsValHomePhoneBean = new CvsValidationService_Req_IB_v1.cls_HomePhone();
         CvsValidationService_Req_IB_v1.cls_HomePhone cvsValNextOfKinHomePhoneBean = new CvsValidationService_Req_IB_v1.cls_HomePhone();
         CvsValidationService_Req_IB_v1.cls_WorkPhone cvsValWorkPhoneBean = new CvsValidationService_Req_IB_v1.cls_WorkPhone();
         CvsValidationService_Req_IB_v1.cls_Fica cvsValFicaBean = new CvsValidationService_Req_IB_v1.cls_Fica();
         CvsValidationService_Req_IB_v1.cls_NextOfKin cvsValNextOfKinBean = new CvsValidationService_Req_IB_v1.cls_NextOfKin();
         CvsValidationService_Req_IB_v1.cls_BusinessInfo cvsValBusinessBean = new CvsValidationService_Req_IB_v1.cls_BusinessInfo();
         CvsValidationService_Req_IB_v1.cls_ContactDetail cvsValNextOfKinContactInfoBean = new CvsValidationService_Req_IB_v1.cls_ContactDetail();

         // Sole Trader specific fields to map (not applicable for individual)
         if(accountP.Client_Type__c.toUpperCase() == 'SOLE TRADER') {

             String sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Standard Industry SIC Code', (accountP.Standard_Industry_SIC_Code__c), StringConstants.OUTBOUND_RECORD_TYPE);
             if(sicCodeTranslated!= null){
                 cvsValBusinessBean.sicCode = sicCodeTranslated;
             }

             String countryOfIncorporationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
             if(countryOfIncorporationTranslated!= null){
                 cvsValBusinessBean.countryIncorporated = countryOfIncorporationTranslated;
             }

             String cpaThresholdTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(accountP.Does_the_Client_fall_under_the_CPA__c), StringConstants.OUTBOUND_RECORD_TYPE);
             if(cpaThresholdTranslated!= null){
                 cvsValBusinessBean.cpaThreshold = cpaThresholdTranslated;
             }

             String ncaThresholdTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(accountP.Does_the_Client_fall_under_the_NCA__c), StringConstants.OUTBOUND_RECORD_TYPE);
             if(ncaThresholdTranslated!= null){
                 cvsValBusinessBean.ncaThreshold = ncaThresholdTranslated;
             }
         }
         //Individual specific (Not for Sole Prop)
         else {
             if(accountP.Client_Type__c != 'Deceased Estate') {

                 String socialGrantTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(accountP.Does_the_Client_receive_Social_a_Grant__c), StringConstants.OUTBOUND_RECORD_TYPE);
                 if(socialGrantTranslated != null){
                     cvsValClientBean.socialGrant = socialGrantTranslated;
                 }

                 String postMatricTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Post Matric Qualification', accountP.Post_Matric_Qualification__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                 if(postMatricTranslated != null){
                     cvsValClientBean.postMatricQualification = postMatricTranslated;
                     cvsValClientBean.postMatricIndicator = 'Y';
                 } else {
                     cvsValClientBean.postMatricIndicator = 'N';
                 }
             }

             cvsValClientBean.incomeTaxNo = String.valueOf(accountP.Income_Tax_Number__c);

         }

         //Person information
         cvsValClientBean.titleCode = tanslationValueMapP.get('personTitleTranslated');

         if(accountP.Client_Type__c != 'Deceased Estate') {
             cvsValClientBean.maritalStatus = tanslationValueMapP.get('maritalStatusTranslated');
             cvsValClientBean.maritalContractType = tanslationValueMapP.get('maritalContractTranslated');
             cvsValClientBean.homeLanguage = tanslationValueMapP.get('comLanguageTranslated');

             //Translation mappings
             String incomeGroupTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Monthly Income', accountP.Monthly_Income__pc, StringConstants.OUTBOUND_RECORD_TYPE);
             if(incomeGroupTranslated != null){
                 cvsValEmploymentInfoBean.monthlyIncome = incomeGroupTranslated;
             }

             //Start : multiple source of income : 2020-03-16 - Anka Ganta
             if(accountP.Source_of_Income__c != null) {
                 String[] sourceOfincomes = accountP.Source_of_Income__c.split(';');

                 List<String> sourceOfincomelist = new List<String>();

                 for(String srcOfincome:sourceOfincomes){
                     String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, srcOfincome, StringConstants.OUTBOUND_RECORD_TYPE);
                     sourceOfincomelist.add(srcOfincomeTranslated);
                 }
                 if(sourceOfincomelist[0] != null){
                     cvsValEmploymentInfoBean.sourceOfFunds = sourceOfincomelist[0];
                 }
             }

             cvsValEmploymentInfoBean.occupationCode = tanslationValueMapP.get('occupaionCodeTranslated');
             cvsValEmploymentInfoBean.occupationStatus = tanslationValueMapP.get('occupationStatusTranslated');
             cvsValClientBean.gender = tanslationValueMapP.get('genderTranslated');
             cvsValClientBean.nationalityCode = tanslationValueMapP.get('nationalityTranslated');
             cvsValClientBean.initials = accountP.Initials__pc;
             if(accountP.PersonBirthdate != null){
                 DateTime birthDate = accountP.PersonBirthdate;
                 cvsValClientBean.dateOfBirth = birthDate.format('ddMMyyyy');
                 cvsValClientBean.firstname = accountP.FirstName;
                 cvsValClientBean.surname = accountP.LastName;
             }
         } else {
             cvsValClientBean.surname = 'Estate Late ' + accountP.FirstName + accountP.LastName;
         }

         cvsValClientBean.countryOfBirthCode = tanslationValueMapP.get('countryOfBirthTranslated');

         cvsValClientBean.correspondenceLanguage = tanslationValueMapP.get('comLanguageTranslated');
         cvsValClientBean.clientCode = accountP.CIF__c;

         cvsValIdNumberBean.documentType = tanslationValueMapP.get('idTypeTranslated');
         if(accountP.ID_Type__c == 'Passport' || accountP.ID_Type__pc == 'Passport') {
             cvsValIdNumberBean.valNumber = accountP.Passport_Number__pc;
             String countryIssueTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_Passport_Issued__pc, StringConstants.OUTBOUND_RECORD_TYPE);
			 cvsValIdNumberBean.countryOfIssueCode = countryIssueTranslated;
         } else {
             cvsValIdNumberBean.valNumber = accountP.ID_Number__pc;
             cvsValIdNumberBean.countryOfIssueCode = tanslationValueMapP.get('countryIssueTranslated');
         }

         //Next of Kin
         cvsValNextOfKinBean.relatedToPartInitials = accountP.Next_of_Kin_Initial__pc;
         cvsValNextOfKinBean.firstname = accountP.Next_of_Kin_First_Name_s__pc;
         cvsValNextOfKinBean.surname = accountP.Next_of_Kin_Last_Name__pc;
         cvsValNextOfKinContactInfoBean.cellPhoneNo = accountP.Next_of_Kin_Cellphone_Number__pc;
         cvsValNextOfKinContactInfoBean.emailAddress = accountP.Next_of_Kin_Email_Address__pc;

         if(accountP.Next_of_Kin_Telephone_Number__pc != null){
             Integer homeNumberSize = accountP.Next_of_Kin_Telephone_Number__pc.length();
             cvsValNextOfKinHomePhoneBean.dialCode = accountP.Next_of_Kin_Telephone_Number__pc.Substring(0, 3);
             cvsValNextOfKinHomePhoneBean.valNumber = accountP.Next_of_Kin_Telephone_Number__pc.Substring(3, homeNumberSize);
         }

         String nextOfKinRelationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Relationship', accountP.Next_of_Kin_Relationship__pc, StringConstants.OUTBOUND_RECORD_TYPE);
         if(nextOfKinRelationshipTranslated!= null){
             cvsValNextOfKinBean.relationshipCode = nextOfKinRelationshipTranslated;
         }

         cvsValBusinessBean.vatRegistrationNo = String.valueOf(accountP.VAT_Registration_Number__c);

         //Translation mappings
         String incomeGroupTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Monthly Income', accountP.Monthly_Income__pc, StringConstants.OUTBOUND_RECORD_TYPE);
         if(incomeGroupTranslated != null){
             cvsValEmploymentInfoBean.monthlyIncome = incomeGroupTranslated;
         }

         //Start : multiple source of income : 2020-03-16 - Anka Ganta
         if(accountP.Source_of_Income__c != null) {
             String[] sourceOfincomes = accountP.Source_of_Income__c.split(';');

             List<String> sourceOfincomelist = new List<String>();

             for(String srcOfincome:sourceOfincomes){
                 String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, srcOfincome, StringConstants.OUTBOUND_RECORD_TYPE);
                 sourceOfincomelist.add(srcOfincomeTranslated);
             }
             if(sourceOfincomelist[0] != null){
                 cvsValEmploymentInfoBean.sourceOfFunds = sourceOfincomelist[0];
             }
         }

         String creditConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(accountP.Credit_Worthiness_Consent__c), StringConstants.OUTBOUND_RECORD_TYPE);
         if(creditConsentTranslated!= null){
             cvsValClientBean.creditWorthinessConsent = creditConsentTranslated;
         }

         if(accountP.Date_Issued__pc != null){
             DateTime issuedDate = accountP.Date_Issued__pc;
             cvsValIdNumberBean.dateIssued = issuedDate.format('ddMMyyyy');
         }

         //Address mappings
         if(accountP.BillingStreet != null) {
             List<String> streetListBilling = accountP.BillingStreet.split('\r\n');
             String line1Billing;
             String line2Billing;
             if(streetListBilling.size() > 0){
                 line1Billing = streetListBilling[0];
                 if(streetListBilling.size() > 1){
                     line2Billing = streetListBilling[1];
                 }
             }
             //cvsValPostalAddBean.line1 = line1Billing;
             //W-006881-Anka Ganta-2020-10-30
             if(line1Billing.containsIgnoreCase('P.O. BOX')){
                 cvsValPostalAddBean.line1 = line1Billing.replace('P.O. BOX','PO BOX');
             }else if(line1Billing.containsIgnoreCase('P O BOX')){
                 cvsValPostalAddBean.line1 = line1Billing.replace('P O BOX','PO BOX');
             }else{
                 cvsValPostalAddBean.line1 = line1Billing;
             }
             cvsValPostalAddBean.line2 = line2Billing;
             cvsValPostalAddBean.city = accountP.BillingCity;
             cvsValPostalAddBean.postalCode = accountP.BillingPostalCode;
             cvsValPostalAddBean.countryCode = tanslationValueMapP.get('billCountryTranslated');
         }

         if(accountP.ShippingStreet != null) {
             List<String> streetListShipping = accountP.ShippingStreet.split('\r\n');
             String line1Shipping;
             String line2Shipping;
             if(streetListShipping.size() > 0){
                 line1Shipping = streetListShipping[0];
                 if(streetListShipping.size() > 1){
                     line2Shipping = streetListShipping[1];
                 }
             }
             //cvsValHomeAddBean.line1 = line1Shipping;
             cvsValHomeAddBean.line2 = line2Shipping;
             cvsValHomeAddBean.city = accountP.ShippingCity;
             cvsValHomeAddBean.postalCode = accountP.ShippingPostalCode;
             cvsValHomeAddBean.countryCode = tanslationValueMapP.get('shipCountryTranslated');
         }

         for(Address__c add : addressListP){

             //Add additional addresses for Sole Trader
           //  if(accountP.Client_Type__c.toUpperCase() == 'SOLE TRADER') {
                 String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);

                 CvsValidationService_Req_IB_v1.cls_Address cvsValAddressAccBean = new CvsValidationService_Req_IB_v1.cls_Address();
                 CvsValidationService_Req_IB_v1.cls_RegisteredAddress cvsValRegAddAccBean = new CvsValidationService_Req_IB_v1.cls_RegisteredAddress();
                 CvsValidationService_Req_IB_v1.cls_HeadOfficeAddress cvsValHeadOffcAddAccBean = new CvsValidationService_Req_IB_v1.cls_HeadOfficeAddress();

                 if(add.Address_Type__c == StringConstants.POSTAL_STRING){
                     //cvsValAddressAccBean.line1 = add.Shipping_Street__c;
                     //W-006881-Anka Ganta-2020-10-30
                     if(add.Shipping_Street__c.containsIgnoreCase('P.O. BOX')){
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c.replace('P.O. BOX','PO BOX');
                     }else if(add.Shipping_Street__c.containsIgnoreCase('P O BOX')){
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c.replace('P O BOX','PO BOX');
                     }else{
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c;
                     }
                     cvsValAddressAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValAddressAccBean.city = add.Shipping_City__c;
                     cvsValAddressAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValAddressAccBean.countryCode = countryOfResTranslated;

                     if(accountP.BillingStreet == null) {
                         cvsValPostalAddBean.line1 = add.Shipping_Street__c;
                         cvsValPostalAddBean.line2 = add.Shipping_Suburb__c;
                         cvsValPostalAddBean.city = add.Shipping_City__c;
                         cvsValPostalAddBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                         cvsValPostalAddBean.countryCode = countryOfResTranslated;
                     }

                     cvsValBusinessBean.address = cvsValAddressAccBean;
                 }

                 if(add.Address_Type__c == StringConstants.RESIDENTIAL_STRING){
                     cvsValRegAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValRegAddAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValRegAddAccBean.city = add.Shipping_City__c;
                     cvsValRegAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValRegAddAccBean.countryCode = countryOfResTranslated;

                     cvsValBusinessBean.registeredAddress = cvsValRegAddAccBean;
                 }

                 if(add.Address_Type__c == StringConstants.PHYSICAL_ADDR_STRING){
                     cvsValHeadOffcAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValHeadOffcAddAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValHeadOffcAddAccBean.city = add.Shipping_City__c;
                     cvsValHeadOffcAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValHeadOffcAddAccBean.countryCode = countryOfResTranslated;

                     if(accountP.ShippingStreet == null) {
                         cvsValHomeAddBean.line1 = add.Shipping_Street__c;
                         cvsValHomeAddBean.line2 = add.Shipping_Suburb__c;
                         cvsValHomeAddBean.city = add.Shipping_City__c;
                         cvsValHomeAddBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                         cvsValHomeAddBean.countryCode = countryOfResTranslated;
                     }

                     cvsValBusinessBean.headOfficeAddress = cvsValHeadOffcAddAccBean;
                 }

            // } else {

                 if(add.Address_Type__c == StringConstants.EMPLOYER_ADDR_STRING){

                     List<String> streetListEmployers = add.Shipping_Street__c.split('\r\n');
                     String line1Employers;
                     String line2Employers;
                     if(streetListEmployers.size() > 0){
                         line1Employers = streetListEmployers[0];
                         if(streetListEmployers.size() > 1){
                             line2Employers = streetListEmployers[1];
                         }
                     }
                     cvsValWorkAddBean.line1 = accountP.Employer_Name__pc;
                     cvsValWorkAddBean.line2 = line1Employers;
                     cvsValWorkAddBean.city = add.Shipping_City__c;
                     cvsValWorkAddBean.postalCode = String.valueOf(add.Shipping_Zip_Postal_Code__c);
                     cvsValWorkAddBean.countryCode = tanslationValueMapP.get('employerCountryTranslated');

                     cvsValEmploymentInfoBean.workAddress = cvsValWorkAddBean;
                 }
            // }
         }

         cvsValEmploymentInfoBean.occupationCode = tanslationValueMapP.get('occupaionCodeTranslated');
         cvsValEmploymentInfoBean.occupationStatus = tanslationValueMapP.get('occupationStatusTranslated');
         //TdB - W-005526
         cvsValEmploymentInfoBean.occupationLevel = tanslationValueMapP.get('occupationLevelTranslated');
         cvsValEmploymentInfoBean.employerName = accountP.Employer_Name__pc;

         if(accountP.Non_Credit_Marketing_Indicator__pc != null){
             cvsValMarketInfoBean.email = accountP.Non_Credit_Marketing_Indicator__pc.contains('Email') ? 'Y' : 'N';
             cvsValMarketInfoBean.mail = accountP.Non_Credit_Marketing_Indicator__pc.contains('Mail') ? 'Y' : 'N';
             cvsValMarketInfoBean.sms = accountP.Non_Credit_Marketing_Indicator__pc.contains('Phone') ? 'Y' : 'N';
             cvsValMarketInfoBean.telephone = accountP.Non_Credit_Marketing_Indicator__pc.toUpperCase().contains('SMS') ? 'Y' : 'N';
         }
         cvsValMarketInfoBean.preferredCommunicationChannel = tanslationValueMapP.get('comMethodTranslated');

         cvsValheaderBean.clientType = tanslationValueMapP.get('clientTypeTranslated');
         cvsValheaderBean.clientTypeGroup = tanslationValueMapP.get('clientTypeGroupTranslated');
         cvsValheaderBean.applicationId = 'Salesforce';
         cvsValheaderBean.version = CvsValidationService_IH_v1.getCVSVersion();

         if(accountP.PersonHomePhone != null){
             Integer homeNumberSize = accountP.PersonHomePhone.length();
             cvsValHomePhoneBean.dialCode = accountP.PersonHomePhone.Substring(0, 3);
             cvsValHomePhoneBean.valNumber = accountP.PersonHomePhone.Substring(3, homeNumberSize);
             cvsValContactInfoBean.homePhone = cvsValHomePhoneBean;
         }
         if(accountP.Phone != null){
             Integer workNumberSize = accountP.Phone.length();
             cvsValWorkPhoneBean.dialCode = accountP.Phone.Substring(0, 3);
             cvsValWorkPhoneBean.valNumber = accountP.Phone.Substring(3, workNumberSize);
             cvsValContactInfoBean.workPhone = cvsValWorkPhoneBean;
         }

         if(accountP.PersonMobilePhone != null){
             String phoneNumber = accountP.PersonMobilePhone;

             if(phoneNumber.length() > 10){
                 //Take last 10 Digits
                 Integer numberLength = phoneNumber.length();
                 cvsValContactInfoBean.cellPhoneNo = phoneNumber.Substring(numberLength - 10, numberLength);

             }else if(phoneNumber.length() < 10){
                 //Add 0 infront until number is 10 digits
                 while(phoneNumber.length() < 10){
                     phoneNumber = '0' + phoneNumber;
                 }
                 cvsValContactInfoBean.cellPhoneNo = phoneNumber;
             }else{
                 //Number is the correct length
                 cvsValContactInfoBean.cellPhoneNo = phoneNumber;
             }
         }

         cvsValContactInfoBean.emailAddress = accountP.PersonEmail;

         cvsValFicaBean.dateExempted = '0';

         List<String> validatorSetList = new List<String>();
         for(String valSet : CvsValidationService_IH_v1.getCVSValidatorSetRbbIndividual()){
             validatorSetList.add(valSet);
         }

         cvsValBean.validatorSet = validatorSetList;

         //Assign beans
         cvsValContactInfoBean.postalAddress = cvsValPostalAddBean;
         cvsValContactInfoBean.homeAddress = cvsValHomeAddBean;
         cvsValClientBean.idNumber = cvsValIdNumberBean;
         cvsValBean.contactInfo = cvsValContactInfoBean;
         cvsValBean.client = cvsValClientBean;
         cvsValBean.employmentInfo = cvsValEmploymentInfoBean;
         cvsValBean.marketingInfo = cvsValMarketInfoBean;
         cvsValBean.header = cvsValheaderBean;
         cvsValBean.fica = cvsValFicaBean;
         cvsValBean.businessInfo = cvsValBusinessBean;
         cvsValBean.nextOfKin = cvsValNextOfKinBean;
         cvsValNextOfKinBean.contactDetail = cvsValNextOfKinContactInfoBean;
         cvsValNextOfKinBean.contactDetail.HomePhone = cvsValNextOfKinHomePhoneBean;
         return cvsValBean;
     }
    /**
    * @description TdB - RBB Mini Individual Mapping
    * @param accountP 
    * @param addressListP 
    * @param clientTypeGroupP 
    * @param tanslationValueMapP 
    * @return CvsValidationService_Req_IB_v1 
    **/
    public static CvsValidationService_Req_IB_v1 mapRBBMiniIndividualRequestFields(Account accountP, List<Address__c> addressListP, String clientTypeGroupP, Map<String, String> tanslationValueMapP){
         //initiate beans
         CvsValidationService_Req_IB_v1 cvsValBean = new CvsValidationService_Req_IB_v1();
         CvsValidationService_Req_IB_v1.cls_Client cvsValClientBean = new CvsValidationService_Req_IB_v1.cls_Client();
         CvsValidationService_Req_IB_v1.cls_ContactInfo cvsValContactInfoBean = new CvsValidationService_Req_IB_v1.cls_ContactInfo();
         CvsValidationService_Req_IB_v1.cls_PostalAddress cvsValPostalAddBean = new CvsValidationService_Req_IB_v1.cls_PostalAddress();
         CvsValidationService_Req_IB_v1.cls_HomeAddress cvsValHomeAddBean = new CvsValidationService_Req_IB_v1.cls_HomeAddress();
         CvsValidationService_Req_IB_v1.cls_WorkAddress cvsValWorkAddBean = new CvsValidationService_Req_IB_v1.cls_WorkAddress();
         CvsValidationService_Req_IB_v1.cls_IdNumber cvsValIdNumberBean = new CvsValidationService_Req_IB_v1.cls_IdNumber();
         CvsValidationService_Req_IB_v1.cls_EmploymentInfo cvsValEmploymentInfoBean = new CvsValidationService_Req_IB_v1.cls_EmploymentInfo();
         CvsValidationService_Req_IB_v1.cls_Header cvsValheaderBean = new CvsValidationService_Req_IB_v1.cls_Header();
         CvsValidationService_Req_IB_v1.cls_BusinessInfo cvsValBusinessBean = new CvsValidationService_Req_IB_v1.cls_BusinessInfo();

         cvsValIdNumberBean.documentType = tanslationValueMapP.get('idTypeTranslated');
         cvsValIdNumberBean.valNumber = accountP.ID_Number__pc;

          String countryOfIncorporationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Country', accountP.Country_of_Incorporation__c, StringConstants.OUTBOUND_RECORD_TYPE);
             if(countryOfIncorporationTranslated!= null){
                 cvsValBusinessBean.countryIncorporated = countryOfIncorporationTranslated;
             }

         cvsValClientBean.countryOfBirthCode = tanslationValueMapP.get('countryOfBirthTranslated');
         cvsValIdNumberBean.countryOfIssueCode = tanslationValueMapP.get('countryIssueTranslated');
        cvsValClientBean.homeLanguage = tanslationValueMapP.get('comLanguageTranslated');
         cvsValClientBean.correspondenceLanguage = tanslationValueMapP.get('comLanguageTranslated');

         for(Address__c add : addressListP){

             //Add additional addresses for Sole Trader

                 String countryOfResTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Registration__c, StringConstants.OUTBOUND_RECORD_TYPE);

                 CvsValidationService_Req_IB_v1.cls_Address cvsValAddressAccBean = new CvsValidationService_Req_IB_v1.cls_Address();
                 CvsValidationService_Req_IB_v1.cls_RegisteredAddress cvsValRegAddAccBean = new CvsValidationService_Req_IB_v1.cls_RegisteredAddress();
                 CvsValidationService_Req_IB_v1.cls_HeadOfficeAddress cvsValHeadOffcAddAccBean = new CvsValidationService_Req_IB_v1.cls_HeadOfficeAddress();

                 if(add.Address_Type__c == StringConstants.POSTAL_STRING){
                     //cvsValAddressAccBean.line1 = add.Shipping_Street__c;
                     //W-006881-Anka Ganta-2020-10-30
                     if(add.Shipping_Street__c.containsIgnoreCase('P.O. BOX')){
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c.replace('P.O. BOX','PO BOX');
                     }else if(add.Shipping_Street__c.containsIgnoreCase('P O BOX')){
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c.replace('P O BOX','PO BOX');
                     }else{
                         cvsValAddressAccBean.line1 = add.Shipping_Street__c;
                     }
                     cvsValAddressAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValAddressAccBean.city = add.Shipping_City__c;
                     cvsValAddressAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValAddressAccBean.countryCode = countryOfResTranslated;

                     if(accountP.BillingStreet == null) {
                         cvsValPostalAddBean.line1 = add.Shipping_Street__c;
                         cvsValPostalAddBean.line2 = add.Shipping_Suburb__c;
                         cvsValPostalAddBean.city = add.Shipping_City__c;
                         cvsValPostalAddBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                         cvsValPostalAddBean.countryCode = countryOfResTranslated;
                     }

                     cvsValBusinessBean.address = cvsValAddressAccBean;
                 }

                 if(add.Address_Type__c == StringConstants.RESIDENTIAL_STRING){
                     cvsValRegAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValRegAddAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValRegAddAccBean.city = add.Shipping_City__c;
                     cvsValRegAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValRegAddAccBean.countryCode = countryOfResTranslated;

                     cvsValBusinessBean.registeredAddress = cvsValRegAddAccBean;
                 }

                 if(add.Address_Type__c == StringConstants.PHYSICAL_ADDR_STRING){
                     cvsValHeadOffcAddAccBean.line1 = add.Shipping_Street__c;
                     cvsValHeadOffcAddAccBean.suburb = add.Shipping_Suburb__c;
                     cvsValHeadOffcAddAccBean.city = add.Shipping_City__c;
                     cvsValHeadOffcAddAccBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                     cvsValHeadOffcAddAccBean.countryCode = countryOfResTranslated;

                     if(accountP.ShippingStreet == null) {
                         cvsValHomeAddBean.line1 = add.Shipping_Street__c;
                         cvsValHomeAddBean.line2 = add.Shipping_Suburb__c;
                         cvsValHomeAddBean.city = add.Shipping_City__c;
                         cvsValHomeAddBean.postalCode = add.Shipping_Zip_Postal_Code__c;
                         cvsValHomeAddBean.countryCode = countryOfResTranslated;
                     }

                     cvsValBusinessBean.headOfficeAddress = cvsValHeadOffcAddAccBean;
                 }



                 if(add.Address_Type__c == StringConstants.EMPLOYER_ADDR_STRING){

                     List<String> streetListEmployers = add.Shipping_Street__c.split('\r\n');
                     String line1Employers;
                     String line2Employers;
                     if(streetListEmployers.size() > 0){
                         line1Employers = streetListEmployers[0];
                         if(streetListEmployers.size() > 1){
                             line2Employers = streetListEmployers[1];
                         }
                     }
                     cvsValWorkAddBean.line1 = accountP.Employer_Name__pc;
                     cvsValWorkAddBean.line2 = line1Employers;
                     cvsValWorkAddBean.city = add.Shipping_City__c;
                     cvsValWorkAddBean.postalCode = String.valueOf(add.Shipping_Zip_Postal_Code__c);
                     cvsValWorkAddBean.countryCode = tanslationValueMapP.get('employerCountryTranslated');

                     cvsValEmploymentInfoBean.workAddress = cvsValWorkAddBean;
                 }
             }


         cvsValheaderBean.clientType = tanslationValueMapP.get('clientTypeTranslated');
         cvsValheaderBean.clientTypeGroup = tanslationValueMapP.get('clientTypeGroupTranslated');
         cvsValheaderBean.applicationId = 'Salesforce';
         cvsValheaderBean.version = CvsValidationService_IH_v1.getCVSVersion();

         List<String> validatorSetList = new List<String>();
         for(String valSet : CvsValidationService_IH_v1.getCVSValidatorSetRbbMiniIndividual()){
             validatorSetList.add(valSet);
         }

         cvsValBean.validatorSet = validatorSetList;

         //Assign beans
         cvsValContactInfoBean.postalAddress = cvsValPostalAddBean;
         cvsValContactInfoBean.homeAddress = cvsValHomeAddBean;
         cvsValBean.client = cvsValClientBean;
         cvsValClientBean.idNumber = cvsValIdNumberBean;
         cvsValBean.businessInfo = cvsValBusinessBean;
         cvsValBean.employmentInfo = cvsValEmploymentInfoBean;
         cvsValBean.header = cvsValheaderBean;
         return cvsValBean;
     }
}