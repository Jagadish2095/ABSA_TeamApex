/**
* Descripton: Apex Integration Utility Bean class for nqcreateneworaddrecipientv2 service
* Test Class Name: nqcreateneworaddrecipientv2_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-03-02
*
**/
public class nqcreateneworaddrecipientv2_IU_v1 {
     public static nqcreateneworaddrecipientv2_Req_IB_v1 mapRequestdFields(){ //Case casemap,User usermap,String acno,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
         
         nqcreateneworaddrecipientv2_Req_IB_v1 requestBean = new nqcreateneworaddrecipientv2_Req_IB_v1(); 
         nqcreateneworaddrecipientv2_Req_IB_v1.nqcreateneworaddrecipientv2 nqcreateneworaddrecipientv2bean = new nqcreateneworaddrecipientv2_Req_IB_v1.nqcreateneworaddrecipientv2();
         
         nqcreateneworaddrecipientv2_Req_IB_v1.nbsmsgi nbsmsgiBean = new nqcreateneworaddrecipientv2_Req_IB_v1.nbsmsgi();
         nbsmsgiBean.msgTarget = 'STD';   
         nbsmsgiBean.msgLanguage = 'E';
         nqcreateneworaddrecipientv2_Req_IB_v1.finalMsgId finalMsgIdbean = new nqcreateneworaddrecipientv2_Req_IB_v1.finalMsgId();
         finalMsgIdbean.finalMsgClass = '';
         finalMsgIdbean.finalMsgCode = '';
         nbsmsgiBean.finalMsgId = finalMsgIdbean;
         nqcreateneworaddrecipientv2bean.nbsmsgi = nbsmsgiBean;
         nqcreateneworaddrecipientv2_Req_IB_v1.nbsapdpi nbsapdpibean = new nqcreateneworaddrecipientv2_Req_IB_v1.nbsapdpi();
         nbsapdpibean.application = 'BRANCH';
         nbsapdpibean.channel = 'BRANCH';
         nbsapdpibean.trace = 'Y';
         nqcreateneworaddrecipientv2bean.nbsapdpi = nbsapdpibean;
         nqcreateneworaddrecipientv2_Req_IB_v1.keyFields keyFieldsBean = new nqcreateneworaddrecipientv2_Req_IB_v1.keyFields();
         keyFieldsBean.acn = '9050544469';
         keyFieldsBean.pnsRecipientId = '1';
         keyFieldsBean.cif = 'MOOIM  002';      
         nqcreateneworaddrecipientv2_Req_IB_v1.recipientData recipientDatabean = new nqcreateneworaddrecipientv2_Req_IB_v1.recipientData();
            recipientDatabean.recipNm = 'Sizwe';
            recipientDatabean.email = '';
            recipientDatabean.lng = 'E';
            recipientDatabean.cellPhone = '0797530041';
            recipientDatabean.contactPref = 'S';
         
         
nqcreateneworaddrecipientv2_Req_IB_v1.recipientAcnData recipientAcnDatabean = new nqcreateneworaddrecipientv2_Req_IB_v1.recipientAcnData();
       
		recipientAcnDatabean.transmitWindow = 'L';
		recipientAcnDatabean.minAm = '1150';
		recipientAcnDatabean.delInd = 'N';
		recipientAcnDatabean.prodArea = 'SAVINGS';
          List<nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX> trnSelXbeanList = new List<nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX>();
        nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX trnSelXbean = new nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX();
        
         trnSelXbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX('20'));
           trnSelXbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.trnSelX('10'));
		recipientAcnDatabean.trnSelX = trnSelXbeanList;
          List<nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs> balFreqsbeanList = new List<nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs>();
       // nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs balFreqsbean = new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs();
       // balFreqsbean.balDay = 'Y';
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('Y'));
       // balFreqsbean.balDay = 'N';
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqcreateneworaddrecipientv2_Req_IB_v1.balFreqs('N'));
		recipientAcnDatabean.balFreqs = balFreqsbeanList;
         
           
            nqcreateneworaddrecipientv2_Req_IB_v1.nqp906i nqp906ibean = new nqcreateneworaddrecipientv2_Req_IB_v1.nqp906i();
		
		nqp906ibean.registeringSite = '3043';
         nqp906ibean.keyFields =keyFieldsBean;
		nqp906ibean.clientNotif = '903';
		nqp906ibean.sbuCd = 'B';
		nqp906ibean.teller = '11012';
		nqp906ibean.notifyCifInd = 'N';
         nqp906ibean.recipientData = recipientDatabean;
         nqp906ibean.recipientAcnData = recipientAcnDatabean;
		//nqp906ibean.recipientAcnData = 'SRDT';
		//nqp906ibean.recipientData = 'SRDT';
		nqp906ibean.marketerCode = '11332';
		nqp906ibean.marketerCodeAmend = '11332';
        nqcreateneworaddrecipientv2bean.nqp906i = nqp906ibean;
         
         requestBean.nqcreateneworaddrecipientv2 = nqcreateneworaddrecipientv2bean;
         
        System.debug('requestBean in IU'+requestBean) ;   
         return requestBean;
  }
    
    
      /* Creates a bean from the response
      * @param: HTTP Response
      * @return: nqcreateneworaddrecipientv2_Resp_IB_v1 bean object
      * */
      public static nqcreateneworaddrecipientv2_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        nqcreateneworaddrecipientv2_Resp_IB_v1 responseBean = (nqcreateneworaddrecipientv2_Resp_IB_v1)JSON.deserialize(respP.getBody().replace('transaction','transactionList'), nqcreateneworaddrecipientv2_Resp_IB_v1.class);
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getstatusCode();
        System.debug('nqcreateneworaddrecipientv2 Service Success ResponseBean: ' + responseBean);
    
        return responseBean;
      }
    
      /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param: message
      * @return: nqcreateneworaddrecipientv2_Resp_IB_v1 bean object
      * */
      public static nqcreateneworaddrecipientv2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        nqcreateneworaddrecipientv2_Resp_IB_v1 responseBean = new nqcreateneworaddrecipientv2_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('nqcreateneworaddrecipientv2 Service Failed Response Bean: ' + responseBean);
        return responseBean;
  }

}