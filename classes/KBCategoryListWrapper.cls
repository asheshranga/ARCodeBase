public with sharing class KBCategoryListWrapper {
	public Map<String, KBCategoryGroupDetails> categories { get; set; }
	
	public KBCategoryListWrapper(Map<String, KBCategoryGroupDetails> categories) {
		this.categories = categories;
	}
}