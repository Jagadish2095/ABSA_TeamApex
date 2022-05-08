/*
 * Response Integration Bean for IBlistBeneficiariesV1 Service
 * @author Rudolf Niehaus
 * @created 2020-03-19
 */

public class IBlistBeneficiariesV1_Resp_IB_v1 extends Base_IB {
    public String status;
    public Integer statusCode;
    public String message;

    public IBlistBeneficiariesV1Response IBlistBeneficiariesV1Response;

    public class Nbsapdpo {
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
    }

    public class Nbsmsgo {
        public String version;
        public String nbrUserMsgs;
        public String nbrUserErrs;
        public MsgEntry msgEntry;
    }

    public class MsgEntry {
        public String msgClass;
        public String msgCode;
        public String msgErrInd;
        public String msgTxt;
    }

    public class LinkedBeneficiaries {
        public String instructionNumber;
        public String beneficiaryName;
        public String bankName;
        public String targetAccountNumber;
        public String sourceStatementRef;
        public String targetStatementRef;
    }

    public class IBlistBeneficiariesV1Response {
        public Nbsapdpo nbsapdpo;
        public Nbsmsgo nbsmsgo;
        public Nhp457o nhp457o;
    }

    public class Nhp457o {
        public String combiCardNumber;
        public String clientName;
        public String division;
        public String numberOfBeneficiaries;
        public List<LinkedBeneficiaries> linkedBeneficiaries;
    }
}