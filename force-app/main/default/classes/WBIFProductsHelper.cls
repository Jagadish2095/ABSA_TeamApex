/**
 * @description WBIFProductsHelper
 **/
public class WBIFProductsHelper{
    
    	/**
	 * @description get products details 
	 * @param productCode
	 * @return WBIF_Product_Details
	 **/
    public static WBIF_Product_Details getWbifProductCoverOptions(String productCode){
        
        WBIF_Product_Wrapper getProductRequest = new WBIF_Product_Wrapper();
        getProductRequest.Product_Get = new cls_Product_Get();
        getProductRequest.Product_Get.module = productCode; 

        WBIF_Product_Wrapper responseBean = (WBIF_Product_Wrapper)Sys_Utilities_Integration.integrationServiceCall(getProductRequest, null, StringConstants.WBIF_AMCDF_PRODUCTGET, WBIF_Product_Wrapper.class);

        WBIF_Product_Details returnValue = new WBIF_Product_Details();
        cls_Product_GetResult results = responseBean.Product_GetResponse.Product_GetResult;
        List<string> duplicateCheck = new List<string>();
        
        returnValue.ProductName = results.ProductName;
        returnValue.ProductIdentifier = results.ProductIdentifier;
        returnValue.MemberTypes = new List<WBIF_Product_Details.WbifMemberType>();
        returnValue.ContractOptions = new List<WBIF_Product_Details.ContractOption>();
        
        for (cls_BenefitOption benefitOption : results.Benefits.BenefitOption){
            
            if (benefitOption.Target.SubType == 'Main' || benefitOption.Target.SubType == 'Dependent'){
                if(!duplicateCheck.contains(benefitOption.Target.Name)){
                    WBIF_Product_Details.WbifMemberType member = new WBIF_Product_Details.WbifMemberType();
                    member.MemberTypeValue = benefitOption.Target.Type;
                    member.MemberTypeName = benefitOption.Target.Name;
                    member.BenefitId = benefitOption.ID;
                    member.CoverOptions = new List<WBIF_Product_Details.CoverOption>();
                    
                    for (cls_CoverOption option : benefitOption.CoverOptions.CoverOption){
                        if (option.Cover != '0'){
                            WBIF_Product_Details.CoverOption cOption = new WBIF_Product_Details.CoverOption();
                            cOption.label = option.Name;
                            cOption.value = option.Cover;
                            member.CoverOptions.add(cOption);
                        }
                    }
                    returnValue.MemberTypes.add(member);
                    duplicateCheck.add(benefitOption.Target.Name);
                }
            }
        }
        
        
        for(cls_ContractOption contract : results.ContractOptions.ContractOption){
            
            WBIF_Product_Details.ContractOption contractOption = new WBIF_Product_Details.ContractOption();
            contractOption.Key = contract.Key;
            contractOption.Name = contract.Name;
            contractOption.value = contract.Name.substring(13).replace(',', '');
            returnValue.ContractOptions.add(contractOption);
        }

        return returnValue;
    }
    
    /**
	 * @description get benefit Id for selected member Type
	 * @param products (WBIF_Product_Details)
     * @param memberType
	 * @return String
	 **/
    public static String  getBenefitId(WBIF_Product_Details products, String memberType){
        
        for(WBIF_Product_Details.WbifMemberType member : products.MemberTypes ){
            if(member.MemberTypeName == memberType){
                return member.BenefitId;
            }
        }
        
        return '00000000';
        
    }

    /**
	 * @description get contract Id for selected cover option
	 * @param products (WBIF_Product_Details)
     * @param coverOptionP
	 * @return String
	 **/
    public static String getContractOptionId(WBIF_Product_Details products, String coverOptionP){
        
        String coverOption = coverOptionP.replace('.00', '');
        
        if(products.ContractOptions.size() == 1 || coverOption == null ||  coverOption == '0'){
            return products.ContractOptions.get(0).Key;
        }
        
        for(WBIF_Product_Details.ContractOption contractOption : products.ContractOptions ){
            if(contractOption.Value == coverOption){
                return contractOption.Key;
            }
        }
        throw new AuraHandledException('Invalid contract options in products details');
    }
    
    /**
     * @description WBIF_Product_Wrapper
     **/
    public class WBIF_Product_Wrapper extends Base_IB {
        public cls_Product_Get Product_Get;
        public cls_Product_GetResponse Product_GetResponse;
    }
    
    /**
     * @description cls_Product_Get
     **/
    public class cls_Product_Get{
        public string module;
    }
    
    /**
     * @description cls_Product_GetResponse
     **/
    public class cls_Product_GetResponse{
        public cls_Product_GetResult Product_GetResult;
    }

    /**
     * @description cls_Product_GetResult
     **/
    public class cls_Product_GetResult{
        public cls_Benefits Benefits;
        public string ProductName;
        public string ProductIdentifier;
        public cls_ContractOptions ContractOptions;
    }

    /**
     * @description cls_Benefits
     **/
    public class cls_Benefits{
        public cls_BenefitOption[] BenefitOption;
    }
    
    /**
     * @description cls_ContractOptions
     **/
    public class cls_ContractOptions{
        public cls_ContractOption[] ContractOption;
    }
    /**
     * @description cls_ContractOption
     **/
    public class cls_ContractOption{
        public string ID;
        public string Key;
        public string Name;
    }
    /**
     * @description cls_BenefitOption
     **/
    public class cls_BenefitOption{
        public string Cover;
        public string ID;
        public string IsDefault;
        public string Name;
        public string Premium;
        public cls_Target Target;
        public cls_CoverOptions CoverOptions;
    }
    /**
     * @description cls_Target
     **/
    public class cls_Target{
        public string ID;
        public string Name;
        public string SubType;
        public string Type;
    }
    /**
     * @description cls_CoverOptions
     **/
    public class cls_CoverOptions{
        public cls_CoverOption[] CoverOption;
    }
    /**
     * @description cls_CoverOption
     **/
    public class cls_CoverOption{
        public string Cover;
        public string IsDefault;
        public string Name;
        public string Premium;
    }
    
 
}