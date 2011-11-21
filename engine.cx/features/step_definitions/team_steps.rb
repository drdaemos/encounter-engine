# -*- coding: utf-8 -*-

Given %r{зарегистрирована команда "(.*)" под руководством (.*)}i do |team_name, nickname|
  steps %Q{
    Given я залогинен как #{nickname}
    When я пытаюсь создать команду "#{team_name}"
    Then должен быть перенаправлен в личный кабинет
    And должен увидеть "Вы - капитан команды"
    And должен увидеть "#{team_name}"
  }
end

When %r{пытаюсь создать команду "(.*)"}i do |team_name|
  step %{захожу в личный кабинет}
  step %{я иду по ссылке "Создать команду"}
  step %{ввожу "#{team_name}" в поле "Название"}
  step %{нажимаю "Создать команду"}
end

Given %r{пользователь (.*) состоит в команде "(.*)"}i do |nickname, team_name|
  captain_nickname = Team.find_by_name(team_name).captain.nickname

  step %{зарегистрирован пользователь #{nickname}}
  step %{я логинюсь как #{captain_nickname}}
  step %{высылаю пользователю #{nickname} приглашение вступить в команду}
  step %{я логинюсь как #{nickname}}
  step %{я иду по ссылке "(принять)"}
  step %{должен быть перенаправлен в личный кабинет}
  step %{должен увидеть "Вы состоите в команде"}
  step %{должен увидеть "#{team_name}"}
end

Given %r{пользователь (.*) создает команду "(.*)"}i do |user_name, team_name|
  step %{я логинюсь как #{user_name}}
  step %{я пытаюсь создать команду "#{team_name}"}
  step %{должен быть перенаправлен в личный кабинет}
  step %{там должен увидеть "Вы - капитан команды"}
  step %{должен увидеть "#{team_name}"}
end
