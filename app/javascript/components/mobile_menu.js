import 'jquery.mmenu'
import 'jquery.mmenu/dist/jquery.mmenu.all.css'
import 'hamburgers/dist/hamburgers.css'

document.addEventListener('DOMContentLoaded', () => {
  let menuTitle = $("#mobile-menu").data('title') || 'Меню';
  !function(n){var e="mmenu";n[e].i18n({Menu:menuTitle})}(jQuery);
  !function(e){var n="mmenu";e[n].i18n({"Close menu":"Закрыть меню","Close submenu":"Закрыть подменю","Open submenu":"Открыть подменю","Toggle submenu":"Переключить подменю"})}(jQuery);
  !function(e){var n="mmenu";e[n].i18n({Search:"Поиск","No results found.":"Не найдено.",cancel:"Отменить"})}(jQuery);

  let $menu = $("#mobile-menu").mmenu({
    "slidingSubmenus": false,
    "extensions": [
      "pagedim-black",
      "position-right",
      "theme-dark"
    ]
  }, {
    // configuration
    offCanvas: {
      pageSelector: "#encounter-app"
    }
  });

  let $icon = $("#mobile-menu-toggle");
  let API = $menu.data( "mmenu" );

  $icon.on( "click", function() {
    API.open();
  });

  API.bind( "open:start", function() {
    setTimeout(function() {
      $icon.addClass( "is-active" );
    }, 0);
  });
  API.bind( "close:start", function() {
    setTimeout(function() {
      $icon.removeClass( "is-active" );
    }, 0);
  });
})