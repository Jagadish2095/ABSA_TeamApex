/*
 * Integration Utility class for vBlistusersv1 Service
 * @author Mashudu Raidimi
 * @created 2020-07-15
 */
public class vBlistusersv1_IU_v1 {

    public static vBlistusersv1_Req_IB_v1 mapRequestFields(String accNo,String userNo , String cifKey){
        vBlistusersv1_Req_IB_v1 requestBean = new vBlistusersv1_Req_IB_v1();
        requestBean.VBlistUsersV1 = new vBlistusersv1_Req_IB_v1.VBlistUsersV1();
        requestBean.VBlistUsersV1.nbsapdpi = new vBlistusersv1_Req_IB_v1.Nbsapdpi();
        requestBean.VBlistUsersV1.nbsapdpi.application = 'BDP';
        requestBean.VBlistUsersV1.nbsapdpi.channel = 'BDP';
        requestBean.VBlistUsersV1.nbsapdpi.trace = 'Y';
        requestBean.VBlistUsersV1.nbsmsgi = new vBlistusersv1_Req_IB_v1.Nbsmsgi();
        requestBean.VBlistUsersV1.nbsmsgi.finalMsgId = new vBlistusersv1_Req_IB_v1.FinalMsgId();
        requestBean.VBlistUsersV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.VBlistUsersV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        requestBean.VBlistUsersV1.nbsmsgi.msgLanguage = 'E';
        requestBean.VBlistUsersV1.nbsmsgi.msgTarget = 'STD';
        requestBean.VBlistUsersV1.vbp451i = new vBlistusersv1_Req_IB_v1.Vbp451i();
        requestBean.VBlistUsersV1.vbp451i.accNo = accNo;
        requestBean.VBlistUsersV1.vbp451i.custId = '0';
        requestBean.VBlistUsersV1.vbp451i.userNo = userNo;
        requestBean.VBlistUsersV1.vbp451i.cifKey = cifKey;
        return requestBean;
    }
}