public class dSretrieveDebitsCreditsInqV2_Resp_IB_v1{

   @AuraEnabled public Integer statusCode{get;set;}
   @AuraEnabled public String StatusMessage {get;set;}
   @AuraEnabled public String status{get;set;}
    
    public DSretrieveDebitsCreditsInqV2Response DSretrieveDebitsCreditsInqV2Response{get;set;}
    public class nbsmsgo3{
        public msgEntry msgEntry{get;set;}
        public String nbrUserErrs{get;set;}
        public String nbrUserMsgs{get;set;}
    }
    public class nbsapdpo{
        public String serviceVersion{get;set;}
        public String reasonCode{get;set;}
        public String returnCode{get;set;}
    }
    public class msgEntry{
        public String msgTxt{get;set;}
        public String msgErrInd{get;set;}
        public String msgCode{get;set;}
        public String msgClass{get;set;}
    }
    public class DSretrieveDebitsCreditsInqV2Response{
        public nbsapdpo nbsapdpo{get;set;}
        public dsp973o dsp973o{get;set;}
        public nbsmsgo3 nbsmsgo3{get;set;}
    }
    public class dsp973o{
       @AuraEnabled public String respCode{get;set;}
       @AuraEnabled public String acno{get;set;}
       @AuraEnabled public String acHolderName{get;set;}
       @AuraEnabled public String recsReturnCnt{get;set;}
       @AuraEnabled public list<debitCreditList> debitCreditList{get;set;}
       @AuraEnabled public String moreRecsInd{get;set;}
    }
    public class debitCreditList{
       @AuraEnabled public String userCode{get;set;}
       @AuraEnabled public String status{get;set;}
       @AuraEnabled public String tieb{get;set;}
       @AuraEnabled public String amount{get;set;}
       @AuraEnabled public String typeInd{get;set;}
       @AuraEnabled public String userRef{get;set;}
       @AuraEnabled public String acbRtrnCode{get;set;}
       @AuraEnabled public String nameOfInst{get;set;}
       @AuraEnabled public String procbInd{get;set;}
       @AuraEnabled public String userSeq{get;set;}
       @AuraEnabled public String ieIndb{get;set;}
       @AuraEnabled public String actionDate{get;set;}
       @AuraEnabled public String effFrmDate{get;set;}
       @AuraEnabled public String trnGrp{get;set;}
    }
    
     public static dSretrieveDebitsCreditsInqV2_Resp_IB_v1 dummyResponse(){
                dSretrieveDebitsCreditsInqV2_Resp_IB_v1 responseBean = new dSretrieveDebitsCreditsInqV2_Resp_IB_v1();
                responseBean.status='OK';
                responseBean.statusCode=200;
                responseBean.StatusMessage='SUCCESS';
                dSretrieveDebitsCreditsInqV2_Resp_IB_v1.nbsmsgo3 nbsmsgo3bean = new dSretrieveDebitsCreditsInqV2_Resp_IB_v1.nbsmsgo3();
                nbsmsgo3bean.nbrUserMsgs = 'test';
                nbsmsgo3bean.nbrUserErrs = 'test';
               
               dSretrieveDebitsCreditsInqV2_Resp_IB_v1.nbsapdpo nbsapdpobean = new dSretrieveDebitsCreditsInqV2_Resp_IB_v1.nbsapdpo();
                nbsapdpobean.serviceVersion = 'test';
                nbsapdpobean.reasonCode = 'test';
                nbsapdpobean.returnCode = 'test';
         
              dSretrieveDebitsCreditsInqV2_Resp_IB_v1.msgEntry msgEntrybean = new dSretrieveDebitsCreditsInqV2_Resp_IB_v1.msgEntry(); 
         		msgEntrybean.msgTxt = 'test';
                msgEntrybean.msgErrInd = 'test';
                msgEntrybean.msgCode = 'test';
         		msgEntrybean.msgClass = 'test';
         List<dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList> debitCreditListdummy  = new List<dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList>();
         dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList debitCreditListbean=  new dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList();
                debitCreditListbean.userCode = 'test';
                debitCreditListbean.status = 'test';
                debitCreditListbean.tieb = 'test';
                debitCreditListbean.amount = 'test';
                debitCreditListbean.typeInd = 'test';
                debitCreditListbean.userRef = 'test';
                debitCreditListbean.acbRtrnCode = 'test';
         		debitCreditListbean.nameOfInst = 'test';
                debitCreditListbean.procbInd = 'test';
                debitCreditListbean.userSeq = 'test';
                debitCreditListbean.ieIndb = 'test';
                debitCreditListbean.actionDate = 'test';
                debitCreditListbean.effFrmDate = 'test';
                debitCreditListbean.trnGrp = 'test';
             debitCreditListdummy.add(debitCreditListbean);
         dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList debitCreditListbean1=  new dSretrieveDebitsCreditsInqV2_Resp_IB_v1.debitCreditList();
                debitCreditListbean1.userCode = 'test';
                debitCreditListbean1.status = 'test';
                debitCreditListbean1.tieb = 'test';
                debitCreditListbean1.amount = 'test';
                debitCreditListbean1.typeInd = 'test';
                debitCreditListbean1.userRef = 'test';
                debitCreditListbean1.acbRtrnCode = 'test';
         		debitCreditListbean1.nameOfInst = 'test';
                debitCreditListbean1.procbInd = 'test';
                debitCreditListbean1.userSeq = 'test';
                debitCreditListbean1.ieIndb = 'test';
                debitCreditListbean1.actionDate = 'test';
                debitCreditListbean1.effFrmDate = 'test';
                debitCreditListbean1.trnGrp = 'test';
               debitCreditListdummy.add(debitCreditListbean1);
                
               dSretrieveDebitsCreditsInqV2_Resp_IB_v1.dsp973o dsp973obean=  new dSretrieveDebitsCreditsInqV2_Resp_IB_v1.dsp973o();
               
              	dsp973obean.respCode = 'test';
                dsp973obean.acno = 'test';
                dsp973obean.acHolderName = 'test';
                dsp973obean.recsReturnCnt = 'test';
                dsp973obean.moreRecsInd = 'test';
                dsp973obean.debitCreditList = debitCreditListdummy;
         dSretrieveDebitsCreditsInqV2_Resp_IB_v1.DSretrieveDebitsCreditsInqV2Response DSretrieveDebitsCreditsInqV2Responsebean=  new dSretrieveDebitsCreditsInqV2_Resp_IB_v1.DSretrieveDebitsCreditsInqV2Response();
                DSretrieveDebitsCreditsInqV2Responsebean.nbsmsgo3 = nbsmsgo3bean;
                DSretrieveDebitsCreditsInqV2Responsebean.dsp973o = dsp973obean;
                DSretrieveDebitsCreditsInqV2Responsebean.nbsapdpo = nbsapdpobean;
                responsebean.DSretrieveDebitsCreditsInqV2Response = DSretrieveDebitsCreditsInqV2Responsebean;
                return responseBean;
        }
    
    
}