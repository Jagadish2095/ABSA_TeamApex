/*
* ASPPinPadResponse for ASPDevicePinPad
* @author  Paul du Randt
* @created 2021-02-17
*/

public class ASPPinpadRequest{   
    public string ContractReference;
    public string ContractAccount;
    public string ContractDebtorID;
    public string ContractMaximunAmount;
    public string Function;
    public string UserNo;
    public string ClientType;
    public string AccessNumber;
    public string OverrideNo;
    public string OverrideReason;

    public ASPPinpadRequest DummyONUSandNOUSRequest(){
        ASPPinpadRequest Request = new ASPPinpadRequest();
        Request.UserNo = 'Test';
        Request.ClientType = 'Test';
        Request.OverrideNo = 'Test';
        Request.OverrideReason = 'Test';
        Request.AccessNumber = 'Test';
        Request.Function = 'Test';
        return Request;
    }

}