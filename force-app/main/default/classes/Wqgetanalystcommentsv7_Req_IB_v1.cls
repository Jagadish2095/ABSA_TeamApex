/**
* Apex Integration Request Bean class for Wqgetanalystcommentsv7 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Wqgetanalystcommentsv7_Req_IB_v1 {
    
    public WQgetAnalystCommentsV7Request WQgetAnalystCommentsV7Request;

	public class WQgetAnalystCommentsV7Request {
		public String refNo;
	}
    
    public static Wqgetanalystcommentsv7_Req_IB_v1 dummyRequest(){
         Wqgetanalystcommentsv7_Req_IB_v1 requestBean = new Wqgetanalystcommentsv7_Req_IB_v1();
         Wqgetanalystcommentsv7_Req_IB_v1.WQgetAnalystCommentsV7Request commentsbean = new Wqgetanalystcommentsv7_Req_IB_v1.WQgetAnalystCommentsV7Request();
         commentsbean.refNo = '121130767';
         requestBean.WQgetAnalystCommentsV7Request = commentsbean;
         return requestBean;
    }
}