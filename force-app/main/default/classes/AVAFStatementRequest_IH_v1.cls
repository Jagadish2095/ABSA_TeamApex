/*
 * Integration Handler class for AVAFStatementRequest Service: sap/statementrequest
 * @author Danie Booysen
 * @created 2020-11-06
 */
public class AVAFStatementRequest_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'AVAF SAP Statement Request';

    public static AVAFStatementRequest_Resp_IB_v1 AVAFStatementRequest (String avafAccNum, String email, Integer statementDate, String statementType){
        AVAFStatementRequest_Req_IB_v1 requestBean = AVAFStatementRequest_IU_v1.mapRequestFields(avafAccNum, email, statementDate, statementType);

        AVAFStatementRequest_Resp_IB_v1 responseBean = (AVAFStatementRequest_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AVAFStatementRequest_Resp_IB_v1.class);
        return responseBean;
    }
}