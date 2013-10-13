module PrintHelper
  def choose_printer
    @print.printer.presence || flash[:printer].presence
  end
  
  def default_printers
    $printers
  end
end
