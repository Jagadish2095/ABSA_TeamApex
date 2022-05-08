public class ValidateAddress_IU_v1 {

    //Populates the Validate Address request bean from the parameters passed
    public static ValidateAddress_Req_IB_v1 mapRequestFields(String languageP, Integer numberOfAddressP, Integer addressTypeP, String addressLine1P, String addressLine2P, String suburbP, String townP, String postalCodeP){
        
        ValidateAddress_Req_IB_v1.cls_addressCollection addressCollection = new ValidateAddress_Req_IB_v1.cls_addressCollection();
        addressCollection.addressType = addressTypeP;
        addressCollection.addressLine1 = addressLine1P;
        addressCollection.addressLine2 = addressLine2P;
        addressCollection.suburb = suburbP;
        addressCollection.town = townP;
        addressCollection.postalCode = postalCodeP;
        
        List<ValidateAddress_Req_IB_v1.cls_addressCollection> addressCollectionList = new List<ValidateAddress_Req_IB_v1.cls_addressCollection>();
        addressCollectionList.add(addressCollection);
        
        ValidateAddress_Req_IB_v1 requestBean = new ValidateAddress_Req_IB_v1();
        requestBean.language = languageP;
        requestBean.numberOfAddress = numberOfAddressP;
        requestBean.addressCollection = addressCollectionList;
        System.debug('Get Validate Address Request Bean: ' + requestBean);
        return requestBean;
    }
    
    //Populates the Validate Address response bean from an http response
    public static ValidateAddress_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        ValidateAddress_Resp_IB_v1 responseBean = new ValidateAddress_Resp_IB_v1();
        responseBean = (ValidateAddress_Resp_IB_v1)responseBean.deserialize( respP.getBody(), ValidateAddress_Resp_IB_v1.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Validate Address Response Bean: ' + responseBean);
        return responseBean;
    }
    
    //Populates the Validate Address response bean as failed with the necessary data
    public static ValidateAddress_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        ValidateAddress_Resp_IB_v1 validateAddressResponse = new ValidateAddress_Resp_IB_v1();
        validateAddressResponse.message = messageP;
        validateAddressResponse.status = statusP;
        validateAddressResponse.statusCode = statusCodeP;
        
        System.debug('Validate Address Failed Response Bean: ' + validateAddressResponse);
        return validateAddressResponse;
    }
}