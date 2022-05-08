/*
 * Integration Response for FraudSyncApplication Service
 * @author André Pietersen
 * @created 2020-11-04
 */
public class FraudSyncApplication_Resp_IB_V1 extends Base_IB{
    public Integer statusCode;
    public String message;

    public String status;
    public Content content;
    public List<Links> links;
    public List<Error> errors;

    public class Content {
        public String fraudStatus;
        public String applicationNumber;
        public String channelReference;
    }

    public class Links {

    }

    public class Error {
        public string fieldName;
        public string sourceSystem;
        public string type;
        public string message;
    }
}