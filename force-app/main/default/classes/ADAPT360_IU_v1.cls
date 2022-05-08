public class ADAPT360_IU_v1 {

    /* Creates a bean from the response
* @param: HTTP Response
* @return: ADAPT360_Resp_IB_v1 bean object
* */
    public static ADAPT360_Resp_IB_v1 mapResponseFields(HttpResponse responseP){

        ADAPT360_Resp_IB_v1 responseBean = new ADAPT360_Resp_IB_v1();

        // PJAIN: 20201030: Change starts
        // Replaced responseBean.deserialize with responseBean.substituteFieldNames AND JSON.deserialize
        // List<ADAPT360_Resp_IB_v1.ClientDetails> responseBeanList = (List<ADAPT360_Resp_IB_v1.ClientDetails>)responseBean.deserialize(responseP.getBody(), List<ADAPT360_Resp_IB_v1.ClientDetails>.class);
        String jsonString = responseP.getBody();

        if (String.isBlank(jsonString)) {
            return mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, 'ADAPT360_IU_v1.mapResponseFields: Response body is null');
        }

        jsonString = responseBean.substituteFieldNames(jsonString, StringConstants.INBOUND_RECORD_TYPE);
        List<ADAPT360_Resp_IB_v1.ClientDetails> responseBeanList = (List<ADAPT360_Resp_IB_v1.ClientDetails>)JSON.deserialize(jsonString, List<ADAPT360_Resp_IB_v1.ClientDetails>.class);

        if (responseBeanList == null) {
            return mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, 'ADAPT360_IU_v1.mapResponseFields: The following response body cannot be deserialized. jsonString: ' + jsonString);
        }
        // PJAIN: 20201030: Change ends

        if(responseBeanList.size() > 0){
            if(responseBeanList[0].individual == null){
                responseBean.status = StringConstants.STATUS_CODE_500;
                responseBean.statusCode = 500;
                responseBean.message = 'Unable to find client by CIF Code';
            }else{
                responseBean.status = responseP.getStatus();
                responseBean.statusCode = responseP.getStatusCode();
                responseBean.message = '';
            }
            responseBean.ClientDetails = responseBeanList;
        }
        System.debug('ADAPT360 Response bean: ' + responseBean);
        return responseBean;
    }
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: ADAPT360_Resp_IB_v1 bean object
* */
    public static ADAPT360_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){

        ADAPT360_Resp_IB_v1 responseBean = new ADAPT360_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('ADAPT360 Failed Response bean: ' + responseBean);
        return responseBean;
    }

    public static ADAPT360GetJointParticipant_Resp_IB_v1 combinedBeanFields(ADAPT360_Resp_IB_v1 adaptd360BeanP,GetJointParticipant_Resp_IB_v1 jointParticipantBeanP){

        ADAPT360GetJointParticipant_Resp_IB_v1 responseBean;

        String jntPartJsonString = jointParticipantBeanP.serialize(jointParticipantBeanP);
        ADAPT360GetJointParticipant_Resp_IB_v1.cls_ClientDetails clientDetailsObj = (ADAPT360GetJointParticipant_Resp_IB_v1.cls_ClientDetails)jointParticipantBeanP.deserialize(jntPartJsonString, ADAPT360GetJointParticipant_Resp_IB_v1.cls_ClientDetails.class);
        List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_ClientDetails> clientDetailsList = new List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_ClientDetails>();

        if(adaptd360BeanP.clientDetails != null && adaptd360BeanP.clientDetails.size() > 0){

            for(ADAPT360_Resp_IB_v1.ClientDetails clientDetails360 : adaptd360BeanP.clientDetails){
                //ACCOUNT
                List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_AccountInfo> accountList = new List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_AccountInfo>();

                if(clientDetails360.account != null && clientDetails360.account.size() > 0){
                    for(ADAPT360_Resp_IB_v1.AccountInfo account : clientDetails360.account){

                        ADAPT360GetJointParticipant_Resp_IB_v1.cls_AccountInfo accountObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_AccountInfo();
                        accountObj.accountNumber = account.accountNumber != null ? account.accountNumber.value : null;
                        accountObj.product = account.product != null ? account.product.value : null;
                        accountObj.productType = account.productType != null ? account.productType.value : null;
                        accountObj.availableBalance = account.availableBalance != null ? account.availableBalance.value : null;
                        accountObj.availableBalanceSpecified = account.availableBalanceSpecified != null ? account.availableBalanceSpecified.value : null;
                        accountObj.availableBalanceFormatted = account.availableBalanceFormatted;
                        accountObj.balance = account.balance != null ? account.balance.value : null;
                        accountObj.balanceFormatted = account.balanceFormatted;
                        accountObj.balanceSpecified = account.balanceSpecified != null ? account.balanceSpecified.value : null;
                        accountObj.balanceTxt = account.balanceTxt != null ? account.balanceTxt.value : null;
                        accountObj.branch = account.branch != null ? account.branch.value : null;
                        accountObj.corporationCode = account.corporationCode != null ? account.corporationCode.value : null;
                        accountObj.dateClosed = account.dateClosed != null ? account.dateClosed.value : null;
                        accountObj.detail = account.detail != null ? account.detail.value : null;
                        accountObj.limits = account.limits != null ? account.limits.value : null;
                        accountObj.limitSpecified = account.limitSpecified != null ? account.limitSpecified.value : null;
                        accountObj.accountStatus = account.accountStatus != null ? account.accountStatus.value : null;
                        accountObj.ref = account.entity != null ? account.entity.ref : null;
                        accountList.add(accountObj);
                    }
                }

                //INDIVIDUAL
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_IndividualInfo individualObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_IndividualInfo();

                if(clientDetails360.individual != null){

                    individualObj.givenName = clientDetails360.individual.givenName != null ? clientDetails360.individual.givenName.value : null;
                    individualObj.nameInitials = clientDetails360.individual.nameInitials != null ? clientDetails360.individual.nameInitials.value : null;
                    individualObj.surname = clientDetails360.individual.surname != null ? clientDetails360.individual.surname.value : null;
                    individualObj.salutationType = clientDetails360.individual.salutationType != null ? clientDetails360.individual.salutationType.code.value : null;
                    individualObj.countryPassport = clientDetails360.individual.countryPassport != null ? clientDetails360.individual.countryPassport.code.value : null;
                    individualObj.countryOfBirth = clientDetails360.individual.countryOfBirth != null ? clientDetails360.individual.countryOfBirth.code.value : null;
                    individualObj.gender = clientDetails360.individual.gender != null ? clientDetails360.individual.gender.code.value : null;
                    individualObj.nationality = clientDetails360.individual.nationality != null ? clientDetails360.individual.nationality.code.value : null;
                    individualObj.employmentStatusType = clientDetails360.individual.employmentStatusType != null ? clientDetails360.individual.employmentStatusType.code.value : null;
                    individualObj.birthDate = clientDetails360.individual.birthDate != null ? clientDetails360.individual.birthDate.value : null;
                    individualObj.countryOfOrigin = clientDetails360.individual.countryOfOrigin != null ? clientDetails360.individual.countryOfOrigin.code.value : null;
                    individualObj.countryOfResidence = clientDetails360.individual.countryOfResidence != null ? clientDetails360.individual.countryOfResidence.code.value : null;

                    //DocumentDetailsInfo
                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_DocumentDetailsInfo documentDetailsInfoObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_DocumentDetailsInfo();
                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_DocumentInfo documentIdDocObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_DocumentInfo();
                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_DocumentInfo documentAddDocObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_DocumentInfo();

                    if(clientDetails360.individual.documentDetails != null){
                        if(clientDetails360.individual.documentDetails.idDoc != null){
                            documentIdDocObj.casaTier = clientDetails360.individual.documentDetails.idDoc.casaTier != null ? clientDetails360.individual.documentDetails.idDoc.casaTier.value : null;
                            documentIdDocObj.documentType = clientDetails360.individual.documentDetails.idDoc.documentType != null ? clientDetails360.individual.documentDetails.idDoc.documentType.code.value : null;
                            documentIdDocObj.documentStatusReason = clientDetails360.individual.documentDetails.idDoc.documentStatusReason != null ? clientDetails360.individual.documentDetails.idDoc.documentStatusReason.code.value : null;
                            documentIdDocObj.casaSequence = clientDetails360.individual.documentDetails.idDoc.casaSequence != null ? clientDetails360.individual.documentDetails.idDoc.casaSequence.value : null;
                            documentIdDocObj.imageId = clientDetails360.individual.documentDetails.idDoc.imageId != null ? clientDetails360.individual.documentDetails.idDoc.imageId.value : null;
                            documentIdDocObj.casaReference = clientDetails360.individual.documentDetails.idDoc.casaReference != null ? clientDetails360.individual.documentDetails.idDoc.casaReference.value : null;
                            documentIdDocObj.documentRecieved = clientDetails360.individual.documentDetails.idDoc.documentRecieved != null ? clientDetails360.individual.documentDetails.idDoc.documentRecieved.value : null;
                            documentIdDocObj.documentInOrder = clientDetails360.individual.documentDetails.idDoc.documentInOrder != null ? clientDetails360.individual.documentDetails.idDoc.documentInOrder.value : null;
                            documentIdDocObj.qualityAssurance = clientDetails360.individual.documentDetails.idDoc.qualityAssurance != null ? clientDetails360.individual.documentDetails.idDoc.qualityAssurance.value : null;
                            documentIdDocObj.allCorrectRecieved = clientDetails360.individual.documentDetails.idDoc.allCorrectRecieved != null ? clientDetails360.individual.documentDetails.idDoc.allCorrectRecieved.value : null;
                            documentIdDocObj.allCorrectInOrder = clientDetails360.individual.documentDetails.idDoc.allCorrectInOrder != null ? clientDetails360.individual.documentDetails.idDoc.allCorrectInOrder.value : null;
                            documentDetailsInfoObj.idDoc = documentIdDocObj;
                        }
                        if(clientDetails360.individual.documentDetails.addDoc != null){
                            documentAddDocObj.casaTier = clientDetails360.individual.documentDetails.addDoc.casaTier != null ? clientDetails360.individual.documentDetails.addDoc.casaTier.value : null;
                            documentAddDocObj.documentType = clientDetails360.individual.documentDetails.addDoc.documentType != null ? clientDetails360.individual.documentDetails.addDoc.documentType.code.value : null;
                            documentAddDocObj.documentStatusReason = clientDetails360.individual.documentDetails.addDoc.documentStatusReason != null ? clientDetails360.individual.documentDetails.addDoc.documentStatusReason.code.value : null;
                            documentAddDocObj.casaSequence = clientDetails360.individual.documentDetails.addDoc.casaSequence != null ? clientDetails360.individual.documentDetails.addDoc.casaSequence.value : null;
                            documentAddDocObj.imageId = clientDetails360.individual.documentDetails.addDoc.imageId != null ? clientDetails360.individual.documentDetails.addDoc.imageId.value : null;
                            documentAddDocObj.casaReference = clientDetails360.individual.documentDetails.addDoc.casaReference != null ? clientDetails360.individual.documentDetails.addDoc.casaReference.value : null;
                            documentAddDocObj.documentRecieved = clientDetails360.individual.documentDetails.addDoc.documentRecieved != null ? clientDetails360.individual.documentDetails.addDoc.documentRecieved.value : null;
                            documentAddDocObj.documentInOrder = clientDetails360.individual.documentDetails.addDoc.documentInOrder != null ? clientDetails360.individual.documentDetails.addDoc.documentInOrder.value : null;
                            documentAddDocObj.qualityAssurance = clientDetails360.individual.documentDetails.addDoc.qualityAssurance != null ? clientDetails360.individual.documentDetails.addDoc.qualityAssurance.value : null;
                            documentAddDocObj.allCorrectRecieved = clientDetails360.individual.documentDetails.addDoc.allCorrectRecieved != null ? clientDetails360.individual.documentDetails.addDoc.allCorrectRecieved.value : null;
                            documentAddDocObj.allCorrectInOrder = clientDetails360.individual.documentDetails.addDoc.allCorrectInOrder != null ? clientDetails360.individual.documentDetails.addDoc.allCorrectInOrder.value : null;
                            documentDetailsInfoObj.addDoc = documentAddDocObj;
                        }
                        individualObj.documentDetails = documentDetailsInfoObj;
                    }
                }

                //CUSTOMER DETAILS
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_CustomerDetailsInfo customerDetailsObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_CustomerDetailsInfo();
                customerDetailsObj.identificationTypeId = clientDetails360.customerDetails.identificationTypeId != null ? clientDetails360.customerDetails.identificationTypeId.code.value : null;
                customerDetailsObj.individualId = clientDetails360.customerDetails.individualId != null ? clientDetails360.customerDetails.individualId.value : null;
                customerDetailsObj.universalResourceLocator = clientDetails360.customerDetails.universalResourceLocator != null ? clientDetails360.customerDetails.universalResourceLocator.value : null;
                customerDetailsObj.customerType = clientDetails360.customerDetails.customerType != null ? clientDetails360.customerDetails.customerType.code.value : null;
                customerDetailsObj.groupScheme = clientDetails360.customerDetails.groupScheme != null ? clientDetails360.customerDetails.groupScheme.code.value : null;
                customerDetailsObj.sourceOfFundsCode = clientDetails360.customerDetails.sourceOfFundsCode != null ? clientDetails360.customerDetails.sourceOfFundsCode.code.value : null;
                customerDetailsObj.sourceOfIncomeCode = clientDetails360.customerDetails.sourceOfIncomeCode != null ? clientDetails360.customerDetails.sourceOfIncomeCode.code.value : null;
                customerDetailsObj.corporateDivision = clientDetails360.customerDetails.corporateDivision != null ? clientDetails360.customerDetails.corporateDivision.code.value : null;
                customerDetailsObj.inLiquidation = clientDetails360.customerDetails.inLiquidation != null ? clientDetails360.customerDetails.inLiquidation.value : null;
                customerDetailsObj.underJudicialManagement = clientDetails360.customerDetails.underJudicialManagement != null ? clientDetails360.customerDetails.underJudicialManagement.value : null;
                customerDetailsObj.financialCrime = clientDetails360.customerDetails.financialCrime != null ? clientDetails360.customerDetails.financialCrime.value : null;
                customerDetailsObj.NCAThreshold = clientDetails360.customerDetails.NCAThreshold != null ? clientDetails360.customerDetails.NCAThreshold.value : null;
                customerDetailsObj.CPAThreshold = clientDetails360.customerDetails.CPAThreshold != null ? clientDetails360.customerDetails.CPAThreshold.value : null;
                customerDetailsObj.sbuSegment = clientDetails360.customerDetails.sbuSegment != null ? clientDetails360.customerDetails.sbuSegment.code.value : null;
                customerDetailsObj.inBusinessRescue = clientDetails360.customerDetails.inBusinessRescue != null ? clientDetails360.customerDetails.inBusinessRescue.value : null;
                customerDetailsObj.inBusinessRescueAffectedParty = clientDetails360.customerDetails.inBusinessRescueAffectedParty != null ? clientDetails360.customerDetails.inBusinessRescueAffectedParty.value : null;
                customerDetailsObj.placedInBusinessRescueBy = clientDetails360.customerDetails.placedInBusinessRescueBy != null ? clientDetails360.customerDetails.placedInBusinessRescueBy.value : null;
                customerDetailsObj.forensicHold = clientDetails360.customerDetails.forensicHold != null ? clientDetails360.customerDetails.forensicHold.value : null;
                customerDetailsObj.casaReference = clientDetails360.customerDetails.casaReference != null ? clientDetails360.customerDetails.casaReference.value : null;
                customerDetailsObj.businessRescueIssueDate = clientDetails360.customerDetails.businessRescueIssueDate != null ? clientDetails360.customerDetails.businessRescueIssueDate.value : null;

                //LOCATION
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_LocationInfo locationObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_LocationInfo();

                if(clientDetails360.location != null){

                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address physicalAddressObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address();
                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address postalAddressObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address();
                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address businessAddressObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address();
                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address headOfficeAddressObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_Address();

                    if(clientDetails360.location.physicalAddress != null){

                        physicalAddressObj.addressName1 = clientDetails360.location.physicalAddress.addressName1 != null ? clientDetails360.location.physicalAddress.addressName1.value : null;
                        physicalAddressObj.addressName2 = clientDetails360.location.physicalAddress.addressName2 != null ? clientDetails360.location.physicalAddress.addressName2.value : null;
                        physicalAddressObj.suburbName = clientDetails360.location.physicalAddress.suburbName != null ? clientDetails360.location.physicalAddress.suburbName.value : null;
                        physicalAddressObj.cityName = clientDetails360.location.physicalAddress.cityName != null ? clientDetails360.location.physicalAddress.cityName.value : null;
                        physicalAddressObj.postCodeArea = clientDetails360.location.physicalAddress.postCodeArea != null ? clientDetails360.location.physicalAddress.postCodeArea.value : null;
                        physicalAddressObj.addressTypeCode = clientDetails360.location.physicalAddress.addressTypeCode != null ? clientDetails360.location.physicalAddress.addressTypeCode.value : null;
                        physicalAddressObj.addressType = clientDetails360.location.physicalAddress.addressType != null ? clientDetails360.location.physicalAddress.addressType.value : null;
                    }

                    if(clientDetails360.location.postalAddress != null){

                        postalAddressObj.addressName1 = clientDetails360.location.postalAddress.addressName1 != null ? clientDetails360.location.postalAddress.addressName1.value : null;
                        postalAddressObj.addressName2 = clientDetails360.location.postalAddress.addressName2 != null ? clientDetails360.location.postalAddress.addressName2.value : null;
                        postalAddressObj.suburbName = clientDetails360.location.postalAddress.suburbName != null ? clientDetails360.location.postalAddress.suburbName.value : null;
                        postalAddressObj.cityName = clientDetails360.location.postalAddress.cityName != null ? clientDetails360.location.postalAddress.cityName.value : null;
                        postalAddressObj.postCodeArea = clientDetails360.location.postalAddress.postCodeArea != null ? clientDetails360.location.postalAddress.postCodeArea.value : null;
                        postalAddressObj.addressTypeCode = clientDetails360.location.postalAddress.addressTypeCode != null ? clientDetails360.location.postalAddress.addressTypeCode.value : null;
                        postalAddressObj.addressType = clientDetails360.location.postalAddress.addressType != null ? clientDetails360.location.postalAddress.addressType.value : null;
                    }

                    if(clientDetails360.location.businessAddress != null){

                        businessAddressObj.addressName1 = clientDetails360.location.businessAddress.addressName1 != null ? clientDetails360.location.businessAddress.addressName1.value : null;
                        businessAddressObj.addressName2 = clientDetails360.location.businessAddress.addressName2 != null ? clientDetails360.location.businessAddress.addressName2.value : null;
                        businessAddressObj.suburbName = clientDetails360.location.businessAddress.suburbName != null ? clientDetails360.location.businessAddress.suburbName.value : null;
                        businessAddressObj.cityName = clientDetails360.location.businessAddress.cityName != null ? clientDetails360.location.businessAddress.cityName.value : null;
                        businessAddressObj.postCodeArea = clientDetails360.location.businessAddress.postCodeArea != null ? clientDetails360.location.businessAddress.postCodeArea.value : null;
                        businessAddressObj.addressTypeCode = clientDetails360.location.businessAddress.addressTypeCode != null ? clientDetails360.location.businessAddress.addressTypeCode.value : null;
                        businessAddressObj.addressType = clientDetails360.location.businessAddress.addressType != null ? clientDetails360.location.businessAddress.addressType.value : null;
                    }

                    if(clientDetails360.location.headOfficeAddress != null){

                        headOfficeAddressObj.addressName1 = clientDetails360.location.headOfficeAddress.addressName1 != null ? clientDetails360.location.headOfficeAddress.addressName1.value : null;
                        headOfficeAddressObj.addressName2 = clientDetails360.location.headOfficeAddress.addressName2 != null ? clientDetails360.location.headOfficeAddress.addressName2.value : null;
                        headOfficeAddressObj.suburbName = clientDetails360.location.headOfficeAddress.suburbName != null ? clientDetails360.location.headOfficeAddress.suburbName.value : null;
                        headOfficeAddressObj.cityName = clientDetails360.location.headOfficeAddress.cityName != null ? clientDetails360.location.headOfficeAddress.cityName.value : null;
                        headOfficeAddressObj.postCodeArea = clientDetails360.location.headOfficeAddress.postCodeArea != null ? clientDetails360.location.headOfficeAddress.postCodeArea.value : null;
                        headOfficeAddressObj.addressTypeCode = clientDetails360.location.headOfficeAddress.addressTypeCode != null ? clientDetails360.location.headOfficeAddress.addressTypeCode.value : null;
                        headOfficeAddressObj.addressType = clientDetails360.location.headOfficeAddress.addressType != null ? clientDetails360.location.headOfficeAddress.addressType.value : null;
                    }

                    locationObj.physicalAddress = physicalAddressObj;
                    locationObj.postalAddress = postalAddressObj;
                    locationObj.businessAddress = businessAddressObj;
                    locationObj.headOfficeAddress = headOfficeAddressObj;
                }

                //CONTACT
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_ContactInfo contactObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_ContactInfo();
                if(clientDetails360.contact != null){

                    contactObj.cellPhoneNumber = clientDetails360.contact.cellPhoneNumber != null ? clientDetails360.contact.cellPhoneNumber.value : null;
                    contactObj.communicationChannelType = clientDetails360.contact.communicationChannelType != null ? clientDetails360.contact.communicationChannelType.code.value : null;
                    contactObj.workPhone = clientDetails360.contact.workPhone != null ? clientDetails360.contact.workPhone.value : null;
                    contactObj.homePhone = clientDetails360.contact.homePhone != null ? clientDetails360.contact.homePhone.value : null;
                    contactObj.telephoneNumber = clientDetails360.contact.telephoneNumber != null ? clientDetails360.contact.telephoneNumber.value : null;
                    contactObj.eMailUserId = clientDetails360.contact.eMailUserId != null ? clientDetails360.contact.eMailUserId.value : null;
                    contactObj.contactPerson = clientDetails360.contact.contactPerson != null ? clientDetails360.contact.contactPerson.value : null;
                    contactObj.designation = clientDetails360.contact.designation != null ? clientDetails360.contact.designation.value : null;

                }
                //CORPORATE ENTITY
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_CorporateEntityInfo corporateEntityInfoObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_CorporateEntityInfo();
                if(clientDetails360.corporateEntity != null){

                    corporateEntityInfoObj.incorporatedCountry = clientDetails360.corporateEntity.incorporatedCountry != null ? clientDetails360.corporateEntity.incorporatedCountry.code.value : null;
                    corporateEntityInfoObj.standardIndustryCode = clientDetails360.corporateEntity.standardIndustryCode != null ? clientDetails360.corporateEntity.standardIndustryCode.code.value : null;
                }

                //CUSTOMER
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_CustomerInfo customerInfoObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_CustomerInfo();
                if(clientDetails360.customer != null){
                    if(clientDetails360.customer.Details != null){

                        customerInfoObj.Details.CPAThreshold = clientDetails360.customer.Details.CPAThreshold != null ? clientDetails360.customer.Details.CPAThreshold.value : null;
                    }
                }

                //META
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_MetaInfo metaObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_MetaInfo();

                if(clientDetails360.meta != null){
                    ADAPT360GetJointParticipant_Resp_IB_v1.cls_QueryResultInfo queryResultObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_QueryResultInfo();

                    if(clientDetails360.meta.queryResult != null){

                        queryResultObj.sourceSystem = clientDetails360.meta.queryResult.sourceSystem;
                        queryResultObj.queryResultInfoType = clientDetails360.meta.queryResult.queryResultInfoType;
                    }
                    metaObj.queryResult = queryResultObj;
                }

                //IDENTIFICATIONS
                List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_IdentificationsInfo> identificationInfoList = new List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_IdentificationsInfo>();
                if(clientDetails360.identifications != null && clientDetails360.identifications.size () > 0){
                    for(ADAPT360_Resp_IB_v1.IdentificationsInfo identification : clientDetails360.identifications){

                        ADAPT360GetJointParticipant_Resp_IB_v1.cls_IdentificationsInfo identificationsObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_IdentificationsInfo();
                        identificationsObj.identificationType = identification.identificationType != null ? identification.identificationType.code : null;
                        identificationsObj.numbers = identification.numbers;
                        identificationsObj.personalIdentificationFlag = identification.personalIdentificationFlag;
                        identificationsObj.systemIdentificationFlag = identification.systemIdentificationFlag;
                        identificationsObj.issueDate = identification.issueDate;
                        identificationsObj.expiryDate = identification.expiryDate;
                        identificationsObj.country = identification.country;
                        identificationInfoList.add(identificationsObj);
                    }
                }

                //FLAGS
                ADAPT360GetJointParticipant_Resp_IB_v1.cls_FlagInfo flagObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_FlagInfo();
                if(clientDetails360.flags != null){

                    flagObj.compliant = clientDetails360.flags.compliant != null ? clientDetails360.flags.compliant.value : null;
                    flagObj.reason = clientDetails360.flags.reason != null ? clientDetails360.flags.reason.code.value : null;
                }

                //AUTHORITY INFO
                List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_AuthorityInfo> authorityInfoList = new List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_AuthorityInfo>();

                if(clientDetails360.authority != null && clientDetails360.authority.size () > 0){
                    for(ADAPT360_Resp_IB_v1.AuthorityInfo authority : clientDetails360.authority){

                        List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_SignatoryDetailsInfo> signatoryDetailsList = new List<ADAPT360GetJointParticipant_Resp_IB_v1.cls_SignatoryDetailsInfo>();

                        if(authority.signatoryDetails != null && authority.signatoryDetails.size () > 0){
                            for(ADAPT360_Resp_IB_v1.SignatoryDetailsInfo signatoryDetails : authority.signatoryDetails){

                                ADAPT360GetJointParticipant_Resp_IB_v1.cls_SignatoryDetailsInfo signatoryDetailsObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_SignatoryDetailsInfo();
                                if(signatoryDetails.product != null){
                                    signatoryDetailsObj.accountNumber = signatoryDetails.product.accountNumber != null ? signatoryDetails.product.accountNumber.value : null;
                                }
                                signatoryDetailsObj.dateIssued = signatoryDetails.dateIssued != null ? signatoryDetails.dateIssued.value : null;
                                signatoryDetailsObj.expiryDate = signatoryDetails.expiryDate != null ? signatoryDetails.expiryDate.value : null;
                                signatoryDetailsObj.maximumAmount = signatoryDetails.maximumAmount != null ? signatoryDetails.maximumAmount.value : null;
                                signatoryDetailsObj.maximumAmountFormatted = signatoryDetails.maximumAmountFormatted;
                                signatoryDetailsObj.ref = signatoryDetails.entity != null ? signatoryDetails.entity.ref : null;
                                signatoryDetailsList.add(signatoryDetailsObj);
                            }
                        }

                        ADAPT360GetJointParticipant_Resp_IB_v1.cls_AuthorityInfo authorityInfoObj = new ADAPT360GetJointParticipant_Resp_IB_v1.cls_AuthorityInfo();
                        authorityInfoObj.authorityTypeCode = authority.authorityTypeCode != null ? authority.authorityTypeCode.value : null;
                        authorityInfoObj.customerCode = authority.customerCode != null ? authority.customerCode.value : null;
                        authorityInfoObj.accountNumber = authority.accountNumber != null ? authority.accountNumber.value : null;
                        authorityInfoObj.changeTrackingNumber = authority.changeTrackingNumber != null ? authority.changeTrackingNumber.value : null;
                        authorityInfoObj.courtAuthorityCode = authority.courtAuthorityCode != null ? authority.courtAuthorityCode.value : null;
                        authorityInfoObj.numberOfSignatures = authority.numberOfSignatures != null ? authority.numberOfSignatures.value : null;
                        authorityInfoObj.employeeNumber = authority.employeeNumber != null ? authority.employeeNumber.value : null;
                        authorityInfoObj.originalCourtAuthorityCode = authority.originalCourtAuthorityCode != null ? authority.originalCourtAuthorityCode.value : null;
                        authorityInfoObj.originalNumberOfSignatures = authority.originalNumberOfSignatures != null ? authority.originalNumberOfSignatures.value : null;
                        authorityInfoObj.originalSpecialConditions = authority.originalSpecialConditions != null ? authority.originalSpecialConditions.value : null;
                        authorityInfoObj.overrideEmployeeNumber = authority.overrideEmployeeNumber != null ? authority.overrideEmployeeNumber.value : null;
                        authorityInfoObj.specialConditions = authority.specialConditions != null ? authority.specialConditions.value : null;
                        authorityInfoObj.status = authority.status != null ? authority.status.value : null;
                        authorityInfoObj.changedSignatory = authority.changedSignatory != null ? authority.changedSignatory.value : null;
                        authorityInfoObj.authorityType = authority.authorityType != null ? authority.authorityType.value : null;
                        authorityInfoObj.signatoryDetails = signatoryDetailsList;
                        authorityInfoList.add(authorityInfoObj);
                    }
                }

                clientDetailsObj.clientDetailsId = clientDetails360.clientDetailsId;
                clientDetailsObj.links = clientDetails360.links;
                clientDetailsObj.account = accountList;
                clientDetailsObj.individual = individualObj;
                clientDetailsObj.customerDetails = customerDetailsObj;
                clientDetailsObj.location = locationObj;
                clientDetailsObj.contact = contactObj;
                clientDetailsObj.corporateEntity = corporateEntityInfoObj;
                clientDetailsObj.meta = metaObj;
                clientDetailsObj.identifications = identificationInfoList;
                clientDetailsObj.customer = customerInfoObj;
                clientDetailsObj.authority = authorityInfoList;
                clientDetailsList.add(clientDetailsObj);
            }
            responseBean = new ADAPT360GetJointParticipant_Resp_IB_v1();
            responseBean.clientDetails = clientDetailsList;
        }
        System.debug('Combined Bean: ' + responseBean);
        return responseBean;
    }

    public static ADAPT360GetJointParticipant_Resp_IB_v1 mapFailedResponseFieldsCombinedBean(Integer statusCodeP, String statusP, String messageP){

        ADAPT360GetJointParticipant_Resp_IB_v1 responseBean = new ADAPT360GetJointParticipant_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('ADAPT360GetJointParticipant Failed Response bean: ' + responseBean);
        return responseBean;
    }
}