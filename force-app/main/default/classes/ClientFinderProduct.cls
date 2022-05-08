/**
 * This is the class definition for a product selected as part of the client finder process
 *
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-04-05
 */

public class ClientFinderProduct {

    @AuraEnabled
    public String accountNumber {get;set;}
    @AuraEnabled
    public String accountStatus {get;set;}
    @AuraEnabled
    public String accountProduct {get;set;}

    public ClientFinderProduct(){}
    public ClientFinderProduct(String accNumber, String accStatus, String accProduct) {
        accountNumber = accNumber;
        accountStatus = accStatus;
        accountProduct = accProduct;
    }

}