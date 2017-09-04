// Require Froala Editor js file.
import 'froala-editor/js/froala_editor.pkgd.min'

// Require Froala Editor css files.
import 'froala-editor/css/froala_editor.pkgd.min.css'
import 'font-awesome/css/font-awesome.css'
import 'froala-editor/css/froala_style.min.css'

export default class FroalaTextarea {
  constructor(element) {
    this.base = $(element);
    this.render();
  }

  options() {
    return {
      toolbarSticky: false,      
      toolbarButtons: ['fontFamily', '|', 'fontSize', '|', 'paragraphFormat', '|', 'bold', 'italic', 'underline', 'undo', 'redo', 'codeView'],
      fontFamilySelection: true,
      fontSizeSelection: true,
      paragraphFormatSelection: true
    }
  }

  render() {
    this.editor = this.base.froalaEditor(this.options());
  }
}

document.addEventListener('DOMContentLoaded', () => {
    $('[data-wysiwyg]').each(function() {
      $(this).data('controller', new FroalaTextarea(this));
    });
})