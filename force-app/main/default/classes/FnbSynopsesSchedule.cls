/**
* Shedulable class to synchronize ROA products synopsis
* @author  André Pietersen
* @created 2020-11-17
*/
global class FnbSynopsesSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        processSynopsisSync();
    }

    public static void processSynopsisSync() { 
        List<ROAProduct__c> productInSF = [select ProductId__c,Description__c,Code__c,PackageChargeOption__c,Synopsis__c from ROAProduct__c];

        //Setup endpoint environment to bypass SOQL logging so limit of 100 queries is not reached
        String serviceNameP = 'SearchProductsV2';
        List<Integration_Service__c> endpoints = [select Id, Integration_API_ID__r.Base_URL__c, URL_Extension__c, Content_Type__c from Integration_Service__c where name =:serviceNameP];
        String endpoint = endpoints[0].Integration_API_ID__r.Base_URL__c + endpoints[0].URL_Extension__c;
        JitterbitAuthResponse jitterbitAuthResponse = JitterbitAuth_IH_V1.authenticate2();

        SearchProductsV2_Req_IB_v1 requestBean = new SearchProductsV2_Req_IB_v1();
        requestBean.SearchProductsV2RequestMsg = new SearchProductsV2_Req_IB_v1.SearchProductsV2RequestMsg();
        requestBean.SearchProductsV2RequestMsg.common = new SearchProductsV2_Req_IB_v1.Common();
        requestBean.SearchProductsV2RequestMsg.searchProductsV2RequestDto = new SearchProductsV2_Req_IB_v1.SearchProductsV2RequestDto();
        requestBean.SearchProductsV2RequestMsg.searchProductsV2RequestDto.cifProductFilter = new SearchProductsV2_Req_IB_v1.CifProductFilter();
        requestBean.SearchProductsV2RequestMsg.common.userInfo = new SearchProductsV2_Req_IB_v1.UserInfo();
           
        requestBean.SearchProductsV2RequestMsg.common.userInfo.username = '?';
        requestBean.SearchProductsV2RequestMsg.common.userInfo.password = '?';
        requestBean.SearchProductsV2RequestMsg.SearchProductsV2RequestDto.cifProductFilter.showFeatures = 'false';
        requestBean.SearchProductsV2RequestMsg.SearchProductsV2RequestDto.cifProductFilter.showRules = 'false';

        requestBean.SearchProductsV2RequestMsg.common.channel = 'Branch';
        requestBean.SearchProductsV2RequestMsg.common.messageOrigin = '?';
        requestBean.SearchProductsV2RequestMsg.common.messageLanguage = 'eng';

        Integer count = 0;
        for (ROAProduct__c product : productInSF) {
            if (product.Code__c != null) {
                List<String> productCode = product.Code__c.split(' ');
                if (productCode[0] != null) {
                    try {       
                        requestBean.SearchProductsV2RequestMsg.SearchProductsV2RequestDto.cifProductFilter.productCodes = productCode[0];
                        
                        // For this call we need to bypass the system util integration class and get the endpoint & auth token directly. 
                        // This is because the integration class does multiple SOQL queries per call.
                        // We reach the 100 SOQL limit trying to update the synopsis for each product in ROAProduct__c
                        String jsonString = JSON.serialize(requestBean);
                        HTTP http = new HTTP();
                        HTTPRequest httpRequest = new HttpRequest();
                        httpRequest.setHeader(StringConstants.CONTENT_TYPE_STRING, endpoints[0].Content_Type__c);
                        if (jitterbitAuthResponse != null && String.isNotBlank(jitterbitAuthResponse.token)) {
                            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitAuthResponse.token);
                        }
                        httpRequest.setEndpoint(endpoint);
                        httpRequest.setMethod('POST');
                        httpRequest.setBody(jsonString);
                        HTTPResponse response = http.send(httpRequest);

                        SearchProductsV2_Resp_IB_v1 responsegetSearchProducts = (SearchProductsV2_Resp_IB_v1)JSON.deserialize(response.getBody(), SearchProductsV2_Resp_IB_v1.class);
                        count = count + 1;

                        if (responsegetSearchProducts.searchProductsV2ResponseMsg.searchProductsV2ResponseDto.productCount != '0') {  
                            String synopsis = responsegetSearchProducts.searchProductsV2ResponseMsg.searchProductsV2ResponseDto.cifProducts[0].description;
                        
                            product.Synopsis__c = synopsis;
                        }
                        
                    } catch(Exception exc){
                        System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
                        throw new ApplicationException('Something went wrong: '+ exc.getMessage());
                    } 
                }
            }
        }
        update productInSF;
    }
}