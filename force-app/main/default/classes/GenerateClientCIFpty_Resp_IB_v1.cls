/*
* Service Response class for generating client CIF 
*
* @author  Haritha Police : Absa
* @version v1.0
* @since   2019-11-28
*
*/
public class GenerateClientCIFpty_Resp_IB_v1 {
	public String status;
    public Integer statusCode;
    public String message;
    public String outputCkey;
    
    public cls_StatusMessage statusMessage;
    
    public class cls_StatusMessage{
        public cls_Error[] error;
        public cls_Error errorObj;
    }
    
    public class cls_Error{
        public String reason;
        public String[] reasonList;
    }
    public static GenerateClientCIFpty_Resp_IB_v1 dummyResponse(){
        GenerateClientCIFpty_Resp_IB_v1 responseBean = new GenerateClientCIFpty_Resp_IB_v1();
        responseBean.status='Ok';
        responseBean.statusCode=12;
        responseBean.message='Test Message';
        responseBean.outputCkey='test1';
        
            return responseBean;
    }
}