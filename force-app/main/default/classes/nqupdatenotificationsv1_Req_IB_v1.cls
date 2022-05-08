public class nqupdatenotificationsv1_Req_IB_v1{
	
	public NQupdJVProdNotificationAcctSettingsV1 NQupdJVProdNotificationAcctSettingsV1{get;set;}
	public class trnSelX{
		public String trnSel{get;set;}
        public trnSelX(){
            
        }
        public trnSelX(String input){
            trnSel = input;
        }
	}
	public class NQupdJVProdNotificationAcctSettingsV1{
		public nbsmsgi nbsmsgi{get;set;}
		public nqp204i nqp204i{get;set;}
		public nbsapdpi nbsapdpi{get;set;}
	}
	public class nqp204i{
		public String cif{get;set;}
		public String accountNumber{get;set;}
		public String jvName{get;set;}
		public String pnsRecipientId{get;set;}
		public String jvRefNo{get;set;}
		public String clientNotif{get;set;}
		public String registeringSite{get;set;}
		public String teller{get;set;}
		public String transmitWindow{get;set;}
		public list<balFreqs> balFreqs{get;set;}
		public String minAm{get;set;}
		public list<trnSelX> trnSelX{get;set;}
		public String prodArea{get;set;}
	}
	public class nbsmsgi{
		public finalMsgId finalMsgId{get;set;}
		public String msgTarget{get;set;}
		public String msgLanguage{get;set;}
	}
	public class nbsapdpi{
		public String trace{get;set;}
		public String application{get;set;}
		public String channel{get;set;}
	}
	public class finalMsgId{
		public String finalMsgClass{get;set;}
		public String finalMsgCode{get;set;}
	}
	public class balFreqs{
		public String balDay{get;set;}
         public balFreqs(){
            
        }
        public balFreqs(String input){
            balDay = input;
        }
	}
    
        public static nqupdatenotificationsv1_Req_IB_v1 createDummyBean(){
          nqupdatenotificationsv1_Req_IB_v1 requestbean = new nqupdatenotificationsv1_Req_IB_v1();
          nqupdatenotificationsv1_Req_IB_v1.NQupdJVProdNotificationAcctSettingsV1 NQupdJVProdNotificationAcctSettingsV1bean = new nqupdatenotificationsv1_Req_IB_v1.NQupdJVProdNotificationAcctSettingsV1();
          nqupdatenotificationsv1_Req_IB_v1.nqp204i nqp204ibean  = new nqupdatenotificationsv1_Req_IB_v1.nqp204i();
          nqupdatenotificationsv1_Req_IB_v1.finalMsgId finalMsgIdbean  = new nqupdatenotificationsv1_Req_IB_v1.finalMsgId();
          nqupdatenotificationsv1_Req_IB_v1.nbsapdpi nbsapdpibean  = new nqupdatenotificationsv1_Req_IB_v1.nbsapdpi();
          nqupdatenotificationsv1_Req_IB_v1.nbsmsgi nbsmsgibean  = new nqupdatenotificationsv1_Req_IB_v1.nbsmsgi();
            
          nqupdatenotificationsv1_Req_IB_v1.trnSelX trnSelXbean = new nqupdatenotificationsv1_Req_IB_v1.trnSelX();
          nqupdatenotificationsv1_Req_IB_v1.balFreqs balFreqsbean = new nqupdatenotificationsv1_Req_IB_v1.balFreqs();
          List<nqupdatenotificationsv1_Req_IB_v1.trnSelX> trnSelXlistbean = new List<nqupdatenotificationsv1_Req_IB_v1.trnSelX>();
          List<nqupdatenotificationsv1_Req_IB_v1.balFreqs> balFreqslistbean = new List<nqupdatenotificationsv1_Req_IB_v1.balFreqs>();
   
          
          finalMsgIdbean.finalMsgClass = 'test';
          finalMsgIdbean.finalMsgCode = 'test';
        
          nbsmsgibean.msgTarget = 'BDP';
          nbsmsgibean.msgLanguage = 'E';
          nbsmsgibean.finalMsgId = finalMsgIdbean;
        
          nbsapdpibean.trace = 'test';
       	  nbsapdpibean.application = 'test';
          nbsapdpibean.channel = 'test';
                  
          balFreqsbean.balDay = 'test';
          balFreqslistbean.add(balFreqsbean);
          
          trnSelXbean.trnSel = 'test';
          trnSelXlistbean.add(trnSelXbean);
        
          nqp204ibean.cif = '4048154875';
          nqp204ibean.accountNumber = 'test';//
          nqp204ibean.jvName = 'test';
          nqp204ibean.pnsRecipientId = '20191001';
          nqp204ibean.jvRefNo = 'test';//
          nqp204ibean.clientNotif = 'test';//
          nqp204ibean.registeringSite = 'BDP';  
          nqp204ibean.teller = '01';//
          nqp204ibean.balFreqs = balFreqslistbean;//
          nqp204ibean.minAm = 'BDP'; 
          nqp204ibean.trnSelX = trnSelXlistbean;//
          nqp204ibean.prodArea = 'BDP'; 
        
          NQupdJVProdNotificationAcctSettingsV1bean.nqp204i = nqp204ibean;
          NQupdJVProdNotificationAcctSettingsV1bean.nbsapdpi = nbsapdpibean;
          NQupdJVProdNotificationAcctSettingsV1bean.nbsmsgi = nbsmsgibean; 
          requestBean.NQupdJVProdNotificationAcctSettingsV1 = NQupdJVProdNotificationAcctSettingsV1bean;
          return requestbean;
    
    }
}