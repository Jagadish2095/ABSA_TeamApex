/*
* Class for NHlistAcctTransactionHistoryV5 response
* @author Mashudu Raidimi
* @created   2020/03/05
*/
public class NhlistAccTransactionHistoryv5_Resp_IB_v1 extends Base_IB{
   
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    //@AuraEnabled public nhp021o nhp021o{get;set;}
   // @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
   @AuraEnabled public NHlistAcctTransactionHistoryV5Response NHlistAcctTransactionHistoryV5Response{get;set;}
    
    public class NHlistAcctTransactionHistoryV5Response{
       @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
       @AuraEnabled public nhp021o nhp021o{get;set;}
    }
    
         
    public class nhp021o 
    {
       
          @AuraEnabled public String rcde{get;set;}
          @AuraEnabled public String rcdeType{get;set;}
          @AuraEnabled public String rcdeSource{get;set;}
          @AuraEnabled public String rcdeReason{get;set;}
          @AuraEnabled public String rdesc{get;set;}
          @AuraEnabled public String moreToCome{get;set;}
          @AuraEnabled public String currentBal{get;set;}
          @AuraEnabled public String availableBal{get;set;}
          @AuraEnabled public String unclearedAmt{get;set;}
          @AuraEnabled public String unclearedEffects{get;set;}
          @AuraEnabled public String pagingKey{get;set;}
          @AuraEnabled public String count{get;set;}
          @AuraEnabled public List<StatementDetails> statementDetails{get;set;}
  
    }
    
    
    
    
     public class nbsapdpo 
    {
		@AuraEnabled public String version{get;set;}
		@AuraEnabled public String returnCode{get;set;}
		@AuraEnabled public String reasonCode{get;set;}
		@AuraEnabled public String serviceVersion{get;set;}
		@AuraEnabled public String echoKey{get;set;}
	} 
    
    
    
    public class StatementDetails
    {
        @AuraEnabled public String processingDate{get;set;}
        @AuraEnabled public String effectiveDate{get;set;}
        @AuraEnabled public String description1{get;set;}
        @AuraEnabled public String description2{get;set;}
        @AuraEnabled public String description3{get;set;}
        @AuraEnabled public String tranAmount{get;set;}
        @AuraEnabled public String tranCost{get;set;}
        @AuraEnabled public String balAfterTran{get;set;}
        @AuraEnabled public String tranType{get;set;}
        @AuraEnabled public String eventNum{get;set;}
        @AuraEnabled public String lineNum{get;set;}
        @AuraEnabled public String tranCat{get;set;}
        
    }
    //dummy response method
     public static NhlistAccTransactionHistoryv5_Resp_IB_v1 dummyResponse(){
          NhlistAccTransactionHistoryv5_Resp_IB_v1 responseBean = new NhlistAccTransactionHistoryv5_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        NhlistAccTransactionHistoryv5_Resp_IB_v1.nhp021o nhp021o = new NhlistAccTransactionHistoryv5_Resp_IB_v1.nhp021o();
        NhlistAccTransactionHistoryv5_Resp_IB_v1.StatementDetails transactlist = new NhlistAccTransactionHistoryv5_Resp_IB_v1.StatementDetails();
        list<StatementDetails> ltransactlist=new list<StatementDetails>();
         transactlist.processingDate ='20200228';
         transactlist.effectiveDate='20190927';
         transactlist.description1='INETBNK PAY DEBIT';
         transactlist.description2 ='CORPORATE Ndalo';
         transactlist.description3 ='null';
         transactlist.tranAmount ='TESTDR3';
         transactlist.tranCost ='-140.00';
         transactlist.balAfterTran ='8070678325778.28';
         transactlist.tranType ='null';
         transactlist.eventNum='0';
         transactlist.lineNum='1';
         transactlist.tranCat ='4';
         
        ltransactlist.add(transactlist);
        nhp021o.rcde='0';
        nhp021o.rcdeType='0';
        nhp021o.rcdeSource='null';
        nhp021o.rcdeReason='0';
        nhp021o.rdesc='null';
        nhp021o.moreToCome='N';
        nhp021o.currentBal='8140512748300.98';
        nhp021o.availableBal='8140512748250.98';
        nhp021o.unclearedAmt='0';
        nhp021o.unclearedEffects='null';
        nhp021o.pagingKey='00000{0000{0000B 0000000{00000000{0000000{0000000000{00{00{';
        nhp021o.count='2';
        nhp021o.statementDetails=ltransactlist;
        
      return responseBean;
}
 
}