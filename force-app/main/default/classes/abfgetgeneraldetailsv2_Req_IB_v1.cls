public class abfgetgeneraldetailsv2_Req_IB_v1 extends Base_IB{
    
    public ABFgetGeneralDetailsV2 ABFgetGeneralDetailsV2{get;set;}
    public class plpa20i{
        public String accountNbr{get;set;}
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
    public class ABFgetGeneralDetailsV2{
        public nbsmsgi nbsmsgi{get;set;}
        public plpa20i plpa20i{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    public abfgetgeneraldetailsv2_Req_IB_v1 createDummyBean(){
        abfgetgeneraldetailsv2_Req_IB_v1 requestbean = new abfgetgeneraldetailsv2_Req_IB_v1();
        abfgetgeneraldetailsv2_Req_IB_v1.abfgetgeneraldetailsv2 abfgetgeneraldetailsv2bean = new abfgetgeneraldetailsv2_Req_IB_v1.abfgetgeneraldetailsv2();
        abfgetgeneraldetailsv2_Req_IB_v1.plpa20i plpa20ibean  = new abfgetgeneraldetailsv2_Req_IB_v1.plpa20i();
        abfgetgeneraldetailsv2_Req_IB_v1.finalMsgId finalMsgIdbean  = new abfgetgeneraldetailsv2_Req_IB_v1.finalMsgId();
        abfgetgeneraldetailsv2_Req_IB_v1.nbsapdpi nbsapdpibean  = new abfgetgeneraldetailsv2_Req_IB_v1.nbsapdpi();
        abfgetgeneraldetailsv2_Req_IB_v1.nbsmsgi nbsmsgibean  = new abfgetgeneraldetailsv2_Req_IB_v1.nbsmsgi();
        finalMsgIdbean.finalMsgClass = 'test';
        finalMsgIdbean.finalMsgCode = 'test';
        nbsmsgibean.msgTarget = 'BDP';
        nbsmsgibean.msgLanguage = 'E';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        nbsapdpibean.trace = 'test';
        nbsapdpibean.application = 'test';
        nbsapdpibean.channel = 'test';
        plpa20ibean.accountNbr = '4048154875';
        abfgetgeneraldetailsv2bean.plpa20i = plpa20ibean;
        abfgetgeneraldetailsv2bean.nbsapdpi = nbsapdpibean;
        abfgetgeneraldetailsv2bean.nbsmsgi = nbsmsgibean; 
        requestBean.abfgetgeneraldetailsv2 = abfgetgeneraldetailsv2bean;
        return requestbean;
        
    }
}