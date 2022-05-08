/*
 * Controller class for the AVAFSendStatement component
 * @author Danie Booysen
 * @created 2020-11-06
 */
public class AVAFSendStatementController {

    @AuraEnabled
    public static AVAFStatementRequest_Resp_IB_v1 statementRequest(String avafAccNum, String email, String statementType){

        //Format current date into format expected by the service
        DateTime currentDate = Datetime.now();
        String dateOutput = currentDate.format('yyyyMM');

        AVAFStatementRequest_Resp_IB_v1 response = AVAFStatementRequest_IH_v1.AVAFStatementRequest(avafAccNum, email, Integer.valueOf(dateOutput), statementType);
        return response;
    }
}