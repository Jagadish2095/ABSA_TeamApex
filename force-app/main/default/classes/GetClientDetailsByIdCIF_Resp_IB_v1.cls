public class GetClientDetailsByIdCIF_Resp_IB_v1 extends Base_IB{
    
    public Integer statusCode;
    public String status;
    public String message;
    
    public String nbrEntsRetrieved;
    public String lastSearchPos;
    
    public cls_tblEntry[] tblEntry;
    
    public class cls_tblEntry{
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