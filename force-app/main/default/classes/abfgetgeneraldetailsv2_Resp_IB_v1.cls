public class abfgetgeneraldetailsv2_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public Integer statusCode{get;set;}
    @AuraEnabled public String StatusMessage {get;set;}
    @AuraEnabled public String status{get;set;}
    
    @AuraEnabled public ABFgetGeneralDetailsV2Response ABFgetGeneralDetailsV2Response{get;set;}
    public class plpa20o{
        @AuraEnabled public String portfCover{get;set;}
        @AuraEnabled public String stampDuty{get;set;}
        @AuraEnabled public String dteConverted{get;set;}
        @AuraEnabled public String addRepayInd{get;set;}
        @AuraEnabled public String dteHistArchived{get;set;}
        @AuraEnabled public String docfeeVat{get;set;}
        @AuraEnabled public String chrgInterest{get;set;}
        @AuraEnabled public String securities{get;set;}
        @AuraEnabled public String chrgCapital{get;set;}
        @AuraEnabled public String commOutstanding{get;set;}
        @AuraEnabled public String addInterest{get;set;}
        @AuraEnabled public String insurance{get;set;}
        @AuraEnabled public String addCapital{get;set;}
        @AuraEnabled public String insurancePrem{get;set;}
        @AuraEnabled public String suppInterest{get;set;}
        @AuraEnabled public String assurance{get;set;}
        @AuraEnabled public String suppCapital{get;set;}
        @AuraEnabled public String creditLife{get;set;}
        @AuraEnabled public String outInterest{get;set;}
        @AuraEnabled public String refundFinst{get;set;}
        @AuraEnabled public String outCapital{get;set;}
        @AuraEnabled public String advIntPaid{get;set;}
        @AuraEnabled public String initInterest{get;set;}
        @AuraEnabled public String dateWo{get;set;}
        @AuraEnabled public String initCapital{get;set;}
        @AuraEnabled public String badDebtAmt{get;set;}
        @AuraEnabled public String ncaIndicator{get;set;}
        @AuraEnabled public String amountAdvanced{get;set;}
        @AuraEnabled public String cashbackAmount{get;set;}
        @AuraEnabled public String lastAdvDate{get;set;}
        @AuraEnabled public String cashbackDate{get;set;}
        @AuraEnabled public String amountAvailable{get;set;}
        @AuraEnabled public String empFundCode{get;set;}
        @AuraEnabled public String permitWithdrawal{get;set;}
        @AuraEnabled public String termLoanType{get;set;}
        @AuraEnabled public String unclearedChq{get;set;}
    }
    public class nbsmsgo3{
        @AuraEnabled public msgEntry msgEntry{get;set;}
        @AuraEnabled public String nbrUserErrs{get;set;}
        @AuraEnabled public String version{get;set;}
        @AuraEnabled public String sysErrTxt{get;set;}
        @AuraEnabled public String nbrUserMsgs{get;set;}
    }
    public class nbsapdpo{
        @AuraEnabled  public String reasonCode{get;set;}
        @AuraEnabled public String returnCode{get;set;}
    }
    public class msgEntry{
        @AuraEnabled public String msgClass{get;set;}
        @AuraEnabled public String msgTxt{get;set;}
        @AuraEnabled public String msgErrInd{get;set;}
        @AuraEnabled public String msgCode{get;set;}
    }
    public class ABFgetGeneralDetailsV2Response{
        @AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
        @AuraEnabled public plpa20o plpa20o{get;set;}
        @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
    }
    public static abfgetgeneraldetailsv2_Resp_IB_v1 dummyResponse(){
        abfgetgeneraldetailsv2_Resp_IB_v1 responseBean = new abfgetgeneraldetailsv2_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.StatusMessage='SUCCESS';
        abfgetgeneraldetailsv2_Resp_IB_v1.msgEntry msgEntrybean = new abfgetgeneraldetailsv2_Resp_IB_v1.msgEntry(); 
        
        msgEntrybean.msgTxt = 'test';
        msgEntrybean.msgErrInd = 'test';
        msgEntrybean.msgCode = 'test';
        msgEntrybean.msgClass = 'test';
        abfgetgeneraldetailsv2_Resp_IB_v1.nbsmsgo3 nbsmsgo3bean = new abfgetgeneraldetailsv2_Resp_IB_v1.nbsmsgo3();
        nbsmsgo3bean.msgEntry = msgEntrybean;
        nbsmsgo3bean.nbrUserErrs = 'test';
        nbsmsgo3bean.version = 'test';
        nbsmsgo3bean.sysErrTxt = 'test';
        nbsmsgo3bean.nbrUserMsgs = 'test';
        
        abfgetgeneraldetailsv2_Resp_IB_v1.plpa20o plpa20obean = new abfgetgeneraldetailsv2_Resp_IB_v1.plpa20o();
        plpa20obean.portfCover= 'test';
        plpa20obean.stampDuty= 'test';
        plpa20obean.dteConverted= 'test';
        plpa20obean.addRepayInd= 'test';
        plpa20obean.dteHistArchived= 'test';
        plpa20obean.docfeeVat= 'test';
        plpa20obean.chrgInterest= 'test';
        plpa20obean.securities= 'test';
        plpa20obean.chrgCapital= 'test';
        plpa20obean.commOutstanding= 'test';
        plpa20obean.addInterest= 'test';
        plpa20obean.insurance= 'test';
        plpa20obean.addCapital= 'test';
        plpa20obean.insurancePrem= 'test';
        plpa20obean.suppInterest= 'test';
        plpa20obean.assurance= 'test';
        plpa20obean.suppCapital= 'test';
        plpa20obean.creditLife= 'test';
        plpa20obean.outInterest= 'test';
        plpa20obean.refundFinst= 'test';
        plpa20obean.outCapital= 'test';
        plpa20obean.advIntPaid= 'test';
        plpa20obean.initInterest= 'test';
        plpa20obean.dateWo= 'test';
        plpa20obean.initCapital= 'test';
        plpa20obean.badDebtAmt= 'test';
        plpa20obean.ncaIndicator= 'test';
        plpa20obean.amountAdvanced= 'test';
        plpa20obean.cashbackAmount= 'test';
        plpa20obean.lastAdvDate= 'test';
        plpa20obean.cashbackDate= 'test';
        plpa20obean.amountAvailable= 'test';
        plpa20obean.empFundCode= 'test';
        plpa20obean.permitWithdrawal= 'test';
        plpa20obean.termLoanType= 'test';
        plpa20obean.unclearedChq= 'test';
        abfgetgeneraldetailsv2_Resp_IB_v1.nbsapdpo nbsapdpobean = new abfgetgeneraldetailsv2_Resp_IB_v1.nbsapdpo();
        nbsapdpobean.reasonCode = 'test';
        nbsapdpobean.returnCode = 'test';
        abfgetgeneraldetailsv2_Resp_IB_v1.abfgetgeneraldetailsv2Response abfgetgeneraldetailsv2Responsebean=  new abfgetgeneraldetailsv2_Resp_IB_v1.abfgetgeneraldetailsv2Response();
        abfgetgeneraldetailsv2Responsebean.nbsmsgo3 = nbsmsgo3bean;
        abfgetgeneraldetailsv2Responsebean.nbsapdpo = nbsapdpobean; 
        abfgetgeneraldetailsv2Responsebean.plpa20o = plpa20obean;
        responsebean.abfgetgeneraldetailsv2Response = abfgetgeneraldetailsv2Responsebean;
        return responseBean;
    }
}