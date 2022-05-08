/*
        * Request wrapper class for GetRiskProfileClient service
        * @author Srikanth N : Absa
        * @version v1.0
        * @since   2019-12-03
        *
   */
global class GetRiskProfileClient_Req_IB_v2 extends Base_IB {
    
    public cls_WQriskProfileClientV7Request WQriskProfileClientV7Request;
    public String errorMessage;
    
    public class cls_WQriskProfileClientV7Request{
        
        public String customerTypeCode;
        public String customerStatusCode;
        public String customerSourceUniqueId;
        public String companyForm;
        public String customerSourceRefID;
        public String primeBranchID;
        public String channel;
        public String sbu;
        public String originatingsystem;
        public String employmentStatus;//Contact
        public String occupation;//Contact
        public String businessSegment1;
        public String cifKey;
        public String specialAttentionFlag;
        public String IncorporationCountryCode;
        public cls_absaCountryTradedWithTable[] absaCountryTradedWithTable;
        public cls_absaCountryOfOperationTable[] absaCountryOfOperationTable;
        public cls_absaSourceOfIncomeTable[] absaSourceOfIncomeTable;//Contact
        public cls_productCodeTable[] productCodeTable;//Product
        public cls_subProductCodeTable[] subProductCodeTable;//Sub Product
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
    
    public GetRiskProfileClient_Req_IB_v2 createDummyRequest(){
        
        GetRiskProfileClient_Req_IB_v2 wholeRequest = new GetRiskProfileClient_Req_IB_v2();
        wholeRequest.errorMessage = '';
      //  GetRiskProfileClient_Req_IB_v2.errorMessage errorString = new GetRiskProfileClient_Req_IB_v2.errorMessage();
        GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request request = new GetRiskProfileClient_Req_IB_v2.cls_WQriskProfileClientV7Request();
        
      //  String requestError = new GetRiskProfileClient_Req_IB_v2.errorMessage();
       
      //  requestError
        
        request.customerTypeCode = '';
        request.customerStatusCode = '';
        request.customerSourceUniqueId = '1798487';
        request.companyForm = '00101';
        request.customerSourceRefID = 'Test';
        request.primeBranchID = '2626';
        request.channel = 'F2F1';
        request.sbu = '061';
        request.originatingsystem = 'SALESFORCE';
        request.employmentStatus = '1';
        request.occupation = '1';
        request.businessSegment1 = '';
        
        cls_absaSourceOfIncomeTable absaSourceOfIncomeObj = new cls_absaSourceOfIncomeTable();
        absaSourceOfIncomeObj.absaSourceOfIncome = '01';
        List<cls_absaSourceOfIncomeTable> absaSourceOfIncomeList = new List<cls_absaSourceOfIncomeTable>();
        absaSourceOfIncomeList.add(absaSourceOfIncomeObj);
        request.absaSourceOfIncomeTable = absaSourceOfIncomeList;
        
        cls_productCodeTable productCodeObj = new cls_productCodeTable();
        productCodeObj.productCode = 'ALI';
        List<cls_productCodeTable> productCodeList = new List<cls_productCodeTable>();
        productCodeList.add(productCodeObj);
        request.productCodeTable = productCodeList;
        
        cls_subProductCodeTable subProductCodeObj = new cls_subProductCodeTable();
        subProductCodeObj.subProductCode = 'EPP1';
        List<cls_subProductCodeTable> subProductCodeList = new List<cls_subProductCodeTable>();
        subProductCodeList.add(subProductCodeObj);
        request.subProductCodeTable = subProductCodeList;

        request.userId = 'EXVP124';
        
        GetRiskProfileClient_Req_IB_v2 bean = new GetRiskProfileClient_Req_IB_v2();
        bean.WQriskProfileClientV7Request = request;
        bean.errorMessage = '';
        System.debug('RequestBean: ' + bean);
        return bean;
        
    }
    
}