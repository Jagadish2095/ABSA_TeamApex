/**
* Descripton: Apex Integration Utility Bean class for nqupdatenotificationsv1 service
* Test Class Name: nqupdatenotificationsv1_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-03-02
*
**/
public class nqupdatenotificationsv1_IU_v1 {
     public static nqupdatenotificationsv1_Req_IB_v1 mapRequestdFields(){ //Case casemap,User usermap,String acno,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
         nqupdatenotificationsv1_Req_IB_v1 requestBean = new nqupdatenotificationsv1_Req_IB_v1(); 
         nqupdatenotificationsv1_Req_IB_v1.NQupdJVProdNotificationAcctSettingsV1 nqupdJVProdNotificationAcctSettingsV1Bean = new nqupdatenotificationsv1_Req_IB_v1.NQupdJVProdNotificationAcctSettingsV1();
         
         nqupdatenotificationsv1_Req_IB_v1.nbsmsgi nbsmsgiBean = new nqupdatenotificationsv1_Req_IB_v1.nbsmsgi();
         nbsmsgiBean.msgTarget = 'STD';   
         nbsmsgiBean.msgLanguage = 'E';
         nqupdatenotificationsv1_Req_IB_v1.finalMsgId finalMsgIdbean = new nqupdatenotificationsv1_Req_IB_v1.finalMsgId();
         finalMsgIdbean.finalMsgClass = '';
         finalMsgIdbean.finalMsgCode = '';
         nbsmsgiBean.finalMsgId = finalMsgIdbean;
         nqupdJVProdNotificationAcctSettingsV1Bean.nbsmsgi = nbsmsgiBean;
         nqupdatenotificationsv1_Req_IB_v1.nbsapdpi nbsapdpibean = new nqupdatenotificationsv1_Req_IB_v1.nbsapdpi();
         nbsapdpibean.application = 'BDP';
         nbsapdpibean.channel = 'BDP';
         nbsapdpibean.trace = 'Y';
         nqupdJVProdNotificationAcctSettingsV1Bean.nbsapdpi = nbsapdpibean;
          List<nqupdatenotificationsv1_Req_IB_v1.trnSelX> trnSelXbeanList = new List<nqupdatenotificationsv1_Req_IB_v1.trnSelX>();
        nqupdatenotificationsv1_Req_IB_v1.trnSelX trnSelXbean = new nqupdatenotificationsv1_Req_IB_v1.trnSelX();
        
         trnSelXbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.trnSelX('20'));
           trnSelXbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.trnSelX('10'));
          List<nqupdatenotificationsv1_Req_IB_v1.balFreqs> balFreqsbeanList = new List<nqupdatenotificationsv1_Req_IB_v1.balFreqs>();
       // nqupdatenotificationsv1_Req_IB_v1.balFreqs balFreqsbean = new nqupdatenotificationsv1_Req_IB_v1.balFreqs();
       // balFreqsbean.balDay = 'Y';
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('Y'));
       // balFreqsbean.balDay = 'N';
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('N'));
         balFreqsbeanList.add(new nqupdatenotificationsv1_Req_IB_v1.balFreqs('N'));
         
           
            nqupdatenotificationsv1_Req_IB_v1.nqp204i nqp204ibean = new nqupdatenotificationsv1_Req_IB_v1.nqp204i();
		
		nqp204ibean.cif = 'MBUSINE003';
		nqp204ibean.accountNumber = '4047433399';
		nqp204ibean.jvName = 'BDP';
		nqp204ibean.pnsRecipientId = '1';
		nqp204ibean.jvRefNo = 'BDP';
		nqp204ibean.clientNotif = '903';
		nqp204ibean.registeringSite = 'SRDT';
		nqp204ibean.teller = '11012';
		nqp204ibean.transmitWindow = 'A';
         nqp204ibean.trnSelX = trnSelXbeanList;
         nqp204ibean.balFreqs = balFreqsbeanList;
		nqp204ibean.prodArea = 'CHEQUE';
		nqp204ibean.minAm = '1100';
        nqupdJVProdNotificationAcctSettingsV1Bean.nqp204i = nqp204ibean;
         
         requestBean.NQupdJVProdNotificationAcctSettingsV1 = nqupdJVProdNotificationAcctSettingsV1Bean;
         
        System.debug('requestBean in IU'+requestBean) ; 
         return requestBean;
  }
    
}