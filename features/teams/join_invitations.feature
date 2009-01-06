Функционал: Приглашение в команду
    Чтобы пополнить команду новыми членами
    Капитан может пригласить других пользователей к себе в команду

Сценарий: Капитан приглашает в команду нового члена
    Допустим зарегестрирован пользователь "alisa@diesel.kg/pass"
    Но я залогинен как "noel@grib.kg/pass"
    И у меня есть команда "Mushrooms"
    Если я иду на страницу "Моя команда"
    И ввожу "alisa@diesel.kg" в поле "Пригласить нового участника"
    И нажимаю "Пригласить"
    То должен увидеть "Пользователю alisa@diesel.kg выслано приглашение"

Сценарий: Пользователю приходит приглашение в команду
    Допустим зарегистрирован пользователь "alisa@diesel.kg/pass"
    И зарегистрирована команда "Mushrooms" под руководством noel@grib.kg
    Если noel@grib.kg высылает мне приглашение вступить в команду
    То письмо с текстом "Вас приглашают вступить в команду Mushrooms" должно быть выслано на "alisa@diesel.kg"
    Если я логинюсь как "alisa@diesel.kg/pass"
    То должен увидеть "Вас пригласили в команду Mushrooms"
    И должен увидеть "Принять"
    И должен увидеть "Отказаться"

Сценарий: Пользователь принимает приглашение

Сценарий: пользователь отвергает приглашение
