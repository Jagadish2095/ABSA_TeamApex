/**
* Apex Integration Response Bean class for Wqgetanalystcommentsv7 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Wqgetanalystcommentsv7_Resp_IB_v1 {
  
    public String StatusMessage;
    public Integer StatusCode;
    
    public WQgetAnalystCommentsV7Response WQgetAnalystCommentsV7Response;

	public class Results {
		public String seqNo;
		public String commentCode;
		public String commentDesc;
	}

	public class WQgetAnalystCommentsV7Response {
		public String name;
		public String surname;
		public String idType;
		public String idReg;
		public String dob;
		public String sbu;
		public Results results;
	}
     
    public static Wqgetanalystcommentsv7_Resp_IB_v1 dummyResponse(){
        Wqgetanalystcommentsv7_Resp_IB_v1 responseBean = new Wqgetanalystcommentsv7_Resp_IB_v1();
        Wqgetanalystcommentsv7_Resp_IB_v1.WQgetAnalystCommentsV7Response Wqgetanalystcommentsbean= new Wqgetanalystcommentsv7_Resp_IB_v1.WQgetAnalystCommentsV7Response();
        Wqgetanalystcommentsv7_Resp_IB_v1.Results resultsbean = new Wqgetanalystcommentsv7_Resp_IB_v1.Results();
        resultsbean.commentCode = '0';
        resultsbean.commentDesc = 'No Comments found';
        resultsbean.seqNo = '1';
        Wqgetanalystcommentsbean.name='VAUGHAN STANLEY HELLIER WOOD';
        Wqgetanalystcommentsbean.surname='VAUGHAN STANLEY HELLIER WOOD';
        Wqgetanalystcommentsbean.idType='3';
        Wqgetanalystcommentsbean.idReg='6503225155081';
        Wqgetanalystcommentsbean.dob='19650322';
        Wqgetanalystcommentsbean.sbu='H';
        Wqgetanalystcommentsbean.results = resultsbean;
        responseBean.WQgetAnalystCommentsV7Response = Wqgetanalystcommentsbean;
        responseBean.StatusMessage = 'SUCCESS';
        responseBean.StatusCode = 200;
        return responseBean;
       
    }
}