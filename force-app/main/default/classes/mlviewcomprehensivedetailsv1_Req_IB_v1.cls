public class mlviewcomprehensivedetailsv1_Req_IB_v1 extends Base_IB{
    public MLviewComprehensiveDetailsV1 MLviewComprehensiveDetailsV1{get;set;}
    public class nbsapdpi{
        public String trace{get;set;}
        public String application{get;set;}
        public String channel{get;set;}
    }
    public class MLviewComprehensiveDetailsV1{
        public nbsapdpi nbsapdpi{get;set;}
        public mlp047i mlp047i{get;set;}
    }
    public class mlp047i{
        public String continue_sfdc{get;set;}
        public String accn{get;set;}
        public String functi{get;set;}
        public String prtell{get;set;}
        public String debug{get;set;}
        public String prsite{get;set;}
        public String func{get;set;}
        public String tranIn{get;set;}
    }
    public	mlviewcomprehensivedetailsv1_Req_IB_v1 createDummyBean(){
        mlviewcomprehensivedetailsv1_Req_IB_v1 requestbean = new mlviewcomprehensivedetailsv1_Req_IB_v1();
        mlviewcomprehensivedetailsv1_Req_IB_v1.mlviewcomprehensivedetailsv1 mlviewcomprehensivedetailsv1bean = new mlviewcomprehensivedetailsv1_Req_IB_v1.mlviewcomprehensivedetailsv1();
        mlviewcomprehensivedetailsv1_Req_IB_v1.mlp047i mlp047ibean  = new mlviewcomprehensivedetailsv1_Req_IB_v1.mlp047i();
        mlviewcomprehensivedetailsv1_Req_IB_v1.nbsapdpi nbsapdpibean  = new mlviewcomprehensivedetailsv1_Req_IB_v1.nbsapdpi();
        nbsapdpibean.trace = 'test';
        nbsapdpibean.application = 'test';
        nbsapdpibean.channel = 'test';
        //mlp047ibean.continue = '0';
        mlp047ibean.accn = '00000008052424088';
        mlp047ibean.functi = 'R';
        mlp047ibean.prtell = '999999';
        mlp047ibean.debug = 'N';
        mlp047ibean.prsite = '034';
        mlp047ibean.func = 'ONLI';
        mlp047ibean.tranIn = 'MBDP';
        mlviewcomprehensivedetailsv1bean.mlp047i = mlp047ibean;
        mlviewcomprehensivedetailsv1bean.nbsapdpi = nbsapdpibean; 
        requestBean.mlviewcomprehensivedetailsv1 = mlviewcomprehensivedetailsv1bean;
        return requestbean;
        
    }   
}