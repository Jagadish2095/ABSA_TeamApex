/**
 * @description       : 
 * @author            : poulami.banerjee@absa.africa
 * @last modified on  : 2021-09-28
 * @last modified by  : poulami.banerjee@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-07-12   poulami.banerjee@absa.africa   Initial Version
**/
public class WBIF_IU_v1 {
    /**
     * @description description
     */
    //String values to be used for the JSON String replace method
    public static final String REPLACEMENT_DATE_FIELD = '"ReplacementDate"';
    public static final String DATE_FIELD = '"Date"';
    public static final String ERROR_STRING_FIELD = '"errorString"';
    public static final String STRING_FIELD = '"string"';
    public static final String BODY_ID = '"BodyId"';
    public static final String AT_SYMBOL_ID = '"@Id"';
    public static final String LANG = '"lang"';
    public static final String AT_SYMBOL_LANG = '"@lang"';
    public static final String EXCEPTION_TYPE = '"exceptionType"';
    public static final String INNER_EXCEPTION_TYPE = '"innerExceptionType"';
    public static final String PREMIUM_LOADING_TYPE = '"PremiumLoadingType"';
    public static final String STRING_TYPE = '"Type"';
    public static final String BENEFICIARY_OBJ = '"BeneficiaryObj"';
    public static final String BENEFICIARY = '"Beneficiary"';
    public static final String DEPENDENT_OBJ = '"DependentObj"';
    public static final String DEPENDENT = '"Dependent"';
    public static final String PREMIUM_LOADINGS_STRING = '"PremiumLoadingsString"';
    public static final String PREMIUM_LOADINGS = '"PremiumLoadings"';
    public static final String BENEFIT_OBJ = '"BenefitObj"';
    public static final String BENEFIT = '"Benefit"';
    public static final String MODULE = 'WIMAL00500';
    /**
     * @description executeWBIFCallout description
     *
     * @param integrationSettingsP (Integration_API__c): integrationSettingsP
     * @param integrationServiceP (Integration_Service__c): integrationServiceP
     * @param jsonStringP (String): jsonStringP
     * @return Return WBIF_IB_String_v1: Return description
     */
    public static WBIF_IB_String_v1 executeWBIFCallout(Integration_API__c integrationSettingsP, Integration_Service__c integrationServiceP, String jsonStringP){
        
        WBIF_IB_String_v1 responseBean;
        
        HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettingsP, integrationServiceP, jsonStringP);  
        request.setTimeout(120000);
        //Send Request
        HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
        //System.debug('WBIF RESPONSE CODE: ' + response.getStatusCode());
        //System.debug('WBIF RESPONSE: ' + response.getBody());
        //Map Response
        if(response.getStatusCode() != 200){
            if(response.getBody().contains('{')){
                response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                responseBean = mapResponseFields(response);
            }else{
                responseBean = mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
            }  
        }else{
            responseBean = mapResponseFields(response);
        }
        return responseBean;
    }
    /**
     * @description mapPolicyCreateRequestFields description
     *
     * @param userP (User): userP
     * @param accountP (Account): accountP
     * @param opportunityP (Opportunity): opportunityP
     * @param countryOfBirthTranslatedP (String): countryOfBirthTranslatedP
     * @param countryOfResidenceTranslatedP (String): countryOfResidenceTranslatedP
     * @param maritalStatusTranslatedP (String): maritalStatusTranslatedP
     * @param nationalityTranslatedP (String): nationalityTranslatedP
     * @param incomeSourceTranslatedP (String): incomeSourceTranslatedP
     * @param titleTranslatedP (String): titleTranslatedP
     * @param generalVirtualAdvisorRulesMap (Map<StringList<General_Virtual_Advisor_Rules__mdt>>): generalVirtualAdvisorRulesMap
     * @param adapt360BeanP (ADAPT360_Resp_IB_v1): adapt360BeanP
     * @return Return WBIF_IB_String_v1: Return description
     */
    //1.Policy Create
    public static WBIF_IB_String_v1 mapPolicyCreateRequestFields(User userP, Account accountP, Opportunity opportunityP, String countryOfBirthTranslatedP, String countryOfResidenceTranslatedP, String maritalStatusTranslatedP, String nationalityTranslatedP, String incomeSourceTranslatedP, String titleTranslatedP, Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap, ADAPT360_Resp_IB_v1 adapt360BeanP){
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        
        /*** START APPINFO ***/
        WBIF_IB_String_v1.cls_Agent agent = new WBIF_IB_String_v1.cls_Agent();
        agent.DistributionChannel = generalVirtualAdvisorRulesMap.get(StringConstants.DISTRIBUTION_CHANNEL)[0].EnumerationExpectedValues__c;//BranchSales
        if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity' && opportunityP.Lead_Branch_Site_Code__c != null){
            String agentSiteCode = opportunityP.Lead_Branch_Site_Code__c.split(' ')[0];
            agent.EmployeeNumber = opportunityP.Lead_Branch_Employee_Number__c;
            agent.SiteCode = agentSiteCode;
        }
        
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
        replacement.IsReplacement = string.valueOf(generalVirtualAdvisorRulesMap.get(StringConstants.IS_REPLACEMENT)[0].BooleanValue__c);//false
        
        WBIF_IB_String_v1.cls_Application appinfo = new WBIF_IB_String_v1.cls_Application();
        appinfo.agent = agent;
        appinfo.consultant = consultant;
        appinfo.declaration = declaration;
        
        if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity'){
            appinfo.DistributionChannel = 'BranchOptimisation';
            appinfo.IsBranchSales = 'false';
        	appinfo.IsClientPresent = 'false';
        }
        else{
            appinfo.DistributionChannel = generalVirtualAdvisorRulesMap.get(StringConstants.DISTRIBUTION_CHANNEL)[0].EnumerationExpectedValues__c;//BranchSales
        	appinfo.IsBranchSales = string.valueOf(generalVirtualAdvisorRulesMap.get(StringConstants.IS_BRANCH_SALES)[0].BooleanValue__c);//false
        	appinfo.IsClientPresent = string.valueOf(generalVirtualAdvisorRulesMap.get(StringConstants.IS_CLIENT_PRESENT)[0].BooleanValue__c);//true
       }
        appinfo.replacement = replacement;
        /*** END APPINFO ***/
        
        /*** START MEMBER ***/
        //adapt360BeanP
        WBIF_IB_String_v1.cls_address physicalAddress = new WBIF_IB_String_v1.cls_address();
        physicalAddress.Line1 = adapt360BeanP.ClientDetails[0].location.physicalAddress.addressName1.value;
        physicalAddress.Line2 = adapt360BeanP.ClientDetails[0].location.physicalAddress.addressName2.value;
        physicalAddress.Line3 = adapt360BeanP.ClientDetails[0].location.physicalAddress.cityName.value;
        physicalAddress.PostalCode = adapt360BeanP.ClientDetails[0].location.physicalAddress.postCodeArea.value;
        //Postal Address
        WBIF_IB_String_v1.cls_address postalAddress = new WBIF_IB_String_v1.cls_address();
        postalAddress.Line1 = adapt360BeanP.ClientDetails[0].location.postalAddress.addressName1.value;
        postalAddress.Line2 = adapt360BeanP.ClientDetails[0].location.postalAddress.addressName2.value;
        postalAddress.Line3 = adapt360BeanP.ClientDetails[0].location.postalAddress.cityName.value;
        postalAddress.PostalCode = adapt360BeanP.ClientDetails[0].location.postalAddress.postCodeArea.value;
        
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
        member.MemberType = generalVirtualAdvisorRulesMap.get(StringConstants.MEMBER_TYPE)[0].EnumerationExpectedValues__c;//Individual
        member.RsaIdNumber = accountP.ID_Number__pc;
        member.Surname = accountP.LastName;
        member.EmailAddress = accountP.PersonEmail;
        if(titleTranslatedP != null){
            member.Title = titleTranslatedP;
        }else{
            member.Title = StringConstants.UNKNOWN_STRING;
        }
        member.CasaReferenceNumber = accountP.CASA_Reference_Number__pc;
        member.CifClientCode = accountP.CIF__c;
        member.contactDetails = contactDetails;
        member.CountryOfBirth = countryOfBirthTranslatedP;//accountP.Country_of_Birth__pc;
        member.CountryOfResidence = countryOfResidenceTranslatedP;//accountP.Country_of_Residence__pc;
        
        //member.IncomeBand = accountP.Income_Bracket__pc;//'Band1'
        member.IncomeBand = generalVirtualAdvisorRulesMap.get(StringConstants.MEMBER_INCOME_BAND_UNKNOWN)[0].EnumerationExpectedValues__c;//Unknown
        
        member.IsIndividual = string.valueOf(generalVirtualAdvisorRulesMap.get(StringConstants.IS_INDIVIDUAL)[0].BooleanValue__c);//true
        member.IsSouthAfrican = string.valueOf(generalVirtualAdvisorRulesMap.get(StringConstants.IS_SOUTH_AFRICAN)[0].BooleanValue__c);//true
        //member.Language = accountP.Communication_Language__pc;
        if(String.isNotBlank(maritalStatusTranslatedP)){
            member.MaritalStatus = maritalStatusTranslatedP;//accountP.Marital_Status__pc;
        }
        member.Nationality = nationalityTranslatedP;//accountP.Nationality__pc;
        member.SourceOfFunds = incomeSourceTranslatedP;//accountP.Income_Source__pc;
        member.SourceOfIncome = incomeSourceTranslatedP;//accountP.Income_Source__pc;
        member.IsStaff = string.valueOf(generalVirtualAdvisorRulesMap.get(StringConstants.IS_STAFF)[0].BooleanValue__c);//false
        /*** END MEMBER ***/
        
        /*** START DEBIT ***/
        //Default Values(Dummy Data) are assigned to the Debit Details Section
        WBIF_IB_String_v1.cls_debit debit = new WBIF_IB_String_v1.cls_debit();
        debit.AccountType = 'Cheque';
        /*** END DEBIT ***/
        
        WBIF_IB_String_v1.cls_PolicyCreate policyCreate = new WBIF_IB_String_v1.cls_PolicyCreate();
        //Added by Poulami to pass Ultimate Protector Module
        if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity')
            policyCreate.module = MODULE;
        else
            policyCreate.module = generalVirtualAdvisorRulesMap.get(StringConstants.MODULE)[0].EnumerationExpectedValues__c;//EPP
        policyCreate.appinfo = appinfo;
        policyCreate.member = member;
        policyCreate.debit = debit;
        requestBean.Policy_Create = policyCreate;
        
        return requestBean;
    }
    /**
     * @description mapAddDependentRequestFields description
     *
     * @param policy_CreatePolicyResponseP (WBIF_IB_String_v1): policy_CreatePolicyResponseP
     * @param opportunityPartyP (Opportunity_Party__c): opportunityPartyP
     * @param relationshipP (String): relationshipP
     * @param generalVirtualAdvisorRulesMap (Map<StringList<General_Virtual_Advisor_Rules__mdt>>): generalVirtualAdvisorRulesMap
     * @return Return WBIF_IB_String_v1: Return description
     */
    //2.Policy Add Dependent
    public static WBIF_IB_String_v1 mapAddDependentRequestFields(WBIF_IB_String_v1 policy_CreatePolicyResponseP, Opportunity_Party__c opportunityPartyP, String relationshipP, Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap){
        
       // System.debug('map add dependent: ' + policy_CreatePolicyResponseP);
        WBIF_IB_String_v1.cls_Policy_AddDependent addDependent = new WBIF_IB_String_v1.cls_Policy_AddDependent();
        
        addDependent.policy = getPolicy(policy_CreatePolicyResponseP);
        
        WBIF_IB_String_v1.cls_beneficiary_member member = new WBIF_IB_String_v1.cls_beneficiary_member();
        
        if(opportunityPartyP.Age__c!=null){
            Double ageDouble = Math.floor(opportunityPartyP.Age__c);
            Integer ageInteger = Integer.valueOf(ageDouble);
            member.age = String.valueOf(ageInteger);
        }
        String stringDateOfBirth = String.valueOf(opportunityPartyP.Date_of_Birth__c);
        member.DateOfBirth = stringDateOfBirth.replace(' ', 'T');
        member.FirstName = opportunityPartyP.First_Name__c;
        member.Gender = StringConstants.UNKNOWN_STRING;
        if(opportunityPartyP.RSA_ID_Number__c == null){
            String idNumber = stringDateOfBirth.replace('-', '').subString(2,8) + '0000000';
            member.RsaIdNumber = idNumber;
        }else{
            member.RsaIdNumber = opportunityPartyP.RSA_ID_Number__c;
        }
        member.Surname = opportunityPartyP.Last_Name__c;
        member.Relationship = relationshipP;
        addDependent.member = member;
        /************/
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.Policy_AddDependent = addDependent;
        
        return requestBean;
    }
    /**
     * @description mapAddBenefitRequestFields description
     *
     * @param policy_AddDependentResultP (WBIF_IB_String_v1): policy_AddDependentResultP
     * @param memberIdP (String): memberIdP
     * @param productP (String): productP
     * @param generalVirtualAdvisorRulesMap (Map<StringList<General_Virtual_Advisor_Rules__mdt>>): generalVirtualAdvisorRulesMap
     * @param isSpouse (Boolean): isSpouse
     * @return Return WBIF_IB_String_v1: Return description
     */
    //3.Policy Add Benefit
    public static WBIF_IB_String_v1 mapAddBenefitRequestFields(WBIF_IB_String_v1 policy_AddDependentResultP, String memberIdP, String productP, Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap, Boolean isSpouse){
        
        WBIF_IB_String_v1.cls_Policy_AddBenefit addBenefit = new WBIF_IB_String_v1.cls_Policy_AddBenefit();
        
        addBenefit.policy = getPolicy(policy_AddDependentResultP);
        
        addBenefit.memberid = memberIdP;
        addBenefit.benefitid = productP;
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.Policy_AddBenefit = addBenefit;
        return requestBean;
    }
    /**
     * @description mapCalculateRequestFields description
     *
     * @param policy_AddBenefitResultP (WBIF_IB_String_v1): policy_AddBenefitResultP
     * @param quoteLineItemListP (List<QuoteLineItem>): quoteLineItemListP
     * @return Return WBIF_IB_String_v1: Return description
     */
    //4.Calculate Policy
    public static WBIF_IB_String_v1 mapCalculateRequestFields(WBIF_IB_String_v1 policy_AddBenefitResultP, List<QuoteLineItem> quoteLineItemListP){
        
        WBIF_IB_String_v1.cls_Calculate calculate = new WBIF_IB_String_v1.cls_Calculate();
        
        calculate.policy = getPolicy(policy_AddBenefitResultP);
        
        for(QuoteLineItem quoteLine : quoteLineItemListP){
            
            if(String.isNotBlank(quoteLine.Benefit__c))
            {
                // Added by Poulami to calculate for Ultimate Protector
                if(quoteLine.Benefit__c.contains('Death and Accidental Disability') || quoteLine.Benefit__c.contains('U01_U03')){
                    for(WBIF_IB_String_v1.cls_benefit benefit : calculate.policy.MainMember.benefits.benefit){
                        benefit.Cover = String.valueOf(quoteLine.Policy_Cover__c);
                        benefit.BenefitID = 'U01_U03';
                        benefit.GUID = '00000000-0000-0000-0000-000000000000';
                    }
                }
                
                if(quoteLine.Benefit__c.contains('Accidental Death Benifit and Accidental Disability') || quoteLine.Benefit__c.contains('U02_U03')){
                    for(WBIF_IB_String_v1.cls_benefit benefit : calculate.policy.MainMember.benefits.benefit){
                        benefit.Cover = String.valueOf(quoteLine.Policy_Cover__c);
                        benefit.BenefitID = 'U02_U03';
                        benefit.GUID = '00000000-0000-0000-0000-000000000000';
                        WBIF_IB_String_v1.cls_UnderwritingItem underwritingMainMember = new WBIF_IB_String_v1.cls_UnderwritingItem();
                        underwritingMainMember.GUID = '00000000-0000-0000-0000-000000000000';
                        underwritingMainMember.ID = '93';
                        underwritingMainMember.Value = 'true';
                        calculate.policy.UnderwritingItems.UnderwritingItem.add(underwritingMainMember);
                    }
                }
            }
            
            if(calculate.policy.MainMember.benefits != null){
                for(WBIF_IB_String_v1.cls_benefit benefit : calculate.policy.MainMember.benefits.benefit){
                    
                    if(benefit.BenefitID == 'UEF' && quoteLine.Product2.Name.contains('Executor Fee')){
                        benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                    }
                    if(benefit.BenefitID == 'UBR' && quoteLine.Product2.Name.contains('Estate Bridging')){
                        benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                    }
                }
            }
            
            if(calculate.policy.dependents != null){
                
                for(WBIF_IB_String_v1.cls_dependent dependent : calculate.policy.dependents.dependent){
                    
                    if(dependent.benefits != null){
                        
                        for(WBIF_IB_String_v1.cls_benefit benefit : dependent.benefits.benefit){
                            if(benefit.BenefitID == 'UEFS' && quoteLine.Product2.Name.contains('Executor Fee')){
                                benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                            }
                            if(benefit.BenefitID == 'UBRS' && quoteLine.Product2.Name.contains('Estate Bridging')){
                                benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                            }
                        }
                    }
                }
            }
            if(calculate.policy.spouse != null){
                
                if(calculate.policy.spouse.benefits != null){
                    
                    for(WBIF_IB_String_v1.cls_benefit benefit : calculate.policy.spouse.benefits.benefit){
                        
                        if(benefit.BenefitID == 'UEFS' && quoteLine.Product2.Name.contains('Executor Fee')){
                            benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                        }
                        if(benefit.BenefitID == 'UBRS' && quoteLine.Product2.Name.contains('Estate Bridging')){
                            benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                        }
                    }
                }
                if(calculate.policy.spouses != null){
                    for(WBIF_IB_String_v1.cls_dependent dependent : calculate.policy.spouses.dependent){
                        
                        if(dependent.benefits != null){
                            
                            for(WBIF_IB_String_v1.cls_benefit benefit : dependent.benefits.benefit){
                                
                                if(benefit.BenefitID == 'UEFS' && quoteLine.Product2.Name.contains('Executor Fee')){
                                    benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                                }
                                if(benefit.BenefitID == 'UBRS' && quoteLine.Product2.Name.contains('Estate Bridging')){
                                    benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.Calculate = calculate;
        return requestBean;
    }
    /**
     * @description mapAddBeneficiaryRequestFields description
     *
     * @param policy_AddDependentResultP (WBIF_IB_String_v1): policy_AddDependentResultP
     * @param opportunityPartyP (Opportunity_Party__c): opportunityPartyP
     * @param relationshipP (String): relationshipP
     * @param generalVirtualAdvisorRulesMap (Map<StringList<General_Virtual_Advisor_Rules__mdt>>): generalVirtualAdvisorRulesMap
     * @return  Return WBIF_IB_String_v1: Return description
     */
    //5.Policy Add Beneficiary
    public static WBIF_IB_String_v1 mapAddBeneficiaryRequestFields(WBIF_IB_String_v1 policy_AddDependentResultP, Opportunity_Party__c opportunityPartyP, String relationshipP, Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap){
        //System.debug('Beneficiary IU: ' + policy_AddDependentResultP);
        WBIF_IB_String_v1.cls_Policy_AddBeneficiary addBeneficiary = new WBIF_IB_String_v1.cls_Policy_AddBeneficiary();
        
        addBeneficiary.policy = getPolicy(policy_AddDependentResultP);
        
        WBIF_IB_String_v1.cls_beneficiary_member member = new WBIF_IB_String_v1.cls_beneficiary_member();
        if(opportunityPartyP.Age__c!=null){
            Double ageDouble = Math.floor(opportunityPartyP.Age__c);
            Integer ageInteger = Integer.valueOf(ageDouble);
            member.age = String.valueOf(ageInteger);
        }
        
        String stringDateOfBirth = String.valueOf(opportunityPartyP.Date_of_Birth__c);
        member.DateOfBirth = stringDateOfBirth;
        
        member.FirstName = opportunityPartyP.First_Name__c;
        member.Gender = StringConstants.UNKNOWN_STRING;
        member.MemberType = StringConstants.UNKNOWN_STRING;
        
        if(opportunityPartyP.RSA_ID_Number__c == null){
            
            String idNumber = stringDateOfBirth.replace('-', '').subString(2,8) + '0000000';
            member.RsaIdNumber = idNumber;
        }else{
            
            member.RsaIdNumber = opportunityPartyP.RSA_ID_Number__c;
        }
        
        member.Surname = opportunityPartyP.Last_Name__c;
        member.Title = StringConstants.UNKNOWN_STRING;
        if(opportunityPartyP.Benefit_Split__c == null)
            member.BenefitSplit = String.valueOf(100);
        else
            member.BenefitSplit = String.valueOf(opportunityPartyP.Benefit_Split__c*100);
        member.Relationship = relationshipP;
        addBeneficiary.member = member;
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.Policy_AddBeneficiary = addBeneficiary;
        return requestBean;
    }
    /**
     * @description mapPolicyValidateRequestFields description
     *
     * @param policy_AddBeneficiaryResponseP (WBIF_IB_String_v1): policy_AddBeneficiaryResponseP
     * @param accountP (Account): accountP
     * @param opportunityP (Opportunity): opportunityP
     * @param generalVirtualAdvisorRulesMap (Map<StringList<General_Virtual_Advisor_Rules__mdt>>): generalVirtualAdvisorRulesMap
     * @param quoteLineItemListP (List<QuoteLineItem>): quoteLineItemListP
     * @return  Return WBIF_IB_String_v1: Return description
     */
    //6.Policy Validate
    public static WBIF_IB_String_v1 mapPolicyValidateRequestFields(WBIF_IB_String_v1 policy_AddBeneficiaryResponseP, Account accountP, Opportunity opportunityP, Map<String, List<General_Virtual_Advisor_Rules__mdt>> generalVirtualAdvisorRulesMap, List<QuoteLineItem> quoteLineItemListP){
        
        WBIF_IB_String_v1.cls_ValidatePolicy validatePolicy = new WBIF_IB_String_v1.cls_ValidatePolicy();
        
        // Poulami Added for Direct Delivery for Ultimate Protector
        List<Quote> quotes = new List<Quote>();
        if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity')
            quotes = new QuotesSelector().selectByProductName(opportunityP.Id,StringConstants.PRODUCT_ULTIMATE_PROTECTOR);
        
        validatePolicy.policy = getPolicy(policy_AddBeneficiaryResponseP);
        String commencementDate;
        validatePolicy.policy.MainMember.WillNumber = opportunityP.Will_Number__c;
        if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity'){           
            commencementDate = String.valueOf(quotes[0].Commencement_Date__c);
        }
        else   
            commencementDate = String.valueOf(opportunityP.Commencement_Date__c);
        validatePolicy.policy.PolicyInfo.Inception = commencementDate.replace(' ', 'T');
        validatePolicy.policy.Application.Declaration.Advice = String.valueOf(generalVirtualAdvisorRulesMap.get(StringConstants.DECLARATION_STATUS_VALID)[0].BooleanValue__c);//true
        validatePolicy.policy.Application.Consultant.PRINumber = opportunityP.PRI_Number__c;
        
        /*** START DEBIT ***/
        //Default Values from Policy Create are overridden and remapped
        WBIF_IB_String_v1.cls_debit debit = new WBIF_IB_String_v1.cls_debit();
        if(opportunityP.RecordType.Name == 'Direct Delivery Sales Opportunity'){
            
            debit.AccountHolder = accountP.PersonTitle + '' + accountP.Initials__pc + '' + accountP.LastName;
            debit.AccountType = quotes[0].Debit_Order_Account_Type__c;
            debit.Bank = quotes[0].Debit_Order_Bank_Name__c;
            debit.Branch = quotes[0].Debit_Order_Branch_Name__c;
            debit.BranchClearingCode = string.valueOf(quotes[0].Debit_Order_Branch_Code__c);
            debit.DebitAccountNumber = quotes[0].Debit_Order_Account_Number__c;
            if(quotes[0].Debit_Order_Date__c != null){
                String stringDebitDate = string.valueOf(quotes[0].Debit_Order_Date__c);
                debit.DebitDate = stringDebitDate.replace(' ', 'T');
                //debit.DebitDay = string.valueOf(opportunityP.Debit_Order_Debit_Day__c);
                debit.DebitDay = string.valueOf(quotes[0].Debit_Order_Date__c.day());
            }
            debit.SalaryDay = string.valueOf(quotes[0].Debit_Order_Salary_Day__c);
            debit.ThirdParty = string.valueOf(false);   
        }
        else{
            
            debit.AccountHolder = accountP.PersonTitle + '' + accountP.Initials__pc + '' + accountP.LastName;
            debit.AccountType = opportunityP.Debit_Order_Account_Type__c;
            debit.Bank = opportunityP.Debit_Order_Bank_Name__c;
            debit.Branch = opportunityP.Debit_Order_Branch_Name__c;
            debit.BranchClearingCode = string.valueOf(opportunityP.Debit_Order_Branch_Code__c);
            debit.DebitAccountNumber = opportunityP.Debit_Order_Account_Number__c;
            if(opportunityP.Debit_Order_Date__c != null){
                String stringDebitDate = string.valueOf(opportunityP.Debit_Order_Date__c);
                debit.DebitDate = stringDebitDate.replace(' ', 'T');
                //debit.DebitDay = string.valueOf(opportunityP.Debit_Order_Debit_Day__c);
                debit.DebitDay = string.valueOf(opportunityP.Debit_Order_Date__c.day());
            }
            debit.SalaryDay = string.valueOf(opportunityP.Debit_Order_Salary_Day__c);
            debit.ThirdParty = string.valueOf(opportunityP.DebitOrderThirdParty__c);    
        }       
        /*** END DEBIT ***/
        
        validatePolicy.policy.DebitDetails = debit;
        
        /*** Assigning Policy Cover Ammount (To Be removed when Calculate is Implemented) ***/
        /*for(QuoteLineItem quoteLine : quoteLineItemListP){
            
            if(validatePolicy.policy.dependents != null){
                
                for(WBIF_IB_String_v1.cls_dependent dependent : validatePolicy.policy.dependents.dependent){
                    
                    if(dependent.benefits != null){
                        
                        for(WBIF_IB_String_v1.cls_benefit benefit : dependent.benefits.benefit){
                            if(benefit.BenefitID == 'UEFS' && quoteLine.Product2.Name.contains('Executor Fee')){
                                benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                                benefit.Premium = String.valueOf(quoteLine.Premium__c);
                                benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                            }
                            if(benefit.BenefitID == 'UBRS' && quoteLine.Product2.Name.contains('Estate Bridging')){
                                benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                                benefit.Premium = String.valueOf(quoteLine.Premium__c);
                                benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                            }
                        }
                    }
                }
            }
            if(validatePolicy.policy.spouse != null){
                
                if(validatePolicy.policy.spouse.benefits != null){
                    
                    for(WBIF_IB_String_v1.cls_benefit benefit : validatePolicy.policy.spouse.benefits.benefit){
                        
                        if(benefit.BenefitID == 'UEFS' && quoteLine.Product2.Name.contains('Executor Fee')){
                            benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                            benefit.Premium = String.valueOf(quoteLine.Premium__c);
                            benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                        }
                        if(benefit.BenefitID == 'UBRS' && quoteLine.Product2.Name.contains('Estate Bridging')){
                            benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                            benefit.Premium = String.valueOf(quoteLine.Premium__c);
                            benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                        }
                    }
                }
                if(validatePolicy.policy.spouses != null){
                    for(WBIF_IB_String_v1.cls_dependent dependent : validatePolicy.policy.spouses.dependent){
                        
                        if(dependent.benefits != null){
                            
                            for(WBIF_IB_String_v1.cls_benefit benefit : dependent.benefits.benefit){
                                
                                if(benefit.BenefitID == 'UEFS' && quoteLine.Product2.Name.contains('Executor Fee')){
                                    benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                                    benefit.Premium = String.valueOf(quoteLine.Premium__c);
                                    benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                                }
                                if(benefit.BenefitID == 'UBRS' && quoteLine.Product2.Name.contains('Estate Bridging')){
                                    benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                                    benefit.Premium = String.valueOf(quoteLine.Premium__c);
                                    benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                                }
                            }
                        }
                    }
                }
            }
            
            if(validatePolicy.policy.MainMember.benefits != null){
                for(WBIF_IB_String_v1.cls_benefit benefit : validatePolicy.policy.MainMember.benefits.benefit){
                    
                    if(benefit.BenefitID == 'UEF' && quoteLine.Product2.Name.contains('Executor Fee')){
                        benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                        benefit.Premium = String.valueOf(quoteLine.Premium__c);
                        benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                    }
                    if(benefit.BenefitID == 'UBR' && quoteLine.Product2.Name.contains('Estate Bridging')){
                        benefit.cover = String.valueOf(quoteLine.Policy_Cover__c);
                        benefit.Premium = String.valueOf(quoteLine.Premium__c);
                        benefit.TotalPremium = String.valueOf(quoteLine.TotalPrice);
                    }
                }
            }
        }*/
        /*** End Of Assigning Policy Cover Ammount ***/
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.ValidatePolicy = validatePolicy;
        return requestBean;
    }
    /**
     * @description mapPolicySubmitFields description
     *
     * @param validatePolicyResponseP (WBIF_IB_String_v1): validatePolicyResponseP
     * @return  Return WBIF_IB_String_v1: Return description
     */
    //7.Policy Submit
    public static WBIF_IB_String_v1 mapPolicySubmitFields(WBIF_IB_String_v1 validatePolicyResponseP){
        
        WBIF_IB_String_v1.cls_SubmitPolicy submitPolicy = new WBIF_IB_String_v1.cls_SubmitPolicy();
        
        submitPolicy.policy = getPolicy(validatePolicyResponseP);
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.SubmitPolicy = submitPolicy;
        return requestBean;
    }
    /**
     * @description mapQuoteSummaryFields description
     *
     * @param wbifPolicyCreateSessionP (WBIF_IB_String_v1): wbifPolicyCreateSessionP
     * @param productCodePriceMapP (Map<StringString>): productCodePriceMapP
     * @param dateOfBirthP (String): dateOfBirthP
     * @param ageP (String): ageP
     * @param isSpouseP (Boolean): isSpouseP
     * @return  Return WBIF_IB_String_v1: Return description
     */
    //*** Add Depedent, Add Benefit & Calculate combination mapping metod
    public static WBIF_IB_String_v1 mapQuoteSummaryFields(WBIF_IB_String_v1 wbifPolicyCreateSessionP, Map<String, String> productCodePriceMapP, String dateOfBirthP, String ageP, Boolean isSpouseP){
        
        WBIF_IB_String_v1.cls_Calculate calculatePolicy = new WBIF_IB_String_v1.cls_Calculate();
        calculatePolicy.policy = getPolicy(wbifPolicyCreateSessionP);
        //WBIF_IB_String_v1.cls_Benefit benefitMain = new WBIF_IB_String_v1.cls_Benefit();
        //WBIF_IB_String_v1.cls_Benefit benefitSpouse = new WBIF_IB_String_v1.cls_Benefit();
        List<WBIF_IB_String_v1.cls_Benefit> benefitsMainMemberList = new List<WBIF_IB_String_v1.cls_Benefit>();
        List<WBIF_IB_String_v1.cls_Benefit> benefitsSpouseList = new List<WBIF_IB_String_v1.cls_Benefit>();
        
         // Poulami added for Ultimate Protector Underwriting Items:
        List<WBIF_IB_String_v1.cls_UnderwritingItems> underwritingMainMemberList = new List<WBIF_IB_String_v1.cls_UnderwritingItems>();
        
        for(String productName : productCodePriceMapP.keySet()){
            
            WBIF_IB_String_v1.cls_Benefit benefitMain = new WBIF_IB_String_v1.cls_Benefit();
            WBIF_IB_String_v1.cls_Benefit benefitSpouse = new WBIF_IB_String_v1.cls_Benefit();         
            
            //System.debug('productName: ' + productName);
            
            if(productName == 'UEF'){
                //System.debug('Hello World UEF');
                benefitMain.BenefitID = 'UEF';
                benefitMain.Cover = productCodePriceMapP.get('UEF');
                benefitMain.GUID = '00000000-0000-0000-0000-000000000000';
                
                benefitsMainMemberList.add(benefitMain);
                
            }//Added by Poulami to pass Ultimate Protector Module
            else if(productName == 'U01_U03'){
                //System.debug('Hello World U01_U03');
                benefitMain.BenefitID = 'U01_U03';
                benefitMain.Cover = productCodePriceMapP.get('U01_U03');
                benefitMain.GUID = '00000000-0000-0000-0000-000000000000';
                
                benefitsMainMemberList.add(benefitMain);
                
            }//Added by Poulami to pass Ultimate Protector Module
            else if(productName == 'U02_U03'){
                //System.debug('Hello World U02_U03');
                benefitMain.BenefitID = 'U02_U03';
                benefitMain.Cover = productCodePriceMapP.get('U02_U03');
                benefitMain.GUID = '00000000-0000-0000-0000-000000000000';
                
                benefitsMainMemberList.add(benefitMain);  
                WBIF_IB_String_v1.cls_UnderwritingItem underwritingMainMember = new WBIF_IB_String_v1.cls_UnderwritingItem();
                underwritingMainMember.GUID = '00000000-0000-0000-0000-000000000000';
                underwritingMainMember.ID = '93';
                underwritingMainMember.Value = 'true';
                calculatePolicy.policy.UnderwritingItems.UnderwritingItem.add(underwritingMainMember);
                
            }else if(productName == 'UEFS'){
                //System.debug('Hello World UEFs');
                benefitSpouse.BenefitID = 'UEFS';
                benefitSpouse.Cover = productCodePriceMapP.get('UEFS');
                benefitSpouse.GUID = '00000000-0000-0000-0000-000000000000';
                
                benefitsSpouseList.add(benefitSpouse);
                
            }else if(productName == 'UBR'){
                //System.debug('Hello World UBR');
                benefitMain.BenefitID = 'UBR';
                benefitMain.Cover = productCodePriceMapP.get('UBR');
                benefitMain.GUID = '00000000-0000-0000-0000-000000000000';
                
                benefitsMainMemberList.add(benefitMain);
                
            }else if(productName == 'UBRS'){
                //System.debug('Hello World UBRS');
                benefitSpouse.BenefitID = 'UBRS';
                benefitSpouse.Cover = productCodePriceMapP.get('UBRS');
                benefitSpouse.GUID = '00000000-0000-0000-0000-000000000000';
                
                benefitsSpouseList.add(benefitSpouse);
                
            }else if(productName == 'UFN'){
               // System.debug('Hello World UFN');
                benefitMain.BenefitID = 'UFN';
                //benefitMain.Cover = productCodePriceMapP.get('UFN');
                benefitMain.GUID = '00000000-0000-0000-0000-000000000000';
                
                benefitsMainMemberList.add(benefitMain);
            }
            
        }
        
        if(isSpouseP){
            //Spouse tag
            WBIF_IB_String_v1.cls_Spouse spouse = new WBIF_IB_String_v1.cls_Spouse();
            
            spouse.age = ageP;
            spouse.DateOfBirth = dateOfBirthP;
            
            WBIF_IB_String_v1.cls_Benefits benefits = new WBIF_IB_String_v1.cls_Benefits();
            benefits.Benefit = benefitsSpouseList;
            
            spouse.Benefits = benefits;
            calculatePolicy.policy.spouse = spouse;
            
            //Main Member Tag
            for(WBIF_IB_String_v1.cls_Benefit mainMemberBenefit: benefitsMainMemberList){
                calculatePolicy.policy.MainMember.Benefits.Benefit.add(mainMemberBenefit);
            }
            
        }else{
            
            //Main Member Tag
            for(WBIF_IB_String_v1.cls_Benefit mainMemberBenefit: benefitsMainMemberList){
                calculatePolicy.policy.MainMember.Benefits.Benefit.add(mainMemberBenefit);
            }
            
        }
        
        WBIF_IB_String_v1 requestBean = new WBIF_IB_String_v1();
        requestBean.Calculate = calculatePolicy;
        
        return requestBean;
    }
    /**
     * @description mapResponseFields description
     *
     * @param respP (HttpResponse): respP
     * @return Return WBIF_IB_String_v1: Return description
     */
    public static WBIF_IB_String_v1 mapResponseFields(HttpResponse respP){
        
        String jsonStringP = respP.getBody();
        jsonStringP = jsonStringP.replace(DATE_FIELD, REPLACEMENT_DATE_FIELD);
        WBIF_IB_String_v1 responseBean = new WBIF_IB_String_v1();
        if(jsonStringP.contains('{')){
            responseBean = (WBIF_IB_String_v1)responseBean.deserialize( jsonStringP, WBIF_IB_String_v1.class );
        }else{
            responseBean.message = respP.getBody();
        }
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        return responseBean;
    }
    /**
     * @description mapFailedResponseFields description
     *
     * @param statusCodeP (Integer): statusCodeP
     * @param statusP (String): statusP
     * @param messageP (String): messageP
     * @return Return WBIF_IB_String_v1: Return description
     */
    public static WBIF_IB_String_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        WBIF_IB_String_v1 responseBean = new WBIF_IB_String_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    /**
     * @description jsonStringReplace description
     *
     * @param jsonStringP (String): jsonStringP
     * @return  Return String: Return description
     */
    /* This method replaces string values in the JSON String that will be used to send in the request
    * @ Param : jsonStringP(a JSON String parameter value)
    * @ Return : jsonStringP(The same JSON String paramter received as an input)
    */
    public static String jsonStringReplace(String jsonStringP){
        
        jsonStringP = jsonStringP.replace(REPLACEMENT_DATE_FIELD, DATE_FIELD);
        jsonStringP = jsonStringP.replace(ERROR_STRING_FIELD, STRING_FIELD);
        jsonStringP = jsonStringP.replace(BODY_ID, AT_SYMBOL_ID);
        jsonStringP = jsonStringP.replace(LANG, AT_SYMBOL_LANG);
        jsonStringP = jsonStringP.replace(EXCEPTION_TYPE, STRING_TYPE);
        jsonStringP = jsonStringP.replace(INNER_EXCEPTION_TYPE, STRING_TYPE);
        jsonStringP = jsonStringP.replace(PREMIUM_LOADING_TYPE, STRING_TYPE);
        jsonStringP = jsonStringP.replace(BENEFICIARY_OBJ, BENEFICIARY);
        jsonStringP = jsonStringP.replace(DEPENDENT_OBJ, DEPENDENT);
        jsonStringP = jsonStringP.replace(PREMIUM_LOADINGS_STRING, PREMIUM_LOADINGS);
        jsonStringP = jsonStringP.replace(BENEFIT_OBJ, BENEFIT);
        
        return jsonStringP;
    }
    
    /**
     * @description getPolicy description
     *
     * @param beanP (WBIF_IB_String_v1): beanP
     * @return  Return WBIF_IB_String_v1.cls_policy: Return description
     */
    public static WBIF_IB_String_v1.cls_policy getPolicy(WBIF_IB_String_v1 beanP){
        
        WBIF_IB_String_v1.cls_policy policy = new WBIF_IB_String_v1.cls_policy();
        //System.debug('bean: ' + beanP);
        if(beanP.Policy_CreateResponse != null){
            policy = beanP.Policy_CreateResponse.Policy_CreateResult;
            
        }else if(beanP.Policy_AddBenefitResponse != null){
            policy = beanP.Policy_AddBenefitResponse.Policy_AddBenefitResult;
            
        }else if(beanP.CalculateResponse != null){
            policy = beanP.CalculateResponse.CalculateResult;
            
        }else if(beanP.Policy_AddBeneficiaryResponse != null){
            policy = beanP.Policy_AddBeneficiaryResponse.Policy_AddBeneficiaryResult;
            
        }else if(beanP.Policy_AddDependentResponse != null){
            policy = beanP.Policy_AddDependentResponse.Policy_AddDependentResult;
            
        }else if(beanP.ValidatePolicyResponse != null){
            policy = beanP.ValidatePolicyResponse.ValidatePolicyResult;
            
        }else if(beanP.SubmitPolicyResponse != null){
            policy = beanP.SubmitPolicyResponse.SubmitPolicyResult;
        }
        //System.debug('Get Policy: ' + policy);
        return policy;
    }
    
}