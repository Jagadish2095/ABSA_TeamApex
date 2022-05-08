/**
* Descripton: Apex Integration Utility Bean class for dSaddStopPaymentV2 service
* Test Class Name: dSaddStopPaymentV2_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-03-02
*
**/
public class dSaddStopPaymentV2_IU_v1 {
     public static dSaddStopPaymentV2_Req_IB_v1 mapRequestdFields(){ //Case casemap,User usermap,String acno,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
        
        dSaddStopPaymentV2_Req_IB_v1 requestBean = new dSaddStopPaymentV2_Req_IB_v1(); 
        dSaddStopPaymentV2_Req_IB_v1.nbsmsgi nbsmsgibean = new dSaddStopPaymentV2_Req_IB_v1.nbsmsgi();
        dSaddStopPaymentV2_Req_IB_v1.finalMsgId finalMsgIdbean = new dSaddStopPaymentV2_Req_IB_v1.finalMsgId();
        dSaddStopPaymentV2_Req_IB_v1.nbsapdpi nbsapdpibean = new dSaddStopPaymentV2_Req_IB_v1.nbsapdpi(); 
         dSaddStopPaymentV2_Req_IB_v1.dsc976iInputArea dsc976iInputAreaBean = new dSaddStopPaymentV2_Req_IB_v1.dsc976iInputArea();
         
         finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        nbsmsgibean.msgTarget = 'E';
        nbsmsgibean.msgLanguage = 'STD';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        
        nbsapdpibean.application = 'SALESFOR';
        nbsapdpibean.channel = 'SALESFOR';
        nbsapdpibean.trace = 'T';
         
        dsc976iInputAreaBean.accNo = '00000004048154875';
        dsc976iInputAreaBean.actDate = '20191017';
        dsc976iInputAreaBean.userCode = '0110';
        dsc976iInputAreaBean.userRef = '01023423 011     CC';
        dsc976iInputAreaBean.amount = '100';
        dsc976iInputAreaBean.brnch = '32322';
        dsc976iInputAreaBean.teller = '12122';
        dsc976iInputAreaBean.caseNo = '12345678';	
       	dsc976iInputAreaBean.institution = 'ABSA CARD';
        dsc976iInputAreaBean.effDate = '20191009';
        System.debug('requestBean in IU'+requestBean) ;
         
         dSaddStopPaymentV2_Req_IB_v1.DSaddStopPaymentV2 DSaddStopPaymentV2bean = new dSaddStopPaymentV2_Req_IB_v1.DSaddStopPaymentV2();
        DSaddStopPaymentV2bean.dsc976iInputArea = dsc976iInputAreaBean;
         DSaddStopPaymentV2bean.nbsmsgi = nbsmsgibean;
        DSaddStopPaymentV2bean.nbsapdpi = nbsapdpibean;
        requestBean.DSaddStopPaymentV2 = DSaddStopPaymentV2bean;
         return requestBean;
  }
    
    
      /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: dSaddStopPaymentV2_Resp_IB_v1 bean object
      * */
      public static dSaddStopPaymentV2_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        dSaddStopPaymentV2_Resp_IB_v1 responseBean = (dSaddStopPaymentV2_Resp_IB_v1)JSON.deserialize(respP.getBody().replace('transaction','transactionList'), dSaddStopPaymentV2_Resp_IB_v1.class);
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getstatusCode();
        System.debug('dSaddStopPaymentV2 Service Success ResponseBean: ' + responseBean);
    
        return responseBean;
      }
    
      /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param: message
      * @return: dSaddStopPaymentV2_Resp_IB_v1 bean object
      * */
      public static dSaddStopPaymentV2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        dSaddStopPaymentV2_Resp_IB_v1 responseBean = new dSaddStopPaymentV2_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('dSaddStopPaymentV2 Service Failed Response Bean: ' + responseBean);
        return responseBean;
  }

}