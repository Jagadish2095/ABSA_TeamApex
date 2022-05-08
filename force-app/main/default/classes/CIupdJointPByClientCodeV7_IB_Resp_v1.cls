/***
* @comment : 
* @description  
*/  
public class CIupdJointPByClientCodeV7_IB_Resp_v1 extends Base_IB{
   
   public String Status;
   public Integer StatusCode;
   public String message;
     /***
* @comment : 
* @description  
*/  
   public class Nbsapdpo {
		public Object version;
		public Integer returnCode;
		public Integer reasonCode;
		public String serviceVersion;
		public String echoKey;
	}
 /***
* @comment : 
* @description  
*/  
	public class ErrorTable {
		public Integer errorCode;
		public String errorMessage;
	}
 /***
* @comment : 
* @description  
*/  
	public class Cib033o {
		public List<ErrorTable> errorTable;
	}
 /***
* @comment : 
* @description  
*/  
	public CiupdJointParticipantsByClientCodeV7Response ciupdJointParticipantsByClientCodeV7Response;
 /***
* @comment : 
* @description  
*/  
	public class Nbsmsgo3 {
		public String version;
		public Object sysErrTxt;
		public Integer nbrUserMsgs;
		public Integer nbrUserErrs;
		public Object msgEntry;
	}
 /***
* @comment : 
* @description  
*/  
	public class CiupdJointParticipantsByClientCodeV7Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cib033o cib033o;
	}
     /***
* @comment : 
* @description  
*/  
    public CIupdJointPByClientCodeV7_IB_Resp_v1(){
        
    }


}