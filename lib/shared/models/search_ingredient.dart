class SearchIngredient {
  final String id;
  final String name;

  SearchIngredient(this.id, this.name);

  SearchIngredient copy() {
    return SearchIngredient(id, name);
  }
}
