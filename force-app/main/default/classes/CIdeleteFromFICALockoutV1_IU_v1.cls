/**
 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CIdeleteFromFICALockoutV1_IU_v1 {
    public static CIdeleteFromFICALockoutV1_Req_IB_v1 mapRequiredFields(String clientCode, String dateIdentified, String dateVerified) {

        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

        CIdeleteFromFICALockoutV1_Req_IB_v1 requestBean = new CIdeleteFromFICALockoutV1_Req_IB_v1();
        requestBean.CIdeleteFromFICALockoutV1 = new CIdeleteFromFICALockoutV1_Req_IB_v1.CIdeleteFromFICALockoutV1();
        requestBean.CIdeleteFromFICALockoutV1.nbsapli = new CIdeleteFromFICALockoutV1_Req_IB_v1.Nbsapli();
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi = new CIdeleteFromFICALockoutV1_Req_IB_v1.Nbsmsgi();
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.finalMsgId = new CIdeleteFromFICALockoutV1_Req_IB_v1.FinalMsgId();
        requestBean.CIdeleteFromFICALockoutV1.cip600i = new CIdeleteFromFICALockoutV1_Req_IB_v1.Cip600i();

        requestBean.CIdeleteFromFICALockoutV1.nbsapli.application = 'BDP';
        requestBean.CIdeleteFromFICALockoutV1.nbsapli.channel = 'BDP';
        requestBean.CIdeleteFromFICALockoutV1.nbsapli.trace = 'Y';

        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CIdeleteFromFICALockoutV1.nbsmsgi.msgTarget = 'STD';

        requestBean.CIdeleteFromFICALockoutV1.cip600i.branchCode = System.Label.CIdeleteFromFICALockoutV1;//currentUser.SiteCode__c;//'5920' delNewToBank;
        requestBean.CIdeleteFromFICALockoutV1.cip600i.clientCode = clientCode;//'TREEA+ 020';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.dateIdentified = dateIdentified;//'20200623';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.dateVerified = dateVerified;//'20200623';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.delNewToBank = System.Label.delNewToBank;//'Y';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.employeeIdentified = currentUser.EmployeeNumber;//employeeIdentified;//currentUser.Teller_Operator_Code__c;//'999999';
        requestBean.CIdeleteFromFICALockoutV1.cip600i.employeeVerified = currentUser.EmployeeNumber;//employeeVerified;//currentUser.Teller_Operator_Code__c;//'999999';

		return requestBean;
    }
}