// Require Froala Editor js file.
import 'froala-editor/js/froala_editor.pkgd.min'
import 'froala-editor/js/languages/ru'

// Require Froala Editor css files.
import 'froala-editor/css/froala_editor.pkgd.min.css'
import 'font-awesome/css/font-awesome.css'
import 'froala-editor/css/froala_style.min.css'

export default class FroalaTextarea {
  constructor (element,) {
    this.base = $(element)
    this.render()
    this.stripMessage()
  }

  options () {
    return {
      language: 'ru',
      theme: "custom",
      toolbarSticky: false,
      toolbarButtons: ['fontSize', 'paragraphFormat', 'align', 'color', '|', 'insertTable', '|', 'insertImage', 'insertLink', 'insertVideo', '|', 'bold', 'italic', 'underline', 'html'],
      toolbarButtonsSM: ['fontSize', 'paragraphFormat', 'align', 'color', '|', 'insertTable', '|', 'insertImage', 'insertLink', 'insertVideo', '|', 'bold', 'italic', 'underline'],
      toolbarButtonsXS: ['fontSize', 'align', 'color', '|', 'insertImage', 'insertLink', 'insertVideo', '|', 'bold', 'italic', 'underline'],
      fontFamilySelection: true,
      fontSizeSelection: true,
      paragraphFormatSelection: true,
      imageInsertButtons: ['imageUpload', 'imageByURL'],
      // Set the image upload parameter.
      imageUploadParam: 'image',
      // Set the image upload URL.
      imageUploadURL: '/upload/image',
      // Additional upload params.
      imageUploadParams: {
        [document.querySelector("meta[name='csrf-param']").getAttribute("content")]: document.querySelector("meta[name='csrf-token']").getAttribute("content")
      },
      // Set request type.
      imageUploadMethod: 'POST',
      // Set max image size to 5MB.
      imageMaxSize: 5 * 1024 * 1024,
      // Allow to upload PNG and JPG.
      imageAllowedTypes: ['jpeg', 'jpg', 'png']
    }
  }

  render () {
    this.editor = this.base.froalaEditor(this.options())
  }

  stripMessage () {
    document.querySelector('a[href="https://www.froala.com/wysiwyg-editor?k=u"]').parentElement.remove();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  $('[data-wysiwyg]').each(function () {
    $(this).data('controller', new FroalaTextarea(this))
  })
})