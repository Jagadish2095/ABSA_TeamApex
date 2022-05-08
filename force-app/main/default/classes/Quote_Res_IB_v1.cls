/*
* @description Response Integration Bean for Quote Service for Absa Instant Life
* @author Satya Boyenepalli
* @created 2021-07-27
*/
/**
* @description quote response class
*/
public with sharing class Quote_Res_IB_v1 extends Base_IB {


/**
* @description Quoteresponse
*/
    public List<ValidationErrors> ValidationErrors;
    public List<InsuredLineResults> InsuredLineResults;
    public String WebLink;

/**
* @description ValidationErrors
*/
    public class ValidationErrors {
        public String id;
        public String Message;
    }
 /**
* @description ValidationErrors
*/
    public class InsuredLineResults {
        public String InsuredAmount;
        public String ProductCode;
        public String PremiumAmount;
        public String StatusCode;
    }
/**
* @description Quote_Res_IB_v1
* @return Quote_Res_IB_v1
*/
    
    public static Quote_Res_IB_v1 dummyResponse(){
        Quote_Res_IB_v1 responseBean = new Quote_Res_IB_v1();
        responseBean.ValidationErrors = new List<Quote_Res_IB_v1.ValidationErrors>();
        responseBean.InsuredLineResults = new List<Quote_Res_IB_v1.InsuredLineResults>();
        responseBean.WebLink='https://qawww.instantlife.co.za/LifeInsurance/Restore?orderId=e0b46f73421045988a0ff9e98e861e7b&linkId=3a8e0451312840e984f23a8ad8a7b36b';
        
        
        return responseBean;
    }
}