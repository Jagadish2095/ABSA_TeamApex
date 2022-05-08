/*
 * Response Integration Bean for CAgetAccountDetails Service
 * @author Prashant Jain
 * @created 2019-09-27
 */

public class CAgetAccountDetails_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

    public CAgetAccountDetailsV2Response CAgetAccountDetailsV2Response;

    public class CAgetAccountDetailsV2Response {
        public Nbsapdpo nbsapdpo;
        public Cas095o cas095o;
    }

    public class Nbsapdpo {
        public String version;
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
        public String echoKey;
    }

    public class Cas095o {
        public String kbAcctNbr;
        public String kbDualAcctNbr;
        public String kbSubprod;
        public String kbAcctTypCd;
        public String kbCurrStatCd;
        public String ccLstStmtDt;
        public String ccBllngCyc;
        public String kbTotTns;
        public String kbCrdsOutstg;
        public String ccCrLfInsCd;
        public String ccLstCrLnChngDt;
        public String kbExpDt;
        public String kbOpenDt;
        public String kbClsDt;
        public String dqDelqEffDt;
        public String kbLang;
        public String jlSex;
        public String raAcctNbr;
        public String kb1stActyDt;
        public String jlFicaInd;
        public String kbMailCd;
        public String kbLcpInd;
        public String kbCoffXfrEffDt;
        public String kbInColInd;
        public String kbNbrPlasWCmnts;
        public String kbCrdsActivePrim;
        public String kbCrdsActiveSec;
        public String kbNxtLcpAnnivDt;
        public String kbLstMfChrgDt;
        public String kbCurrTcEffDt;
        public List < AcctPlasNumbers > acctPlasNumbers;
        public String ccCurrCrLn;
        public String uaBudgetLimit;
        public String jlCurrBal;
        public String jlAvailCrLn;
        public String jlEcCurrBal;
        public String kbOutstgEcAuthAmt;
        public String jlAvailBudgetLimit;
        public String jlOutstgAuthCnt;
        public String jlOutstgAuthAmt;
        public String jlOutstgNormAuAmt;
        public String jlOutstgEcAAmt;
        public String ccLstStmtBal;
        public String ccLstPymtAmt;
        public String ccLstPymtDt;
        public String ccPymtDueDt;
        public String btBlldReqdPymt;
        public String ccAmtOvln;
        public String dqAmtCurrDelq;
        public String kbTotUnresDsptAmt;
        public List < TxnLn > txnLn;
        public String kbLstUpdtDt;
        public String kbLstUpdtTm;
        public String kbLstUpdtOper;
        public String kbLstUpdtTerm;
    }

    public class AcctPlasNumbers {
        public String pdPlasNbr;
        public String tdEmbNmLn1;
        public String pdCurrStatCd;
    }

    public class TxnLn {
        public String dt1TxnCatg;
        public String dt1TxnDt;
        public String dt1OrigPstgDt;
        public String dt1MicflmMsgRef;
        public String dt1TxnDesc;
        public String dt1TxnAmt;
    }
    
    public static CAgetAccountDetails_Resp_IB_v1 dummyResponse(){
        CAgetAccountDetails_Resp_IB_v1 dummyRes = new CAgetAccountDetails_Resp_IB_v1();
        dummyRes.message ='test';
        dummyRes.status = 'Success';
        dummyRes.statusCode=200;
        CAgetAccountDetails_Resp_IB_v1.Nbsapdpo nbs = new CAgetAccountDetails_Resp_IB_v1.Nbsapdpo();
        nbs.version='test';
        nbs.returnCode='test';
        nbs.reasonCode='test';
        nbs.serviceVersion='test';
        nbs.echoKey='test';
        return dummyRes;
        }
}