/*
 * Request Integration Bean for AVAFStatementRequest Service
 * @author Danie Booysen
 * @created 2020-11-06
 */
public class AVAFStatementRequest_Req_IB_v1 extends Base_IB {
    public BAPI_SF_STMT_REQ BAPI_SF_STMT_REQ;

    public class BAPI_SF_STMT_REQ{
        public String I_ACCOUNT;
        public String I_USER;
        public String I_EMAIL_ADDRESS1;
        public Integer I_PERIOD_ENDING;
        public String I_STMT_TYPE;
    }

    public static AVAFStatementRequest_Req_IB_v1 createDummyRequest(){
        AVAFStatementRequest_Req_IB_v1 requestBean = new AVAFStatementRequest_Req_IB_v1();
        requestBean.BAPI_SF_STMT_REQ = new AVAFStatementRequest_Req_IB_v1.BAPI_SF_STMT_REQ();

        requestBean.BAPI_SF_STMT_REQ.I_ACCOUNT = '00077129389';
        requestBean.BAPI_SF_STMT_REQ.I_USER = 'ABZZ123';
        requestBean.BAPI_SF_STMT_REQ.I_EMAIL_ADDRESS1 = 'test@example.co.za';
        requestBean.BAPI_SF_STMT_REQ.I_PERIOD_ENDING = 202009;
        requestBean.BAPI_SF_STMT_REQ.I_STMT_TYPE = 'D';

        return requestBean;
    }
}