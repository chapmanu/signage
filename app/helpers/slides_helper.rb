module SlidesHelper
  ORGANIZER_ICONS = {
    'Department of Art' => 'wilkinson',
    'Argyros Career Services' => 'business',
    'Argyros School of Business and Economics' => 'business',
    'Career Development Center'    => 'chapman',
    'College of Educational Studies' => 'ces',
    'Chapman University' => 'chapman',
    'Civic Engagement' => 'chapman',
    'College of Performing Arts' => 'copa',
    'Department of Dance' => 'copa',
    'Hall-Musco Conservatory of Music' => 'copa',
    'Department of Theatre' => 'copa',
    'Crean School of Health and Life Sciences' => 'chapman',
    'Cross-Cultural Engagement' => 'chapman',
    'Dodge College of Film and Media Arts' => 'dodge',
    'Julianne Argyros Fitness Center' => 'chapman',
    'Greek Life' => 'chapman',
    'Fowler School of Law' => 'law',
    'Leatherby Libraries' => 'chapman',
    'PEER' => 'chapman',
    'School of Pharmacy' => 'chapman',
    'Schmid College of Science and Technology' => 'scst',
    'Student Government Association' => 'chapman',
    'Student Affairs' => 'chapman',
    'Clubs and Organizations' => 'chapman',
    'Argyros Forum Student Union' => 'chapman',
    'University Program Board' => 'chapman',
    'Wilkinson College of Humanities and Social Sciences' => 'wilkinson',
    nil => 'chapman'
  }

  def organizer_options
    ORGANIZER_ICONS.keys.compact
  end
end
