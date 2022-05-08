/*
* Request Integration Bean for CreateInstruction v2 Service
* @author Rudolf Niehaus
* @created 2020-05-17
*/
public class CreateInstruction_Req_IB_v2 extends Base_IB{

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
    
    public static CreateInstruction_Req_IB_v2 createDummy(){
        
        CreateInstruction_Req_IB_v2 bean = new CreateInstruction_Req_IB_v2();
        
        bean.channel = 'SALSFOR';
        bean.function = 'CREATE';
        bean.maxRetrieve = '1';
        bean.confirmInd = 'C';
        bean.accessAcc = '04483850000161519';
        bean.instrType = 'SO';
        bean.actDate = '20200602';
        bean.startDate = '20200602';
        bean.endDate = '20200702';
        bean.freq = '1M';
        bean.amount = '100';
        bean.instrRefName = 'NIEHAUS';
        bean.srcAcc = '4048017641';
        bean.srcAccType = 'CQ';
        bean.srcClrCode = '632005';
        bean.srcStmtRef = 'PAY';
        bean.trgAcc = '62001847237';
        bean.trgAccType = '02';
        bean.trgClrCode = '250655';
        bean.trgStmtRef = 'pay';
        bean.payDay = '1';
        bean.lastMaintBrnch = '8089';
        bean.lastMaintTell = '11332';
        
        return bean;
    }
}