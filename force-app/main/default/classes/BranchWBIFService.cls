/**
* @description BranchWBIFService Controller
*/
public class BranchWBIFService{
    /**
    * @description mapAddDependentRequestFields description
    *
    * @param policy_CreatePolicyResponseP (WBIF_IB_String_v1): policy_CreatePolicyResponseP
    * @param newMember (BranchMemberDetail): newMember
    * @param benefitId (String): benefitId
    * @return Return WBIF_IB_String_v1: Return description
    */
    public static WBIF_IB_String_v1.cls_policy mapAddDependentRequestFields(WBIF_IB_String_v1.cls_policy policy_CreatePolicyResponseP, BranchMemberDetail newMember, string benefitId){
        
        WBIF_IB_String_v1.cls_Policy_AddDependent addDependent = new WBIF_IB_String_v1.cls_Policy_AddDependent();
        
        addDependent.policy = policy_CreatePolicyResponseP;
        
        WBIF_IB_String_v1.cls_beneficiary_member member = new WBIF_IB_String_v1.cls_beneficiary_member();
        member.age = string.valueOf(Date.today().year()-newMember.DateOfBirth.year());
        
        String stringDateOfBirth = String.valueOf(newMember.DateofBirth);
        member.DateOfBirth = stringDateOfBirth.replace(' ', 'T');
        member.FirstName = newMember.Name;
        member.Gender = newMember.Gender;
        if (newMember.IDNumber == null || newMember.IDNumber == ''){
            String idNumber = stringDateOfBirth.replace('-', '').subString(2, 8)+'0000000';
            member.RsaIdNumber = idNumber;
        } else{
            member.RsaIdNumber = newMember.IDNumber;
        }
        
        String relationship = newMember.Relationship.toUpperCase();
        relationship = relationship.replace('-', '_');
        relationship = relationship.replace(' ', '_');

        member.Surname = newMember.Surname;
        member.Relationship = relationship;
        member.Title = 'Unknown';
        member.ShortName = newMember.Name;
        member.MemberType = 'Unknown';
        member.Initials = newMember.Name.substring(0, 1);
        addDependent.member = member;
        
        /************/
        
        WBIF_IB_String_v1 addDependentRequestBean = new WBIF_IB_String_v1();
        addDependentRequestBean.Policy_AddDependent = addDependent;
        
        WBIF_IB_String_v1 responseBean = (WBIF_IB_String_v1)Sys_Utilities_Integration.integrationServiceCall(addDependentRequestBean, null, StringConstants.WBIF_POLICY_ADD_DEPENDENT, WBIF_IB_String_v1.class);
       
        if(newMember.Relationship == 'Spouse'){
            WBIF_IB_String_v1.cls_policy dependentPoicy = getPolicy(responseBean);
            Boolean keyExisist = false;
            
            for(WBIF_IB_String_v1.cls_KeyValueOfstringstring  keyValue:   dependentPoicy.Flags.KeyValueOfstringstring)
            {
                if(keyValue.Key == 'IncludeSpouse'){
                    keyValue.Value = 'True';
                    keyExisist = true;
                }
            }
            if(!keyExisist){
                WBIF_IB_String_v1.cls_KeyValueOfstringstring includeSpouse = new WBIF_IB_String_v1.cls_KeyValueOfstringstring();
                includeSpouse.Key = 'IncludeSpouse';
                includeSpouse.Value = 'True';
                dependentPoicy.Flags.KeyValueOfstringstring.add(includeSpouse);
            }
            WBIF_IB_String_v1.cls_Policy_AddBenefit benefit = new WBIF_IB_String_v1.cls_Policy_AddBenefit();
            benefit.benefitid = benefitId;
            benefit.memberid = dependentPoicy.Spouse.GUID;
            benefit.policy = dependentPoicy;
            
            WBIF_IB_String_v1 addBenefitRequest = new WBIF_IB_String_v1();
            addBenefitRequest.Policy_AddBenefit = benefit;
            
            responseBean = (WBIF_IB_String_v1)Sys_Utilities_Integration.integrationServiceCall(addBenefitRequest, null, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, WBIF_IB_String_v1.class);
        }
        
        return getPolicy(responseBean);
    }
    
    /**
     * @description WBIF_IB_String_v1.cls_policy Description
     *
     * @param wbifPolicyCreateSessionP (WBIF_IB_String_v1): policy_CreatePolicyResponseP
     * @param details (BranchMemberDetail): newMember
     * @param produtCode (String): produtCode
     * @param benefitId (String): benefitId
     * @param contractId (String): contractId
     * @return Return WBIF_IB_String_v1: Return description
     */
    private static WBIF_IB_String_v1 addMainMemberAndDependantsForCalculation(WBIF_IB_String_v1.cls_policy wbifPolicyCreateSessionP, BranchMemberDetail details, String produtCode, string benefitId, string contractId){
        
        WBIF_IB_String_v1.cls_Calculate calculatePolicy = new WBIF_IB_String_v1.cls_Calculate();
        calculatePolicy.policy = wbifPolicyCreateSessionP;
        
        // Poulami added for Ultimate Protector Underwriting Items:
        //List<WBIF_IB_String_v1.cls_UnderwritingItems> underwritingMainMemberList = new List<WBIF_IB_String_v1.cls_UnderwritingItems>();
        
        if(wbifPolicyCreateSessionP.Flags != null){
            for(WBIF_IB_String_v1.cls_KeyValueOfstringstring  keyValue:   wbifPolicyCreateSessionP.Flags.KeyValueOfstringstring)
            {
                if((keyValue.Key == 'ReplacementSumAssured' || keyValue.Key == 'ReplacementPolicyInforceMonths') && keyValue.Value == null){
                    keyValue.Value = '0';
                }

                if(keyValue.Key == 'IncludeParent' && details.MemberType == 'Parent'){
                    keyValue.Value = 'True';
                }

                if(keyValue.Key == 'IncludeSpouse' && details.MemberType == 'Spouse'){
                    keyValue.Value = 'True';
                }

                if(keyValue.Key == 'IncludeChildren' && details.MemberType == 'Child'){
                    keyValue.Value = 'True';
                }

                
                if(keyValue.Key == 'IncludeEFM' && details.MemberType == 'Extended Family Member'){
                    keyValue.Value = 'True';
                }

            }
        }
        
        if (details.MemberType == 'Spouse'){
            //Spouse tag
            calculatePolicy.policy.spouse.Benefits.Benefit[0].Cover = string.valueOf(details.CoverOption);
            
        } 
        else if (details.MemberType == 'Main Member'){  
            calculatePolicy.policy.MainMember.Benefits.Benefit[0].Cover = string.valueOf(details.CoverOption);
            calculatePolicy.policy.MainMember.Cover = string.valueOf(details.CoverOption);
            calculatePolicy.policy.PolicyInfo.ContractOptionID = contractId;
        } 
        else{
            
            if (calculatePolicy.policy.Dependents != null){
                if (calculatePolicy.policy.Dependents.Dependent != null){
                    for (WBIF_IB_String_v1.cls_Dependent dependent : calculatePolicy.policy.Dependents.Dependent){
                        
                        if ((dependent.GUID == details.PartyId) 
                            || (dependent.FirstName == details.Name && dependent.Surname == details.Surname)){
                                dependent.Benefits.Benefit[0].Cover = string.valueOf(details.CoverOption);
                                dependent.Benefit.Cover = string.valueOf(details.CoverOption);
                                dependent.Cover = string.valueOf(details.CoverOption);
                                break;
                            }
                    }
                }
            }
            
            if (calculatePolicy.policy.Children != null){
                if (calculatePolicy.policy.Children.Dependent != null){
                    for (WBIF_IB_String_v1.cls_Dependent dependent : calculatePolicy.policy.Children.Dependent){
                        
                        if ((dependent.GUID == details.PartyId) 
                            || (dependent.FirstName == details.Name && dependent.Surname == details.Surname)){
                                dependent.Benefits.Benefit[0].Cover = string.valueOf(details.CoverOption);
                                dependent.Benefit.Cover = string.valueOf(details.CoverOption);

                                dependent.Cover = string.valueOf(details.CoverOption);
                                break;
                            }
                    }
                }
            }
        }
        
        calculatePolicy.policy.ModuleID = produtCode;
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.Calculate = calculatePolicy;
        
        return requestBean;
    }
    
    //New Method - Only Implemeting WBIF Policy Calcualte
    /**
     * @description wbifPolicyCalculate WBIF_IB_String_v1 Description
     *
     * @param policyCreateSessionP (WBIF_IB_String_v1.cls_policy ): policyCreateSessionP
     * @param details (BranchMemberDetail): details
     * @param produtCode (BranchMemberDetail): produtCode
     * @param benefitId (String): benefitId
     * @param contractId (String): contractId
     * @return Return WBIF_IB_String_v1: Return description
     */
    public static WBIF_IB_String_v1 wbifPolicyCalculate(WBIF_IB_String_v1.cls_policy policyCreateSessionP, BranchMemberDetail details, String produtCode, string benefitId, string contractId){
        //Map Request Fields
        WBIF_IB_String_v1 policyCalculateRequestBean = addMainMemberAndDependantsForCalculation(policyCreateSessionP, details, produtCode, benefitId, contractId);
        
        WBIF_IB_String_v1 responseBean = (WBIF_IB_String_v1)Sys_Utilities_Integration.integrationServiceCall(policyCalculateRequestBean, null, StringConstants.WBIF_CALCULATE_V2, WBIF_IB_String_v1.class);
        
        return responseBean;
    }
    
    /**
    * @description getPolicy description
    *
    * @param beanP (WBIF_IB_String_v1): beanP
    * @return  Return WBIF_IB_String_v1.cls_policy: Return description
    */
    public static WBIF_IB_String_v1.cls_policy getPolicy(WBIF_IB_String_v1 beanP){
        
        WBIF_IB_String_v1.cls_policy policy = new WBIF_IB_String_v1.cls_policy();

        if (beanP.Policy_CreateResponse != null){
            policy = beanP.Policy_CreateResponse.Policy_CreateResult;
            
        } else if (beanP.Policy_AddBenefitResponse != null){
            policy = beanP.Policy_AddBenefitResponse.Policy_AddBenefitResult;
            
        } else if (beanP.CalculateResponse != null){
            policy = beanP.CalculateResponse.CalculateResult;
            
        } else if (beanP.Policy_AddBeneficiaryResponse != null){
            policy = beanP.Policy_AddBeneficiaryResponse.Policy_AddBeneficiaryResult;
            
        } else if (beanP.Policy_AddDependentResponse != null){
            policy = beanP.Policy_AddDependentResponse.Policy_AddDependentResult;
            
        } else if (beanP.ValidatePolicyResponse != null){
            policy = beanP.ValidatePolicyResponse.ValidatePolicyResult;
            
        } else if (beanP.SubmitPolicyResponse != null){
            policy = beanP.SubmitPolicyResponse.SubmitPolicyResult;
        }
        
        return policy;
    }
    
    /**
    * @description mapPolicyCreateRequestFields description
    *
    * @param userP (User): userP
    * @param accountP (Account): accountP
    * @param productCode (String): productCode
    * @param replacementPolicy (WBIF_Product_Details.ExistingPolicy): replacementPolicy
    * @param countryOfBirthTranslatedP (String): countryOfBirthTranslatedP
    * @param countryOfResidenceTranslatedP (String): countryOfResidenceTranslatedP
    * @param maritalStatusTranslatedP (String): maritalStatusTranslatedP
    * @param nationalityTranslatedP (String): nationalityTranslatedP
    * @param incomeSourceTranslatedP (String): incomeSourceTranslatedP
    * @param titleTranslatedP (String): titleTranslatedP
    * @return Return WBIF_IB_String_v1: Return description
    **/
    private static WBIF_IB_String_v1 mapPolicyCreateRequestFields(User userP, Account accountP, String productCode, WBIF_Product_Details.ExistingPolicy replacementPolicy, String countryOfBirthTranslatedP, String countryOfResidenceTranslatedP, String maritalStatusTranslatedP, String nationalityTranslatedP, String incomeSourceTranslatedP, String titleTranslatedP){
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        
        /*** START APPINFO ***/
        WBIF_IB_String_v1.cls_Agent agent = new WBIF_IB_String_v1.cls_Agent();
        agent.DistributionChannel = 'BranchSales';
        
        WBIF_IB_String_v1.cls_Consultant consultant = new WBIF_IB_String_v1.cls_Consultant();
        consultant.ABNumber = userP.AB_Number__c;
        consultant.EmployeeNumber = userP.EmployeeNumber;
        consultant.Name = userP.Name;
        consultant.SiteCode = userP.SiteCode__c;
        consultant.IntermediaryCode = userP.Advisor_Code__c;
        
        WBIF_IB_String_v1.cls_Declaration declaration = new WBIF_IB_String_v1.cls_Declaration();
        declaration.IsFit = string.valueOf(userP.IsFit__c);
        declaration.IsSupervised = string.valueOf(userP.IsSupervised__c);
        
        WBIF_IB_String_v1.cls_Replacement replacement = new WBIF_IB_String_v1.cls_Replacement();
        String requestDate = string.valueOf(System.now());
        replacement.ReplacementDate = requestDate.replace(' ', 'T');
        replacement.IsReplacement = replacementPolicy.ReplacementPolicy ? 'true' : 'false';
        
        WBIF_IB_String_v1.cls_Application appinfo = new WBIF_IB_String_v1.cls_Application();
        appinfo.agent = agent;
        appinfo.consultant = consultant;
        appinfo.declaration = declaration;
        appinfo.DistributionChannel = 'BranchSales';
        appinfo.IsBranchSales = 'true';
        appinfo.IsClientPresent = 'true';
        appinfo.replacement = replacement;
        /*** END APPINFO ***/
        
        /*** START MEMBER ***/	
        Address__c residentialAddress = [
            SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
            FROM Address__c
            WHERE Account__c = :accountP.Id AND Address_TYpe__c = 'Residential'
            LIMIT 1
        ];
        
        WBIF_IB_String_v1.cls_address physicalAddress = new WBIF_IB_String_v1.cls_address();
        physicalAddress.Line1 = residentialAddress.Shipping_Street__c;
        physicalAddress.Line2 = residentialAddress.Shipping_Street_2__c;
        physicalAddress.Line3 = residentialAddress.Shipping_Suburb__c;
        physicalAddress.PostalCode = residentialAddress.Shipping_Zip_Postal_Code__c;
        
        Address__c postalAddressObj = [
            SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
            FROM Address__c
            WHERE Account__c = :accountP.Id AND Address_TYpe__c = 'Postal'
            LIMIT 1
        ];
        //Postal Address
        WBIF_IB_String_v1.cls_address postalAddress = new WBIF_IB_String_v1.cls_address();
        postalAddress.Line1 = postalAddressObj.Shipping_Street__c;
        postalAddress.Line2 = postalAddressObj.Shipping_Street_2__c;
        postalAddress.Line3 = postalAddressObj.Shipping_Suburb__c;
        postalAddress.PostalCode = postalAddressObj.Shipping_Zip_Postal_Code__c;
        
        WBIF_IB_String_v1.cls_ContactDetails contactDetails = new WBIF_IB_String_v1.cls_ContactDetails();
        contactDetails.CellTelephone = accountP.PersonMobilePhone;
        contactDetails.HomeTelephone = accountP.PersonHomePhone;
        contactDetails.WorkTelephone = accountP.Phone;
        contactDetails.EmailAddress = accountP.PersonEmail;
        contactDetails.PhysicalAddress = physicalAddress;
        contactDetails.PostalAddress = postalAddress;
        
        WBIF_IB_String_v1.cls_member member = new WBIF_IB_String_v1.cls_member();
        String stringBirthDate = string.valueOf(accountP.PersonBirthdate);
        member.DateOfBirth = stringBirthDate.replace(' ', 'T');
        member.FirstName = accountP.FirstName;
        member.Gender = accountP.Gender__pc;
        member.Initials = accountP.Initials__pc;
        member.MemberType = accountP.Client_Type__c.contains('Individual') ? 'Individual' : 'NonIndividual';
        member.RsaIdNumber = accountP.ID_Number__pc;
        member.Surname = accountP.LastName;
        member.EmailAddress = accountP.PersonEmail;
        if (titleTranslatedP != null){
            member.Title = titleTranslatedP;
        } else{
            member.Title = StringConstants.UNKNOWN_STRING;
        }
        member.CasaReferenceNumber = accountP.CASA_Reference_Number__pc;
        member.CifClientCode = accountP.CIF__c;
        member.contactDetails = contactDetails;
        member.CountryOfBirth = countryOfBirthTranslatedP;
        member.CountryOfResidence = countryOfResidenceTranslatedP;
        member.IncomeBand = 'Unknown';
        
        member.IsIndividual = accountP.Client_Type__c.contains('Individual') ? 'true' : 'false';
        member.IsSouthAfrican = nationalityTranslatedP == 'SOU01' ? 'true' : 'false';
        
        if (String.isNotBlank(maritalStatusTranslatedP)){
            member.MaritalStatus = maritalStatusTranslatedP;//accountP.Marital_Status__pc;
        }
        member.Nationality = nationalityTranslatedP;//accountP.Nationality__pc;
        member.SourceOfFunds = incomeSourceTranslatedP;//accountP.Income_Source__pc;
        member.SourceOfIncome = incomeSourceTranslatedP;//accountP.Income_Source__pc;
        member.IsStaff = 'false';
        /*** END MEMBER ***/
        
        /*** START DEBIT ***/
        //Default Values(Dummy Data) are assigned to the Debit Details Section
        WBIF_IB_String_v1.cls_debit debit = new WBIF_IB_String_v1.cls_debit();
        debit.AccountType = 'Cheque';
        /*** END DEBIT ***/
        
        WBIF_IB_String_v1.cls_PolicyCreate policyCreate = new WBIF_IB_String_v1.cls_PolicyCreate();
        policyCreate.module = productCode;
        
        policyCreate.appinfo = appinfo;
        policyCreate.member = member;
        policyCreate.debit = debit;
        requestBean.Policy_Create = policyCreate;
        
        return requestBean;
    }
    
    /**
    * @description WBIF_IB_String_v1 Description
    *
    * @param opportunityProductId (String) :opportunityProductId
    * @param userP (User): userP
    * @param accountP (Account): accountP
    * @param opportunityP (Opportunity): opportunityP
    * @param replacementPolicy (WBIF_Product_Details.ExistingPolicy): replacementPolicy
    * @param productCode (String): productCode
    * @return Return WBIF_IB_String_v1: Return description
     */
    public static WBIF_IB_String_v1 wbifPolicyCreate(String opportunityProductId, User userP, Account accountP, Opportunity opportunityP, WBIF_Product_Details.ExistingPolicy replacementPolicy, String productCode){
        
        WBIF_IB_String_v1 responseBean = new WBIF_IB_String_v1();
        
        //Value Translations
        String countryOfBirthTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String countryOfResidenceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_COUNTRY_STRING, accountP.Country_of_Residence__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        
        //***NOTE: maritalStatusTranslated will be sent to the mapping method as an Empty String ('') or with a Marital Status translated value
        String maritalStatusTranslated;
        if (accountP.Marital_Status__pc != null){
            
            maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_MARITAL_STATUS_STRING, accountP.Marital_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        } else{
            maritalStatusTranslated = '';
        }
        
        String nationalityTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_NATIONALITY_STRING, accountP.Nationality__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
        
        //***NOTE: titleTranslated will be sent to the mapping method as null or with a Title translated value
        String titleTranslated;
        if (accountP.PersonTitle != null){
            titleTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.WBIF_STRING, StringConstants.FIELD_TITLE_STRING, accountP.PersonTitle.replace('.', ''), StringConstants.OUTBOUND_RECORD_TYPE);
        }
        
        if (countryOfBirthTranslated != null && countryOfResidenceTranslated != null && maritalStatusTranslated != null && nationalityTranslated != null && incomeSourceTranslated != null){
            
            //POLICY CREATE ONLY
            //Map Request Fields
            WBIF_IB_String_v1 policyCreateRequestBean = mapPolicyCreateRequestFields(userP, accountP, productCode, replacementPolicy, countryOfBirthTranslated, countryOfResidenceTranslated, maritalStatusTranslated, nationalityTranslated, incomeSourceTranslated, titleTranslated);
            Payment_Plan__c payment = getPaymentForOpporunity(opportunityProductId);	

            policyCreateRequestBean.Policy_Create.debit.AccountHolder = payment.Account_Holder_Name__c;
            policyCreateRequestBean.Policy_Create.debit.DebitAccountNumber = payment.Account_Number__c;
            policyCreateRequestBean.Policy_Create.debit.AccountType = payment.Account_Type__c == null ? 'Cheque' : payment.Account_Type__c;
            policyCreateRequestBean.Policy_Create.debit.Bank = payment.Bank_Name__c;
            policyCreateRequestBean.Policy_Create.debit.BranchClearingCode = String.valueOf(payment.Branch_Code__c);
            policyCreateRequestBean.Policy_Create.debit.Branch = 'N/A';
            policyCreateRequestBean.Policy_Create.debit.SalaryDay = payment.Debit_Order_Salary_Day__c;
            policyCreateRequestBean.Policy_Create.debit.DebitDate = payment.Debit_Order_Debit_Day__c;
            policyCreateRequestBean.Policy_Create.debit.ThirdParty = 'false';
            //contractSection.SourceOfFunds = payment.;
            

            responseBean = (WBIF_IB_String_v1)Sys_Utilities_Integration.integrationServiceCall(policyCreateRequestBean, null, StringConstants.WBIF_POLICY_CREATE, WBIF_IB_String_v1.class);
            
            
            return responseBean;
        }
        else
        {
            throw new AuraHandledException('Unable to Create Policy Due to Translation Error');
        }
        
    }
    
    /**
    * @description updatePaymentDetails WBIF_IB_String_v1 Description
    *
    * @param policy (WBIF_IB_String_v1.cls_policy): policy
    * @param payment (WBIF_IB_String_v1.cls_debit): payment
    * @return Return WBIF_IB_String_v1: Return description
     */
    public static WBIF_IB_String_v1 updatePaymentDetails(WBIF_IB_String_v1.cls_policy policy, WBIF_IB_String_v1.cls_debit payment){
        WBIF_IB_String_v1 responseBean = new WBIF_IB_String_v1();
        
        if(policy.DebitDetails == null)
        {
            policy.DebitDetails = new WBIF_IB_String_v1.cls_debit();
        }	

        policy.DebitDetails.ThirdParty = 'false';
        policy.DebitDetails.SalaryDay = payment.SalaryDay;		
        policy.DebitDetails.DebitDay = payment.DebitDay;	
        policy.DebitDetails.DebitDate = payment.DebitDate;	
        policy.DebitDetails.DebitAccountNumber = payment.DebitAccountNumber;	
        policy.DebitDetails.BranchClearingCode = payment.BranchClearingCode;	
        policy.DebitDetails.Branch = payment.Branch;	
        policy.DebitDetails.Bank = payment.Bank;	
        policy.DebitDetails.AccountType = payment.AccountType;	
        policy.DebitDetails.AccountHolder = payment.AccountHolder;	
        
        responseBean = validatePolicy(policy);
        
        return responseBean;
    }
    
   
    private static WBIF_IB_String_v1 validatePolicy(WBIF_IB_String_v1.cls_policy policy){
        
        WBIF_IB_String_v1 validateRequestBean = new WBIF_IB_String_v1();
        validateRequestBean.ValidatePolicy =  new WBIF_IB_String_v1.cls_ValidatePolicy();
        validateRequestBean.ValidatePolicy.policy = policy;
        
        WBIF_IB_String_v1 responseBean = (WBIF_IB_String_v1)Sys_Utilities_Integration.integrationServiceCall(validateRequestBean, null, StringConstants.WBIF_VALIDATE_POLICY, WBIF_IB_String_v1.class);
        
        return responseBean;
    } 

    private static Payment_Plan__c getPaymentForOpporunity(String opportunityProductId){
        List<Application_Product__c> applicationProducts = [SELECT Id, Opportunity_Product_Id__c, Application__c FROM Application_Product__c WHERE Opportunity_Product_Id__c =:opportunityProductId];
        
        List<Payment_Plan__c> paymentPlans = [SELECT Account_Number__c, Account_Holder_Name__c, Bank_Name__c, Branch_Code__c, Method__c, Status__c,
										Debit_Order_Commencement_Date__c, Reference__c, Amount__c, Account_Type__c, Frequency__c, Application_Product__c,
                                        Debit_Order_Debit_Day__c, Debit_Order_Salary_Day__c
										FROM Payment_Plan__c WHERE Application_Product__c =:opportunityProductId];
        
        if(paymentPlans.size() > 0){
           return paymentPlans.get(0);
        }
        else{
            return new Payment_Plan__c();
        }

    }
    
    /**
    * @description sumbitPolicy Description
    *
    * @param policy (WBIF_IB_String_v1.cls_policy): policy
    * @return Return WBIF_IB_String_v1: Return description
    **/
    public static WBIF_IB_String_v1 sumbitPolicy(WBIF_IB_String_v1.cls_policy policy){
        
        WBIF_IB_String_v1 validateResponse  = BranchWBIFService.validatePolicy(policy);
        WBIF_IB_String_v1.cls_policy validatedPolicy = BranchWBIFService.getPolicy(validateResponse);
        
        if(validatedPolicy.PolicyInfo.ErrorReasons == null){
            
            WBIF_IB_String_v1 validateRequestBean = new WBIF_IB_String_v1();
            validateRequestBean.SubmitPolicy =  new WBIF_IB_String_v1.cls_SubmitPolicy();
            validateRequestBean.SubmitPolicy.policy = policy;
            
            WBIF_IB_String_v1 responseBean = (WBIF_IB_String_v1)Sys_Utilities_Integration.integrationServiceCall(validateRequestBean, null, StringConstants.WBIF_SUBMIT_POLICY, WBIF_IB_String_v1.class);

            return responseBean;
        }
        else{
            return validateResponse;
        }
    }
    
    /**
     * @description mapAddBeneficiariesRequestFields Description
    *
    * @param policy_CreatePolicyResponseP (User): userP
    * @param newMember (BranchMemberDetail): newMember
    * @return Return WBIF_IB_String_v1.cls_policy: Return description
     **/
    public static WBIF_IB_String_v1.cls_policy mapAddBeneficiariesRequestFields(WBIF_IB_String_v1.cls_policy policy_CreatePolicyResponseP, BranchMemberDetail newMember){
        
        WBIF_IB_String_v1.cls_Policy_AddBeneficiary addBeneficiary = new WBIF_IB_String_v1.cls_Policy_AddBeneficiary();
        
        addBeneficiary.policy = policy_CreatePolicyResponseP;
        
        WBIF_IB_String_v1.cls_beneficiary_member member = new WBIF_IB_String_v1.cls_beneficiary_member();
        member.age = string.valueOf(Date.today().year()-newMember.DateOfBirth.year());
        
        String stringDateOfBirth = String.valueOf(newMember.DateofBirth);
        member.DateOfBirth = stringDateOfBirth.replace(' ', 'T');
        member.FirstName = newMember.Name;
        member.Gender = newMember.Gender;
        if (newMember.IDNumber == null || newMember.IDNumber == ''){
            String idNumber = stringDateOfBirth.replace('-', '').subString(2, 8)+'0000000';
            member.RsaIdNumber = idNumber;
        } else{
            member.RsaIdNumber = newMember.IDNumber;
        }
        String relationship = newMember.Relationship.toUpperCase();
        relationship = relationship.replace('-', '_');
        relationship = relationship.replace(' ', '_');

        member.Surname = newMember.Surname;
        member.Relationship = relationship;
        member.Title = 'Unknown';
        member.ShortName = newMember.Name;
        member.MemberType = 'Unknown';
        member.Initials = newMember.Name.substring(0, 1);
        member.BenefitSplit = '100';
        addBeneficiary.member = member;
        
        /************/
        
        WBIF_IB_String_v1 addBeneficiaryRequestBean = new WBIF_IB_String_v1();
        addBeneficiaryRequestBean.Policy_AddBeneficiary = addBeneficiary;
        
        WBIF_IB_String_v1 responseBean = (WBIF_IB_String_v1)Sys_Utilities_Integration.integrationServiceCall(addBeneficiaryRequestBean, null, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, WBIF_IB_String_v1.class);
        
        return getPolicy(responseBean);
    }
}