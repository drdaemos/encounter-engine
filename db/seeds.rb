admin = User.new ({
    :nickname => "admin",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :email => "admin@example.com",
    :password => "123456",
    :sign_in_count => 0,
    :access_level => [:admin]
})

admin.save!

writer = User.new ({
    :nickname => "org1",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :email => "org@example.com",
    :password => "123456",
    :sign_in_count => 0,
    :access_level => [:organizer]
})

writer.save!

player = User.new ({
    :nickname => "player1",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :email => "player1@example.com",
    :password => "123456",
    :sign_in_count => 0,
    :access_level => [:player]
})

player.save!

team = Team.new ({
    :name => "Тестовая команда",
    :captain => player,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
})

team.save!

admin_team = Team.new ({
    :name => "Администрация",
    :captain => admin,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
})

admin_team.save!

game = Game.new ({
    :name => "Тестовая игра",
    :description => "<p>Анонс тестовой игры</p>",
    :author => writer,
    :max_team_number => 10,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :starts_at => "2018-10-11 18:00:00.000000",
    :finished_at => "2018-10-12 18:00:00.000000",
})

level = Level.new ({
    :game => game,
    :text => "<p>Робин-Бобин Барабек скушал сорок человек. Робин-Бобин кое-как подкрепился натощак</p>",
    :name => "Интро",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 0
})

game.save!
level.save!

# Default settings

sitename = Setting.new ({
    :key => 'site_name',
    :label => 'Название сайта',
    :value => 'Автоквест Ульяновск'
})

sitename.save!