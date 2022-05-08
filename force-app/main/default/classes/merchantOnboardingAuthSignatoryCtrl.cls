/**
*@description merchantOnboardingAuthSignatoryCtrl
*Apex Class merchantOnboardingAuthSignatoryCtrl
* @author  Tinashe M Shoko - 01-06-2020
* @version v1.0
* @since   
*
*/
public class merchantOnboardingAuthSignatoryCtrl {
    /** 
   * @description getOpportunityProduct
   * @param oppId
   * @return OpportunityLineItem
   */
   @AuraEnabled
   public static OpportunityLineItem getOpportunityProduct(id oppId) {
       OpportunityLineItem oppLineItem;
      
       List<OpportunityLineItem> oppLineItemList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(oppId,1);
       if(oppLineItemList != null && oppLineItemList.size() > 0 && !oppLineItemList.isEmpty()){
           oppLineItem = oppLineItemList[0];
       }
       return oppLineItem;
   }
   /** 
   * @description getAccountContactRelation
   * @param oppId
   * @return string
   */
   @AuraEnabled
   public static string  getAccountContactRelation(id oppId) {
       List<contactPerson> cpList = new List<contactPerson>() ;
       id accId = new OpportunitiesSelector().selectByOppId(oppId).AccountId;
       if (accId != null) {
           List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectRelationByAccountId(accId);
           if(acrList != null && acrList.size() > 0 && !acrList.isEmpty()){
               for (AccountContactRelation acr : acrList ) {
                   contactPerson cp = new contactPerson();
                   cp.id = acr.Id;
                   cp.salutation = acr.Contact.Salutation;
                   cp.initials = acr.Contact.Initials__c;
                   cp.lastName = acr.Contact.LastName;
                   cp.mobilePhone = acr.Contact.MobilePhone;
                   cp.email = acr.Contact.Email;
                   cp.roles = acr.Roles;
                   cpList.add(cp);
               }
           } else {
               Account ac = new AccountsSelector().selectAllById(accId);
               if (ac != null) {
                   contactPerson cp = new contactPerson();
                   cp.id = ac.Id;
                   cp.salutation = ac.PersonTitle;
                   cp.initials = ac.Initials__pc;
                   cp.lastName = ac.LastName;
                   cp.mobilePhone = ac.PersonMobilePhone;
                   cp.email = ac.PersonEmail;
                   cp.roles = 'Individual with Authority to Act';
                   cpList.add(cp);
               }
           }
       }
       return Json.serialize(cpList);
   }

   
   /** 
   * @description Tinashe M Shoko - added so we cater for both Person and non-Person Accounts
   */
   public class contactPerson {
       /** 
   * @description 
   */
       public String id { get; set; }
       /** 
   * @description 
   */
       public String salutation { get; set; }
       /** 
   * @description 
   */
       public String initials { get; set; }
       /** 
   * @description 
   */
       public String lastName { get; set; }
       /** 
   * @description 
   */
       public String mobilePhone { get; set; }
       /** 
   * @description 
   */
       public String email { get; set; }
       /** 
   * @description 
   */
       public String roles { get; set; }
       /** 
   * @description 
   */
       public String designation { get; set; } // W-13685
   }
}