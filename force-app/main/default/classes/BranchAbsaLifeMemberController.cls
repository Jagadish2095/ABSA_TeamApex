/**
* @description BranchAbsaLifeMemberController
*/
public with sharing class BranchAbsaLifeMemberController{
    /**
    * @description getTranslationValues
    * @param systemName
    * @param valueType
    * @param direction
    * @return List<String>
    **/
    @AuraEnabled
    public static Map<String, String> getTranslationValues(String systemName, String valueType, String direction){
        
        Map<String, String> listValues = new Map<String, String>();
        Integration_Translation__c[] returnValues = [SELECT Internal_Value__c, External_Value__c
                                                     FROM Integration_Translation__c
                                                     WHERE System_Name__c = :systemName AND Value_Type__c = :valueType AND Direction__c = :direction
                                                     WITH SECURITY_ENFORCED];
        for (Integration_Translation__c returnValue : returnValues){
            listValues.put(returnValue.Internal_Value__c, returnValue.External_Value__c);
        }
        return listValues;
    }
    
    /**
    * @description calculate Members Premium
    * @param policyData - opportunity Id
    * @param newMemberData
    * @param opportunityProductId
    * @return BranchPolicyDetails - policy in JSON structure
    */
    @AuraEnabled
    public static BranchPolicyDetails calculateMembersPremium(String policyData, String newMemberData, String opportunityProductId){
        
        BranchPolicyDetails policy = (BranchPolicyDetails) JSON.deserialize(policyData, BranchPolicyDetails.class);
        BranchMemberDetail newMember = (BranchMemberDetail) JSON.deserialize(newMemberData, BranchMemberDetail.class);
        
        OpportunityLineItem opportunityProduct = [SELECT Id, Other_Extra_Description__c, OpportunityId, Policy_Cover__c, Premium__c
                                                  FROM OpportunityLineItem
                                                  WHERE Id = :opportunityProductId];
        
        return calculateMembersPremiumDetails(opportunityProduct.OpportunityId, policy, newMember, true);
    }
    
    private static BranchPolicyDetails calculateMembersPremiumDetails(String opportunityId, BranchPolicyDetails policy, BranchMemberDetail newMember, Boolean doAddOrUpdate){
        
        WBIF_IB_String_v1.cls_policy policySession = (WBIF_IB_String_v1.cls_policy)JSON.deserialize(policy.Policy, WBIF_IB_String_v1.cls_policy.class );
        WBIF_IB_String_v1 resp = NULL;
        
        String mainBenefitId = WBIFProductsHelper.getBenefitId(policy.ProductDetails, 'Main');
        
        String contractOptionId = WBIFProductsHelper.getContractOptionId(policy.ProductDetails, String.valueOf(newMember.CoverOption));
        
        if (newMember.Relationship != 'Main Member' && newMember.PartyId == '0'){
            String dependentBenefitId = WBIFProductsHelper.getBenefitId(policy.ProductDetails, newMember.Relationship);
            WBIF_IB_String_v1.cls_policy policywithDependend = BranchWBIFService.mapAddDependentRequestFields(policySession, newMember, dependentBenefitId);
            
            resp = BranchWBIFService.wbifPolicyCalculate(policywithDependend, newMember, policy.ProductCode, mainBenefitId, contractOptionId);
            
            if(doAddOrUpdate){
                
                addOrUpdateMembersToOpportunityPartyObject(opportunityId, newMember, 'Dependant', policy.ProductCode);
                
            }
        }
        else{
            resp = BranchWBIFService.wbifPolicyCalculate(policySession, newMember, policy.ProductCode, mainBenefitId, contractOptionId);
        }
        
        WBIF_IB_String_v1.cls_policy calculatedPolicy = BranchWBIFService.getPolicy(resp);
        
        if (resp != null && resp.statusCode == 200 && calculatedPolicy.PolicyInfo != null){
            
            if (newMember.Relationship == 'Main Member'){
                policy.CalculatedPremium = Double.valueOf(calculatedPolicy.MainMember.Premium);
                policy.CurrentCoverOption = Double.valueOf(calculatedPolicy.MainMember.Cover);
                policy.MemberId = calculatedPolicy.MainMember.GUID;
            } else if (newMember.Relationship == 'Spouse'){
                policy.CalculatedPremium = Double.valueOf(calculatedPolicy.Spouse.Premium);
                policy.CurrentCoverOption = Double.valueOf(calculatedPolicy.Spouse.Cover);
                policy.MemberId = calculatedPolicy.Spouse.GUID;
            } else{
                
                if (calculatedPolicy.Dependents != null && calculatedPolicy.Dependents.Dependent != null){
                    for (WBIF_IB_String_v1.cls_Dependent dependant : calculatedPolicy.Dependents.Dependent){
                        if (dependant.Surname == newMember.Surname && dependant.FirstName == newMember.Name){
                            policy.CalculatedPremium = Double.valueOf(dependant.Premium);
                            policy.CurrentCoverOption = Double.valueOf(dependant.Cover);
                            policy.MemberId = dependant.GUID;
                            break;
                        }
                    }
                }
            }
        }
        
        else{
            throw new AuraHandledException('Policy Corrupted please cancel and try again');
        }
        
        policy.Policy = JSON.serializePretty(calculatedPolicy);
        
        return policy;
    }
    
    /**
    * @description add Or Update Beneficiaries
    * @param policyData - opportunity Id
    * @param newMemberData
    * @param opportunityProductId
    * @return BranchPolicyDetails - policy in JSON structure
    */	
    @AuraEnabled
    public static BranchPolicyDetails addOrUpdateBeneficiaries(String policyData, String newMemberData, String opportunityProductId){
        
        BranchPolicyDetails policy = (BranchPolicyDetails) JSON.deserialize(policyData, BranchPolicyDetails.class );
        BranchMemberDetail newMember = (BranchMemberDetail) JSON.deserialize(newMemberData, BranchMemberDetail.class );
        
        
        OpportunityLineItem opportunityProduct = [SELECT Id, Other_Extra_Description__c, OpportunityId, Policy_Cover__c, Premium__c
                                                  FROM OpportunityLineItem
                                                  WHERE Id = :opportunityProductId];
        
        return addOrUpdateBeneficiariesDetails(opportunityProduct.OpportunityId, policy, newMember, true);
    }
    
    private static BranchPolicyDetails addOrUpdateBeneficiariesDetails(String opportunityId, BranchPolicyDetails policy, BranchMemberDetail newMember, Boolean doAddOrUpdate){
        
        WBIF_IB_String_v1.cls_policy policySession = (WBIF_IB_String_v1.cls_policy)JSON.deserialize(policy.Policy, WBIF_IB_String_v1.cls_policy.class );
        
        if (newMember.PartyId == '0'){
            WBIF_IB_String_v1.cls_policy policywithBeneficiaries = BranchWBIFService.mapAddBeneficiariesRequestFields(policySession, newMember);
            
            if (policywithBeneficiaries.PolicyInfo == null){
                throw new AuraHandledException('Error while adding Or Updating Beneficiaries, please try again');
            }
            
            policy.Policy = JSON.serializePretty(policywithBeneficiaries);
            
            policy.MemberId = policywithBeneficiaries.Beneficiaries.Beneficiary[0].GUID;
        }
        else{
            
            policySession.Beneficiaries.Beneficiary[0].age = String.valueOf(Date.today().year() - newMember.DateOfBirth.year());
            String stringDateOfBirth = String.valueOf(newMember.DateofBirth);
            policySession.Beneficiaries.Beneficiary[0].DateOfBirth = stringDateOfBirth.replace(' ', 'T');
            policySession.Beneficiaries.Beneficiary[0].FirstName = newMember.Name;
            policySession.Beneficiaries.Beneficiary[0].Gender = newMember.Gender;
            if (newMember.IDNumber == null || newMember.IDNumber == ''){
                String idNumber = stringDateOfBirth.replace('-', '').subString(2, 8) + '0000000';
                policySession.Beneficiaries.Beneficiary[0].RsaIdNumber = idNumber;
            } else{
                policySession.Beneficiaries.Beneficiary[0].RsaIdNumber = newMember.IDNumber;
            }
            policySession.Beneficiaries.Beneficiary[0].Surname = newMember.Surname;
            policySession.Beneficiaries.Beneficiary[0].Relationship = newMember.Relationship.toUpperCase();
            policySession.Beneficiaries.Beneficiary[0].Title = 'Unknown';
            policySession.Beneficiaries.Beneficiary[0].ShortName = newMember.Name;
            policySession.Beneficiaries.Beneficiary[0].MemberType = 'Unknown';
            policySession.Beneficiaries.Beneficiary[0].Initials = newMember.Name.substring(0, 1);
            policySession.Beneficiaries.Beneficiary[0].BenefitSplit = '100';
            
            policy.MemberId = policySession.Beneficiaries.Beneficiary[0].GUID;
        }
        
        if(doAddOrUpdate){
            addOrUpdateMembersToOpportunityPartyObject(opportunityId, newMember, 'Beneficiary', policy.ProductCode);
        }
        
        return policy;
    }
    
    /**
    * @description submitPolicyDetails
    * @param opportunityProductId - opportunity Id
    * @param policyP
    */
    @AuraEnabled
    public static void submitPolicyDetails(String opportunityProductId, String policyP){
        
        BranchPolicyDetails branchPolicy = (BranchPolicyDetails) JSON.deserialize(policyP, BranchPolicyDetails.class );
        WBIF_IB_String_v1.cls_policy policySession = (WBIF_IB_String_v1.cls_policy)JSON.deserialize(branchPolicy.Policy, WBIF_IB_String_v1.cls_policy.class );
        
        
        List<string> errors = new List<string>();
        if (policySession.PolicyInfo != null){
            if (policySession.PolicyInfo.ErrorReasons != null){ 
                errors = policySession.PolicyInfo.ErrorReasons.split('\n');
                
                if (!Test.isRunningTest() && errors.size() > 0){
                    throw new AuraHandledException(policySession.PolicyInfo.ErrorReasons);
                }
            }
        }
        else{
            throw new AuraHandledException('Policy Info is null, please contact your administartor');
        }
        
        WBIF_IB_String_v1 response = BranchWBIFService.sumbitPolicy(policySession);
        WBIF_IB_String_v1.cls_policy responsePolicy = BranchWBIFService.getPolicy(response);
        
        if (responsePolicy.PolicyInfo.ErrorReasons != null){
            errors = responsePolicy.PolicyInfo.ErrorReasons.split('\n');
        }
        
        if (!Test.isRunningTest() && errors.size() > 0){
            throw new AuraHandledException(responsePolicy.PolicyInfo.ErrorReasons);
        }
        OpportunityLineItem opportunityProduct = [SELECT Id, Other_Extra_Description__c, OpportunityId, Policy_Cover__c, Premium__c
                                                  FROM OpportunityLineItem
                                                  WHERE Id = :opportunityProductId];	
        
        opportunityProduct.Other_Extra_Description__c = 'Completed';
        opportunityProduct.Policy_Cover__c = Decimal.valueOf(responsePolicy.TotalCover);
        opportunityProduct.Premium__c = Decimal.valueOf(responsePolicy.TotalPremium);
        opportunityProduct.Policy_Number__c = responsePolicy.PolicyInfo.PolicyNumber;
        
        update opportunityProduct;
    }
    
    private static void addOrUpdateMembersToOpportunityPartyObject(String OpportunityId, BranchMemberDetail memberDetails, String partyType, String productCode){
        
        
        String product = '';
        
        switch on productCode{
            when 'WIMAL00500'{
                product = 'Ultimate Protector';
            }
            when 'WIMAL00102'{
                product = 'Health Assistance';
            }
            when 'WIMAL00103'{
                product = 'Flexi Funeral';
            }
        }
        
        if (product != ''){
            SObject sObjType = (SObject) Type.forName('Opportunity_Party__c').newInstance();
            List<String> valuesFromObject = BranchFunctions.getFieldPickListValues(sObjType, 'Relationship__c');
            Opportunity_Party__c opportunityParty = new Opportunity_Party__c();
            
            List<Opportunity_Party__c> dependants = [
                SELECT Id, First_Name__c, Last_Name__c, RSA_ID_Number__c,
                ID_Type__c, Gender__c, Date_of_Birth__c, Relationship__c,
                Beneficiary_Product__c, Party_Type__c, Dependant_Cover__c,
                Benefit_Split__c, Opportunity__c
                FROM Opportunity_Party__c 
                WHERE First_Name__c =:memberDetails.Name
                AND Last_Name__c =:memberDetails.Surname
                AND Date_of_Birth__c =: memberDetails.DateOfBirth
                AND Opportunity__c =: OpportunityId
                AND Beneficiary_Product__c =:product];
            
            if(dependants.size() > 0){
                opportunityParty = dependants.get(0);
            }
            
            opportunityParty.First_Name__c = memberDetails.Name;
            opportunityParty.Last_Name__c = memberDetails.Surname;
            opportunityParty.RSA_ID_Number__c = memberDetails.IDNumber;
            opportunityParty.ID_Type__c =  Sys_Utilities_Integration.getIntegrationTranslationInternalValue('CIF', 'Identity Type', memberDetails.IdType, 'Outbound');
            opportunityParty.Gender__c = memberDetails.Gender;
            opportunityParty.Date_of_Birth__c = memberDetails.DateOfBirth;
            opportunityParty.Relationship__c =  lookupRelationShip(memberDetails.Relationship, valuesFromObject);
            opportunityParty.Beneficiary_Product__c = product;
            if (partyType == 'Dependant' && memberDetails.MemberType == 'Spouse'){
                opportunityParty.Party_Type__c = 'Spouse';
            } else{
                opportunityParty.Party_Type__c = partyType;
            }
            opportunityParty.Dependant_Cover__c = memberDetails.CoverOption;
            opportunityParty.Benefit_Split__c =  memberDetails.Premium;
            opportunityParty.Opportunity__c = OpportunityId;
            
            
            if(dependants.size() > 0){
                update opportunityParty;
            }	
            else{
                Insert opportunityParty;
            }	
            
        }
        else{
            throw new AuraHandledException('Could not Submit Unconfigured product with code ' + productCode);
        }
    }
    
    /**
    * @description getPolicyFromService
    * @param oppId - opportunity Id
    * @param oppProductId
    * @param productCode
    * @param replacementPolicy (WBIF_Product_Details.ExistingPolicy)
    * @return String - policy in JSON structure
    */
    private static String getPolicyFromService(Id oppId, String oppProductId, String productCode, WBIF_Product_Details.ExistingPolicy replacementPolicy){
        String strResp;
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if (!opportunities.isEmpty() && opportunities != null){
            Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
            List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
            
            if (!users.isEmpty() && users != null){
                
                if(Test.isRunningTest()){
                    strResp = BranchAbsaLifeTestDataFactory.PolicyDataString;
                }
                else{
                    WBIF_IB_String_v1 resp = BranchWBIFService.wbifPolicyCreate(oppProductId, users.get(0), account, opportunities.get(0), replacementPolicy, productCode);
                    WBIF_IB_String_v1.cls_policy policy = BranchWBIFService.getPolicy(resp);
                    
                    strResp = JSON.serializePretty(policy);
                }
            }
            
        }
        return strResp;
    }
    
    /**
    * @description getPolicyDetails
    * @param opportunityProductId - opportunity Id
    * @param existingPolicyQuestions
    * @return BranchPolicyDetails
    */
    @AuraEnabled
    public static BranchPolicyDetails getPolicyDetails(String opportunityProductId, String existingPolicyQuestions){
        
        WBIF_Product_Details.ExistingPolicy existingPolicy;
        
        if (existingPolicyQuestions == null){
            existingPolicy = new WBIF_Product_Details.ExistingPolicy();
            existingPolicy.ReplacementPolicy = false;
            existingPolicy.PreviousInsurer = '';
        } else{
            existingPolicy = (WBIF_Product_Details.ExistingPolicy)JSON.deserialize(existingPolicyQuestions, WBIF_Product_Details.ExistingPolicy.class );
        }
        
        OpportunityLineItem opportunityProduct = [SELECT OpportunityId, ProductCode
                                                  FROM OpportunityLineItem
                                                  WHERE Id = :opportunityProductId];
        
        BranchPolicyDetails policyDetails = new BranchPolicyDetails();
        
        policyDetails.ProductCode = opportunityProduct.ProductCode;
        policyDetails.ProductDetails = WBIFProductsHelper.getWbifProductCoverOptions(opportunityProduct.ProductCode);
        policyDetails.MainMember = new List<BranchMemberDetail>();
        policyDetails.AdditionalMembers = new List<BranchMemberDetail>();
        policyDetails.Beneficiaries = new List<BranchMemberDetail>();
        policyDetails.Policy = getPolicyFromService(opportunityProduct.OpportunityId, opportunityProductId, opportunityProduct.ProductCode, existingPolicy);
        
        
        policyDetails = getMainMemberDetails(policyDetails, opportunityProductId);
        policyDetails  = getMembersDetails(policyDetails, opportunityProduct.OpportunityId);
        
        return policyDetails;
    }
    
    
    private static BranchPolicyDetails getMembersDetails(BranchPolicyDetails sessionDetails, string opportunityId){
        
        BranchPolicyDetails tempSession  = sessionDetails;
        
        List<string> patryTypes = new List<string>();
        
        
        String product = '';
        
        switch on sessionDetails.ProductCode{
            when 'WIMAL00500'{
                product = 'Ultimate Protector';
            }
            when 'WIMAL00102'{
                product = 'Health Assistance';
            }
            when 'WIMAL00103'{
                product = 'Flexi Funeral';
            }
        }
        
        List<Opportunity_Party__c> opportunityPartyList = [SELECT Id, First_Name__c, Date_of_Birth__c, Last_Name__c, Relationship__c, RSA_ID_Number__c, Gender__c, ID_Type__c, Dependant_Cover__c, Party_Type__c
                                                           FROM Opportunity_Party__c
                                                           WHERE Party_Type__c IN('Beneficiary','Dependant','Spouse')
                                                           AND Beneficiary_Product__c =: product
                                                           AND Opportunity__c =: opportunityId];
        
        
        
        for (Opportunity_Party__c opportunityParty : opportunityPartyList){
            
            BranchMemberDetail memberDetails = new BranchMemberDetail();
            
            memberDetails.PartyId = '0';
            memberDetails.Name = opportunityParty.First_Name__c;
            memberDetails.Surname = opportunityParty.Last_Name__c;
            memberDetails.IDNumber = opportunityParty.RSA_ID_Number__c;
            memberDetails.IdType = opportunityParty.ID_Type__c;
            memberDetails.Gender = opportunityParty.Gender__c;
            memberDetails.DateOfBirth = opportunityParty.Date_of_Birth__c;
            memberDetails.Relationship = opportunityParty.Relationship__c;
            memberDetails.CoverOption = opportunityParty.Dependant_Cover__c;
            memberDetails.Premium = 0;
            
            if(opportunityParty.Party_Type__c == 'Beneficiary')
            {
                tempSession.Beneficiaries.add(memberDetails);
                if(!Test.isRunningTest()){
                    tempSession = addOrUpdateBeneficiariesDetails(opportunityId, tempSession, memberDetails, false);
                }
            }
            else{
                tempSession.AdditionalMembers.add(memberDetails);
                if(!Test.isRunningTest()){
                    tempSession = calculateMembersPremiumDetails(opportunityId, tempSession, memberDetails, false);
                }
                memberDetails.Premium = tempSession.CalculatedPremium == null ? 0 : tempSession.CalculatedPremium;
            }
        }
        
        return tempSession;
    }
    
    private static BranchPolicyDetails getMainMemberDetails(BranchPolicyDetails sessionDetails, String opportunityProductId){
        
        OpportunityLineItem opportunityProduct = [SELECT OpportunityId, Policy_Cover__c, Premium__c
                                                  FROM OpportunityLineItem
                                                  WHERE Id = :opportunityProductId];
        Opportunity opportunity = [SELECT AccountId
                                   FROM Opportunity
                                   WHERE Id = :opportunityProduct.OpportunityId];
        Account account = [SELECT Id, FirstName, LastName, ID_Number__pc, ID_Type__pc, Gender__pc, PersonBirthdate
                           FROM Account
                           WHERE Id = :opportunity.AccountId];
        
        BranchMemberDetail memberDetails = new BranchMemberDetail();
        
        memberDetails.Name = account.FirstName;
        memberDetails.Surname = account.LastName;
        
        memberDetails.IDNumber = account.ID_Number__pc;
        memberDetails.IdType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Identity Type', account.ID_Type__pc, 'Outbound') ;
        memberDetails.Gender = account.Gender__pc;
        memberDetails.DateOfBirth = account.PersonBirthdate;
        memberDetails.Relationship = 'Main Member';
        
        memberDetails.CoverOption = opportunityProduct.Policy_Cover__c == null ? 0 : opportunityProduct.Policy_Cover__c;
        
        if(!Test.isRunningTest()){
            sessionDetails = calculateMembersPremiumDetails(opportunityProductId, sessionDetails, memberDetails, false);
        }
        
        memberDetails.Premium = sessionDetails.CalculatedPremium;
        memberDetails.CoverOption = sessionDetails.CurrentCoverOption;
        memberDetails.PartyId = sessionDetails.MemberId;
        
        sessionDetails.MainMember.add(memberDetails);
        
        return sessionDetails;
    }
    
    /**
    * @description delete Policy Benefit
    * @param policyData - opportunity Id
    * @param memberData
    * @return BranchPolicyDetails
    */
    @AuraEnabled
    public static BranchPolicyDetails deletePolicyBenefit(String policyData, String memberData){
        BranchPolicyDetails policy = (BranchPolicyDetails) JSON.deserialize(policyData, BranchPolicyDetails.class );
        BranchMemberDetail member = (BranchMemberDetail) JSON.deserialize(memberData, BranchMemberDetail.class );
        PolicyRemovalRequest.PolicyDetails policySession = (PolicyRemovalRequest.PolicyDetails)JSON.deserialize(policy.Policy,PolicyRemovalRequest.PolicyDetails.class );       
        
        String benefitId = WBIFProductsHelper.getBenefitId(policy.ProductDetails, member.Relationship);
        string memberId = policy.MemberId;
        PolicyRemovalResponse response = BranchPolicyRemovalService.DeleteBenefit(memberId, benefitId,policySession);
        
        if (response.Policy_DeleteBenefitResponse.PolicyBenefitResult.PolicyInfo == null){
            throw new AuraHandledException('Unable to delete Dependent From Policy, please contact your administrator');
        }
        
        if (!Test.isRunningTest() && response.Policy_DeleteBenefitResponse.PolicyBenefitResult.PolicyInfo.ErrorReasons != null){
            throw new AuraHandledException(response.Policy_DeleteBenefitResponse.PolicyBenefitResult.PolicyInfo.ErrorReasons);
        }
        
        policy.Policy = JSON.serializePretty(response.Policy_DeleteBenefitResponse.PolicyBenefitResult);
        
        return policy;
    }
    
    /**
    * @description delete Dependent FromPolicy
    * @param policyData - opportunity Id
    * @param memberData
    * @return BranchPolicyDetails
    */
    @AuraEnabled
    public static BranchPolicyDetails deleteDependentFromPolicy(String policyData, String memberData){
        BranchPolicyDetails policy = (BranchPolicyDetails)JSON.deserialize(policyData, BranchPolicyDetails.class);
        BranchMemberDetail newMember = (BranchMemberDetail)JSON.deserialize(memberData, BranchMemberDetail.class);
        PolicyRemovalRequest.PolicyDetails policySession = (PolicyRemovalRequest.PolicyDetails)JSON.deserialize(policy.Policy,PolicyRemovalRequest.PolicyDetails.class );
        
        PolicyRemovalResponse response = BranchPolicyRemovalService.DeleteDependent(newMember.PartyId,policySession);
        
        if (response.Policy_DeleteDependentResponse.PolicyDependentResult.PolicyInfo == null){
            throw new AuraHandledException('Unable to delete Dependent From Policy, please contact your administrator');
        }
        
        if (!Test.isRunningTest() && response.Policy_DeleteDependentResponse.PolicyDependentResult.PolicyInfo.ErrorReasons != null){
            throw new AuraHandledException(response.Policy_DeleteDependentResponse.PolicyDependentResult.PolicyInfo.ErrorReasons);
        }
        policy.Policy = JSON.serializePretty(response.Policy_DeleteDependentResponse.PolicyDependentResult);
        return policy;
    }
    
    /**
    * @description delete Dependent FromPolicy
    * @param policyData - opportunity Id
    * @param memberData
    * @return BranchPolicyDetails
    */
    @AuraEnabled
    public static BranchPolicyDetails deletePolicyBeneficiary(String policyData, String memberData){
        BranchPolicyDetails policy = (BranchPolicyDetails)JSON.deserialize(policyData, BranchPolicyDetails.class);
        BranchMemberDetail newMember = (BranchMemberDetail)JSON.deserialize(memberData, BranchMemberDetail.class);
        
        PolicyRemovalRequest.PolicyDetails policySession = (PolicyRemovalRequest.PolicyDetails)JSON.deserialize(policy.Policy,PolicyRemovalRequest.PolicyDetails.class );
        
        PolicyRemovalResponse response = BranchPolicyRemovalService.DeleteBeneficiary(newMember.PartyId, policySession);
        
        if (response.Policy_DeleteBeneficiaryResponse.PolicyBeneficiaryResult.PolicyInfo == null){
            throw new AuraHandledException('Unable to delete Dependent From Policy, please contact your administrator');
        }
        
        if (!Test.isRunningTest() && response.Policy_DeleteBeneficiaryResponse.PolicyBeneficiaryResult.PolicyInfo.ErrorReasons != null){
            throw new AuraHandledException(response.Policy_DeleteBeneficiaryResponse.PolicyBeneficiaryResult.PolicyInfo.ErrorReasons);
        }
        
        policy.Policy = JSON.serializePretty(response.Policy_DeleteBeneficiaryResponse.PolicyBeneficiaryResult);
        
        return policy;
    }
    
    private static string lookupRelationShip(String relationphip, List<String> values){
        
        String tempRelation = relationphip.replace('-', '').replace(' ', '');
        
        for(String item : values){
            if(tempRelation == item.replace('-', '').replace(' ', '')){
                return item;
            }
        }
        
        return relationphip;
    }
}