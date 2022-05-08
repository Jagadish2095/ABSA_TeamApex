public class CreateInstruction_Req_IB_v1 extends Base_IB{

    public String channel;
    public String application;
    public String function;
    public String maxRetrieve;
    public String confirmInd;
    public String futureInd;
    public String accessAcc;
    public String instrType;
    public String actDate;
    public String startDate;
    public String endDate;
    public String freq;
    public String amount;
    public String instrRefName;
    public String srcAcc;
    public String srcAccType;
    public String srcClrCode;
    public String srcStmtRef;
    public String trgAcc;
    public String trgAccType;
    public String trgClrCode;
    public String trgStmtRef;
    public String trgBusinessCode;
    public String minPayAmnt;
    public String maxPayAmnt;
    public String payDay;
    public String doType;
    public String chqFlag;
    public String priNo;
    public String mandNo;
    public String creditTrack;
    public String notifInd;
    public String srcFaxCode;
    public String srcFaxNo;
    public String srcFaxText;
    public String srcCellCode;
    public String srcCellNo;
    public String srcCellText;
    public String srcEmailAddr;
    public String srcEmailText;
    public String srcNotifMed;
    public String trgFaxCode;
    public String trgFaxNo;
    public String trgFaxText;
    public String trgCellCode;
    public String trgCellNo;
    public String trgCellText;
    public String trgEmailAddr;
    public String trgEmailText;
    public String trgNotifMed;
    public String iipAllowInd;
    public String lastMaintBrnch;
    public String lastMaintTell;
    public String lastMaintOvrId;
    public String cardAuth;
    public String lastMaintOvr2Id;
    public String SDTARREF;
    public String trace;
    public String msgLanguage;
    public String msgTarget;
    
    public static CreateInstruction_Req_IB_v1 createDummy(){
        
        CreateInstruction_Req_IB_v1 bean = new CreateInstruction_Req_IB_v1();
        
        bean.channel = 'BDP';
        bean.function = 'CREATE';
        bean.maxRetrieve = '1';
        bean.confirmInd = 'N';
        bean.instrType = 'OOP';
        bean.actDate = '20181120';
        bean.startDate = '20181120';
        bean.freq = '1M';
        bean.amount = '450';
        bean.instrRefName = 'SDTEST';
        bean.srcAcc = '4047698294';
        bean.srcAccType = '1';
        bean.srcClrCode = '632005';
        bean.srcStmtRef = 'SDREF1';
        bean.trgAcc = '62161856087';
        bean.trgAccType = '01';
        bean.trgClrCode = '251445';
        bean.trgStmtRef = 'SDTARREF';
        bean.lastMaintBrnch = 'SYSTEM';
        bean.lastMaintTell = 'MBM231D';
        
        return bean;
    }
    public static CreateInstruction_Req_IB_v1 createAddBen(){ 
        CreateInstruction_Req_IB_v1 bresponse = new CreateInstruction_Req_IB_v1();
        
        bresponse.confirmInd = 'C';
        bresponse.channel = 'Salesfor';
        bresponse.application = 'Salesfor';
        bresponse.trace = 'Y';
        bresponse.msgLanguage = 'E';
        bresponse.msgTarget = 'STD';
        bresponse.channel = 'BDP';
        bresponse.function = 'CREATE';
        bresponse.maxRetrieve = '1';
        bresponse.accessAcc = '550220261';
        bresponse.instrType = 'VP';
        bresponse.instrRefName = 'Sizwe';
        bresponse.srcAcc = '550220261';
        bresponse.srcAccType = 'CQ';
        bresponse.srcClrCode = '';
        bresponse.srcStmtRef = 'PAY';
        bresponse.trgAcc = '3001325523';
        bresponse.trgAccType = 'PL';
        bresponse.trgClrCode = '';
        bresponse.trgStmtRef = '';
        bresponse.lastMaintBrnch = '8089';
        bresponse.lastMaintTell = '11332';
        
        return bresponse;
        
    } 
    




}