public class CreateInstruction_Resp_IB_v1 extends Base_IB{

    public String status;
    public Integer statusCode;
    public String message;
    public String todaysDate;
    public String timeNow;
    public String respCode;
    public String respOther;
    public String recsReturn;
    public String respDesc;
    public String instrTypeDrcr;
    public String instrTypeDuepe;
    public String instrTypeAccs;
    public String fwWarnInd;
    public String instrNo;
    public String multiNo;
    public String intExtBenInd;
    public String actDate;
    public String trigDate;
    public String srcAcc;
    public String srcAccType;
    public String srcClrCode;
    public String srcInstCode;
    public String trgAcc;
    public String trgAccType;
    public String trgClrCode;
    public String trgInstCode;
    public String corpCode;
    public String sbu;
    public String clientType;
    public String iipAllowInd;
    public String lastChangeNo;
    public String lastMaintFunc;
    public String changeNo;
    public String changeSet;
    public String changeDate;
    public String changeTime;
    public String changeFunc;
    public String changeBranch;
    public String changeTeller;
    public String changeOverride;
    
    public static CreateInstruction_Resp_IB_v1 dummyResponse(){
        CreateInstruction_Resp_IB_v1 responseBean = new CreateInstruction_Resp_IB_v1();
        
        responseBean.todaysDate = '20200319';
        responseBean.timeNow = '14352835';
        responseBean.respCode = '0';
        responseBean.respOther = '0';
        responseBean.recsReturn = '0';
        responseBean.respDesc = 'SUCCESSFUL PROCESS';
        responseBean.instrTypeDrcr = 'D';
        responseBean.instrTypeDuepe = 'C';
        responseBean.instrTypeAccs = 'Y';
        responseBean.fwWarnInd = '';
        responseBean.instrNo = '0';
        responseBean.multiNo = '0';
        responseBean.intExtBenInd = 'I';
        responseBean.actDate = '0';
        responseBean.trigDate = '0';
        responseBean.srcAcc = '000000004483850000192464';
        responseBean.srcAccType =  'CO' ;
        responseBean.srcClrCode =  '632005'  ;
        responseBean.srcInstCode =  'ABSA BANK'  ;
        responseBean.trgAcc =  '000000000000009051212340'  ;
        responseBean.trgAccType =  'SA'  ;
        responseBean.trgClrCode =  '632005'  ;
        responseBean.trgInstCode =  'ABSA BANK'  ;
        responseBean.corpCode =  'Z'  ;
        responseBean.sbu =  'F'  ;
        responseBean.clientType =  'I'  ;
        responseBean.iipAllowInd =  'N'  ;
        responseBean.lastChangeNo =  '0'  ;
        responseBean.lastMaintFunc =  ''  ;
        responseBean.changeNo =  '0'  ;
        responseBean.changeSet =  '0'  ;
        responseBean.changeDate =  '0'  ;
        responseBean.changeTime =  '0'  ;
        responseBean.changeFunc =   '' ;
        responseBean.changeBranch =  '0'  ;
        responseBean.changeTeller =  '0'  ;
        responseBean.changeOverride = '';
        
        return responseBean;
        
    }
   
}