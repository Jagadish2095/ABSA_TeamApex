public class Prediction_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String responseMessage;
    
    public class Errors {
    }

    public Data data;
    public Boolean success;
    public String message;
    public List<Errors> errors;

    public class Data {
        public String caseId;
        public String serviceTypeId;
        public String status;
        public Double confidence;
        public String responseAction;
        public String accountId;
    }
}