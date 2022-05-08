/*
* Integration Utility Bean for IBlistBeneficiariesV1 Service
* @author Rudolf Niehaus
* @created 2020-03-19
*/

public class IBlistBeneficiariesV1_IU_v1 {

    /* Creates a request bean
* @param: accountNumber
* @param: siteCode
* @param: maxRetrieve
* @return: IBlistBeneficiariesV1_Req_IB_v1 bean object
*/
    public static IBlistBeneficiariesV1_Req_IB_v1 mapRequestFields(String accountNumber, String branch, String subBranch, String siteType,
                                                                   String teller, String manager, String supervisor) {

        IBlistBeneficiariesV1_Req_IB_v1 requestBean = new IBlistBeneficiariesV1_Req_IB_v1();
        requestBean.IBlistBeneficiariesV1 = new IBlistBeneficiariesV1_Req_IB_v1.IBlistBeneficiariesV1();
        requestBean.IBlistBeneficiariesV1.nbsapdpi = new IBlistBeneficiariesV1_Req_IB_v1.Nbsapdpi();
        requestBean.IBlistBeneficiariesV1.nbsmsgi = new IBlistBeneficiariesV1_Req_IB_v1.Nbsmsgi();
        requestBean.IBlistBeneficiariesV1.nhp457i = new IBlistBeneficiariesV1_Req_IB_v1.nhp457i();
        requestBean.IBlistBeneficiariesV1.nbsmsgi.finalMsgId = new IBlistBeneficiariesV1_Req_IB_v1.FinalMsgId();

        requestBean.IBlistBeneficiariesV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.IBlistBeneficiariesV1.nbsapdpi.application = 'SALESFOR';
        requestBean.IBlistBeneficiariesV1.nbsapdpi.trace = 'Y';

        requestBean.IBlistBeneficiariesV1.nbsmsgi.msgLanguage = 'E';
        requestBean.IBlistBeneficiariesV1.nbsmsgi.msgTarget = 'STD';
        requestBean.IBlistBeneficiariesV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.IBlistBeneficiariesV1.nbsmsgi.finalMsgId.finalMsgCode = '';

        requestBean.IBlistBeneficiariesV1.nhp457i.agencyCode = '034';
        requestBean.IBlistBeneficiariesV1.nhp457i.workstation = '99';
        requestBean.IBlistBeneficiariesV1.nhp457i.instructionType = 'VP';
        requestBean.IBlistBeneficiariesV1.nhp457i.pageKey = '1e';

        requestBean.IBlistBeneficiariesV1.nhp457i.accessAccount = accountNumber;
        requestBean.IBlistBeneficiariesV1.nhp457i.branch = branch;
        requestBean.IBlistBeneficiariesV1.nhp457i.subBranch = subBranch;
        requestBean.IBlistBeneficiariesV1.nhp457i.siteType = siteType;
        requestBean.IBlistBeneficiariesV1.nhp457i.teller = teller;
        requestBean.IBlistBeneficiariesV1.nhp457i.manager = manager;
        requestBean.IBlistBeneficiariesV1.nhp457i.supervisor = supervisor;

        System.debug('IBlistBeneficiariesV1 Request Bean: ' + requestBean);

        return requestBean;
    }

    /* Creates a bean from the response
* @param: HTTP Response
* @return: IBlistBeneficiariesV1_Resp_IB_v1 bean object
*/
    public static IBlistBeneficiariesV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        IBlistBeneficiariesV1_Resp_IB_v1 responseBeanContent;

        try {
            IBlistBeneficiariesV1_Resp_IB_v1 responseBean = new IBlistBeneficiariesV1_Resp_IB_v1();
            responseBeanContent = (IBlistBeneficiariesV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), IBlistBeneficiariesV1_Resp_IB_v1.class);

            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            System.debug(message);
        }

        System.debug('IBlistBeneficiariesV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: IBlistBeneficiariesV1_Resp_IB_v1 bean object
* */

    public static IBlistBeneficiariesV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        IBlistBeneficiariesV1_Resp_IB_v1 responseBean = new IBlistBeneficiariesV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('IBlistBeneficiariesV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}