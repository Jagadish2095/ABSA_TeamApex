/*
 * Integration Handler for BankCodesUpdateCase Service
 * @author Thabo K Senkomane
 * @created 2020-07-30
 */


public class BankCodesUpdateCase_IH_v1  extends Base_IB{
    
    public static final String INTEGRATION_SERVICE_NAME = 'Bank Codes Update Case';
    
    public static BankCodesUpdateCase_Resp_IB_v1 BankCodesUpdateCase(BankCodesUpdateCase_Req_IB_v1 requestBean) {
        BankCodesUpdateCase_Resp_IB_v1 responseBean = (BankCodesUpdateCase_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, BankCodesUpdateCase_Resp_IB_v1.class);
        return responseBean;
    }
} 

/*   public static BankCodesUpdateCase_Resp_IB_v1 BankCodesUpdateCase(String caseId,String digitalCaseReference,String applicationReason,String applicationStatus,String consultantComments,Boolean isABSABusinessClient
                                                                    Boolean isAccountConductConfirmed, Boolean isAccountNumberConfirmed,Boolean isEmailAddressConfirmed,Boolean isFinancialInstitution,
                                                                     Boolean isNameConfirmed,Boolean isUserTypeConfirmed,String workingHistoryComments){
         return BankCodesUpdateCase(caseId, digitalCaseReference, applicationReason, applicationStatus, consultantComments, isABSABusinessClient, true);
    } */