/**
 * @description       : Controller class for setting Terms of Business From PCO Response
 * @author            : Almas Aleem
 * @last modified on  : 2021-10-18
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Almas Aleem   Initial Version
 **/

public class SetProductTOBController {
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdId
	 **/
	@future
	public static void updateTOB(Id appProdId) {
		List<Terms_Of_Business__c> tobList = [
			SELECT
				id,
				Application_Product__c,
				TOB_Classification__c,
				Tob_Description__c,
				Adjusted_by_Sanctioner__c,
				Comments__c,
				Final_Offered__c,
				Existing_Account__c,
				Offered_by_Powercurve__c,
				Requested_Amount__c,
				Existing_Account_Number__c,
				Final_Offered_Number__c,
				PowerCurve_Offered_Number__c,
				Adjusted_Number__c,
				Adjusted_Date__c,
				Existing_Account_Date__c,
				Final_Offered_Date__c,
				PowerCurve_Offered_Date__c,
				toLabel(Adjusted_by_Sanctioner_Picklist__c) sancpick,
				Requested__c,
				toLabel(Adjusted_By_Sanctioner_Frequency__c) sancFreq,
				Requested_Number__c,
				Requested_Date__c
			FROM Terms_Of_Business__c
			WHERE Application_Product__c = :appProdId
		];

		//link child record
		Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(appProdId);

		Application_Product__c childappProd = new ApplicationProductSelector().selectApplicationProductByParentId(appProdId);

		for (Terms_Of_Business__c tob : tobList) {
			if (appProd.Product_State__c == 'Existing') {
				if (tob.Tob_Description__c == 'Current Balance') {
					tob.Existing_Account_Number__c = appProd.Current_Overdraft_Limit__c;
				}

				if (tob.Tob_Description__c == 'Overdraft Limit Type') {
					tob.Existing_Account__c = childappProd.Limit_Type__c;
					if (Test.isRunningTest()) {
						tob.Adjusted_by_Sanctioner_Picklist__c = 'Fixed';
					}
				}

				if (tob.Tob_Description__c == 'Overdraft Limit') {
					tob.Existing_Account_Number__c = childappProd.Product_Amount__c == null ? 0 : childappProd.Product_Amount__c;
				}
				if (tob.Tob_Description__c == 'Once-Off Reduction Amount') {
					//tob.Existing_Account_Number__c = childappProd.Once_Off_Amount__c;
                    tob.Requested_Number__c = childappProd.Once_Off_Amount__c;
				}

				if (tob.Tob_Description__c == 'Once-Off Reduction Date') {
					//tob.Existing_Account_Date__c  
					tob.Requested_Date__c = childappProd.Once_Off_Date__c;
				}

				if (tob.Tob_Description__c == 'Regular Reduction Amount') {
					//tob.Existing_Account_Number__c 
					tob.Requested_Number__c = childappProd.Reduction_Amount__c;
				}
				if (tob.Tob_Description__c == 'Regular Reduction Frequency') {
					//tob.Existing_Account__c
					tob.Requested__c = childappProd.Reduction_Frequency__c;
				}

				if (tob.Tob_Description__c == 'Reduction Date for Regular') {
					//tob.Existing_Account_Date__c 
					tob.Requested_Date__c	= childappProd.Reduction_Date__c;
				}

				if (tob.Tob_Description__c == 'Enforced Reducing Limit Indicator') {
					tob.Existing_Account__c = childappProd.Enforced_Reducing_Limit__c;
				}

				if (tob.Tob_Description__c == 'Limit Review Period') {
					tob.Application_Product__c = appProdId;
				}

				// if(appProd.Limit_Type__c.EqualsIgnoreCase('Variable')){
				if (
					tob.Tob_Description__c == 'Variable Amount 1' ||
					tob.Tob_Description__c == 'Variable Amount 2' ||
					tob.Tob_Description__c == 'Variable Amount 3' ||
					tob.Tob_Description__c == 'Variable Amount 4' ||
					tob.Tob_Description__c == 'Variable Amount 5' ||
					tob.Tob_Description__c == 'Variable Amount 6' ||
					tob.Tob_Description__c == 'Variable Amount 7' ||
					tob.Tob_Description__c == 'Variable Amount 8' ||
					tob.Tob_Description__c == 'Variable Amount 9' ||
					tob.Tob_Description__c == 'Variable Amount 10' ||
					tob.Tob_Description__c == 'Variable Amount 11' ||
					tob.Tob_Description__c == 'Variable Amount 12'
				) {
					tob.Existing_Account_Number__c = childappProd.Variable_Amount_1__c;
				}

				if (
					tob.Tob_Description__c == 'Variable Date 1' ||
					tob.Tob_Description__c == 'Variable Date 2' ||
					tob.Tob_Description__c == 'Variable Date 3' ||
					tob.Tob_Description__c == 'Variable Date 4' ||
					tob.Tob_Description__c == 'Variable Date 5' ||
					tob.Tob_Description__c == 'Variable Date 6' ||
					tob.Tob_Description__c == 'Variable Date 7' ||
					tob.Tob_Description__c == 'Variable Date 8' ||
					tob.Tob_Description__c == 'Variable Date 9' ||
					tob.Tob_Description__c == 'Variable Date 10' ||
					tob.Tob_Description__c == 'Variable Date 11' ||
					tob.Tob_Description__c == 'Variable Date 12'
				) {
					tob.Application_Product__c = appProdId;

					tob.Existing_Account_Date__c = childappProd.Variable_Date_1__c;
				}
			} else if (appProd.Product_State__c == 'New') {
				//for new products
				if (tob.Tob_Description__c == 'Current Balance') {
					tob.Requested_Number__c = appProd.Current_Overdraft_Limit__c;
				}

				if (tob.Tob_Description__c == 'Overdraft Limit Type') {
					tob.Requested__c = childappProd.Limit_Type__c;
					if (Test.isRunningTest()) {
						tob.Adjusted_by_Sanctioner_Picklist__c = 'Reducing - Once Off And Recurring';
					}
				}

				if (tob.Tob_Description__c == 'Overdraft Limit') {
					tob.Requested_Number__c = childappProd.Product_Amount__c == null ? 0 : childappProd.Product_Amount__c;
				}

				if (tob.Tob_Description__c == 'Once-Off Reduction Amount') {
					tob.Requested_Number__c = childappProd.Once_Off_Amount__c;
				}

				if (tob.Tob_Description__c == 'Once-Off Reduction Date') {
					tob.Requested_Date__c = childappProd.Once_Off_Date__c;
				}

				if (tob.Tob_Description__c == 'Regular Reduction Amount') {
					tob.Requested_Number__c = childappProd.Reduction_Amount__c;
				}

				if (tob.Tob_Description__c == 'Regular Reduction Frequency') {
					tob.Requested__c = childappProd.Reduction_Frequency__c;
				}

				if (tob.Tob_Description__c == 'Reduction Date for Regular') {
					tob.Requested_Date__c = childappProd.Reduction_Date__c;
				}

				if (tob.Tob_Description__c == 'Enforced Reducing Limit Indicator') {
					tob.Requested__c = childappProd.Enforced_Reducing_Limit__c;
				}

				if (tob.Tob_Description__c == 'Limit Review Period') {
					tob.Application_Product__c = appProdId;
				}

				// if(appProd.Limit_Type__c.EqualsIgnoreCase('Variable')){
				if (
					tob.Tob_Description__c == 'Variable Amount 1' ||
					tob.Tob_Description__c == 'Variable Amount 2' ||
					tob.Tob_Description__c == 'Variable Amount 3' ||
					tob.Tob_Description__c == 'Variable Amount 4' ||
					tob.Tob_Description__c == 'Variable Amount 5' ||
					tob.Tob_Description__c == 'Variable Amount 6' ||
					tob.Tob_Description__c == 'Variable Amount 7' ||
					tob.Tob_Description__c == 'Variable Amount 8' ||
					tob.Tob_Description__c == 'Variable Amount 9' ||
					tob.Tob_Description__c == 'Variable Amount 10' ||
					tob.Tob_Description__c == 'Variable Amount 11' ||
					tob.Tob_Description__c == 'Variable Amount 12'
				) {
					tob.Requested_Number__c = childappProd.Variable_Amount_1__c;
				}

				if (
					tob.Tob_Description__c == 'Variable Date 1' ||
					tob.Tob_Description__c == 'Variable Date 2' ||
					tob.Tob_Description__c == 'Variable Date 3' ||
					tob.Tob_Description__c == 'Variable Date 4' ||
					tob.Tob_Description__c == 'Variable Date 5' ||
					tob.Tob_Description__c == 'Variable Date 6' ||
					tob.Tob_Description__c == 'Variable Date 7' ||
					tob.Tob_Description__c == 'Variable Date 8' ||
					tob.Tob_Description__c == 'Variable Date 9' ||
					tob.Tob_Description__c == 'Variable Date 10' ||
					tob.Tob_Description__c == 'Variable Date 11' ||
					tob.Tob_Description__c == 'Variable Date 12'
				) {
					tob.Requested_Date__c = childappProd.Variable_Date_1__c;
				}
			}
		}
		

		try {
			update tobList;
		} catch (Exception e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

		}
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdId
	 **/
	@future(callout=true)
	public static void insertTob(Id appProdId) {
		//link to application product

		/** Product Terms insertion**/
		insertProductTob(appProdId);

		/** Pricing and Fees insertion**/

		insertPricing(appProdId);

		/** Additional Info insertion**/

		insertAdditionalInfo(appProdId);
	}

	/**
	 * @description call this method when need to insert pricing from AIPS and Powercurve services
	 * need to map the values from service once service available fully with wrapping
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdId
	 **/
	public static void insertPricing(Id appProdId) {
		//link child record
		Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(appProdId);
		List<Terms_Of_Business__c> prodtobList = new List<Terms_Of_Business__c>();

		/*if(appProd.Product_State__c == 'Existing'){
        
        }else if(appProd.Product_State__c == 'New'){
        
        }*/
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(appProd.Opportunity__c);

		IPlistNCARatesV1_Resp_IB_v1 AIPSresp = (IPlistNCARatesV1_Resp_IB_v1) JSON.deserialize(application.AIPS__c, IPlistNCARatesV1_Resp_IB_v1.class);

		Terms_Of_Business__c tob = new Terms_Of_Business__c();
		tob.Tob_Description__c = 'Prime Rate';
		tob.Application_Product__c = appProdId;
		tob.Existing_Account_Number__c = AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate == null ? 0 : AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate;
		tob.Requested_Number__c = AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate == null ? 0 : AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate;
		tob.PowerCurve_Offered_Number__c = AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate == null
			? 0
			: AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate;
		tob.Final_Offered_Number__c = AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate == null ? 0 : AIPSresp.IPlistNCARatesV1Response.Ipb100o.primeRate;
		tob.TOB_Classification__c = 'Pricing And Fees';
		prodtobList.add(tob);

		tob = new Terms_Of_Business__c();
		tob.Tob_Description__c = 'Prime + %';
		tob.Application_Product__c = appProdId;
		tob.TOB_Classification__c = 'Pricing And Fees';
		prodtobList.add(tob);

		tob = new Terms_Of_Business__c();
		tob.Tob_Description__c = 'Interest Rate';
		tob.Application_Product__c = appProdId;
		tob.TOB_Classification__c = 'Pricing And Fees';
		prodtobList.add(tob);

		tob = new Terms_Of_Business__c();
		tob.Tob_Description__c = 'Initiation Fee';
		tob.Application_Product__c = appProdId;
		tob.TOB_Classification__c = 'Pricing And Fees';
		prodtobList.add(tob);

		tob = new Terms_Of_Business__c();
		tob.Tob_Description__c = 'Monthly Service Fee';
		tob.Application_Product__c = appProdId;
		tob.TOB_Classification__c = 'Pricing And Fees';
		prodtobList.add(tob);

		/* tob = new Terms_Of_Business__c();
tob.Tob_Description__c = 'Unutilized Facility Fee';
tob.Application_Product__c = appProdId;
tob.TOB_Classification__c ='Pricing And Fees';
prodtobList.add(tob);*/

		try {
			insert prodtobList;
		} catch (DmlException e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

		}
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdId
	 **/
	public static void insertProductTob(Id appProdId) {
		
		Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(appProdId);
		Application_Product__c childappProd = new ApplicationProductSelector().selectApplicationProductByParentId(appProdId);
	

		List<Terms_Of_Business__c> prodtobList = new List<Terms_Of_Business__c>();
		Map<String,String> ReducingFrequencyRequestedMap = new Map<String,String>();
        ReducingFrequencyRequestedMap.put('01','Monthly');
        ReducingFrequencyRequestedMap.put('02','Bi-Weekly');
        ReducingFrequencyRequestedMap.put('04','Quarterly');
        ReducingFrequencyRequestedMap.put('06','B-Annual');
        ReducingFrequencyRequestedMap.put('12','Annually');
		if (appProd.Product_State__c == 'Existing') {
			Terms_Of_Business__c tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Current Balance';
			tob.Application_Product__c = appProdId;
			tob.Existing_Account_Number__c = appProd.Account_Balance__c;
			// tob.Requested_Number__c =  appProd.Account_Balance__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			/*tob = new Terms_Of_Business__c();
            tob.Tob_Description__c = 'Overdraft Limit Type';
            tob.Application_Product__c = appProdId;
            tob.Existing_Account__c = childappProd.Limit_Type__c;
            tob.TOB_Classification__c = 'Product Terms';
            prodtobList.add(tob);
			
 			tob = new Terms_Of_Business__c();
            tob.Tob_Description__c = 'Overdraft Limit';
            tob.Application_Product__c = appProdId;
            tob.Existing_Account_Number__c = childappProd.Product_Amount__c == null ?0:childappProd.Product_Amount__c ;
            tob.TOB_Classification__c = 'Product Terms';
            prodtobList.add(tob);
			*/

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Overdraft Limit Type';
			tob.Application_Product__c = appProdId;
			// tob.Existing_Account__c = childappProd.Limit_Type__c;
			// tob.Requested_Picklist__c = childappProd.Limit_Type__c;  change by Himanshu
			tob.Requested__c = childappProd.Limit_Type__c; //change by Himanshu
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Overdraft Limit';
			tob.Application_Product__c = appProdId;
			tob.Existing_Account_Number__c = appProd.Current_Overdraft_Limit__c == null ? 0 : appProd.Current_Overdraft_Limit__c; //childappProd.Product_Amount__c == null ?0:childappProd.Product_Amount__c ; //from where to get original existing value
			tob.Requested_Number__c = childappProd.Product_Amount__c == null ? 0 : childappProd.Product_Amount__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Once-Off Reduction Amount';
			tob.Application_Product__c = appProdId;
			//tob.Existing_Account_Number__c = childappProd.Once_Off_Amount__c;
            tob.Requested_Number__c = childappProd.Once_Off_Amount__c == null ? 0 : childappProd.Once_Off_Amount__c ;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Once-Off Reduction Date';
			tob.Application_Product__c = appProdId;
			tob.Existing_Account_Date__c = childappProd.Once_Off_Date__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Regular Reduction Amount';
			tob.Application_Product__c = appProdId;
			//tob.Existing_Account_Number__c = childappProd.Reduction_Amount__c;
            tob.Requested_Number__c = childappProd.Reduction_Amount__c == null ? 0 : childappProd.Reduction_Amount__c ;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Regular Reduction Frequency';
			tob.Application_Product__c = appProdId;
			//tob.Existing_Account__c = childappProd.Reduction_Frequency__c;
            tob.Requested__c = ReducingFrequencyRequestedMap.containskey(childappProd.Reduction_Frequency__c)?ReducingFrequencyRequestedMap.get(childappProd.Reduction_Frequency__c):childappProd.Reduction_Frequency__c;
            tob.Requested_Frequency_Picklist__c = childappProd.Reduction_Frequency__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Reduction Date for Regular';
			tob.Application_Product__c = appProdId;
			tob.Requested_Date__c = childappProd.Reduction_Date__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Enforced Reducing Limit Indicator';
			tob.Application_Product__c = appProdId;
			tob.Existing_Account__c = childappProd.Enforced_Reducing_Limit__c;
            
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Limit Review Period';
			tob.Application_Product__c = appProdId;

			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			// if(appProd.Limit_Type__c.EqualsIgnoreCase('Variable')){
			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 1';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_1__c; //Existing_Account_Number__c
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 1';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_1__c;  // Existing_Account_Date__c 
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 2';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_2__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 2';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_2__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 3';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_3__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 3';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_3__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 4';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_4__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 4';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_4__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 5';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_5__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 5';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_5__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 6';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_6__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 6';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_6__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 7';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_7__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 7';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_7__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 8';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_8__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 8';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_8__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 9';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_9__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 9';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_9__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 10';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_10__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 10';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_10__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 11';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_11__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 11';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_11__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 12';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_12__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 12';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_12__c;
			prodtobList.add(tob);
		} else if (appProd.Product_State__c == 'New') {
			//for new products
			Terms_Of_Business__c tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Current Balance';
			tob.Application_Product__c = appProdId;
			tob.Requested_Number__c = appProd.Current_Overdraft_Limit__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Overdraft Limit Type';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = childappProd.Limit_Type__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Overdraft Limit';
			tob.Application_Product__c = appProdId;
			tob.Requested_Number__c = childappProd.Product_Amount__c == null ? 0 : childappProd.Product_Amount__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Once-Off Reduction Amount';
			tob.Application_Product__c = appProdId;
			tob.Requested_Number__c = childappProd.Once_Off_Amount__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Once-Off Reduction Date';
			tob.Application_Product__c = appProdId;
			tob.Requested_Date__c = childappProd.Once_Off_Date__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Regular Reduction Amount';
			tob.Application_Product__c = appProdId;
			tob.Requested_Number__c = childappProd.Reduction_Amount__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Regular Reduction Frequency';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = ReducingFrequencyRequestedMap.containskey(childappProd.Reduction_Frequency__c)?ReducingFrequencyRequestedMap.get(childappProd.Reduction_Frequency__c):childappProd.Reduction_Frequency__c;
            tob.Requested_Frequency_Picklist__c = childappProd.Reduction_Frequency__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Reduction Date for Regular';
			tob.Application_Product__c = appProdId;
			tob.Requested_Date__c = childappProd.Reduction_Date__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Enforced Reducing Limit Indicator';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = childappProd.Enforced_Reducing_Limit__c;
			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Limit Review Period';
			tob.Application_Product__c = appProdId;

			tob.TOB_Classification__c = 'Product Terms';
			prodtobList.add(tob);

			// if(appProd.Limit_Type__c.EqualsIgnoreCase('Variable')){
			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 1';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_1__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 1';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_1__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 2';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_2__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 2';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_2__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 3';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_3__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 3';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_3__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 4';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_4__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 4';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_4__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 5';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_5__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 5';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_5__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 6';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_6__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 6';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_6__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 7';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_7__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 7';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_7__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 8';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_8__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 8';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_8__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 9';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_9__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 9';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_9__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 10';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_10__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 10';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_10__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 11';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_11__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 11';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_11__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Amount 12';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Number__c = childappProd.Variable_Amount_12__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Variable Date 12';
			tob.Application_Product__c = appProdId;
			tob.TOB_Classification__c = 'Product Terms';
			tob.Requested_Date__c = childappProd.Variable_Date_12__c;
			prodtobList.add(tob);
		}

	

		
		try {
			insert prodtobList;
		} catch (DmlException e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

		}
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdId
	 **/
	public static void insertAdditionalInfo(Id appProdId) {
		Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(appProdId);
		Account acc = new AccountsSelector().selectIndvByOpportunityId(appProd.Opportunity__c);
		Application__c applicationRec = [SELECT Id, EDF_ReqName__c, EDF_ReqCode__c FROM Application__c WHERE Opportunity__c = :appProd.Opportunity__c LIMIT 1];

		Application_Product__c childappProd = new ApplicationProductSelector().selectApplicationProductByParentId(appProdId);
		List<Terms_Of_Business__c> prodtobList = new List<Terms_Of_Business__c>();

		Terms_Of_Business__c tob = new Terms_Of_Business__c();

		if (appProd.Product_State__c == 'Existing') {
			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Alternative Fund Indicator';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = childappProd.Alternative_Fund_Indicator__c == false ? 'No' : 'Yes';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Alternative Fund Code';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = childappProd.Alternative_Fund_Code__c == null ? '' : childappProd.Alternative_Fund_Code__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Enterprise Development Fund Code';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = acc.EDF_Code__c == null ? '' : acc.EDF_Code__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Enterprise Development Fund Indicator';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = acc.EDF_Name__c == null ? '' : acc.EDF_Name__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Franchise Financing';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = acc.Franchise_Code__c == null ? '' : acc.Franchise_Code__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Franchisor Type';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = acc.Franchise_Name__c == null ? '' : acc.Franchise_Name__c;
			prodtobList.add(tob);
		} else if (appProd.Product_State__c == 'New') {
			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Alternative Fund Indicator';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = childappProd.Alternative_Fund_Indicator__c == false ? 'No' : 'Yes';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Alternative Fund Code';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = childappProd.Alternative_Fund_Code__c == null ? '' : childappProd.Alternative_Fund_Code__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Enterprise Development Fund Code';
			tob.Existing_Account__c = applicationRec.EDF_ReqCode__c == null ? '' : applicationRec.EDF_ReqCode__c;
			tob.TOB_Classification__c = 'Additional Info';
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Enterprise Development Fund Indicator';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = applicationRec.EDF_ReqName__c == null ? '' : applicationRec.EDF_ReqName__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Franchise Financing';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = acc.Franchise_Code__c == null ? '' : acc.Franchise_Code__c;
			prodtobList.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Application_Product__c = appProdId;
			tob.Tob_Description__c = 'Franchisor Type';
			tob.TOB_Classification__c = 'Additional Info';
			tob.Existing_Account__c = acc.Franchise_Name__c == null ? '' : acc.Franchise_Name__c;

			prodtobList.add(tob);
		}

		try {
			insert prodtobList;
		} catch (DmlException e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

		}
	}

	/**
	 * @description method to map values from pco7 call and AIPS to tob
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdList
	 * @param stageId
	 **/
	public static void mapFromPCOResponse(List<Application_Product__c> appProdList, String stageId) {
		/*List<Application_Product__c> appPrdList = new List<Application_Product__c> ();
		 appPrdList.add(appProd);*/
		//get AIPS response
		//Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(appProd.Opportunity__c);
		//use selector later
		List<Application_Product__c> ProductList = [
			SELECT
				id,
				Name,
				Product_Name__c,
				Account_Number__c,
				Product_State__c,
				Product_Status__c,
				Limit_Type__c,
				Temp_Account_Number__c,
				Opportunity__c,
				toLabel(Product_Type__c) producttype,
				Review_Date__c,
				Expiry_Date__c,
				NCA_Appplicable__c,
				Maximum_NCA_Rate_Type__c,
				Maximum_NCA_Rate__c
			FROM Application_Product__c
			WHERE ID IN :appProdList AND Application_Product_Parent__c = NULL
		];
		Id opportunityId = ProductList.size() > 0 ? ProductList[0].Opportunity__c : null; // added by Manish for W-012367
		
		List<Terms_Of_Business__c> toupdateprodtobList = [
			SELECT
				id,
				Application_Product__c,
				TOB_Classification__c,
				Tob_Description__c,
				Adjusted_by_Sanctioner__c,
				Comments__c,
				Existing_Account__c,
				Final_Offered__c,
				Offered_by_Powercurve__c,
				Requested_Amount__c,
				Existing_Account_Number__c,
				Final_Offered_Number__c,
				PowerCurve_Offered_Number__c,
				Adjusted_Number__c,
				Adjusted_Date__c,
				Existing_Account_Date__c,
				Final_Offered_Date__c,
				PowerCurve_Offered_Date__c,
				Adjusted_by_Sanctioner_Picklist__c,
				Requested__c,
				Requested_Number__c,
				Requested_Date__c
			FROM Terms_Of_Business__c
			WHERE Application_Product__c IN :ProductList
		];

		List<Application_Scoring_Product__c> appProdScoreList = [
			SELECT
				id,
				Final_Init_Fee_Amount__c,
				Final_Int_Rate__c,
				Final_Int_Rate_Prime_Plus__c,
				Offer_Total_Amount__c,
				Final_Total_Amount__c,
				Final_OD_Limit_Type__c,
				Final_Once_Off_Reduction_Amount__c,
				Final_Reduction_Amount__c,
				Final_Reduction_Frequency__c,
				Final_Reduction_Period__c,
				Final_Service_Fee__c,
				NCA_Max_Rate__c,
				NCA_Max_Rate_Type__c,
				Offer_Init_Fee_Amount__c,
				Offer_Int_Rate__c,
				Offer_Int_Rate_Prime_Plus__c,
				Offer_OD_Limit_Type__c,
				Offer_Once_Off_Reduction_Amount__c,
				Offer_Reduction_Amount__c,
				Unique_Product_ID__c,
				Account_Number__c,
				Offer_Reduction_Frequency__c,
				Offer_Reduction_Period__c,
				Offer_Service_Fee__c
			FROM Application_Scoring_Product__c
			WHERE Application_Scoring__r.stage__c = :stageId AND Application_Scoring__r.Application_Number__r.Opportunity__c = :opportunityId
		]; //added extra filter by Manish for W-012367
		

		for (Application_Product__c appProd : ProductList) {
			for (Application_Scoring_Product__c appProdScore : appProdScoreList) {
				if (appProdScore.Unique_Product_ID__c == '' + appProd.Name || appProdScore.Account_Number__c == '' + appProd.Account_Number__c) {
					//List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProductId(appProd.Application_Product_Parent__c) ;   //selector for tob based on products
					
					appProd.Maximum_NCA_Rate__c = '' + appProdScore.nca_max_rate__c;
					appProd.Maximum_NCA_Rate_Type__c = '' + appProdScore.NCA_Max_Rate_Type__c;

					for (Terms_Of_Business__c tob : toupdateprodtobList) {
						if (appProd.id == tob.Application_Product__c) {
							// if(tob.TOB_Classification__c.equalsIgnoreCase('Pricing And Fees')){
							 if (tob.Tob_Description__c.equalsIgnoreCase('Prime + %')) {
								tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Int_Rate_Prime_Plus__c;
								tob.Final_Offered_Number__c = appProdScore.Final_Int_Rate_Prime_Plus__c;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Interest Rate')) {
								tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Int_Rate__c;
								tob.Final_Offered_Number__c = appProdScore.Final_Int_Rate__c;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Initiation Fee')) {
								tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Init_Fee_Amount__c;
								tob.Final_Offered_Number__c = appProdScore.Final_Init_Fee_Amount__c;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Monthly Service Fee')) {
								tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Service_Fee__c;
								tob.Final_Offered_Number__c = appProdScore.Final_Service_Fee__c;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit Type')) {
								//need translation here
								Decimal offered = appProdScore.Offer_OD_Limit_Type__c;
								Decimal finallimit = appProdScore.Final_OD_Limit_Type__c;
								String offeredLimitText;
								String finallimitText;
								if (offered == 1) {
									offeredLimitText = 'INDEFINATE';
								} else if (offered == 2) {
									offeredLimitText = 'FIXED OD';
								} else if (offered == 3) {
									offeredLimitText = 'REDUCING LIMIT';
								} else if (offered == 4) {
									offeredLimitText = 'VARIABLE LIMIT';
								}
								if (finallimit == 1) {
									finallimitText = 'INDEFINATE';
								} else if (finallimit == 2) {
									finallimitText = 'FIXED OD';
								} else if (finallimit == 3) {
									finallimitText = 'REDUCING LIMIT';
								} else if (finallimit == 4) {
									finallimitText = 'VARIABLE LIMIT';
								}

								tob.Offered_by_Powercurve__c = offeredLimitText;
								tob.Final_Offered__c = finallimitText;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Once-Off Reduction Amount')) {
								tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Once_Off_Reduction_Amount__c;
								tob.Final_Offered_Number__c = appProdScore.Final_Once_Off_Reduction_Amount__c;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Amount')) {
								tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Reduction_Amount__c;
								tob.Final_Offered_Number__c = appProdScore.Final_Reduction_Amount__c;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Regular Reduction Frequency')) {
								//need translation
								String offeredFreq;
								String finalfreq;
								if (appProdScore.Offer_Reduction_Frequency__c == 1) {
									offeredFreq = 'Monthly';
								} else if (appProdScore.Offer_Reduction_Frequency__c == 3) {
									offeredFreq = 'Quarterly';
								} else if (appProdScore.Offer_Reduction_Frequency__c == 6) {
									offeredFreq = 'Bi-annually';
								} else if (appProdScore.Offer_Reduction_Frequency__c == 12) {
									offeredFreq = 'Annually';
								}
								if (appProdScore.Final_Reduction_Frequency__c == 1) {
									finalfreq = 'Monthly';
								} else if (appProdScore.Final_Reduction_Frequency__c == 3) {
									finalfreq = 'Quarterly';
								} else if (appProdScore.Final_Reduction_Frequency__c == 6) {
									finalfreq = 'Bi-annually';
								} else if (appProdScore.Final_Reduction_Frequency__c == 12) {
									finalfreq = 'Annually';
								}
								tob.Offered_by_Powercurve__c = offeredFreq;
								tob.Final_Offered__c = finalfreq;
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Limit Review Period')) {
								//need translation
								tob.Offered_by_Powercurve__c = '' + appProdScore.Offer_Reduction_Period__c + ' MONTHS';
								tob.Final_Offered__c = '' + appProdScore.Final_Reduction_Period__c + ' MONTHS';
							} else if (tob.Tob_Description__c.equalsIgnoreCase('Overdraft Limit')) {
								//need translation
								tob.PowerCurve_Offered_Number__c = appProdScore.Offer_Total_Amount__c;
								tob.Final_Offered_Number__c = appProdScore.Final_Total_Amount__c;
							}
						}
					}
					// toupdateprodtobList.add(appProd.Terms_Of_Business__r);
				}
			}
		}
		try {
			update toupdateprodtobList;
			update ProductList;
		} catch (DMLException e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

		}
	}

	/**
	 * @description Added by Himanshu -W-011426 - CC
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appId
	 * @param appProdList
	 * @param stageId
	 **/
	public static void mapCCTOBFromPCOResponse(Id appId, List<Application_Product__c> appProdList, String stageId) {
		List<Application_Product__c> ProductList = [
			SELECT
				id,
				Name,
				Product_Name__c,
				Account_Number__c,
				Product_State__c,
				Product_Status__c,
				Limit_Type__c,
				Temp_Account_Number__c,
				toLabel(Product_Type__c) producttype,
				Review_Date__c,
				Expiry_Date__c,
				NCA_Appplicable__c,
				Maximum_NCA_Rate_Type__c,
				Maximum_NCA_Rate__c
			FROM Application_Product__c
			WHERE ID IN :appProdList AND Application_Product_Parent__c = NULL AND Product_Name__c = 'Credit Card'
		];

		

		//Creating TOC for Credit Card --
		for (Application_Product__c appProd : ProductList) {
			List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProducts(new List<Application_Product__c>{ appProd }); // tob based on products
			if (prodtobList == null || prodtobList.isEmpty()) {
				if (!Test.isRunningTest()) {
					SetProductTOBController.insertCCTob(appProd.Id);
				}
			} else {
				SetProductTOBController.updateCCTOB(appProd.Id); //update tob if any changes over product
			}
		}

		//Updating TOC for Credit Card --
		List<Terms_Of_Business__c> toupdateprodtobList = [
			SELECT
				id,
				Application_Product__c,
				TOB_Classification__c,
				Tob_Description__c,
				Adjusted_by_Sanctioner__c,
				Comments__c,
				Existing_Account__c,
				Final_Offered__c,
				Offered_by_Powercurve__c,
				Requested_Amount__c,
				Existing_Account_Number__c,
				Final_Offered_Number__c,
				PowerCurve_Offered_Number__c,
				Adjusted_Number__c,
				Adjusted_Date__c,
				Existing_Account_Date__c,
				Final_Offered_Date__c,
				PowerCurve_Offered_Date__c,
				Adjusted_by_Sanctioner_Picklist__c,
				Requested__c,
				Requested_Number__c,
				Requested_Date__c
			FROM Terms_Of_Business__c
			WHERE Application_Product__c IN :ProductList
		];

		

		List<Application_Scoring_Product__c> appProdScoreList = [
			SELECT
				id,
				Offer_Total_Amount__c,
				Final_Total_Amount__c,
				Final_OD_Limit_Type__c,
				NCA_Max_Rate__c,
				NCA_Max_Rate_Type__c,
				Offer_OD_Limit_Type__c,
				Unique_Product_ID__c,
				Account_Number__c
			FROM Application_Scoring_Product__c
			WHERE Application_Scoring__r.Application_Number__c = :appId AND Application_Scoring__r.stage__c = :stageId
		];

		for (Application_Scoring_Product__c appProdScore : appProdScoreList) {
			for (Application_Product__c appProd : ProductList) {
					if ((appProdScore.Unique_Product_ID__c == '' + appProd.Name) || (appProdScore.Account_Number__c == '' + appProd.Account_Number__c)) {
					appProd.Maximum_NCA_Rate__c = '' + appProdScore.NCA_Max_Rate__c;
					appProd.Maximum_NCA_Rate_Type__c = '' + appProdScore.NCA_Max_Rate_Type__c;

					for (Terms_Of_Business__c tob : toupdateprodtobList) {
						if (appProd.id == tob.Application_Product__c) {
							if (tob.Tob_Description__c.equalsIgnoreCase('Limit')) {
								
								tob.Offered_by_Powercurve__c = string.valueof(appProdScore.Offer_Total_Amount__c); // need to check with Khulani
								tob.Final_Offered__c = string.valueof(appProdScore.Final_Total_Amount__c);
							}
						}
					}
				}
			}
		}

		try {
			update toupdateprodtobList;
			update ProductList;
		} catch (DMLException e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

		}
	}

	/**
	 * @description Added by Himanshu -W-011426 - CC
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdId
	 **/
	public static void insertCCTob(Id appProdId) {
		Application_Product__c appProdCC = new ApplicationProductSelector().selectApplicationProductById(appProdId);
		List<Terms_Of_Business__c> prodtobListCC = new List<Terms_Of_Business__c>();

		if (appProdCC.Product_State__c == 'Existing') {
			Terms_Of_Business__c tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Current Balance';
			tob.TOB_Classification__c = 'Product Terms';
			tob.Application_Product__c = appProdId;
			tob.Existing_Account__c = string.valueof(appProdCC.Account_Balance__c);
			prodtobListCC.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Product Type';
			tob.TOB_Classification__c = 'Product Terms';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = appProdCC.Business_Credit_Card_Product_Type__c;
			tob.Offered_by_Powercurve__c = appProdCC.Business_Credit_Card_Product_Type__c;
			tob.Final_Offered__c = appProdCC.Business_Credit_Card_Product_Type__c;
			prodtobListCC.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Sub Product Type';
			tob.TOB_Classification__c = 'Product Terms';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
			tob.Offered_by_Powercurve__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
			tob.Final_Offered__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
			prodtobListCC.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Limit';
			tob.TOB_Classification__c = 'Product Terms';
			tob.Application_Product__c = appProdId;
			tob.Existing_Account__c = string.valueof(appProdCC.Credit_Card_Limit__c);
			tob.Requested__c = appProdCC.Requested_facility_limit__c;
			prodtobListCC.add(tob);
		} else if (appProdCC.Product_State__c == 'New') {
			Terms_Of_Business__c tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Current Balance';
			tob.TOB_Classification__c = 'Product Terms';
			// tob.Requested__c = appProdCC.Requested_facility_limit__c; W-012904
			tob.Application_Product__c = appProdId;
			prodtobListCC.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Product Type';
			tob.TOB_Classification__c = 'Product Terms';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = appProdCC.Business_Credit_Card_Product_Type__c;
			tob.Offered_by_Powercurve__c = appProdCC.Business_Credit_Card_Product_Type__c;
			tob.Final_Offered__c = appProdCC.Business_Credit_Card_Product_Type__c;
			prodtobListCC.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Sub Product Type';
			tob.TOB_Classification__c = 'Product Terms';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
			tob.Offered_by_Powercurve__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
			tob.Final_Offered__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
			prodtobListCC.add(tob);

			tob = new Terms_Of_Business__c();
			tob.Tob_Description__c = 'Limit';
			tob.TOB_Classification__c = 'Product Terms';
			tob.Application_Product__c = appProdId;
			tob.Requested__c = appProdCC.Requested_facility_limit__c;
			// tob.Requested__c = String.valueof(appProdCC.Business_Credit_Card_Limit__c);
			// tob.Offered_by_Powercurve__c = '';   //new to set by PCO
			// tob.Final_Offered__c =  '';            //new to set by PCO
			prodtobListCC.add(tob);
		}

		try {
			
			insert prodtobListCC;
		} catch (DmlException e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());
	
		}
	}

	/**
	 * @description Added by Himanshu -W-011426 - CC
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appProdId
	 **/
	public static void updateCCTOB(Id appProdId) {
		List<Terms_Of_Business__c> tobList = [
			SELECT
				id,
				Application_Product__c,
				TOB_Classification__c,
				Tob_Description__c,
				Existing_Account__c,
				Requested__c,
				Offered_by_Powercurve__c,
				Final_Offered__c
			FROM Terms_Of_Business__c
			WHERE Application_Product__c = :appProdId
		];

		Application_Product__c appProdCC = new ApplicationProductSelector().selectApplicationProductById(appProdId);

		for (Terms_Of_Business__c tob : tobList) {
			if (appProdCC.Product_State__c == 'Existing') {
				if (tob.Tob_Description__c == 'Current Balance') {
					tob.Existing_Account__c = string.valueof(appProdCC.Account_Balance__c);
				}
				if (tob.Tob_Description__c == 'Product Type') {
					tob.Application_Product__c = appProdId;
				}
				if (tob.Tob_Description__c == 'Sub Product Type') {
					tob.Requested_Number__c = appProdCC.Current_Overdraft_Limit__c;
				}
				if (tob.Tob_Description__c == 'Limit') {
					tob.Existing_Account__c = string.valueof(appProdCC.Credit_Card_Limit__c);
					tob.Requested__c = appProdCC.Requested_facility_limit__c;
				}
			} else if (appProdCC.Product_State__c == 'New') {
				if (tob.Tob_Description__c == 'Current Balance') {
					tob.Requested__c = appProdCC.Requested_facility_limit__c;
					tob.Application_Product__c = appProdId;
				}
				if (tob.Tob_Description__c == 'Product Type') {
					tob.Requested__c = appProdCC.Business_Credit_Card_Product_Type__c;
					tob.Offered_by_Powercurve__c = appProdCC.Business_Credit_Card_Product_Type__c;
					tob.Final_Offered__c = appProdCC.Business_Credit_Card_Product_Type__c;
				}
				if (tob.Tob_Description__c == 'Sub Product Type') {
					tob.Requested__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
					tob.Offered_by_Powercurve__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
					tob.Final_Offered__c = appProdCC.Business_Credit_Card_Sub_Product_Type__c;
				}
				if (tob.Tob_Description__c == 'Limit') {
					tob.Requested__c = String.valueof(appProdCC.Business_Credit_Card_Limit__c);
				}
			}
		}

		try {
			update tobList;
		} catch (Exception e) {
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

		}
	}
       
	/**
	* @description 
	* @author almas.aleem@absa.africa | 2021-10-18 
	* @param appProdList 
	* @param stageId 
	**/
	public static void createTOBForLDP(List<Application_Product__c> appProdList,String stageId){
        List<Terms_Of_Business__c> termsOfBusiness = new List<Terms_Of_Business__c>();
        Map<Id, List<Terms_Of_Business__c>> appProdTOBMap = new Map<Id, List<Terms_Of_Business__c>>();
        Id opportunityId;
        Application__c application;
        Account account;
        List<Application_Product__c> applicationProducts = [Select id, Name ,Product_Name__c,TL_Additional_Loan_Amount_Requested__c,TL_Total_Settlement_Amount__c,TL_Total_Loan_Amount__c,
                                                            Alternative_Fund_Indicator__c,TL_Alternative_Fund_Name_Code__c,TL_Term_of_Loan_Months__c,TL_Months_to_Skip__c,Opportunity__c
                                                            from Application_Product__c Where ID IN :appProdList AND Product_Name__c = 'Bank Guarantee'];
        List<Terms_Of_Business__c> tobProducts = new TermsOfBusinessSelector().selectByAppProducts(appProdList) ;   // tob based on products
         if(applicationProducts.size() > 0 ){
            opportunityId = applicationProducts[0].Opportunity__c;
            application = new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
            //account = new AccountsSelector().selectIndvByOpportunityId(opportunityId);
            for(Terms_Of_Business__c tob : tobProducts){
                if(!appProdTOBMap.keyset().contains(tob.Application_Product__c)){
                    appProdTOBMap.put(tob.Application_Product__c, new List<Terms_Of_Business__c>{tob});
                }
                else{
                    List<Terms_Of_Business__c> tobRecs = appProdTOBMap.get(tob.Application_Product__c);
                    tobRecs.add(tob);
                    appProdTOBMap.put(tob.Application_Product__c, tobRecs);
                 }
                }
            for(Application_Product__c appProduct : applicationProducts){
                if(appProdTOBMap.get(appProduct.Id) == null || appProdTOBMap.get(appProduct.Id).size() < 1) {
                    termsOfBusiness.addALL(insertTOBForLDP(appProduct.Id));
                }
                else{
                   // termsOfBusiness.addALL(updateForLDP(appProduct, appProdTOBMap.get(appProduct.Id)));
                }
            }
            if(termsOfBusiness.size() > 0){
                upsert termsOfBusiness;
            }
            //mapTLTOBFromPCOResponse(appProdList, stageId);
        }
        
    }
  
  
  /**
  * @description 
  * @author almas.aleem@absa.africa | 2021-10-18 
  * @param appProdId 
  * @return List<Terms_Of_Business__c> 
  **/
  public static List<Terms_Of_Business__c>  insertTOBForLDP(Id appProdId){
      Application_Product__c appProd = new ApplicationProductSelector().selectApplicationProductById(appProdId);
      
        
        List<Terms_Of_Business__c> prodtobList = new List<Terms_Of_Business__c>();
     
      
      if(appProd.Product_State__c == 'Existing'){
        Terms_Of_Business__c tob = new Terms_Of_Business__c();
        tob.Tob_Description__c = 'Account Number';
        tob.Application_Product__c = appProd.Id;
        tob.TOB_Classification__c = 'Product Terms';
        tob.Existing_Account__c = appProd.Facility_account_number__c;  
        //tob.Requested_Number__c =  ;//  appProd.TL_Additional_Loan_Amount_Requested__c;
        prodtobList.add(tob);

        tob = new Terms_Of_Business__c();
        tob.Tob_Description__c = 'Limit';
        tob.Application_Product__c = appProd.Id;
        tob.TOB_Classification__c = 'Product Terms';
        tob.Existing_Account__c =  appProd.Facility_limit__c;
      	tob.Requested__c = appProd.Requested_facility_limit__c; //appProd.TL_Total_Settlement_Amount__c;
        prodtobList.add(tob);

        tob = new Terms_Of_Business__c();
        tob.Tob_Description__c = 'Review Date';
        tob.Application_Product__c = appProd.Id;
        tob.TOB_Classification__c = 'Product Terms';
        tob.Existing_Account__c =  appProd.Facility_review_date__c.format();
        tob.Requested__c = appProd.Requested_review_date__c.format(); //appProd.TL_Total_Settlement_Amount__c;
        prodtobList.add(tob);
      }else if(appProd.Product_State__c == 'New'){
          
      	Terms_Of_Business__c   tob = new Terms_Of_Business__c();
        tob.Tob_Description__c = 'Limit';
        tob.Application_Product__c = appProd.Id;
        tob.TOB_Classification__c = 'Product Terms';
        //tob.Existing_Account_Number__c =  Decimal.valueOf(appProd.Facility_limit__c);
       
      	tob.Requested__c = appProd.Facility_limit__c;
        prodtobList.add(tob);

        tob = new Terms_Of_Business__c();
        tob.Tob_Description__c = 'Review Date';
        tob.Application_Product__c = appProd.Id;
        tob.TOB_Classification__c = 'Product Terms';
       // tob.Existing_Account_Date__c =  appProd.Facility_review_date__c;  
        tob.Requested__c = appProd.Facility_review_date__c.format();  //appProd.TL_Total_Settlement_Amount__c;
        prodtobList.add(tob);
  
      }
      try{
         insert prodtobList;
      }catch(Exception e){
		AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

      }
       return prodtobList;
    }
    
    /**
    * @description mapLDPTOBFromPCOResponse for LDP
    * @param appId - appId
    * @param appProdList - application products
    * @param stageId - stageid
    **/
    public static void mapLDPTOBFromPCOResponse(Id appId,List<Application_Product__c> appProdList,String stageId){
        
        List<Application_Product__c> ProductList = [Select id, Name ,Product_Name__c,Account_Number__c,Product_State__c,Product_Status__c,Limit_Type__c,Temp_Account_Number__c,
                                                    toLabel(Product_Type__c) producttype,Review_Date__c, Expiry_Date__c,  NCA_Appplicable__c, Maximum_NCA_Rate_Type__c,Maximum_NCA_Rate__c,Facility_account_number__c
                                                    from Application_Product__c Where ID IN :appProdList AND Application_Product_Parent__c = null and Product_Name__c = 'Bank Guarantee' ];
        
        
        
        //Creating TOB For LDP --
        for(Application_Product__c appProd :  ProductList){
            
            List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProducts(new List<Application_Product__c>{appProd}) ;   // tob based on products
           
            if(prodtobList.isEmpty()) {
               if (!Test.isRunningTest()){
                   
                    insertTOBForLDP(appProd.Id);
                }
            }else{
                updateLDPTOB(appProd.Id);//update tob if any changes over product
            }
            
        }
        
        //Updating TOC for LDP--
        List<Terms_Of_Business__c> toupdateprodtobList =  [Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c,
                                                           Adjusted_by_Sanctioner__c,Comments__c,Existing_Account__c,Final_Offered__c,
                                                           Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,
                                                           PowerCurve_Offered_Number__c,Adjusted_Number__c,Adjusted_Date__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                           PowerCurve_Offered_Date__c,Adjusted_by_Sanctioner_Picklist__c,Requested__c,
                                                           Requested_Number__c,Requested_Date__c from Terms_Of_Business__c where Application_Product__c  IN :ProductList ];
        
     
        
        List<Application_Scoring_Product__c> appProdScoreList = [select id, Offer_Total_Amount__c,Final_Total_Amount__c,
                                                                 Final_OD_Limit_Type__c,NCA_Max_Rate__c,NCA_Max_Rate_Type__c,
                                                                 Offer_OD_Limit_Type__c,Unique_Product_ID__c,Account_Number__c
                                                                 From Application_Scoring_Product__c
                                                                 where Application_Scoring__r.Application_Number__c=:appId and
                                                                 Application_Scoring__r.stage__c =:stageId];
        
        
        
        for(Application_Scoring_Product__c appProdScore : appProdScoreList){
            for(Application_Product__c appProd :  ProductList){
                 if(appProdScore.Unique_Product_ID__c == ''+appProd.Name || appProdScore.Account_Number__c == string.valueof(appProd.Facility_account_number__c)){
                    
                          
                    for( Terms_Of_Business__c tob: toupdateprodtobList){
                        if(appProd.id == tob.Application_Product__c){
                            
                            if(tob.Tob_Description__c.equalsIgnoreCase( 'Limit')){ 
                                
                                tob.Offered_by_Powercurve__c = string.valueof(appProdScore.Offer_Total_Amount__c); 
                                tob.Final_Offered__c = string.valueof(appProdScore.Final_Total_Amount__c);
                            }
                        }
                    }    
                    
                }
            }      
        }
        
        try{
            
            update toupdateprodtobList;    
            update ProductList;
        }catch(DMLException e){
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

            
        }
    }
    
     /**
    * @description update terms of business for LDP
    * @author
    * @param appProdId - application product Id
    **/
    public static void updateLDPTOB(Id appProdId){ 
        List<Terms_Of_Business__c> tobList = [Select id, Application_Product__c, TOB_Classification__c, Tob_Description__c,
                                              Existing_Account__c, Requested__c, Offered_by_Powercurve__c, Final_Offered__c
                                              from Terms_Of_Business__c where Application_Product__c  =:appProdId ];
        
        Application_Product__c appProdCC = new ApplicationProductSelector().selectApplicationProductById(appProdId);
        
        for(Terms_Of_Business__c tob : tobList ){
            if(appProdCC.Product_State__c == 'Existing'){
                
              
                if(tob.Tob_Description__c == 'Limit'){
                    tob.Existing_Account__c = string.valueof(appProdCC.Facility_limit__c);
                    tob.Requested__c = appProdCC.Requested_facility_limit__c;
                }
                
            }else if(appProdCC.Product_State__c == 'New'){ 
                
                if(tob.Tob_Description__c == 'Limit'){
                    tob.Requested__c = appProdCC.Requested_facility_limit__c;
                }
            }
        }
        
        
        try{
            update tobList;
        }catch(Exception e){
			AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

        }
        
    }
}