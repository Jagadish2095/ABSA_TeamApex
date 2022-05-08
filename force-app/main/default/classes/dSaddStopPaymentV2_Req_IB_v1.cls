public class dSaddStopPaymentV2_Req_IB_v1{
    
    public DSaddStopPaymentV2 DSaddStopPaymentV2{get;set;}
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
    public class dsc976iInputArea{
        public String actDate{get;set;}
        public String brnch{get;set;}
        public String amount{get;set;}
        public String teller{get;set;}
        public String userRef{get;set;}
        public String caseNo{get;set;}
        public String userCode{get;set;}
        public String institution{get;set;}
        public String effDate{get;set;}
        public String accNo{get;set;}
    }
    public class DSaddStopPaymentV2{
        public nbsmsgi nbsmsgi{get;set;}
        public dsc976iInputArea dsc976iInputArea{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
     public dSaddStopPaymentV2_Req_IB_v1 createDummyBean(){
          dSaddStopPaymentV2_Req_IB_v1 requestbean = new dSaddStopPaymentV2_Req_IB_v1();
          dSaddStopPaymentV2_Req_IB_v1.DSaddStopPaymentV2 DSaddStopPaymentV2bean = new dSaddStopPaymentV2_Req_IB_v1.DSaddStopPaymentV2();
          dSaddStopPaymentV2_Req_IB_v1.dsc976iInputArea dsc976iInputAreabean  = new dSaddStopPaymentV2_Req_IB_v1.dsc976iInputArea();
          dSaddStopPaymentV2_Req_IB_v1.nbsmsgi nbsmsgibean  = new dSaddStopPaymentV2_Req_IB_v1.nbsmsgi();
          dSaddStopPaymentV2_Req_IB_v1.finalMsgId finalMsgIdbean  = new dSaddStopPaymentV2_Req_IB_v1.finalMsgId();
          dSaddStopPaymentV2_Req_IB_v1.nbsapdpi nbsapdpibean  = new dSaddStopPaymentV2_Req_IB_v1.nbsapdpi();
         
          finalMsgIdbean.finalMsgClass = 'test';
          finalMsgIdbean.finalMsgCode = 'test';
         
		  nbsmsgibean.msgTarget = 'BDP';
          nbsmsgibean.msgLanguage = 'E';
          nbsmsgibean.finalMsgId = finalMsgIdbean;
         
          nbsapdpibean.trace = 'test';
       	  nbsapdpibean.application = 'test';
          nbsapdpibean.channel = 'test';
         
         
          dsc976iInputAreabean.brnch = '32322';
          dsc976iInputAreabean.amount = '100';
          dsc976iInputAreabean.teller = '12122';
          dsc976iInputAreabean.userRef= '01023423 011     CC';
          dsc976iInputAreabean.caseNo = '12345678';
          dsc976iInputAreabean.userCode = '0110';
          dsc976iInputAreabean.institution = 'ABSA CARD';
          dsc976iInputAreabean.actDate = '20191017';
          dsc976iInputAreabean.effDate = '20191009';
          dsc976iInputAreabean.accNo = '20191009';
         
          DSaddStopPaymentV2bean.nbsmsgi = nbsmsgibean;
          DSaddStopPaymentV2bean.nbsapdpi = nbsapdpibean;
          DSaddStopPaymentV2bean.dsc976iInputArea = dsc976iInputAreabean; 
          requestBean.DSaddStopPaymentV2 =  DSaddStopPaymentV2bean;
          return requestbean;
          
    
    }
}