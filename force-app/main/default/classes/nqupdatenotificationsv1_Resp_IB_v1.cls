public class nqupdatenotificationsv1_Resp_IB_v1{
    
    public Integer statusCode{get;set;}
    public String StatusMessage {get;set;}
    public String status{get;set;}
    
	public NQupdJVProdNotificationAcctSettingsV1Response NQupdJVProdNotificationAcctSettingsV1Response{get;set;}
	public class NQupdJVProdNotificationAcctSettingsV1Response{
		public nbsmsgo nbsmsgo{get;set;}
		public nqp204o nqp204o{get;set;}
		public nbsapdpo nbsapdpo{get;set;}
	}
	public class nqp204o{
		public String rc{get;set;}
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
		public String msgClass{get;set;}
		public String msgTxt{get;set;}
		public String msgErrInd{get;set;}
		public String msgCode{get;set;}
	}
    public static nqupdatenotificationsv1_Resp_IB_v1 dummyResponse(){
          nqupdatenotificationsv1_Resp_IB_v1 responsebean = new nqupdatenotificationsv1_Resp_IB_v1();
          nqupdatenotificationsv1_Resp_IB_v1.NQupdJVProdNotificationAcctSettingsV1Response NQupdJVProdNotificationAcctSettingsV1Responsebean = new nqupdatenotificationsv1_Resp_IB_v1.NQupdJVProdNotificationAcctSettingsV1Response();
          nqupdatenotificationsv1_Resp_IB_v1.nbsmsgo nbsmsgobean  = new nqupdatenotificationsv1_Resp_IB_v1.nbsmsgo();
          nqupdatenotificationsv1_Resp_IB_v1.nqp204o nqp204obean  = new nqupdatenotificationsv1_Resp_IB_v1.nqp204o();
          nqupdatenotificationsv1_Resp_IB_v1.nbsapdpo nbsapdpobean  = new nqupdatenotificationsv1_Resp_IB_v1.nbsapdpo();
          nqupdatenotificationsv1_Resp_IB_v1.msgEntry msgEntrybean  = new nqupdatenotificationsv1_Resp_IB_v1.msgEntry();
       
          msgEntrybean.msgCode = 'BDP';
          msgEntrybean.msgTxt = 'E';
          msgEntrybean.msgErrInd = 'test';
          msgEntrybean.msgClass = 'test';
         
          nbsmsgobean.nbrUserErrs = 'test';
       	  nbsmsgobean.version = 'test';
          nbsmsgobean.nbrUserMsgs = 'test';
          nbsmsgobean.msgEntry = msgEntrybean;
                  
         
          nqp204obean.rc = '0';
        
         
          nbsapdpobean.serviceVersion = 'test';
          nbsapdpobean.reasonCode = '03';
          nbsapdpobean.returnCode = 'test';//
          
         
          NQupdJVProdNotificationAcctSettingsV1Responsebean.nbsmsgo = nbsmsgobean;
          NQupdJVProdNotificationAcctSettingsV1Responsebean.nqp204o = nqp204obean;
          NQupdJVProdNotificationAcctSettingsV1Responsebean.nbsapdpo = nbsapdpobean; 
          responsebean.NQupdJVProdNotificationAcctSettingsV1Response = NQupdJVProdNotificationAcctSettingsV1Responsebean;
          return responsebean;
    
    }
}