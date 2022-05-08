/*
* Response Integration Bean for exergyLogin Service
* @author chandra Bhushan Singh
* @created 2021-02-04
* @W-007772,007776,007778,007777,007783
*/

public class ExergyLogin_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public String status;

    public class LoginResponse {
        @AuraEnabled public String LoginResult;
    }

    @AuraEnabled public LoginResponse LoginResponse;
}