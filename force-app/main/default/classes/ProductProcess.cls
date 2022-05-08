/**
 * @description       :
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class ProductProcess {
	/**
	 * @description       : List of processes
	 **/
	public class ProcessList {
		List<ProcessDetails> processDetails;
	}
	/**
	 * @description       : ProcessDetails
	 **/
	public class ProcessDetails {
		public string name;
		public string flow;
		public string onboardingMode;
        public string productAccountNumber;
		public string productFamily;
		public string productSelectorMode;
		public string requestName;
		public string caseId;
		public ProcessType ProcessType;
	}
	/**
	 * @description       : ProcessType
	 **/
	public enum ProcessType {
		Sales,
		Enquiry,
		Maintenance,
		CustomerMaintenance
	}
}