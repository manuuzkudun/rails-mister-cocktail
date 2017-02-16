# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

cocktails = JSON.parse(open("http://www.thecocktaildb.com/api/json/v1/1/search.php?s=rum").read)

cocktails["drinks"].each do |cocktail_data|
  cocktail = Cocktail.create(name: cocktail_data["strDrink"])
  cocktail_data.each do |key, value|
    if key =~ /strIngredient/ && !value.nil? && !value.chomp.strip.empty?
      ingredient_name = value.chomp.strip
      ingredient = nil
      if Ingredient.exists?(name: ingredient_name)
        ingredient = Ingredient.find_by_name(ingredient_name)
      else
        ingredient = Ingredient.create(name: ingredient_name)
      end
      dose_key = key.sub(/strIngredient/, "strMeasure")
      dose = Dose.new(description: cocktail_data[dose_key].chomp.strip)
      dose.ingredient = ingredient
      dose.cocktail = cocktail
      dose.save
    end
  end
end




