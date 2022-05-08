/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-12-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class RiskProfileJointClient_Req_IB_v2 extends Base_IB {
   
    public List<RelatedParty> relatedParties ;
        public PrimaryClient primaryClient ;
        public string errorMessage ;

        /** 
         * @description SubProductCodeTable
         */
    public without sharing class SubProductCodeTable
    {
        public string subProductCode;
    }

        /** 
         * @description ProductCodeTable
         */
    public without sharing class ProductCodeTable
    {
        public string productCode;
    }
        /** 
         * @description AbsaSourceOfIncomeTable
         */
    public without sharing class AbsaSourceOfIncomeTable
    {
        public string absaSourceOfIncome;
    }
        /** 
         * @description AbsaCountryTradedWithTable
         */
    public without sharing class AbsaCountryTradedWithTable
    {
        public string absaCountriesTradedWith;
    }
        /** 
         * @description AbsaCountryOfOperationTable
         */
    public without sharing class AbsaCountryOfOperationTable
    {
        public string absaCountryOfOperation;
    }
         /** 
         * @description RelatedParty
         */
    public without sharing class RelatedParty
    {
        public string userId;
        public List<SubProductCodeTable> subProductCodeTable;
        public string sbu;
        public List<ProductCodeTable> productCodeTable;
        public string primeBranchID;
        public string originatingsystem;
        public string occupation;
        public string incorporationCountryCode;
        public string employmentStatus;
        public string customerTypeCode;
        public string customerStatusCode;
        public string customerSourceUniqueId;
        public string customerSourceRefID;
        public string companyForm;
        public string cifKey;
        public string channel;
        public string businessSegment1;
        public List<AbsaSourceOfIncomeTable> absaSourceOfIncomeTable;
        public List<AbsaCountryTradedWithTable> absaCountryTradedWithTable;
        public List<AbsaCountryOfOperationTable> absaCountryOfOperationTable;
    }
         /** 
         * @description PrimaryClient
         */
    public without sharing class PrimaryClient
    {
        public string userId;
        public List<SubProductCodeTable> subProductCodeTable;
        public string sbu;
        public List<ProductCodeTable> productCodeTable;
        public string primeBranchID;
        public string originatingsystem;
        public string occupation;
        public string incorporationCountryCode;
        public string employmentStatus;
        public string customerTypeCode;
        public string customerStatusCode;
        public string customerSourceUniqueId;
        public string customerSourceRefID;
        public string companyForm;
        public string cifKey;
        public string channel;
        public string businessSegment1;
        public List<AbsaSourceOfIncomeTable> absaSourceOfIncomeTable;
        public List<AbsaCountryTradedWithTable> absaCountryTradedWithTable;
        public List<AbsaCountryOfOperationTable> absaCountryOfOperationTable;
    }
    
    /** 
         * @description createDummy
         * @return RiskProfileJointClient_Req_IB_v2
         */
    public static RiskProfileJointClient_Req_IB_v2 createDummy(){
        
        RiskProfileJointClient_Req_IB_v2.PrimaryClient primaryClient = new RiskProfileJointClient_Req_IB_v2.PrimaryClient();
        primaryClient.primeBranchID= '2626';
        primaryClient.originatingsystem= 'BDP';
        primaryClient.occupation= '1 ';
        primaryClient.IncorporationCountryCode= '';
        primaryClient.employmentStatus= '1';
        primaryClient.customerTypeCode= '';
        primaryClient.customerStatusCode= '' ;
        primaryClient.customerSourceUniqueId='120000150';
        primaryClient.customerSourceRefID=
        primaryClient.companyForm='301' ;
        primaryClient.cifKey  = '';
        primaryClient.channel='F2F1';
        primaryClient.businessSegment1 =  '';


        SubProductCodeTable subProductCodePrimaryClientObj = new SubProductCodeTable();
        subProductCodePrimaryClientObj.subProductCode = '';
         List<SubProductCodeTable> subProductCodePrimaryClientList = new List<SubProductCodeTable>();
         subProductCodePrimaryClientList.add(subProductCodePrimaryClientObj);
         primaryClient.subProductCodeTable = subProductCodePrimaryClientList;

         ProductCodeTable productCodePrimaryClientObj = new ProductCodeTable();
         productCodePrimaryClientObj.productCode = '16';
         List<ProductCodeTable> productCodePrimaryClientList = new List<ProductCodeTable>();
         productCodePrimaryClientList.add(productCodePrimaryClientObj);
         primaryClient.productCodeTable = productCodePrimaryClientList;

        AbsaCountryTradedWithTable absaCountryTradeWithPrimaryClientObj = new AbsaCountryTradedWithTable();
        absaCountryTradeWithPrimaryClientObj.absaCountriesTradedWith = '';
        List<AbsaCountryTradedWithTable> absaCountryTradeWithPrimaryClientList = new List<AbsaCountryTradedWithTable>();
        absaCountryTradeWithPrimaryClientList.add(absaCountryTradeWithPrimaryClientObj);
        primaryClient.absaCountryTradedWithTable = absaCountryTradeWithPrimaryClientList;
        
        AbsaCountryOfOperationTable absaCountryOfOperationPrimaryClientObj = new AbsaCountryOfOperationTable();
         absaCountryOfOperationPrimaryClientObj.absaCountryOfOperation = '';
         List<AbsaCountryOfOperationTable> absaCountryOfOperationClientPrimaryClientList = new List<AbsaCountryOfOperationTable>();
         absaCountryOfOperationClientPrimaryClientList.add(absaCountryOfOperationPrimaryClientObj);
         primaryClient.absaCountryOfOperationTable = absaCountryOfOperationClientPrimaryClientList;
        
         AbsaSourceOfIncomeTable absaSourceOfIncomePrimaryClientObj = new AbsaSourceOfIncomeTable();
         absaSourceOfIncomePrimaryClientObj.absaSourceOfIncome = '1';
         List<AbsaSourceOfIncomeTable> absaSourceOfIncomePrimaryClientList = new List<AbsaSourceOfIncomeTable>();
         absaSourceOfIncomePrimaryClientList.add(absaSourceOfIncomePrimaryClientObj);
        primaryClient.absaSourceOfIncomeTable = absaSourceOfIncomePrimaryClientList;
        
        primaryClient.userId = 'EXRN181';
        
        RiskProfileJointClient_Req_IB_v2.RelatedParty relatedParty = new RiskProfileJointClient_Req_IB_v2.RelatedParty();
        relatedParty.primeBranchID= '2626';
        relatedParty.originatingsystem= 'BDP';
        relatedParty.occupation= '1 ';
        relatedParty.IncorporationCountryCode= '';
        relatedParty.employmentStatus= '1';
        relatedParty.customerTypeCode= '';
        relatedParty.customerStatusCode= '' ;
        relatedParty.customerSourceUniqueId='120000150';
        relatedParty.customerSourceRefID=
        relatedParty.companyForm='301' ;
        relatedParty.cifKey  = '';
        relatedParty.channel='F2F1';
        relatedParty.businessSegment1 =  '';
        relatedParty.IncorporationCountryCode = '';
         AbsaCountryTradedWithTable absaCountryTradeWithRelatedPartyObj = new  AbsaCountryTradedWithTable();
        absaCountryTradeWithRelatedPartyObj.absaCountriesTradedWith = '';
        List<AbsaCountryTradedWithTable> absaCountryTradeWithRelatedPartyList = new List<AbsaCountryTradedWithTable>();
        absaCountryTradeWithRelatedPartyList.add(absaCountryTradeWithRelatedPartyObj);
        relatedParty.absaCountryTradedWithTable = absaCountryTradeWithRelatedPartyList;
        
        AbsaCountryOfOperationTable absaCountryOfOperationRelatedPartyObj = new AbsaCountryOfOperationTable();
        absaCountryOfOperationRelatedPartyObj.absaCountryOfOperation = '';
        List<AbsaCountryOfOperationTable> absaCountryOfOperationClientRelatedPartyList = new List<AbsaCountryOfOperationTable>();
        absaCountryOfOperationClientRelatedPartyList.add(absaCountryOfOperationRelatedPartyObj);
        relatedParty.absaCountryOfOperationTable = absaCountryOfOperationClientRelatedPartyList;
        
        AbsaSourceOfIncomeTable absaSourceOfIncomeRelatedPartyObj = new AbsaSourceOfIncomeTable();
        absaSourceOfIncomeRelatedPartyObj.absaSourceOfIncome = '1';
        List<AbsaSourceOfIncomeTable> absaSourceOfIncomeRelatedPartyList = new List<AbsaSourceOfIncomeTable>();
        absaSourceOfIncomeRelatedPartyList.add(absaSourceOfIncomeRelatedPartyObj);
        relatedParty.absaSourceOfIncomeTable = absaSourceOfIncomeRelatedPartyList;
        
        ProductCodeTable productCodeRelatedPartyObj = new ProductCodeTable();
        productCodeRelatedPartyObj.productCode = '16';
        List<ProductCodeTable> productCodeRelatedPartyList = new List<ProductCodeTable>();
        productCodeRelatedPartyList.add(productCodeRelatedPartyObj);
        relatedParty.productCodeTable = productCodeRelatedPartyList;
        
        SubProductCodeTable subProductCodeRelatedPartyObj = new SubProductCodeTable();
        subProductCodeRelatedPartyObj.subProductCode = '';
        List<SubProductCodeTable> subProductCodeRelatedPartyList = new List<SubProductCodeTable>();
        subProductCodeRelatedPartyList.add(subProductCodeRelatedPartyObj);
        relatedParty.subProductCodeTable = subProductCodeRelatedPartyList;

        relatedParty.userId = 'EXRN181';
        
        List<RiskProfileJointClient_Req_IB_v2.RelatedParty> relatedPartyList = new List<RiskProfileJointClient_Req_IB_v2.RelatedParty>();
        relatedPartyList.add(relatedParty);
        
        RiskProfileJointClient_Req_IB_v2 bean = new RiskProfileJointClient_Req_IB_v2();
        bean.PrimaryClient = primaryClient;
        bean.relatedParties = relatedPartyList;
        return bean;
    }
}