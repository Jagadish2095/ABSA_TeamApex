/**
 * @description       : 
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-28
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/


/**
* @description RESTful API to get account beneficiaries using CIF
* @author Hloni Matsoso
* @date 27/08/2021
* @requestUri: /services/apexrest/GetAccountBeneficiariesByCIF/v01/
* @httpMethods: POST
*/
@RestResource(urlMapping='/GetAccountBeneficiariesByCIF/v01/*')
global class AccountBeneficiaries_ApiRest_v1 {


    /**
    * @description Default constructor
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28
    **/
    public AccountBeneficiaries_ApiRest_v1() {

    }


    /**
    * @description Returns nominated beneficiary for the CIF. W-015982
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-02
    * @return AccountBeneficiaryResult
    **/
    @HttpGet
    global static AccountBeneficiaryResult doGet() {
        AccountBeneficiaryResult result = new AccountBeneficiaryResult();
        RestRequest req = RestContext.request;
        String cif = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(String.isNotEmpty(cif)){
            result = ExtractBeneficiary(cif);
        }
        else {
            result.Status.IsValid = false;
            result.Status.ErrorMessage = 'No CIF found in URL ' + cif;
        }

        return result;
    }

    /**
    * @description Extracts the beneficiaries
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-12
    * @param cif
    * @return AccountBeneficiaryResult
    **/
    private static AccountBeneficiaryResult ExtractBeneficiary(String cif){
        AccountBeneficiaryResult result = new AccountBeneficiaryResult();
        List<Absa_Listed_Beneficiaries__c> benefificaries;
        Beneficiary temp;

        cif = cif.replace('%20', ' ');
        List<Account> accounts = new AccountsSelector().selectByCIF(new Set<String>{cif}, 1);
        //result.TelebankingChargeAccountNumber = accounts[0].Telebanking_Charge_Account_Number__c;
        AbsaBeneficiarySelector beneSelector = new  AbsaBeneficiarySelector();

        if(accounts != null && accounts.size() > 0 ){
            benefificaries = beneSelector.selectByAccountID(accounts[0].Id, 1000);

            if(benefificaries != null && benefificaries.size() > 0 ){

				for (Absa_Listed_Beneficiaries__c beneItem : benefificaries){
                    temp = createBeneficiary(beneItem);
                    result.Results.add(temp);
                }
            }
            result.Status.IsValid = true;

        }
        else {
            result.Status.IsValid = false;
            result.Status.ErrorMessage = 'No account in SF found with CIF ' + cif;
        }
        return result;
    }

    /**
    * @description Creates result beneficiary
    * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-12
    * @param beneficiary
    * @return Beneficiary
    **/
    public static Beneficiary createBeneficiary(Absa_Listed_Beneficiaries__c beneficiary){
        Beneficiary result = new Beneficiary();
        result.Name = beneficiary.name;
        result.IVR = String.valueOf(beneficiary.Sequence_Number__c);
        result.CellNUmber = beneficiary.Beneficiary_Cellphone_Number__c;
        result.ServiceProvider = beneficiary.Beneficiary_Service_Provider__c;
        result.Bank = beneficiary.Beneficiary_Bank_Name__c;
        result.AccountType = beneficiary.Beneficiary_Account_Type__c;
        result.AccountNumber = beneficiary.Beneficiary_Account_Number__c;
        result.BranchName = beneficiary.BranchCode__c;
        result.RecipientReference = beneficiary.Recipient_Reference__c;
        result.OwnReference = beneficiary.Own_Reference__c;
        if(String.isNotBlank(beneficiary.Beneficiary_Cellphone_Number__c) && String.isNotBlank(beneficiary.Beneficiary_Service_Provider__c)){
            result.BeneficiaryType = 'Mobile';
        }else {
            result.BeneficiaryType = 'Nominated';
        }


        return result;
     }


    /**
	* @description status of the response
	*/
    global class Status
    {
        @AuraEnabled
        public Boolean IsValid;

        @AuraEnabled
        public String ErrorMessage;
    }

    /**
	* @description requested object
	*/
    global class Beneficiary
    {
        @AuraEnabled
         public String Name;

         @AuraEnabled
         public String IVR;

         @AuraEnabled
         public String CellNUmber;

         @AuraEnabled
         public String ServiceProvider;

         @AuraEnabled
         public String Bank;

         @AuraEnabled
         public String AccountNumber;

         @AuraEnabled
         public String AccountType;

         @AuraEnabled
         public String RecipientReference;

         @AuraEnabled
         public String BranchName;

         @AuraEnabled
         public String OwnReference;

         @AuraEnabled
         public String BeneficiaryType;

    }

    /**
	* @description response
	*/
    global class AccountBeneficiaryResult
    {

        /**
        * @description Default constructor
        * @author Lehlohonolo.Matsoso@absa.africa | 2021-11-28 
        **/
        public AccountBeneficiaryResult(){
            this.Status = new Status();
            this.Results = new List<Beneficiary>();
        }

        

        
        // @AuraEnabled
        // public String TelebankingChargeAccountNumber;

        @AuraEnabled
        public Status Status;


         @AuraEnabled
         public List<Beneficiary> Results;


    }

}