/**
@description Response Integration Bean for dsCheckDigitVerificationV1_Resp_IB_v1 Service
* @author Kamil Rega
* @created 2021-10-05
*/
public with sharing class dsCheckDigitVerificationV1_Resp_IB_v1 extends Base_IB {
    public String rc; //0
    public String branchName;          //PNP TEMBISA
    public String accountHost;           //F
    public String bankNameLong;     //NEDBANK                         NEDSZAJJ
    public String bankNameShort;   //NEDBANK
    public String accountExceptionInd;          //0
    public String branchType;             //C
    public Boolean acctypeZeroAllowed;
    public String bankCode; //3
    public String ssvAllowed;              //Y
    public String dt2Allowed;             //Y
    public String dt5Allowed;             //Y
    public String aedossIss; //Y
    public String aedossAcq;               //Y
    public String naedossIss;              //Y
    public String naedossAcq;            //Y

}