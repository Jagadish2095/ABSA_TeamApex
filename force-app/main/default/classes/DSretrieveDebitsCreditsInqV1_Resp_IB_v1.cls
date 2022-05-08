/*
* Response Integration Bean for DSretrieveDebitsCreditsInqV1 Service
* @author Prasanna Patwardhan
* @created 2019-10-30
*/
public class DSretrieveDebitsCreditsInqV1_Resp_IB_v1 extends Base_IB {
    @AuraEnabled public String status;
    @AuraEnabled  public Integer statusCode;
    @AuraEnabled public String message;
    
    @AuraEnabled public DSretrieveDebitsCreditsInqV1Response DSretrieveDebitsCreditsInqV1Response{get;set;}
    public class Dsp973o {
        @AuraEnabled public String respCode;
        @AuraEnabled public String respDesc;
        @AuraEnabled public String moreRecsInd;
        @AuraEnabled public String recsReturnCnt;
        @AuraEnabled public String acno;
        @AuraEnabled public String acHolderName;
        @AuraEnabled public List<DebitCreditList> debitCreditList;
    }
    
    public class Nbsapdpo {
        @AuraEnabled public String version;
        @AuraEnabled public String returnCode;
        @AuraEnabled public String reasonCode;
        @AuraEnabled public String serviceVersion;
        @AuraEnabled public String echoKey;
    }
    
    public class Nbsmsgo3 {
        @AuraEnabled public String version;
        @AuraEnabled public String sysErrTxt;
        @AuraEnabled public String nbrUserMsgs;
        @AuraEnabled public String nbrUserErrs;
        @AuraEnabled public List<MsgEntry> msgEntry;
    }
    
    public class DebitCreditList {
        @AuraEnabled public String trnGrp;
        @AuraEnabled public String actionDate;
        @AuraEnabled public String userCode;
        @AuraEnabled public String userSeq;
        @AuraEnabled public String nameOfInst;
        @AuraEnabled public String userRef;
        @AuraEnabled public String amount;
        @AuraEnabled public String status;
        @AuraEnabled public String tieb;
        @AuraEnabled public String typeInd;
        @AuraEnabled public String acbRtrnCode;
        @AuraEnabled public String procbInd;
        @AuraEnabled public String ieIndb;
        @AuraEnabled public String ccpCaseNo;
    }
    
    public class MsgEntry {
    }
    
    public class DSretrieveDebitsCreditsInqV1Response {
        @AuraEnabled public Nbsapdpo nbsapdpo;
        @AuraEnabled public Nbsmsgo3 nbsmsgo3;
        @AuraEnabled public Dsp973o dsp973o;
    }
    public static DSretrieveDebitsCreditsInqV1_Resp_IB_v1 dummyResponse(){
          DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean = new DSretrieveDebitsCreditsInqV1_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
      //  DSretrieveDebitsCreditsInqV1_Resp_IB_v1.DSretrieveDebitsCreditsInqV1Response dsresponse  = new DSretrieveDebitsCreditsInqV1_Resp_IB_v1.DSretrieveDebitsCreditsInqV1Response();
        DSretrieveDebitsCreditsInqV1_Resp_IB_v1.Dsp973o dsp973o = new DSretrieveDebitsCreditsInqV1_Resp_IB_v1.Dsp973o();
        DSretrieveDebitsCreditsInqV1_Resp_IB_v1.DebitCreditList debitlist = new DSretrieveDebitsCreditsInqV1_Resp_IB_v1.DebitCreditList();
        list<DebitCreditList> ldebitlist=new list<DebitCreditList>();
         debitlist.trnGrp ='DD';
         debitlist.actionDate='20190927';
         debitlist.userCode='0110';
         debitlist.userSeq ='7';
         debitlist.nameOfInst ='RSADLV';
         debitlist.userRef ='TESTDR3';
         debitlist.amount ='47.64';
         debitlist.status ='001';
         debitlist.tieb ='13416CE2081E01A5F107';
         debitlist.typeInd='Y';
         debitlist.acbRtrnCode='000';
         debitlist.procbInd ='Y';
         debitlist.ieIndb='I';
         debitlist.ccpCaseNo ='0020190927';
        ldebitlist.add(debitlist);
        dsp973o.respCode='0';
        dsp973o.respDesc='';
        dsp973o.moreRecsInd='N';
        dsp973o.recsReturnCnt='11';
        dsp973o.acno='09050987409';
        dsp973o.acHolderName='UNKNOWN';
        dsp973o.debitCreditList=ldebitlist;
        
      return responseBean;
    }
    
}