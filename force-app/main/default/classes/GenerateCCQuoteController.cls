/**
 * @description       :
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 07-13-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-07-13   almas.aleem@absa.africa   Initial Version
**/


public class GenerateCCQuoteController {
    /**
     * @description
     * @author almas.aleem@absa.africa | 2021-07-13
     * @param oppId
     * @return List<Application_Product__c>
    **/
    @auraEnabled
    public static List<Application_Product__c> FetchproductList(Id oppId){
        List<Application_Product__c> appPrdList = [Select id,CC_Quote_Json__c, Name , Application_Product_Parent__c, Product_Name__c, Account_Number__c,Product_Amount__c,
                                                Product_State__c,Product_Status__c,Limit_Type__c,Temp_Account_Number__c,Agreement_Category__c,Campaign_Code__c,
                                                toLabel(Product_Type__c) producttype,Review_Date__c,Accept_TOB__c, Expiry_Date__c,Secured_By_Mortgage_Bond__c,
                                                NCA_Appplicable__c, Maximum_NCA_Rate_Type__c,Maximum_NCA_Rate__c
                                                from Application_Product__c
                                                Where Opportunity__c=:oppId and Product_Name__c = 'Credit Card' ];

        List<Application_Product__c> retappPrdList = new List<Application_Product__c>();
        for(Application_Product__c appProd : appPrdList){
            if(appProd.Application_Product_Parent__c == null && appProd.Product_State__c !=null &&( appProd.Product_State__c.equalsIgnoreCase('New') || appprod.Product_State__c.equalsIgnoreCase('Existing'))){
                if(appProd.Product_Status__c =='Accepted' || appProd.Product_Status__c =='FulFilled'  ){
                    retappPrdList.add(appProd);
                }
            }
        }

        return retappPrdList;
    }

    /**
     * @description
     * @author almas.aleem@absa.africa | 2021-07-13
     * @param prodId
     * @param oppId
     * @return QuoteWrapper
    **/
    @auraEnabled
    public static QuoteWrapper generateCCQuoteFunction(Id prodId,Id oppId){
       QuoteWrapper prWrapper;
        system.debug('prodId---'+prodId);
		Application_Product__c appProd = [Select id,CC_Quote_Json__c, Name , Application__r.Credit_Application_Accepted__c, Product_Name__c, Account_Number__c,Product_Amount__c,
                                                    Product_State__c,Product_Status__c,Limit_Type__c,Temp_Account_Number__c,Agreement_Category__c,Campaign_Code__c,
                                                    toLabel(Product_Type__c) producttype,Review_Date__c,Accept_TOB__c, Expiry_Date__c,Secured_By_Mortgage_Bond__c,
                                                    NCA_Appplicable__c, Maximum_NCA_Rate_Type__c,Maximum_NCA_Rate__c,Business_Credit_Card_Product_Type__c,
                                                    (Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c,
                                                     Existing_Account__c,Requested__c,Final_Offered_Number__c,Offered_by_Powercurve__c,Final_Offered__c
                                                     from Terms_Of_Business__r )
                                                    from Application_Product__c
                                                    Where Product_Name__c = 'Credit Card' AND id=:prodId ];


        if(appProd.CC_Quote_Json__c == null){
            prWrapper = new QuoteWrapper();
            prWrapper.serviceFee = 32;
            prWrapper.annualinterestRate=17;
            prWrapper.annualinterestRateP=6.5;
            prWrapper.UpfrontInitiationfees=272;
            prWrapper.otherfees= 0;
        }else{
           prWrapper =  (QuoteWrapper)JSON.deserialize(appProd.CC_Quote_Json__c , QuoteWrapper.Class);
        }
         prWrapper.creditLimit = 0;
        if(appProd.Terms_Of_Business__r != null){
       for(Terms_Of_Business__c tob : appProd.Terms_Of_Business__r ){
                //if(tob.TOB_Classification__c.equalsIgnoreCase('Product Terms')){
                    if(tob.Tob_Description__c.equalsIgnoreCase('Limit')){
                        prWrapper.creditLimit = Decimal.valueOf(tob.Final_Offered__c);
                        prWrapper.creditAdvanced = Decimal.valueOf(tob.Final_Offered__c);
                    }
                     if(tob.Tob_Description__c.equalsIgnoreCase('Product Type')){
                        prWrapper.APcardType = tob.Final_Offered__c;
                       // prWrapper.creditAdvanced =  tob.Final_Offered_Number__c;
                    }
                //}
            }
        }else{
            prWrapper.creditLimit = 0;
        }


         appProd.CC_Quote_Json__c = JSON.serialize(prWrapper);
         appProd.Product_Amount__c = prWrapper.creditLimit;
         appProd.Credit_Card_Limit__c = prWrapper.creditLimit;
        // appProd.Card_Type__c = appProd.Business_Credit_Card_Product_Type__c;
         update appProd;

        return prWrapper;
    }

    /**
     * @description
     * @author almas.aleem@absa.africa | 2021-07-13
     * @param QuoteWrap
     * @param ProdId
     * @return QuoteWrapper
    **/
	@auraEnabled
    public static QuoteWrapper calculateQuotes(String QuoteWrap,Id ProdId){
        QuoteWrapper  prWrapper = (QuoteWrapper)JSON.deserialize(QuoteWrap, QuoteWrapper.Class);

        //calculcations part
        Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(ProdId);
        prWrapper.annualservicefees = prWrapper.servicefee * 12;
        prWrapper.CreditInsurAggre = 0; // how to calculate ask
        prWrapper.monthlyinstalment = (prWrapper.creditLimit + (( prWrapper.creditLimit  * ((prwrapper.annualinterestRate +( prwrapper.annualinterestRate - prWrapper.annualinterestRateP))/100))/12))+ prWrapper.annualservicefees;
        prWrapper.totalinterest = prWrapper.creditLimit * prWrapper.annualinterestRate * 12;
        prWrapper.totalinterestandfees = prWrapper.totalinterest + prWrapper.UpfrontInitiationfees + prWrapper.annualservicefees;
        prWrapper.totaltoberepaid = prWrapper.totalinterestandfees + prWrapper.creditLimit + prWrapper.creditInsurance;
        prWrapper.totalCreditCost = prWrapper.creditLimit + prWrapper.annualservicefees +prWrapper.UpfrontInitiationfees +prWrapper.AnnualInterestRate;

        prWrapper.creditcostmultiple = (prWrapper.totalCreditCost/prWrapper.creditLimit);

        appProd.CC_Quote_Json__c = JSON.serialize(prWrapper);
        appProd.Margin__c = prWrapper.annualinterestRateP;

        try{
              update appprod ;
        }catch(Exception e){
            system.debug('e---'+e.getStackTraceString());
        }
        return prWrapper;

    }

    /**
     * @description
     * @author almas.aleem@absa.africa
    */
    public class QuoteWrapper {
        @auraEnabled public Decimal creditLimit;
        @auraEnabled public String APcardType;
        @auraEnabled public Decimal creditInsurance;
        @auraEnabled public Decimal creditAdvanced;
        @auraEnabled public Decimal serviceFee;
        @auraEnabled public Decimal annualinterestRate;
        @auraEnabled public Decimal annualinterestRateP;
        @auraEnabled public Decimal UpfrontInitiationfees;
        @auraEnabled public Decimal annualservicefees;
        @auraEnabled public Decimal CreditInsurAggre;
        @auraEnabled public Decimal monthlyinstalment;
        @auraEnabled public Decimal totalinterest;
        @auraEnabled public Decimal totalinterestandfees;
        @auraEnabled public Decimal  totaltoberepaid ;
        @auraEnabled public Decimal totalCreditCost;
        @auraEnabled public Decimal creditcostmultiple;
        @auraEnabled public Decimal creditInsurMonth;
        @auraEnabled public Decimal otherfees;
    }
}