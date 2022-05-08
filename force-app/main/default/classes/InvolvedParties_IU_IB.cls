/**
 * @description Integration Utility for InvolvedParties Service
 * @author Humbelani Denge
 * @created 2021-06-16
 */
public class InvolvedParties_IU_IB {
	/**
	 * @description utility method to map service request fields
	 * @param flags
	 * @param method
	 * @param cifKey
	 * @return InvolvedParties_Req_IB_v1
	 */
	public static InvolvedParties_Req_IB_v1 mapRequestFields(map<String, String> flags, String method, String cifKey) {
		InvolvedParties_Req_IB_v1 requestBean = new InvolvedParties_Req_IB_v1();

		requestBean.content = new InvolvedParties_Req_IB_v1.Content();
		requestBean.content.flags = new List<InvolvedParties_Req_IB_v1.Flags>();
		for (string Key : flags.keySet()) {
			InvolvedParties_Req_IB_v1.Flags flag = new InvolvedParties_Req_IB_v1.Flags();
			flag.type = new InvolvedParties_Req_IB_v1.Type_cls();
			flag.category = new InvolvedParties_Req_IB_v1.Category();
			flag.effectiveDate = method.equalsIgnoreCase('create') ? Datetime.now().format('yyyy-MM-dd') : '';
			flag.type.code = Key;
			flag.type.description = Key;
			flag.status = flags.get(key);
			flag.category.code = 'Data Subject Rights';
			flag.category.description = 'Data Subject Rights';
			requestBean.content.flags.add(flag);
		}

		return requestBean;
	}
}