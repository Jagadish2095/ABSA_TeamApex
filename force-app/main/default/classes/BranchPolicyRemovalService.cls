/**
 * @description BranchPolicyRemovalService Description
 *
 */
public class BranchPolicyRemovalService {
    
       public static final String PolicyBenefit_SERVICE_NAME = 'PolicyBenefitDelete';
       public static final String BeneficiryaDelete_SERVICE_NAME = 'PolicyBeneficiryaDelete';
       public static final String PolicyDependent_SERVICE_NAME = 'PolicyDependentDelete';
    
    /**
    * @description DeleteBenefit Description
    * @param memberId
    * @param benefitId
    * @param policy
    * @return PolicyRemovalResponse
     */
    public static  PolicyRemovalResponse DeleteBenefit(string memberId,String benefitId,PolicyRemovalRequest.PolicyDetails policy){  
        PolicyRemovalRequest.DeleteBenefit deleteRequest = new   PolicyRemovalRequest.DeleteBenefit();
        deleteRequest.memberId = memberId;
        deleteRequest.benefitId = benefitId;
        deleteRequest.policy = policy;
        
        PolicyRemovalRequest request = new PolicyRemovalRequest();        
        request.Policy_DeleteBenefit = deleteRequest;
            
       PolicyRemovalResponse responseBean = (PolicyRemovalResponse) Sys_Utilities_Integration.integrationServiceCall(request, null, PolicyBenefit_SERVICE_NAME,  PolicyRemovalResponse.class);
       return responseBean;
     
    }
    
        /**
         * @description DeleteBeneficiary Description
         * @param beneficiaryId
         * @param policy
         * @return PolicyRemovalResponse
         */
        public static  PolicyRemovalResponse DeleteBeneficiary(String beneficiaryId, PolicyRemovalRequest.PolicyDetails policy){  
        PolicyRemovalRequest.DeleteBeneficiary deleteRequest = new   PolicyRemovalRequest.DeleteBeneficiary();
        deleteRequest.beneficiaryId = beneficiaryId;
        deleteRequest.policy = policy;
            
        
        PolicyRemovalRequest request = new PolicyRemovalRequest();        
        request.Policy_DeleteBeneficiary = deleteRequest;
            
       PolicyRemovalResponse responseBean = (PolicyRemovalResponse) Sys_Utilities_Integration.integrationServiceCall(request, null, BeneficiryaDelete_SERVICE_NAME,  PolicyRemovalResponse.class);
       return responseBean;
     
    }
        /**
         * @description DeleteDependent Description
         * @param dependentId
         * @param policy
         * @return PolicyRemovalResponse
         */
        public static  PolicyRemovalResponse DeleteDependent(String dependentId, PolicyRemovalRequest.PolicyDetails policy){  
        PolicyRemovalRequest.DeleteDependent deleteRequest = new  PolicyRemovalRequest.DeleteDependent();
        deleteRequest.dependentId = dependentId; 
        deleteRequest.policy = policy;
        
        PolicyRemovalRequest request = new PolicyRemovalRequest();        
        request.Policy_DeleteDependent = deleteRequest;
            
       PolicyRemovalResponse responseBean = (PolicyRemovalResponse) Sys_Utilities_Integration.integrationServiceCall(policy, dependentId, PolicyDependent_SERVICE_NAME,  PolicyRemovalResponse.class);
       return responseBean;
     
    }

}