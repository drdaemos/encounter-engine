user = User.new ({
    :nickname => "admin",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :email => "admin@example.com",
    :password => "123456",
    :sign_in_count => 0
})

user.save!

team = Team.new ({
    :name => "Test team",
    :captain => user,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
})

team.save!