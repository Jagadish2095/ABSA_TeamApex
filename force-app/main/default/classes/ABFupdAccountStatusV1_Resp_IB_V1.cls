public class ABFupdAccountStatusV1_Resp_IB_V1 extends Base_IB{
/*
* Integration Response Bean for ABFgetAndCalcConfDetailV4 Service 
* @author Gulafsha 
* @created 2020-11-28
*/
    public nbsapdpo  nbsapdpo;
    public nbsmsgo3 nbsmsgo3;
    public plpa03o plpa03o;
    
    public class nbsapdpo{
        public string version;
        public String  returnCode;  
        public String reasonCode;  
        public String serviceVersion;
        public String echoKey;
    }
    public class nbsmsgo3{
        public string version;
        public String  sysErrTxt;  
        public String nbrUserMsgs;  
        public String nbrUserErrs;
        public msgEntry[] msgEntry;
    }
    public class msgEntry{
        public string msgClass;
        public String  msgCode;  
        public String msgErrInd;  
        public String msgTxt;
        
    }
    
    public class plpa03o{
        public string mandateNbr;
        public String contractSignedInd;  
        public String contractSignIndUpdbl;  
        public String payMethodReqInd;
        public String cessionPledgeInd;
        public string autoSettlementInd;
        public String autoSettleIndUpdbl;  
        public String creditLifeInd;  
        public String creditLifeIndUpdbl;
        public String landlordWaiverInd;
        public string insuranceInd;
        public String elecTransferInd;  
        public String elecTransferIndUpdbl;  
    }
}