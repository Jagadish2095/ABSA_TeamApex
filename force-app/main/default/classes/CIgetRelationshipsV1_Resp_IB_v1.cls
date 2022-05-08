public class CIgetRelationshipsV1_Resp_IB_v1  extends Base_IB{
    
    public CIgetRelationshipsV1Response CIgetRelationshipsV1Response;
    
    public class CIgetRelationshipsV1Response{
        public Nbsapdpo nbsapdpo;
        public Nbsmsgo3 nbsmsgo3;
        public cib128o cib128o;
    }
    
    public class Nbsapdpo{
       public String reasonCode;
       public String returnCode;
       public String serviceVersion;   
    }
    public class Nbsmsgo3{
       public String nbrUserErrs;
       public String nbrUserMsgs;  
    }
    public class cib128o{
       public String clientKey;
       public String clientName;
       public String noRecordCnt;
       public String restartKey;
       public List<relDetails> relDetails;
       
    }
    public class relDetails{
       public String dateCreated;
       public String relatedAcno;
       public String relativeClientIdNo;
       public String relativeClientIdTp;
       public String relativeClientKey;//
       public String relativeClientName;//
       public String relativeRelaCode;
       public String relativeRelaCodeDs;
       public String sourceRelaCode;
       public String sourceRelaCodeDesc;
       
    }
}