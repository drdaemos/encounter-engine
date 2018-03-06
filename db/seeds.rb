admin = User.create! ({
    :nickname => "admin1",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :email => "admin1@example.com",
    :password => "123456",
    :sign_in_count => 0,
    :access_level => [:admin]
})

writer = User.create! ({
    :nickname => "org1",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :email => "org1@example.com",
    :password => "123456",
    :sign_in_count => 0,
    :access_level => [:organizer]
})

player = User.create! ({
    :nickname => "player1",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :email => "player1@example.com",
    :password => "123456",
    :sign_in_count => 0,
    :access_level => [:player]
})

team = Team.create! ({
    :name => "Тестовая команда",
    :captain => player,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
})

admin_team = Team.create! ({
    :name => "Администрация",
    :captain => admin,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
})

game = Game.create! ({
    :name => "Тестовая игра",
    :description => "<p>Анонс тестовой игры</p>",
    :author => writer,
    :max_team_number => 10,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :starts_at => "2018-10-11 18:00:00.000000",
    :finished_at => "2018-10-12 18:00:00.000000",
})

intro_level = Level.create! ({
    :game => game,
    :text => "<p>КОД: start. Робин-Бобин Барабек скушал сорок человек. Робин-Бобин кое-как подкрепился натощак</p>",
    :name => "Интро",
    :time_limit => 5,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 1
})

multiple_codes_level = Level.create! ({
    :game => game,
    :text => "<p>КОДЫ: aq01, (aq02, aq02+). Добрый доктор Айболит! Он под деревом сидит. Приходи к нему лечиться И корова, и волчица, И жучок, и червячок, И медведица!</p>",
    :name => "С ограничением по времени",
    :time_limit => 60,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 2
})

finish_level = Level.create! ({
    :game => game,
    :text => "<p>КОД: finish. Только Тотошеньке, Только Кокошеньке Не подарил Крокодил Ничегошеньки.</p>",
    :name => "Финиш",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 3
})

intro = Question.create! ({
    :level => intro_level
})

Answer.create! ({
    :level => intro_level,
    :question => intro,
    :value => 'start'
})

code1 = Question.create! ({
    :level => multiple_codes_level
})

Answer.create! ({
    :level => multiple_codes_level,
    :question => code1,
    :value => 'aq01'
})

code2 = Question.create! ({
    :level => multiple_codes_level
})

Answer.create! ({
    :level => multiple_codes_level,
    :question => code2,
    :value => 'aq02'
})

Answer.create! ({
    :level => multiple_codes_level,
    :question => code2,
    :value => 'aq02+'
})

finish = Question.create! ({
    :level => finish_level
})

Answer.create! ({
    :level => finish_level,
    :question => finish,
    :value => 'finish'
})


# Default settings

Setting.create! ({
    :key => 'site_name',
    :label => 'Название сайта',
    :value => 'Автоквест Ульяновск'
})
