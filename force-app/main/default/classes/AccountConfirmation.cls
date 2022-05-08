/** 
 * Controller class for the aura component AccountConfirmation.
 * Retrives accounts for a sepecfic CIF and sends a confirmation letter to teh client
 * 
 * @author Rudolf Niehaus
 * @since 2020-06-02
*/
public class AccountConfirmation {


    
    @AuraEnabled
    public static String getDocument(String accountId,String accNo, String templateName, string caseId , string branch , string accountType){
        Account accountRecord = new AccountsSelector().selectAllById(accountId);
        System.debug('accountRecord : ' + accountRecord);
        System.debug('templateName : ' + templateName);
		Map<String, String> result = new Map<String, String>();
        Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);
		DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		
        // this bit here is temporary so we have dates to populate while we try get ECM and Docfusion to work on dates - if send a null or unformatted date they throw error
			Datetime dt = Datetime.now();
			contextBuilder.add('today', String.valueOf(dt.year()) + '-' + String.valueOf(dt.month()) + '-' +  String.valueOf(dt.day()) + + 'T00:00:00');//dt.format('yyyy-mm-dd')+'T00:00:00'); //'2020-07-16T00:00:00');
			contextBuilder.add('showUSCitizens', false);
        	contextBuilder.add('acountType', getProductName(accountType));
        	contextBuilder.add('branchCode', branch);
        	contextBuilder.add('accNumber', accNo.substring(7, 17));
        	contextBuilder.add('accountOpenDate', String.valueOf(accountRecord.Client_Since_Date__c.year()) + '-' + String.valueOf(accountRecord.Client_Since_Date__c.month()) + '-' + String.valueOf(accountRecord.Client_Since_Date__c.day()));
        	contextBuilder.add('Account', accountRecord);
        
			// end dirty fix
			String req = contextBuilder.serialize(documentTemplate.XML__c);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			System.debug(req);
			System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
			Map<String, String> params = setECMParam(accountRecord, documentTemplate);
        
        System.debug('contextBuilder' +contextBuilder);           
        CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
        System.debug('serialise response ' + JSON.serialize(response));
			Document__c doc = new Document__c();
			doc.Name = documentTemplate.Name.left(75)+'.pdf';
			doc.Type__c = documentTemplate.Document_Type__c;
        	if (!Test.isRunningTest()){
            	doc.Reference__c = response.contentStoreToken;
				doc.Case__c = caseId;
				insert doc;
        	}
			
        
        return Null;
    }
    public static String getProductName(String value){
        if(value == 'CQ'){
            return 'Cheque';
        }else if(value == 'SA'){
            return 'Savings';
        }
        return null;
    }
    public static Map<String, String> setECMParam(Account acc, Document_Template__c template){
		Map<String, String> fields = new Map<String, String>();

		fields.put('CIFNr', acc.CIF__c == null ? '0' : acc.CIF__c);
		fields.put('IdNr', acc.Registration_Number__c == null ? '0' : acc.Registration_Number__c);
		fields.put('AcctNr', acc.AccountNumber == null ? '0' : acc.AccountNumber);
		fields.put('Origin', 'Salesforce B2C');
		fields.put('BusinessUnit', 'RBB');

		if (!Test.isRunningTest()){
			Map<String, String> credentials = ECM_IH_V1.getCredentials();
			fields.put('ECM_Account', credentials.get('username'));
			fields.put('ECM_Password', credentials.get('password'));
			fields.put('ECMItemType', template.ECM_Item_Type__c);
		}

		return fields;
	}   
}