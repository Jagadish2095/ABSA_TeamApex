public class SMSGateway_IU_v1 {
    
    public static SMSGateway_Resp_IB_v1 mapSubmitResponseFields(HttpResponse responseP){
        
        SMSGateway_Resp_IB_v1 responseBean = new SMSGateway_Resp_IB_v1();
        
        responseBean.status = responseP.getBody().substringBefore('&');
        responseBean.message = responseP.getBody();
        responseBean.statusCode = responseP.getStatusCode();
        String data = responseP.getBody().substringAfter('&');
        data = data.replace('\n', '');
        List<String> dataList = new List<String>();
        dataList = data.split('&');
        
        if(responseBean.status == StringConstants.INTEGRATION_STATUS_SUCCESS){

            
            for(String dataItem : dataList){
                if(dataItem.substringBefore('=') == 'MessageReference'){
                    responseBean.MessageReference = dataItem.substringAfter('=');
                }
                if(dataItem.substringBefore('=') == 'PhoneNumber'){
                    responseBean.PhoneNumber = dataItem.substringAfter('=');
                }
                if(dataItem.substringBefore('=') == 'Credits'){
                    responseBean.Credits = dataItem.substringAfter('=').trim();
                }
            }
            
        }else{
            
            for(String dataItem : dataList){
                if(dataItem.substringBefore('=') == 'ErrorCode'){
                    responseBean.ErrorCode = Integer.valueOf(dataItem.substringAfter('='));
                }
                if(dataItem.substringBefore('=') == 'ErrorDescription'){
                    responseBean.ErrorDescription = dataItem.substringAfter('=');
                }
            }
            responseBean.statusCode = 400;
        }
        
        return responseBean;
    }
    
    public static SMSGateway_Resp_IB_v1 mapResponseFields(SMSGateway_Resp_IB_v1 beanP, String statusP, Integer statusCodeP, String messageP){
        
        return mapFailedResponseFields(beanP, statusP, statusCodeP, messageP);
    }
    
    public static SMSGateway_Resp_IB_v1 mapResponseFields(List<String> dataListP){
        
        SMSGateway_Resp_IB_v1 smsBean = new SMSGateway_Resp_IB_v1();
        //Map fields from the data list to the response bean
        for(String data : dataListP){
            if(data.substringBefore('=') == 'Type'){
                smsBean.smsType = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'status'){
                smsBean.statusNumber = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'StatusDescription'){
                smsBean.StatusDescription = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'MessageReference'){
                smsBean.MessageReference = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'PhoneNumber'){
                smsBean.PhoneNumber = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'CreateTime'){
                smsBean.CreateTime = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'ScheduledTime'){
                smsBean.ScheduledTime = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'SubmitTime'){
                smsBean.SubmitTime = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'ConfirmTime'){
                smsBean.ConfirmTime = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'FinalTime'){
                smsBean.FinalTime = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'UserReference'){
                smsBean.UserReference = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'MessageText'){
                smsBean.MessageText = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'SourceNumber'){
                smsBean.SourceNumber = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'Flags'){
                smsBean.Flags = data.substringAfter('=').trim();
            }
            if(data.substringBefore('=') == 'OriginalText'){
                smsBean.OriginalText = data.substringAfter('=').trim();
            }
        }
        
        return smsBean;
    }
    
    public static SMSGateway_Resp_IB_v1 mapFailedResponseFields(SMSGateway_Resp_IB_v1 beanP, String statusP, Integer statusCodeP, String messageP){
        
        beanP.status = statusP;
        beanP.statusCode = statusCodeP;
        beanP.message = messageP;
        return beanP;
        
    }
    
    public static String getDeliveryStatus(String numberP){
        
        String status;
        switch on numberP {
            when '1'{
                status = 'Pending';
            }
            when '2'{
                status = 'Submitted';
            }
            when '3'{
                status = 'Delivered';
            }
            when '4'{
                status = 'Submit Error';
            }
            when '5'{
                status = 'Delivery Expired';
            }
            when '9'{
                status = 'Suspended';
            }
            when '16'{
                status = 'Submission Expired';
            }
        }
        return status;
    }
}