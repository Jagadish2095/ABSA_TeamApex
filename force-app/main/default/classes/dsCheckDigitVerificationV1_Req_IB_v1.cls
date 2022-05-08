/**
* @description This is CollectionCycleController TEST  Lightning component Apex Controller Class
* @author Kamil Rega
* @created 2020/02/05
*/
public with sharing class dsCheckDigitVerificationV1_Req_IB_v1 extends Base_IB {
    public String accountNumber;
    public String branchCode;
    public String accountType;
    public String transactionType;
 /**
* @description createDummyRequest
* @return dsCheckDigitVerificationV1_Req_IB_v1
*/
    public static dsCheckDigitVerificationV1_Req_IB_v1 createDummyRequest() {
        dsCheckDigitVerificationV1_Req_IB_v1 requestBean = new dsCheckDigitVerificationV1_Req_IB_v1();
        requestBean.accountNumber = '1573017159';
        requestBean.branchCode = '195705';
        requestBean.accountType='01';
        requestBean.transactionType='CR';
        return requestBean;
    }
}