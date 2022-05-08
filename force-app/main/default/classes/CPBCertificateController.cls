/**
 * @description       :Class to show CPBCertificate
 * @author            :Diksha Wasekar
 * @last modified on  : 2021-11-08
 * @last modified by  : 
**/
public class CPBCertificateController {


/**
* @description Method to call CPB Service Details
* @author  | 2021-11-08
* @param accountId
* @return String
**/
@AuraEnabled
public static String getCPBServiceDetails
    
    (Id accountId){
String idNumber, lastName;
List<Account> acctlst =[select id ,ID_Number__pc,LastName  from Account where Id=:accountId];
if(!acctlst.isEmpty() && acctlst != null ){
idNumber= acctlst[0].ID_Number__pc;
lastName= acctlst[0].LastName;
}
return OnboardingIndividualDetailsController.callCPBService(idNumber, lastName);
}

/**
* @description Method to get existing Address
* @author  | 2021-11-08
* @param accountId
* @param CPBResponse
* @return List<Address__c>
**/
@AuraEnabled
public static List<Address__c> getExistingAddress(Id accountId,String CPBResponse){
//Get existing Addresses linked to Account
List<Address__c> allAddressRelatedToAcc = new AddressesSelector().addressesRelatedToAcc(accountId);
List<Address__c> residentialAdd = new List<Address__c>();

if(CPBResponse ==null && CPBResponse ==''){
//For getting the details of exiting Physical  or Residential Address
for (Address__c eachAddress : allAddressRelatedToAcc){
if (eachAddress.Address_Type__c == 'Physical Address' || eachAddress.Address_Type__c == 'Residential'){
residentialAdd.add(eachAddress);
}
}
}
else{

CPBValidate_Resp_IB_v1 cpbDataClass = (CPBValidate_Resp_IB_v1)JSON.deserialize(CPBResponse, CPBValidate_Resp_IB_v1.class);
CPBValidate_Resp_IB_v1.PostalAddress cpbPostalDataClass = null;
CPBValidate_Resp_IB_v1.ResidentialAddress cpbResidentialDataClass = null;
List<Address__c> addListToBeInsert ;
Account accRec;
if (String.isNotBlank(accountId)){
accRec = new AccountsSelector().selectAllById(accountId);
} else{
throw new AuraHandledException('Account Record needs to created first.');
}

if (cpbDataClass != null && cpbDataClass.Person != null){

if (cpbDataClass.Person.AddressInformation != null){
cpbPostalDataClass = cpbDataClass.Person.AddressInformation.PostalAddress;
cpbResidentialDataClass = cpbDataClass.Person.AddressInformation.ResidentialAddress;
}
if (cpbPostalDataClass != null){
//Residential Address
accRec.ShippingStreet = cpbPostalDataClass.Line1;
accRec.ShippingCity = cpbPostalDataClass.Line2;
accRec.ShippingState = cpbPostalDataClass.Line3;
accRec.ShippingCountry = cpbPostalDataClass.Line4;
accRec.ShippingPostalCode = cpbPostalDataClass.PostalCode;
}

if (cpbResidentialDataClass != null){
//Postal Address
accRec.BillingStreet = cpbResidentialDataClass.Line1;
accRec.BillingCity = cpbResidentialDataClass.Line2;
accRec.BillingState = cpbResidentialDataClass.Line3;
accRec.BillingCountry = cpbResidentialDataClass.Line4;
accRec.BillingPostalCode = cpbResidentialDataClass.PostalCode;
}
}

upsert accRec;

if (accountId != null && cpbDataClass != null){
Address__c postal = new Address__c();
Address__c street = new Address__c();
addListToBeInsert = new List<Address__c>();

if (allAddressRelatedToAcc != null && allAddressRelatedToAcc.size() > 0){
//Check if there's a Postal address linke dto Account
//If yes, then update existing, else insert new Address
for (Address__c eachAddress : allAddressRelatedToAcc){
if (eachAddress.Address_Type__c == 'Postal'){
    postal = eachAddress;
} else if (eachAddress.Address_Type__c == 'Physical Address'){
    street = eachAddress;
}
}
}

// Add Postal address
if (cpbPostalDataClass != null){
postal.account__c = accountId;
postal.Address_Type__c = 'Postal';
postal.Data_Status__c = 'Un Structured';
postal.Address1__c = cpbPostalDataClass.Line1;
postal.Address2__c = cpbPostalDataClass.Line2;
postal.Address3__c = cpbPostalDataClass.Line3;
postal.Address4__c = cpbPostalDataClass.Line4;
postal.Address5__c = cpbPostalDataClass.PostalCode;
postal.Shipping_Street__c = cpbPostalDataClass.Line1;
postal.Shipping_Suburb__c = cpbPostalDataClass.Line3;
postal.Shipping_City__c = cpbPostalDataClass.Line3;
postal.Shipping_State_Province__c = cpbPostalDataClass.Line4;
postal.Shipping_Zip_Postal_Code__c = cpbPostalDataClass.PostalCode;
addListToBeInsert.add(postal);

}

// Add Residential address
if (cpbResidentialDataClass != null){
street.account__c = accountId;
street.Address_Type__c = 'Physical Address';
street.Data_Status__c = 'Un Structured';
street.Address1__c = cpbResidentialDataClass.Line1;
street.Address2__c = cpbResidentialDataClass.Line2;
street.Address3__c = cpbResidentialDataClass.Line3;
street.Address4__c = cpbResidentialDataClass.Line4;
street.Address5__c = cpbResidentialDataClass.PostalCode;
street.Shipping_Street__c = cpbResidentialDataClass.Line1;
street.Shipping_Suburb__c = cpbResidentialDataClass.Line3;
street.Shipping_City__c = cpbResidentialDataClass.Line3;
street.Shipping_State_Province__c = cpbResidentialDataClass.Line4;
street.Shipping_Zip_Postal_Code__c = cpbResidentialDataClass.PostalCode;
addListToBeInsert.add(street);

}

if (addListToBeInsert != null && addListToBeInsert.size() > 0){
upsert addListToBeInsert;
}
//For getting the details of newly inserted Physical Address
for (Address__c upsertedAdd : addListToBeInsert){
if (upsertedAdd.Address_Type__c == 'Physical Address' || upsertedAdd.Address_Type__c == 'Residential'){
residentialAdd.add(upsertedAdd);
}
}
}
}


return residentialAdd;

}

}