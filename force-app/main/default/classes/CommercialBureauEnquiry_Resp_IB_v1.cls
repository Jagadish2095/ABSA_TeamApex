/**
 * @description       : Integration response bean class for Commercial Bureau Enquiry
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-09  Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
 **/

public class CommercialBureauEnquiry_Resp_IB_v1 extends Base_IB {
	public cls_Response Response;
	/**
	 * @description       : Integration  response  class for Commercial Bureau Enquiry
	 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
	 * Ver   Date         Author                       Modification
	 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
	 **/
	public class cls_Response {
		public cls_ApplicationDV ApplicationDV;
	}
	/**
	 * @description       : Integration  response  class for Commercial Bureau Enquiry
	 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
	 * Ver   Date         Author                       Modification
	 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
	 **/
	public class cls_ApplicationDV {
		public String APPPCCEID;
		public cls_COMM COMM;
	}
	/**
	 * @description       : Integration  response  class for Commercial Bureau Enquiry
	 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
	 * Ver   Date         Author                       Modification
	 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
	 **/
	public class cls_COMM {
		public String BURCOMMINPKIMNUMBER;
		public String BURCOMMINPBUSNAME;
		public String BURCOMMINPREGNUMBER;
		public String BURCOMMINPVATNUMBER;
		public cls_ECOMDET ECOMDET;
		public List<cls_ECOMDETJUD> ECOMDETJUD;
	}
	/**
	 * @description       : Integration  response  class for Commercial Bureau Enquiry
	 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
	 * Ver   Date         Author                       Modification
	 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
	 **/
	public class cls_ECOMDET {
		public String BURECOMCOMPDETBUSNSTARTDATE;
		public String BURECOMCOMPDETSTATUS;
		public String BURECOMDETAUDNAME;
		public String BURECOMDETAUDSTATUS;
		public String BURECOMDETAUDTYPE;
		public String BURECOMDETBANKBANKERS;
		public String BURECOMDETBANKCODE;
		public String BURECOMDETBANKCODEDESC;
		public String BURECOMDETBANKDATECODE;
		public String BURECOMOFFLINE;
		public String BURECOMONREC;
		public String BURECOMSUMLATESTBNKCDE;
		public String BURECOMDATECALLED;
		public String BURECOMSEARCHED;
		public String BURECOMCOMPDETTRADINGNAME;
		public String BURECOMCOMPDETMTHSINCEBUSSTARTDATE;
		public String BURECOMENRSUMJUDTOTL12M;
		public String BURECOMENRSUMJUDHIGHAMNT;
		public String BURECOMENRSUMJUDTOTVAL;
		public String BURECOMENRSUMJUDVALL12M;
		public String BURECOMENRSUMJUDMTHSNCHIGH;
		public String BURECOMENRSUMJUDLASTDATE;
		public String BURECOMENRSUMJUDHIGHDATE;
		public String BURECOMENRSUMJUDMTHSNCLAST;
		public String BURECOMENRSUMJUDTOTEVER;
		public String BURECOMENRSUMJUDPRESENT;
		public String BURECOMENRSUMNOTRBNDSTOTAL;
		public String BURECOMENRSUMNOTRBNDSTOTVAL;
		public String BURECOMENRSUMNOTRBNDSDATESINCEHIGHAMNT;
		public String BURECOMENRSUMNOTRBNDSMNTHSINCEHIGHAMNT;
		public String BURECOMENRSUMNOTRBNDSDATEMRECHIGHAMNT;
		public String BURECOMENRSUMNOTRBNDSMNTHMRECHIGHAMNT;
		public String BURECOMENRSUMNBONDPRESENT;
		public String BURECOMDETKISAMNTOUTSTCURR;
		public String BURECOMDETKISAMNTOUTST30D;
		public String BURECOMDETKISAMNTOUTST60D;
		public String BURECOMDETKISAMNTOUTST90D;
		public String BURECOMDETKISAMNTOUTST120D;
		public String BURECOMDETKISAMNTOUTST150D;
		public String BURECOMDETKISTOTODAMNT;
		public String BURECOMDETKISTRANSACTPERIOD;
		public String BURECOMDETKISNODEBTORS;
		public String BURECOMDETKISNOOVERDUE;
		public String BURECOMDETKISTOTPERCENTAGE;
		public String BURECOMENRKISTOTWITHINTERMS;
		public String BURECOMDETBANKDATELASTRD;
		public String BURECOMDETBANKAMNTLASTRD;
		public String BURECOMDETBANKACCDATE;
		public String BURECOMDETBANKMNTHSINCELASTRD;
		public String BURECOMSUMNORDS;
	}
	/**
	 * @description       : Integration  response  class for Commercial Bureau Enquiry
	 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
	 * Ver   Date         Author                       Modification
	 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
	 **/
	public class cls_ECOMDETJUD {
		public String BURECOMDETJUDPLAINTIFF;
		public String BURECOMDETJUDCASENUMBER;
		public String BURECOMDETJUDAMOUNT;
		public String BURECOMDETJUDDATE;
		public String BURECOMDETJUDCOURT;
	}

	/**
	 * @description Integration dummy response  class for Commercial Bureau Enquiry
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-09
	 * @return String
	 **/
	public static String getStringDummyResponse() {
		String response = '{"Response":{"ApplicationDV":{"APPPCCEID":"000000406946","COMM":{"BURCOMMINPKIMNUMBER":"TheString","BURCOMMINPBUSNAME":"Business Name",';
		response += '"BURCOMMINPREGNUMBER":"Id Reg Num","BURCOMMINPVATNUMBER":"TheString","ECOMDET":{"BURECOMDATECALLED":"1992-08-27","BURECOMOFFLINE":"TheString",';
		response += '"BURECOMONREC":"TheString","BURECOMSEARCHED":"TheString","BURECOMCOMPDETBUSNSTARTDATE":"TheString","BURECOMCOMPDETTRADINGNAME":"TheString",';
		response += '"BURECOMCOMPDETSTATUS":"TheString","BURECOMCOMPDETMTHSINCEBUSSTARTDATE":"TheString","BURECOMENRSUMJUDTOTL12M":"TheString",';
		response += '"BURECOMENRSUMJUDHIGHAMNT":"TheString","BURECOMENRSUMJUDTOTVAL":"TheString","BURECOMENRSUMJUDVALL12M":"TheString",';
		response += '"BURECOMENRSUMJUDMTHSNCHIGH":"TheString","BURECOMENRSUMJUDLASTDATE":"TheString","BURECOMENRSUMJUDHIGHDATE":"TheString",';
		response += '"BURECOMENRSUMJUDMTHSNCLAST":"TheString","BURECOMENRSUMJUDTOTEVER":"TheString","BURECOMENRSUMJUDPRESENT":"TheString",';
		response += '"BURECOMENRSUMNOTRBNDSTOTAL":"TheString","BURECOMENRSUMNOTRBNDSTOTVAL":"TheString","BURECOMENRSUMNOTRBNDSDATESINCEHIGHAMNT":"TheString",';
		response += '"BURECOMENRSUMNOTRBNDSMNTHSINCEHIGHAMNT":"TheString","BURECOMENRSUMNOTRBNDSDATEMRECHIGHAMNT":"TheString",';
		response += '"BURECOMENRSUMNOTRBNDSMNTHMRECHIGHAMNT":"TheString","BURECOMENRSUMNBONDPRESENT":"TheString","BURECOMDETKISAMNTOUTSTCURR":"TheString",';
		response += '"BURECOMDETKISAMNTOUTST30D":"TheString","BURECOMDETKISAMNTOUTST60D":"TheString","BURECOMDETKISAMNTOUTST90D":"TheString",';
		response += '"BURECOMDETKISAMNTOUTST120D":"TheString","BURECOMDETKISAMNTOUTST150D":"TheString","BURECOMDETKISTOTODAMNT":"TheString",';
		response += '"BURECOMDETKISTRANSACTPERIOD":"TheString","BURECOMDETKISNODEBTORS":"TheString","BURECOMDETKISNOOVERDUE":"TheString",';
		response += '"BURECOMDETKISTOTPERCENTAGE":"TheString","BURECOMENRKISTOTWITHINTERMS":"TheString","BURECOMDETBANKBANKERS":"TheString",';
		response += '"BURECOMDETBANKCODE":"TheString","BURECOMDETBANKCODEDESC":"TheString","BURECOMDETBANKDATECODE":"TheString","BURECOMDETBANKDATELASTRD":"TheString",';
		response += '"BURECOMDETBANKAMNTLASTRD":"TheString","BURECOMDETBANKACCDATE":"TheString","BURECOMDETBANKMNTHSINCELASTRD":"TheString","BURECOMDETAUDNAME":"TheString",';
		response += '"BURECOMDETAUDTYPE":"TheString","BURECOMDETAUDSTATUS":"TheString","BURECOMSUMNORDS":"TheString","BURECOMSUMLATESTBNKCDE":"TheString"},';
		response += '"ECOMDETJUD":[{"BURECOMDETJUDPLAINTIFF":"TheString","BURECOMDETJUDCASENUMBER":"TheString","BURECOMDETJUDAMOUNT":"TheString",';
		response += '"BURECOMDETJUDDATE":"TheString","BURECOMDETJUDCOURT":"TheString"},{"BURECOMDETJUDPLAINTIFF":"TheString","BURECOMDETJUDCASENUMBER":"TheString",';
		response += '"BURECOMDETJUDAMOUNT":"TheString","BURECOMDETJUDDATE":"TheString","BURECOMDETJUDCOURT":"TheString"}]}}}}';

		return response;
	}
}