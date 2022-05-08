/**
 * @description       : Apex Class for Updating the Status to PowerCurveStatusUpdate Service call
 * @author            : Gulafsha
 * @last modified on  : 2021-10-18
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-07-17   Gulafsha   Initial Version
**/


Public class PowerCurveStatusUpdate {
    
    /**
    * @description pcoCallout
    * @author Gulafsha | 2021-07-17 
    * @param OpportunityId 
    * @return PowerCurveStatusUpdate_Resp_IB_v1 
    **/
    Public Static PowerCurveStatusUpdate_Resp_IB_v1 pcoCallout(Id OpportunityId){
        
        Opportunity opp = [SELECT Id, Name, Is_Submitted_Sanctioning__c,Credit_Application_Refferedby__c,Sanctioning_Refer_DateTime__c,
                           Sanctioning_SLA_Start_Date__c,Pricing_Refer_DateTime__c from Opportunity where Id=:OpportunityId LIMIT 1];       
        
        List<Application__c> appList = [SELECT Id, Name, Credit_Application_Accepted__c, Credit_Application_Accepted_DateTime__c,Credit_Application_Acceptedby__c,
                                        Credit_Application_Status__c,stock_Number__c,Credit_App_Status_Change_Date__c,Credit_App_Status_Change_Time__c,
                                        DERPCOUNIQUENUMBER__c
                                        FROM Application__c where Opportunity__c=:OpportunityId  LIMIT 1  ];
        
        
        List<Application_Scoring__c> appScoringList =[SELECT Id,stage__c,DERPCOUNIQUENUMBER__c from Application_Scoring__c 
														where Application_Number__c=:appList[0].Id and  stage__c='1' LIMIT 1];
        
         
        //put time and date
        DateTime dt;
        DateTime dt2;
        String appreferTime ;
        if(appList[0].Credit_App_Status_Change_Date__c !=null){
            dt = DateTime.newInstance(appList[0].Credit_App_Status_Change_Date__c.year(),appList[0].Credit_App_Status_Change_Date__c.month(),appList[0].Credit_App_Status_Change_Date__c.day());
        }
        if(appList[0].Credit_App_Status_Change_Time__c  !=null){
            dt2 = DateTime.newInstance(appList[0].Credit_App_Status_Change_Time__c.millisecond());
            appreferTime = ''+appList[0].Credit_App_Status_Change_Time__c.hour()+''+appList[0].Credit_App_Status_Change_Time__c.minute()+''+appList[0].Credit_App_Status_Change_Time__c.second()+'00';
        }
        
        
          List<Application_Product__c> appProdCredList = [Select Id, Application_Product_Parent__c, Name, Product_Name__c,Account_Number__c, Temp_Account_Number__c,
                                                        System_Decision__c,Final_Decision_Date_Time__c, Final_Decision__c, Product_Status__c, Product_State__c
                                                        from Application_Product__c Where opportunity__c=:OpportunityId and Application_Product_Parent__c = null];
        
        
        
        
        //updating status 
		Boolean isAllprodFulfilled =false;
        for(Application_Product__c appProd : appProdCredList){
            if (appProd.Product_Status__c.EqualsIgnoreCase('FulFilled')){
                    isAllprodFulfilled=true;
            }else{
                break;
            }
        }
        
        String applicationStatus;
        if(appList[0].Credit_Application_Status__c != null){
            if(appList[0].Credit_Application_Status__c.EqualsIgnoreCase('Accepted')){
                applicationStatus ='A';
            }else if(appList[0].Credit_Application_Status__c.EqualsIgnoreCase('Declined')){
                applicationStatus='D';
            }else if (appList[0].Credit_Application_Status__c.EqualsIgnoreCase('Refer To Sanctioning')){
                applicationStatus='P';
            }else if (appList[0].Credit_Application_Status__c.EqualsIgnoreCase('Amend')){
                applicationStatus='P';
            }else if (appList[0].Credit_Application_Status__c.EqualsIgnoreCase('Withdrawal')){
                applicationStatus='W';
            }else if (appList[0].Credit_Application_Status__c.EqualsIgnoreCase('Pipeline For Fulfillment')){
                applicationStatus='I';
            }
        }else if(appList[0].Credit_Application_Status__c == null && isAllprodFulfilled==false) {
            applicationStatus='P';
        }else if(isAllprodFulfilled){
            applicationStatus = 'F';
        }
        
        
        PowerCurveStatusUpdate_Req_IB_v1 requestBean = new PowerCurveStatusUpdate_Req_IB_v1();
        
        requestBean.Request = new PowerCurveStatusUpdate_Req_IB_v1.Request();
        requestBean.Request.ApplicationDV = new PowerCurveStatusUpdate_Req_IB_v1.ApplicationDV();
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONNUMBER = appList[0].stock_Number__c != null ? appList[0].stock_Number__c : '' ; 
        requestBean.Request.ApplicationDV.DERPCOUNIQUENUMBER = String.valueOf(appList[0].DERPCOUNIQUENUMBER__c)!= null ? String.valueOf(appList[0].DERPCOUNIQUENUMBER__c):'';  
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTYPE = 'O';                  
        requestBean.Request.ApplicationDV.APPAPPSTAGEID ='SU';                          
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSTATUS = applicationStatus!=null?applicationStatus:'';    
        requestBean.Request.ApplicationDV.APPAPPFINALISEDDATE =  '';
        requestBean.Request.ApplicationDV.APPAPPFINALISEDTIME = '';
       /* requestBean.Request.ApplicationDV.APPAPPSTATUSCHANGEDATE = appList[0].Credit_App_Status_Change_Date__c == null ? '' : ''+ String.valueOf(dt.format('YYYY-MM-dd')); //system decision refer date     
        requestBean.Request.ApplicationDV.APPAPPSTATUSCHANGETIME = appList[0].Credit_App_Status_Change_Time__c == null ? '' : ''+appreferTime ;*/
        requestBean.Request.ApplicationDV.APPAPPSTATUSCHANGEDATE = System.now().format('YYYY-MM-dd'); //system decision refer date     
        requestBean.Request.ApplicationDV.APPAPPSTATUSCHANGETIME = System.now().format('HHmmss');
        requestBean.Request.ApplicationDV.APPAPPCREDITREFERDATE =  opp.Sanctioning_SLA_Start_Date__c!= null ? String.valueOf(opp.Sanctioning_SLA_Start_Date__c.format('YYYY-MM-dd')) : '' ;  
        requestBean.Request.ApplicationDV.APPAPPCREDITREFERTIME =  opp.Sanctioning_SLA_Start_Date__c!= null ? String.valueOf(opp.Sanctioning_SLA_Start_Date__c.format('HHmmss')) : '' ;  
        requestBean.Request.ApplicationDV.APPAPPPRICINGREFERDATE = opp.Pricing_Refer_DateTime__c!= null ? String.valueOf(opp.Pricing_Refer_DateTime__c.format('YYYY-MM-dd')) : '' ;     
        requestBean.Request.ApplicationDV.APPAPPPRICINGREFERTIME = opp.Pricing_Refer_DateTime__c!= null ? String.valueOf(opp.Pricing_Refer_DateTime__c.format('HHmmss')) : '' ;       		 
        
        requestBean.Request.ApplicationDV.ExistingProducts = new List <PowerCurveStatusUpdate_Req_IB_v1.ExistingProducts>();
        requestBean.Request.ApplicationDV.RequestedProducts = new List <PowerCurveStatusUpdate_Req_IB_v1.RequestedProducts>();
        
        
      
        
        for(Application_Product__c appProd : appProdCredList){
            
            String productStatus;
            if(appProd.Product_Status__c!= null){
                if(appProd.Product_Status__c.EqualsIgnoreCase('Accepted')){
                    productStatus ='A';
                }else if(appProd.Product_Status__c.EqualsIgnoreCase('Declined')){
                    productStatus='D';
                }if(appProd.Product_Status__c.EqualsIgnoreCase('Pending')){
                    productStatus ='P';
                }else if (appProd.Product_Status__c.EqualsIgnoreCase('Not Taken Up')){
                    productStatus='W';
                }else if (appProd.Product_Status__c.EqualsIgnoreCase('Withdrawal')){
                    productStatus='W';
                }else if (appProd.Product_Status__c.EqualsIgnoreCase('Pipeline For Fulfillment')){
                    productStatus='I';
                }else if (appProd.Product_Status__c.EqualsIgnoreCase('FulFilled')){
                    productStatus='F';
                }
                if(applicationStatus=='P'){
                    if(appProd.Product_Status__c.EqualsIgnoreCase('FulFilled') == false){
                    	productStatus ='P';
                    }
                }
            }
            
            if( appProd.Product_State__c!=null  && appProd.Product_State__c.equalsIgnoreCase('existing')){
                
                //New Instance of Existing Products
                PowerCurveStatusUpdate_Req_IB_v1.ExistingProducts existingProducts = new PowerCurveStatusUpdate_Req_IB_v1.ExistingProducts();
                existingProducts.APPPRDEXST = new PowerCurveStatusUpdate_Req_IB_v1.APPPRDEXST();
                existingProducts.INTPRDEXST = new PowerCurveStatusUpdate_Req_IB_v1.INTPRDEXST();
                
                existingProducts.APPPRDEXST.APPLICATIONSTATUS = productStatus!= null ? productStatus : '' ; 
                existingProducts.APPPRDEXST.FINALISEDDATE = appProd.Final_Decision_Date_Time__c!= null ? String.valueOf(appProd.Final_Decision_Date_Time__c.format('YYYY-MM-dd')) : '' ;    
                existingProducts.APPPRDEXST.FINALISEDTIME =  appProd.Final_Decision_Date_Time__c!= null ? String.valueOf(appProd.Final_Decision_Date_Time__c.format('HHmmss')) : '' ; 
                existingProducts.INTPRDEXST.ACCOUNTNUMBER = appProd.Account_Number__c!= null ? string.valueof(appProd.Account_Number__c) : '' ;
                existingProducts.INTPRDEXST.ESPINSTRUCTION = '';    
                
                requestBean.Request.ApplicationDV.ExistingProducts.add(existingProducts);
                
            }else  if(appProd.Product_State__c!=null  &&  appProd.Product_State__c.equalsIgnoreCase('new') ){ 
                
                String acctnumber ;
                if(appProd.Product_Status__c == 'FulFilled' && appProd.Product_Name__c == 'Credit Card' ){
                    acctnumber = string.valueof(appProd.Account_Number__c) !=null ? string.valueOf(appProd.Account_Number__c) : '';
                }else{
                    acctnumber = string.valueof(appProd.Temp_Account_Number__c) != null ? string.valueof(appProd.Temp_Account_Number__c) :'';
                }
                
                //New Instance of Requested Products
                PowerCurveStatusUpdate_Req_IB_v1.RequestedProducts requestedProducts = new PowerCurveStatusUpdate_Req_IB_v1.RequestedProducts();
                requestedProducts.APPPRDNEWF = new PowerCurveStatusUpdate_Req_IB_v1.APPPRDNEWF();
                
                requestedProducts.APPPRDNEWF.ACCOUNTNUMBER = acctnumber; //string.valueof(appProd.Temp_Account_Number__c)!= null ? string.valueof(appProd.Temp_Account_Number__c) : ''; 
                requestedProducts.APPPRDNEWF.APPLICATIONSTATUS =  productStatus!= null ? productStatus : '' ;  
                requestedProducts.APPPRDNEWF.ESPINSTRUCTION = ''; 
                requestedProducts.APPPRDNEWF.FINALISEDDATE = appProd.Final_Decision_Date_Time__c!= null ? String.valueOf(appProd.Final_Decision_Date_Time__c.format('YYYY-MM-dd')) : '' ; 
                requestedProducts.APPPRDNEWF.FINALISEDTIME = appProd.Final_Decision_Date_Time__c!= null ? String.valueOf(appProd.Final_Decision_Date_Time__c.format('HHmmss')) : '' ; 
                
                requestBean.Request.ApplicationDV.RequestedProducts.add(requestedProducts);
            }
        }  
        
       
        PowerCurveStatusUpdate_Resp_IB_v1 responseBean = PowerCurveStatusUpdate_IH_v1.PowerCurveStatusUpdate(requestBean);
         
        
        return responseBean;
        
    }
    
}