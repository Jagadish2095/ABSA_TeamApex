public class RiskProfileJointClient_Req_IB_v1 extends Base_IB {
    //Risk Profile Joint Client V7
    
    public String errorMessage;
    public cls_riskProfileJointClientRequest primaryClient;
    public cls_riskProfileJointClientRequest[] relatedParties;
    
    public class cls_riskProfileJointClientRequest{
        public String customerTypeCode;
        public String customerStatusCode;
        public String customerSourceUniqueId;
        public String companyForm;
        public String customerSourceRefID;
        public String primeBranchID;
        public String channel;
        public String sbu;
        public String originatingsystem;
        public String employmentStatus;
        public String occupation;
        public String businessSegment1;
        public String cifKey;
        public String IncorporationCountryCode;
        public cls_absaCountryTradedWithTable[] absaCountryTradedWithTable;
        public cls_absaCountryOfOperationTable[] absaCountryOfOperationTable;
        public cls_absaSourceOfIncomeTable[] absaSourceOfIncomeTable;
        public cls_productCodeTable[] productCodeTable;
        public cls_subProductCodeTable[] subProductCodeTable;
        public String userId;
    }
    public class cls_absaCountryTradedWithTable{
        public String absaCountriesTradedWith;
    }
    public class cls_absaCountryOfOperationTable{
        public String absaCountryOfOperation;
    }
    public class cls_absaSourceOfIncomeTable{
        public String absaSourceOfIncome;
    }
    public class cls_productCodeTable{
        public String productCode;
    }
    public class cls_subProductCodeTable{
        public String subProductCode;
    }
    
    public static RiskProfileJointClient_Req_IB_v1 createDummy(){
        
        RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest primaryClient = new RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest();
        primaryClient.customerTypeCode = '';
        primaryClient.customerStatusCode = '';
        primaryClient.customerSourceUniqueId = '120000150';
        primaryClient.companyForm = '301';
        primaryClient.customerSourceRefID = '';
        primaryClient.primeBranchID = '2626';
        primaryClient.channel = 'F2F1';
        primaryClient.sbu = 'F';
        primaryClient.originatingsystem = 'AVAF';
        primaryClient.employmentStatus = '1';
        primaryClient.occupation = '1';
        primaryClient.businessSegment1 = '';
        primaryClient.cifKey = '';
        primaryClient.IncorporationCountryCode = '';
        
        cls_absaCountryTradedWithTable absaCountryTradeWithPrimaryClientObj = new cls_absaCountryTradedWithTable();
        absaCountryTradeWithPrimaryClientObj.absaCountriesTradedWith = '';
        List<cls_absaCountryTradedWithTable> absaCountryTradeWithPrimaryClientList = new List<cls_absaCountryTradedWithTable>();
        absaCountryTradeWithPrimaryClientList.add(absaCountryTradeWithPrimaryClientObj);
        primaryClient.absaCountryTradedWithTable = absaCountryTradeWithPrimaryClientList;
        
        cls_absaCountryOfOperationTable absaCountryOfOperationPrimaryClientObj = new cls_absaCountryOfOperationTable();
        absaCountryOfOperationPrimaryClientObj.absaCountryOfOperation = '';
        List<cls_absaCountryOfOperationTable> absaCountryOfOperationClientPrimaryClientList = new List<cls_absaCountryOfOperationTable>();
        absaCountryOfOperationClientPrimaryClientList.add(absaCountryOfOperationPrimaryClientObj);
        primaryClient.absaCountryOfOperationTable = absaCountryOfOperationClientPrimaryClientList;
        
        cls_absaSourceOfIncomeTable absaSourceOfIncomePrimaryClientObj = new cls_absaSourceOfIncomeTable();
        absaSourceOfIncomePrimaryClientObj.absaSourceOfIncome = '1';
        List<cls_absaSourceOfIncomeTable> absaSourceOfIncomePrimaryClientList = new List<cls_absaSourceOfIncomeTable>();
        absaSourceOfIncomePrimaryClientList.add(absaSourceOfIncomePrimaryClientObj);
        primaryClient.absaSourceOfIncomeTable = absaSourceOfIncomePrimaryClientList;
        
        cls_productCodeTable productCodePrimaryClientObj = new cls_productCodeTable();
        productCodePrimaryClientObj.productCode = '16';
        List<cls_productCodeTable> productCodePrimaryClientList = new List<cls_productCodeTable>();
        productCodePrimaryClientList.add(productCodePrimaryClientObj);
        primaryClient.productCodeTable = productCodePrimaryClientList;
        
        cls_subProductCodeTable subProductCodePrimaryClientObj = new cls_subProductCodeTable();
        subProductCodePrimaryClientObj.subProductCode = '';
        List<cls_subProductCodeTable> subProductCodePrimaryClientList = new List<cls_subProductCodeTable>();
        subProductCodePrimaryClientList.add(subProductCodePrimaryClientObj);
        primaryClient.subProductCodeTable = subProductCodePrimaryClientList;

        primaryClient.userId = 'EXRN181';
        
        RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest relatedParty = new RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest();
        relatedParty.customerTypeCode = '';
        relatedParty.customerStatusCode = '';
        relatedParty.customerSourceUniqueId = '120000251';
        relatedParty.companyForm = '101';
        relatedParty.customerSourceRefID = '120000251';
        relatedParty.primeBranchID = '';
        relatedParty.channel = 'F2F1';
        relatedParty.sbu = 'F';
        relatedParty.originatingsystem = 'AVAF';
        relatedParty.employmentStatus = '1';
        relatedParty.occupation = '1';
        relatedParty.businessSegment1 = '';
        relatedParty.cifKey = '';
        relatedParty.IncorporationCountryCode = '';
        
        cls_absaCountryTradedWithTable absaCountryTradeWithRelatedPartyObj = new cls_absaCountryTradedWithTable();
        absaCountryTradeWithRelatedPartyObj.absaCountriesTradedWith = '';
        List<cls_absaCountryTradedWithTable> absaCountryTradeWithRelatedPartyList = new List<cls_absaCountryTradedWithTable>();
        absaCountryTradeWithRelatedPartyList.add(absaCountryTradeWithRelatedPartyObj);
        relatedParty.absaCountryTradedWithTable = absaCountryTradeWithRelatedPartyList;
        
        cls_absaCountryOfOperationTable absaCountryOfOperationRelatedPartyObj = new cls_absaCountryOfOperationTable();
        absaCountryOfOperationRelatedPartyObj.absaCountryOfOperation = '';
        List<cls_absaCountryOfOperationTable> absaCountryOfOperationClientRelatedPartyList = new List<cls_absaCountryOfOperationTable>();
        absaCountryOfOperationClientRelatedPartyList.add(absaCountryOfOperationRelatedPartyObj);
        relatedParty.absaCountryOfOperationTable = absaCountryOfOperationClientRelatedPartyList;
        
        cls_absaSourceOfIncomeTable absaSourceOfIncomeRelatedPartyObj = new cls_absaSourceOfIncomeTable();
        absaSourceOfIncomeRelatedPartyObj.absaSourceOfIncome = '1';
        List<cls_absaSourceOfIncomeTable> absaSourceOfIncomeRelatedPartyList = new List<cls_absaSourceOfIncomeTable>();
        absaSourceOfIncomeRelatedPartyList.add(absaSourceOfIncomeRelatedPartyObj);
        relatedParty.absaSourceOfIncomeTable = absaSourceOfIncomeRelatedPartyList;
        
        cls_productCodeTable productCodeRelatedPartyObj = new cls_productCodeTable();
        productCodeRelatedPartyObj.productCode = '16';
        List<cls_productCodeTable> productCodeRelatedPartyList = new List<cls_productCodeTable>();
        productCodeRelatedPartyList.add(productCodeRelatedPartyObj);
        relatedParty.productCodeTable = productCodeRelatedPartyList;
        
        cls_subProductCodeTable subProductCodeRelatedPartyObj = new cls_subProductCodeTable();
        subProductCodeRelatedPartyObj.subProductCode = '';
        List<cls_subProductCodeTable> subProductCodeRelatedPartyList = new List<cls_subProductCodeTable>();
        subProductCodeRelatedPartyList.add(subProductCodeRelatedPartyObj);
        relatedParty.subProductCodeTable = subProductCodeRelatedPartyList;

        relatedParty.userId = 'EXRN181';
        
        List<RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest> relatedPartyList = new List<RiskProfileJointClient_Req_IB_v1.cls_riskProfileJointClientRequest>();
        relatedPartyList.add(relatedParty);
        
        RiskProfileJointClient_Req_IB_v1 bean = new RiskProfileJointClient_Req_IB_v1();
        bean.primaryClient = primaryClient;
        bean.relatedParties = relatedPartyList;
        return bean;
    }
}