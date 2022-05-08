/**
* Descripton: Apex Integration Utility Bean class for gPpaymReturnV1 service
* Test Class Name: gPpaymReturnV1_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-03-02
*
**/
public class gPpaymReturnV1_IU_v1 {
     public static gPpaymReturnV1_Req_IB_v1 mapRequestdFields(){ //Case casemap,User usermap,String acno,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
        
        gPpaymReturnV1_Req_IB_v1 requestBean = new gPpaymReturnV1_Req_IB_v1(); 
        gPpaymReturnV1_Req_IB_v1.nbsmsgi nbsmsgibean = new gPpaymReturnV1_Req_IB_v1.nbsmsgi();
        gPpaymReturnV1_Req_IB_v1.finalMsgId finalMsgIdbean = new gPpaymReturnV1_Req_IB_v1.finalMsgId();
        gPpaymReturnV1_Req_IB_v1.nbsapdpi nbsapdpibean = new gPpaymReturnV1_Req_IB_v1.nbsapdpi();
         
         gPpaymReturnV1_Req_IB_v1.gpp506i gpp506iBean = new gPpaymReturnV1_Req_IB_v1.gpp506i();
         
         finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        nbsmsgibean.msgTarget = 'E';
        nbsmsgibean.msgLanguage = 'STD';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        
        nbsapdpibean.application = 'SALESFOR';
        nbsapdpibean.channel = 'SALESFOR';
        nbsapdpibean.trace = 'T';
         
        gpp506iBean.func = 'SRDT';
        gpp506iBean.versionI = '00';
        gpp506iBean.acno = '4044751304';
        gpp506iBean.tkey = '1343AC025F6F111DBB19';
        gpp506iBean.resn = '30';
        gpp506iBean.brcd = '8198';
        gpp506iBean.tell = '1110022';
        gpp506iBean.sitetp = '034'; 
        gpp506iBean.spare = '33';
        gPpaymReturnV1_Req_IB_v1.GPpaymReturnV1 GPpaymReturnV1bean = new gPpaymReturnV1_Req_IB_v1.GPpaymReturnV1();
         GPpaymReturnV1bean.gpp506i = gpp506iBean;
         GPpaymReturnV1bean.nbsmsgi = nbsmsgibean;
        GPpaymReturnV1bean.nbsapdpi = nbsapdpibean;
         requestBean.GPpaymReturnV1 = GPpaymReturnV1bean;
        System.debug('requestBean in IU'+requestBean) ;   
         return requestBean;
  }
    
    
      /* Creates a bean from the response
      * @param: HTTP Response
      * @return: gPpaymReturnV1_Resp_IB_v1 bean object
      * */
      public static gPpaymReturnV1_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        gPpaymReturnV1_Resp_IB_v1 responseBean = (gPpaymReturnV1_Resp_IB_v1)JSON.deserialize(respP.getBody().replace('transaction','transactionList'), gPpaymReturnV1_Resp_IB_v1.class);
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getstatusCode();
        System.debug('gPpaymReturnV1 Service Success ResponseBean: ' + responseBean);
    
        return responseBean;
      }
    
      /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param: message
      * @return: gPpaymReturnV1_Resp_IB_v1 bean object
      * */
      public static gPpaymReturnV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        gPpaymReturnV1_Resp_IB_v1 responseBean = new gPpaymReturnV1_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('gPpaymReturnV1 Service Failed Response Bean: ' + responseBean);
        return responseBean;
  }

}