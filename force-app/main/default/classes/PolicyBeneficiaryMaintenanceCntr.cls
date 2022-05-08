/*
 * PolicyBeneficiaryMaintenanceCntr for getting Policy Beneficiary details
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-07-10
 * @W-006912
 */
public class PolicyBeneficiaryMaintenanceCntr {
    @AuraEnabled
    public static LAListPolicyDetailsByPolicyV7_Resp_IB_v1 getBeneficiaryDetails(String policyNumber, List<String> roleTypes) {
        List<LAListPolicyDetailsByPolicyV7_Resp_IB_v1.RolePlayersDetails> reducedRolePlayerDetails = new List<LAListPolicyDetailsByPolicyV7_Resp_IB_v1.RolePlayersDetails>();
        LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean = LAListPolicyDetailsByPolicyV7_IH_v1.LAListPolicyDetailsByPolicyV7(policyNumber);

        if (
            responseBean != null &&
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response != null &&
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o != null &&
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails != null
        ) {
            for (LAListPolicyDetailsByPolicyV7_Resp_IB_v1.RolePlayersDetails rolePlayer : responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails) {
                if (roleTypes.contains(rolePlayer.roleType)) {
                    reducedRolePlayerDetails.add(rolePlayer);
                }
            }
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails = reducedRolePlayerDetails;
        }

        return responseBean;
    }

    /*
     * @author  Chandra Bhushan Singh : ABSA
     * @version v1.0
     * @since   2020-07-20
     * @W-006912
     */
    @AuraEnabled
    public static LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 LAUpdateBeneficiaryDetailsV2(String jsonString) {
        LAUpdateBeneficiaryDetailsV2_Req_IB_v1 requestBean = (LAUpdateBeneficiaryDetailsV2_Req_IB_v1) JSON.deserialize(jsonString, LAUpdateBeneficiaryDetailsV2_Req_IB_v1.class);
        return LAUpdateBeneficiaryDetailsV2_IH_v1.LAUpdateBeneficiaryDetailsV2(requestBean);
    }

    /*
     * @author  Chandra Bhushan Singh : ABSA
     * @version v1.0
     * @since   2021-02-10
     * @W-007776
     */
    @AuraEnabled
    public static PolicyLoadByRefNo_Resp_IB_v1 getBeneficiaryDetailsForExergy(String policyNumber) {
        List<PolicyLoadByRefNo_Resp_IB_v1.V3_DC2ClientRole> reducedV3DC2ClientRoles = new List<PolicyLoadByRefNo_Resp_IB_v1.V3_DC2ClientRole>();
        PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);

        if (
            responseBean != null &&
            responseBean.Policy_LoadByRefNoResponse != null &&
            responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult != null &&
            responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts != null &&
            responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract != null &&
            responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles != null &&
            responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles.V3_DC2ClientRole != null
        ) {
            for (PolicyLoadByRefNo_Resp_IB_v1.V3_DC2ClientRole v3DC2ClientRole : responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles.V3_DC2ClientRole) {
                if (v3DC2ClientRole.RoleID == '5') {
                    reducedV3DC2ClientRoles.add(v3DC2ClientRole);
                }
            }
            responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.ClientRoles.V3_DC2ClientRole = reducedV3DC2ClientRoles;
        }
        return responseBean;
    }

    /*
     * @author  Chandra Bhushan Singh : ABSA
     * @version v1.0
     * @since   2021-02-12
     * @W--007772,007778,007777,007783
     */
    @AuraEnabled
    public static ContractCaptureBeneficiary_Resp_IB_v1 contractCaptureBeneficiary(String jsonString) {
        ContractCaptureBeneficiary_Req_IB_v1 requestBean = (ContractCaptureBeneficiary_Req_IB_v1) JSON.deserialize(jsonString, ContractCaptureBeneficiary_Req_IB_v1.class);
        return ContractCaptureBeneficiary_IH_v1.contractCaptureBeneficiary(requestBean);
    }

    /*
     * @author  Chandra Bhushan Singh : ABSA
     * @version v1.0
     * @since   2021-02-15
     * @W-007772,007778,007777,007783
     */
    @AuraEnabled
    public static String getSessionGID() {
        return ExergyLoginController.getSessionId();
    }
}