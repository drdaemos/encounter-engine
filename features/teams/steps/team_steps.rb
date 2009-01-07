Given %r{зарегистрирована команда "(.*)" под руководством "([^/\s]+)/(\S+)"}i do |team_name, user_email, user_password|
  Допустим %{я залогинен как "#{user_email}/#{user_password}"}
  Если %{я пытаюсь создать команду "#{team_name}"}
  То %{должен быть перенаправлен в личный кабинет}
  И %{там должен увидеть "Вы - капитан команды #{team_name}"}
end

When %r{пытаюсь создать команду "(.*)"}i do |team_name|
  Если %{захожу в личный кабинет}
  И %{я иду по ссылке "Создать команду"}
  И %{ввожу "#{team_name}" в поле "Название"}
  И %{нажимаю "Создать команду"}
end