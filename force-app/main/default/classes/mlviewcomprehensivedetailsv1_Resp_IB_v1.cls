public class mlviewcomprehensivedetailsv1_Resp_IB_v1 extends Base_IB {
    @AuraEnabled  public String status;
    @AuraEnabled  public Integer StatusCode;
    @AuraEnabled  public String StatusMessage;
    @AuraEnabled public MLviewComprehensiveDetailsV1Response MLviewComprehensiveDetailsV1Response{get;set;}
    public class nbsapdpo{
        @AuraEnabled public String serviceVersion{get;set;}
        @AuraEnabled public String echoKey{get;set;}
        @AuraEnabled public String reasonCode{get;set;}
        @AuraEnabled public String returnCode{get;set;}
        @AuraEnabled public String version{get;set;}
    }
    public class MLviewComprehensiveDetailsV1Response{
       @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
       @AuraEnabled public mlp047o mlp047o{get;set;}
    }
    public class mlp047o{
        @AuraEnabled public String admin{get;set;}
        @AuraEnabled public String saveBondAmount{get;set;}
        @AuraEnabled public String hmp{get;set;}
        @AuraEnabled public String hoc{get;set;}
        @AuraEnabled public String fixind{get;set;}
        @AuraEnabled public String snypay{get;set;}
        @AuraEnabled public String instat{get;set;}
        @AuraEnabled public String expdte{get;set;}
        @AuraEnabled public String basins{get;set;}
        @AuraEnabled public String volexe{get;set;}
        @AuraEnabled public String remmm{get;set;}
        @AuraEnabled public String siramt{get;set;}
        @AuraEnabled public String remyy{get;set;}
        @AuraEnabled public String endow{get;set;}
        @AuraEnabled public String termmm{get;set;}
        @AuraEnabled public String tempin{get;set;}
        @AuraEnabled public String termyy{get;set;}
        @AuraEnabled public String temped{get;set;}
        @AuraEnabled public String ncdate{get;set;}
        @AuraEnabled public String totins{get;set;}
        @AuraEnabled public String ocdate{get;set;}
        @AuraEnabled public String ardate{get;set;}
        @AuraEnabled public String iccode{get;set;}
        @AuraEnabled public String volstd{get;set;}
        @AuraEnabled public String iddate{get;set;}
        @AuraEnabled public String volamt{get;set;}
        @AuraEnabled public String insfrq{get;set;}
        @AuraEnabled public String volper{get;set;}
        @AuraEnabled public String icdate{get;set;}
        @AuraEnabled public String volno{get;set;}
        @AuraEnabled public String ntuCount{get;set;}
        @AuraEnabled public String volinc{get;set;}
        @AuraEnabled public String grantListCount{get;set;}
        @AuraEnabled public String vonext{get;set;}
        @AuraEnabled public String commn{get;set;}
        @AuraEnabled public String affiri{get;set;}
        @AuraEnabled public String cgross{get;set;}
        @AuraEnabled public String myhome{get;set;}
        @AuraEnabled public String covtot{get;set;}
        @AuraEnabled public String affind{get;set;}
        @AuraEnabled public String bndtot{get;set;}
        @AuraEnabled public String affcga{get;set;}
        @AuraEnabled public String bondCount{get;set;}
        @AuraEnabled public String affsub{get;set;}
        @AuraEnabled public String holdCount{get;set;}
        @AuraEnabled public String affamt{get;set;}
        @AuraEnabled public String ncaind{get;set;}
        @AuraEnabled public String lifeac{get;set;}
        @AuraEnabled public String uaf{get;set;}
        @AuraEnabled public String hschem{get;set;}
        @AuraEnabled public String site{get;set;}
        @AuraEnabled public String empnbr{get;set;}
        @AuraEnabled public String dmlast{get;set;}
        @AuraEnabled public String schdes{get;set;}
        @AuraEnabled public String accntl{get;set;}
        @AuraEnabled public String cclass{get;set;}
        @AuraEnabled public String riskcd{get;set;}
        @AuraEnabled public String subsind{get;set;}
        @AuraEnabled public String dbind{get;set;}
        @AuraEnabled public String govscd{get;set;}
        @AuraEnabled public String cltyp{get;set;}
        @AuraEnabled public String notper{get;set;}
        @AuraEnabled public String passbk{get;set;}
        @AuraEnabled public String mrdate{get;set;}
        @AuraEnabled public String dombrc{get;set;}
        @AuraEnabled public String stcode{get;set;}
        @AuraEnabled public String btype{get;set;}
        @AuraEnabled public String efffin{get;set;}
        @AuraEnabled public String caddr5{get;set;}
        @AuraEnabled public String rpxdte{get;set;}
        @AuraEnabled public String caddr4{get;set;}
        @AuraEnabled public String fryy{get;set;}
        @AuraEnabled public String caddr3{get;set;}
        @AuraEnabled public String frmm{get;set;}
        @AuraEnabled public String caddr2{get;set;}
        @AuraEnabled public String rprcod{get;set;}
        @AuraEnabled public String caddr1{get;set;}
        @AuraEnabled public String cltcon{get;set;}
        @AuraEnabled public String clnt2{get;set;}
        @AuraEnabled public String minvar{get;set;}
        @AuraEnabled public String clnt1{get;set;}
        @AuraEnabled public String negvar{get;set;}
        @AuraEnabled public String bdcan{get;set;}
        @AuraEnabled public String hlpind{get;set;}
        @AuraEnabled public String capind{get;set;}
        @AuraEnabled public String rate{get;set;}
        @AuraEnabled public String corp{get;set;}
        @AuraEnabled public String propListCount{get;set;}
        @AuraEnabled public String accnid{get;set;}
        @AuraEnabled public String propInsurCount{get;set;}
        @AuraEnabled public String accn{get;set;}
        @AuraEnabled public String lifeAssurCount{get;set;}
        @AuraEnabled public String errsec{get;set;}
        @AuraEnabled public String errmsg{get;set;}
    }
    public static mlviewcomprehensivedetailsv1_Resp_IB_v1 dummyResponse(){
        mlviewcomprehensivedetailsv1_Resp_IB_v1 responseBean = new mlviewcomprehensivedetailsv1_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.StatusMessage='SUCCESS';
        mlviewcomprehensivedetailsv1_Resp_IB_v1.nbsapdpo nbsapdpobean = new mlviewcomprehensivedetailsv1_Resp_IB_v1.nbsapdpo(); 
        nbsapdpobean.serviceVersion = 'test';
        nbsapdpobean.echoKey = 'test';
        nbsapdpobean.reasonCode = 'test';
        nbsapdpobean.returnCode = 'test';
        nbsapdpobean.version = 'test';
        mlviewcomprehensivedetailsv1_Resp_IB_v1.mlp047o mlp047obean = new mlviewcomprehensivedetailsv1_Resp_IB_v1.mlp047o();
        mlp047obean.admin = 'test';
        mlp047obean.saveBondAmount = 'test';
        mlp047obean.hmp = 'test';
        mlp047obean.hoc = 'test';
        mlp047obean.fixind = 'test';
        mlp047obean.snypay = 'test';
        mlp047obean.instat = 'test';
        mlp047obean.expdte = 'test';
        mlp047obean.basins = 'test';
        mlp047obean.volexe = 'test';
        mlp047obean.remmm = 'test';
        mlp047obean.siramt = 'test';
        mlp047obean.remyy = 'test';
        mlp047obean.endow = 'test';
        mlp047obean.termmm = 'test';
        mlp047obean.tempin = 'test';
        mlp047obean.termyy = 'test';
        mlp047obean.temped = 'test';
        mlp047obean.ncdate = 'test';
        mlp047obean.totins = 'test';
        mlp047obean.ocdate = 'test';
        mlp047obean.ardate = 'test';
        mlp047obean.iccode = 'test';
        mlp047obean.volstd = 'test';
        mlp047obean.iddate = 'test';
        mlp047obean.volamt = 'test';
        mlp047obean.insfrq = 'test';
        mlp047obean.volper = 'test';
        mlp047obean.icdate = 'test';
        mlp047obean.volno = 'test';
        mlp047obean.ntuCount = 'test';
        mlp047obean.volinc = 'test';
        mlp047obean.grantListCount = 'test';
        mlp047obean.vonext = 'test';
        mlp047obean.commn = 'test';
        mlp047obean.affiri = 'test';
        mlp047obean.cgross = 'test';
        mlp047obean.myhome = 'test';
        mlp047obean.covtot = 'test';
        mlp047obean.affind = 'test';
        mlp047obean.bndtot = 'test';
        mlp047obean.affcga = 'test';
        mlp047obean.bondCount = 'test';
        mlp047obean.affsub = 'test';
        mlp047obean.holdCount = 'test';
        mlp047obean.affamt = 'test';
        mlp047obean.ncaind = 'test';
        mlp047obean.lifeac = 'test';
        mlp047obean.uaf = 'test';
        mlp047obean.hschem = 'test';
        mlp047obean.site = 'test';
        mlp047obean.empnbr = 'test';
        mlp047obean.dmlast = 'test';
        mlp047obean.schdes = 'test';
        mlp047obean.accntl = 'test';
        mlp047obean.cclass = 'test';
        mlp047obean.riskcd = 'test';
        mlp047obean.subsind = 'test';
        mlp047obean.dbind = 'test';
        mlp047obean.govscd = 'test';
        mlp047obean.cltyp = 'test';
        mlp047obean.notper = 'test';
        mlp047obean.passbk = 'test';
        mlp047obean.mrdate = 'test';
        mlp047obean.dombrc = 'test';
        mlp047obean.stcode = 'test';
        mlp047obean.btype = 'test';
        mlp047obean.efffin = 'test';
        mlp047obean.caddr5 = 'test';
        mlp047obean.rpxdte = 'test';
        mlp047obean.caddr4 = 'test';
        mlp047obean.fryy = 'test';
        mlp047obean.caddr3 = 'test';
        mlp047obean.frmm = 'test';
        mlp047obean.caddr2 = 'test';
        mlp047obean.rprcod = 'test';
        mlp047obean.caddr1 = 'test';
        mlp047obean.cltcon = 'test';
        mlp047obean.clnt2 = 'test';
        mlp047obean.minvar = 'test';
        mlp047obean.clnt1 = 'test';
        mlp047obean.negvar = 'test';
        mlp047obean.bdcan = 'test';
        mlp047obean.hlpind = 'test';
        mlp047obean.capind = 'test';
        mlp047obean.rate = 'test';
        mlp047obean.corp = 'test';
        mlp047obean.propListCount = 'test';
        mlp047obean.accnid = 'test';
        mlp047obean.propInsurCount = 'test';
        mlp047obean.accn = 'test';
        mlp047obean.lifeAssurCount = 'test';
        mlp047obean.errsec = 'test';
        mlp047obean.errmsg = 'test';
        mlviewcomprehensivedetailsv1_Resp_IB_v1.mlviewcomprehensivedetailsv1Response mlviewcomprehensivedetailsv1Responsebean=  new mlviewcomprehensivedetailsv1_Resp_IB_v1.mlviewcomprehensivedetailsv1Response();
        mlviewcomprehensivedetailsv1Responsebean.nbsapdpo = nbsapdpobean;
        mlviewcomprehensivedetailsv1Responsebean.mlp047o = mlp047obean; 
        responsebean.mlviewcomprehensivedetailsv1Response = mlviewcomprehensivedetailsv1Responsebean;
        return responseBean;
    }
}