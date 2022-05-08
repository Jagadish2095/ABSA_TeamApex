/* Request object for ASPDeviceCustomerVerification
* @author  Paul du Randt
* @created 2021-02-01
*/
public class ASPDeviceCustomerVerificationRequest {
	public string IDNumber;
	public string Surname;
	public string CIFcode;
	public Boolean IsNewtoBank;
	public string Cellphone;
    
    public ASPDeviceCustomerVerificationRequest DummyRequest()
    {
        ASPDeviceCustomerVerificationRequest request = new ASPDeviceCustomerVerificationRequest();
		request.IDNumber = '9308295041215';
        request.Surname = 'Tester';
        request.CIFcode = 'TEST';
        request.IsNewtoBank = true;
        request.Cellphone = '0833813501';
        return request;
    }
}