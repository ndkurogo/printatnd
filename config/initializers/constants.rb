IMAGE_EXTENSIONS = %w(.gif .jpg .jpeg .png)
DIRECT_EXTENSIONS = %w(.pdf .eps .ps .txt) + IMAGE_EXTENSIONS
GOOGLE_EXTENSIONS = %w(.odt .ods .doc .docx .xls .xlsx .ppt .pptx .pages .ai .psd .tiff .dxf .svg .rtf)

ALL_EXTENSIONS = DIRECT_EXTENSIONS + GOOGLE_EXTENSIONS

ALL_MIMETYPES = %w(application/pdf application/postscript application/postscript text/plain image/gif image/jpeg image/png application/vnd.oasis.opendocument.text application/vnd.oasis.opendocument.spreadsheet application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation application/postscript image/x-photoshop image/tiff image/svg+xml application/rtf application/dxf application/x-autocad application/x-dxf drawing/x-dxf image/vnd.dxf image/x-autocad image/x-dxf zz-application/zz-winassoc-dxf application/x-iwork-keynote-sffkey)

