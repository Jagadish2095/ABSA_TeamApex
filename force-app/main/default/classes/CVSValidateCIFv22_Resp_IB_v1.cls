/*
* @author  Paul John du Randt : ABSA (IQ Business)
* @version v1.0
* @since   2020-09-18
*/

public class CVSValidateCIFv22_Resp_IB_v1 extends Base_IB 
{

public Integer statusCode;
public StatusMessage statusMessage;

public class Error 
{
	public List<String> reason;
	public String field;
}

public class StatusMessage 
{
	public List<Error> error;
}
public override void setFieldNameSubstitutions() {
	fieldNameSubstitutionMap = new Map<String, String>();
	fieldNameSubstitutionMap.put('"number":', '"z_number":');        
}
}