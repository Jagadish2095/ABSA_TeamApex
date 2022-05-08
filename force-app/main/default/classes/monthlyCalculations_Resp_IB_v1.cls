/**
 * Response Bean for GetTriadsAggregation Service
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
public class monthlyCalculations_Resp_IB_v1 extends Base_IB {
	public String primaryClientCode;
	public list<aggregation> aggregation;
	public String name;

	public class aggregation {
		public String type;
		public Decimal total;
	}
}