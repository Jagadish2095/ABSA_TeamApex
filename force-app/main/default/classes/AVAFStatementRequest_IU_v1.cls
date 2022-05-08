/*
 * Integration Utility class for AVAFStatementRequest Service
 * @author Danie Booysen
 * @created 2020-11-06
 */
public class AVAFStatementRequest_IU_v1 {
    public static AVAFStatementRequest_Req_IB_v1 mapRequestFields(String avafAccNum, String email, Integer statementDate, String statementType){
        AVAFStatementRequest_Req_IB_v1 requestBean = new AVAFStatementRequest_Req_IB_v1();
        requestBean.BAPI_SF_STMT_REQ = new AVAFStatementRequest_Req_IB_v1.BAPI_SF_STMT_REQ();

        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        requestBean.BAPI_SF_STMT_REQ.I_USER = currentUser.AB_Number__c;
        requestBean.BAPI_SF_STMT_REQ.I_ACCOUNT = avafAccNum.replaceFirst('^0+','').leftPad(11, '0');
        requestBean.BAPI_SF_STMT_REQ.I_EMAIL_ADDRESS1 = email;
        requestBean.BAPI_SF_STMT_REQ.I_PERIOD_ENDING = statementDate;
        requestBean.BAPI_SF_STMT_REQ.I_STMT_TYPE = statementType;

        return requestBean;
    }
}