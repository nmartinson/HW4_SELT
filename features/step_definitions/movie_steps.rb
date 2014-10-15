# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    expect(page).to have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these
When /^I have sorted the movies by title$/ do
  click_link('title_header')
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |movie1, movie2|
  if /#{movie1}.*#{movie2}/m =~ page.body
    assert true
  elsif
    assert false
  end
end

When /^I have sorted the movies by date$/ do
  click_link('release_date_header')
end

# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
  if(!Movie.exists? movie)
    Movie.create movie
  end
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # You should arrange to add that movie to the database here.
    # You can add the entries directly to the databasse with ActiveRecord methodsQ
  end
#  flunk "Unimplemented"
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  uncheck('ratings_G')
  uncheck('ratings_PG')
  uncheck('ratings_R')
  uncheck('ratings_PG-13')

  @allRatings = arg1.split(/, \s*/).each do |rating|
    checkBox = "ratings_#{rating}"
    check("#{checkBox}")
  end
  click_button('Refresh')
  
  #flunk "Unimplemented"
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
  row = 0

  arg1.split(/, \s*/).each do |rating|
    row += Movie.where(:rating => rating).count 
  end

  row.should == all('tr').count - 1
  #flunk "Unimplemented" 
end

Then /^I should see all of the movies$/ do
  check('ratings_G')
  check('ratings_PG')
  check('ratings_R')
  check('ratings_PG-13')
  click_button('Refresh')

  row = Movie.all.count
  row.should == all('tr').count - 1
    
#flunk "Unimplemented"
end



