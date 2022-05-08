/*
 * Request Bean for nQupdateNotificationsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-16-03
 */

public class nQupdateNotificationsV1_Req_IB_v2 extends Base_IB{
    
	public NQupdJVProdNotificationAcctSettingsV1 NQupdJVProdNotificationAcctSettingsV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class TrnSelX {
		public String trnSel;
        public TrnSelX(String input){
            trnSel = input;
        }
        public TrnSelX(){
        }
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class NQupdJVProdNotificationAcctSettingsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nqp204i nqp204i;
	}

	public class BalFreqs {
		public String balDay;
	}

	public class Nqp204i {
		public String registeringSite;
		public String jvRefNo;
		public String jvName;
		public String cif;
		public String accountNumber;
		public String pnsRecipientId;
		public String clientNotif;
		public String teller;
		public String prodArea;
		public String minAm;
		public String transmitWindow;
		public List<BalFreqs> balFreqs;
		public List<TrnSelX> trnSelX;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

    
    public static nQupdateNotificationsV1_Req_IB_v2 createDummyBean(){
            
          nQupdateNotificationsV1_Req_IB_v2 requestbean = new nQupdateNotificationsV1_Req_IB_v2();
          nQupdateNotificationsV1_Req_IB_v2.NQupdJVProdNotificationAcctSettingsV1 NQupdJVProdNotificationAcctSettingsV1bean = new nQupdateNotificationsV1_Req_IB_v2.NQupdJVProdNotificationAcctSettingsV1();
          nQupdateNotificationsV1_Req_IB_v2.nbsapdpi nbsapdpibean  = new nQupdateNotificationsV1_Req_IB_v2.nbsapdpi();
          nQupdateNotificationsV1_Req_IB_v2.nbsmsgi nbsmsgibean  = new nQupdateNotificationsV1_Req_IB_v2.nbsmsgi();
          nQupdateNotificationsV1_Req_IB_v2.nqp204i nqp204ibean  = new nQupdateNotificationsV1_Req_IB_v2.nqp204i();
          nQupdateNotificationsV1_Req_IB_v2.finalMsgId finalMsgIdbean  = new nQupdateNotificationsV1_Req_IB_v2.finalMsgId();
          nQupdateNotificationsV1_Req_IB_v2.trnSelX trnSelXbean = new nQupdateNotificationsV1_Req_IB_v2.trnSelX();
          nQupdateNotificationsV1_Req_IB_v2.balFreqs balFreqsbean = new nQupdateNotificationsV1_Req_IB_v2.balFreqs();
        
          List<nQupdateNotificationsV1_Req_IB_v2.trnSelX> trnSelXlistbean = new List<nQupdateNotificationsV1_Req_IB_v2.trnSelX>();
          List<nQupdateNotificationsV1_Req_IB_v2.balFreqs> balFreqslistbean = new List<nQupdateNotificationsV1_Req_IB_v2.balFreqs>();
          
          nbsapdpibean.channel = 'SALESFORCE';
          nbsapdpibean.application = 'SALESFORCE';
          nbsapdpibean.trace = 'Y';
          
          nbsmsgibean.msgLanguage = 'E';
          nbsmsgibean.msgTarget = 'STD';
          finalMsgIdbean.finalMsgClass = '';
          finalMsgIdbean.finalMsgCode = '';
          nbsmsgibean.finalMsgId = finalMsgIdbean;
          
          nqp204ibean.registeringSite = '3043';
          nqp204ibean.jvRefNo = '0';
          nqp204ibean.jvName = '0';
          nqp204ibean.cif = 'MBUSINE003';
          nqp204ibean.accountNumber = '4047433399';
          nqp204ibean.pnsRecipientId = '1';
          nqp204ibean.clientNotif = '904';
          nqp204ibean.teller = '11012';//
          nqp204ibean.prodArea = 'SAVINGS';
          nqp204ibean.minAm = '200';
          nqp204ibean.transmitWindow = 'A';
          
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
          balFreqsbean.balDay = 'N';
          balFreqslistbean.add(balFreqsbean);
        
          trnSelXbean.trnSel = '029';
          trnSelXlistbean.add(trnSelXbean);
          trnSelXbean.trnSel = '039';
          trnSelXlistbean.add(trnSelXbean);
          trnSelXbean.trnSel = '049';
          trnSelXlistbean.add(trnSelXbean);
          trnSelXbean.trnSel = '059';
          trnSelXlistbean.add(trnSelXbean);
          trnSelXbean.trnSel = '069';
          trnSelXlistbean.add(trnSelXbean);
          trnSelXbean.trnSel = '079';
          trnSelXlistbean.add(trnSelXbean);
        
          nqp204ibean.balFreqs = balFreqslistbean;
          nqp204ibean.trnSelX = trnSelXlistbean;
           
          NQupdJVProdNotificationAcctSettingsV1bean.nbsapdpi = nbsapdpibean;
          NQupdJVProdNotificationAcctSettingsV1bean.nbsmsgi = nbsmsgibean; 
          NQupdJVProdNotificationAcctSettingsV1bean.nqp204i = nqp204ibean;
         
          requestBean.NQupdJVProdNotificationAcctSettingsV1 = NQupdJVProdNotificationAcctSettingsV1bean;
          return requestbean;
    
    }
}