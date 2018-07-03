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
    :text => "<p>КОД: start. Не учитывается в статистике. Робин-Бобин Барабек скушал сорок человек. Робин-Бобин кое-как подкрепился натощак</p>",
    :name => "Интро",
    :time_limit => 300,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 1,
    :is_used_in_stats => false
})

multiple_codes_level = Level.create! ({
    :game => game,
    :text => "<p>КОДЫ: aq01, (aq02, aq02+). Нужен хотя бы один. Добрый доктор Айболит! Он под деревом сидит. Приходи к нему лечиться И корова, и волчица, И жучок, и червячок, И медведица!</p>",
    :name => "Несколько кодов",
    :time_limit => 3600,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 2,
    :is_all_sectors_required => false,
    :count_of_sectors_to_pass => 1
})

penalty_time_level = Level.create! ({
    :game => game,
    :text => "<p>КОДЫ: код1, ШТРАФНОЙ КОД: штраф1</p>",
    :name => "Штраф за слив и штрафной код",
    :time_limit => 60,
    :penalty_time_fail => 600,
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 3
})

finish_level = Level.create! ({
    :game => game,
    :text => "<p>КОД: finish. Только Тотошеньке, Только Кокошеньке Не подарил Крокодил Ничегошеньки.</p>",
    :name => "Финиш",
    :created_at => "2017-10-11 18:00:00.000000",
    :updated_at => "2017-10-11 18:00:00.000000",
    :position => 4
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

code3 = Question.create! ({
    :level => penalty_time_level
})

Answer.create! ({
    :level => penalty_time_level,
    :question => code3,
    :value => 'код1'
})

penalty_code1 = Question.create! ({
    :level => penalty_time_level,
    :is_counted_in_level => false,
    :penalty_time => 120
})

Answer.create! ({
    :level => penalty_time_level,
    :question => penalty_code1,
    :value => 'штраф1'
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

Setting.create! ({
    :key => 'site_from',
    :label => 'Адрес FROM',
    :value => 'autoquest@localhost'
})
