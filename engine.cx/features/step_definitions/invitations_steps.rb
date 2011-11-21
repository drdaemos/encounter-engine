# -*- coding: utf-8 -*-

When %r{высылаю пользователю (.*) приглашение вступить в команду}i do |recepient_name|
  step %{я захожу в комнату команды}
  step %{иду по ссылке "Пригласить участников"}
  step %{ввожу "#{recepient_name}" в поле "Пригласить нового участника"}
  step %{нажимаю "Пригласить"}
  step %{должен увидеть "Пользователю #{recepient_name} выслано приглашение"}
end

Then %r{пользователь (.*) должен получить приглашение от команды (.*)}i do |nickname, team_name|
  user_email = User.find_by_nickname(nickname).email

  step %{я логинюсь как #{nickname}}
  step %{я захожу в личный кабинет}
  step %{должен увидеть "Вас пригласили в команду #{team_name}"}
  step %{одно письмо с текстом "Вас пригласили вступить в команду #{team_name}" должно быть выслано на #{user_email}}
end

Then %r{пользователь (.*) не должен получить приглашение}i do |nickname|
  user_email = User.find_by_nickname(nickname).email

  step %{я логинюсь как #{nickname}}
  step %{я захожу в личный кабинет}
  step %{я не должен видеть "Вас пригласили в команду"}
  step %{никакие письма не должны быть высланы на #{user_email} }
end

When %r{как пользователь (.*) принимаю приглашение команды (.*)$}i do |nickname, team_name|
  step %{я захожу в личный кабинет}
  step %{должен увидеть "Вас пригласили в команду #{team_name}"}

  user = User.find_by_nickname(nickname)
  team = Team.find_by_name(team_name)
  invitation = Invitation.for_user(user).to_team(team).first
  step %{я иду по ссылке "accept-invitation-#{invitation.id}"}
  step %{должен быть перенаправлен в личный кабинет}
end

When %r{как пользователь (.*) отказываюсь от приглашения команды (.*)$}i do |nickname, team_name|
  step %{я захожу в личный кабинет}
  step %{должен увидеть "Вас пригласили в команду #{team_name}"}

  user = User.find_by_nickname(nickname)
  team = Team.find_by_name(team_name)
  invitation = Invitation.for_user(user).to_team(team).first  

  step %{я иду по ссылке "reject-invitation-#{invitation.id}"}
  step %{должен быть перенаправлен в личный кабинет}
end
