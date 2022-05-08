/**
 * @description       : Integration response class for Application Exposure Facilities
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

public class ApplicationExposureFacilities_Resp_IB_v1 extends Base_IB {
	Public String status;
    Public Integer statusCode;
    Public String description;
    public cls_Client[] client;
    /**
 * @description       : Inner class with params
 * @author            : Ephetehe Mokgopanyane
 **/
    public class cls_Client{
        public String name;
        public cls_Aggregation[] aggregation;
    }
     /**
 * @description       : Inner class with params
 * @author            : Ephetehe Mokgopanyane
 **/
    public class cls_Aggregation{
        public Decimal total;
        public String aggregationType;
    }

    /**
    * @description : Method to set field names
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    **/
    public override void setFieldNameSubstitutions(){
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"type":', '"aggregationType":');
    }
    
    /**
    * @description : Method to create dummy response 
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @return ApplicationExposureFacilities_Resp_IB_v1 
    **/
    public static ApplicationExposureFacilities_Resp_IB_v1 createDummyResponse(){
        ApplicationExposureFacilities_Resp_IB_v1 responseBean = new ApplicationExposureFacilities_Resp_IB_v1();
        ApplicationExposureFacilities_Resp_IB_v1.cls_Client[] clients = new List<ApplicationExposureFacilities_Resp_IB_v1.cls_Client>();
        ApplicationExposureFacilities_Resp_IB_v1.cls_Client client = new ApplicationExposureFacilities_Resp_IB_v1.cls_Client();
        ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation[] aggregations = new List<ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation>();
        ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation aggregation = new ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation();
        
        aggregation.aggregationType = 'Approved Facility';
        aggregation.total = 720.0;
        aggregations.add(aggregation);
        
        aggregation = new ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation();
        aggregation.aggregationType = 'Approved Facility Installments';
        aggregation.total = 870;
        aggregations.add(aggregation);
        
        client.name = 'REBELLO';
        client.aggregation = aggregations;
        
        clients.add(client);
        
        client = new ApplicationExposureFacilities_Resp_IB_v1.cls_Client();
        aggregations = new List<ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation>();
        
        aggregation = new ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation();
        aggregation.aggregationType = 'Approved Facility';
        aggregation.total = 770.0;
        aggregations.add(aggregation);
        
        aggregation = new ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation();
        aggregation.aggregationType = 'Approved Facility Installments';
        aggregation.total = 950;
        aggregations.add(aggregation);
        
        client.name = 'Sindiso Mahl';
        client.aggregation = aggregations;
        
        clients.add(client);
        
        responseBean.client = clients;
        responseBean.statusCode = 200;
        
        return responseBean;
    }
}