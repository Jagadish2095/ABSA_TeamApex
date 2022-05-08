public class MBinitiatePaymentV10_Resp_IB_v1{
    @AuraEnabled Public List<MBinitiatePaymentV10Response> responseList{set;get;}
    @AuraEnabled public Integer statusCode{get;set;}
    @AuraEnabled public String StatusMessage {get;set;}
    @AuraEnabled public String status{get;set;}
    @AuraEnabled public String RequesterReference{get;set;}
    @AuraEnabled public MBinitiatePaymentV10Response MBinitiatePaymentV10Response{get;set;}
    public class nbsmsgo3{
        @AuraEnabled public String nbrUserMsgs{get;set;}
        @AuraEnabled public String sysErrTxt{get;set;}
        @AuraEnabled public String nbrUserErrs{get;set;}
        @AuraEnabled public String version{get;set;}
        @AuraEnabled public msgEntry msgEntry{get;set;}
    }
    public class nbsapdpo{
        @AuraEnabled public String serviceVersion{get;set;}
        @AuraEnabled public String reasonCode{get;set;}
        @AuraEnabled public String returnCode{get;set;}
        @AuraEnabled public String echoKey{get;set;}
        @AuraEnabled public String version{get;set;}
    }
    public class msgEntry{
        @AuraEnabled public String msgClass{get;set;}
        @AuraEnabled public String msgErrInd{get;set;}
        @AuraEnabled public String msgTxt{get;set;}
        @AuraEnabled  public String msgCode{get;set;}
    }
    public class mbn301o{
        @AuraEnabled public String trgAcc{get;set;}
        @AuraEnabled public String maxPayAmnt{get;set;}
        @AuraEnabled public String minPayAmnt{get;set;}
        @AuraEnabled public String iipAllowInd{get;set;}
        @AuraEnabled public String clientType{get;set;}
        @AuraEnabled public String lastChangeNo{get;set;}
        @AuraEnabled public String sbu{get;set;}
        @AuraEnabled public String lastMaintFunc{get;set;}
        @AuraEnabled public String corpCode{get;set;}
        @AuraEnabled public String lastMaintDate{get;set;}
        @AuraEnabled public String trgInstCode{get;set;}
        @AuraEnabled public String lastMaintTime{get;set;}
        @AuraEnabled public String trgClrCode{get;set;}
        @AuraEnabled public String lastMaintBrnch{get;set;}
        @AuraEnabled public String trgAccType{get;set;}
        @AuraEnabled public String lastMaintTell{get;set;}
        @AuraEnabled public String srcInstCode{get;set;}
        @AuraEnabled public String lastMaintOvrId{get;set;}
        @AuraEnabled public String srcClrCode{get;set;}
        @AuraEnabled public String paymNo{get;set;}
        @AuraEnabled public String srcAccType{get;set;}
        @AuraEnabled public String paymBusRef{get;set;}
        @AuraEnabled public String freq{get;set;}
        @AuraEnabled public String lastMaintOvr2Id{get;set;}
        @AuraEnabled public String endDate{get;set;}
        @AuraEnabled public String lastPaymDate{get;set;}
        @AuraEnabled public String startDate{get;set;}
        @AuraEnabled public String lastPaymAmnt{get;set;}
        @AuraEnabled public String trigDate{get;set;}
        @AuraEnabled public String lastPaymErr{get;set;}
        @AuraEnabled public String actDate{get;set;}
        @AuraEnabled public String abal{get;set;}
        @AuraEnabled public String intExtBenInd{get;set;}
        @AuraEnabled public String avbl{get;set;}
        @AuraEnabled public String uniqueEft{get;set;}
        @AuraEnabled public String statusCde{get;set;}
        @AuraEnabled public String fwWarnInd{get;set;}
        @AuraEnabled public String statusIndx{get;set;}
        @AuraEnabled public String keyFormat{get;set;}
        @AuraEnabled public String statusDesc{get;set;}
        @AuraEnabled public String instrTypeAccs{get;set;}
        @AuraEnabled public String primEvno{get;set;}
        @AuraEnabled public String instrTypeDuepe{get;set;}
        @AuraEnabled public String secEvno{get;set;}
        @AuraEnabled public String instrTypeDrcr{get;set;}
        @AuraEnabled public String emvscScriptDataLgth{get;set;}
        @AuraEnabled public String respDesc{get;set;}
        @AuraEnabled public String emvscScriptData{get;set;}
        @AuraEnabled public String recsReturn{get;set;}
        @AuraEnabled public String productsSpa{get;set;}
        @AuraEnabled public String respOther{get;set;}
        @AuraEnabled public String initpaymOverride{get;set;}
        @AuraEnabled public String respCode{get;set;}
        @AuraEnabled public String benGender{get;set;}
        @AuraEnabled public String timeNow{get;set;}
        @AuraEnabled public String benNonResStat{get;set;}
        @AuraEnabled public String todaysDate{get;set;}
    }
    
        public static MBinitiatePaymentV10_Resp_IB_v1 dummyResponse(){
                MBinitiatePaymentV10_Resp_IB_v1 responseBean = new MBinitiatePaymentV10_Resp_IB_v1();
                responseBean.status='OK';
                responseBean.statusCode=200;
                responseBean.StatusMessage='SUCCESS';
                MBinitiatePaymentV10_Resp_IB_v1.mbn301o dsresponse  = new MBinitiatePaymentV10_Resp_IB_v1.mbn301o();
                list<MBinitiatePaymentV10_Resp_IB_v1.mbn301o> listdsresponse  = new list<MBinitiatePaymentV10_Resp_IB_v1.mbn301o>();
                
                
                dsresponse.trgAcc='20190720';
                dsresponse.maxPayAmnt='4047715862    0046';
                dsresponse.minPayAmnt='test';
                dsresponse.iipAllowInd='AAASHSA004';
                dsresponse.clientType='test';
                dsresponse.lastChangeNo='test';
                dsresponse.sbu='test';
                dsresponse.lastMaintFunc='test';
                dsresponse.corpCode='test';
                dsresponse.lastMaintDate='test';
                dsresponse.trgInstCode='test';
                dsresponse.lastMaintTime='test';
                dsresponse.trgClrCode='test';
                dsresponse.lastMaintBrnch='test';
                dsresponse.trgAccType='test';
                dsresponse.lastMaintTell='test';
                dsresponse.srcInstCode='test';
                dsresponse.lastMaintOvrId='test';
                dsresponse.srcClrCode='test';
                dsresponse.paymNo='test';
                dsresponse.srcAccType='test';
                dsresponse.paymBusRef='test';
                dsresponse.freq='test';
                dsresponse.lastMaintOvr2Id='test';
                dsresponse.endDate='test';
                dsresponse.lastPaymDate='test';
                dsresponse.startDate='test';
                dsresponse.lastPaymAmnt='test';
                dsresponse.trigDate='test';
                dsresponse.lastPaymErr='test';
                dsresponse.actDate='test';
                dsresponse.abal='test';
                dsresponse.intExtBenInd='test';
                dsresponse.avbl='test';
                dsresponse.uniqueEft='test';
                dsresponse.statusCde='test';
                dsresponse.fwWarnInd='test';
                dsresponse.statusIndx='test';
                dsresponse.keyFormat='test';
                dsresponse.statusDesc='test';
                dsresponse.instrTypeAccs='test';
                dsresponse.primEvno='test';
                dsresponse.instrTypeDuepe='test';
                dsresponse.secEvno='test';
                dsresponse.instrTypeDrcr='test';
                dsresponse.emvscScriptDataLgth='test';
                dsresponse.respDesc='test';
                dsresponse.emvscScriptData='test';
                dsresponse.recsReturn='test';
                dsresponse.productsSpa='test';
                dsresponse.respOther='test';
                dsresponse.initpaymOverride='test';
                dsresponse.respCode='test';
                dsresponse.benGender='test';
                dsresponse.timeNow='test';
                dsresponse.benNonResStat='test';
                dsresponse.todaysDate='test';
                
                listdsresponse.add(dsresponse);
                return responseBean;
        }
    public class MBinitiatePaymentV10Response{
        @AuraEnabled public mbn301o mbn301o{get;set;}
        @AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
        @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
    }
}