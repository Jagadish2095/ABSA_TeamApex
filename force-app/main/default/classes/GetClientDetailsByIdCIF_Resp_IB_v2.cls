/**
 * @description       : Client detail by Id Response Bean
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-31
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class GetClientDetailsByIdCIF_Resp_IB_v2 extends Base_IB {

    /**
     * @description       : CIgetClientDetailsByIDNOV2Response
     **/
    public CIgetClientDetailsByIDNOV2Response CIgetClientDetailsByIDNOV2Response { get; set; }

    /**
     * @description       : CIgetClientDetailsByIDNOV2Response
     **/
    public class CIgetClientDetailsByIDNOV2Response {
        public Cip008o cip008o;
        public Nbsapdpo nbsapdpo;
        public Nbsmsgo nbsmsgo;
    }

    /**
     * @description       : Cip008o
     **/
    public class Cip008o {
        public String lastSearchPos;
        public String nbrEntsRetrieved;
        public List<TblEntry> tblEntry;
    }

    /**
     * @description       : Nbsapdpo
     **/
    public class Nbsapdpo {
        public String echoKey;
        public String reasonCode;
        public String returnCode;
        public String serviceVersion;
        public String version;
    }

    /**
     * @description       : Nbsmsgo
     **/
    public class Nbsmsgo {
        public String nbrUserErrs;
        public String nbrUserMsgs;
        public String sysErrTxt;
        public String version;
    }

    /**
     * @description       : TblEntry
     **/
    public class TblEntry {
        public String cifKey;
        public String cifInitials;
        public String cifSurname;
        public String cifTitleCode;
        public String cifClntType;
        public String cifClntGroup;
        public String cifNbrOfAccts;
        public String cifBirthDate;
        public String cifAddrLine1;
        public String cifAddrLine2;
        public String cifPostlSuburb;
        public String cifPostlTown;
        public String cifPostlCodeRsa;
        public String cifCorpCode;
    }
}