/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-07-08
 * @last modified by  : Manish.battu@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-06-11   muvhuso.nekhubvi@absa.africa   Initial Version
**/

 /**
   * @description Method getOppDetails
   */
public class SPMServiceDetailsController {

    /**
   * @description Method getOppDetails
   * @param oppId
   * @return Opportunity
   */
    @AuraEnabled
    public static Opportunity getOppDetails(Id oppId){
        
      List<Opportunity> opp= new OpportunitiesSelector().selectByOpportunityId(oppId);
      System.debug('opportunities : ' + opp);
         if(opp != null && opp.size() > 0) 
         {
            return opp[0];
         }
        else 
         {
            return null;
        }
    }
    
      /**
   * @description Method getAppRec
   * @param oppId
   * @return Application__c
   */
    @AuraEnabled
    public static Application__c getAppRec(Id oppId){
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        return app[0];
    }  

      /**
   * @description Method updateAppDetails
   * @param srcOfFunds
   * @param investmentNumbers
   * @param investorType
   * @param otherInvestorType
   * @param investmentProducts
   * @param applicableOption
   * @param exemption
   * @param listAllProducts
   * @param appRecid
   * @return String
   */
    @AuraEnabled
    public static string updateAppDetails(string srcOfFunds , string investmentNumbers, string investorType,string otherInvestorType,string investmentProducts,
                                          string applicableOption,string exemption ,String listAllProducts, Id appRecid) {
   
        
        try{
            Application__c app = new ApplicationsSelector().selectById(appRecid);
            if(app!=null){
                app.Source_of_Funds_Savings__c= srcOfFunds;
                app.Investment_Number_s__c= investmentNumbers;
                app.Investor_Type__c= investorType;
                app.Specify_Other_Investment_Type__c= otherInvestorType;
                app.Investment_Product_s_please_list_them__c= investmentProducts;
                app.applicable_option__c= applicableOption;
                app.Exemption__c= Exemption;
                app.Please_List_All__c = listAllProducts;
                upsert app;
            }
            return 'SUCCESS';
        }catch(Exception e){
            system.debug(e.getMessage());
            return 'FAILURE';
        }
        
    }

    /**
    * @description 
    * @author 
    * @param oppId 
    * @return Account 
    **/
    @AuraEnabled
    public static Account getAccount(Id oppId) {
        Account acc=new AccountsSelector().selectByOpportunityId(oppId);
        return acc;     
        
    }

    /**
    * @description 
    * @author 
    * @param oppId 
    * @return string 
    **/
    @AuraEnabled
    public static string updateOppStage(Id oppId){
        try{
            Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
            if(opp != null){
                opp.StageName = 'Upload Documents';

                update opp;
            }
            return 'SUCCESS';
        }catch(Exception ex){
            system.debug(ex.getMessage());
            return 'FAILURE';
        }
    }
}