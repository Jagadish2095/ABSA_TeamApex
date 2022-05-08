/*
 * Integration Utility Bean for CQGetPaymentDue Service
 * @author Haritha Police
 * @created 2019-09-14
 */

public class CQgetPaymentDue_IU_V5 {
    
	//Populates the CQ get Payment Due request bean from the parameters passed
      public static CQgetPaymentDue_Req_IB_V1 mapRequestFields(String accountNbrP,String agencyCodeP,String siteCodeP,String tellerCodeP,String controllerCodeP){
        
        CQgetPaymentDue_Req_IB_V1 requestBean = new CQgetPaymentDue_Req_IB_V1();
        requestBean.channel = StringConstants.SALESFORCE_STRING;
        requestBean.application = StringConstants.SALESFORCE_STRING;
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.accountNbr = accountNbrP;
        requestBean.agencyCode = agencyCodeP;
        requestBean.siteCode = siteCodeP;
        requestBean.tellerCode = tellerCodeP;
        requestBean.controllerCode = controllerCodeP;
        
        System.debug('CQ get Payment Due Request Bean: ' + requestBean);
        return requestBean;
    }
    
    //Populates the CQ get Payment Due response bean from an http response
    public static CQgetPaymentDue_Resp_IB_V1 mapResponseFields(HttpResponse respP){
        
        CQgetPaymentDue_Resp_IB_V1 responseBean = new CQgetPaymentDue_Resp_IB_V1();
        responseBean = (CQgetPaymentDue_Resp_IB_V1)responseBean.deserialize( respP.getBody(), CQgetPaymentDue_Resp_IB_V1.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('CQ get Payment Due Response Bean: ' + responseBean);
        return responseBean;
    }
    
    //Populates the CQ get Payment Due response bean as failed with the necessary data
    public static CQgetPaymentDue_Resp_IB_V1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        CQgetPaymentDue_Resp_IB_V1 CQgetPaymentDueResponse = new CQgetPaymentDue_Resp_IB_V1();
        CQgetPaymentDueResponse.message = messageP;
        CQgetPaymentDueResponse.status = statusP;
        CQgetPaymentDueResponse.statusCode = statusCodeP;
        System.debug('CQ get Payment Due Failed Response Bean: ' + CQgetPaymentDueResponse);
        return CQgetPaymentDueResponse;
}
}