public class Prediction_IU_v1 {

    public static Prediction_Req_IB_v1 mapRequestFields(String caseId , String caseNo, String status , String serviceTypeId, String suppliedEmail,String subject,String description,String serviceGroup) {
        Prediction_Req_IB_v1 requestBean = new Prediction_Req_IB_v1();
        requestBean.caseId = caseId;
        requestBean.caseNo = caseNo;
        requestBean.status = status;
        requestBean.serviceTypeId = serviceTypeId;
        requestBean.suppliedEmail = suppliedEmail;
        requestBean.subject = subject;
        requestBean.description = description;
        requestBean.serviceGroup = serviceGroup;
        return requestBean;
    }

     public static Prediction_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        Prediction_Resp_IB_v1 responseBeanContent;

        try {
            Prediction_Resp_IB_v1 responseBean = new Prediction_Resp_IB_v1();
            responseBeanContent = (Prediction_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), Prediction_Resp_IB_v1.class);

            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('Prediction Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }



    public static Prediction_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        Prediction_Resp_IB_v1 responseBean = new Prediction_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.responseMessage = messageP;

        System.debug('Prediction Failed Response bean: ' + responseBean);
        return responseBean;
    }

}