/**
 * An interface to abstract answer set generators.
 * @author Masimba Chingwende
 */
public interface HotDocsAnswerSetGenerator {
	
	String generate();
	void setContext(Map<String, Object> context);
	void setAnswers(String answers);	

}