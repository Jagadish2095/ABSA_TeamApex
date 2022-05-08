/**
 * @description       :
 * @author            : deepthi.narayanappa@absa.africa
 * @last modified on  : 2021-09-27
 * @last modified by  : deepthi.narayanappa@absa.africa
 **/
public class LookupSearchComponentController {
	/**
	 * @description getResults method
	 * @param ObjectName
	 * @param fieldName
	 * @param value
	 * @param campaign
	 * @return List<SObjectResult>
	 * */
	@AuraEnabled
	public static List<SObjectResult> getResults(String ObjectName, String fieldName, String value, String campaign) {
		List<SObJectResult> sObjectResultList = new List<SObJectResult>();
		String roles = 'WIMI-Distribution-Virtual Adviser%';
		String values = '%' + value + '%';
		if (ObjectName == 'User' && campaign == 'VA') {
			for (sObject so : [SELECT id, Name FROM user WHERE userrole.name LIKE :roles AND name LIKE :values]) {
				String fieldvalue = (String) so.get(fieldName);
				sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
			}
		} else {
			/* for(sObject so : Database.Query('Select Id,'+fieldName+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value + '%\'')) {
            String fieldvalue = (String)so.get(fieldName);
            sObjectResultList.add(new SObjectResult(fieldvalue, so.Id));
        	} */
		}
		return sObjectResultList;
	}

	/**
	 * @description SObJectResult
	 **/
	public class SObJectResult {
		@AuraEnabled
		public String recName;
		@AuraEnabled
		public Id recId;

		/**
		 * @description SObJectResult method
		 * @param recNameTemp
		 * @param recIdTemp
		 * */
		public SObJectResult(String recNameTemp, Id recIdTemp) {
			recName = recNameTemp;
			recId = recIdTemp;
		}
	}
}