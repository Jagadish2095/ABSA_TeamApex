/** 
 * @description Response Integration Bean for MLgetPayoffDetailsV1 Service
 * @author Jason Quevauvilliers
 * @created 2020-10-20
 * Edited Simangaliso: 26 Aug 2021
 */
public class MLgetPayoffDetailsV1_Resp_IB_v1 extends Base_IB{

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public MLgetPayoffDetailsV1Response MLgetPayoffDetailsV1Response;

    /**
	* @description MLgetPayoffDetailsV1Response class
	*/
    public class MLgetPayoffDetailsV1Response{
        @AuraEnabled public Mlp801o mlp801o;
        @AuraEnabled public Nbsapdpo nbsapdpo;
        @AuraEnabled public Nbsmsgo nbsmsgo;
    }

    /**
	* @description Mlp801o class
	*/
    public class Mlp801o{
        @AuraEnabled public String acctId;
        @AuraEnabled public Double amntReqPayOffLoan;
        @AuraEnabled public List<Balance> balance;
        @AuraEnabled public String branchName;
        @AuraEnabled public String capMnthInd;
        @AuraEnabled public String clientAddressLine1;
        @AuraEnabled public String clientAddressLine2;
        @AuraEnabled public String clientAddressLine3;
        @AuraEnabled public String clientAddressLine4;
        @AuraEnabled public String clientName;
        @AuraEnabled public Integer clientPostalCode;
        @AuraEnabled public Double commitAmnt;
        @AuraEnabled public Double commitGross;
        @AuraEnabled public String corpCode;
        @AuraEnabled public Integer endowCommDate;
        @AuraEnabled public Integer enqDate;
        @AuraEnabled public Integer enqTime;
        @AuraEnabled public Double hmpPremium;
        @AuraEnabled public Double hocPremium;
        @AuraEnabled public Double intAccrued;
        @AuraEnabled public Integer payOffDate;
        @AuraEnabled public List<PrimHolds> primHolds;
        @AuraEnabled public Integer primHoldsCnt;
        @AuraEnabled public Double provAdminFee;
        @AuraEnabled public Double provEndowment;
        @AuraEnabled public Integer secHoldsCnt;
        @AuraEnabled public Double stampDuty;
        @AuraEnabled public Integer uncCheq;
        @AuraEnabled public Integer uncDoc;
    }

    /**
	* @description Nbsapdpo class
	*/
    public class Nbsapdpo{
        @AuraEnabled public String echoKey;
        @AuraEnabled public Integer reasonCode;
        @AuraEnabled public Integer returnCode;
        @AuraEnabled public String serviceVersion;
        @AuraEnabled public String version;
    }

    /**
	* @description Nbsmsgo class
	*/
    public class Nbsmsgo{
        @AuraEnabled public List<MSGEntry> msgEntry;
        @AuraEnabled public Integer nbrUserErrs;
        @AuraEnabled public Integer nbrUserMsgs;
        @AuraEnabled public String sysErrTxt;
        @AuraEnabled public String version;
    }

    /**
	* @description Balance class
	*/
    public class Balance{
        @AuraEnabled public String balInd;
        @AuraEnabled public Double outstBal;
    }

    /**
	* @description MSGEntry class
	*/
    public class MSGEntry{
        @AuraEnabled public String msgErrInd;
        @AuraEnabled public String msgCode;
        @AuraEnabled public String msgTxt;
        @AuraEnabled public String msgClass;
    }

    /**
	* @description PrimHolds class
	*/
    public class PrimHolds{
        @AuraEnabled public String data;
    }
}