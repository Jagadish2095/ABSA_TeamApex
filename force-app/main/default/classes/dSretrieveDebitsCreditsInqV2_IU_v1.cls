/**
* Descripton: Apex Integration Utility Bean class for ABSAOnlineStatementDetailsV1 service
* Test Class Name: dSretrieveDebitsCreditsInqV2_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-03-30
*
**/
public class dSretrieveDebitsCreditsInqV2_IU_v1{
   
    public static dSretrieveDebitsCreditsInqV2_Req_IB_v1 mapRequestdFields(String accountId, String fromDate){ //Case casemap,User usermap,String acno,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
        
        dSretrieveDebitsCreditsInqV2_Req_IB_v1 requestBean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1();
        dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsmsgi nbsmsgibean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsmsgi();
        dSretrieveDebitsCreditsInqV2_Req_IB_v1.finalMsgId finalMsgIdbean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.finalMsgId();
        dSretrieveDebitsCreditsInqV2_Req_IB_v1.dsp973i dsp973ibean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.dsp973i();
        dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsapdpi nbsapdpibean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsapdpi();
        
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        nbsmsgibean.msgTarget = 'E';
        nbsmsgibean.msgLanguage = 'STD';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        
        nbsapdpibean.application = 'SALESFOR';
        nbsapdpibean.channel = 'SALESFOR';
        nbsapdpibean.trace = 'T';
       
        dsp973ibean.acno= accountId; // '4047433399';
        dsp973ibean.functionI= 'SPID';
        dsp973ibean.branch= '034';
        dsp973ibean.effFromDate=fromDate;// '20191001';
        dsp973ibean.versionI= '01';
        dsp973ibean.nxtTieb= '13413B12C9B4062EF039';
        dsp973ibean.channelI= 'SALESFOR';
        
        dSretrieveDebitsCreditsInqV2_Req_IB_v1.DSretrieveDebitsCreditsInqV2 DSretrieveDebitsCreditsInqV2bean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.DSretrieveDebitsCreditsInqV2();
        DSretrieveDebitsCreditsInqV2bean.dsp973i = dsp973ibean;
        DSretrieveDebitsCreditsInqV2bean.nbsmsgi = nbsmsgibean;
        DSretrieveDebitsCreditsInqV2bean.nbsapdpi = nbsapdpibean;
        
        requestBean.DSretrieveDebitsCreditsInqV2 = DSretrieveDebitsCreditsInqV2bean;
        
        System.debug('requestBean in IU'+requestBean) ;   
        return requestBean;
  }
    
    
      /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: dSretrieveDebitsCreditsInqV2_Resp_IB_v1 bean object
      * */
      public static dSretrieveDebitsCreditsInqV2_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        dSretrieveDebitsCreditsInqV2_Resp_IB_v1 responseBean = (dSretrieveDebitsCreditsInqV2_Resp_IB_v1)JSON.deserialize(respP.getBody().replace('transaction','transactionList'), dSretrieveDebitsCreditsInqV2_Resp_IB_v1.class);
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getstatusCode();
        System.debug('dSretrieveDebitsCreditsInqV2 Service Success ResponseBean: ' + responseBean);
    
        return responseBean;
      }
    
      /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param:  message
      * @return: dSretrieveDebitsCreditsInqV2_Resp_IB_v1 bean object
      * */
      public static dSretrieveDebitsCreditsInqV2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        dSretrieveDebitsCreditsInqV2_Resp_IB_v1 responseBean = new dSretrieveDebitsCreditsInqV2_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('dSretrieveDebitsCreditsInqV2 Service Failed Response Bean: ' + responseBean);
        return responseBean;
  }
}