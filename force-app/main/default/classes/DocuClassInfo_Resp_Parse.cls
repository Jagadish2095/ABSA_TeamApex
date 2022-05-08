/**
* @comment sdasdad
* @description       DocuClassInfo_Resp_Parse
* @author            : Sandeep Chodisetti
* @since			  : 06-10-2021
* @group             :
* @last modified on  : 06-12-2021
* @last modified by  : Sandeep Ch
* 
**/
public class DocuClassInfo_Resp_Parse extends Base_IB {
    /**
* @comment Parse
* @description Parse
* */
    public String status{get;set;}
    /**
* @comment Parse
* @description Parse
* */
    public Integer statusCode{get;set;}
    /**
* @comment Parse
* @description Parse
* */
    public String message{get;set;}
    /**
* @comment Parse
* @description Parse
* */
    public String requestUUID{get;set;}
    /**
* @comment Parse
* @description Parse
* */
    public String documentType{get;set;}
    /**
* @comment sdasdad
* @description ssdd
* */
    
    public Results results{get;set;}
    /**
* @comment sdasdad
* @description ssdd
* */
   
    
   public ResponseFields responseFields{get;set;}
    
    /**
* @comment Parse
* @description       : Parsing results
* @author            : Sandeep Chodisetti
* @since			  : 06-10-2021
* @group             :
* @last modified on  : 06-12-2021
* @last modified by  : Sandeep Ch
* 
**/
    public class Results {
        /**
* @comment results
* @description results
* */
        public String status{get;set;}
        /**
* @comment results
* @description results
* */
        public String details{get;set;}
    }
    
 /**
* @comment sdasdad
* @description       ResponseFields
* @author            : Sandeep Chodisetti
* @since			  : 06-10-2021
* @group             :
* @last modified on  : 06-12-2021
* @last modified by  : Sandeep Ch
* 
**/
    public class ResponseFields{
        /**
* @comment results
* @description results
* */
        public String ItemType{get;set;}
        
    }
}