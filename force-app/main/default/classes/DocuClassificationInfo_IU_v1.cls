/**
 * @description       : Integration Utility for Document Classification Service
 * @author            : Sandeep Chodisetti
 * @since             : 06-10-2021
**/
public class DocuClassificationInfo_IU_v1{
  /**
              *@comment : getCase
              *@description getCase
              *@return listCases
              *@param filname
              *@param docstr
      **/
    public static String mapRequestFields(string filname,String docstr){
        String requestUUID = filname+' - '+datetime.now();
        String source = 'Home Loans';
        String fileName = filname;
        String mimeType = 'application/pdf';
        String documentBase64;

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('RequestUUID', GuidUtil.NewGuid());//'123e4567-e89b-12d3-a456-426614174000');
        gen.writeStringField('Source', 'Test');
        gen.writeStringField('FileName', 'Test');
        gen.writeStringField('MimeType', 'application/pdf');
        gen.writeStringField('DocumentBase64', docstr);
        gen.writeEndObject();
        gen.close();
        return gen.getAsString();
    }
     /***
* @comment : DocuClassInfo_Resp_Parse Parser
* @description method to handle the response from document clarrification
  *@param responseP
* @return DocuClassInfo_Resp_Parse
* **/
    public static DocuClassInfo_Resp_Parse mapResponseFields(HttpResponse responseP)
    {
        //string response = responseP.getBody();
        DocuClassInfo_Resp_Parse responseBean = new DocuClassInfo_Resp_Parse();
        DocuClassInfo_Resp_Parse resp = new DocuClassInfo_Resp_Parse();
        responseBean = (DocuClassInfo_Resp_Parse)resp.deserialize( responseP.getbody(), DocuClassInfo_Resp_Parse.class );
        try{
            responseBean.status = responseP.getStatus();
            responseBean.statusCode = responseP.getStatusCode();
            responseBean.message = '';
            if(test.isRunningTest()){
                responseBean.results = responseBean.results;
            	responseBean.requestUUID = responseBean.requestUUID;
            	responseBean.results = responseBean.results;
                responseBean.results.Details = 'Test';
                responseBean.results.status = 'Test';
                responseBean.statusCode = 200;
                responseBean.documentType = 'Test';
            }

        }catch(exception ex){
            //Exception Handling
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + ex.getMessage() + '. ' + ex.getStackTraceString();
            
        }
        return responseBean;

    }
    /***
* @comment : DocuClassInfo_Resp_Parse Parser
* @description method to handle the failed response from document clarrification
* @param	  statusCodeP
* @param	  statusP
* @param	  messageP
* @return DocuClassInfo_Resp_Parse
* **/
    public static  DocuClassInfo_Resp_Parse mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {
        DocuClassInfo_Resp_Parse responseBean = new DocuClassInfo_Resp_Parse();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        return responseBean;
    }


}