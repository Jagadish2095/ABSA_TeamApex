/**
* Descripton: Apex Integration Utility Bean class for nqcancelacctnotificationv1 service
* Test Class Name: nqcancelacctnotificationv1_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-03-02
*
**/
public class nqcancelacctnotificationv1_IU_v1 {
     public static nqcancelacctnotificationv1_Req_IB_v1 mapRequestdFields(){ //Case casemap,User usermap,String acno,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
        
        nqcancelacctnotificationv1_Req_IB_v1 requestBean = new nqcancelacctnotificationv1_Req_IB_v1(); 
        nqcancelacctnotificationv1_Req_IB_v1.nbsmsgi nbsmsgibean = new nqcancelacctnotificationv1_Req_IB_v1.nbsmsgi();
        nqcancelacctnotificationv1_Req_IB_v1.finalMsgId finalMsgIdbean = new nqcancelacctnotificationv1_Req_IB_v1.finalMsgId();
        nqcancelacctnotificationv1_Req_IB_v1.nbsapdpi nbsapdpibean = new nqcancelacctnotificationv1_Req_IB_v1.nbsapdpi(); 
        nqcancelacctnotificationv1_Req_IB_v1.nqp207i nqp207iBean = new nqcancelacctnotificationv1_Req_IB_v1.nqp207i();
         
         finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        nbsmsgibean.msgTarget = 'E';
        nbsmsgibean.msgLanguage = 'STD';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        
        nbsapdpibean.application = 'SALE';
        nbsapdpibean.channel = 'SALE';
        nbsapdpibean.trace = 'T';
         
        nqp207iBean.cif = 'MBUSINE003';
        nqp207iBean.accountNumber = '4047433399';
        nqp207iBean.jvName = 'ABSA';
        nqp207iBean.jvRefNo = 'ABSA';
        nqp207iBean.pnsRecipientId = '1';
        nqp207iBean.clientNotif = '901';
        nqp207iBean.registeringSite = '3043';
        System.debug('requestBean in IU'+requestBean) ;
         
        nqcancelacctnotificationv1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1 nqcancelacctnotificationv1bean = new nqcancelacctnotificationv1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1();
        nqcancelacctnotificationv1bean.nqp207i = nqp207iBean;
        nqcancelacctnotificationv1bean.nbsmsgi = nbsmsgibean;
        nqcancelacctnotificationv1bean.nbsapdpi = nbsapdpibean;
        requestBean.NQcancelAnAcctJVProdNotificationV1 = nqcancelacctnotificationv1bean;
         return requestBean;
  }
    
    
      /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: nqcancelacctnotificationv1_Resp_IB_v1 bean object
      * */
      public static nqcancelacctnotificationv1_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        nqcancelacctnotificationv1_Resp_IB_v1 responseBean = (nqcancelacctnotificationv1_Resp_IB_v1)JSON.deserialize(respP.getBody().replace('transaction','transactionList'), nqcancelacctnotificationv1_Resp_IB_v1.class);
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getstatusCode();
        System.debug('nqcancelacctnotificationv1 Service Success ResponseBean: ' + responseBean);
    
        return responseBean;
      }
    
      /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param: message
      * @return: nqcancelacctnotificationv1_Resp_IB_v1 bean object
      * */
      public static nqcancelacctnotificationv1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        nqcancelacctnotificationv1_Resp_IB_v1 responseBean = new nqcancelacctnotificationv1_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('nqcancelacctnotificationv1 Service Failed Response Bean: ' + responseBean);
        return responseBean;
  }

}