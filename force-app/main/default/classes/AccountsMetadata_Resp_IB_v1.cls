/**
 * @description       : AccountsMetadata_Resp_IB_v1
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-05-31
 * @last modified by  : André Pietersen (IQ Business)
 * Ver   Date         Author                               Modification
 * 1.0   2021-05-27   André Pietersen (IQ Business)   Initial Version
**/
public class AccountsMetadata_Resp_IB_v1 extends Base_IB {
    public string status;
    public List<Error> errors;
    public string error;
    public string data;
    public List<string> links;
    public string timestamp;
    public string message;

    /**
    * @description Error class
    **/
    public class Error {
        public string type;
        public string statusCode;
        public string message;
        public string sourceSystem;
        public string fieldName;
    }

    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"_number":', '"z_number":');
    }
}