public class nqcancelacctnotificationv1_Resp_IB_v1{
	
	public Integer statusCode{get;set;}
    public String StatusMessage {get;set;}
    public String status{get;set;}
	
	public NQcancelAnAcctJVProdNotificationV1Response NQcancelAnAcctJVProdNotificationV1Response{get;set;}
	public class nqp207o{
		public String rc{get;set;}
		public String pnsRecipientId{get;set;}
	}
	public class NQcancelAnAcctJVProdNotificationV1Response{
		public nbsmsgo nbsmsgo{get;set;}
		public nqp207o nqp207o{get;set;}
		public nbsapdpo nbsapdpo{get;set;}
	}
	public class nbsmsgo{
		public String nbrUserMsgs{get;set;}
		public String version{get;set;}
		public String sysErrTxt{get;set;}
		public msgEntry msgEntry{get;set;}
		public String nbrUserErrs{get;set;}
	}
	public class nbsapdpo{
		public String serviceVersion{get;set;}
		public String reasonCode{get;set;}
		public String returnCode{get;set;}
	}
	public class msgEntry{
		public String msgCode{get;set;}
		public String msgTxt{get;set;}
		public String msgErrInd{get;set;}
		public String msgClass{get;set;}
	}
     public static nqcancelacctnotificationv1_Resp_IB_v1 dummyResponse(){
          nqcancelacctnotificationv1_Resp_IB_v1 responsebean = new nqcancelacctnotificationv1_Resp_IB_v1();
          nqcancelacctnotificationv1_Resp_IB_v1.NQcancelAnAcctJVProdNotificationV1Response NQcancelAnAcctJVProdNotificationV1Responsebean = new nqcancelacctnotificationv1_Resp_IB_v1.NQcancelAnAcctJVProdNotificationV1Response();
          nqcancelacctnotificationv1_Resp_IB_v1.nbsmsgo nbsmsgobean  = new nqcancelacctnotificationv1_Resp_IB_v1.nbsmsgo();
          nqcancelacctnotificationv1_Resp_IB_v1.nqp207o nqp207obean  = new nqcancelacctnotificationv1_Resp_IB_v1.nqp207o();
          nqcancelacctnotificationv1_Resp_IB_v1.nbsapdpo nbsapdpobean  = new nqcancelacctnotificationv1_Resp_IB_v1.nbsapdpo();
          nqcancelacctnotificationv1_Resp_IB_v1.msgEntry msgEntrybean  = new nqcancelacctnotificationv1_Resp_IB_v1.msgEntry();
       
          msgEntrybean.msgCode = 'BDP';
          msgEntrybean.msgTxt = 'E';
          msgEntrybean.msgErrInd = 'test';
          msgEntrybean.msgClass = 'test';
         
          nbsmsgobean.nbrUserErrs = 'test';
       	  nbsmsgobean.version = 'test';
          nbsmsgobean.nbrUserMsgs = 'test';
          nbsmsgobean.msgEntry = msgEntrybean;
                  
         
          nqp207obean.rc = '0';
          nqp207obean.pnsRecipientId = 'test';
         
          nbsapdpobean.serviceVersion = 'test';
          nbsapdpobean.reasonCode = '03';
          nbsapdpobean.returnCode = 'test';//
          
         
          NQcancelAnAcctJVProdNotificationV1Responsebean.nbsmsgo = nbsmsgobean;
          NQcancelAnAcctJVProdNotificationV1Responsebean.nqp207o = nqp207obean;
          NQcancelAnAcctJVProdNotificationV1Responsebean.nbsapdpo = nbsapdpobean; 
          responsebean.NQcancelAnAcctJVProdNotificationV1Response = NQcancelAnAcctJVProdNotificationV1Responsebean;
          return responsebean;
    
    }
}