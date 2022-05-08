/*
 * Controller class for MemberMaintenance cmp
 * @author Jason Quevauvilliers
 * @created 2020-10-15
 */
public class MemberMaintenance {

    //Method called via init on MemberMaintenance cmp
    //returns the response from the LAListPolicyDetailsByPolicyV7 Service call with RolePlayers that have a benefitCode
    //@author Jason Quevauvilliers
    @AuraEnabled
    public static LAListPolicyDetailsByPolicyV7_Resp_IB_v1 getPolicyDetailsByPolicyWithBenefits(String policyNumberP) {
        List<LAListPolicyDetailsByPolicyV7_Resp_IB_v1.RolePlayersDetails> rolePlayerList = new List<LAListPolicyDetailsByPolicyV7_Resp_IB_v1.RolePlayersDetails>();
        LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean =  LAListPolicyDetailsByPolicyV7_IH_v1.LAListPolicyDetailsByPolicyV7(policyNumberP);
        if (
            responseBean != null &&
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response != null &&
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o != null &&
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails != null
        ) {
            for (LAListPolicyDetailsByPolicyV7_Resp_IB_v1.RolePlayersDetails rolePlayer : responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails) {
                if (rolePlayer.benefitCode != null) {
                    rolePlayerList.add(rolePlayer);
                }
            }
            responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails = rolePlayerList;
        }

        return responseBean;
    }
}