/**
 * @description RecordTypeIdController Class to support cmpChooseTaskComponent
 * @author Chandra Bhushan Singh
 * @updated 27/08/2019
 */
public class RecordTypeIdController {
	/**
	 * @description Method to get record type id
	 * @param developerName
	 * @param sobjectName
	 * @return String
	 */
	@AuraEnabled
	public static String getRecordTypeId(String developerName, String sobjectName) {
		String recordTypeId = '';
		List<RecordType> newRecordTpeList = [
			SELECT Id, Name, DeveloperName, SobjectType
			FROM RecordType
			WHERE DeveloperName = :developerName AND SobjectType = :sobjectName
		];
		if (!newRecordTpeList.isEmpty()) {
			recordTypeId = newRecordTpeList[0].Id;
		}
		return recordTypeId;
	}

	//JQUEV 03-12-2020
	/**
	 * @description Method to get record type id
	 * @param recordTypeName
	 * @param sobjectName
	 * @return String
	 */
	@AuraEnabled
	public static String getRecordTypeIdFromServiceType(String recordTypeName, String sobjectName) {
		String recordTypeId = '';
		List<RecordType> newRecordTpeList = [
			SELECT Id, Name, DeveloperName, SobjectType
			FROM RecordType
			WHERE Name = :recordTypeName AND SobjectType = :sobjectName
		];
		if (!newRecordTpeList.isEmpty()) {
			recordTypeId = newRecordTpeList[0].Id;
		}
		return recordTypeId;
	}

	/**
	 * @description Method to get record type name
	 * @param developerName
	 * @param sobjectName
	 * @return String
	 */

	@AuraEnabled
	public static String getRecordTypeName(String developerName, String sobjectName) {
		String recordTypeName = '';
		List<RecordType> newRecordTpeList = [
			SELECT Id, Name, DeveloperName, SobjectType
			FROM RecordType
			WHERE DeveloperName = :developerName AND SobjectType = :sobjectName
		];
		if (!newRecordTpeList.isEmpty()) {
			recordTypeName = newRecordTpeList[0].DeveloperName;
		}
		return recordTypeName;
	}

	/**
	 * @description Method to Create Opportunity, use record type as paramter
	 * @param accRecordId
	 * @param recordTypeDevName
	 * @return String
	 */
	    @AuraEnabled
    public static String createNewOpportunity(String accRecordId, String recordTypeDevName) {

        if(accRecordId !=null){
            Date todaysDate = System.today();
            Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
            User userRec =  new UsersSelector().selectById(UserInfo.getUserId());
            List<Site__c> sitecodes;
            if(userRec.SiteCode__c!=null){
                sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
            } else{
                sitecodes = new List<Site__c>();
            }

            //Get Standard Pricebook Id
            PriceBook2 priceBookItem = new PriceBook2();
            priceBookItem = [select id from priceBook2 where name = 'Standard Price Book'];

            //check for Client Type and Block it if its individual
            Account accountRecord =   [SELECT Id, Client_Type__c FROM Account where id =: accRecordId ];
            if (accountRecord?.Client_Type__c == 'Individual'){
                throw new AuraHandledException('Credit Opportunity can not be created for Individual Client Type');
            }

            //Saurabh : W:3780 Business Rules Validations
            //check for Business Rules before creating credit Opportunity and update Business_Rules_Decision__c
            string rulesEngineResult = ClientFinderExt.businessRulesEngineHandler(accRecordId);
            //Saurabh : 20210414 adding a salesProcess linking to opp
            // with next enhancement we would use request name as a param from cmp and then we can create a common method to create all type of opp
            List<Sales_Process_Type__c> salesProcessList = new SalesProcessTypesSelector().selectByRequestName('New Credit Product (Business Banking)');
            if(!salesProcessList.isEmpty()){
                //Create Opportunity
                Opportunity onboardOpportunity = new Opportunity();
                onboardOpportunity.Name = 'Credit Onboarding';
                onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get(recordTypeDevName).getRecordTypeId();
                onboardOpportunity.AccountId = accRecordId;
                onboardOpportunity.StageName = 'Confirm Client Eligibility';
                onboardOpportunity.closeDate = todaysDate.addDays(7);
                onboardOpportunity.priceBook2Id = priceBookItem.id;
                onboardOpportunity.Business_Rules_Decision__c = rulesEngineResult;
                onboardOpportunity.Sales_Process_Type__c = salesProcessList[0].id; //Saurabh added lookup to Sales Process Type
                //Capturing Sitecode of loggedin User while creating opportunity if user has site code
                if(!sitecodes.isEmpty()){
                    onboardOpportunity.Site__c= sitecodes[0].Id;
                }

                insert onboardOpportunity;
                //Creating Application Record
                Application__c application = new Application__c();
                application.Opportunity__c = onboardOpportunity.Id;
                INSERT application;
                if(onboardOpportunity.Id!=Null){
                    AllocateStockNumberController.getEDFservice(onboardOpportunity.id);//added by Gulafsha for Credit Onboarding
                }
                return onboardOpportunity.id;
            }
            else{
                throw new AuraHandledException('Credit Opportunity can not be created as Sales Process Type is not defined ');
            }

        } else {
            return null;
        }
    }

	/**  W-019387
	* @description  Create opportunity for Voice
	* @author Lehlohonolo.Matsoso@absa.africa | 2022-03-11
	* @param accRecordId
	* @param recordTypeDevName
	* @param processType
	* @param salesProcessType
	* @return String
	**/
	@AuraEnabled
	public static String createVoiceProductOnboardingOpportunity(String accRecordId, String recordTypeDevName, String processType, String salesProcessType) {

        if(accRecordId !=null){
            Date todaysDate = System.today();
            Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

			User userRec =  new UsersSelector().selectById(UserInfo.getUserId());
            List<Site__c> sitecodes;
            if(userRec.SiteCode__c!=null){
                sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
            } else{
                sitecodes = new List<Site__c>();
            }

			List<Sales_Process_Type__c> salesProcessList = new SalesProcessTypesSelector().selectByRequestName(salesProcessType);
            if(!salesProcessList.isEmpty()){

				PriceBook2 priceBookItem = new PriceBook2();
				priceBookItem = [select id from priceBook2 where name = 'Standard Price Book'];

				Opportunity onboardOpportunity = new Opportunity();
				onboardOpportunity.Name = processType;
				onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get(recordTypeDevName).getRecordTypeId();
				onboardOpportunity.AccountId = accRecordId;
				onboardOpportunity.StageName = 'Confirm Client Eligibility';// was New
				onboardOpportunity.closeDate = todaysDate.addDays(7);
				onboardOpportunity.priceBook2Id = priceBookItem.id;
				onboardOpportunity.Process_Type__c = processType; // W-019387 Voice Process Types (CC, CQ & SV)
				onboardOpportunity.Sales_Process_Type__c = salesProcessList[0].id; // Voice Sales Product Onboarding

				if(!sitecodes.isEmpty()){
					onboardOpportunity.Site__c= sitecodes[0].Id;
				}

				insert onboardOpportunity;
				//Creating Application Record
				Application__c application = new Application__c();
				application.Opportunity__c = onboardOpportunity.Id;
				application.Account__c = accRecordId;
				INSERT application;

				return onboardOpportunity.id;
			}
            else{
                throw new AuraHandledException('Credit Opportunity can not be created as Sales Process Type is not defined ');
            }
        } else {
            return null;
        }
    }

	/**
	 * @description Method to get UCID from Session Cache
	 * @return String
	 */
	@AuraEnabled
	public static String getUCIDValueFromSessionCache() {
		String ucid = '';
		ClientIDnVPollingApex.ClientIDnVSessionObject sessionObj = (ClientIDnVPollingApex.ClientIDnVSessionObject) Cache.Session.get(
			'local.Customer1Cache.clientIDnVSessionObject'
		);
		if (sessionObj != null && String.isNotBlank(sessionObj.ucId)) {
			ucid = sessionObj.ucId;
		}
		return ucid;
	}
}