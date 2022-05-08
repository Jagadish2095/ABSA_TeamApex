/*
 * Controller class for BehaviouralRewardsManager cmp
 * @author Jason Quevauvilliers
 * @created 2020-10-27
 */
public class BehaviouralRewardsManagerController {

    @AuraEnabled
    public static void transferCase(String serviceGroupName, String serviceTypeName, String caseId) {

        CaseTransferActionExt.transferCase(serviceGroupName, serviceTypeName, caseId);
    }
}