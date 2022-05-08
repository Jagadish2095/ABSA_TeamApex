/**
 * @description       : 
 * @author            : Himani Joshi: Absa
 * @last modified on  : 2021-10-22
 * @last modified by  : almas.aleem@absa.africa
**/

public class BGProductApplicationController {
    /**
 * @description       : 
 * @author            : Himani Joshi: Absa
 * 
**/
    public class productWrapper {
        @auraEnabled public String appReference;
        @auraEnabled public String casaReference;
        @auraEnabled public date proddate;
        @auraEnabled public String clientRep1;
        @auraEnabled public String clientRep2;
        @auraEnabled public String capacity1;
        @auraEnabled public String capacity2;
        @auraEnabled public String guaranteeIssued;
        @auraEnabled public String termExtension;
        @auraEnabled public String cancellations;
        @auraEnabled public String amountIncrease;
        @auraEnabled public String amendments;
        @auraEnabled public String reIssueGuarantees;
        @auraEnabled public String claims;
        @auraEnabled public String waivedAmount;
        @auraEnabled public date   expiryDate;
        @auraEnabled public String expiryEvent;
        @auraEnabled public String contractNo;
        @auraEnabled public String debitAccNo;
        @auraEnabled public String guaranteeAmount;
        @auraEnabled public String escapeClause;
        @auraEnabled public String guaranteeIssued1;
        @auraEnabled public String goodsDescription;
        @auraEnabled public String interestRate;
        @auraEnabled public String guaranteeDate;
        @auraEnabled public String interestDate;
        @auraEnabled public String completedTransactions;
        @auraEnabled public String description;
        @auraEnabled public String calculateInterest;
        @auraEnabled public String propGuaranteeAmount;
        @auraEnabled public String guaranteeToDate;
        @auraEnabled public String bankFees;
        @auraEnabled public String writtenAdvice;
        @auraEnabled public String guaranteeType;
        @auraEnabled public String clientCode;
        @auraEnabled public String agreementCompletion;
        @auraEnabled public String sourceOfFunds;
        @auraEnabled public String explanation;
        @auraEnabled public String explanationComments;
        @auraEnabled public String clientCodeIncome;
        @auraEnabled public String sourceOfIncome;
        @auraEnabled public String emailAddress;
        @auraEnabled public String forAttentionOf;
        @auraEnabled public String approvedAmount;
        @auraEnabled public String authorisedBy;
        @auraEnabled public String signaturesVerified;
        @auraEnabled public String guaranteeCredit;
        @auraEnabled public String Amount;
        @auraEnabled public List<VariableWrapper> variablemap;
        @auraEnabled public List<VariableWrapper1> additionalFields;
        //Amendment Fields
        @auraEnabled public String busAddress;
        @auraEnabled public String appDate;
        @auraEnabled public String guaranteeNo;
        @auraEnabled public String guaranteeIssueDate;
        @auraEnabled public String guarAmount;
        @auraEnabled public String existingBeneficiary;
        @auraEnabled public String amendmentInstructions;
        @auraEnabled public String relatedBankCharges;
        @auraEnabled public String authorisedSignatory;
        @auraEnabled public String accountNumber;
        @auraEnabled public String accountType;
        @auraEnabled public String sourceOfFundsAmendment;
        @auraEnabled public String satisfactoryExplanation;
        @auraEnabled public String explanationCommentsAmendment;
        @auraEnabled public String clientCodeAmendment;
        @auraEnabled public String sourceOfIncomeAmendment;
        @auraEnabled public String sourceOfWealth;
        @auraEnabled public String firstName;
        @auraEnabled public String signatureEmpNo;
        @auraEnabled public String firstName1;
        @auraEnabled public String signatureEmpNo1;
    }
      /**
 * @description       : 
 * @author            : Himani Joshi: Absa
 * 
**/
    public class VariableWrapper{
        
        @auraEnabled public String beneficiaryName;
        @auraEnabled public String clearingCode;
        @auraEnabled public String addressLine1;
        @auraEnabled public String town;
        @auraEnabled public String country;
        @auraEnabled public String accountNo;
        @auraEnabled public String accountType;
        @auraEnabled public String suburb;
        @auraEnabled public String postalCode;
       
    }
      /**
 * @description       : 
 * @author            : Himani Joshi: Absa
 * 
**/
    public class VariableWrapper1{
        
        @auraEnabled public String minAmount;
        @auraEnabled public String establishmentAmount;
        @auraEnabled public String dueFeesSecondSixMonths;
        @auraEnabled public String dueFeesFirstSixMonths;
    }
    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    * @param oppId 
    * @param selectedValue 
    * @return productWrapper 
    **/
    @auraEnabled
    public static productWrapper generateProdWrapper(Id oppId,String selectedValue){
        Account acc=new accountsselector().selectIndvByOpportunityId(oppId);
        productWrapper wrapper=new productWrapper();
        
        List<Application_product__c>appProduct=[select Id,BGProductJson__c from Application_product__c where Product_Name__c='Bank Guarantee'and Opportunity_Product_Id__c=:oppId and Documents_Required__c=:selectedValue];
        if(appProduct.size()==0){
        
        
        Application_product__c app=new Application_product__c();
        app.Product_Name__c='Bank Guarantee';
        app.Opportunity_Product_Id__c=oppId;
        app.Documents_Required__c=selectedValue;
        insert app;
        wrapper.casaReference=acc.CASA_Reference_Number__c;      
        
        }
        
        else{
            if(appProduct.size()>0 && appProduct[0].BGProductJson__c!=null){
            wrapper = (productWrapper)JSON.deserialize(appProduct[0].BGProductJson__c, productWrapper.Class);
            }
        }

        return wrapper;
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    * @param oppId 
    * @param selectedValue 
    * @return Id 
    **/
    @auraEnabled
    public static Id returnProdId(Id oppId,String selectedValue){
        Application_product__c app=[select Id from Application_product__c where Product_Name__c='Bank Guarantee'and Opportunity_Product_Id__c=:oppId and Documents_Required__c=:selectedValue];
        return app.Id;
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    * @param prodWrap 
    * @param appProdId 
    **/
    @auraEnabled
    public static void saveBGProduct(String prodWrap,Id appProdId){
        productWrapper  prWrapper = (productWrapper)JSON.deserialize(prodWrap, productWrapper.Class);
        Application_product__c app=[select Id from Application_product__c where Id=:appProdId ];
        app.BGProductJson__c=prodWrap;
        update app;
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    * @param prodWrap 
    * @param newWitnesses 
    * @param appProdId 
    * @return productWrapper 
    **/
    @auraEnabled
    public static productWrapper addNewProduct(String prodWrap,Integer newWitnesses,Id appProdId){
        productWrapper  prWrapper = (productWrapper)JSON.deserialize(prodWrap, productWrapper.Class);
        
        List<VariableWrapper>variableWrapperList=new List<VariableWrapper>();
        VariableWrapper wrp=new VariableWrapper();
        wrp.beneficiaryName='';
        wrp.clearingCode='';
        wrp.addressLine1='';
        wrp.town='';
        wrp.country='';
        wrp.accountNo='';
        wrp.accountType='';
        wrp.suburb='';
        wrp.postalCode='';
        variableWrapperList.add(wrp);
        
        prWrapper.variablemap=variableWrapperList;
        return prWrapper;
        
    }
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-22 
    * @param prodWrap 
    * @param newWitnesses 
    * @param appProdId 
    * @return productWrapper 
    **/
    @auraEnabled
    public static productWrapper addAdditionalFields(String prodWrap,Integer newWitnesses,Id appProdId){
        productWrapper  prWrapper = (productWrapper)JSON.deserialize(prodWrap, productWrapper.Class);
        List<VariableWrapper1>variableWrapperList=new List<VariableWrapper1>();
        VariableWrapper1 wrp=new VariableWrapper1();
        wrp.minAmount='';
        wrp.establishmentAmount='';
        wrp.dueFeesSecondSixMonths='';
        wrp.dueFeesFirstSixMonths='';
        variableWrapperList.add(wrp);
        
        prWrapper.additionalFields=variableWrapperList;
        return prWrapper;
        
    }
    /*
    @auraEnabled
    public static String generate4012(Id oppId,Id appProdId) {
        DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new Document_Template__c();
        Application_Product__c appProdRec = new Application_Product__c();
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
        Account acc = new AccountsSelector().selectAllByIdFOrDocs(opp.AccountId);
        documentTemplate = new DocumentTemplateSelector().selectTemplateByName('ABSA 4012 - Application for the Issuance of a Local Guarantee');
        
        
            appProdRec = new ApplicationProductSelector().selectApplicationProductById(appProdId);
            if (appProdRec != null){
                productWrapper prWrapper = new productWrapper();
				system.debug('appProdRec.BGProductJson__c ' + appProdRec.BGProductJson__c);
				if (appProdRec.BGProductJson__c != '' && appProdRec.BGProductJson__c != null){
					prWrapper = (productWrapper) System.JSON.deserialize(appProdRec.BGProductJson__c, productWrapper.Class);
                    contextBuilder.add('productWrapper', prWrapper);
                    contextBuilder.add('variablemap', prWrapper.variablemap);
                    system.debug('variablemap'+prWrapper.variablemap);
                }
            }
            
         try{
			String req = contextBuilder.serialize(documentTemplate.XML__c);
			System.debug('req'+json.serializePretty(req));
			Map<String, String> params = GenerateDocument.setECMParam(acc, documentTemplate);
            CC_GenerateContentResponse response;
            if (!Test.isRunningTest()) {
                response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
                system.debug('response'+json.serializepretty(response));
            }
            Document__c doc = new Document__c();
			string docFormat = documentTemplate.Generated_Document_Format__c;
			if (docFormat == null || docFormat == ''){
				docFormat = '.pdf';
			}
            doc.Name = documentTemplate.Name.left(75)+docFormat;
			doc.Type__c = documentTemplate.Document_Type__c;
			 if (!Test.isRunningTest()) {
                 doc.Reference__c = response.contentStoreToken;
             } else {
                 doc.Reference__c = 'tesRef';
             }
			doc.Opportunity__c = opp.Id;
			doc.ECM_Type__c = documentTemplate.ECM_Item_Type__c;
			insert doc;
			return 'success';
            
        }
        catch (Exception ex){
			return 'fail';
		}
    
    }
    @AuraEnabled
	public static String getDocumentContent(Id documentId){
		List<Document__c> docContentList = new DocumentsSelector().selectByDocId(documentId);
		ECM_LoginResult_IB_V1 login = ECMLogin();
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, docContentList[0].Reference__c);

		if (getResult.Content != null){
			return getResult.Content.data;
		} else{
			return 'ECM returned no results.';
		}
	}
    public static ECM_LoginResult_IB_V1 ECMLogin(){
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		return login;
	}
*/   
  /**
       * @description 
       * @author almas.aleem@absa.africa | 2021-10-22 
       * @param ; 
       * @return List<String> 
       **/
    @AuraEnabled
    public static List<String> getCountriesList(){
     
       List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Account.Country_of_Registration__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}
       
		return pickListValuesList;
    }
}