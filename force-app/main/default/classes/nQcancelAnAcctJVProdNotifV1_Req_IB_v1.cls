/*
 * Request Bean for nQupdateNotificationsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-16-03
 */
public class nQcancelAnAcctJVProdNotifV1_Req_IB_v1 extends Base_IB {
    
	public NQcancelAnAcctJVProdNotificationV1 NQcancelAnAcctJVProdNotificationV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nqp207i {
		public String registeringSite;
		public String jvRefNo;
		public String jvName;
		public String cif;
		public String accountNumber;
		public String pnsRecipientId;
		public String clientNotif;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class NQcancelAnAcctJVProdNotificationV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nqp207i nqp207i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    
    public static nQcancelAnAcctJVProdNotifV1_Req_IB_v1 createDummyRequest(){
        
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1 requestBean = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1();
              
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsapdpi nbsapdpi = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsapdpi();
        
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1 nQcancelAnAcctJVProdNotificationV1  = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1();
        nbsapdpi.channel = 'SALESFORCE';
        nbsapdpi.application = 'SALESFORCE';
        nbsapdpi.trace = 'Y';
        
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsmsgi nbsmsgi = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nbsmsgi();
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'STD';
         
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.FinalMsgId finalMsgId = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.FinalMsgId();
        finalMsgId.finalMsgClass = '';
        finalMsgId.finalMsgCode = '';
        nbsmsgi.finalMsgId = finalMsgId;
        
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nqp207i nqp207i = new nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nqp207i();
        nqp207i.registeringSite = '3043';
        nqp207i.jvName = 'ABSA';
        nqp207i.jvRefNo = 'ABSA';
        nqp207i.cif = 'MBUSINE003';
        nqp207i.accountNumber = '4047433399';
        nqp207i.pnsRecipientId = '1';
        nqp207i.clientNotif = '901';
        
        nQcancelAnAcctJVProdNotificationV1.nbsapdpi = nbsapdpi;
        nQcancelAnAcctJVProdNotificationV1.nbsmsgi = nbsmsgi;
        nQcancelAnAcctJVProdNotificationV1.nqp207i = nqp207i;
        
       
        requestBean.NQcancelAnAcctJVProdNotificationV1 = nQcancelAnAcctJVProdNotificationV1;
       
        return requestBean;
    } 
   
}