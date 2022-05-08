/*
* Integration Utility Bean for MBListSourceInstructionsV1 Service
* @author Rudolf Niehaus
* @created 2020-05-13
*/

public class MBListSourceInstructionsV1_IU_v1 {
    
    /* Creates a request bean
    * @param: cifNumber
    * @param: accNumber
    * @return: MBListSourceInstructionsV1_Req_IB_v1 bean object
    */
    public static MBListSourceInstructionsV1_Req_IB_v1 mapRequestFields(String cifNumber, String accNumber) {
        
        MBListSourceInstructionsV1_Req_IB_v1 requestBean = new MBListSourceInstructionsV1_Req_IB_v1();
        requestBean.MBListSourceInstructionsV1 = new MBListSourceInstructionsV1_Req_IB_v1.MBListSourceInstructionsV1();
        requestBean.MBListSourceInstructionsV1.nbsapdpi = new MBListSourceInstructionsV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBListSourceInstructionsV1.nbsmsgi = new MBListSourceInstructionsV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBListSourceInstructionsV1.mbs305i = new MBListSourceInstructionsV1_Req_IB_v1.Mbs305i();
        requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId = new MBListSourceInstructionsV1_Req_IB_v1.FinalMsgId();
        
        requestBean.MBListSourceInstructionsV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.nbsapdpi.application = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.nbsapdpi.trace = 'Y';

        requestBean.MBListSourceInstructionsV1.nbsmsgi.msgLanguage = 'E';
        requestBean.MBListSourceInstructionsV1.nbsmsgi.msgTarget = 'STD';
        requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBListSourceInstructionsV1.mbs305i.channelI = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.mbs305i.maxRetrieve = '50';
        requestBean.MBListSourceInstructionsV1.mbs305i.processInd = '';
        requestBean.MBListSourceInstructionsV1.mbs305i.origType = 'SO';
        requestBean.MBListSourceInstructionsV1.mbs305i.origStatus = 'CURRENT';
        requestBean.MBListSourceInstructionsV1.mbs305i.altTieb = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.cifKey = cifNumber;
        requestBean.MBListSourceInstructionsV1.mbs305i.tieb = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.instrType = 'SO';
        requestBean.MBListSourceInstructionsV1.mbs305i.instrNo = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.multiNo = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.instrStatus = 'CURRENT';                                        
        requestBean.MBListSourceInstructionsV1.mbs305i.srcAcc = accNumber;
                                                                        
        
        System.debug('MBListSourceInstructionsV1 Request Bean: ' + requestBean);

        return requestBean;
    }
    
        
    /* Creates a request bean for future payment
    * @param: cifNumber
    * @param: accNumber
    * @return: MBListSourceInstructionsV1_Req_IB_v1 bean object
    * Modified by Lulu
    */
    public static MBListSourceInstructionsV1_Req_IB_v1 mapRequest(String cifNumber, String accNumber) {
        
        MBListSourceInstructionsV1_Req_IB_v1 requestBean = new MBListSourceInstructionsV1_Req_IB_v1();
        requestBean.MBListSourceInstructionsV1 = new MBListSourceInstructionsV1_Req_IB_v1.MBListSourceInstructionsV1();
        requestBean.MBListSourceInstructionsV1.nbsapdpi = new MBListSourceInstructionsV1_Req_IB_v1.Nbsapdpi();
        requestBean.MBListSourceInstructionsV1.nbsmsgi = new MBListSourceInstructionsV1_Req_IB_v1.Nbsmsgi();
        requestBean.MBListSourceInstructionsV1.mbs305i = new MBListSourceInstructionsV1_Req_IB_v1.Mbs305i();
        requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId = new MBListSourceInstructionsV1_Req_IB_v1.FinalMsgId();
        
        requestBean.MBListSourceInstructionsV1.nbsapdpi.channel = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.nbsapdpi.application = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.nbsapdpi.trace = 'Y';

        requestBean.MBListSourceInstructionsV1.nbsmsgi.msgLanguage = 'E';
        requestBean.MBListSourceInstructionsV1.nbsmsgi.msgTarget = 'STD';
        requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.MBListSourceInstructionsV1.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.MBListSourceInstructionsV1.mbs305i.channelI = 'SALESFOR';
        requestBean.MBListSourceInstructionsV1.mbs305i.maxRetrieve = '50';
        requestBean.MBListSourceInstructionsV1.mbs305i.processInd = '';
        requestBean.MBListSourceInstructionsV1.mbs305i.origType = 'OOP';
        requestBean.MBListSourceInstructionsV1.mbs305i.origStatus = 'CURRENT';
        requestBean.MBListSourceInstructionsV1.mbs305i.altTieb = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.cifKey = cifNumber;
        requestBean.MBListSourceInstructionsV1.mbs305i.tieb = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.instrType = 'SO';
        requestBean.MBListSourceInstructionsV1.mbs305i.instrNo = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.multiNo = '0';
        requestBean.MBListSourceInstructionsV1.mbs305i.instrStatus = 'CURRENT';                                        
        requestBean.MBListSourceInstructionsV1.mbs305i.srcAcc = accNumber;
                                                                        
        
        System.debug('MBListSourceInstructionsV1 Request Bean: ' + requestBean);

        return requestBean;
    }
    
    

    
    /* Creates a bean from the response
    * @param: HTTP Response
    * @return: MBListSourceInstructionsV1_Resp_IB_v1 bean object
    */
    public static MBListSourceInstructionsV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        MBListSourceInstructionsV1_Resp_IB_v1 responseBeanContent;
        
        try {
            MBListSourceInstructionsV1_Resp_IB_v1 responseBean = new MBListSourceInstructionsV1_Resp_IB_v1();
            responseBeanContent = (MBListSourceInstructionsV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), MBListSourceInstructionsV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }
        
        System.debug('MBListSourceInstructionsV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: MBListSourceInstructionsV1_Resp_IB_v1 bean object
    * */
    
    public static MBListSourceInstructionsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        MBListSourceInstructionsV1_Resp_IB_v1 responseBean = new MBListSourceInstructionsV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('MBListSourceInstructionsV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}