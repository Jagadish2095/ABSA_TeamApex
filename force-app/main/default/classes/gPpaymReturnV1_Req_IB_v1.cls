public class gPpaymReturnV1_Req_IB_v1{
    
    public GPpaymReturnV1 GPpaymReturnV1{get;set;}
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
    public class GPpaymReturnV1{
        public nbsapdpi nbsapdpi{get;set;}
        public gpp506i gpp506i{get;set;}
        public nbsmsgi nbsmsgi{get;set;}
    }
    public class gpp506i{
        public String func{get;set;}
        public String resn{get;set;}
        public String tkey{get;set;}
        public String brcd{get;set;}
        public String acno{get;set;}
        public String tell{get;set;}
        public String versionI{get;set;}
        public String sitetp{get;set;}
        public String spare{get;set;}
    }
    public class finalMsgId{
        public String finalMsgCode{get;set;}
        public String finalMsgClass{get;set;}
    }
   public gPpaymReturnV1_Req_IB_v1 createDummyBean(){
          gPpaymReturnV1_Req_IB_v1 requestbean = new gPpaymReturnV1_Req_IB_v1();
          gPpaymReturnV1_Req_IB_v1.GPpaymReturnV1 GPpaymReturnV1bean = new gPpaymReturnV1_Req_IB_v1.GPpaymReturnV1();
          gPpaymReturnV1_Req_IB_v1.gpp506i gpp506ibean  = new gPpaymReturnV1_Req_IB_v1.gpp506i();
          gPpaymReturnV1_Req_IB_v1.finalMsgId finalMsgIdbean  = new gPpaymReturnV1_Req_IB_v1.finalMsgId();
          gPpaymReturnV1_Req_IB_v1.nbsmsgi nbsmsgibean  = new gPpaymReturnV1_Req_IB_v1.nbsmsgi();
          gPpaymReturnV1_Req_IB_v1.nbsapdpi nbsapdpibean  = new gPpaymReturnV1_Req_IB_v1.nbsapdpi();
       
          finalMsgIdbean.finalMsgClass = 'test';
          finalMsgIdbean.finalMsgCode = 'test';
         
		  nbsmsgibean.msgTarget = 'BDP';
          nbsmsgibean.msgLanguage = 'E';
          nbsmsgibean.finalMsgId = finalMsgIdbean;
         
          nbsapdpibean.trace = 'test';
       	  nbsapdpibean.application = 'test';
          nbsapdpibean.channel = 'test';
         
          gpp506ibean.brcd = '8198';
          gpp506ibean.resn = '30';
          gpp506ibean.tkey = '1343AC025F6F111DBB19';
          gpp506ibean.tell = '1110022';
          gpp506ibean.acno = '4044751304';
          gpp506ibean.sitetp = '034';
          gpp506ibean.versionI = '01';
          gpp506ibean.spare = '33';
          gpp506ibean.func = 'SRDT';
       
          GPpaymReturnV1bean.nbsmsgi = nbsmsgibean;
          GPpaymReturnV1bean.nbsapdpi = nbsapdpibean;
          GPpaymReturnV1bean.gpp506i = gpp506ibean; 
          requestBean.GPpaymReturnV1 =  GPpaymReturnV1bean;
          return requestbean;
    
    }
}