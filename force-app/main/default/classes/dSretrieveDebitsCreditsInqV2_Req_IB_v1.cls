public class dSretrieveDebitsCreditsInqV2_Req_IB_v1{

    public DSretrieveDebitsCreditsInqV2 DSretrieveDebitsCreditsInqV2{get;set;}
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
    public class DSretrieveDebitsCreditsInqV2{
        public nbsmsgi nbsmsgi{get;set;}
        public dsp973i dsp973i{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    public class dsp973i{
        public String functionI{get;set;}
        public String acno{get;set;}
        public String branch{get;set;}
        public String effFromDate{get;set;}
        public String versionI{get;set;}
        public String nxtTieb{get;set;}
        public String channelI{get;set;}
        
    }
       
    public dSretrieveDebitsCreditsInqV2_Req_IB_v1 createDummyBean(){
          dSretrieveDebitsCreditsInqV2_Req_IB_v1 requestbean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1();
          dSretrieveDebitsCreditsInqV2_Req_IB_v1.DSretrieveDebitsCreditsInqV2 DSretrieveDebitsCreditsInqV2bean = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.DSretrieveDebitsCreditsInqV2();
          dSretrieveDebitsCreditsInqV2_Req_IB_v1.dsp973i dsp973ibean  = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.dsp973i();
          dSretrieveDebitsCreditsInqV2_Req_IB_v1.finalMsgId finalMsgIdbean  = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.finalMsgId();
          dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsapdpi nbsapdpibean  = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsapdpi();
          dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsmsgi nbsmsgibean  = new dSretrieveDebitsCreditsInqV2_Req_IB_v1.nbsmsgi();
          
          
          finalMsgIdbean.finalMsgClass = 'test';
          finalMsgIdbean.finalMsgCode = 'test';
        
          nbsmsgibean.msgTarget = 'BDP';
          nbsmsgibean.msgLanguage = 'E';
          nbsmsgibean.finalMsgId = finalMsgIdbean;
        
          nbsapdpibean.trace = 'test';
       	  nbsapdpibean.application = 'test';
          nbsapdpibean.channel = 'test';
        
          dsp973ibean.acno = '4048154875';
          dsp973ibean.functionI = 'SPID';
          dsp973ibean.branch = '034';
          dsp973ibean.effFromDate = '20191001';
          dsp973ibean.versionI = '01';
          dsp973ibean.nxtTieb = 'test';
          dsp973ibean.channelI = 'BDP';  
          DSretrieveDebitsCreditsInqV2bean.dsp973i = dsp973ibean;
          DSretrieveDebitsCreditsInqV2bean.nbsapdpi = nbsapdpibean;
          DSretrieveDebitsCreditsInqV2bean.nbsmsgi = nbsmsgibean; 
          requestBean.DSretrieveDebitsCreditsInqV2 = DSretrieveDebitsCreditsInqV2bean;
          return requestbean;
    
    }
    
}