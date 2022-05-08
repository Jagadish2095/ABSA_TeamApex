public class ASPDeviceContractCaseRequest{

   public SrmCase SrmCase { get; set; }
   public ASPDeviceContractRequest ASPDeviceContractRequest { get; set; }

   public ASPDeviceContractCaseRequest DummyRequest(){
      ASPDeviceContractCaseRequest request= new ASPDeviceContractCaseRequest();
      request.SrmCase = new SrmCase();
      request.ASPDeviceContractRequest = new ASPDeviceContractRequest();
      return request;
   }
   
}