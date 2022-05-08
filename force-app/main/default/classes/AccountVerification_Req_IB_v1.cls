/*
* Integration Bean for Verify Account Details Request
* @author Danie Booysen
* @created 2019-01-18
*/

public class AccountVerification_Req_IB_v1 extends Base_IB {
    
    public String channel;
    public String application;
    public String trace;
    public String avsruser;
    public String reqDate;
    public String reqTime;
    public String reqConfirm;
    public String receiveBank;
    public String receiveBranch;
    public String receiveAccno;
    public String accType;
    public String idno;
    public String initials;
    public String name;
    public String accDebits;
    public String accCredits;
    public String accLength;
    public String emailAddress;
    public String cellNo;
    
    public static AccountVerification_Req_IB_v1 createDummy(){
        
        AccountVerification_Req_IB_v1 bean = new AccountVerification_Req_IB_v1();
        
        bean.channel = 'BDP';
        bean.application = 'BDP';
        bean.trace = 'N';
        bean.avsruser = 'AVSR020000';
        bean.reqDate = '20180807';
        bean.reqTime = '10430101';
        bean.reqConfirm = '';
        bean.receiveBank = '1';
        bean.receiveBranch = '632005';
        bean.receiveAccno = '9050999852';
        bean.accType = '1';
        bean.idno = '8008310491084';
        bean.initials = 'PF';
        bean.name = 'PUMEZA';
        bean.accDebits = 'Y';
        bean.accCredits = 'Y';
        bean.accLength = 'Y';
        bean.emailAddress = '';
        bean.cellNo = '';
        
        return bean;
        
    }
    
}