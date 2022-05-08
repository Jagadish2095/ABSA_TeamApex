public class MBinitiatePaymentV10_Req_IB_v1{
    
    public String amount{get;set;}
    public String srcAcc{get;set;}
    public String actDate{get;set;}
    public String srcAccType{get;set;}
    public String instrRefName{get;set;}
    public String srcClrCode{get;set;}
    public String instrType{get;set;}
    public String srcStmtRef{get;set;}
    public String maxRetrieve{get;set;}
    public String trgAcc{get;set;}
    public String paymTime{get;set;}
    public String paymIipInd{get;set;}
    public String trgClrCode{get;set;}
    public String channelInp{get;set;}
    public String trgAccType{get;set;}
    public String msgTarget{get;set;}
    public String trgStmtRef{get;set;}
    public String msgLanguage{get;set;}
    public String changeBranch{get;set;}
    public String trace{get;set;}
    public String changeTeller{get;set;}
    public String application{get;set;}
    public String benNonResStat{get;set;}
    public String channel{get;set;}
    public String accessAcc{get;set;} 
    public String cifKey {get;set;} 
    public String multiNo {get;set;} 
    public String instrNo {get;set;}
    public String tieb {get;set;} //Added by chandra dated 12/01/2022
    
    
    public static MBinitiatePaymentV10_Req_IB_v1 createDummyRequest() {
        MBinitiatePaymentV10_Req_IB_v1 requestBean = new MBinitiatePaymentV10_Req_IB_v1();
        
        requestBean.amount = '1';
        requestBean.srcAcc = '4048017641';
        requestBean.actDate = '20200526';
        requestBean.srcAccType = '01';
        requestBean.instrRefName = 'test';
        requestBean.srcClrCode = '632005';
        requestBean.instrType = 'test';
        requestBean.srcStmtRef = 'test';
        requestBean.maxRetrieve = '1';
        requestBean.trgAcc = '62001847237';
        requestBean.paymTime = '11050112';
        requestBean.trgClrCode = '632005';
        requestBean.channelInp = 'SALESFOR';
        requestBean.trgAccType = '02';
        requestBean.msgTarget  = 'STD';
        requestBean.trgStmtRef = 'test';
        requestBean.msgLanguage = 'E';
        requestBean.changeBranch = '8089';
        requestBean.paymIipInd = 'Q';
        requestBean.trace = 'Y';
        requestBean.changeTeller = '11012';
        requestBean.application = 'SALESFOR';
        requestBean.benNonResStat = '';
        requestBean.channel = 'SALESFOR';
        requestBean.tieb = '00003';//Added by chandra dated 12/01/2022

        return requestBean;
    }
    
    public static MBinitiatePaymentV10_Req_IB_v1 createPayBeneficiaryDummy(){
        
        MBinitiatePaymentV10_Req_IB_v1 requestBean = new MBinitiatePaymentV10_Req_IB_v1(); 
        
        requestBean.channel = 'SALESFOR';
        requestBean.application ='SALESFOR';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.channelInp = 'SALESFOR';
        requestBean.paymTime = '11050112';
        requestBean.maxRetrieve= '1';
        requestBean.accessAcc = '4483850000161519';
        requestBean.cifKey = 'ZUMAD  001';
        requestBean.multiNo = '0';
        requestBean.instrType ='VP';
        requestBean.instrRefName = 'Test';
        requestBean.actDate = '20200526';
        requestBean.amount = '3';
        requestBean.instrNo = '51';
        requestBean.srcAcc = '4048017641';
        requestBean.srcAccType = '02';
        requestBean.srcClrCode = '632005';
        requestBean.srcStmtRef = 'srcStmtRef';
        requestBean.trgAcc = '62001847237';
        requestBean.trgClrCode = '632005';
        requestBean.trgAccType ='02';
        requestBean.trgStmtRef = 'trgStmtRef';
        requestBean.changeBranch = '8089';
        requestBean.changeTeller = '11012';
        requestBean.benNonResStat ='';
        requestBean.tieb = '00003';//Added by chandra dated 12/01/2022 
        
        return requestBean;
    }
    
}