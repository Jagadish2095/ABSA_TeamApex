public class UpdateJntPartByClientCode_Resp_IB_v1 extends Base_IB{

    public String status;
    public Integer statusCode;
    public String message;
    
    public cls_CIupdJointParticipantsByClientCodeV7Response CIupdJointParticipantsByClientCodeV7Response;
    
    public class cls_CIupdJointParticipantsByClientCodeV7Response{
        
        public cls_nbsapdpo nbsapdpo;
        public cls_nbsmsgo3 nbsmsgo3;
        public cls_cib033o cib033o;
        
    }
    public class cls_nbsapdpo{
        
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
    }
    
    public class cls_nbsmsgo3{
        
        public String version;
        public String nbrUserMsgs;
        public String nbrUserErrs;
    }
    
    public class cls_cib033o{
        
        public cls_errorTable[] errorTable;
    }
    
    public class cls_errorTable{
        
        public String errorCode;
        public String errorMessage;
    }
    
}