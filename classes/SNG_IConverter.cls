/**
 * This is an interface used to convert a string parameter using any conversion
 * required. The result is a String.
 */
public interface SNG_IConverter {

	/**
	 * Converts a singular parameter.
	 *
	 * @param     parameter            The parameter to convert.
	 * @return                         The converted parameter.
	 */
	String convert(String parameter); 

	/**
	 * Converts a list of parameters.
	 *
	 * @param     parameters            The parameters to convert.
	 * @return                          The list of converted parameters.
	 */
	List<String> convert(List<String> parameters);
}