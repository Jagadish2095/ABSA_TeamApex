/**
 * @description       : Controller class for Origination Vertical Tab
 * @author            : Almas
 * @last modified on  : 06-08-2021
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author    Modification
 * 1.0   06-08-2021   Almas   Initial Version
 * 2.0   06-08-21      Englarmerdge/Saurabh
 **/
public class originationVerticalTabsController {
	/**
	* @description : Get Sole trader flag for  Account
	* @author Almas | 06-08-2021
	* @param oppId
	* @return Boolean
	**/
	@AuraEnabled
	public static Boolean isSoleTraderAccount(Id oppId) {
		Boolean isSoleTrader = false;
		Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id = :oppId];//new OpportunitiesSelector().selectByOpportunityId(oppId, 1).get(0).AccountId;
        Account acc = [SELECT Id, RecordType.Name, Client_Type__c FROM Account WHERE Id = :opp.AccountId];

		if (acc.Client_Type__c.equalsIgnoreCase('Sole Trader') && (acc.RecordType.Name.equalsIgnoreCase('Individual Client') || acc.RecordType.Name.equalsIgnoreCase('Individual Prospect') )) {
			isSoleTrader = true;
		}

		return isSoleTrader;
	}

	/**
	* @description : Get Application Record for current opp
	* @author Almas | 06-08-2021
	* @param oppId
	* @return List<Application__c>
	**/
	@AuraEnabled
	public static List<Application__c> getAppRecords(Id oppId) {
		List<Application__c> appRecList = new ApplicationsSelector().selectByOpportunityId(oppId);

        return appRecList;
	}

	/**
	* @description : Get SuperUser flag for current user
	* @author Almas | 06-08-2021
	* @return Boolean
	**/
	@AuraEnabled
	public static Boolean getSuperUsersAll() {
		Boolean isSuperUser;
        List<GroupMember> grpMemb = [SELECT UserOrGroupId FROM GroupMember WHERE group.name = 'Super Users Origination- Credit'];

		for (GroupMember gp : grpMemb) {
            if (gp.UserOrGroupId == userInfo.getUserId()){
                isSuperUser = true;
            }
		}

        return isSuperUser;
    }

    /**
    * @description  : get locate call required flag based on opp
    * @author Englarmerdge | 06-08-2021
    * @param oppId
    * @return Boolean
    **/
    @AuraEnabled
    public static Boolean isLocateCallRequired(Id oppId) {
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		return LocateCallController.isLocateCallRequired(opp?.Id);
    }


    /**
    * @description : Get illustrative decision flag for opp
    * @author Himani | 06-08-2021
    * @param oppId
    * @return Boolean
    **/
    @AuraEnabled
    public static Boolean getIllustrativeDecisionFlag(Id oppId) {
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
        if(opp?.Illustrative_Decision__c == true){
            return true;
        }
        else{
            return false;
        }
    }

    /**
    * @description : Get Selected Product Family for opp
    * @author Saurabh | 06-08-2021 | W-007224
    * @param oppId
    * @return List<String>
    **/
    @AuraEnabled
    public static List<String> getSelectedProductFamily(Id oppId){
        List<String> selectedProductFamilyList = new List<string>();
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
        if(opp?.Selected_Product_Family__c != '' || opp?.Selected_Product_Family__c != Null){
            selectedProductFamilyList = string.valueof(opp.Selected_Product_Family__c).split(',');
        }
        return selectedProductFamilyList;
    }

    /**
    * @description : Adding method to display next tabs based on application progress
    * @author Saurabh | 06-08-2021 : W-007224
    * @param oppId
    * @return List<String>
    **/
    @AuraEnabled
    public static List<String> getCompletedTabs(Id oppId){
        List<String> completedTabsList = new List<string>();
        List<Validations__c> fieldValidationList = [SELECT Id, Related_to_Object_Record_Id__c, Validation_Value__c, Related_to_Object_Api_Name__c, Name
        FROM Validations__c
        WHERE Related_to_Object_Record_Id__c = :oppId];
        if(!fieldValidationList.isEmpty()){
         for(Validations__c val : fieldValidationList ){
         if(val.Validation_Value__c == True)
         	completedTabsList.add(val.Name);
         }
        }
        return completedTabsList;
    }



}