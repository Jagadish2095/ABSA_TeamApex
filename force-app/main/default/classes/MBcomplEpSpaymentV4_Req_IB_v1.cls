public class MBcomplEpSpaymentV4_Req_IB_v1 extends Base_IB{
   // public mbp302i mbp302i{get;set;}    
    public MBcomplEPSpaymentV4 MBcomplEPSpaymentV4{get;set;}
   public class nbsmsgi{
        public String msgTarget{get;set;}
        public String msgLanguage{get;set;}
    }
    public class nbsapdpi{
        public String trace{get;set;}
        public String application{get;set;}
        public String channel{get;set;}
    }
    
    public class mbp302i{

        public String channel{get;set;}
        public String overrideCompl{get;set;}
        public String instrType{get;set;}
        public String uniqueEft{get;set;}
        public String paymNo{get;set;}
        public String paymIipInd{get;set;}
        public String initpaymOverride{get;set;}
        public String tellerAmtAuth{get;set;}
        public String productsSpa{get;set;}
        public String tranCodeDr{get;set;}
        public String sfncCodeDr{get;set;}
        public String sourceIndDr{get;set;}
        public String tranCodeCr{get;set;}
        public String sfncCodeCr{get;set;}
        public String changeOverride{get;set;}

        
    }    
    public class MBcomplEPSpaymentV4{
        
        public mbp302i mbp302i{get;set;}
        public nbsmsgi nbsmsgi{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    
    
    public MBcomplEpSpaymentV4_Req_IB_v1 createDummyRequest(){ 
        
       MBcomplEpSpaymentV4_Req_IB_v1 responseBean = new MBcomplEpSpaymentV4_Req_IB_v1();   
        mbp302i reqBean = new mbp302i(); 
        
        reqBean.paymNo = '1';
        reqBean.uniqueEft = '80003705DB';
        reqBean.paymIipInd = 'D';
        reqBean.instrType = 'OOP';
        reqBean.channel = 'INTERNET';
        return responseBean;
    }
    

    
}