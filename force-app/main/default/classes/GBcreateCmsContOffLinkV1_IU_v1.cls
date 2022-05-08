/*
 * Integration Utility Bean for GBcreateCmsContOffLinkV1 Service
 * @author Diksha Wasekar
 * @created 2020-04-03
 */

public class GBcreateCmsContOffLinkV1_IU_v1 {

     
    public static GBcreateCmsContOffLinkV1_Req_IB_v1 mapRequestFields  (String clientCode,String branchCode,String bankingSector,String indvGroup,String contOffType,String contOffNum,String capByEmployee,String appByEmployee,String overallControl,String businessSeg,String businessSubSeg,String franchisorCode) {

           GBcreateCmsContOffLinkV1_Req_IB_v1 requestBean = new GBcreateCmsContOffLinkV1_Req_IB_v1();
           requestBean.GBcreateCmsContOffLinkV1 = new GBcreateCmsContOffLinkV1_Req_IB_v1.GBcreateCmsContOffLinkV1();
           requestBean.GBcreateCmsContOffLinkV1.gsp020i  = new GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i();
           requestBean.GBcreateCmsContOffLinkV1.nbsapdpi  = new GBcreateCmsContOffLinkV1_Req_IB_v1.Nbsapdpi();
           requestBean.GBcreateCmsContOffLinkV1.nbsmsgi = new GBcreateCmsContOffLinkV1_Req_IB_v1.Nbsmsgi();
        
           
           requestBean.GBcreateCmsContOffLinkV1.Nbsapdpi.channel = 'BDP';
           requestBean.GBcreateCmsContOffLinkV1.Nbsapdpi.application = 'BDP';
           requestBean.GBcreateCmsContOffLinkV1.Nbsapdpi.trace = 'Y';
           
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.clientCode = clientCode;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.branchCode = branchCode;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.bankingSector = bankingSector;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.indvGroup = indvGroup;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.contOffType = contOffType;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.contOffNum = contOffNum;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.capByEmployee = capByEmployee ; //'0939943'
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.appByEmployee = appByEmployee ; //'9091968'
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.overallControl = overallControl; //'25698'
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.businessSeg = businessSeg;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.businessSubSeg = businessSubSeg;
           requestBean.GBcreateCmsContOffLinkV1.gsp020i.franchisorCode = franchisorCode;


           
           requestBean.GBcreateCmsContOffLinkV1.Nbsmsgi.msgLanguage = 'E';
           requestBean.GBcreateCmsContOffLinkV1.Nbsmsgi.msgTarget = 'STD';
           system.debug('GBcreateCmsContOffLinkV1 Request Bean: ' + requestBean);  
           return requestBean;

    }
    
    
        /* Creates a bean from the response
     * @param: HTTP Response
     * @return: GBcreateCmsContOffLinkV1_Resp_IB_v1 bean object
     */
    public static GBcreateCmsContOffLinkV1_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBeanContent;
        
        try {
            GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = new GBcreateCmsContOffLinkV1_Resp_IB_v1();
            responseBeanContent = (GBcreateCmsContOffLinkV1_Resp_IB_v1)responseBean.deserialize(responseP.getBody(), GBcreateCmsContOffLinkV1_Resp_IB_v1.class);
            
            responseBeanContent.status = responseP.getStatus();
            responseBeanContent.statusCode = responseP.getStatusCode();
            //responseBeanContent.message = '';
        } catch (Exception e) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanContent = mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.Sevice500InternalErrorMessage);
            System.debug(message);
        }

        System.debug('GBcreateCmsContOffLinkV1 Response bean: ' + responseBeanContent);
        return responseBeanContent;
    }
    
        /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: GBcreateCmsContOffLinkV1_Resp_IB_v1 bean object
     * */

    public static GBcreateCmsContOffLinkV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
        GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = new GBcreateCmsContOffLinkV1_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        System.debug('GBcreateCmsContOffLinkV1 Failed Response bean: ' + responseBean);
        return responseBean;
    }
}