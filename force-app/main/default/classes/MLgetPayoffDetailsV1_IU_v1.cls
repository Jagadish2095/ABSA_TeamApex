/*
 * Integration Utilities for MLgetPayoffDetailsV1 Service
 * @author Jason Quevauvilliers
 * @created 2020-10-20
 */
public class MLgetPayoffDetailsV1_IU_v1 extends Base_IB {
    public static MLgetPayoffDetailsV1_Req_IB_v1 mapRequestFields(String mortgageLoanNo, String payAllAcc, String effectiveDate, String includeCommit) {
        // Query corpCode, branchCode & tellerCode from the current user
        // effectiveDate should be todays date in YYYYMMDD format
        UsersSelector userSelectorRef = new UsersSelector();
        User currentUser = userSelectorRef.selectById(UserInfo.getUserId());

        MLgetPayoffDetailsV1_Req_IB_v1 requestBean = new MLgetPayoffDetailsV1_Req_IB_v1();
        requestBean.mLgetPayoffDetailsV1 = new MLgetPayoffDetailsV1_Req_IB_v1.MLgetPayoffDetailsV1();
        requestBean.mLgetPayoffDetailsV1.nbsapdpi = new MLgetPayoffDetailsV1_Req_IB_v1.Nbsapdpi();
        requestBean.mLgetPayoffDetailsV1.nbsmsgi = new MLgetPayoffDetailsV1_Req_IB_v1.Nbsmsgi();
        requestBean.mLgetPayoffDetailsV1.mlp778i = new MLgetPayoffDetailsV1_Req_IB_v1.Mlp778i();

        requestBean.mLgetPayoffDetailsV1.nbsapdpi.channel = 'BDP';
        requestBean.mLgetPayoffDetailsV1.nbsapdpi.application = 'BDP';
        requestBean.mLgetPayoffDetailsV1.nbsapdpi.trace = 'Y';

        requestBean.mLgetPayoffDetailsV1.nbsmsgi.msgLanguage = 'E';
        requestBean.mLgetPayoffDetailsV1.nbsmsgi.msgTarget = 'STD';
        requestBean.mLgetPayoffDetailsV1.nbsmsgi.finalMsgId = new MLgetPayoffDetailsV1_Req_IB_v1.FinalMsgId();

        requestBean.mLgetPayoffDetailsV1.mlp778i.origin = 'B';
        requestBean.mLgetPayoffDetailsV1.mlp778i.corpCode = 'ABS';
        requestBean.mLgetPayoffDetailsV1.mlp778i.branchCode = currentUser.SiteCode__c; //'8091';
        requestBean.mLgetPayoffDetailsV1.mlp778i.tellerCode = currentUser.Teller_Operator_Code__c; // '999999';

        requestBean.mLgetPayoffDetailsV1.mlp778i.effectiveDate = effectiveDate; //string.valueOf(system.now().format('yyyyMMdd'));
        requestBean.mLgetPayoffDetailsV1.mlp778i.includeCommit = includeCommit;
        requestBean.mLgetPayoffDetailsV1.mlp778i.payAllAcc = payAllAcc;
        requestBean.mLgetPayoffDetailsV1.mlp778i.mortgageLoanNo = mortgageLoanNo;

        return requestBean;
    }
}