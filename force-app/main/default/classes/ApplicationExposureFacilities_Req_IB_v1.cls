/**
 * @description       : Integration request class for Application Exposure Facilities
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

public class ApplicationExposureFacilities_Req_IB_v1 extends Base_IB {

    public cls_Client[] client;
    /**
 * @description       : Inner class with params
 * @author            : Ephetehe Mokgopanyane
 **/
    public class cls_Client{
        public String name;
        public cls_Facility facility;
        public cls_InstalmentFacility installmentfacility;
    }
    /**
 * @description       : Inner class with params
 * @author            : Ephetehe Mokgopanyane
 **/
    public class cls_Facility{
        public Decimal settlementLimitsApproved;
        public Decimal ordinaryCreditBusinessBank;
        public Decimal ordinaryCreditRetail;
        public Decimal assetFinanceBusinessBank;
        public Decimal assetFinanceRetail;
        public Decimal mortgageBusinessBank;
        public Decimal mortgageRetail;
    }
    /**
 * @description       : Inner class with params
 * @author            : Ephetehe Mokgopanyane
 **/
    public class cls_InstalmentFacility{
        public Decimal settlementLimitsApproved;
        public Decimal ordinaryCreditBusinessBank;
        public Decimal ordinaryCreditRetail;
        public Decimal assetFinanceBusinessBank;
        public Decimal assetFinanceRetail;
        public Decimal mortgageBusinessBank;
        public Decimal mortgageRetail;
    }

    /**
    * @description : Method to create dummy request
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @return ApplicationExposureFacilities_Req_IB_v1 
    **/
    public static ApplicationExposureFacilities_Req_IB_v1 createDummyRequest() {
        List<ApplicationExposureFacilities_Req_IB_v1.cls_Client> clients = new List<ApplicationExposureFacilities_Req_IB_v1.cls_Client>();
        
        ApplicationExposureFacilities_Req_IB_v1.cls_Client client = new ApplicationExposureFacilities_Req_IB_v1.cls_Client();
        
        ApplicationExposureFacilities_Req_IB_v1.cls_Facility facility = new ApplicationExposureFacilities_Req_IB_v1.cls_Facility();
        facility.assetFinanceBusinessBank = 100;
        facility.assetFinanceRetail = 100;
        facility.mortgageBusinessBank = 100;
        facility.mortgageRetail = 100;
        facility.ordinaryCreditBusinessBank = 100;
        facility.ordinaryCreditRetail = 100;
        facility.settlementLimitsApproved = 100;
        
        client.facility = facility;
        
        ApplicationExposureFacilities_Req_IB_v1.cls_InstalmentFacility installmentFac = new ApplicationExposureFacilities_Req_IB_v1.cls_InstalmentFacility();
        installmentFac.assetFinanceBusinessBank = 100;
        installmentFac.assetFinanceRetail = 100;
        installmentFac.mortgageBusinessBank = 100;
        installmentFac.mortgageRetail = 100;
        installmentFac.ordinaryCreditBusinessBank = 100;
        installmentFac.ordinaryCreditRetail = 100;
        installmentFac.settlementLimitsApproved = 100;
        
        client.installmentfacility = installmentFac;
        
        client.name = 'Rebello';
        clients.add(client);
        
        ApplicationExposureFacilities_Req_IB_v1 bean = new ApplicationExposureFacilities_Req_IB_v1();
        bean.client = clients;

        return bean;
    }
}