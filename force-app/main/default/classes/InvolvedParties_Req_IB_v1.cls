/**
 * @description Request Integration Bean for InvolvedPartiesv1 Service
 * @author Humbelani Denge
 * @created 2021-06-16
 */
public class InvolvedParties_Req_IB_v1 extends Base_IB {
	/**
	 * @description Type_cls Child class
	 */
	public class Type_cls {
		public String code;
		public String description;
	}
	/**
	 * @description Content Child class
	 */
	public class Content {
		public List<Flags> flags;
	}
	/**
	 * @description Category Child class
	 */
	public class Category {
		public String code;
		public String description;
	}

	public Content content;
	/**
	 * @description Flags Child class
	 */
	public class Flags {
		public String effectiveDate;
		public Type_cls type;
		public String status;
		public Category category;
	}
	/**
	 * @description createDummyRequest method
	 * @return InvolvedParties_Req_IB_v1
	 */
	public static InvolvedParties_Req_IB_v1 createDummyRequest() {
		InvolvedParties_Req_IB_v1 requestBean = new InvolvedParties_Req_IB_v1();
		requestBean.content = new InvolvedParties_Req_IB_v1.Content();
		requestBean.content.flags = new List<InvolvedParties_Req_IB_v1.Flags>();

		InvolvedParties_Req_IB_v1.Flags flag = new InvolvedParties_Req_IB_v1.Flags();
		flag.type = new InvolvedParties_Req_IB_v1.Type_cls();
		flag.category = new InvolvedParties_Req_IB_v1.Category();
		flag.effectiveDate = '2021-05-11';
		flag.type.code = 'Access Request';
		flag.type.description = 'Access Request';
		flag.status = 'Yes';
		flag.category.code = 'Data Subject Rights';
		flag.category.description = 'Data Subject Rights';
		requestBean.content.flags.add(flag);
		return requestBean;
	}

	/**
	 * @description setFieldNameSubstitutions method
	 */
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('Type', 'Type_cls');
	}
	/**
	 * @description setIntegrationTranslations method
	 */
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('content.flags.type.code', 'C1V;Data Privacy Flag');
		integrationTranslationsMap.put('content.flags.type.description', 'C1V;Data Privacy Flag');
	}
}