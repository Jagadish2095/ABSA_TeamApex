/**
 * @description       : Test class for GetBalanceSheet Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/


@IsTest
public class GetBalanceSheet_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '[{"client_name":"MR JH BRINK","cif_no":"BRINKJH060","clientid_no":"6908115218081","client_currency":"R","id":2,"financialcustomerid":3288,"financialstatementdate":"2017-04-28","fixedpropertiesandimprovements_ownervaluation":1200000,"fixedpropertiesandimprovements_branchvaluation":950000,"fixedpropertiesandimprovements_creditvaluation":0,"sharesinprivatecompanyorccinterest_ownervalution":0,"sharesinprivatecompanyorccinterest_branchvaluation":0,"sharesinprivatecompanyorccinterest_creditvaluation":0,"loanaccountstobusiness_ownervaluation":0,"loanaccountstobusiness_branchvaluation":0,"loanaccountstobusiness_creditvaluation":0,"localfinancialinstrumentslisted_ownervaluation":0,"localfinancialinstrumentslisted_branchvaluation":0,"localfinancialinstrumentslisted_creditvaluation":0,"cashinvestments_ownervaluation":0,"cashinvestments_branchvaluation":0,"cashinvestments_creditvaluation":0,"totalforeignassets_ownervaluation":0,"totalforeignassets_branchvaluation":0,"totalforeignassets_creditvaluation":0,"netcapitalofbusiness_ownervaluation":0,"netcapitalofbusiness_branchvaluation":0,"netcapitalofbusiness_creditvaluation":0,"equipmentmachineryimplements_ownervaluation":0,"equipmentmachineryimplements_branchvaluation":0,"equipmentmachineryimplements_creditvaluation":0,"motorvehiclescaravansboats_ownervaluation":201058,"motorvehiclescaravansboats_branchvaluation":100529,"motorvehiclescaravansboats_creditvaluation":0,"debtors_ownervaluation":0,"debtors_branchvaluation":0,"debtors_creditvaluation":0,"stock_ownervaluation":0,"stock_branchvaluation":0,"stock_creditvaluation":0,"livestock_ownervaluation":0,"livestock_branchvaluation":0,"livestock_creditvaluation":0,"cashonhand_ownervaluation":0,"cashonhand_branchvaluation":0,"cashonhand_creditvaluation":0,"personaleffects_ownervaluation":763466,"personaleffects_branchvaluation":0,"personaleffects_creditvaluation":0,"otherassets_ownervaluation":0,"otherassets_branchvaluation":0,"otherassets_creditvaluation":0,"shareholdersequity_historical":0,"shareholdersequity_current":0,"shareholdersequity_currentadjusted":0,"totalforeignliabilities_historical":0,"totalforeignliabilities_current":0,"totalforeignliabilities_currentadjusted":0,"mortgagebonds_historical":362488,"mortgagebonds_current":362488,"mortgagebonds_currentadjusted":0,"loanaccounts_historical":48787,"loanaccounts_current":48787,"loanaccounts_currentadjusted":0,"bankoverdraft_historical":30000,"bankoverdraft_current":30000,"bankoverdraft_currentadjusted":0,"creditcards_historical":42000,"creditcards_current":42000,"creditcards_currentadjusted":0,"creditors_historical":0,"creditors_current":0,"creditors_currentadjusted":0,"otherliabilities_historical":56426,"otherliabilities_current":56426,"otherliabilities_currentadjusted":0,"fixedpropertiesbonded_historical":465000,"fixedpropertiesbonded_current":465000,"fixedpropertiesbonded_currentadjusted":0,"fixedpropertiesunbonded_historical":0,"fixedpropertiesunbonded_current":0,"fixedpropertiesunbonded_currentadjusted":0,"fixedpropertiesinformal_historical":0,"fixedpropertiesinformal_current":0,"fixedpropertiesinformal_currentadjusted":0,"totalbondregistered_historical":465000,"totalbondregistered_current":465000,"totalbondregistered_currentadjusted":0,"notarialbondamount_historical":0,"notarialbondamount_current":0,"notarialbondamount_currentadjusted":0,"isdeedsofficesearchavailable":false,"dateofdeedsofficesearch":1493371886933,"isoutcomepositive":false,"totalassets_ownervaluation":2164524,"totalassets_branchvaluation":1050529,"totalassets_creditvaluation":0,"totalliabilities_historical":539701,"totalliabilities_current":539701,"totalliabilities_currentadjusted":0,"networth_historical":1624823,"networth_current":510828,"networth_currentadjusted":0,"totalpropertiesbonddetails_historical":465000,"totalpropertiesbonddetails_current":465000,"totalpropertiesbonddetails_currentadjusted":0,"modifydate":1493371886980,"isactive":true,"accountnumber":null,"ownersnetworth_current":null}]';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetBalanceSheet_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        balSheetTestMock();

        Test.startTest();

        GetBalanceSheet_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    /**
    * @description : Method to create the test mock
    * @author Englarmerdge Mongwe | 2021-06-15 
    **/
    public static void balSheetTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static GetBalanceSheet_Resp_IB_v1 callHandlerMethod() {
        GetBalanceSheet_Req_IB_v1 dummyBean = GetBalanceSheet_Req_IB_v1.createDummyRequest();
        GetBalanceSheet_Resp_IB_v1 responseBean = GetBalanceSheet_IH_v1.getBalanceSheet(dummyBean.client_code);
        GetBalanceSheet_IU_v1.mapRequestFields(dummyBean.client_code);
        return responseBean;
    }
}