/**
 * Apex abstract class for the ClientFinderExt
 *
 * @author  Tracy de Bruin : CloudSmiths
 * @since   2018-08-07
 *
 **/
public abstract class ClientFinderBase {
    /*Call method to search in Salesforce
     *
     * @param  search Value
     * @return List<Account>
     */
    public static List<Account> searchSalesforceAccountsByName(String searchValue) {
        List<Account> accountsList = new AccountsSelector().selectByName(searchValue, 10);
        for (Account eachClient : accountsList) {
            eachClient.Source__c = 'SF';
            if (eachClient.IsPersonAccount == true) {
                eachClient.Client_Type__c = 'Individual';
            } else {
                eachClient.Client_Type__c = 'Business';
            }
        }
        return accountsList;
    }

    /*Call method to search in Salesforce
     *
     * @param  search Value
     * @return List<Account>
     */
    public static List<Account> searchSalesforceAccountsByCIF(String searchValue) {
        List<Account> accountsList = new AccountsSelector().selectByCIF(searchValue, 10);
        return accountsList;
    }

    /*Call method to search in Salesforce - SOSL
     *
     * @param  search Value
     * @return List<Account>
     */
    public static List<Account> searchSalesforceAccountsByValue(String searchValue) {
        List<Account> accountsList = new AccountsSelector().searchByValueOnAllFields(searchValue, 10);
        return accountsList;
    }

    /*Adapt360 search
     *
     * @param  search Value
     * @param  search Type
     * @return String (Bean)
     */
    public static String getAdapt360ClientBean(String searchType, String searchValue) {
        String viewP = 'CIB_VIEW';
        Boolean hideMetaP = false;
        ADAPT360_Resp_IB_v1 clientProfilesBean;
        try {
            clientProfilesBean = ADAPT360_IH_v1.retrieveClientDetails(searchType, searchValue, viewP, hideMetaP);
            if (clientProfilesBean.ClientDetails != null) {
                return JSON.serialize(clientProfilesBean);
            } else {
                return null;
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.Finest, 'Exception : ClientFinderBase : getAdapt360ClientBean - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /*Generate Adapt360 Bean and return Account List
     *
     * @param  ClientBean JSON
     * @return List<Account>
     */
    public static List<Account> generateAdapt360ClientBean(String clientProfilesBeanText) {
        try {
            ADAPT360_Resp_IB_v1 clientProfilesBean = (ADAPT360_Resp_IB_v1) JSON.deserialize(clientProfilesBeanText, ADAPT360_Resp_IB_v1.class);
            List<Account> accountList = new List<Account>();
            if (clientProfilesBean != null) {
                for (ADAPT360_Resp_IB_v1.ClientDetails client : clientProfilesBean.ClientDetails) {
                    ADAPT360_Resp_IB_v1.LocationInfo location = client.location;
                    ADAPT360_Resp_IB_v1.IndividualInfo individual = client.individual;
                    ADAPT360_Resp_IB_v1.IdentificationsInfo[] identifications = client.identifications;
                    ADAPT360_Resp_IB_v1.CustomerDetailsInfo customerDetails = client.customerDetails;
                    ADAPT360_Resp_IB_v1.ContactInfo contact = client.contact;
                    String clientDetailsId = client.clientDetailsId;
                    ADAPT360_Resp_IB_v1.AuthorityInfo[] authority = client.authority;
                    ADAPT360_Resp_IB_v1.AccountInfo[] account = client.account;
                    if (individual != null) {
                        String salutationType = individual.salutationType.description.value;
                        String nameInitials = individual.nameInitials.value;
                        String firstName = individual.givenName.value;
                        String lastName = individual.surname.value;
                        Account eachAccount = new Account();
                        //Individual
                        if (firstName != null && firstName != '') {
                            //TODO - TdB - Confirm mapping with Derek
                            eachAccount.FirstName = firstName;
                            eachAccount.LastName = lastName;
                            eachAccount.Salutation = salutationType;
                            //Contact details
                            if (contact != null) {
                                if (contact.communicationChannelType != null) {
                                    eachAccount.Communication_Method__c = contact.communicationChannelType.description.value;
                                }
                                if (contact.cellPhoneNumber != null) {
                                    eachAccount.PersonMobilePhone = contact.cellPhoneNumber.value;
                                }
                                if (contact.homePhone != null) {
                                    eachAccount.PersonHomePhone = contact.homePhone.value;
                                }
                                if (contact.workPhone != null) {
                                    eachAccount.Phone = contact.workPhone.value;
                                }
                                if (contact.eMailUserId != null) {
                                    eachAccount.PersonEmail = contact.eMailUserId.value;
                                }
                            }
                            //Physical and Postal Address
                            if (location != null) {
                                if (location.physicalAddress != null) {
                                    if (location.physicalAddress.addressName1 != null) {
                                        eachAccount.ShippingStreet = location.physicalAddress.addressName1.value;
                                    }
                                    if (location.physicalAddress.addressName2 != null) {
                                        eachAccount.ShippingStreet = eachAccount.ShippingStreet + ' ' + location.physicalAddress.addressName2.value;
                                    }
                                    if (location.physicalAddress.cityName != null) {
                                        eachAccount.ShippingCity = location.physicalAddress.cityName.value;
                                    }
                                    if (location.physicalAddress.postCodeArea != null) {
                                        eachAccount.ShippingPostalCode = location.physicalAddress.postCodeArea.value;
                                    }
                                    if (location.physicalAddress.suburbName != null) {
                                        eachAccount.ShippingState = location.physicalAddress.suburbName.value;
                                    }
                                }
                                if (location.postalAddress != null) {
                                    if (location.postalAddress.addressName1 != null) {
                                        eachAccount.BillingStreet = location.postalAddress.addressName1.value;
                                    }
                                    if (location.postalAddress.addressName2 != null) {
                                        eachAccount.BillingStreet = eachAccount.BillingStreet + ' ' + location.postalAddress.addressName2.value;
                                    }
                                    if (location.postalAddress.cityName != null) {
                                        eachAccount.BillingCity = location.postalAddress.cityName.value;
                                    }
                                    if (location.postalAddress.postCodeArea != null) {
                                        eachAccount.BillingPostalCode = location.postalAddress.postCodeArea.value;
                                    }
                                    if (location.postalAddress.suburbName != null) {
                                        eachAccount.BillingState = location.postalAddress.suburbName.value;
                                    }
                                }
                            }
                            //Id number and Client Type (default value)
                            if (customerDetails != null) {
                                if (customerDetails.groupScheme != null) {
                                    eachAccount.Client_Type__c = customerDetails.groupScheme.description.value;
                                }
                                if (customerDetails.individualId != null) {
                                    eachAccount.ID_Number__pc = customerDetails.individualId.value;
                                }
                            }
                        } else {
                            eachAccount.Name = firstName + ' ' + lastName;
                            //TODO - TdB - Confirm mapping with Derek
                            //Contact details
                            if (contact != null) {
                                if (contact.workPhone != null) {
                                    eachAccount.Phone = contact.workPhone.value;
                                }
                                if (contact.communicationChannelType != null) {
                                    eachAccount.Communication_Method__c = contact.communicationChannelType.description.value;
                                }
                            }
                            //Physical and Postal Address
                            if (location != null) {
                                //18-10-22 DH deleted as per WhatsApp messga.Preferred_Email__c = emailAddress;
                                if (location.businessAddress != null) {
                                    if (location.businessAddress.addressName1 != null) {
                                        eachAccount.ShippingStreet = location.businessAddress.addressName1.value;
                                    }
                                    if (location.businessAddress.addressName2 != null) {
                                        eachAccount.ShippingStreet = eachAccount.ShippingStreet + ' ' + location.businessAddress.addressName2.value;
                                    }
                                    if (location.businessAddress.cityName != null) {
                                        eachAccount.ShippingCity = location.businessAddress.cityName.value;
                                    }
                                    if (location.businessAddress.postCodeArea != null) {
                                        eachAccount.ShippingPostalCode = location.businessAddress.postCodeArea.value;
                                    }
                                    if (location.businessAddress.suburbName != null) {
                                        eachAccount.ShippingState = location.businessAddress.suburbName.value;
                                    }
                                }

                                if (location.headOfficeAddress != null) {
                                    if (location.headOfficeAddress.addressName1 != null) {
                                        eachAccount.BillingStreet = location.headOfficeAddress.addressName1.value;
                                    }
                                    if (location.headOfficeAddress.addressName2 != null) {
                                        eachAccount.BillingStreet = eachAccount.BillingStreet + ' ' + location.headOfficeAddress.addressName2.value;
                                    }
                                    if (location.headOfficeAddress.cityName != null) {
                                        eachAccount.BillingCity = location.headOfficeAddress.cityName.value;
                                    }
                                    if (location.headOfficeAddress.postCodeArea != null) {
                                        eachAccount.BillingPostalCode = location.headOfficeAddress.postCodeArea.value;
                                    }
                                    if (location.headOfficeAddress.suburbName != null) {
                                        eachAccount.BillingState = location.headOfficeAddress.suburbName.value;
                                    }
                                }
                            }
                            //Client Type (default value)
                            if (customerDetails.groupScheme != null) {
                                eachAccount.Client_Type__c = customerDetails.groupScheme.description.value;
                            }
                        }
                        if (identifications != null) {
                            eachAccount.CIF__c = identifications[0].numbers;
                        }
                        eachAccount.Source__c = 'CIF';
                        
                        //TdB - Set Client Type based on Integration Translations
                        if (String.isNotBlank(customerDetails?.customerType?.description?.value)) {
                            String translatedClientType = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Client Type',customerDetails.customerType.description.value,StringConstants.INBOUND_RECORD_TYPE);
                            if (String.isNotBlank(translatedClientType)) {
                                // Overwrite the default Client Type with translatedClientType
                                eachAccount.Client_Type__c = translatedClientType;
                            }
                        }
                        
                        //TdB - Set Client Group based on Integration Translations
                        if (String.isNotBlank(customerDetails?.groupScheme?.description?.value)) {
                            String translatedClientGroup = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF','Client Type Group',customerDetails.groupScheme.description.value,StringConstants.INBOUND_RECORD_TYPE);
                            if (String.isNotBlank(translatedClientGroup)) {
                                // Overwrite the default Client Type with translatedClientGroup
                                eachAccount.Client_Group__c = translatedClientGroup;
                            }
                        }

                        accountList.add(eachAccount);
                    }
                }
            }
            if (accountList.size() > 0) {
                return accountList;
            } else {
                return null;
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.Finest, 'Exception : ClientFinderBase : generateAdapt360ClientBean - ' + ex.getMessage());
            System.debug(LoggingLevel.Finest, 'Exception : ClientFinderBase : generateAdapt360ClientBean - ' + ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /*Get Involved Parties search
     *
     * @param  search Value
     * @param  search Type
     * @return String (Bean)
     */
    public static String getInvolvedPartyClientBean(String searchType, String searchValue) {
        RegSer_InvolvedParties_Resp_IB_v1 involvedParties;
        try {
            involvedParties = RegSer_InvolvedParties_IH_v1.getInvolvedParties(searchType, searchValue, false);
            if (involvedParties.statusCode == 200 && involvedParties.content.identifications != null) {
                System.debug('here involvedParties' + involvedParties);
                return JSON.serialize(involvedParties);
            } else {
                return null;
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.Finest, 'Exception : ClientFinderBase : getInvolvedPartyClientBean - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /*Generate Get Involved Party Bean and return Account
     *
     * @param  ClientBean JSON
     * @return Account
     */
    public static Account generateInvolvedPartyClientBean(String clientProfilesBeanText) {
        try {
            RegSer_InvolvedParties_Resp_IB_v1 clientProfilesBean = (RegSer_InvolvedParties_Resp_IB_v1) JSON.deserialize(
                clientProfilesBeanText,
                RegSer_InvolvedParties_Resp_IB_v1.class
            );
            Account account = new Account();
            if (clientProfilesBean != null) {
                String cifNumber = clientProfilesBean.content.identifications.get(0).numbers;
                String idNumber = clientProfilesBean.content.identifications.get(1).numbers;
                //Individual
                if (clientProfilesBean.content.individual != null) {
                    account.Client_Type__c = 'Individual';
                    account.Client_Group__c = 'Individual';
                    account.LastName = clientProfilesBean.content.individual.surname;
                    account.FirstName = clientProfilesBean.content.individual.name;
                    account.Person_Informal_Name__pc = clientProfilesBean.content.individual.knownAs;
                    account.Initials__pc = clientProfilesBean.content.individual.initials.toUpperCase();
                    if (clientProfilesBean.content.individual.salutation != null) {
                        account.PersonTitle = clientProfilesBean.content.individual.salutation.description.toUpperCase();
                    }
                    if (clientProfilesBean.content.individual.gender != null) {
                        account.Gender__pc = clientProfilesBean.content.individual.gender.description;
                    }
                    //ToDo remove hardcoded value as soon as we get mapping
                    account.ID_Type__pc = 'SA Identity Document';
                    account.ID_Number__pc = idNumber;
                    if (clientProfilesBean.content.individual.dateofBirth != null) {
                        account.PersonBirthdate = Date.parse(clientProfilesBean.content.individual.dateofBirth.replace('-', '/'));
                    }
                    if (clientProfilesBean.content.individual.maritalContractType != null) {
                        account.Marital_Contract_Type__pc = clientProfilesBean.content.individual.maritalContractType.description;
                    }
                    account.Occupation__pc = clientProfilesBean.content.individual.occupation;
                    if (clientProfilesBean.content.sourcesOfIncome.size() != 0) {
                        account.Income_Source__pc = clientProfilesBean.content.sourcesOfIncome.get(0).description;
                    }
                    account.Occupation_Status__pc = clientProfilesBean.content.individual.occupationStatus;
                } else {
                    // Default Client Type is no translation is found
                    account.Client_Type__c = 'Joint & Several';

                    if (String.isNotBlank(clientProfilesBean?.content?.formalOrganisation?.type?.code)) {
                        String translatedClientType = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
                            'MDM',
                            'Client Type',
                            clientProfilesBean.content.formalOrganisation.type.code,
                            StringConstants.INBOUND_RECORD_TYPE
                        );
                        if (String.isNotBlank(translatedClientType)) {
                            // Overwrite the default Client Type with translatedClientType
                            account.Client_Type__c = translatedClientType;
                            
                            if(translatedClientType == 'Sole Trader' || translatedClientType == 'Sole Proprietor' ) {
                                account.Client_Group__c = 'SOLE TRADER CLIENT';
                            } else {
                                account.Client_Group__c = 'Non Individual';
                            }
                        }
                    }

                    account.Name = clientProfilesBean.content.name;
                    if (clientProfilesBean.content.addresses.addresses.size() > 1) {
                        account.Country_of_Registration__c = clientProfilesBean.content.addresses.addresses.get(0).countryName;
                    }
                }

                account.CIF__c = cifNumber;

                for (RegSer_InvolvedParties_Resp_IB_v1.cls_addresses_telephonicAddress phone : clientProfilesBean.content.addresses.telephonicAddress) {
                    if (phone.context.description == 'MainHomePhone') {
                        account.PersonHomePhone = phone.countryCode + phone.diallingCode + phone.numbers;
                    }
                    if (phone.context.description == 'MainCellPhone') {
                        account.PersonMobilePhone = phone.countryCode + phone.diallingCode + phone.numbers;
                    }
                    if (phone.context.description == 'MainWorkPhone') {
                        account.Phone = phone.countryCode + phone.diallingCode + phone.numbers;
                    }
                }
                for (RegSer_InvolvedParties_Resp_IB_v1.cls_addresses_addresses address : clientProfilesBean.content.addresses.addresses) {
                    if (address.context.description == 'Residential') {
                        account.ShippingStreet = address.addressName1 + ' ' + address.addressName2;
                        account.ShippingCity = address.cityName;
                        account.ShippingPostalCode = address.postalCode;
                    }
                    if (address.context.description == 'Postal') {
                        account.BillingStreet = address.addressName1 + ' ' + address.addressName2;
                        account.BillingCity = address.cityName;
                        account.BillingPostalCode = address.postalCode;
                    }
                }

                account.Source__c = 'MDM';
                System.debug('ClientFinderBase.generateInvolvedPartyClientBean: account: ' + account);
                return account;
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.Finest, 'Exception : ClientFinderBase : generateAdapt360ClientBean - ' + ex.getMessage());
            String errorMessage = 'An error occurred while try to create an Account based on data received from MDM based on your search criteria, please log a call with your system administrator and provide the following information: '+
                                    'Error method: ClientFinderBase. generateInvolvedPartyClientBean; - '+
                                    'Error line:' +ex.getLineNumber()+'; - '+
                                    'Error message:' +ex.getMessage()+'; - '+
                                    'Error cause:' +ex.getCause()+'.' ;
            System.debug('<<<<<<<< errorMessage:' + errorMessage);

            throw new AuraHandledException(errorMessage);
        }
        return null;
    }

    /*getJointParticipant search
     *
     * @param  CIF number
     * @return String (Bean)
     */
    public static String getJointParticipantsBean(String cifNumber) {
        GetJointParticipant_Resp_IB_v1 clientParticipantsBean;
        clientParticipantsBean = GetJointParticipant_IH_v1.getJointParticipant(cifNumber);
        return JSON.serialize(clientParticipantsBean);
    }

    /*Generate getJointParticipant Bean and return Account List
     *
     * @param  ParticipantBean JSON
     * @return List<Account>
     */
    public static List<Account> generateJointParticipantBean(String clientParticipantsBeanText) {
        GetJointParticipant_Resp_IB_v1 clientParticipantsBean = (GetJointParticipant_Resp_IB_v1) JSON.deserialize(
            clientParticipantsBeanText,
            GetJointParticipant_Resp_IB_v1.class
        );
        System.debug('clientParticipantsBean: ' + clientParticipantsBean);
        List<Account> participantsList = new List<Account>();
        Account newParticipant;
        GetJointParticipant_Resp_IB_v1.cls_ForeignTaxData[] foreignTaxData;
        if (clientParticipantsBean != null && clientParticipantsBean.jntEntry != null) {
            for (GetJointParticipant_Resp_IB_v1.cls_JntEntry entry : clientParticipantsBean.jntEntry) {
                foreignTaxData = entry.foreignTaxData;
                String idNumber = entry.idNumber;
                String initials = entry.initials;
                String titleCode = entry.titleCode;
                String surname = entry.surname;
                String resAddrLine1 = entry.resAddrLine1;
                String resAddrLine2 = entry.resAddrLine2;
                String resSuburb = entry.resSuburb;
                String resTown = entry.resTown;
                String resPosCde = entry.resPosCde;
                String firstNames = entry.firstNames;
                String homeTelCode = entry.homeTelCode;
                String homeTelephone = entry.homeTelephone;
                String workTelCode = entry.workTelCode;
                String workTelephone = entry.workTelephone;
                String cellPhone = entry.cellphone;
                String practiceNumber = entry.practiceNumber;
                String birthDate = entry.birthDate;
                String sourceOfIncome = entry.sourceOfIncome;
                String dateIdentified = entry.dateIdentified;
                String dateVerified = entry.dateVerified;
                String employeeIdentified = entry.employeeIdentified;
                String employeeVerified = entry.employeeVerified;
                String taxNumber = entry.taxNumber;
                String clientNationality = entry.clientNationality;
                String countryOfOrigin = entry.countryOfOrigin;
                String tempPermitNumber = entry.tempPermitNumber;
                String permitExpiryDate = entry.permitExpiryDate;
                String homeTcodex = entry.homeTcodex;
                String workTcodex = entry.workTcodex;
                String cellx = entry.cellx;
                String groupScheme = entry.groupScheme;
                String groupSchemeEmp = entry.groupSchemeEmp;
                String dateIssued = entry.dateIssued;
                String dateExempted = entry.dateExempted;
                String empExempted = entry.empExempted;
                String statusOfExempt = entry.statusOfExempt;
                String exemptionInd = entry.exemptionInd;
                String countryOfRes = entry.countryOfRes;
                String countryOfBirth = entry.countryOfBirth;
                String occupationStatus = entry.occupationStatus;
                String occupationCode = entry.occupationCode;
                String saTaxRegis = entry.saTaxRegis;
                String rsonSaTaxNotGiven = entry.rsonSaTaxNotGiven;
                String foreignTaxRegis = entry.foreignTaxRegis;
                //Participant Information
                newParticipant = new Account();
                newParticipant.FirstName = firstNames;
                newParticipant.LastName = surname;
                newParticipant.Salutation = '';
                newParticipant.ID_Number__pc = idNumber;
                newParticipant.PersonMobilePhone = cellPhone;
                newParticipant.PersonHomePhone = homeTelCode + homeTelephone;
                newParticipant.Phone = workTelCode + workTelephone;
                newParticipant.ShippingStreet = resAddrLine1 + ' ' + resAddrLine2;
                newParticipant.ShippingCity = resTown;
                newParticipant.ShippingPostalCode = resPosCde;
                newParticipant.Source__c = 'CIF';
                newParticipant.Client_Type__c = 'INDIVIDUAL';
                participantsList.add(newParticipant);
            }
        }
        return participantsList;
    }
}