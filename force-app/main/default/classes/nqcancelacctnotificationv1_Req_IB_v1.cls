public class nqcancelacctnotificationv1_Req_IB_v1{
	
	public NQcancelAnAcctJVProdNotificationV1 NQcancelAnAcctJVProdNotificationV1{get;set;}
	public class nqp207i{
		public String cif{get;set;}
		public String accountNumber{get;set;}
		public String jvName{get;set;}
		public String pnsRecipientId{get;set;}
		public String jvRefNo{get;set;}
		public String clientNotif{get;set;}
		public String registeringSite{get;set;}
	}
	public class NQcancelAnAcctJVProdNotificationV1{
		public nbsmsgi nbsmsgi{get;set;}
		public nqp207i nqp207i{get;set;}
		public nbsapdpi nbsapdpi{get;set;}
	}
	public class nbsmsgi{
		public String msgTarget{get;set;}
		public String msgLanguage{get;set;}
		public finalMsgId finalMsgId{get;set;}
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
    public static nqcancelacctnotificationv1_Req_IB_v1 createDummyBean(){
          nqcancelacctnotificationv1_Req_IB_v1 requestbean = new nqcancelacctnotificationv1_Req_IB_v1();
          nqcancelacctnotificationv1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1 NQcancelAnAcctJVProdNotificationV1bean = new nqcancelacctnotificationv1_Req_IB_v1.NQcancelAnAcctJVProdNotificationV1();
          nqcancelacctnotificationv1_Req_IB_v1.nqp207i nqp207ibean  = new nqcancelacctnotificationv1_Req_IB_v1.nqp207i();
          nqcancelacctnotificationv1_Req_IB_v1.finalMsgId finalMsgIdbean  = new nqcancelacctnotificationv1_Req_IB_v1.finalMsgId();
          nqcancelacctnotificationv1_Req_IB_v1.nbsapdpi nbsapdpibean  = new nqcancelacctnotificationv1_Req_IB_v1.nbsapdpi();
          nqcancelacctnotificationv1_Req_IB_v1.nbsmsgi nbsmsgibean  = new nqcancelacctnotificationv1_Req_IB_v1.nbsmsgi();
            
          finalMsgIdbean.finalMsgClass = 'test';
          finalMsgIdbean.finalMsgCode = 'test';
        
          nbsmsgibean.msgTarget = 'BDP';
          nbsmsgibean.msgLanguage = 'E';
          nbsmsgibean.finalMsgId = finalMsgIdbean;
        
          nbsapdpibean.trace = 'test';
       	  nbsapdpibean.application = 'test';
          nbsapdpibean.channel = 'test';
                  
         
          nqp207ibean.cif = '4048154875';
          nqp207ibean.accountNumber = 'test';//
          nqp207ibean.jvName = 'test';
          nqp207ibean.pnsRecipientId = '20191001';
          nqp207ibean.jvRefNo = 'test';//
          nqp207ibean.clientNotif = 'test';//
          nqp207ibean.registeringSite = 'BDP';  
         
          NQcancelAnAcctJVProdNotificationV1bean.nqp207i = nqp207ibean;
          NQcancelAnAcctJVProdNotificationV1bean.nbsapdpi = nbsapdpibean;
          NQcancelAnAcctJVProdNotificationV1bean.nbsmsgi = nbsmsgibean; 
          requestBean.NQcancelAnAcctJVProdNotificationV1 = NQcancelAnAcctJVProdNotificationV1bean;
          return requestbean;
    
    }
}