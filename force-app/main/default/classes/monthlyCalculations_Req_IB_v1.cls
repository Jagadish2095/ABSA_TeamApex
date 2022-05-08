/**
 * Request Bean for GetTriadsAggregation Service
 *
 * @author  Gopi Budaraju (ZA)
 * @version v1.0n
 * @since   2020/09/20
 * @UserStory W:006253
 *
 * @update Englarmerge Mongwe
 * @date 2021-01-07
 * Complete UserStory W:006253
 */
public class monthlyCalculations_Req_IB_v1 extends Base_IB {
	public client client;

	public class monthlyData {
		public Decimal numChequeRDEvents;
		public Decimal numSavingsRDEvents;
		public Decimal savingsRDValue;
		public Decimal numChequeDebits;
		public Decimal chequeRDValue;
		public Decimal numSavingsDebits;
		public String month;
	}

	public class client {
		public list<monthlyData> monthlyData;
		public String primaryClientCode;
		public String name;
	}

    public static monthlyCalculations_Req_IB_v1 createDummyRequest() {
        String jsonString = '{"client":{"monthlyData":[{"chequeRDValue":1,"month":"01/01/2021","numChequeDebits":1,"numChequeRDEvents":1,"numSavingsDebits":1,"numSavingsRDEvents":1,"savingsRDValue":1},{"chequeRDValue":1,"month":"31/12/2020","numChequeDebits":1,"numChequeRDEvents":1,"numSavingsDebits":1,"numSavingsRDEvents":1,"savingsRDValue":1}],"name":"SEDERKRANS BOERDERY SOUTPANSBERG BK","primaryClientCode":"SBSOUTP001"}}';
        monthlyCalculations_Req_IB_v1 requestBean = (monthlyCalculations_Req_IB_v1)JSON.deserializeStrict(jsonString, monthlyCalculations_Req_IB_v1.class);

        return requestBean;
    }
}